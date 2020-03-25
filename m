Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28060192BD3
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgCYPG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:06:28 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:53189 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbgCYPGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:06:23 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48nWfP0Zmcz1r0GH;
        Wed, 25 Mar 2020 16:06:21 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48nWfN73DMz1r0cZ;
        Wed, 25 Mar 2020 16:06:20 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 7zMCzdde0VBs; Wed, 25 Mar 2020 16:06:19 +0100 (CET)
X-Auth-Info: 2TyGa/H7rL56q9FvrS9U7znXoqQ+koMTsQGd2IkDfkw=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 25 Mar 2020 16:06:19 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V2 08/14] net: ks8851: Use 16-bit writes to program MAC address
Date:   Wed, 25 Mar 2020 16:05:37 +0100
Message-Id: <20200325150543.78569-9-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200325150543.78569-1-marex@denx.de>
References: <20200325150543.78569-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the SPI variant of KS8851, the MAC address can be programmed with
either 8/16/32-bit writes. To make it easier to support the 16-bit
parallel option of KS8851 too, switch both the MAC address programming
and readout to 16-bit operations.

Remove ks8851_wrreg8() as it is not used anywhere anymore.

There should be no functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: Get rid of the KS_MAR(i + 1) by adjusting KS_MAR(x) macro
---
 drivers/net/ethernet/micrel/ks8851.c | 47 ++++++++--------------------
 drivers/net/ethernet/micrel/ks8851.h |  2 +-
 2 files changed, 14 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 8f1cc05dc3c8..6f3ecf980514 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -185,36 +185,6 @@ static void ks8851_wrreg16(struct ks8851_net *ks, unsigned reg, unsigned val)
 		netdev_err(ks->netdev, "spi_sync() failed\n");
 }
 
-/**
- * ks8851_wrreg8 - write 8bit register value to chip
- * @ks: The chip state
- * @reg: The register address
- * @val: The value to write
- *
- * Issue a write to put the value @val into the register specified in @reg.
- */
-static void ks8851_wrreg8(struct ks8851_net *ks, unsigned reg, unsigned val)
-{
-	struct spi_transfer *xfer = &ks->spi_xfer1;
-	struct spi_message *msg = &ks->spi_msg1;
-	__le16 txb[2];
-	int ret;
-	int bit;
-
-	bit = 1 << (reg & 3);
-
-	txb[0] = cpu_to_le16(MK_OP(bit, reg) | KS_SPIOP_WR);
-	txb[1] = val;
-
-	xfer->tx_buf = txb;
-	xfer->rx_buf = NULL;
-	xfer->len = 3;
-
-	ret = spi_sync(ks->spidev, msg);
-	if (ret < 0)
-		netdev_err(ks->netdev, "spi_sync() failed\n");
-}
-
 /**
  * ks8851_rdreg - issue read register command and return the data
  * @ks: The device state
@@ -349,6 +319,7 @@ static void ks8851_set_powermode(struct ks8851_net *ks, unsigned pwrmode)
 static int ks8851_write_mac_addr(struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	u16 val;
 	int i;
 
 	mutex_lock(&ks->lock);
@@ -358,8 +329,12 @@ static int ks8851_write_mac_addr(struct net_device *dev)
 	 * the first write to the MAC address does not take effect.
 	 */
 	ks8851_set_powermode(ks, PMECR_PM_NORMAL);
-	for (i = 0; i < ETH_ALEN; i++)
-		ks8851_wrreg8(ks, KS_MAR(i), dev->dev_addr[i]);
+
+	for (i = 0; i < ETH_ALEN; i += 2) {
+		val = (dev->dev_addr[i] << 8) | dev->dev_addr[i + 1];
+		ks8851_wrreg16(ks, KS_MAR(i), val);
+	}
+
 	if (!netif_running(dev))
 		ks8851_set_powermode(ks, PMECR_PM_SOFTDOWN);
 
@@ -377,12 +352,16 @@ static int ks8851_write_mac_addr(struct net_device *dev)
 static void ks8851_read_mac_addr(struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	u16 reg;
 	int i;
 
 	mutex_lock(&ks->lock);
 
-	for (i = 0; i < ETH_ALEN; i++)
-		dev->dev_addr[i] = ks8851_rdreg8(ks, KS_MAR(i));
+	for (i = 0; i < ETH_ALEN; i += 2) {
+		reg = ks8851_rdreg16(ks, KS_MAR(i));
+		dev->dev_addr[i] = reg & 0xff;
+		dev->dev_addr[i + 1] = reg >> 8;
+	}
 
 	mutex_unlock(&ks->lock);
 }
diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index 8f834aef8e32..f210d18a10b5 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -19,7 +19,7 @@
 #define CCR_32PIN				(1 << 0)    /* KSZ8851SNL    */
 
 /* MAC address registers */
-#define KS_MAR(_m)				(0x15 - (_m))
+#define KS_MAR(_m)				(0x14 - (_m))
 #define KS_MARL					0x10
 #define KS_MARM					0x12
 #define KS_MARH					0x14
-- 
2.25.1

