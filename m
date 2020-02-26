Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D56A16FF8E
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgBZNEf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Feb 2020 08:04:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57109 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727196AbgBZNEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:04:34 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-dA7Q_NKRNLOo4kXOHFDYYA-1; Wed, 26 Feb 2020 08:04:30 -0500
X-MC-Unique: dA7Q_NKRNLOo4kXOHFDYYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 924461005512;
        Wed, 26 Feb 2020 13:04:28 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF69219C7F;
        Wed, 26 Feb 2020 13:04:25 +0000 (UTC)
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
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/18] bpf: Rename bpf_tree to bpf_progs_tree
Date:   Wed, 26 Feb 2020 14:03:38 +0100
Message-Id: <20200226130345.209469-12-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-1-jolsa@kernel.org>
References: <20200226130345.209469-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Renaming bpf_tree to bpf_progs_tree and bpf_tree_ops
to bpf_progs_tree_ops to better capture the usage of
the tree which is for the bpf_prog objects only.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/core.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 1af2109b45c7..9879fb02ee8e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -580,13 +580,14 @@ bpf_get_prog_addr_start(struct latch_tree_node *n)
 	return aux->ksym.start;
 }
 
-static __always_inline bool bpf_tree_less(struct latch_tree_node *a,
-					  struct latch_tree_node *b)
+static __always_inline bool
+bpf_progs_tree_less(struct latch_tree_node *a,
+		    struct latch_tree_node *b)
 {
 	return bpf_get_prog_addr_start(a) < bpf_get_prog_addr_start(b);
 }
 
-static __always_inline int bpf_tree_comp(void *key, struct latch_tree_node *n)
+static __always_inline int bpf_progs_tree_comp(void *key, struct latch_tree_node *n)
 {
 	unsigned long val = (unsigned long)key;
 	const struct bpf_prog_aux *aux;
@@ -601,9 +602,9 @@ static __always_inline int bpf_tree_comp(void *key, struct latch_tree_node *n)
 	return 0;
 }
 
-static const struct latch_tree_ops bpf_tree_ops = {
-	.less	= bpf_tree_less,
-	.comp	= bpf_tree_comp,
+static const struct latch_tree_ops bpf_progs_tree_ops = {
+	.less	= bpf_progs_tree_less,
+	.comp	= bpf_progs_tree_comp,
 };
 
 static unsigned long bpf_get_ksym_start(struct latch_tree_node *n)
@@ -642,7 +643,7 @@ static const struct latch_tree_ops bpf_ksym_tree_ops = {
 static DEFINE_SPINLOCK(bpf_lock);
 static LIST_HEAD(bpf_kallsyms);
 static struct latch_tree_root bpf_ksym_tree __cacheline_aligned;
-static struct latch_tree_root bpf_tree __cacheline_aligned;
+static struct latch_tree_root bpf_progs_tree __cacheline_aligned;
 
 static void __bpf_ksym_add(struct bpf_ksym *ksym)
 {
@@ -702,7 +703,8 @@ void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 	bpf_get_prog_name(fp);
 
 	spin_lock_bh(&bpf_lock);
-	latch_tree_insert(&fp->aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
+	latch_tree_insert(&fp->aux->ksym_tnode, &bpf_progs_tree,
+			  &bpf_progs_tree_ops);
 	__bpf_ksym_add(&fp->aux->ksym);
 	spin_unlock_bh(&bpf_lock);
 }
@@ -713,7 +715,8 @@ void bpf_prog_kallsyms_del(struct bpf_prog *fp)
 		return;
 
 	spin_lock_bh(&bpf_lock);
-	latch_tree_erase(&fp->aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
+	latch_tree_erase(&fp->aux->ksym_tnode, &bpf_progs_tree,
+			 &bpf_progs_tree_ops);
 	__bpf_ksym_del(&fp->aux->ksym);
 	spin_unlock_bh(&bpf_lock);
 }
@@ -722,7 +725,8 @@ static struct bpf_prog *bpf_prog_kallsyms_find(unsigned long addr)
 {
 	struct latch_tree_node *n;
 
-	n = latch_tree_find((void *)addr, &bpf_tree, &bpf_tree_ops);
+	n = latch_tree_find((void *)addr, &bpf_progs_tree,
+			    &bpf_progs_tree_ops);
 	return n ?
 	       container_of(n, struct bpf_prog_aux, ksym_tnode)->prog :
 	       NULL;
-- 
2.24.1

