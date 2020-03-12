Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B69183A07
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCLT5R convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Mar 2020 15:57:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33919 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727020AbgCLT5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:57:17 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-epYriTC_M92rrRp6wEhU9Q-1; Thu, 12 Mar 2020 15:57:12 -0400
X-MC-Unique: epYriTC_M92rrRp6wEhU9Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8105CA0CC9;
        Thu, 12 Mar 2020 19:57:10 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE7B05D9C5;
        Thu, 12 Mar 2020 19:57:06 +0000 (UTC)
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
Subject: [PATCH 11/15] bpf: Add dispatchers to kallsyms
Date:   Thu, 12 Mar 2020 20:56:06 +0100
Message-Id: <20200312195610.346362-12-jolsa@kernel.org>
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

Adding dispatchers to kallsyms. It's displayed as
  bpf_dispatcher_<NAME>

where NAME is the name of dispatcher.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     | 19 ++++++++++++-------
 kernel/bpf/dispatcher.c |  1 +
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7edbf30cf2b2..95e13efe658a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -531,6 +531,7 @@ struct bpf_dispatcher {
 	int num_progs;
 	void *image;
 	u32 image_off;
+	struct bpf_ksym ksym;
 };
 
 static __always_inline unsigned int bpf_dispatcher_nop_func(
@@ -546,13 +547,17 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
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
index b3e5b214fed8..a2679bae9e73 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -143,6 +143,7 @@ void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
 		d->image = bpf_image_alloc();
 		if (!d->image)
 			goto out;
+		bpf_image_ksym_add(d->image, &d->ksym);
 	}
 
 	prev_num_progs = d->num_progs;
-- 
2.24.1

