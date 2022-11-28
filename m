Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F011B63A7C2
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiK1MCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiK1MAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E545718B3D
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:49 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoT-0005Lj-Dm; Mon, 28 Nov 2022 13:00:41 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoR-000oBY-P1; Mon, 28 Nov 2022 13:00:40 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoO-00H6Sp-U8; Mon, 28 Nov 2022 13:00:36 +0100
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
Subject: [PATCH v1 24/26] net: dsa: microchip: ksz8_w_sta_mac_table(): make use of error values provided by read/write functions
Date:   Mon, 28 Nov 2022 13:00:32 +0100
Message-Id: <20221128120034.4075562-25-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221128120034.4075562-1-o.rempel@pengutronix.de>
References: <20221128120034.4075562-1-o.rempel@pengutronix.de>
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

Read/write operations may fail. So, make use of return values.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 33 ++++++++++++++++-------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 9c1450782314..ea08bdea193e 100644
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
@@ -509,8 +516,8 @@ static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 	return 0;
 }
 
-static void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
-				 struct alu_struct *alu)
+static int ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
+				struct alu_struct *alu)
 {
 	u32 data_hi, data_lo;
 	const u8 *shifts;
@@ -538,7 +545,8 @@ static void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 		data_hi &= ~masks[STATIC_MAC_TABLE_OVERRIDE];
 
 	data = (u64)data_hi << 32 | data_lo;
-	ksz8_w_table(dev, TABLE_STATIC_MAC, addr, data);
+
+	return ksz8_w_table(dev, TABLE_STATIC_MAC, addr, data);
 }
 
 static void ksz8_from_vlan(struct ksz_device *dev, u32 vlan, u8 *fid,
@@ -1065,9 +1073,8 @@ static int ksz8_add_sta_mac(struct ksz_device *dev, int port,
 		/* Need a way to map VID to FID. */
 		alu.fid = vid;
 	}
-	ksz8_w_sta_mac_table(dev, index, &alu);
 
-	return 0;
+	return ksz8_w_sta_mac_table(dev, index, &alu);
 }
 
 static int ksz8_del_sta_mac(struct ksz_device *dev, int port,
@@ -1091,16 +1098,14 @@ static int ksz8_del_sta_mac(struct ksz_device *dev, int port,
 
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
@@ -1424,9 +1429,7 @@ int ksz8_enable_stp_addr(struct ksz_device *dev)
 	alu.is_override = true;
 	alu.port_forward = dev->info->cpu_ports;
 
-	ksz8_w_sta_mac_table(dev, 0, &alu);
-
-	return 0;
+	return ksz8_w_sta_mac_table(dev, 0, &alu);
 }
 
 int ksz8_setup(struct dsa_switch *ds)
-- 
2.30.2

