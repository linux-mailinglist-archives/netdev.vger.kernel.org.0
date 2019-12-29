Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5668812C2C0
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 15:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfL2OiG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 29 Dec 2019 09:38:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47789 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726798AbfL2OiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 09:38:04 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-BUO75DSvOymR2akmbqlz0A-1; Sun, 29 Dec 2019 09:38:00 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D1F21005502;
        Sun, 29 Dec 2019 14:37:59 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-25.brq.redhat.com [10.40.204.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86B405DA7D;
        Sun, 29 Dec 2019 14:37:56 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: [PATCH 5/5] bpf: Allow to resolve bpf trampoline in unwind
Date:   Sun, 29 Dec 2019 15:37:40 +0100
Message-Id: <20191229143740.29143-6-jolsa@kernel.org>
In-Reply-To: <20191229143740.29143-1-jolsa@kernel.org>
References: <20191229143740.29143-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: BUO75DSvOymR2akmbqlz0A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When unwinding the stack we need to identify each
address to successfully continue. Adding latch tree
to keep trampolines for quick lookup during the
unwind.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     |  6 ++++++
 kernel/bpf/core.c       |  2 ++
 kernel/bpf/trampoline.c | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b14e51d56a82..66825c821ac9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -470,6 +470,7 @@ struct bpf_trampoline {
 	/* Executable image of trampoline */
 	void *image;
 	u64 selector;
+	struct latch_tree_node tnode;
 };
 
 #define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
@@ -502,6 +503,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
+bool is_bpf_trampoline(void *addr);
 void *bpf_jit_alloc_exec_page(void);
 #define BPF_DISPATCHER_INIT(name) {			\
 	.mutex = __MUTEX_INITIALIZER(name.mutex),	\
@@ -555,6 +557,10 @@ static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
 static inline void bpf_dispatcher_change_prog(struct bpf_dispatcher *d,
 					      struct bpf_prog *from,
 					      struct bpf_prog *to) {}
+static inline bool is_bpf_trampoline(void *addr)
+{
+	return false;
+}
 #endif
 
 struct bpf_func_info_aux {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 29d47aae0dd1..63a515b5aa7b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -704,6 +704,8 @@ bool is_bpf_text_address(unsigned long addr)
 
 	rcu_read_lock();
 	ret = bpf_prog_kallsyms_find(addr) != NULL;
+	if (!ret)
+		ret = is_bpf_trampoline((void*) addr);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 505f4e4b31d2..4b5f0d0b0072 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -4,16 +4,44 @@
 #include <linux/bpf.h>
 #include <linux/filter.h>
 #include <linux/ftrace.h>
+#include <linux/rbtree_latch.h>
 
 /* btf_vmlinux has ~22k attachable functions. 1k htab is enough. */
 #define TRAMPOLINE_HASH_BITS 10
 #define TRAMPOLINE_TABLE_SIZE (1 << TRAMPOLINE_HASH_BITS)
 
 static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
+static struct latch_tree_root tree __cacheline_aligned;
 
 /* serializes access to trampoline_table */
 static DEFINE_MUTEX(trampoline_mutex);
 
+static __always_inline bool tree_less(struct latch_tree_node *a,
+				      struct latch_tree_node *b)
+{
+	struct bpf_trampoline *ta = container_of(a, struct bpf_trampoline, tnode);
+	struct bpf_trampoline *tb = container_of(b, struct bpf_trampoline, tnode);
+
+	return ta->image < tb->image;
+}
+
+static __always_inline int tree_comp(void *addr, struct latch_tree_node *n)
+{
+	struct bpf_trampoline *tr = container_of(n, struct bpf_trampoline, tnode);
+
+	if (addr < tr->image)
+		return -1;
+	if (addr >= tr->image + PAGE_SIZE)
+		return  1;
+
+	return 0;
+}
+
+static const struct latch_tree_ops tree_ops = {
+	.less	= tree_less,
+	.comp	= tree_comp,
+};
+
 void *bpf_jit_alloc_exec_page(void)
 {
 	void *image;
@@ -30,6 +58,11 @@ void *bpf_jit_alloc_exec_page(void)
 	return image;
 }
 
+bool is_bpf_trampoline(void *addr)
+{
+	return latch_tree_find(addr, &tree, &tree_ops) != NULL;
+}
+
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
@@ -65,6 +98,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	for (i = 0; i < BPF_TRAMP_MAX; i++)
 		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
 	tr->image = image;
+	latch_tree_insert(&tr->tnode, &tree, &tree_ops);
 out:
 	mutex_unlock(&trampoline_mutex);
 	return tr;
@@ -252,6 +286,7 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 		goto out;
 	bpf_jit_free_exec(tr->image);
 	hlist_del(&tr->hlist);
+	latch_tree_erase(&tr->tnode, &tree, &tree_ops);
 	kfree(tr);
 out:
 	mutex_unlock(&trampoline_mutex);
-- 
2.21.1

