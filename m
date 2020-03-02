Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AC6175D27
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 15:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgCBOce convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Mar 2020 09:32:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727370AbgCBOcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 09:32:32 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-j6mHfsBGMryTOKwscffVpQ-1; Mon, 02 Mar 2020 09:32:27 -0500
X-MC-Unique: j6mHfsBGMryTOKwscffVpQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA8468017DF;
        Mon,  2 Mar 2020 14:32:24 +0000 (UTC)
Received: from krava.redhat.com (ovpn-205-46.brq.redhat.com [10.40.205.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1120192D2D;
        Mon,  2 Mar 2020 14:32:20 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 06/15] bpf: Add bpf_ksym_tree tree
Date:   Mon,  2 Mar 2020 15:31:45 +0100
Message-Id: <20200302143154.258569-7-jolsa@kernel.org>
In-Reply-To: <20200302143154.258569-1-jolsa@kernel.org>
References: <20200302143154.258569-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

Adding bpf_ksym_tree that will hold symbols for all bpf_prog
bpf_trampoline and bpf_dispatcher objects and keeping bpf_tree
only for bpf_prog objects to keep it fast.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h |  1 +
 kernel/bpf/core.c   | 56 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f1174d24c185..5d6649cdc3df 100644
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
index 084abfbc3362..c36558c44637 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -607,8 +607,42 @@ static const struct latch_tree_ops bpf_tree_ops = {
 	.comp	= bpf_tree_comp,
 };
 
+static unsigned long bpf_get_ksym_start(struct latch_tree_node *n)
+{
+	return container_of(n, struct bpf_ksym, tnode)->start;
+}
+
+static bool
+bpf_ksym_tree_less(struct latch_tree_node *a,
+		   struct latch_tree_node *b)
+{
+	return bpf_get_ksym_start(a) < bpf_get_ksym_start(b);
+}
+
+static int
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
+static const struct latch_tree_ops bpf_ksym_tree_ops = {
+	.less	= bpf_ksym_tree_less,
+	.comp	= bpf_ksym_tree_comp,
+};
+
 static DEFINE_SPINLOCK(bpf_lock);
 static LIST_HEAD(bpf_kallsyms);
+static struct latch_tree_root bpf_ksym_tree __cacheline_aligned;
 static struct latch_tree_root bpf_tree __cacheline_aligned;
 
 static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
@@ -616,6 +650,7 @@ static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
 	WARN_ON_ONCE(!list_empty(&aux->ksym.lnode));
 	list_add_tail_rcu(&aux->ksym.lnode, &bpf_kallsyms);
 	latch_tree_insert(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
+	latch_tree_insert(&aux->ksym.tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
 }
 
 static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
@@ -624,6 +659,7 @@ static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
 		return;
 
 	latch_tree_erase(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
+	latch_tree_erase(&aux->ksym.tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
 	list_del_rcu(&aux->ksym.lnode);
 }
 
@@ -672,19 +708,27 @@ static struct bpf_prog *bpf_prog_kallsyms_find(unsigned long addr)
 	       NULL;
 }
 
+static struct bpf_ksym *bpf_ksym_find(unsigned long addr)
+{
+	struct latch_tree_node *n;
+
+	n = latch_tree_find((void *)addr, &bpf_ksym_tree, &bpf_ksym_tree_ops);
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

