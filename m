Return-Path: <netdev+bounces-3763-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A624A708A4A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 23:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CCAC1C211AC
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 21:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52AD61EA96;
	Thu, 18 May 2023 21:18:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474FC23C78
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 21:18:13 +0000 (UTC)
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A60E45
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 14:18:12 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
	id D11ED5B1A668; Thu, 18 May 2023 14:17:56 -0700 (PDT)
From: Stefan Roesch <shr@devkernel.io>
To: io-uring@vger.kernel.org,
	kernel-team@fb.com
Cc: shr@devkernel.io,
	axboe@kernel.dk,
	ammarfaizi2@gnuweeb.org,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	olivier@trillion01.com
Subject: [PATCH v13 5/7] io-uring: add sqpoll support for napi busy poll
Date: Thu, 18 May 2023 14:17:49 -0700
Message-Id: <20230518211751.3492982-6-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230518211751.3492982-1-shr@devkernel.io>
References: <20230518211751.3492982-1-shr@devkernel.io>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
	SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This adds the sqpoll support to the io-uring napi.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Suggested-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/napi.c   | 24 ++++++++++++++++++++++++
 io_uring/napi.h   |  2 ++
 io_uring/sqpoll.c |  4 ++++
 3 files changed, 30 insertions(+)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 54d66dd3119f..9aaeea51250f 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -257,4 +257,28 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, st=
ruct io_wait_queue *iowq)
 		io_napi_blocking_busy_loop(ctx, iowq);
 }
=20
+/*
+ * io_napi_sqpoll_busy_poll() - busy poll loop for sqpoll
+ * @ctx: pointer to io-uring context structure
+ *
+ * Splice of the napi list and execute the napi busy poll loop.
+ */
+int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
+{
+	LIST_HEAD(napi_list);
+	bool is_stale =3D false;
+
+	if (!READ_ONCE(ctx->napi_busy_poll_to))
+		return 0;
+	if (list_empty_careful(&ctx->napi_list))
+		return 0;
+
+	rcu_read_lock();
+	is_stale =3D __io_napi_do_busy_loop(ctx, NULL);
+	rcu_read_unlock();
+
+	io_napi_remove_stale(ctx, is_stale);
+	return 1;
+}
+
 #endif
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 1bdf8442081f..945d3c8c201d 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -17,6 +17,7 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct file=
 *file);
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
 		struct io_wait_queue *iowq, struct timespec64 *ts);
 void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *=
iowq);
+int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx);
=20
 static inline bool io_napi(struct io_ring_ctx *ctx)
 {
@@ -77,6 +78,7 @@ static inline void io_napi_add(struct io_kiocb *req)
=20
 #define io_napi_adjust_timeout(ctx, iowq, ts) do {} while (0)
 #define io_napi_busy_loop(ctx, iowq) do {} while (0)
+#define io_napi_sqpoll_busy_poll(ctx) do {} while (0)
=20
 #endif
=20
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 9db4bc1f521a..0c8d53ef134a 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -15,6 +15,7 @@
 #include <uapi/linux/io_uring.h>
=20
 #include "io_uring.h"
+#include "napi.h"
 #include "sqpoll.h"
=20
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
@@ -193,6 +194,9 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bo=
ol cap_entries)
 			ret =3D io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
=20
+		if (io_napi(ctx))
+			ret +=3D io_napi_sqpoll_busy_poll(ctx);
+
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
 		if (creds)
--=20
2.39.1


