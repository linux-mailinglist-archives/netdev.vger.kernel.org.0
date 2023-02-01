Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE7B687114
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 23:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjBAWkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 17:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjBAWj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 17:39:59 -0500
X-Greylist: delayed 979 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Feb 2023 14:39:57 PST
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B112E2916C
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 14:39:56 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id CABA360FCABA; Wed,  1 Feb 2023 14:23:25 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [PATCH v6 2/3] io_uring: add api to set / get napi configuration.
Date:   Wed,  1 Feb 2023 14:22:53 -0800
Message-Id: <20230201222254.744422-3-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230201222254.744422-1-shr@devkernel.io>
References: <20230201222254.744422-1-shr@devkernel.io>
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
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/io_uring.h | 11 +++++++
 io_uring/io_uring.c           | 55 +++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 2780bce62faf..fce4533c81c3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -516,6 +516,10 @@ enum {
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
@@ -638,6 +642,13 @@ struct io_uring_buf_reg {
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
index 96062036db41..f2509f0afc7b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4246,6 +4246,49 @@ static __cold int io_register_iowq_max_workers(str=
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
+	if (arg) {
+		if (copy_to_user(arg, &curr, sizeof(curr)))
+			return -EFAULT;
+	}
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
@@ -4404,6 +4447,18 @@ static int __io_uring_register(struct io_ring_ctx =
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

