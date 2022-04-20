Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C98E508211
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 09:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359682AbiDTH3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 03:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbiDTH3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 03:29:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8E51107;
        Wed, 20 Apr 2022 00:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650439617; x=1681975617;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7x/XmTCdteW2wLfZrPwcs45IaGMX+USYibzSNolEiYk=;
  b=mRUUDrfbd+i3sxBDYTW2qlmkigvCpqmXD5N5xpbvIjHQWEtf+ayp7OpP
   fWnMLeESsXPJsmxs2BO4yVws7E1o7Nwy0d2DudzIjNiYUXKxDNpYjD5tf
   ucFOrkv/ZNkfP6+SgkZtSUWwaIbJNVLAx6rB8TrAue0p5E6bQt13PtYNW
   Cjqc3BSMDFjltG3j49hcPZqLRtcMilUMzLEwL9lil/kmpptxyI+BFTatq
   8RS7dqhkJ9S9k1fWIWowIuTUXDCEKFkIPAwGmwJm7BALcbqmT4QoNJbLF
   7R3WW5F1KQnvRCIZMzTTQ4QeXrffGlekqyIB8C737OdVogD+HfyGwjYPv
   w==;
X-IronPort-AV: E=Sophos;i="5.90,275,1643698800"; 
   d="scan'208";a="156118661"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2022 00:26:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 20 Apr 2022 00:26:56 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 20 Apr 2022 00:26:50 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [RFC Patch net-next] net: dsa: ksz: added the generic port_stp_state_set function
Date:   Wed, 20 Apr 2022 12:56:47 +0530
Message-ID: <20220420072647.22192-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ksz8795 and ksz9477 uses the same algorithm for the
port_stp_state_set function except the register address is different. So
moved the algorithm to the ksz_common.c and used the dev_ops for
register read and write. This function can also used for the lan937x
part. Hence making it generic for all the parts.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c     | 37 ++++---------------------
 drivers/net/dsa/microchip/ksz8795_reg.h |  3 --
 drivers/net/dsa/microchip/ksz9477.c     | 36 ++++--------------------
 drivers/net/dsa/microchip/ksz9477_reg.h |  4 ---
 drivers/net/dsa/microchip/ksz_common.c  | 37 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  |  8 ++++++
 6 files changed, 55 insertions(+), 70 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index b2752978cb09..0873b668913d 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1025,42 +1025,14 @@ static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 	ksz_pwrite8(dev, port, P_MIRROR_CTRL, data);
 }
 
-static void ksz8_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
+static void ksz8_cfg_stp_state(struct ksz_device *dev, int port, u8 val)
 {
-	struct ksz_device *dev = ds->priv;
-	struct ksz_port *p;
 	u8 data;
 
 	ksz_pread8(dev, port, P_STP_CTRL, &data);
 	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
-
-	switch (state) {
-	case BR_STATE_DISABLED:
-		data |= PORT_LEARN_DISABLE;
-		break;
-	case BR_STATE_LISTENING:
-		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
-		break;
-	case BR_STATE_LEARNING:
-		data |= PORT_RX_ENABLE;
-		break;
-	case BR_STATE_FORWARDING:
-		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
-		break;
-	case BR_STATE_BLOCKING:
-		data |= PORT_LEARN_DISABLE;
-		break;
-	default:
-		dev_err(ds->dev, "invalid STP state: %d\n", state);
-		return;
-	}
-
+	data |= val;
 	ksz_pwrite8(dev, port, P_STP_CTRL, data);
-
-	p = &dev->ports[port];
-	p->stp_state = state;
-
-	ksz_update_port_member(dev, port);
 }
 
 static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
@@ -1385,7 +1357,7 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 	for (i = 0; i < dev->phy_port_cnt; i++) {
 		p = &dev->ports[i];
 
-		ksz8_port_stp_state_set(ds, i, BR_STATE_DISABLED);
+		ksz_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 
 		/* Last port may be disabled. */
 		if (i == dev->phy_port_cnt)
@@ -1542,7 +1514,7 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.get_sset_count		= ksz_sset_count,
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
-	.port_stp_state_set	= ksz8_port_stp_state_set,
+	.port_stp_state_set	= ksz_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz8_port_vlan_filtering,
 	.port_vlan_add		= ksz8_port_vlan_add,
@@ -1761,6 +1733,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.cfg_port_member = ksz8_cfg_port_member,
 	.flush_dyn_mac_table = ksz8_flush_dyn_mac_table,
 	.port_setup = ksz8_port_setup,
+	.cfg_stp_state = ksz8_cfg_stp_state,
 	.r_phy = ksz8_r_phy,
 	.w_phy = ksz8_w_phy,
 	.r_dyn_mac_table = ksz8_r_dyn_mac_table,
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index d74defcd86b4..4109433b6b6c 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -160,9 +160,6 @@
 #define PORT_DISCARD_NON_VID		BIT(5)
 #define PORT_FORCE_FLOW_CTRL		BIT(4)
 #define PORT_BACK_PRESSURE		BIT(3)
-#define PORT_TX_ENABLE			BIT(2)
-#define PORT_RX_ENABLE			BIT(1)
-#define PORT_LEARN_DISABLE		BIT(0)
 
 #define REG_PORT_1_CTRL_3		0x13
 #define REG_PORT_2_CTRL_3		0x23
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 8222c8a6c5ec..96248de95749 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -514,41 +514,14 @@ static void ksz9477_cfg_port_member(struct ksz_device *dev, int port,
 	ksz_pwrite32(dev, port, REG_PORT_VLAN_MEMBERSHIP__4, member);
 }
 
-static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
-				       u8 state)
+static void ksz9477_cfg_stp_state(struct ksz_device *dev, int port, u8 val)
 {
-	struct ksz_device *dev = ds->priv;
-	struct ksz_port *p = &dev->ports[port];
 	u8 data;
 
 	ksz_pread8(dev, port, P_STP_CTRL, &data);
 	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
-
-	switch (state) {
-	case BR_STATE_DISABLED:
-		data |= PORT_LEARN_DISABLE;
-		break;
-	case BR_STATE_LISTENING:
-		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
-		break;
-	case BR_STATE_LEARNING:
-		data |= PORT_RX_ENABLE;
-		break;
-	case BR_STATE_FORWARDING:
-		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
-		break;
-	case BR_STATE_BLOCKING:
-		data |= PORT_LEARN_DISABLE;
-		break;
-	default:
-		dev_err(ds->dev, "invalid STP state: %d\n", state);
-		return;
-	}
-
+	data |= val;
 	ksz_pwrite8(dev, port, P_STP_CTRL, data);
-	p->stp_state = state;
-
-	ksz_update_port_member(dev, port);
 }
 
 static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
