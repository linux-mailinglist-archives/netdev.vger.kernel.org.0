Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6589F175D30
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 15:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgCBOct convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Mar 2020 09:32:49 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36719 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727304AbgCBOcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 09:32:47 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-yM-x8qWvMgOZCpjbUjnQrA-1; Mon, 02 Mar 2020 09:32:44 -0500
X-MC-Unique: yM-x8qWvMgOZCpjbUjnQrA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EEE98017DF;
        Mon,  2 Mar 2020 14:32:42 +0000 (UTC)
Received: from krava.redhat.com (ovpn-205-46.brq.redhat.com [10.40.205.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F7EE93519;
        Mon,  2 Mar 2020 14:32:38 +0000 (UTC)
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
Subject: [PATCH 09/15] bpf: Add bpf_ksym_add/del functions
Date:   Mon,  2 Mar 2020 15:31:48 +0100
Message-Id: <20200302143154.258569-10-jolsa@kernel.org>
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

Adding bpf_ksym_add/del functions as locked version
for __bpf_ksym_add/del. It will be used in following
patches for bpf_trampoline and bpf_dispatcher.

Acked-by: Song Liu <songliubraving@fb.com>
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
index 387e1bac3a45..46ef6f66aab4 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -652,6 +652,13 @@ static void __bpf_ksym_add(struct bpf_ksym *ksym)
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
@@ -661,6 +668,13 @@ static void __bpf_ksym_del(struct bpf_ksym *ksym)
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

