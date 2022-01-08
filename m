Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C407148866B
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbiAHVoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbiAHVoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B40BC06175A
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:10 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVQ-0004fT-KT
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:44:08 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 169E16D3AA8
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CAC9E6D3A3B;
        Sat,  8 Jan 2022 21:43:49 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f4fbe80c;
        Sat, 8 Jan 2022 21:43:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 22/22] docs: networking: device drivers: can: add flexcan
Date:   Sat,  8 Jan 2022 22:43:45 +0100
Message-Id: <20220108214345.1848470-23-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108214345.1848470-1-mkl@pengutronix.de>
References: <20220108214345.1848470-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

Add initial documentation for Flexcan driver.

Link: https://lore.kernel.org/all/20220107193105.1699523-8-mkl@pengutronix.de
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../device_drivers/can/freescale/flexcan.rst  | 54 +++++++++++++++++++
 .../networking/device_drivers/can/index.rst   |  2 +
 2 files changed, 56 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/can/freescale/flexcan.rst

diff --git a/Documentation/networking/device_drivers/can/freescale/flexcan.rst b/Documentation/networking/device_drivers/can/freescale/flexcan.rst
new file mode 100644
index 000000000000..4e3eec6cecd2
--- /dev/null
+++ b/Documentation/networking/device_drivers/can/freescale/flexcan.rst
@@ -0,0 +1,54 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+=============================
+Flexcan CAN Controller driver
+=============================
+
+Authors: Marc Kleine-Budde <mkl@pengutronix.de>,
+Dario Binacchi <dario.binacchi@amarula.solutions.com>
+
+On/off RTR frames reception
+===========================
+
+For most flexcan IP cores the driver supports 2 RX modes:
+
+- FIFO
+- mailbox
+
+The older flexcan cores (integrated into the i.MX25, i.MX28, i.MX35
+and i.MX53 SOCs) only receive RTR frames if the controller is
+configured for RX-FIFO mode.
+
+The RX FIFO mode uses a hardware FIFO with a depth of 6 CAN frames,
+while the mailbox mode uses a software FIFO with a depth of up to 62
+CAN frames. With the help of the bigger buffer, the mailbox mode
+performs better under high system load situations.
+
+As reception of RTR frames is part of the CAN standard, all flexcan
+cores come up in a mode where RTR reception is possible.
+
+With the "rx-rtr" private flag the ability to receive RTR frames can
+be waived at the expense of losing the ability to receive RTR
+messages. This trade off is beneficial in certain use cases.
+
+"rx-rtr" on
+  Receive RTR frames. (default)
+
+  The CAN controller can and will receive RTR frames.
+
+  On some IP cores the controller cannot receive RTR frames in the
+  more performant "RX mailbox" mode and will use "RX FIFO" mode
+  instead.
+
+"rx-rtr" off
+
+  Waive ability to receive RTR frames. (not supported on all IP cores)
+
+  This mode activates the "RX mailbox mode" for better performance, on
+  some IP cores RTR frames cannot be received anymore.
+
+The setting can only be changed if the interface is down::
+
+    ip link set dev can0 down
+    ethtool --set-priv-flags can0 rx-rtr {off|on}
+    ip link set dev can0 up
diff --git a/Documentation/networking/device_drivers/can/index.rst b/Documentation/networking/device_drivers/can/index.rst
index 218276818968..58b6e0ad3030 100644
--- a/Documentation/networking/device_drivers/can/index.rst
+++ b/Documentation/networking/device_drivers/can/index.rst
@@ -10,6 +10,8 @@ Contents:
 .. toctree::
    :maxdepth: 2
 
+   freescale/flexcan
+
 .. only::  subproject and html
 
    Indices
-- 
2.34.1


