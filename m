Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B041616FF8B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgBZNE3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Feb 2020 08:04:29 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44466 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727196AbgBZNE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:04:29 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-53ednklAOBmw8e_eXHNUPA-1; Wed, 26 Feb 2020 08:04:24 -0500
X-MC-Unique: 53ednklAOBmw8e_eXHNUPA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47480800EBB;
        Wed, 26 Feb 2020 13:04:22 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7315119C7F;
        Wed, 26 Feb 2020 13:04:19 +0000 (UTC)
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
Subject: [PATCH 09/18] bpf: Add bpf_ksym_add/del functions
Date:   Wed, 26 Feb 2020 14:03:36 +0100
Message-Id: <20200226130345.209469-10-jolsa@kernel.org>
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

Adding bpf_ksym_add/del functions as locked version
for __bpf_ksym_add/del. It will be used in following
patches for bpf_trampoline and bpf_dispatcher.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h |  3 +++
 kernel/bpf/core.c   | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5d6649cdc3df..76934893bccf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -573,6 +573,9 @@ struct bpf_image {
 #define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
 bool is_bpf_image_address(unsigned long address);
 void *bpf_image_alloc(void);
+/* Called only from code, so there's no need for stubs. */
+void bpf_ksym_add(struct bpf_ksym *ksym);
+void bpf_ksym_del(struct bpf_ksym *ksym);
 #else
 static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index a8a4000f5ca8..c95424fc53de 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -651,6 +651,13 @@ static void __bpf_ksym_add(struct bpf_ksym *ksym)
 	latch_tree_insert(&ksym->tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
 }
 
+void bpf_ksym_add(struct bpf_ksym *ksym)
+{
+	spin_lock_bh(&bpf_lock);
+	__bpf_ksym_add(ksym);
+	spin_unlock_bh(&bpf_lock);
+}
+
 static void __bpf_ksym_del(struct bpf_ksym *ksym)
 {
 	if (list_empty(&ksym->lnode))
@@ -660,6 +667,13 @@ static void __bpf_ksym_del(struct bpf_ksym *ksym)
 	list_del_rcu(&ksym->lnode);
 }
 
+void bpf_ksym_del(struct bpf_ksym *ksym)
+{
+	spin_lock_bh(&bpf_lock);
+	__bpf_ksym_del(ksym);
+	spin_unlock_bh(&bpf_lock);
+}
+
 static bool bpf_prog_kallsyms_candidate(const struct bpf_prog *fp)
 {
 	return fp->jited && !bpf_prog_was_classic(fp);
-- 
2.24.1

