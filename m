Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C63632CC3
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiKUTPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiKUTPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:15:07 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C3763148
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:06 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 942E31B81310; Mon, 21 Nov 2022 11:15:00 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        ammarfaizi2@gnuweeb.org
Subject: [PATCH v5 2/4] liburing: add documentation for new napi busy polling
Date:   Mon, 21 Nov 2022 11:14:57 -0800
Message-Id: <20221121191459.998388-3-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121191459.998388-1-shr@devkernel.io>
References: <20221121191459.998388-1-shr@devkernel.io>
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

This adds two man pages for the two new functions:
- io_uring_register_nap
- io_uring_unregister_napi

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 man/io_uring_register_napi.3   | 40 ++++++++++++++++++++++++++++++++++
 man/io_uring_unregister_napi.3 | 27 +++++++++++++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100644 man/io_uring_register_napi.3
 create mode 100644 man/io_uring_unregister_napi.3

diff --git a/man/io_uring_register_napi.3 b/man/io_uring_register_napi.3
new file mode 100644
index 0000000..78eaa71
--- /dev/null
+++ b/man/io_uring_register_napi.3
@@ -0,0 +1,40 @@
+.\" Copyright (C) 2022 Stefan Roesch <shr@devkernel.io>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_register_napi 3 "November 16, 2022" "liburing-2.4" "liburin=
g Manual"
+.SH NAME
+io_uring_register_napi \- register NAPI busy poll settings
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_register_napi(struct io_uring *" ring ","
+.BI "                           struct io_uring_napi *" napi)
+.PP
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_register_napi (3)
+function registers the NAPI settings for subsequent operations. The NAPI
+settings are specified in the structure that is passed in the
+.I napi
+parameter. The structure consists of the napi timeout
+.I busy_poll_to
+(napi busy poll timeout in us) and
+.I prefer_busy_poll.
+
+Registering a NAPI settings sets the mode when calling the function
+napi_busy_loop and corresponds to the SO_PREFER_BUSY_POLL socket
+option.
+
+NAPI busy poll can reduce the network roundtrip time.
+
+
+.SH RETURN VALUE
+On success
+.BR io_uring_register_napi (3)
+return 0. On failure they return
+.BR -errno .
+It also updates the napi structure with the current values.
diff --git a/man/io_uring_unregister_napi.3 b/man/io_uring_unregister_nap=
i.3
new file mode 100644
index 0000000..f7087ef
--- /dev/null
+++ b/man/io_uring_unregister_napi.3
@@ -0,0 +1,27 @@
+.\" Copyright (C) 2022 Stefan Roesch <shr@devkernel.io>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_unregister_napi 3 "November 16, 2022" "liburing-2.4" "libur=
ing Manual"
+.SH NAME
+io_uring_unregister_napi \- unregister NAPI busy poll settings
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_unregister_napi(struct io_uring *" ring ","
+.BI "                             struct io_uring_napi *" napi)
+.PP
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_unregister_napi (3)
+function unregisters the NAPI busy poll settings for subsequent operatio=
ns.
+
+.SH RETURN VALUE
+On success
+.BR io_uring_unregister_napi (3)
+return 0. On failure they return
+.BR -errno .
+It also updates the napi structure with the current values.
--=20
2.30.2

