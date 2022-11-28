Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C4263A788
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiK1MA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiK1MAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A08186FE
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:17 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcns-0003pk-S0; Mon, 28 Nov 2022 13:00:04 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnr-000o9T-B5; Mon, 28 Nov 2022 13:00:04 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnn-00Gzfi-Vi; Mon, 28 Nov 2022 12:59:59 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v1 18/26] net: dsa: microchip: ksz8_r_dyn_mac_table(): return read/write error if we got any
Date:   Mon, 28 Nov 2022 12:59:50 +0100
Message-Id: <20221128115958.4049431-19-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221128115958.4049431-1-o.rempel@pengutronix.de>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The read/write path may fail. So, return error if we got it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 1b067e0cacd5..3348f5c25942 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -371,12 +371,16 @@ static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 	int timeout = 100;
 	const u32 *masks;
 	const u16 *regs;
+	int ret;
 
 	masks = dev->info->masks;
 	regs = dev->info->regs;
 
 	do {
-		ksz_read8(dev, regs[REG_IND_DATA_CHECK], data);
+		ret = ksz_read8(dev, regs[REG_IND_DATA_CHECK], data);
+		if (ret)
+			return ret;
+
 		timeout--;
 	} while ((*data & masks[DYNAMIC_MAC_TABLE_NOT_READY]) && timeout);
 
@@ -385,7 +389,9 @@ static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 		return -ETIMEDOUT;
 	/* Entry is ready for accessing. */
 	} else {
-		ksz_read8(dev, regs[REG_IND_DATA_8], data);
+		ret = ksz_read8(dev, regs[REG_IND_DATA_8], data);
+		if (ret)
+			return ret;
 
 		/* There is no valid entry in the table. */
 		if (*data & masks[DYNAMIC_MAC_TABLE_MAC_EMPTY])
@@ -414,7 +420,9 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 	ctrl_addr = IND_ACC_TABLE(TABLE_DYNAMIC_MAC | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	ret = ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	if (ret)
+		goto unlock_alu;
 
 	ret = ksz8_valid_dyn_entry(dev, &data);
 	if (ret == -ENXIO) {
@@ -425,7 +433,10 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 	if (ret)
 		goto unlock_alu;
 
-	ksz_read64(dev, regs[REG_IND_DATA_HI], &buf);
+	ret = ksz_read64(dev, regs[REG_IND_DATA_HI], &buf);
+	if (ret)
+		goto unlock_alu;
+
 	data_hi = (u32)(buf >> 32);
 	data_lo = (u32)buf;
 
@@ -446,7 +457,6 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 
 	mac_addr[1] = (u8)data_hi;
 	mac_addr[0] = (u8)(data_hi >> 8);
-	ret = 0;
 
 unlock_alu:
 	mutex_unlock(&dev->alu_mutex);
-- 
2.30.2

