Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCD358D70
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfF0V63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:58:29 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:34032 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbfF0V61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:58:27 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45ZYgP4Kknz1s28d;
        Thu, 27 Jun 2019 23:58:25 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45ZYgP49T6z1qqkH;
        Thu, 27 Jun 2019 23:58:25 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id vZOBZ2fy3fU7; Thu, 27 Jun 2019 23:58:24 +0200 (CEST)
X-Auth-Info: IZyIRITiU1s8ROSB+gyjDuSzgo2dxwBrpZhD+Ke0oqM=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 27 Jun 2019 23:58:24 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH 5/5] net: dsa: microchip: Replace bit RMW with regmap
Date:   Thu, 27 Jun 2019 23:55:56 +0200
Message-Id: <20190627215556.23768-6-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627215556.23768-1-marex@denx.de>
References: <20190627215556.23768-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regmap provides read-modify-write function to update bitfields in
registers. Replace ad-hoc read-modify-write with regmap_update_bits()
where applicable.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index bfc44799854c..a8c97f7a79b7 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -197,16 +197,14 @@ static int ksz9477_wait_alu_sta_ready(struct ksz_device *dev)
 static int ksz9477_reset_switch(struct ksz_device *dev)
 {
 	u8 data8;
-	u16 data16;
 	u32 data32;
 
 	/* reset switch */
 	ksz_cfg(dev, REG_SW_OPERATION, SW_RESET, true);
 
 	/* turn off SPI DO Edge select */
-	ksz_read8(dev, REG_SW_GLOBAL_SERIAL_CTRL_0, &data8);
-	data8 &= ~SPI_AUTO_EDGE_DETECTION;
-	ksz_write8(dev, REG_SW_GLOBAL_SERIAL_CTRL_0, data8);
+	regmap_update_bits(dev->regmap[0], REG_SW_GLOBAL_SERIAL_CTRL_0,
+			   SPI_AUTO_EDGE_DETECTION, 0);
 
 	/* default configuration */
 	ksz_read8(dev, REG_SW_LUE_CTRL_1, &data8);
@@ -220,10 +218,10 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 	ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
 
 	/* set broadcast storm protection 10% rate */
-	ksz_read16(dev, REG_SW_MAC_CTRL_2, &data16);
-	data16 &= ~BROADCAST_STORM_RATE;
-	data16 |= (BROADCAST_STORM_VALUE * BROADCAST_STORM_PROT_RATE) / 100;
-	ksz_write16(dev, REG_SW_MAC_CTRL_2, data16);
+	regmap_update_bits(dev->regmap[1], REG_SW_MAC_CTRL_2,
+			   BROADCAST_STORM_RATE,
+			   (BROADCAST_STORM_VALUE *
+			   BROADCAST_STORM_PROT_RATE) / 100);
 
 	if (dev->synclko_125)
 		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
@@ -485,10 +483,10 @@ static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
 	u8 data;
 
-	ksz_read8(dev, REG_SW_LUE_CTRL_2, &data);
-	data &= ~(SW_FLUSH_OPTION_M << SW_FLUSH_OPTION_S);
-	data |= (SW_FLUSH_OPTION_DYN_MAC << SW_FLUSH_OPTION_S);
-	ksz_write8(dev, REG_SW_LUE_CTRL_2, data);
+	regmap_update_bits(dev->regmap[0], REG_SW_LUE_CTRL_2,
+			   SW_FLUSH_OPTION_M << SW_FLUSH_OPTION_S,
+			   SW_FLUSH_OPTION_DYN_MAC << SW_FLUSH_OPTION_S);
+
 	if (port < dev->mib_port_cnt) {
 		/* flush individual port */
 		ksz_pread8(dev, port, P_STP_CTRL, &data);
-- 
2.20.1

