Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A0254F369
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381252AbiFQIou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381271AbiFQIoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:44:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55D269494;
        Fri, 17 Jun 2022 01:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655455482; x=1686991482;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VcFm6KNhOBJvrevqE5OJB2YUqyW06HP3kdWNkWDDr7M=;
  b=YsehY95XBCN02zG1+9xOd7IRtsqy9NJS6cpywgrQhaxK2NkSMPq0RaZ6
   ssvdo8DaaN17rVzan3jXvk8KhIrWMynYNIo6aU4B/etOo8z249nGKbOCG
   /aNjZWo+ue7IiO42liIWtUOsWIKRlG2xVWVvmfVfJYqtAk/51g6CyTYq5
   2uvhJWrHCzicUIBA7bI8hCEOAftNhHcetGHtPAY+UMRhrw09pL3Q+WFTG
   nTlzB7v+Hde9SJVavTMlsxgJqeuqXC7kSM0Wd00zfiZbflnzP1OKPJs9i
   YLsjT4Akcs6LmMdm0kzqRO8MUuqbhYpndSYe6IXAsu78q/L1/kNoRUDu5
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="100484956"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2022 01:44:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Jun 2022 01:44:38 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Jun 2022 01:44:34 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next 07/11] net: dsa: microchip: get P_STP_CTRL in ksz_port_stp_state by ksz_dev_ops
Date:   Fri, 17 Jun 2022 14:12:51 +0530
Message-ID: <20220617084255.19376-8-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617084255.19376-1-arun.ramadoss@microchip.com>
References: <20220617084255.19376-1-arun.ramadoss@microchip.com>
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

At present, P_STP_CTRL register value is passed as parameter to
ksz_port_stp_state from the individual dsa_switch_ops hooks. This patch
update the function to retrieve the register value through the
ksz_chip_data member.
And add the static to ksz_update_port_member since it is not called
outside the ksz_common.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    |  9 ++-------
 drivers/net/dsa/microchip/ksz9477.c    | 10 ++--------
 drivers/net/dsa/microchip/ksz_common.c | 22 ++++++++++++++++++----
 drivers/net/dsa/microchip/ksz_common.h |  5 ++---
 4 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 2e3d24a3260e..9721c55974be 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -920,11 +920,6 @@ static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 	ksz_pwrite8(dev, port, P_MIRROR_CTRL, data);
 }
 
-static void ksz8_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
-{
-	ksz_port_stp_state_set(ds, port, state, P_STP_CTRL);
-}
-
 static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
 	u8 learn[DSA_MAX_PORTS];
@@ -1240,7 +1235,7 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 	for (i = 0; i < dev->phy_port_cnt; i++) {
 		p = &dev->ports[i];
 
-		ksz8_port_stp_state_set(ds, i, BR_STATE_DISABLED);
+		ksz_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 
 		/* Last port may be disabled. */
 		if (i == dev->phy_port_cnt)
@@ -1389,7 +1384,7 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.get_sset_count		= ksz_sset_count,
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
-	.port_stp_state_set	= ksz8_port_stp_state_set,
+	.port_stp_state_set	= ksz_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz_port_vlan_filtering,
 	.port_vlan_add		= ksz_port_vlan_add,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 6796c9d89ab9..fed16bbede0a 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -344,12 +344,6 @@ static void ksz9477_cfg_port_member(struct ksz_device *dev, int port,
 	ksz_pwrite32(dev, port, REG_PORT_VLAN_MEMBERSHIP__4, member);
 }
 
-static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
-				       u8 state)
-{
-	ksz_port_stp_state_set(ds, port, state, P_STP_CTRL);
-}
-
 static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
 	u8 data;
@@ -1237,7 +1231,7 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 			continue;
 		p = &dev->ports[i];
 
-		ksz9477_port_stp_state_set(ds, i, BR_STATE_DISABLED);
+		ksz_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 		p->on = 1;
 		if (i < dev->phy_port_cnt)
 			p->phy = 1;
@@ -1315,7 +1309,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.get_sset_count		= ksz_sset_count,
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
-	.port_stp_state_set	= ksz9477_port_stp_state_set,
+	.port_stp_state_set	= ksz_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz_port_vlan_filtering,
 	.port_vlan_add		= ksz_port_vlan_add,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 340cad43deea..d14cb50fe610 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -151,6 +151,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x02,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -183,6 +184,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x02,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -201,6 +203,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x02,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -218,6 +221,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz88xx_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x02,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.internal_phy = {true, true, false},
@@ -235,6 +239,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x0B04,
 		.supports_mii	= {false, false, false, false,
 				   false, true, false},
 		.supports_rmii	= {false, false, false, false,
@@ -257,6 +262,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x0B04,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -278,6 +284,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x0B04,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.supports_rgmii = {false, false, true},
@@ -296,6 +303,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x0B04,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -317,6 +325,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x0B04,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -334,6 +343,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x0B04,
 		.supports_mii = {false, false, false, false, true, true},
 		.supports_rmii = {false, false, false, false, true, true},
 		.supports_rgmii = {false, false, false, false, true, true},
@@ -351,6 +361,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x0B04,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -372,6 +383,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x0B04,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -393,6 +405,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.stp_ctrl_reg = 0x0B04,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -532,7 +545,7 @@ void ksz_get_strings(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_get_strings);
 
-void ksz_update_port_member(struct ksz_device *dev, int port)
+static void ksz_update_port_member(struct ksz_device *dev, int port)
 {
 	struct ksz_port *p = &dev->ports[port];
 	struct dsa_switch *ds = dev->ds;
@@ -589,7 +602,6 @@ void ksz_update_port_member(struct ksz_device *dev, int port)
 
 	dev->dev_ops->cfg_port_member(dev, port, port_member | cpu_port);
 }
-EXPORT_SYMBOL_GPL(ksz_update_port_member);
 
 static void port_r_cnt(struct ksz_device *dev, int port)
 {
@@ -890,12 +902,14 @@ int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 }
 EXPORT_SYMBOL_GPL(ksz_enable_port);
 
-void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
-			    u8 state, int reg)
+void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p;
 	u8 data;
+	int reg;
+
+	reg = dev->info->stp_ctrl_reg;
 
 	ksz_pread8(dev, port, reg, &data);
 	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c724cbb437e2..39c6ae3d47f9 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -46,6 +46,7 @@ struct ksz_chip_data {
 	const struct ksz_mib_names *mib_names;
 	int mib_cnt;
 	u8 reg_mib_cnt;
+	int stp_ctrl_reg;
 	bool supports_mii[KSZ_MAX_NUM_PORTS];
 	bool supports_rmii[KSZ_MAX_NUM_PORTS];
 	bool supports_rgmii[KSZ_MAX_NUM_PORTS];
@@ -207,7 +208,6 @@ void ksz_switch_remove(struct ksz_device *dev);
 int ksz8_switch_register(struct ksz_device *dev);
 int ksz9477_switch_register(struct ksz_device *dev);
 
-void ksz_update_port_member(struct ksz_device *dev, int port);
 void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_get_stats64(struct dsa_switch *ds, int port,
@@ -229,8 +229,7 @@ int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 			 struct netlink_ext_ack *extack);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge);
-void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
-			    u8 state, int reg);
+void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
-- 
2.36.1

