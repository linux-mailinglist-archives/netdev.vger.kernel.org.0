Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4601605F5
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 20:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgBPTbj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 16 Feb 2020 14:31:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48864 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727957AbgBPTbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 14:31:39 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-nDO0ajQrNV-e2dsolwyg1w-1; Sun, 16 Feb 2020 14:31:34 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8122E1007268;
        Sun, 16 Feb 2020 19:31:32 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-28.brq.redhat.com [10.40.204.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E8C48574E;
        Sun, 16 Feb 2020 19:31:28 +0000 (UTC)
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
Subject: [PATCH 14/18] bpf: Add dispatchers to kallsyms
Date:   Sun, 16 Feb 2020 20:30:01 +0100
Message-Id: <20200216193005.144157-15-jolsa@kernel.org>
In-Reply-To: <20200216193005.144157-1-jolsa@kernel.org>
References: <20200216193005.144157-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: nDO0ajQrNV-e2dsolwyg1w-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding dispatchers to kallsyms. It's displayed as
  bpf_dispatcher_<NAME>

where NAME is the name of dispatcher.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     | 19 ++++++++++++-------
 kernel/bpf/dispatcher.c |  9 ++++++++-
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c216af89254f..4ae2273112ba 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -520,6 +520,7 @@ struct bpf_dispatcher {
 	int num_progs;
 	void *image;
 	u32 image_off;
+	struct bpf_ksym ksym;
 };
 
 static __always_inline unsigned int bpf_dispatcher_nop_func(
@@ -535,13 +536,17 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
-#define BPF_DISPATCHER_INIT(name) {			\
-	.mutex = __MUTEX_INITIALIZER(name.mutex),	\
-	.func = &name##_func,				\
-	.progs = {},					\
-	.num_progs = 0,					\
-	.image = NULL,					\
-	.image_off = 0					\
+#define BPF_DISPATCHER_INIT(_name) {				\
+	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
+	.func = &_name##_func,					\
+	.progs = {},						\
+	.num_progs = 0,						\
+	.image = NULL,						\
+	.image_off = 0,						\
+	.ksym = {						\
+		.name  = #_name,				\
+		.lnode = LIST_HEAD_INIT(_name.ksym.lnode),	\
+	},							\
 }
 
 #define DEFINE_BPF_DISPATCHER(name)					\
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index 3a5871bbd6d0..74060c92b2f3 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -154,7 +154,14 @@ void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
 	if (!changed)
 		goto out;
 
-	bpf_dispatcher_update(d, prev_num_progs);
+	if (!bpf_dispatcher_update(d, prev_num_progs)) {
+		if (!prev_num_progs)
+			bpf_image_ksym_add(d->image, &d->ksym);
+
+		if (!d->num_progs)
+			bpf_image_ksym_del(&d->ksym);
+	}
+
 out:
 	mutex_unlock(&d->mutex);
 }
-- 
2.24.1

