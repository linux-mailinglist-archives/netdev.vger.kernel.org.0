Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D171D64F0
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 02:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgEQAer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 20:34:47 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:42298 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgEQAel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 20:34:41 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49Pjp22xCJz1rqrb;
        Sun, 17 May 2020 02:34:31 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49Pjnz5blHz1shft;
        Sun, 17 May 2020 02:34:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id vQbgyMp6reIB; Sun, 17 May 2020 02:34:30 +0200 (CEST)
X-Auth-Info: sgDhdWpVro7tgOJUCdmPdjhEa+ixx1ntXGZhvCHLnXY=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 17 May 2020 02:34:30 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V6 07/20] net: ks8851: Remove ks8851_rdreg32()
Date:   Sun, 17 May 2020 02:33:41 +0200
Message-Id: <20200517003354.233373-8-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200517003354.233373-1-marex@denx.de>
References: <20200517003354.233373-1-marex@denx.de>
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
V2: No change
V3: No change
V4: Drop the NOTE from the comment, the performance is OK
V5: No change
V6: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index fe2037e166dc..8df130efbde1 100644
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

