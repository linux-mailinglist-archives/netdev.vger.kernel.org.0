Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF5F632AFC
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiKURaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiKURaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:30:09 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6FDC67CC
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:30:07 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id AD0C71B6D6B0; Mon, 21 Nov 2022 09:29:55 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [RFC PATCH v4 2/3] io_uring: add api to set / get napi configuration.
Date:   Mon, 21 Nov 2022 09:29:52 -0800
Message-Id: <20221121172953.4030697-3-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121172953.4030697-1-shr@devkernel.io>
References: <20221121172953.4030697-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds an api to register the busy poll timeout from liburing. To be
able to use this functionality, the corresponding liburing patch is neede=
d.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 include/linux/io_uring_types.h |  2 +-
 include/uapi/linux/io_uring.h  | 11 +++++++
 io_uring/io_uring.c            | 54 ++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 23993b5d3186..67b861305d97 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -274,8 +274,8 @@ struct io_ring_ctx {
 	struct list_head	napi_list;	/* track busy poll napi_id */
 	spinlock_t		napi_lock;	/* napi_list lock */
=20
-	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
 	bool			napi_prefer_busy_poll;
+	unsigned int		napi_busy_poll_to;
 #endif
=20
 	struct {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 2df3225b562f..1a713bbafaee 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -490,6 +490,10 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation *=
/
 	IORING_REGISTER_FILE_ALLOC_RANGE	=3D 25,
=20
+	/* set/clear busy poll settings */
+	IORING_REGISTER_NAPI			=3D 26,
+	IORING_UNREGISTER_NAPI			=3D 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -612,6 +616,13 @@ struct io_uring_buf_reg {
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
index 4f432694cbed..cf0e7cc8ad2e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4122,6 +4122,48 @@ static __cold int io_register_iowq_max_workers(str=
uct io_ring_ctx *ctx,
 	return ret;
 }
=20
+static int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
+{
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	const struct io_uring_napi curr =3D {
+		.busy_poll_to =3D ctx->napi_busy_poll_to,
+	};
+	struct io_uring_napi *napi;
+
+	napi =3D memdup_user(arg, sizeof(*napi));
+	if (IS_ERR(napi))
+		return PTR_ERR(napi);
+
+	WRITE_ONCE(ctx->napi_busy_poll_to, napi->busy_poll_to);
+
+	kfree(napi);
+
+	if (copy_to_user(arg, &curr, sizeof(curr)))
+		return -EFAULT;
+
+	return 0;
+#else
+	return -EINVAL;
+#endif
+}
+
+static int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
+{
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	const struct io_uring_napi curr =3D {
+		.busy_poll_to =3D ctx->napi_busy_poll_to,
+	};
+
+	if (copy_to_user(arg, &curr, sizeof(curr)))
+		return -EFAULT;
+
+	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
+	return 0;
+#else
+	return -EINVAL;
+#endif
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -4282,6 +4324,18 @@ static int __io_uring_register(struct io_ring_ctx =
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
+		ret =3D -EINVAL;
+		if (!arg)
+			break;
+		ret =3D io_unregister_napi(ctx, arg);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
--=20
2.30.2