@@ -1404,7 +1377,7 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 			continue;
 		p = &dev->ports[i];
 
-		ksz9477_port_stp_state_set(ds, i, BR_STATE_DISABLED);
+		ksz_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 		p->on = 1;
 		if (i < dev->phy_port_cnt)
 			p->phy = 1;
@@ -1481,7 +1454,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.get_sset_count		= ksz_sset_count,
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
-	.port_stp_state_set	= ksz9477_port_stp_state_set,
+	.port_stp_state_set	= ksz_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz9477_port_vlan_filtering,
 	.port_vlan_add		= ksz9477_port_vlan_add,
@@ -1682,6 +1655,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
 	.port_setup = ksz9477_port_setup,
+	.cfg_stp_state = ksz9477_cfg_stp_state,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
 	.r_mib_pkt = ksz9477_r_mib_pkt,
 	.r_mib_stat64 = ksz9477_r_mib_stats64,
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 0bd58467181f..7a2c8d4767af 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1586,10 +1586,6 @@
 
 #define REG_PORT_LUE_MSTP_STATE		0x0B04
 
-#define PORT_TX_ENABLE			BIT(2)
-#define PORT_RX_ENABLE			BIT(1)
-#define PORT_LEARN_DISABLE		BIT(0)
-
 /* C - PTP */
 
 #define REG_PTP_PORT_RX_DELAY__2	0x0C00
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8014b18d9391..08e8f09b6bc0 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -372,6 +372,43 @@ int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 }
 EXPORT_SYMBOL_GPL(ksz_enable_port);
 
+void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
+			    u8 state)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p;
+	u8 data;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		data = PORT_LEARN_DISABLE;
+		break;
+	case BR_STATE_LISTENING:
+		data = (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
+		break;
+	case BR_STATE_LEARNING:
+		data = PORT_RX_ENABLE;
+		break;
+	case BR_STATE_FORWARDING:
+		data = (PORT_TX_ENABLE | PORT_RX_ENABLE);
+		break;
+	case BR_STATE_BLOCKING:
+		data = PORT_LEARN_DISABLE;
+		break;
+	default:
+		dev_err(ds->dev, "invalid STP state: %d\n", state);
+		return;
+	}
+
+	dev->dev_ops->cfg_stp_state(dev, port, data);
+
+	p = &dev->ports[port];
+	p->stp_state = state;
+
+	ksz_update_port_member(dev, port);
+}
+EXPORT_SYMBOL_GPL(ksz_port_stp_state_set);
+
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 {
 	struct dsa_switch *ds;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 485d4a948c38..360b98c7b0d2 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -119,6 +119,7 @@ struct ksz_dev_ops {
 	void (*flush_dyn_mac_table)(struct ksz_device *dev, int port);
 	void (*port_cleanup)(struct ksz_device *dev, int port);
 	void (*port_setup)(struct ksz_device *dev, int port, bool cpu_port);
+	void (*cfg_stp_state)(struct ksz_device *dev, int port, u8 state);
 	void (*r_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
 	void (*w_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
 	int (*r_dyn_mac_table)(struct ksz_device *dev, u16 addr, u8 *mac_addr,
@@ -165,6 +166,8 @@ int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 			 struct netlink_ext_ack *extack);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge);
+void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
+			    u8 state);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
@@ -292,6 +295,11 @@ static inline void ksz_regmap_unlock(void *__mtx)
 	mutex_unlock(mtx);
 }
 
+/* STP State Defines */
+#define PORT_TX_ENABLE			BIT(2)
+#define PORT_RX_ENABLE			BIT(1)
+#define PORT_LEARN_DISABLE		BIT(0)
+
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2

base-commit: cc4bdef26ecd56de16a04bc6d99aa10ff9076498
-- 
2.33.0

