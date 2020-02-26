Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C2D16FF83
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgBZNEQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Feb 2020 08:04:16 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47931 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727073AbgBZNEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:04:16 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-TXZEl8umOieyXX1idc4hyg-1; Wed, 26 Feb 2020 08:04:11 -0500
X-MC-Unique: TXZEl8umOieyXX1idc4hyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9282F800D53;
        Wed, 26 Feb 2020 13:04:09 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B715119756;
        Wed, 26 Feb 2020 13:04:05 +0000 (UTC)
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
Subject: [PATCH 05/18] bpf: Add lnode list node to struct bpf_ksym
Date:   Wed, 26 Feb 2020 14:03:32 +0100
Message-Id: <20200226130345.209469-6-jolsa@kernel.org>
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

Adding lnode list node to 'struct bpf_ksym' object,
so the symbol itself can be chained and used in other
objects like bpf_trampoline and bpf_dispatcher.

Changing iterator to bpf_ksym in bpf_get_kallsym.

The ksym->start is holding the prog->bpf_func value,
so it's ok to use it in bpf_get_kallsym.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h |  2 +-
 kernel/bpf/core.c   | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e7b2e9fc256c..f1174d24c185 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -467,6 +467,7 @@ struct bpf_ksym {
 	unsigned long		 start;
 	unsigned long		 end;
 	char			 name[KSYM_NAME_LEN];
+	struct list_head	 lnode;
 };
 
 enum bpf_tramp_prog_type {
@@ -649,7 +650,6 @@ struct bpf_prog_aux {
 	struct bpf_jit_poke_descriptor *poke_tab;
 	u32 size_poke_tab;
 	struct latch_tree_node ksym_tnode;
-	struct list_head ksym_lnode;
 	struct bpf_ksym ksym;
 	const struct bpf_prog_ops *ops;
 	struct bpf_map **used_maps;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index a7aaa81035b1..604093d2153a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -97,7 +97,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	fp->aux->prog = fp;
 	fp->jit_requested = ebpf_jit_enabled();
 
-	INIT_LIST_HEAD_RCU(&fp->aux->ksym_lnode);
+	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 
 	return fp;
 }
@@ -612,18 +612,18 @@ static struct latch_tree_root bpf_tree __cacheline_aligned;
 
 static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
 {
-	WARN_ON_ONCE(!list_empty(&aux->ksym_lnode));
-	list_add_tail_rcu(&aux->ksym_lnode, &bpf_kallsyms);
+	WARN_ON_ONCE(!list_empty(&aux->ksym.lnode));
+	list_add_tail_rcu(&aux->ksym.lnode, &bpf_kallsyms);
 	latch_tree_insert(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
 }
 
 static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
 {
-	if (list_empty(&aux->ksym_lnode))
+	if (list_empty(&aux->ksym.lnode))
 		return;
 
 	latch_tree_erase(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
-	list_del_rcu(&aux->ksym_lnode);
+	list_del_rcu(&aux->ksym.lnode);
 }
 
 static bool bpf_prog_kallsyms_candidate(const struct bpf_prog *fp)
@@ -633,8 +633,8 @@ static bool bpf_prog_kallsyms_candidate(const struct bpf_prog *fp)
 
 static bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
 {
-	return list_empty(&fp->aux->ksym_lnode) ||
-	       fp->aux->ksym_lnode.prev == LIST_POISON2;
+	return list_empty(&fp->aux->ksym.lnode) ||
+	       fp->aux->ksym.lnode.prev == LIST_POISON2;
 }
 
 void bpf_prog_kallsyms_add(struct bpf_prog *fp)
@@ -728,7 +728,7 @@ const struct exception_table_entry *search_bpf_extables(unsigned long addr)
 int bpf_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 		    char *sym)
 {
-	struct bpf_prog_aux *aux;
+	struct bpf_ksym *ksym;
 	unsigned int it = 0;
 	int ret = -ERANGE;
 
@@ -736,13 +736,13 @@ int bpf_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 		return ret;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(aux, &bpf_kallsyms, ksym_lnode) {
+	list_for_each_entry_rcu(ksym, &bpf_kallsyms, lnode) {
 		if (it++ != symnum)
 			continue;
 
-		strncpy(sym, aux->ksym.name, KSYM_NAME_LEN);
+		strncpy(sym, ksym->name, KSYM_NAME_LEN);
 
-		*value = (unsigned long)aux->prog->bpf_func;
+		*value = ksym->start;
 		*type  = BPF_SYM_ELF_TYPE;
 
 		ret = 0;
-- 
2.24.1

