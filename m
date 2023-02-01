Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0DA68711B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 23:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjBAWm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 17:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjBAWm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 17:42:26 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8D2244B8
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 14:42:25 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id CF82960FCABC; Wed,  1 Feb 2023 14:23:25 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [PATCH v6 3/3] io_uring: add api to set napi prefer busy poll
Date:   Wed,  1 Feb 2023 14:22:54 -0800
Message-Id: <20230201222254.744422-4-shr@devkernel.io>
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

This adds an api to register and unregister the napi prefer busy poll
setting from liburing. To be able to use this functionality, the
corresponding liburing patch is needed.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/io_uring.h | 3 ++-
 io_uring/io_uring.c           | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index fce4533c81c3..e166bbe5bad8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -645,7 +645,8 @@ struct io_uring_buf_reg {
 /* argument for IORING_(UN)REGISTER_NAPI */
 struct io_uring_napi {
 	__u32	busy_poll_to;
-	__u32	pad;
+	__u8	prefer_busy_poll;
+	__u8	pad[3];
 	__u64	resv;
 };
=20
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f2509f0afc7b..90dac6c001ac 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4251,15 +4251,17 @@ static int io_register_napi(struct io_ring_ctx *c=
tx, void __user *arg)
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	const struct io_uring_napi curr =3D {
 		.busy_poll_to =3D ctx->napi_busy_poll_to,
+		.prefer_busy_poll =3D ctx->napi_prefer_busy_poll
 	};
 	struct io_uring_napi napi;
=20
 	if (copy_from_user(&napi, arg, sizeof(napi)))
 		return -EFAULT;
-	if (napi.pad || napi.resv)
+	if (napi.pad[0] || napi.pad[1] || napi.pad[2] || napi.resv)
 		return -EINVAL;
=20
 	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
+	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
=20
 	if (copy_to_user(arg, &curr, sizeof(curr)))
 		return -EFAULT;
@@ -4275,6 +4277,7 @@ static int io_unregister_napi(struct io_ring_ctx *c=
tx, void __user *arg)
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	const struct io_uring_napi curr =3D {
 		.busy_poll_to =3D ctx->napi_busy_poll_to,
+		.prefer_busy_poll =3D ctx->napi_prefer_busy_poll
 	};
=20
 	if (arg) {
@@ -4283,6 +4286,7 @@ static int io_unregister_napi(struct io_ring_ctx *c=
tx, void __user *arg)
 	}
=20
 	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
+	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
 	return 0;
 #else
 	return -EINVAL;
--=20
2.30.2

