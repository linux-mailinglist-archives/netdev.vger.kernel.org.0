Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B24156539
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 16:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgBHPnN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Feb 2020 10:43:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20776 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727581AbgBHPnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 10:43:12 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-Bql8ufMdP9ikBZNEOreDRw-1; Sat, 08 Feb 2020 10:43:07 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BA0C800D6C;
        Sat,  8 Feb 2020 15:43:05 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-79.brq.redhat.com [10.40.204.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDA2A5C21B;
        Sat,  8 Feb 2020 15:43:02 +0000 (UTC)
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
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH 13/14] bpf: Add dispatchers to kallsyms
Date:   Sat,  8 Feb 2020 16:42:08 +0100
Message-Id: <20200208154209.1797988-14-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-1-jolsa@kernel.org>
References: <20200208154209.1797988-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: Bql8ufMdP9ikBZNEOreDRw-1
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
 kernel/bpf/dispatcher.c |  6 ++++++
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b91bac10d3ea..837cdc093d2c 100644
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
+		.name = #_name,					\
+		.lnode = LIST_HEAD_INIT(_name.ksym.lnode),	\
+	},							\
 }
 
 #define DEFINE_BPF_DISPATCHER(name)					\
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index b3e5b214fed8..8771d2cc5840 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -152,6 +152,12 @@ void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
 	if (!changed)
 		goto out;
 
+	if (!prev_num_progs)
+		bpf_image_ksym_add(d->image, &d->ksym);
+
+	if (!d->num_progs)
+		bpf_ksym_del(&d->ksym);
+
 	bpf_dispatcher_update(d, prev_num_progs);
 out:
 	mutex_unlock(&d->mutex);
-- 
2.24.1

