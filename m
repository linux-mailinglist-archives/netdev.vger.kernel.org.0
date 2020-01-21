Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198D41446F2
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 23:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgAUWKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 17:10:38 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44812 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729157AbgAUWKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 17:10:37 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 8A26C299A5; Tue, 21 Jan 2020 17:10:36 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <d9b11258f36b7b801bb78f32c39c9691f0237551.1579641728.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579641728.git.fthain@telegraphics.com.au>
References: <cover.1579641728.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net v2 09/12] net/sonic: Quiesce SONIC before re-initializing
 descriptor memory
Date:   Wed, 22 Jan 2020 08:22:08 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the SONIC's DMA engine is idle before altering the transmit
and receive descriptors. Add a helper for this as it will be needed
again.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 26 ++++++++++++++++++++++++++
 drivers/net/ethernet/natsemi/sonic.h |  3 +++
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 305884fb22fd..6570b9428d12 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -116,6 +116,25 @@ static int sonic_open(struct net_device *dev)
 	return 0;
 }
 
+/* Wait for the SONIC to become idle. */
+
+static void sonic_quiesce(struct net_device *dev, u16 mask)
+{
+	struct sonic_local * __maybe_unused lp = netdev_priv(dev);
+	int i;
+	u16 bits;
+
+	for (i = 0; i < 1000; ++i) {
+		bits = SONIC_READ(SONIC_CMD) & mask;
+		if (!bits)
+			return;
+		if (irqs_disabled() || in_interrupt())
+			udelay(20);
+		else
+			usleep_range(100, 200);
+	}
+	WARN_ONCE(1, "command deadline expired! 0x%04x\n", bits);
+}
 
 /*
  * Close the SONIC device
@@ -132,6 +151,9 @@ static int sonic_close(struct net_device *dev)
 	/*
 	 * stop the SONIC, disable interrupts
 	 */
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
+
 	SONIC_WRITE(SONIC_IMR, 0);
 	SONIC_WRITE(SONIC_ISR, 0x7fff);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RST);
@@ -171,6 +193,9 @@ static void sonic_tx_timeout(struct net_device *dev)
 	 * put the Sonic into software-reset mode and
 	 * disable all interrupts before releasing DMA buffers
 	 */
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
+
 	SONIC_WRITE(SONIC_IMR, 0);
 	SONIC_WRITE(SONIC_ISR, 0x7fff);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RST);
@@ -657,6 +682,7 @@ static int sonic_init(struct net_device *dev)
 	 */
 	SONIC_WRITE(SONIC_CMD, 0);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
 
 	/*
 	 * initialize the receive resource area
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index cc2f7b4b77e3..1df6d2f06cc4 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -110,6 +110,9 @@
 #define SONIC_CR_TXP            0x0002
 #define SONIC_CR_HTX            0x0001
 
+#define SONIC_CR_ALL (SONIC_CR_LCAM | SONIC_CR_RRRA | \
+		      SONIC_CR_RXEN | SONIC_CR_TXP)
+
 /*
  * SONIC data configuration bits
  */
-- 
2.24.1

