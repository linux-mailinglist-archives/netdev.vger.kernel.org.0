Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C876D15652B
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 16:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgBHPmt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Feb 2020 10:42:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35425 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727527AbgBHPmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 10:42:49 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-nlASWSeAPqe1w0HtI1lVug-1; Sat, 08 Feb 2020 10:42:44 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B83F4800D6C;
        Sat,  8 Feb 2020 15:42:42 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-79.brq.redhat.com [10.40.204.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE9655C21B;
        Sat,  8 Feb 2020 15:42:39 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH 06/14] bpf: Add bpf_kallsyms_tree tree
Date:   Sat,  8 Feb 2020 16:42:01 +0100
Message-Id: <20200208154209.1797988-7-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-1-jolsa@kernel.org>
References: <20200208154209.1797988-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: nlASWSeAPqe1w0HtI1lVug-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_tree is used both for kallsyms iterations and searching
for exception tables of bpf programs, which is needed only for
bpf programs.

Adding bpf_kallsyms_tree that will hold symbols for all bpf_prog,
bpf_trampoline and bpf_dispatcher objects and keeping bpf_tree
only for bpf_prog objects exception tables search to keep it fast.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h |  1 +
 kernel/bpf/core.c   | 60 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index da67ca3afa2f..151d7b1c8435 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -468,6 +468,7 @@ struct bpf_ksym {
 	unsigned long		 end;
 	char			 name[KSYM_NAME_LEN];
 	struct list_head	 lnode;
+	struct latch_tree_node	 tnode;
 };
 
 enum bpf_tramp_prog_type {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index b9b7077e60f3..1daa72341450 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -606,8 +606,46 @@ static const struct latch_tree_ops bpf_tree_ops = {
 	.comp	= bpf_tree_comp,
 };
 
+static __always_inline unsigned long
+bpf_get_ksym_start(struct latch_tree_node *n)
+{
+	const struct bpf_ksym *ksym;
+
+	ksym = container_of(n, struct bpf_ksym, tnode);
+	return ksym->start;
+}
+
+static __always_inline bool
+bpf_ksym_tree_less(struct latch_tree_node *a,
+		   struct latch_tree_node *b)
+{
+	return bpf_get_ksym_start(a) < bpf_get_ksym_start(b);
+}
+
+static __always_inline int
+bpf_ksym_tree_comp(void *key, struct latch_tree_node *n)
+{
+	unsigned long val = (unsigned long)key;
+	const struct bpf_ksym *ksym;
+
+	ksym = container_of(n, struct bpf_ksym, tnode);
+
+	if (val < ksym->start)
+		return -1;
+	if (val >= ksym->end)
+		return  1;
+
+	return 0;
+}
+
+static const struct latch_tree_ops bpf_kallsyms_tree_ops = {
+	.less	= bpf_ksym_tree_less,
+	.comp	= bpf_ksym_tree_comp,
+};
+
 static DEFINE_SPINLOCK(bpf_lock);
 static LIST_HEAD(bpf_kallsyms);
+static struct latch_tree_root bpf_kallsyms_tree __cacheline_aligned;
 static struct latch_tree_root bpf_tree __cacheline_aligned;
 
 static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
@@ -615,6 +653,7 @@ static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
 	WARN_ON_ONCE(!list_empty(&aux->ksym.lnode));
 	list_add_tail_rcu(&aux->ksym.lnode, &bpf_kallsyms);
 	latch_tree_insert(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
+	latch_tree_insert(&aux->ksym.tnode, &bpf_kallsyms_tree, &bpf_kallsyms_tree_ops);
 }
 
 static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
@@ -623,6 +662,7 @@ static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
 		return;
 
 	latch_tree_erase(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
+	latch_tree_erase(&aux->ksym.tnode, &bpf_kallsyms_tree, &bpf_kallsyms_tree_ops);
 	list_del_rcu(&aux->ksym.lnode);
 }
 
@@ -671,19 +711,27 @@ static struct bpf_prog *bpf_prog_kallsyms_find(unsigned long addr)
 	       NULL;
 }
 
+static struct bpf_ksym *bpf_ksym_find(unsigned long addr)
+{
+	struct latch_tree_node *n;
+
+	n = latch_tree_find((void *)addr, &bpf_kallsyms_tree, &bpf_kallsyms_tree_ops);
+	return n ? container_of(n, struct bpf_ksym, tnode) : NULL;
+}
+
 const char *__bpf_address_lookup(unsigned long addr, unsigned long *size,
 				 unsigned long *off, char *sym)
 {
-	struct bpf_prog *prog;
+	struct bpf_ksym *ksym;
 	char *ret = NULL;
 
 	rcu_read_lock();
-	prog = bpf_prog_kallsyms_find(addr);
-	if (prog) {
-		unsigned long symbol_start = prog->aux->ksym.start;
-		unsigned long symbol_end = prog->aux->ksym.end;
+	ksym = bpf_ksym_find(addr);
+	if (ksym) {
+		unsigned long symbol_start = ksym->start;
+		unsigned long symbol_end = ksym->end;
 
-		strncpy(sym, prog->aux->ksym.name, KSYM_NAME_LEN);
+		strncpy(sym, ksym->name, KSYM_NAME_LEN);
 
 		ret = sym;
 		if (size)
-- 
2.24.1

