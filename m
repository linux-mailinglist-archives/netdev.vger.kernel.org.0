Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9772B6D5CFC
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbjDDKTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbjDDKTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:19:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC1C3AB5
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:18:56 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkT-00008A-S0; Tue, 04 Apr 2023 12:18:46 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkT-008tRp-6C; Tue, 04 Apr 2023 12:18:45 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkR-005nnt-Od; Tue, 04 Apr 2023 12:18:43 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v1 7/7] net: dsa: microchip: Utilize error values in ksz8_w_sta_mac_table()
Date:   Tue,  4 Apr 2023 12:18:42 +0200
Message-Id: <20230404101842.1382986-8-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404101842.1382986-1-o.rempel@pengutronix.de>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To handle potential read/write operation failures, update
ksz8_w_sta_mac_table() to make use of the return values provided by
read/write functions.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 33 ++++++++++++++++-------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 81ce1e3fdf56..fe17ce27e5e2 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -358,19 +358,26 @@ static int ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
 	return ret;
 }
 
-static void ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
+static int ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
 {
 	const u16 *regs;
 	u16 ctrl_addr;
+	int ret;
 
 	regs = dev->info->regs;
 
 	ctrl_addr = IND_ACC_TABLE(table) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write64(dev, regs[REG_IND_DATA_HI], data);
-	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	ret = ksz_write64(dev, regs[REG_IND_DATA_HI], data);
+	if (ret)
+		goto unlock_alu;
+
+	ret = ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+unlock_alu:
 	mutex_unlock(&dev->alu_mutex);
+
+	return ret;
 }
 
 static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
@@ -510,8 +517,8 @@ static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 	return 0;
 }
 
-static void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
-				 struct alu_struct *alu)
+static int ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
+				struct alu_struct *alu)
 {
 	u32 data_hi, data_lo;
 	const u8 *shifts;
@@ -539,7 +546,8 @@ static void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 		data_hi &= ~masks[STATIC_MAC_TABLE_OVERRIDE];
 
 	data = (u64)data_hi << 32 | data_lo;
-	ksz8_w_table(dev, TABLE_STATIC_MAC, addr, data);
+
+	return ksz8_w_table(dev, TABLE_STATIC_MAC, addr, data);
 }
 
 static void ksz8_from_vlan(struct ksz_device *dev, u32 vlan, u8 *fid,
@@ -1047,9 +1055,8 @@ static int ksz8_add_sta_mac(struct ksz_device *dev, int port,
 		/* Need a way to map VID to FID. */
 		alu.fid = vid;
 	}
-	ksz8_w_sta_mac_table(dev, index, &alu);
 
-	return 0;
+	return ksz8_w_sta_mac_table(dev, index, &alu);
 }
 
 static int ksz8_del_sta_mac(struct ksz_device *dev, int port,
@@ -1073,16 +1080,14 @@ static int ksz8_del_sta_mac(struct ksz_device *dev, int port,
 
 	/* no available entry */
 	if (index == dev->info->num_statics)
-		goto exit;
+		return 0;
 
 	/* clear port */
 	alu.port_forward &= ~BIT(port);
 	if (!alu.port_forward)
 		alu.is_static = false;
-	ksz8_w_sta_mac_table(dev, index, &alu);
 
-exit:
-	return 0;
+	return ksz8_w_sta_mac_table(dev, index, &alu);
 }
 
 int ksz8_mdb_add(struct ksz_device *dev, int port,
@@ -1446,9 +1451,7 @@ int ksz8_enable_stp_addr(struct ksz_device *dev)
 	alu.is_override = true;
 	alu.port_forward = dev->info->cpu_ports;
 
-	ksz8_w_sta_mac_table(dev, 0, &alu);
-
-	return 0;
+	return ksz8_w_sta_mac_table(dev, 0, &alu);
 }
 
 int ksz8_setup(struct dsa_switch *ds)
-- 
2.39.2

