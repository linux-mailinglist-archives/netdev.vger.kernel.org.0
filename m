Return-Path: <netdev+bounces-3762-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B71A708A48
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 23:18:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47F59281A12
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 21:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219161F164;
	Thu, 18 May 2023 21:18:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072011EA96
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 21:18:10 +0000 (UTC)
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4151E4D
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 14:18:09 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
	id DB4875B1A66A; Thu, 18 May 2023 14:17:56 -0700 (PDT)
From: Stefan Roesch <shr@devkernel.io>
To: io-uring@vger.kernel.org,
	kernel-team@fb.com
Cc: shr@devkernel.io,
	axboe@kernel.dk,
	ammarfaizi2@gnuweeb.org,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	olivier@trillion01.com
Subject: [PATCH v13 6/7] io_uring: add register/unregister napi function
Date: Thu, 18 May 2023 14:17:50 -0700
Message-Id: <20230518211751.3492982-7-shr@devkernel.io>
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

This adds an api to register and unregister the napi for io-uring. If
the arg value is specified when unregistering, the current napi setting
for the busy poll timeout is copied into the user structure. If this is
not required, NULL can be passed as the arg value.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/io_uring.h | 11 ++++++++
 io_uring/io_uring.c           |  9 +++++++
 io_uring/napi.c               | 48 +++++++++++++++++++++++++++++++++++
 io_uring/napi.h               | 13 ++++++++++
 4 files changed, 81 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 0716cb17e436..278c1a9de78c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -523,6 +523,10 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation *=
/
 	IORING_REGISTER_FILE_ALLOC_RANGE	=3D 25,
=20
+	/* set/clear busy poll settings */
+	IORING_REGISTER_NAPI			=3D 26,
+	IORING_UNREGISTER_NAPI			=3D 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
=20
@@ -649,6 +653,13 @@ struct io_uring_buf_reg {
 	__u64	resv[3];
 };
=20
+/* argument for IORING_(UN)REGISTER_NAPI */
+struct io_uring_napi {
+	__u32	busy_poll_to;
+	__u32	pad;
+	__u64	resv;
+};
+
 /*
  * io_uring_restriction->opcode values
  */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f06175b36b41..66e4591fbe2b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4405,6 +4405,15 @@ static int __io_uring_register(struct io_ring_ctx =
*ctx, unsigned opcode,
 			break;
 		ret =3D io_register_file_alloc_range(ctx, arg);
 		break;
+	case IORING_REGISTER_NAPI:
+		ret =3D -EINVAL;
+		if (!arg)
+			break;
+		ret =3D io_register_napi(ctx, arg);
+		break;
+	case IORING_UNREGISTER_NAPI:
+		ret =3D io_unregister_napi(ctx, arg);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 9aaeea51250f..5d5330d66201 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -212,6 +212,54 @@ void io_napi_free(struct io_ring_ctx *ctx)
 	spin_unlock(&ctx->napi_lock);
 }
=20
+/*
+ * io_napi_register() - Register napi with io-uring
+ * @ctx: pointer to io-uring context structure
+ * @arg: pointer to io_uring_napi structure
+ *
+ * Register napi in the io-uring context.
+ */
+int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
+{
+	const struct io_uring_napi curr =3D {
+		.busy_poll_to =3D ctx->napi_busy_poll_to,
+	};
+	struct io_uring_napi napi;
+
+	if (copy_from_user(&napi, arg, sizeof(napi)))
+		return -EFAULT;
+	if (napi.pad || napi.resv)
+		return -EINVAL;
+
+	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
+
+	if (copy_to_user(arg, &curr, sizeof(curr)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * io_napi_unregister() - Unregister napi with io-uring
+ * @ctx: pointer to io-uring context structure
+ * @arg: pointer to io_uring_napi structure
+ *
+ * Unregister napi. If arg has been specified copy the busy poll timeout=
 and
+ * prefer busy poll setting to the passed in structure.
+ */
+int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
+{
+	const struct io_uring_napi curr =3D {
+		.busy_poll_to =3D ctx->napi_busy_poll_to,
+	};
+
+	if (arg && copy_to_user(arg, &curr, sizeof(curr)))
+		return -EFAULT;
+
+	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
+	return 0;
+}
+
 /*
  * __io_napi_adjust_timeout() - Add napi id to the busy poll list
  * @ctx: pointer to io-uring context structure
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 945d3c8c201d..69c1970cbecc 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -12,6 +12,9 @@
 void io_napi_init(struct io_ring_ctx *ctx);
 void io_napi_free(struct io_ring_ctx *ctx);
=20
+int io_register_napi(struct io_ring_ctx *ctx, void __user *arg);
+int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
+
 void __io_napi_add(struct io_ring_ctx *ctx, struct file *file);
=20
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
@@ -67,6 +70,16 @@ static inline void io_napi_free(struct io_ring_ctx *ct=
x)
 {
 }
=20
+static inline int io_register_napi(struct io_ring_ctx *ctx, void __user =
*arg)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int io_unregister_napi(struct io_ring_ctx *ctx, void __use=
r *arg)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline bool io_napi(struct io_ring_ctx *ctx)
 {
 	return false;
--=20
2.39.1


