Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDA41E6E9C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437042AbgE1WWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:22:45 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45126 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436999AbgE1WWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:22:19 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49Y2Hq3RNcz1rtZP;
        Fri, 29 May 2020 00:22:15 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49Y2Hq3F5vz1qsqF;
        Fri, 29 May 2020 00:22:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id uMusbHHR0vws; Fri, 29 May 2020 00:22:14 +0200 (CEST)
X-Auth-Info: Fe2dgITi6x3SGlujRcZFrLC3yvSbFvGhqYIBT/fOxiY=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 29 May 2020 00:22:14 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V7 09/19] net: ks8851: Use 16-bit read of RXFC register
Date:   Fri, 29 May 2020 00:21:36 +0200
Message-Id: <20200528222146.348805-10-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528222146.348805-1-marex@denx.de>
References: <20200528222146.348805-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RXFC register is the only one being read using 8-bit accessors.
To make it easier to support the 16-bit accesses used by the parallel
bus variant of KS8851, use 16-bit accessor to read RXFC register as
well as neighboring RXFCTR register.

Remove ks8851_rdreg8() as it is not used anywhere anymore.

There should be no functional change.

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
V7: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 1b81340e811f..e2e75041e931 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -236,21 +236,6 @@ static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
 		memcpy(rxb, trx + 2, rxl);
 }
 
-/**
- * ks8851_rdreg8 - read 8 bit register from device
- * @ks: The chip information
- * @reg: The register address
- *
- * Read a 8bit register from the chip, returning the result
-*/
-static unsigned ks8851_rdreg8(struct ks8851_net *ks, unsigned reg)
-{
-	u8 rxb[1];
-
-	ks8851_rdreg(ks, MK_OP(1 << (reg & 3), reg), rxb, 1);
-	return rxb[0];
-}
-
 /**
  * ks8851_rdreg16 - read 16 bit register from device
  * @ks: The chip information
@@ -470,7 +455,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 	unsigned rxstat;
 	u8 *rxpkt;
 
-	rxfc = ks8851_rdreg8(ks, KS_RXFC);
+	rxfc = (ks8851_rdreg16(ks, KS_RXFCTR) >> 8) & 0xff;
 
 	netif_dbg(ks, rx_status, ks->netdev,
 		  "%s: %d packets\n", __func__, rxfc);
-- 
2.25.1

