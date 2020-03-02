Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAC8175D2A
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 15:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgCBOcn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Mar 2020 09:32:43 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53079 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727304AbgCBOcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 09:32:43 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-MeA5K4DcNYKB2sm7I289KQ-1; Mon, 02 Mar 2020 09:32:40 -0500
X-MC-Unique: MeA5K4DcNYKB2sm7I289KQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E29C3DBB3;
        Mon,  2 Mar 2020 14:32:37 +0000 (UTC)
Received: from krava.redhat.com (ovpn-205-46.brq.redhat.com [10.40.205.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14CCC92D25;
        Mon,  2 Mar 2020 14:32:30 +0000 (UTC)
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
Subject: [PATCH 08/15] bpf: Separate kallsyms add/del functions
Date:   Mon,  2 Mar 2020 15:31:47 +0100
Message-Id: <20200302143154.258569-9-jolsa@kernel.org>
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

Moving bpf_prog_ksym_node_add/del to __bpf_ksym_add/del
and changing the argument to 'struct bpf_ksym' object.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index cd7049441953..387e1bac3a45 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -645,20 +645,20 @@ static LIST_HEAD(bpf_kallsyms);
 static struct latch_tree_root bpf_ksym_tree __cacheline_aligned;
 static struct latch_tree_root bpf_tree __cacheline_aligned;
 
-static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
+static void __bpf_ksym_add(struct bpf_ksym *ksym)
 {
-	WARN_ON_ONCE(!list_empty(&aux->ksym.lnode));
-	list_add_tail_rcu(&aux->ksym.lnode, &bpf_kallsyms);
-	latch_tree_insert(&aux->ksym.tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
+	WARN_ON_ONCE(!list_empty(&ksym->lnode));
+	list_add_tail_rcu(&ksym->lnode, &bpf_kallsyms);
+	latch_tree_insert(&ksym->tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
 }
 
-static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
+static void __bpf_ksym_del(struct bpf_ksym *ksym)
 {
-	if (list_empty(&aux->ksym.lnode))
+	if (list_empty(&ksym->lnode))
 		return;
 
-	latch_tree_erase(&aux->ksym.tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
-	list_del_rcu(&aux->ksym.lnode);
+	latch_tree_erase(&ksym->tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
+	list_del_rcu(&ksym->lnode);
 }
 
 static bool bpf_prog_kallsyms_candidate(const struct bpf_prog *fp)
@@ -683,7 +683,7 @@ void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 
 	spin_lock_bh(&bpf_lock);
 	latch_tree_insert(&fp->aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
-	bpf_prog_ksym_node_add(fp->aux);
+	__bpf_ksym_add(&fp->aux->ksym);
 	spin_unlock_bh(&bpf_lock);
 }
 
@@ -694,7 +694,7 @@ void bpf_prog_kallsyms_del(struct bpf_prog *fp)
 
 	spin_lock_bh(&bpf_lock);
 	latch_tree_erase(&fp->aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
-	bpf_prog_ksym_node_del(fp->aux);
+	__bpf_ksym_del(&fp->aux->ksym);
 	spin_unlock_bh(&bpf_lock);
 }
 
-- 
2.24.1

