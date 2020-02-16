Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95261605EA
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 20:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgBPTbJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 16 Feb 2020 14:31:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24677 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726719AbgBPTbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 14:31:08 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-88P8VVDbP9GWfOCtG5TvUA-1; Sun, 16 Feb 2020 14:31:05 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07D6C8017CC;
        Sun, 16 Feb 2020 19:31:03 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-28.brq.redhat.com [10.40.204.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8B598AC5B;
        Sun, 16 Feb 2020 19:30:54 +0000 (UTC)
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
Date:   Sun, 16 Feb 2020 20:29:56 +0100
Message-Id: <20200216193005.144157-10-jolsa@kernel.org>
In-Reply-To: <20200216193005.144157-1-jolsa@kernel.org>
References: <20200216193005.144157-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 88P8VVDbP9GWfOCtG5TvUA-1
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
index f361cfdf8d9e..739bef60d868 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -655,6 +655,13 @@ static void __bpf_ksym_add(struct bpf_ksym *ksym)
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
@@ -664,6 +671,13 @@ static void __bpf_ksym_del(struct bpf_ksym *ksym)
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

