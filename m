Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE26C2BAB2B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgKTNdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgKTNdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D545C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:23 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XR-0006Fn-6F; Fri, 20 Nov 2020 14:33:21 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Yegor Yefremov <yegorslists@googlemail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 01/25] can: j1939: add tables for the CAN identifier and its fields
Date:   Fri, 20 Nov 2020 14:32:54 +0100
Message-Id: <20201120133318.3428231-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

Use table markup to show the structure of the CAN identifier, PGN, PDU1, and
PDU2 formats. Also add introductory sentence.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Link: https://lore.kernel.org/r/20201104155730.25196-1-yegorslists@googlemail.com
[mkl: removed trailing whitespace]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/j1939.rst | 46 +++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index 0a4b73b03b99..b705d2801e9c 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -69,18 +69,56 @@ J1939 concepts
 PGN
 ---
 
+The J1939 protocol uses the 29-bit CAN identifier with the following structure:
+
+  ============  ==============  ====================
+  29 bit CAN-ID
+  --------------------------------------------------
+  Bit positions within the CAN-ID
+  --------------------------------------------------
+  28 ... 26     25 ... 8        7 ... 0
+  ============  ==============  ====================
+  Priority      PGN             SA (Source Address)
+  ============  ==============  ====================
+
 The PGN (Parameter Group Number) is a number to identify a packet. The PGN
 is composed as follows:
-1 bit  : Reserved Bit
-1 bit  : Data Page
-8 bits : PF (PDU Format)
-8 bits : PS (PDU Specific)
+
+  ============  ==============  =================  =================
+  PGN
+  ------------------------------------------------------------------
+  Bit positions within the CAN-ID
+  ------------------------------------------------------------------
+  25            24              23 ... 16          15 ... 8
+  ============  ==============  =================  =================
+  R (Reserved)  DP (Data Page)  PF (PDU Format)    PS (PDU Specific)
+  ============  ==============  =================  =================
 
 In J1939-21 distinction is made between PDU1 format (where PF < 240) and PDU2
 format (where PF >= 240). Furthermore, when using the PDU2 format, the PS-field
 contains a so-called Group Extension, which is part of the PGN. When using PDU2
 format, the Group Extension is set in the PS-field.
 
+  ==============  ========================
+  PDU1 Format (specific) (peer to peer)
+  ----------------------------------------
+  Bit positions within the CAN-ID
+  ----------------------------------------
+  23 ... 16       15 ... 8
+  ==============  ========================
+  00h ... EFh     DA (Destination address)
+  ==============  ========================
+
+  ==============  ========================
+  PDU2 Format (global) (broadcast)
+  ----------------------------------------
+  Bit positions within the CAN-ID
+  ----------------------------------------
+  23 ... 16       15 ... 8
+  ==============  ========================
+  F0h ... FFh     GE (Group Extenstion)
+  ==============  ========================
+
 On the other hand, when using PDU1 format, the PS-field contains a so-called
 Destination Address, which is _not_ part of the PGN. When communicating a PGN
 from user space to kernel (or vice versa) and PDU2 format is used, the PS-field

base-commit: 4082c502bf9c8a6afe4268c654d4e93ab7dfeb69
-- 
2.29.2

