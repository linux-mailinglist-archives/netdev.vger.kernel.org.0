Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EF642D90F
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhJNMNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhJNMNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 08:13:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9014FC06174E;
        Thu, 14 Oct 2021 05:11:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mazaH-0002nN-4u; Thu, 14 Oct 2021 14:11:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, me@ubique.spb.ru,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 9/9] netfilter: hook_jit: add prog cache
Date:   Thu, 14 Oct 2021 14:10:46 +0200
Message-Id: <20211014121046.29329-11-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014121046.29329-1-fw@strlen.de>
References: <20211014121046.29329-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows to re-use the same program.  For example, a nft
ruleset that attaches filter basechains to input, forward, output would
use the same program for all three hook points.

The cache is intentionally netns agnostic, so same config
in different netns will all use same programs.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_hook_bpf.c | 144 ++++++++++++++++++++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/net/netfilter/nf_hook_bpf.c b/net/netfilter/nf_hook_bpf.c
index cd8aba6da53b..00ac3e896f25 100644
--- a/net/netfilter/nf_hook_bpf.c
+++ b/net/netfilter/nf_hook_bpf.c
@@ -40,6 +40,24 @@ struct nf_hook_prog {
 	unsigned int pos;
 };
 
+struct nf_hook_bpf_prog {
+	struct rcu_head rcu_head;
+
+	struct hlist_node node_key;
+	struct hlist_node node_prog;
+	u32 key;
+	u16 hook_count;
+	refcount_t refcnt;
+	struct bpf_prog	*prog;
+	unsigned long hooks[64];
+};
+
+#define NF_BPF_PROG_HT_BITS	8
+
+/* users need to hold nf_hook_mutex */
+static DEFINE_HASHTABLE(nf_bpf_progs_ht_key, NF_BPF_PROG_HT_BITS);
+static DEFINE_HASHTABLE(nf_bpf_progs_ht_prog, NF_BPF_PROG_HT_BITS);
+
 static bool emit(struct nf_hook_prog *p, struct bpf_insn insn)
 {
 	if (WARN_ON_ONCE(p->pos >= BPF_MAXINSNS))
@@ -399,12 +417,106 @@ struct bpf_prog *nf_hook_bpf_create_fb(void)
 	return prog;
 }
 
+static u32 nf_hook_entries_hash(const struct nf_hook_entries *new)
+{
+	int i, hook_count = new->num_hook_entries;
+	u32 a, b, c;
+
+	a = b = c = JHASH_INITVAL + hook_count;
+	i = 0;
+	while (hook_count > 3) {
+		a += hash32_ptr(new->hooks[i+0].hook);
+		b += hash32_ptr(new->hooks[i+1].hook);
+		c += hash32_ptr(new->hooks[i+2].hook);
+		__jhash_mix(a, b, c);
+		hook_count -= 3;
+		i += 3;
+	}
+
+	switch (hook_count) {
+	case 3: c += hash32_ptr(new->hooks[i+2].hook); fallthrough;
+	case 2: b += hash32_ptr(new->hooks[i+1].hook); fallthrough;
+	case 1: a += hash32_ptr(new->hooks[i+0].hook);
+		__jhash_final(a, b, c);
+		break;
+	}
+
+	return c;
+}
+
+static struct bpf_prog *nf_hook_bpf_find_prog_by_key(const struct nf_hook_entries *new, u32 key)
+{
+	int i, hook_count = new->num_hook_entries;
+	struct nf_hook_bpf_prog *pc;
+
+	hash_for_each_possible(nf_bpf_progs_ht_key, pc, node_key, key) {
+		if (pc->hook_count != hook_count ||
+		    pc->key != key)
+			continue;
+
+		for (i = 0; i < hook_count; i++) {
+			if (pc->hooks[i] != (unsigned long)new->hooks[i].hook)
+				break;
+		}
+
+		if (i == hook_count) {
+			refcount_inc(&pc->refcnt);
+			return pc->prog;
+		}
+	}
+
+	return NULL;
+}
+
+static struct nf_hook_bpf_prog *nf_hook_bpf_find_prog(const struct bpf_prog *p)
+{
+	struct nf_hook_bpf_prog *pc;
+
+	hash_for_each_possible(nf_bpf_progs_ht_prog, pc, node_prog, (unsigned long)p) {
+		if (pc->prog == p)
+			return pc;
+	}
+
+	return NULL;
+}
+
+static void nf_hook_bpf_prog_store(const struct nf_hook_entries *new, struct bpf_prog *prog, u32 key)
+{
+	unsigned int i, hook_count = new->num_hook_entries;
+	struct nf_hook_bpf_prog *alloc;
+
+	if (hook_count >= ARRAY_SIZE(alloc->hooks))
+		return;
+
+	alloc = kzalloc(sizeof(*alloc), GFP_KERNEL);
+	if (!alloc)
+		return;
+
+	alloc->hook_count = new->num_hook_entries;
+	alloc->prog = prog;
+	alloc->key = key;
+
+	for (i = 0; i < hook_count; i++)
+		alloc->hooks[i] = (unsigned long)new->hooks[i].hook;
+
+	hash_add(nf_bpf_progs_ht_key, &alloc->node_key, key);
+	hash_add(nf_bpf_progs_ht_prog, &alloc->node_prog, (unsigned long)prog);
+	refcount_set(&alloc->refcnt, 1);
+
+	bpf_prog_inc(prog);
+}
+
 struct bpf_prog *nf_hook_bpf_create(const struct nf_hook_entries *new)
 {
+	u32 key = nf_hook_entries_hash(new);
 	struct bpf_prog *prog;
 	struct nf_hook_prog p;
 	int err;
 
+	prog = nf_hook_bpf_find_prog_by_key(new, key);
+	if (prog)
+		return prog;
+
 	err = nf_hook_prog_init(&p);
 	if (err)
 		return NULL;
@@ -414,12 +526,44 @@ struct bpf_prog *nf_hook_bpf_create(const struct nf_hook_entries *new)
 		goto err;
 
 	prog = nf_hook_jit_compile(p.insns, p.pos);
+	if (prog)
+		nf_hook_bpf_prog_store(new, prog, key);
 err:
 	nf_hook_prog_free(&p);
 	return prog;
 }
 
+static void __nf_hook_free_prog(struct rcu_head *head)
+{
+	struct nf_hook_bpf_prog *old = container_of(head, struct nf_hook_bpf_prog, rcu_head);
+
+	bpf_prog_put(old->prog);
+	kfree(old);
+}
+
+static void nf_hook_free_prog(struct nf_hook_bpf_prog *old)
+{
+	call_rcu(&old->rcu_head, __nf_hook_free_prog);
+}
+
 void nf_hook_bpf_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from, struct bpf_prog *to)
 {
+	if (from == to)
+		return;
+
+	if (from) {
+		struct nf_hook_bpf_prog *old;
+
+		old = nf_hook_bpf_find_prog(from);
+		if (old) {
+			WARN_ON_ONCE(from != old->prog);
+			if (refcount_dec_and_test(&old->refcnt)) {
+				hash_del(&old->node_key);
+				hash_del(&old->node_prog);
+				nf_hook_free_prog(old);
+			}
+		}
+	}
+
 	bpf_dispatcher_change_prog(d, from, to);
 }
-- 
2.32.0

