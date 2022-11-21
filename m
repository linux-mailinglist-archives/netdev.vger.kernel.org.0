Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3006632CC1
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiKUTPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiKUTO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:14:56 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFF413DC6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:14:56 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 203F91B812B1; Mon, 21 Nov 2022 11:14:39 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [PATCH v5 2/3] io_uring: add api to set / get napi configuration.
Date:   Mon, 21 Nov 2022 11:14:36 -0800
Message-Id: <20221121191437.996297-3-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121191437.996297-1-shr@devkernel.io>
References: <20221121191437.996297-1-shr@devkernel.io>
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
 include/uapi/linux/io_uring.h | 11 ++++++++
 io_uring/io_uring.c           | 53 +++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

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
index 6d7c05fa3c80..d8790c1b1cfb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4122,6 +4122,47 @@ static __cold int io_register_iowq_max_workers(str=
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
@@ -4282,6 +4323,18 @@ static int __io_uring_register(struct io_ring_ctx =
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

