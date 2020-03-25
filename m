Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80917192BCD
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgCYPGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:06:24 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:47558 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbgCYPGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:06:21 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48nWfM4lYTz1r0GW;
        Wed, 25 Mar 2020 16:06:19 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48nWfM1KLwz1r0cY;
        Wed, 25 Mar 2020 16:06:19 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 14XbV3sRiByM; Wed, 25 Mar 2020 16:06:18 +0100 (CET)
X-Auth-Info: sm9rl7lMaEw2AcSs+LlHEp42ErzPt8P5+LQQ0r2TwGI=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 25 Mar 2020 16:06:18 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V2 07/14] net: ks8851: Remove ks8851_rdreg32()
Date:   Wed, 25 Mar 2020 16:05:36 +0100
Message-Id: <20200325150543.78569-8-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200325150543.78569-1-marex@denx.de>
References: <20200325150543.78569-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ks8851_rdreg32() is used only in one place, to read two registers
using a single read. To make it easier to support 16-bit accesses via
parallel bus later on, replace this single read with two 16-bit reads
from each of the registers and drop the ks8851_rdreg32() altogether.

If this has noticeable performance impact on the SPI variant of KS8851,
then we should consider using regmap to abstract the SPI and parallel
bus options and in case of SPI, permit regmap to merge register reads
of neighboring registers into single, longer, read.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
NOTE: This might need to be reinstated if it limits performance
      of the SPI part
V2: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index c2f381a7b3f3..8f1cc05dc3c8 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -296,25 +296,6 @@ static unsigned ks8851_rdreg16(struct ks8851_net *ks, unsigned reg)
 	return le16_to_cpu(rx);
 }
 
-/**
- * ks8851_rdreg32 - read 32 bit register from device
- * @ks: The chip information
- * @reg: The register address
- *
- * Read a 32bit register from the chip.
- *
- * Note, this read requires the address be aligned to 4 bytes.
-*/
-static unsigned ks8851_rdreg32(struct ks8851_net *ks, unsigned reg)
-{
-	__le32 rx = 0;
-
-	WARN_ON(reg & 3);
-
-	ks8851_rdreg(ks, MK_OP(0xf, reg), (u8 *)&rx, 4);
-	return le32_to_cpu(rx);
-}
-
 /**
  * ks8851_soft_reset - issue one of the soft reset to the device
  * @ks: The device state.
@@ -508,7 +489,6 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 	unsigned rxfc;
 	unsigned rxlen;
 	unsigned rxstat;
-	u32 rxh;
 	u8 *rxpkt;
 
 	rxfc = ks8851_rdreg8(ks, KS_RXFC);
@@ -527,9 +507,8 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 	 */
 
 	for (; rxfc != 0; rxfc--) {
-		rxh = ks8851_rdreg32(ks, KS_RXFHSR);
-		rxstat = rxh & 0xffff;
-		rxlen = (rxh >> 16) & 0xfff;
+		rxstat = ks8851_rdreg16(ks, KS_RXFHSR);
+		rxlen = ks8851_rdreg16(ks, KS_RXFHBCR) & RXFHBCR_CNT_MASK;
 
 		netif_dbg(ks, rx_status, ks->netdev,
 			  "rx: stat 0x%04x, len 0x%04x\n", rxstat, rxlen);
-- 
2.25.1

