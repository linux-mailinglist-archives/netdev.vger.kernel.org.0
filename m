Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06BA629237
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiKOHJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbiKOHJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:09:52 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5226A1FFA1
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:09:44 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 24A3D15F1109; Mon, 14 Nov 2022 23:09:35 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        ammarfaizi2@gnuweeb.org
Subject: [RFC PATCH v3 2/4] liburing: add documentation for new napi busy polling
Date:   Mon, 14 Nov 2022 23:09:31 -0800
Message-Id: <20221115070933.1792142-3-shr@devkernel.io>
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

This adds two man pages for the two new functions:
- io_uring_register_napi_busy_poll_timeout
- io_uring_unregister_napi_busy_poll_timeout

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 ...io_uring_register_napi_busy_poll_timeout.3 | 35 +++++++++++++++++++
 man/io_uring_register_napi_prefer_busy_poll.3 | 35 +++++++++++++++++++
 ..._uring_unregister_napi_busy_poll_timeout.3 | 26 ++++++++++++++
 3 files changed, 96 insertions(+)
 create mode 100644 man/io_uring_register_napi_busy_poll_timeout.3
 create mode 100644 man/io_uring_register_napi_prefer_busy_poll.3
 create mode 100644 man/io_uring_unregister_napi_busy_poll_timeout.3

diff --git a/man/io_uring_register_napi_busy_poll_timeout.3 b/man/io_urin=
g_register_napi_busy_poll_timeout.3
new file mode 100644
index 0000000..3acce60
--- /dev/null
+++ b/man/io_uring_register_napi_busy_poll_timeout.3
@@ -0,0 +1,35 @@
+.\" Copyright (C) 2022 Stefan Roesch <shr@devkernel.io>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_register_napi_busy_poll_timeout 3 "November 10, 2022" "libu=
ring-2.4" "liburing Manual"
+.SH NAME
+io_uring_register_napi_busy_poll_timeout \- register NAPI busy poll time=
out
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_register_napi_busy_poll_timeout(struct io_uring *" rin=
g ","
+.BI "                                             unsigned int " timeout=
)
+.PP
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_register_napi_busy_poll_timeout (3)
+function registers the NAPI busy poll
+.I timeout
+for subsequent operations.
+
+Registering a NAPI busy poll timeout is a requirement to be able to use
+NAPI busy polling. The other way to enable NAPI busy polling is to set t=
he
+proc setting /proc/sys/net/core/busy_poll.
+
+NAPI busy poll can reduce the network roundtrip time.
+
+
+.SH RETURN VALUE
+On success
+.BR io_uring_register_napi_busy_poll_timeout (3)
+return 0. On failure they return
+.BR -errno .
diff --git a/man/io_uring_register_napi_prefer_busy_poll.3 b/man/io_uring=
_register_napi_prefer_busy_poll.3
new file mode 100644
index 0000000..713840e
--- /dev/null
+++ b/man/io_uring_register_napi_prefer_busy_poll.3
@@ -0,0 +1,35 @@
+.\" Copyright (C) 2022 Stefan Roesch <shr@devkernel.io>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_register_napi_prefer_busy_poll 3 "November 11, 2022" "libur=
ing-2.4" "liburing Manual"
+.SH NAME
+io_uring_register_napi_prefer_busy_poll \- register NAPI prefer busy pol=
l setting
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_register_napi_prefer_busy_poll(struct io_uring *" ring=
 ","
+.BI "                                            bool " prefer_busy_poll=
)
+.PP
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_register_napi_prefer_busy_poll (3)
+function registers the NAPI
+.I prefer_busy_poll
+for subsequent operations.
+
+Registering a NAPI prefer busy poll seeting sets the mode when calling t=
he
+function napi_busy_loop and corresponds to the SO_PREFER_BUSY_POLL socke=
t
+option.
+
+NAPI prefer busy poll can help in reducng the network roundtrip time.
+
+
+.SH RETURN VALUE
+On success
+.BR io_uring_register_napi_prefer_busy_poll (3)
+return 0. On failure they return
+.BR -errno .
diff --git a/man/io_uring_unregister_napi_busy_poll_timeout.3 b/man/io_ur=
ing_unregister_napi_busy_poll_timeout.3
new file mode 100644
index 0000000..666e006
--- /dev/null
+++ b/man/io_uring_unregister_napi_busy_poll_timeout.3
@@ -0,0 +1,26 @@
+.\" Copyright (C) 2022 Stefan Roesch <shr@devkernel.io>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_unregister_napi_busy_poll_timeout 3 "November 10, 2022" "li=
buring-2.4" "liburing Manual"
+.SH NAME
+io_uring_unregister_napi_busy_poll_timeout \- unregister NAPI busy poll =
timeout
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_unregister_napi_busy_poll_timeout(struct io_uring *" r=
ing ")
+.PP
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_unregister_napi_busy_poll_timeout (3)
+function unregisters the NAPI busy poll
+for subsequent operations.
+
+.SH RETURN VALUE
+On success
+.BR io_uring_unregister_napi_busy_poll_timeout (3)
+return 0. On failure they return
+.BR -errno .
--=20
2.30.2

