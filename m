Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE4E59BE12
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 13:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiHVLEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 07:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiHVLEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 07:04:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F4C326C3
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 04:04:29 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Dw-0005PM-1M; Mon, 22 Aug 2022 13:04:04 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Du-001Hlq-NG; Mon, 22 Aug 2022 13:04:02 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Ds-009gyh-By; Mon, 22 Aug 2022 13:04:00 +0200
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 04/17] net: dsa: microchip: allow to pass return values for PHY read/write accesses
Date:   Mon, 22 Aug 2022 13:03:45 +0200
Message-Id: <20220822110358.2310055-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220822110358.2310055-1-o.rempel@pengutronix.de>
References: <20220822110358.2310055-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY access may end with errors on different levels. So, allow to forward
return values where possible.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8.h         |  4 ++--
 drivers/net/dsa/microchip/ksz8795.c      |  8 ++++++--
 drivers/net/dsa/microchip/ksz9477.c      | 12 ++++++++----
 drivers/net/dsa/microchip/ksz9477.h      |  4 ++--
 drivers/net/dsa/microchip/ksz_common.c   | 10 ++++++++--
 drivers/net/dsa/microchip/ksz_common.h   |  4 ++--
 drivers/net/dsa/microchip/lan937x.h      |  4 ++--
 drivers/net/dsa/microchip/lan937x_main.c |  8 ++++----
 8 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index 42c50cc4d8536..8582b4b67d989 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -17,8 +17,8 @@ u32 ksz8_get_port_addr(int port, int offset);
 void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member);
 void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port);
 void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port);
-void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
-void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
+int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
+int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
 int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 			 u8 *fid, u8 *src_port, u8 *timestamp, u16 *entries);
 int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index c79a5128235f9..f2dd75ee0e075 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -552,7 +552,7 @@ static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
 	ksz8_w_table(dev, TABLE_VLAN, addr, buf);
 }
 
-void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
+int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 {
 	u8 restart, speed, ctrl, link;
 	int processed = true;
@@ -674,9 +674,11 @@ void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 	}
 	if (processed)
 		*val = data;
+
+	return 0;
 }
 
-void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
+int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 {
 	u8 restart, speed, ctrl, data;
 	const u16 *regs;
@@ -787,6 +789,8 @@ void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 	default:
 		break;
 	}
+
+	return 0;
 }
 
 void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index e1702ff04b858..d986be78183c4 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -275,7 +275,7 @@ static void ksz9477_r_phy_quirks(struct ksz_device *dev, u16 addr, u16 reg,
 		*data &= ~(BMSR_ESTATEN | BMSR_ERCAP);
 }
 
-void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
+int ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 {
 	u16 val = 0xffff;
 
@@ -323,19 +323,23 @@ void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 	}
 
 	*data = val;
+
+	return 0;
 }
 
-void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
+int ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 {
 	/* No real PHY after this. */
 	if (addr >= dev->phy_port_cnt)
-		return;
+		return 0;
 
 	/* No gigabit support.  Do not write to this register. */
 	if (!(dev->features & GBIT_SUPPORT) && reg == MII_CTRL1000)
-		return;
+		return 0;
 
 	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
+
+	return 0;
 }
 
 void ksz9477_cfg_port_member(struct ksz_device *dev, int port, u8 member)
diff --git a/drivers/net/dsa/microchip/ksz9477.h b/drivers/net/dsa/microchip/ksz9477.h
index cd278b307b3c7..ce87e4e09ada8 100644
--- a/drivers/net/dsa/microchip/ksz9477.h
+++ b/drivers/net/dsa/microchip/ksz9477.h
@@ -16,8 +16,8 @@ u32 ksz9477_get_port_addr(int port, int offset);
 void ksz9477_cfg_port_member(struct ksz_device *dev, int port, u8 member);
 void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port);
 void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port);
-void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data);
-void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
+int ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data);
+int ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
 void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt);
 void ksz9477_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 		       u64 *dropped, u64 *cnt);
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 816438d2ed640..089570e18fb7c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1117,8 +1117,11 @@ static int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg)
 {
 	struct ksz_device *dev = ds->priv;
 	u16 val = 0xffff;
+	int ret;
 
-	dev->dev_ops->r_phy(dev, addr, reg, &val);
+	ret = dev->dev_ops->r_phy(dev, addr, reg, &val);
+	if (ret)
+		return ret;
 
 	return val;
 }
@@ -1126,8 +1129,11 @@ static int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg)
 static int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val)
 {
 	struct ksz_device *dev = ds->priv;
+	int ret;
 
-	dev->dev_ops->w_phy(dev, addr, reg, val);
+	ret = dev->dev_ops->w_phy(dev, addr, reg, val);
+	if (ret)
+		return ret;
 
 	return 0;
 }
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index aaa6a910d0819..baaeb60533faf 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -261,8 +261,8 @@ struct ksz_dev_ops {
 	void (*flush_dyn_mac_table)(struct ksz_device *dev, int port);
 	void (*port_cleanup)(struct ksz_device *dev, int port);
 	void (*port_setup)(struct ksz_device *dev, int port, bool cpu_port);
-	void (*r_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
-	void (*w_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
+	int (*r_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
+	int (*w_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
 	void (*r_mib_cnt)(struct ksz_device *dev, int port, u16 addr,
 			  u64 *cnt);
 	void (*r_mib_pkt)(struct ksz_device *dev, int port, u16 addr,
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 4e0b1dccec270..5d78d034a62f1 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -12,8 +12,8 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
 void lan937x_config_cpu_port(struct dsa_switch *ds);
 int lan937x_switch_init(struct ksz_device *dev);
 void lan937x_switch_exit(struct ksz_device *dev);
-void lan937x_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data);
-void lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
+int lan937x_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data);
+int lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
 int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu);
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 			      struct phylink_config *config);
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index daedd2bf20c1b..7b464f1fb5d88 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -128,14 +128,14 @@ static int lan937x_internal_phy_read(struct ksz_device *dev, int addr, int reg,
 	return ksz_read16(dev, REG_VPHY_IND_DATA__2, val);
 }
 
-void lan937x_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
+int lan937x_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 {
-	lan937x_internal_phy_read(dev, addr, reg, data);
+	return lan937x_internal_phy_read(dev, addr, reg, data);
 }
 
-void lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
+int lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 {
-	lan937x_internal_phy_write(dev, addr, reg, val);
+	return lan937x_internal_phy_write(dev, addr, reg, val);
 }
 
 static int lan937x_sw_mdio_read(struct mii_bus *bus, int addr, int regnum)
-- 
2.30.2

