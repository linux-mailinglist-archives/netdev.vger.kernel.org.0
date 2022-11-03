Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671FC618A14
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiKCVA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiKCVA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:00:28 -0400
X-Greylist: delayed 1222 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Nov 2022 14:00:27 PDT
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580643896
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 14:00:27 -0700 (PDT)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 516DBC4F60D; Thu,  3 Nov 2022 13:39:54 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [RFC PATCH v1 2/2] io_uring: add api to set napi busy poll timeout.
Date:   Thu,  3 Nov 2022 13:39:39 -0700
Message-Id: <20221103203939.667307-3-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103203939.667307-1-shr@devkernel.io>
References: <20221103203939.667307-1-shr@devkernel.io>
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

This adds an api to register and unregister the busy poll timeout from
liburing. To be able to use this functionality, the corresponding
liburing patch is needed.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 include/uapi/linux/io_uring.h |  4 ++++
 io_uring/io_uring.c           | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index ab7458033ee3..48670074e1fc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -490,6 +490,10 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation *=
/
 	IORING_REGISTER_FILE_ALLOC_RANGE	=3D 25,
=20
+	/* set/clear busy poll timeout */
+	IORING_REGISTER_NAPI_BUSY_POLL_TIMEOUT	=3D 26,
+	IORING_UNREGISTER_NAPI_BUSY_POLL_TIMEOUT=3D 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f64ccd537d05..c3d277772ca0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4108,6 +4108,12 @@ static __cold int io_register_iowq_max_workers(str=
uct io_ring_ctx *ctx,
 	return ret;
 }
=20
+static int io_register_napi_busy_poll_timeout(struct io_ring_ctx *ctx, u=
nsigned int to)
+{
+	WRITE_ONCE(ctx->napi_busy_poll_to, to);
+	return 0;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -4268,6 +4274,18 @@ static int __io_uring_register(struct io_ring_ctx =
*ctx, unsigned opcode,
 			break;
 		ret =3D io_register_file_alloc_range(ctx, arg);
 		break;
+	case IORING_REGISTER_NAPI_BUSY_POLL_TIMEOUT:
+		ret =3D -EINVAL;
+		if (arg || !nr_args)
+			break;
+		ret =3D io_register_napi_busy_poll_timeout(ctx, nr_args);
+		break;
+	case IORING_UNREGISTER_NAPI_BUSY_POLL_TIMEOUT:
+		ret =3D -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret =3D io_register_napi_busy_poll_timeout(ctx, nr_args);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
--=20
2.30.2

