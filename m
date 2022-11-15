Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0B862923C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiKOHKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiKOHJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:09:54 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7659E20352
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:09:45 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 2098915F1107; Mon, 14 Nov 2022 23:09:35 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        ammarfaizi2@gnuweeb.org
Subject: [RFC PATCH v3 1/4] liburing: add api to set napi busy poll settings
Date:   Mon, 14 Nov 2022 23:09:30 -0800
Message-Id: <20221115070933.1792142-2-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221115070933.1792142-1-shr@devkernel.io>
References: <20221115070933.1792142-1-shr@devkernel.io>
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

This adds three functions to manage the napi busy poll settings:
- io_uring_register_napi_busy_poll_timeout
- io_uring_unregister_napi_busy_poll_timeout
- io_uring_register_napi_prefer_busy_poll

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 src/include/liburing.h          |  6 ++++++
 src/include/liburing/io_uring.h |  4 ++++
 src/liburing.map                |  7 +++++++
 src/register.c                  | 23 +++++++++++++++++++++++
 4 files changed, 40 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 12a703f..47bbced 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -235,6 +235,12 @@ int io_uring_register_sync_cancel(struct io_uring *r=
ing,
 int io_uring_register_file_alloc_range(struct io_uring *ring,
 					unsigned off, unsigned len);
=20
+int io_uring_register_napi_prefer_busy_poll(struct io_uring *ring,
+					    bool prefer_busy_poll);
+int io_uring_register_napi_busy_poll_timeout(struct io_uring *ring,
+					     unsigned int to);
+int io_uring_unregister_napi_busy_poll_timeout(struct io_uring *ring);
+
 int io_uring_get_events(struct io_uring *ring);
 int io_uring_submit_and_get_events(struct io_uring *ring);
=20
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index a3e0920..2e53f52 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -499,6 +499,10 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation *=
/
 	IORING_REGISTER_FILE_ALLOC_RANGE	=3D 25,
=20
+	/* set/clear busy poll settings */
+	IORING_REGISTER_NAPI_PREFER_BUSY_POLL	=3D 26,
+	IORING_REGISTER_NAPI_BUSY_POLL_TIMEOUT	=3D 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
diff --git a/src/liburing.map b/src/liburing.map
index 06c64f8..2e41a40 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -67,3 +67,10 @@ LIBURING_2.3 {
 		io_uring_get_events;
 		io_uring_submit_and_get_events;
 } LIBURING_2.2;
+
+LIBURING_2.4 {
+	global:
+		io_uring_napi_register_prefer_busy_poll;
+		io_uring_napi_register_busy_poll_timeout;
+		io_uring_napi_unregister_busy_poll_timeout;
+} LIBURING_2.3;
diff --git a/src/register.c b/src/register.c
index e849825..50250b8 100644
--- a/src/register.c
+++ b/src/register.c
@@ -367,3 +367,26 @@ int io_uring_register_file_alloc_range(struct io_uri=
ng *ring,
 				       IORING_REGISTER_FILE_ALLOC_RANGE, &range,
 				       0);
 }
+
+int io_uring_register_napi_prefer_busy_poll(struct io_uring *ring,
+					    bool prefer_busy_poll)
+{
+	return __sys_io_uring_register(ring->ring_fd,
+				IORING_REGISTER_NAPI_PREFER_BUSY_POLL,
+				NULL, prefer_busy_poll);
+}
+
+int io_uring_register_napi_busy_poll_timeout(struct io_uring *ring,
+					     unsigned int to)
+{
+	return __sys_io_uring_register(ring->ring_fd,
+				IORING_REGISTER_NAPI_BUSY_POLL_TIMEOUT,
+				NULL, to);
+}
+
+int io_uring_unregister_napi_busy_poll_timeout(struct io_uring *ring)
+{
+	return __sys_io_uring_register(ring->ring_fd,
+				IORING_REGISTER_NAPI_BUSY_POLL_TIMEOUT,
+				NULL, 0);
+}
--=20
2.30.2

