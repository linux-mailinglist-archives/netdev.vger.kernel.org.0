Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2AB616FF7C
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgBZNEC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Feb 2020 08:04:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43760 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726765AbgBZNEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:04:02 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-yeGzYs_pN8ehijx5KIDQnQ-1; Wed, 26 Feb 2020 08:03:58 -0500
X-MC-Unique: yeGzYs_pN8ehijx5KIDQnQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 222111005513;
        Wed, 26 Feb 2020 13:03:56 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D69119C7F;
        Wed, 26 Feb 2020 13:03:53 +0000 (UTC)
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
Subject: [PATCH 02/18] bpf: Add bpf_trampoline_ name prefix for DECLARE_BPF_DISPATCHER
Date:   Wed, 26 Feb 2020 14:03:29 +0100
Message-Id: <20200226130345.209469-3-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-1-jolsa@kernel.org>
References: <20200226130345.209469-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Adding bpf_trampoline_ name prefix for DECLARE_BPF_DISPATCHER,
so all the dispatchers have the common name prefix.

And also a small '_' cleanup for bpf_dispatcher_nopfunc function
name.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h    | 21 +++++++++++----------
 include/linux/filter.h |  7 +++----
 net/core/filter.c      |  5 ++---
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 49b1a70e12c8..be7afccc9459 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -512,7 +512,7 @@ struct bpf_dispatcher {
 	u32 image_off;
 };
 
-static __always_inline unsigned int bpf_dispatcher_nopfunc(
+static __always_inline unsigned int bpf_dispatcher_nop_func(
 	const void *ctx,
 	const struct bpf_insn *insnsi,
 	unsigned int (*bpf_func)(const void *,
@@ -527,7 +527,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
 #define BPF_DISPATCHER_INIT(name) {			\
 	.mutex = __MUTEX_INITIALIZER(name.mutex),	\
-	.func = &name##func,				\
+	.func = &name##_func,				\
 	.progs = {},					\
 	.num_progs = 0,					\
 	.image = NULL,					\
@@ -535,7 +535,7 @@ void bpf_trampoline_put(struct bpf_trampoline *tr);
 }
 
 #define DEFINE_BPF_DISPATCHER(name)					\
-	noinline unsigned int name##func(				\
+	noinline unsigned int bpf_dispatcher_##name##_func(		\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
 		unsigned int (*bpf_func)(const void *,			\
@@ -543,17 +543,18 @@ void bpf_trampoline_put(struct bpf_trampoline *tr);
 	{								\
 		return bpf_func(ctx, insnsi);				\
 	}								\
-	EXPORT_SYMBOL(name##func);			\
-	struct bpf_dispatcher name = BPF_DISPATCHER_INIT(name);
+	EXPORT_SYMBOL(bpf_dispatcher_##name##_func);			\
+	struct bpf_dispatcher bpf_dispatcher_##name =			\
+		BPF_DISPATCHER_INIT(bpf_dispatcher_##name);
 #define DECLARE_BPF_DISPATCHER(name)					\
-	unsigned int name##func(					\
+	unsigned int bpf_dispatcher_##name##_func(			\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
 		unsigned int (*bpf_func)(const void *,			\
 					 const struct bpf_insn *));	\
-	extern struct bpf_dispatcher name;
-#define BPF_DISPATCHER_FUNC(name) name##func
-#define BPF_DISPATCHER_PTR(name) (&name)
+	extern struct bpf_dispatcher bpf_dispatcher_##name;
+#define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_##name##_func
+#define BPF_DISPATCHER_PTR(name) (&bpf_dispatcher_##name)
 void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
 				struct bpf_prog *to);
 struct bpf_image {
@@ -579,7 +580,7 @@ static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
 #define DEFINE_BPF_DISPATCHER(name)
 #define DECLARE_BPF_DISPATCHER(name)
-#define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_nopfunc
+#define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_nop_func
 #define BPF_DISPATCHER_PTR(name) NULL
 static inline void bpf_dispatcher_change_prog(struct bpf_dispatcher *d,
 					      struct bpf_prog *from,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index f349e2c0884c..eafe72644282 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -577,7 +577,7 @@ DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 	ret; })
 
 #define BPF_PROG_RUN(prog, ctx) __BPF_PROG_RUN(prog, ctx,		\
-					       bpf_dispatcher_nopfunc)
+					       bpf_dispatcher_nop_func)
 
 #define BPF_SKB_CB_LEN QDISC_CB_PRIV_LEN
 
@@ -701,7 +701,7 @@ static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
 	return res;
 }
 
-DECLARE_BPF_DISPATCHER(bpf_dispatcher_xdp)
+DECLARE_BPF_DISPATCHER(xdp)
 
 static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 					    struct xdp_buff *xdp)
@@ -712,8 +712,7 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 	 * already takes rcu_read_lock() when fetching the program, so
 	 * it's not necessary here anymore.
 	 */
-	return __BPF_PROG_RUN(prog, xdp,
-			      BPF_DISPATCHER_FUNC(bpf_dispatcher_xdp));
+	return __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
 }
 
 void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog);
diff --git a/net/core/filter.c b/net/core/filter.c
index c180871e606d..9048453e235c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8835,10 +8835,9 @@ const struct bpf_prog_ops sk_reuseport_prog_ops = {
 };
 #endif /* CONFIG_INET */
 
-DEFINE_BPF_DISPATCHER(bpf_dispatcher_xdp)
+DEFINE_BPF_DISPATCHER(xdp)
 
 void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog)
 {
-	bpf_dispatcher_change_prog(BPF_DISPATCHER_PTR(bpf_dispatcher_xdp),
-				   prev_prog, prog);
+	bpf_dispatcher_change_prog(BPF_DISPATCHER_PTR(xdp), prev_prog, prog);
 }
-- 
2.24.1

