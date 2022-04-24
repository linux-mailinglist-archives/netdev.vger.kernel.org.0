Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3915150D17C
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 13:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239294AbiDXLbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 07:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239288AbiDXLbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 07:31:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA074D611;
        Sun, 24 Apr 2022 04:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650799726; x=1682335726;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8k1ES70BmUWZMSrJyoRyHOAjXPeAakRkGgoz8h1dkfU=;
  b=r8VdgN++kI4+X8jgUgCiP5BEsdt4viZF+/GQ6SbF4ibbZXy4C+pxH9Aq
   O3LzexRDGSb/M77EUCO6ZactKwCvfmfhu/CQC/YP2RnqJCUa+OXY0ms0R
   Ny+tHOphgEotHafQQ9jvR2vrsmVBkvK3w5kHOweGGdoHAbN3AS/MpGlPx
   QV7qSC77Tx3KKcrLjf363+nvpIPxWS5aUW9zXSG+SIB2FSMKPwZlhv+VR
   62Yi9R+Pz8w49jmu/pCJ7yyHHtggMODhxfHCbDlpKZa1z7q7UYTJZt3Yq
   YbgGqoslbmbGZeJe6EKulMU+AjZBVAGU6XjCtdj57EmpjX3YGB5TO3Og1
   A==;
X-IronPort-AV: E=Sophos;i="5.90,286,1643698800"; 
   d="scan'208";a="93351080"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2022 04:28:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 24 Apr 2022 04:28:44 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 24 Apr 2022 04:28:35 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [Patch net-next] net: dsa: ksz: added the generic port_stp_state_set function
Date:   Sun, 24 Apr 2022 16:58:31 +0530
Message-ID: <20220424112831.11504-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
 drivers/net/dsa/microchip/ksz8795.c     | 35 +---------------------
 drivers/net/dsa/microchip/ksz8795_reg.h |  3 --
 drivers/net/dsa/microchip/ksz9477.c     | 33 +-------------------
 drivers/net/dsa/microchip/ksz9477_reg.h |  4 ---
 drivers/net/dsa/microchip/ksz_common.c  | 40 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  |  7 +++++
 6 files changed, 49 insertions(+), 73 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index b2752978cb09..f91deea9368e 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1027,40 +1027,7 @@ static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 
 static void ksz8_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
-	struct ksz_device *dev = ds->priv;
-	struct ksz_port *p;
-	u8 data;
-
-	ksz_pread8(dev, port, P_STP_CTRL, &data);
-	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
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
-	ksz_pwrite8(dev, port, P_STP_CTRL, data);
-
-	p = &dev->ports[port];
-	p->stp_state = state;
-
-	ksz_update_port_member(dev, port);
+	ksz_port_stp_state_set(ds, port, state, P_STP_CTRL);
 }
 
 static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
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
index 8222c8a6c5ec..4f617fee9a4e 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -517,38 +517,7 @@ static void ksz9477_cfg_port_member(struct ksz_device *dev, int port,
 static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
 				       u8 state)
 {
-	struct ksz_device *dev = ds->priv;
-	struct ksz_port *p = &dev->ports[port];
-	u8 data;
-
-	ksz_pread8(dev, port, P_STP_CTRL, &data);
-	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
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
-	ksz_pwrite8(dev, port, P_STP_CTRL, data);
-	p->stp_state = state;
-
-	ksz_update_port_member(dev, port);
+	ksz_port_stp_state_set(ds, port, state, P_STP_CTRL);
 }
 
 static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
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
index 8014b18d9391..9b9f570ebb0b 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -372,6 +372,46 @@ int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 }
 EXPORT_SYMBOL_GPL(ksz_enable_port);
 
+void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
+			    u8 state, int reg)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p;
+	u8 data;
+
+	ksz_pread8(dev, port, reg, &data);
+	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		data |= PORT_LEARN_DISABLE;
+		break;
+	case BR_STATE_LISTENING:
+		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
+		break;
+	case BR_STATE_LEARNING:
+		data |= PORT_RX_ENABLE;
+		break;
+	case BR_STATE_FORWARDING:
+		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
+		break;
+	case BR_STATE_BLOCKING:
+		data |= PORT_LEARN_DISABLE;
+		break;
+	default:
+		dev_err(ds->dev, "invalid STP state: %d\n", state);
+		return;
+	}
+
+	ksz_pwrite8(dev, port, reg, data);
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
index 485d4a948c38..4d978832c448 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -165,6 +165,8 @@ int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 			 struct netlink_ext_ack *extack);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge);
+void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
+			    u8 state, int reg);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
@@ -292,6 +294,11 @@ static inline void ksz_regmap_unlock(void *__mtx)
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

base-commit: cfc1d91a7d78cf9de25b043d81efcc16966d55b3
-- 
2.33.0

