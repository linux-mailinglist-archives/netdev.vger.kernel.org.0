Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F79618A2C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiKCVFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiKCVFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:05:19 -0400
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB35526E0
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 14:05:18 -0700 (PDT)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 52B2FC4F6B5; Thu,  3 Nov 2022 13:40:23 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [RFC PATCH v1 1/3] liburing: add api to set napi busy poll timeout
Date:   Thu,  3 Nov 2022 13:40:15 -0700
Message-Id: <20221103204017.670757-2-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103204017.670757-1-shr@devkernel.io>
References: <20221103204017.670757-1-shr@devkernel.io>
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

This adds the two functions to register and unregister the napi busy
poll timeout:
- io_uring_register_busy_poll_timeout
- io_uring_unregister_busy_poll_timeout

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 src/include/liburing.h          |  3 +++
 src/include/liburing/io_uring.h |  4 ++++
 src/register.c                  | 12 ++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 12a703f..ef2510e 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -235,6 +235,9 @@ int io_uring_register_sync_cancel(struct io_uring *ri=
ng,
 int io_uring_register_file_alloc_range(struct io_uring *ring,
 					unsigned off, unsigned len);
=20
+int io_uring_register_busy_poll_timeout(struct io_uring *ring, unsigned =
int to);
+int io_uring_unregister_busy_poll_timeout(struct io_uring *ring);
+
 int io_uring_get_events(struct io_uring *ring);
 int io_uring_submit_and_get_events(struct io_uring *ring);
=20
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index a3e0920..0919d9e 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -499,6 +499,10 @@ enum {
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
diff --git a/src/register.c b/src/register.c
index e849825..c18e072 100644
--- a/src/register.c
+++ b/src/register.c
@@ -367,3 +367,15 @@ int io_uring_register_file_alloc_range(struct io_uri=
ng *ring,
 				       IORING_REGISTER_FILE_ALLOC_RANGE, &range,
 				       0);
 }
+
+int io_uring_register_busy_poll_timeout(struct io_uring *ring, unsigned =
int to)
+{
+	return __sys_io_uring_register(ring->ring_fd,
+				IORING_REGISTER_NAPI_BUSY_POLL_TIMEOUT, NULL, to);
+}
+
+int io_uring_unregister_busy_poll_timeout(struct io_uring *ring)
+{
+	return __sys_io_uring_register(ring->ring_fd,
+				IORING_UNREGISTER_NAPI_BUSY_POLL_TIMEOUT, NULL, 0);
+}
--=20
2.30.2

