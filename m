Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61EEC1839FB
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgCLT4v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Mar 2020 15:56:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55034 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726928AbgCLT4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:56:51 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-feJ9WQg6PESirBnShiXgvQ-1; Thu, 12 Mar 2020 15:56:46 -0400
X-MC-Unique: feJ9WQg6PESirBnShiXgvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D66A19251A1;
        Thu, 12 Mar 2020 19:56:44 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B5DF5D9C5;
        Thu, 12 Mar 2020 19:56:38 +0000 (UTC)
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
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 06/15] bpf: Move ksym_tnode to bpf_ksym
Date:   Thu, 12 Mar 2020 20:56:01 +0100
Message-Id: <20200312195610.346362-7-jolsa@kernel.org>
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

Moving ksym_tnode list node to 'struct bpf_ksym' object,
so the symbol itself can be chained and used in other
objects like bpf_trampoline and bpf_dispatcher.

We need bpf_ksym object to be linked both in bpf_kallsyms
via lnode for /proc/kallsyms and in bpf_tree via tnode for
bpf address lookup functions like __bpf_address_lookup or
bpf_prog_kallsyms_find.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h |  2 +-
 kernel/bpf/core.c   | 24 ++++++++++--------------
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index de624c4f66ec..c5afff03b0f4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -477,6 +477,7 @@ struct bpf_ksym {
 	unsigned long		 end;
 	char			 name[KSYM_NAME_LEN];
 	struct list_head	 lnode;
+	struct latch_tree_node	 tnode;
 };
 
 enum bpf_tramp_prog_type {
@@ -659,7 +660,6 @@ struct bpf_prog_aux {
 	void *jit_data; /* JIT specific data. arch dependent */
 	struct bpf_jit_poke_descriptor *poke_tab;
 	u32 size_poke_tab;
-	struct latch_tree_node ksym_tnode;
 	struct bpf_ksym ksym;
 	const struct bpf_prog_ops *ops;
 	struct bpf_map **used_maps;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 084abfbc3362..df0caa4bc9cc 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -572,31 +572,27 @@ bpf_prog_ksym_set_name(struct bpf_prog *prog)
 		*sym = 0;
 }
 
-static __always_inline unsigned long
-bpf_get_prog_addr_start(struct latch_tree_node *n)
+static unsigned long bpf_get_ksym_start(struct latch_tree_node *n)
 {
-	const struct bpf_prog_aux *aux;
-
-	aux = container_of(n, struct bpf_prog_aux, ksym_tnode);
-	return aux->ksym.start;
+	return container_of(n, struct bpf_ksym, tnode)->start;
 }
 
 static __always_inline bool bpf_tree_less(struct latch_tree_node *a,
 					  struct latch_tree_node *b)
 {
-	return bpf_get_prog_addr_start(a) < bpf_get_prog_addr_start(b);
+	return bpf_get_ksym_start(a) < bpf_get_ksym_start(b);
 }
 
 static __always_inline int bpf_tree_comp(void *key, struct latch_tree_node *n)
 {
 	unsigned long val = (unsigned long)key;
-	const struct bpf_prog_aux *aux;
+	const struct bpf_ksym *ksym;
 
-	aux = container_of(n, struct bpf_prog_aux, ksym_tnode);
+	ksym = container_of(n, struct bpf_ksym, tnode);
 
-	if (val < aux->ksym.start)
+	if (val < ksym->start)
 		return -1;
-	if (val >= aux->ksym.end)
+	if (val >= ksym->end)
 		return  1;
 
 	return 0;
@@ -615,7 +611,7 @@ static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
 {
 	WARN_ON_ONCE(!list_empty(&aux->ksym.lnode));
 	list_add_tail_rcu(&aux->ksym.lnode, &bpf_kallsyms);
-	latch_tree_insert(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
+	latch_tree_insert(&aux->ksym.tnode, &bpf_tree, &bpf_tree_ops);
 }
 
 static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
@@ -623,7 +619,7 @@ static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
 	if (list_empty(&aux->ksym.lnode))
 		return;
 
-	latch_tree_erase(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
+	latch_tree_erase(&aux->ksym.tnode, &bpf_tree, &bpf_tree_ops);
 	list_del_rcu(&aux->ksym.lnode);
 }
 
@@ -668,7 +664,7 @@ static struct bpf_prog *bpf_prog_kallsyms_find(unsigned long addr)
 
 	n = latch_tree_find((void *)addr, &bpf_tree, &bpf_tree_ops);
 	return n ?
-	       container_of(n, struct bpf_prog_aux, ksym_tnode)->prog :
+	       container_of(n, struct bpf_prog_aux, ksym.tnode)->prog :
 	       NULL;
 }
 
-- 
2.24.1

