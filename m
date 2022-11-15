Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D068629230
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiKOHJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbiKOHJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:09:27 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04BAFCE9
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:09:23 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 759E015F0F6B; Mon, 14 Nov 2022 23:09:07 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [RFC PATCH v3 2/3] io_uring: add api to set napi busy poll timeout.
Date:   Mon, 14 Nov 2022 23:08:59 -0800
Message-Id: <20221115070900.1788837-3-shr@devkernel.io>
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

This adds an api to register the busy poll timeout from liburing. To be
able to use this functionality, the corresponding liburing patch is neede=
d.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 include/uapi/linux/io_uring.h |  3 +++
 io_uring/io_uring.c           | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 2df3225b562f..9b5c1df0d1d8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -490,6 +490,9 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation *=
/
 	IORING_REGISTER_FILE_ALLOC_RANGE	=3D 25,
=20
+	/* set/clear busy poll timeout */
+	IORING_REGISTER_NAPI_BUSY_POLL_TIMEOUT	=3D 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4f432694cbed..f6c9c9cbe0f8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4122,6 +4122,16 @@ static __cold int io_register_iowq_max_workers(str=
uct io_ring_ctx *ctx,
 	return ret;
 }
=20
+static int io_register_napi_busy_poll_timeout(struct io_ring_ctx *ctx, u=
nsigned int to)
+{
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	WRITE_ONCE(ctx->napi_busy_poll_to, to);
+	return 0;
+#else
+	return -EINVAL;
+#endif
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -4282,6 +4292,12 @@ static int __io_uring_register(struct io_ring_ctx =
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
 	default:
 		ret =3D -EINVAL;
 		break;
--=20
2.30.2

