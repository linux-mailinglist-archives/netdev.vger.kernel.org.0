Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6AB81839F8
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgCLT4p convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Mar 2020 15:56:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43139 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726729AbgCLT4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:56:44 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-2a3cYJl7Ow-mVUR3uBaDHw-1; Thu, 12 Mar 2020 15:56:40 -0400
X-MC-Unique: 2a3cYJl7Ow-mVUR3uBaDHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D846A107ACC7;
        Thu, 12 Mar 2020 19:56:37 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D871E5D9C5;
        Thu, 12 Mar 2020 19:56:33 +0000 (UTC)
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
Subject: [PATCH 05/15] bpf: Move lnode list node to struct bpf_ksym
Date:   Thu, 12 Mar 2020 20:56:00 +0100
Message-Id: <20200312195610.346362-6-jolsa@kernel.org>
In-Reply-To: <20200312195610.346362-1-jolsa@kernel.org>
References: <20200312195610.346362-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding lnode list node to 'struct bpf_ksym' object,
so the struct bpf_ksym itself can be chained and used
in other objects like bpf_trampoline and bpf_dispatcher.

Changing iterator to bpf_ksym in bpf_get_kallsym function.

The ksym->start is holding the prog->bpf_func value,
so it's ok to use it as value in bpf_get_kallsym.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h |  2 +-
 kernel/bpf/core.c   | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e1cd64f2bf05..de624c4f66ec 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -476,6 +476,7 @@ struct bpf_ksym {
 	unsigned long		 start;
 	unsigned long		 end;
 	char			 name[KSYM_NAME_LEN];
+	struct list_head	 lnode;
 };
 
 enum bpf_tramp_prog_type {
@@ -659,7 +660,6 @@ struct bpf_prog_aux {
 	struct bpf_jit_poke_descriptor *poke_tab;
 	u32 size_poke_tab;
 	struct latch_tree_node ksym_tnode;
-	struct list_head ksym_lnode;
 	struct bpf_ksym ksym;
 	const struct bpf_prog_ops *ops;
 	struct bpf_map **used_maps;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index f86cb15d6f2e..084abfbc3362 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -97,7 +97,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	fp->aux->prog = fp;
 	fp->jit_requested = ebpf_jit_enabled();
 
-	INIT_LIST_HEAD_RCU(&fp->aux->ksym_lnode);
+	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 
 	return fp;
 }
@@ -613,18 +613,18 @@ static struct latch_tree_root bpf_tree __cacheline_aligned;
 
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
@@ -634,8 +634,8 @@ static bool bpf_prog_kallsyms_candidate(const struct bpf_prog *fp)
 
 static bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
 {
-	return list_empty(&fp->aux->ksym_lnode) ||
-	       fp->aux->ksym_lnode.prev == LIST_POISON2;
+	return list_empty(&fp->aux->ksym.lnode) ||
+	       fp->aux->ksym.lnode.prev == LIST_POISON2;
 }
 
 void bpf_prog_kallsyms_add(struct bpf_prog *fp)
@@ -729,7 +729,7 @@ const struct exception_table_entry *search_bpf_extables(unsigned long addr)
 int bpf_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 		    char *sym)
 {
-	struct bpf_prog_aux *aux;
+	struct bpf_ksym *ksym;
 	unsigned int it = 0;
 	int ret = -ERANGE;
 
@@ -737,13 +737,13 @@ int bpf_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
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

