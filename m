Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769EC183A03
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgCLT5J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Mar 2020 15:57:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31997 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgCLT5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:57:08 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-fY9hT-M8OjOZttMZys8QDg-1; Thu, 12 Mar 2020 15:57:03 -0400
X-MC-Unique: fY9hT-M8OjOZttMZys8QDg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0E5A109DDEA;
        Thu, 12 Mar 2020 19:57:01 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AA285D9C5;
        Thu, 12 Mar 2020 19:56:58 +0000 (UTC)
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
Subject: [PATCH 09/15] bpf: Add bpf_ksym_add/del functions
Date:   Thu, 12 Mar 2020 20:56:04 +0100
Message-Id: <20200312195610.346362-10-jolsa@kernel.org>
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

Separating /proc/kallsyms add/del code and adding bpf_ksym_add/del
functions for that.

Moving bpf_prog_ksym_node_add/del functions to __bpf_ksym_add/del
and changing their argument to 'struct bpf_ksym' object. This way
we can call them for other bpf objects types like trampoline and
dispatcher.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h |  3 +++
 kernel/bpf/core.c   | 33 +++++++++++++++++++--------------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 739ec3f562bf..83920cbce24c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -584,6 +584,9 @@ struct bpf_image {
 #define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
 bool is_bpf_image_address(unsigned long address);
 void *bpf_image_alloc(void);
+/* Called only from JIT-enabled code, so there's no need for stubs. */
+void bpf_ksym_add(struct bpf_ksym *ksym);
+void bpf_ksym_del(struct bpf_ksym *ksym);
 #else
 static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 92577a81122a..cc360bfde1fe 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -607,20 +607,29 @@ static DEFINE_SPINLOCK(bpf_lock);
 static LIST_HEAD(bpf_kallsyms);
 static struct latch_tree_root bpf_tree __cacheline_aligned;
 
-static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
+void bpf_ksym_add(struct bpf_ksym *ksym)
 {
-	WARN_ON_ONCE(!list_empty(&aux->ksym.lnode));
-	list_add_tail_rcu(&aux->ksym.lnode, &bpf_kallsyms);
-	latch_tree_insert(&aux->ksym.tnode, &bpf_tree, &bpf_tree_ops);
+	spin_lock_bh(&bpf_lock);
+	WARN_ON_ONCE(!list_empty(&ksym->lnode));
+	list_add_tail_rcu(&ksym->lnode, &bpf_kallsyms);
+	latch_tree_insert(&ksym->tnode, &bpf_tree, &bpf_tree_ops);
+	spin_unlock_bh(&bpf_lock);
 }
 
-static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
+static void __bpf_ksym_del(struct bpf_ksym *ksym)
 {
-	if (list_empty(&aux->ksym.lnode))
+	if (list_empty(&ksym->lnode))
 		return;
 
-	latch_tree_erase(&aux->ksym.tnode, &bpf_tree, &bpf_tree_ops);
-	list_del_rcu(&aux->ksym.lnode);
+	latch_tree_erase(&ksym->tnode, &bpf_tree, &bpf_tree_ops);
+	list_del_rcu(&ksym->lnode);
+}
+
+void bpf_ksym_del(struct bpf_ksym *ksym)
+{
+	spin_lock_bh(&bpf_lock);
+	__bpf_ksym_del(ksym);
+	spin_unlock_bh(&bpf_lock);
 }
 
 static bool bpf_prog_kallsyms_candidate(const struct bpf_prog *fp)
@@ -644,9 +653,7 @@ void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 	bpf_prog_ksym_set_name(fp);
 	fp->aux->ksym.prog = true;
 
-	spin_lock_bh(&bpf_lock);
-	bpf_prog_ksym_node_add(fp->aux);
-	spin_unlock_bh(&bpf_lock);
+	bpf_ksym_add(&fp->aux->ksym);
 }
 
 void bpf_prog_kallsyms_del(struct bpf_prog *fp)
@@ -654,9 +661,7 @@ void bpf_prog_kallsyms_del(struct bpf_prog *fp)
 	if (!bpf_prog_kallsyms_candidate(fp))
 		return;
 
-	spin_lock_bh(&bpf_lock);
-	bpf_prog_ksym_node_del(fp->aux);
-	spin_unlock_bh(&bpf_lock);
+	bpf_ksym_del(&fp->aux->ksym);
 }
 
 static struct bpf_ksym *bpf_ksym_find(unsigned long addr)
-- 
2.24.1

