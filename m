Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10F3629232
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiKOHJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiKOHJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:09:27 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FDFFCC6
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:09:19 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 79C9915F0F6D; Mon, 14 Nov 2022 23:09:07 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [RFC PATCH v3 3/3] io_uring: add api to set napi prefer busy poll
Date:   Mon, 14 Nov 2022 23:09:00 -0800
Message-Id: <20221115070900.1788837-4-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221115070900.1788837-1-shr@devkernel.io>
References: <20221115070900.1788837-1-shr@devkernel.io>
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

This adds an api to register and unregister the napi prefer busy poll
setting from liburing. To be able to use this functionality, the
corresponding liburing patch is needed.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 include/uapi/linux/io_uring.h |  3 ++-
 io_uring/io_uring.c           | 17 +++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 9b5c1df0d1d8..25b91a4dc103 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -490,7 +490,8 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation *=
/
 	IORING_REGISTER_FILE_ALLOC_RANGE	=3D 25,
=20
-	/* set/clear busy poll timeout */
+	/* set/clear busy poll settings */
+	IORING_REGISTER_NAPI_PREFER_BUSY_POLL	=3D 26,
 	IORING_REGISTER_NAPI_BUSY_POLL_TIMEOUT	=3D 27,
=20
 	/* this goes last */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f6c9c9cbe0f8..eca9f7540123 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4122,6 +4122,17 @@ static __cold int io_register_iowq_max_workers(str=
uct io_ring_ctx *ctx,
 	return ret;
 }
=20
+static int io_register_napi_prefer_busy_poll(struct io_ring_ctx *ctx,
+					     unsigned int prefer_napi)
+{
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!prefer_napi);
+	return 0;
+#else
+	return -EINVAL;
+#endif
+}
+
 static int io_register_napi_busy_poll_timeout(struct io_ring_ctx *ctx, u=
nsigned int to)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
@@ -4292,6 +4303,12 @@ static int __io_uring_register(struct io_ring_ctx =
*ctx, unsigned opcode,
 			break;
 		ret =3D io_register_file_alloc_range(ctx, arg);
 		break;
+	case IORING_REGISTER_NAPI_PREFER_BUSY_POLL:
+		ret =3D -EINVAL;
+		if (arg || !nr_args)
+			break;
+		ret =3D io_register_napi_prefer_busy_poll(ctx, nr_args);
+		break;
 	case IORING_REGISTER_NAPI_BUSY_POLL_TIMEOUT:
 		ret =3D -EINVAL;
 		if (arg || !nr_args)
--=20
2.30.2

