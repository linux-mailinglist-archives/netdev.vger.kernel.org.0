Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690D85359F4
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345599AbiE0HKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345573AbiE0HJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:09:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6FBFD344;
        Fri, 27 May 2022 00:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653635267; x=1685171267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W8RFDnOnFomW6fJZLbFFtAJgXoRxi0T1j4eTqyne4vY=;
  b=PM0KgioYf1kjuaSBaM6RHRW0C0JB0zQRgauZcy6/EdIzizlUxn1z7uVK
   xiMjPsEAk0ESxl7HkD/JRhGsWqix0XI1h1jpLYwdT0/cItoU4fiaeH3KK
   cJNOBlmGYggmDLSgQxll5Sfe6aQliV9n4+kOw5yg+L+5ZoEBVOtHbBqch
   g+/CnU3045HRQlgwvrBpdWns8LQbin7Pwfcuc7M6j94DY7OtPM4S4PPuL
   KTGZz9H14JexEG1uv81/LGvcObp2mqMwAP7SFdxUyPOqAe389lSoZ21wy
   Lh2OU1axoPmxP3/TYWRcbrrtGaJsKkAG5fWQud7SZwIonf9lfsrBjK9Ro
   g==;
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="165953631"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 May 2022 00:07:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 27 May 2022 00:07:46 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 27 May 2022 00:07:41 -0700
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
Subject: [RFC Patch net-next 14/17] net: dsa: microchip: move ksz_dev_ops to ksz_common.c
Date:   Fri, 27 May 2022 12:33:55 +0530
Message-ID: <20220527070358.25490-15-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527070358.25490-1-arun.ramadoss@microchip.com>
References: <20220527070358.25490-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch move the ksz_dev_ops from individual files to ksz_common.c.
And the dev_ops is assigned to ksz_device based on the switch detect.
This reduces the redundant function and allows to reuse the
functionality for LAN937x which has similar register set.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8.h       |  46 +++++++++
 drivers/net/dsa/microchip/ksz8795.c    | 119 +++++++++--------------
 drivers/net/dsa/microchip/ksz9477.c    | 129 +++++++++----------------
 drivers/net/dsa/microchip/ksz9477.h    |  58 +++++++++++
 drivers/net/dsa/microchip/ksz_common.c |  78 ++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h |   4 +-
 6 files changed, 269 insertions(+), 165 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz9477.h

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index 03da369675c6..90d5c7ea7850 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -8,6 +8,8 @@
 #ifndef __KSZ8XXX_H
 #define __KSZ8XXX_H
 #include <linux/kernel.h>
+#include <net/dsa.h>
+#include "ksz_common.h"
 
 enum ksz_regs {
 	REG_IND_CTRL_0,
@@ -67,4 +69,48 @@ struct ksz8 {
 	void *priv;
 };
 
+int ksz8_setup(struct dsa_switch *ds);
+u32 ksz8_get_port_addr(int port, int offset);
+void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member);
+void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port);
+void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port);
+void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
+void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
+int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
+			 u8 *fid, u8 *src_port, u8 *timestamp, u16 *entries);
+int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
+			 struct alu_struct *alu);
+void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
+			  struct alu_struct *alu);
+void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt);
+void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+		    u64 *dropped, u64 *cnt);
+void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze);
+void ksz8_port_init_cnt(struct ksz_device *dev, int port);
+int ksz8_fdb_dump(struct ksz_device *dev, int port,
+		  dsa_fdb_dump_cb_t *cb, void *data);
+int ksz8_mdb_add(struct ksz_device *dev, int port,
+		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db);
+int ksz8_mdb_del(struct ksz_device *dev, int port,
+		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db);
+int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
+			     struct netlink_ext_ack *extack);
+int ksz8_port_vlan_add(struct ksz_device *dev, int port,
+		       const struct switchdev_obj_port_vlan *vlan,
+		       struct netlink_ext_ack *extack);
+int ksz8_port_vlan_del(struct ksz_device *dev, int port,
+		       const struct switchdev_obj_port_vlan *vlan);
+int ksz8_port_mirror_add(struct ksz_device *dev, int port,
+			 struct dsa_mall_mirror_tc_entry *mirror,
+			 bool ingress, struct netlink_ext_ack *extack);
+void ksz8_port_mirror_del(struct ksz_device *dev, int port,
+			  struct dsa_mall_mirror_tc_entry *mirror);
+int ksz8_get_stp_reg(void);
+void ksz8_get_caps(struct ksz_device *dev, int port,
+		   struct phylink_config *config);
+int ksz8_reset_switch(struct ksz_device *dev);
+int ksz8_switch_detect(struct ksz_device *dev);
+int ksz8_switch_init(struct ksz_device *dev);
+void ksz8_switch_exit(struct ksz_device *dev);
+
 #endif
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index ff4b33a3b1b4..79ee5ad407bc 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -162,7 +162,7 @@ static int ksz8_ind_write8(struct ksz_device *dev, u8 table, u16 addr, u8 data)
 	return ret;
 }
 
-static int ksz8_reset_switch(struct ksz_device *dev)
+int ksz8_reset_switch(struct ksz_device *dev)
 {
 	if (ksz_is_ksz88x3(dev)) {
 		/* reset switch */
@@ -213,7 +213,7 @@ static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
 			true);
 }
 
-static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
+void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 {
 	struct ksz8 *ksz8 = dev->priv;
 	const u32 *masks;
@@ -334,8 +334,8 @@ static void ksz8863_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	}
 }
 
-static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
-			   u64 *dropped, u64 *cnt)
+void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+		    u64 *dropped, u64 *cnt)
 {
 	if (ksz_is_ksz88x3(dev))
 		ksz8863_r_mib_pkt(dev, port, addr, dropped, cnt);
@@ -343,7 +343,7 @@ static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 		ksz8795_r_mib_pkt(dev, port, addr, dropped, cnt);
 }
 
-static void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze)
+void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 {
 	if (ksz_is_ksz88x3(dev))
 		return;
@@ -358,7 +358,7 @@ static void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), false);
 }
 
-static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
+void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
 	u64 *dropped;
@@ -447,9 +447,8 @@ static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 	return 0;
 }
 
-static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
-				u8 *mac_addr, u8 *fid, u8 *src_port,
-				u8 *timestamp, u16 *entries)
+int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
+			 u8 *fid, u8 *src_port, u8 *timestamp, u16 *entries)
 {
 	struct ksz8 *ksz8 = dev->priv;
 	u32 data_hi, data_lo;
@@ -512,8 +511,8 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 	return rc;
 }
 
-static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
-				struct alu_struct *alu)
+int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
+			 struct alu_struct *alu)
 {
 	struct ksz8 *ksz8 = dev->priv;
 	u32 data_hi, data_lo;
@@ -551,8 +550,8 @@ static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 	return -ENXIO;
 }
 
-static void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
-				 struct alu_struct *alu)
+void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
+			  struct alu_struct *alu)
 {
 	struct ksz8 *ksz8 = dev->priv;
 	u32 data_hi, data_lo;
@@ -663,7 +662,7 @@ static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
 	ksz8_w_table(dev, TABLE_VLAN, addr, buf);
 }
 
-static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
+void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 {
 	struct ksz8 *ksz8 = dev->priv;
 	u8 restart, speed, ctrl, link;
@@ -786,7 +785,7 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 		*val = data;
 }
 
-static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
+void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 {
 	struct ksz8 *ksz8 = dev->priv;
 	u8 restart, speed, ctrl, data;
@@ -898,7 +897,7 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 	}
 }
 
-static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
+void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 {
 	u8 data;
 
@@ -908,12 +907,12 @@ static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 	ksz_pwrite8(dev, port, P_MIRROR_CTRL, data);
 }
 
-static int ksz8_get_stp_reg(void)
+int ksz8_get_stp_reg(void)
 {
 	return P_STP_CTRL;
 }
 
-static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
+void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
 	u8 learn[DSA_MAX_PORTS];
 	int first, index, cnt;
@@ -946,8 +945,8 @@ static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
-static int ksz8_fdb_dump(struct ksz_device *dev, int port,
-			 dsa_fdb_dump_cb_t *cb, void *data)
+int ksz8_fdb_dump(struct ksz_device *dev, int port,
+		  dsa_fdb_dump_cb_t *cb, void *data)
 {
 	int ret = 0;
 	u16 i = 0;
@@ -975,9 +974,8 @@ static int ksz8_fdb_dump(struct ksz_device *dev, int port,
 	return ret;
 }
 
-static int ksz8_mdb_add(struct ksz_device *dev, int port,
-			const struct switchdev_obj_port_mdb *mdb,
-			struct dsa_db db)
+int ksz8_mdb_add(struct ksz_device *dev, int port,
+		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
 {
 	struct alu_struct alu;
 	int index;
@@ -1019,9 +1017,8 @@ static int ksz8_mdb_add(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz8_mdb_del(struct ksz_device *dev, int port,
-			const struct switchdev_obj_port_mdb *mdb,
-			struct dsa_db db)
+int ksz8_mdb_del(struct ksz_device *dev, int port,
+		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
 {
 	struct alu_struct alu;
 	int index;
@@ -1049,8 +1046,8 @@ static int ksz8_mdb_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
-				    struct netlink_ext_ack *extack)
+int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
+			     struct netlink_ext_ack *extack)
 {
 	if (ksz_is_ksz88x3(dev))
 		return -ENOTSUPP;
@@ -1076,9 +1073,9 @@ static void ksz8_port_enable_pvid(struct ksz_device *dev, int port, bool state)
 	}
 }
 
-static int ksz8_port_vlan_add(struct ksz_device *dev, int port,
-			      const struct switchdev_obj_port_vlan *vlan,
-			      struct netlink_ext_ack *extack)
+int ksz8_port_vlan_add(struct ksz_device *dev, int port,
+		       const struct switchdev_obj_port_vlan *vlan,
+		       struct netlink_ext_ack *extack)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_port *p = &dev->ports[port];
@@ -1148,8 +1145,8 @@ static int ksz8_port_vlan_add(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz8_port_vlan_del(struct ksz_device *dev, int port,
-			      const struct switchdev_obj_port_vlan *vlan)
+int ksz8_port_vlan_del(struct ksz_device *dev, int port,
+		       const struct switchdev_obj_port_vlan *vlan)
 {
 	u16 data, pvid;
 	u8 fid, member, valid;
@@ -1180,9 +1177,9 @@ static int ksz8_port_vlan_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz8_port_mirror_add(struct ksz_device *dev, int port,
-				struct dsa_mall_mirror_tc_entry *mirror,
-				bool ingress, struct netlink_ext_ack *extack)
+int ksz8_port_mirror_add(struct ksz_device *dev, int port,
+			 struct dsa_mall_mirror_tc_entry *mirror,
+			 bool ingress, struct netlink_ext_ack *extack)
 {
 	if (ingress) {
 		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
@@ -1202,8 +1199,8 @@ static int ksz8_port_mirror_add(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static void ksz8_port_mirror_del(struct ksz_device *dev, int port,
-				 struct dsa_mall_mirror_tc_entry *mirror)
+void ksz8_port_mirror_del(struct ksz_device *dev, int port,
+			  struct dsa_mall_mirror_tc_entry *mirror)
 {
 	u8 data;
 
@@ -1270,7 +1267,7 @@ static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
 	p->phydev.duplex = 1;
 }
 
-static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct dsa_switch *ds = dev->ds;
 	struct ksz8 *ksz8 = dev->priv;
@@ -1374,7 +1371,7 @@ static int ksz8_handle_global_errata(struct dsa_switch *ds)
 	return ret;
 }
 
-static int ksz8_setup(struct dsa_switch *ds)
+int ksz8_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	struct alu_struct alu;
@@ -1444,8 +1441,8 @@ static int ksz8_setup(struct dsa_switch *ds)
 	return ksz8_handle_global_errata(ds);
 }
 
-static void ksz8_get_caps(struct ksz_device *dev, int port,
-			  struct phylink_config *config)
+void ksz8_get_caps(struct ksz_device *dev, int port,
+		   struct phylink_config *config)
 {
 	config->mac_capabilities = MAC_10 | MAC_100;
 
@@ -1462,12 +1459,12 @@ static void ksz8_get_caps(struct ksz_device *dev, int port,
 		config->mac_capabilities |= MAC_ASYM_PAUSE;
 }
 
-static u32 ksz8_get_port_addr(int port, int offset)
+u32 ksz8_get_port_addr(int port, int offset)
 {
 	return PORT_CTRL_ADDR(port, offset);
 }
 
-static int ksz8_switch_init(struct ksz_device *dev)
+int ksz8_switch_init(struct ksz_device *dev)
 {
 	struct ksz8 *ksz8 = dev->priv;
 
@@ -1498,44 +1495,14 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	return 0;
 }
 
-static void ksz8_switch_exit(struct ksz_device *dev)
+void ksz8_switch_exit(struct ksz_device *dev)
 {
 	ksz8_reset_switch(dev);
 }
 
-static const struct ksz_dev_ops ksz8_dev_ops = {
-	.setup = ksz8_setup,
-	.get_port_addr = ksz8_get_port_addr,
-	.cfg_port_member = ksz8_cfg_port_member,
-	.flush_dyn_mac_table = ksz8_flush_dyn_mac_table,
-	.port_setup = ksz8_port_setup,
-	.r_phy = ksz8_r_phy,
-	.w_phy = ksz8_w_phy,
-	.r_dyn_mac_table = ksz8_r_dyn_mac_table,
-	.r_sta_mac_table = ksz8_r_sta_mac_table,
-	.w_sta_mac_table = ksz8_w_sta_mac_table,
-	.r_mib_cnt = ksz8_r_mib_cnt,
-	.r_mib_pkt = ksz8_r_mib_pkt,
-	.freeze_mib = ksz8_freeze_mib,
-	.port_init_cnt = ksz8_port_init_cnt,
-	.fdb_dump = ksz8_fdb_dump,
-	.mdb_add = ksz8_mdb_add,
-	.mdb_del = ksz8_mdb_del,
-	.vlan_filtering = ksz8_port_vlan_filtering,
-	.vlan_add = ksz8_port_vlan_add,
-	.vlan_del = ksz8_port_vlan_del,
-	.mirror_add = ksz8_port_mirror_add,
-	.mirror_del = ksz8_port_mirror_del,
-	.get_stp_reg = ksz8_get_stp_reg,
-	.get_caps = ksz8_get_caps,
-	.shutdown = ksz8_reset_switch,
-	.init = ksz8_switch_init,
-	.exit = ksz8_switch_exit,
-};
-
 int ksz8_switch_register(struct ksz_device *dev)
 {
-	return ksz_switch_register(dev, &ksz8_dev_ops);
+	return ksz_switch_register(dev);
 }
 EXPORT_SYMBOL(ksz8_switch_register);
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index c87ce0e2afd8..065cf33f7c6a 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -17,6 +17,7 @@
 
 #include "ksz9477_reg.h"
 #include "ksz_common.h"
+#include "ksz9477.h"
 
 /* Used with variable features to indicate capabilities. */
 #define GBIT_SUPPORT			BIT(0)
@@ -47,7 +48,7 @@ static void ksz9477_port_cfg32(struct ksz_device *dev, int port, int offset,
 			   bits, set ? bits : 0);
 }
 
-static int ksz9477_change_mtu(struct ksz_device *dev, int port, int mtu)
+int ksz9477_change_mtu(struct ksz_device *dev, int port, int mtu)
 {
 	u16 frame_size, max_frame = 0;
 	int i;
@@ -64,7 +65,7 @@ static int ksz9477_change_mtu(struct ksz_device *dev, int port, int mtu)
 				  REG_SW_MTU_MASK, max_frame);
 }
 
-static int ksz9477_max_mtu(struct ksz_device *dev, int port)
+int ksz9477_max_mtu(struct ksz_device *dev, int port)
 {
 	return KSZ9477_MAX_FRAME_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
 }
@@ -174,7 +175,7 @@ static int ksz9477_wait_alu_sta_ready(struct ksz_device *dev)
 					10, 1000);
 }
 
-static int ksz9477_reset_switch(struct ksz_device *dev)
+int ksz9477_reset_switch(struct ksz_device *dev)
 {
 	u8 data8;
 	u32 data32;
@@ -213,8 +214,7 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 	return 0;
 }
 
-static void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
-			      u64 *cnt)
+void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 {
 	struct ksz_port *p = &dev->ports[port];
 	unsigned int val;
@@ -241,14 +241,14 @@ static void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
 	*cnt += data;
 }
 
-static void ksz9477_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
-			      u64 *dropped, u64 *cnt)
+void ksz9477_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+		       u64 *dropped, u64 *cnt)
 {
 	addr = dev->info->mib_names[addr].index;
 	ksz9477_r_mib_cnt(dev, port, addr, cnt);
 }
 
-static void ksz9477_freeze_mib(struct ksz_device *dev, int port, bool freeze)
+void ksz9477_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 {
 	u32 val = freeze ? MIB_COUNTER_FLUSH_FREEZE : 0;
 	struct ksz_port *p = &dev->ports[port];
@@ -262,7 +262,7 @@ static void ksz9477_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 	mutex_unlock(&p->mib.cnt_mutex);
 }
 
-static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
+void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
 
@@ -275,7 +275,7 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	mutex_unlock(&mib->cnt_mutex);
 }
 
-static void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
+void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 {
 	u16 val = 0xffff;
 
@@ -324,7 +324,7 @@ static void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 	*data = val;
 }
 
-static void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
+void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 {
 	/* No real PHY after this. */
 	if (addr >= dev->phy_port_cnt)
@@ -337,18 +337,17 @@ static void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
 }
 
-static void ksz9477_cfg_port_member(struct ksz_device *dev, int port,
-				    u8 member)
+void ksz9477_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 {
 	ksz_pwrite32(dev, port, REG_PORT_VLAN_MEMBERSHIP__4, member);
 }
 
-static int ksz9477_get_stp_reg(void)
+int ksz9477_get_stp_reg(void)
 {
 	return P_STP_CTRL;
 }
 
-static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
+void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
 	u8 data;
 
@@ -370,9 +369,8 @@ static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
-static int ksz9477_port_vlan_filtering(struct ksz_device *dev, int port,
-				       bool flag,
-				       struct netlink_ext_ack *extack)
+int ksz9477_port_vlan_filtering(struct ksz_device *dev, int port,
+				bool flag, struct netlink_ext_ack *extack)
 {
 	if (flag) {
 		ksz_port_cfg(dev, port, REG_PORT_LUE_CTRL,
@@ -387,9 +385,9 @@ static int ksz9477_port_vlan_filtering(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
-				 const struct switchdev_obj_port_vlan *vlan,
-				 struct netlink_ext_ack *extack)
+int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
+			  const struct switchdev_obj_port_vlan *vlan,
+			  struct netlink_ext_ack *extack)
 {
 	u32 vlan_table[3];
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
@@ -423,8 +421,8 @@ static int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
-				 const struct switchdev_obj_port_vlan *vlan)
+int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
+			  const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	u32 vlan_table[3];
@@ -456,9 +454,8 @@ static int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz9477_fdb_add(struct ksz_device *dev, int port,
-			   const unsigned char *addr, u16 vid,
-			   struct dsa_db db)
+int ksz9477_fdb_add(struct ksz_device *dev, int port,
+		    const unsigned char *addr, u16 vid, struct dsa_db db)
 {
 	u32 alu_table[4];
 	u32 data;
@@ -513,9 +510,8 @@ static int ksz9477_fdb_add(struct ksz_device *dev, int port,
 	return ret;
 }
 
-static int ksz9477_fdb_del(struct ksz_device *dev, int port,
-			   const unsigned char *addr, u16 vid,
-			   struct dsa_db db)
+int ksz9477_fdb_del(struct ksz_device *dev, int port,
+		    const unsigned char *addr, u16 vid, struct dsa_db db)
 {
 	u32 alu_table[4];
 	u32 data;
@@ -603,8 +599,8 @@ static void ksz9477_convert_alu(struct alu_struct *alu, u32 *alu_table)
 	alu->mac[5] = alu_table[3] & 0xFF;
 }
 
-static int ksz9477_fdb_dump(struct ksz_device *dev, int port,
-			    dsa_fdb_dump_cb_t *cb, void *data)
+int ksz9477_fdb_dump(struct ksz_device *dev, int port,
+		     dsa_fdb_dump_cb_t *cb, void *data)
 {
 	int ret = 0;
 	u32 ksz_data;
@@ -654,9 +650,8 @@ static int ksz9477_fdb_dump(struct ksz_device *dev, int port,
 	return ret;
 }
 
-static int ksz9477_mdb_add(struct ksz_device *dev, int port,
-			   const struct switchdev_obj_port_mdb *mdb,
-			   struct dsa_db db)
+int ksz9477_mdb_add(struct ksz_device *dev, int port,
+		    const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
 {
 	u32 static_table[4];
 	u32 data;
@@ -729,9 +724,8 @@ static int ksz9477_mdb_add(struct ksz_device *dev, int port,
 	return err;
 }
 
-static int ksz9477_mdb_del(struct ksz_device *dev, int port,
-			   const struct switchdev_obj_port_mdb *mdb,
-			   struct dsa_db db)
+int ksz9477_mdb_del(struct ksz_device *dev, int port,
+		    const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
 {
 	u32 static_table[4];
 	u32 data;
@@ -804,9 +798,9 @@ static int ksz9477_mdb_del(struct ksz_device *dev, int port,
 	return ret;
 }
 
-static int ksz9477_port_mirror_add(struct ksz_device *dev, int port,
-				   struct dsa_mall_mirror_tc_entry *mirror,
-				   bool ingress, struct netlink_ext_ack *extack)
+int ksz9477_port_mirror_add(struct ksz_device *dev, int port,
+			    struct dsa_mall_mirror_tc_entry *mirror,
+			    bool ingress, struct netlink_ext_ack *extack)
 {
 	u8 data;
 	int p;
@@ -843,8 +837,8 @@ static int ksz9477_port_mirror_add(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static void ksz9477_port_mirror_del(struct ksz_device *dev, int port,
-				    struct dsa_mall_mirror_tc_entry *mirror)
+void ksz9477_port_mirror_del(struct ksz_device *dev, int port,
+			     struct dsa_mall_mirror_tc_entry *mirror)
 {
 	bool in_use = false;
 	u8 data;
@@ -1067,14 +1061,14 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
 	ksz9477_port_mmd_write(dev, port, 0x1c, 0x20, 0xeeee);
 }
 
-static void ksz9477_get_caps(struct ksz_device *dev, int port,
-			     struct phylink_config *config)
+void ksz9477_get_caps(struct ksz_device *dev, int port,
+		      struct phylink_config *config)
 {
 	config->mac_capabilities = MAC_10 | MAC_100 | MAC_1000FD |
 				   MAC_ASYM_PAUSE | MAC_SYM_PAUSE;
 }
 
-static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct ksz_port *p = &dev->ports[port];
 	struct dsa_switch *ds = dev->ds;
@@ -1241,7 +1235,7 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 	}
 }
 
-static int ksz9477_setup(struct dsa_switch *ds)
+int ksz9477_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	int ret = 0;
@@ -1293,12 +1287,12 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	return 0;
 }
 
-static u32 ksz9477_get_port_addr(int port, int offset)
+u32 ksz9477_get_port_addr(int port, int offset)
 {
 	return PORT_CTRL_ADDR(port, offset);
 }
 
-static int ksz9477_switch_init(struct ksz_device *dev)
+int ksz9477_switch_init(struct ksz_device *dev)
 {
 	u8 data8;
 	int ret;
@@ -1344,12 +1338,12 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 	return 0;
 }
 
-static void ksz9477_switch_exit(struct ksz_device *dev)
+void ksz9477_switch_exit(struct ksz_device *dev)
 {
 	ksz9477_reset_switch(dev);
 }
 
-static int ksz9477_dsa_init(struct ksz_device *dev)
+int ksz9477_dsa_init(struct ksz_device *dev)
 {
 	struct phy_device *phydev;
 	int i;
@@ -1373,42 +1367,9 @@ static int ksz9477_dsa_init(struct ksz_device *dev)
 	return 0;
 }
 
-static const struct ksz_dev_ops ksz9477_dev_ops = {
-	.setup = ksz9477_setup,
-	.get_port_addr = ksz9477_get_port_addr,
-	.cfg_port_member = ksz9477_cfg_port_member,
-	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
-	.port_setup = ksz9477_port_setup,
-	.r_phy = ksz9477_r_phy,
-	.w_phy = ksz9477_w_phy,
-	.r_mib_cnt = ksz9477_r_mib_cnt,
-	.r_mib_pkt = ksz9477_r_mib_pkt,
-	.r_mib_stat64 = ksz_r_mib_stats64,
-	.freeze_mib = ksz9477_freeze_mib,
-	.port_init_cnt = ksz9477_port_init_cnt,
-	.vlan_filtering = ksz9477_port_vlan_filtering,
-	.vlan_add = ksz9477_port_vlan_add,
-	.vlan_del = ksz9477_port_vlan_del,
-	.mirror_add = ksz9477_port_mirror_add,
-	.mirror_del = ksz9477_port_mirror_del,
-	.get_stp_reg = ksz9477_get_stp_reg,
-	.get_caps = ksz9477_get_caps,
-	.fdb_dump = ksz9477_fdb_dump,
-	.fdb_add = ksz9477_fdb_add,
-	.fdb_del = ksz9477_fdb_del,
-	.mdb_add = ksz9477_mdb_add,
-	.mdb_del = ksz9477_mdb_del,
-	.change_mtu = ksz9477_change_mtu,
-	.max_mtu = ksz9477_max_mtu,
-	.shutdown = ksz9477_reset_switch,
-	.dsa_init = ksz9477_dsa_init,
-	.init = ksz9477_switch_init,
-	.exit = ksz9477_switch_exit,
-};
-
 int ksz9477_switch_register(struct ksz_device *dev)
 {
-	return ksz_switch_register(dev, &ksz9477_dev_ops);
+	return ksz_switch_register(dev);
 }
 EXPORT_SYMBOL(ksz9477_switch_register);
 
diff --git a/drivers/net/dsa/microchip/ksz9477.h b/drivers/net/dsa/microchip/ksz9477.h
new file mode 100644
index 000000000000..feb5464e8c2b
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz9477.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Microchip KSZ9477 series Header file
+ *
+ * Copyright (C) 2017-2022 Microchip Technology Inc.
+ */
+
+#ifndef __KSZ9477_H
+#define __KSZ9477_H
+
+#include <net/dsa.h>
+#include "ksz_common.h"
+
+int ksz9477_setup(struct dsa_switch *ds);
+u32 ksz9477_get_port_addr(int port, int offset);
+void ksz9477_cfg_port_member(struct ksz_device *dev, int port, u8 member);
+void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port);
+void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port);
+void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data);
+void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
+void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt);
+void ksz9477_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+		       u64 *dropped, u64 *cnt);
+void ksz9477_freeze_mib(struct ksz_device *dev, int port, bool freeze);
+void ksz9477_port_init_cnt(struct ksz_device *dev, int port);
+int ksz9477_port_vlan_filtering(struct ksz_device *dev, int port,
+				bool flag, struct netlink_ext_ack *extack);
+int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
+			  const struct switchdev_obj_port_vlan *vlan,
+			  struct netlink_ext_ack *extack);
+int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
+			  const struct switchdev_obj_port_vlan *vlan);
+int ksz9477_port_mirror_add(struct ksz_device *dev, int port,
+			    struct dsa_mall_mirror_tc_entry *mirror,
+			    bool ingress, struct netlink_ext_ack *extack);
+void ksz9477_port_mirror_del(struct ksz_device *dev, int port,
+			     struct dsa_mall_mirror_tc_entry *mirror);
+int ksz9477_get_stp_reg(void);
+void ksz9477_get_caps(struct ksz_device *dev, int port,
+		      struct phylink_config *config);
+int ksz9477_fdb_dump(struct ksz_device *dev, int port,
+		     dsa_fdb_dump_cb_t *cb, void *data);
+int ksz9477_fdb_add(struct ksz_device *dev, int port,
+		    const unsigned char *addr, u16 vid, struct dsa_db db);
+int ksz9477_fdb_del(struct ksz_device *dev, int port,
+		    const unsigned char *addr, u16 vid, struct dsa_db db);
+int ksz9477_mdb_add(struct ksz_device *dev, int port,
+		    const struct switchdev_obj_port_mdb *mdb, struct dsa_db db);
+int ksz9477_mdb_del(struct ksz_device *dev, int port,
+		    const struct switchdev_obj_port_mdb *mdb, struct dsa_db db);
+int ksz9477_change_mtu(struct ksz_device *dev, int port, int mtu);
+int ksz9477_max_mtu(struct ksz_device *dev, int port);
+int ksz9477_reset_switch(struct ksz_device *dev);
+int ksz9477_dsa_init(struct ksz_device *dev);
+int ksz9477_switch_init(struct ksz_device *dev);
+void ksz9477_switch_exit(struct ksz_device *dev);
+
+#endif
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index f40d64858d35..835b9e2767d1 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -21,6 +21,8 @@
 #include <net/switchdev.h>
 
 #include "ksz_common.h"
+#include "ksz8.h"
+#include "ksz9477.h"
 
 #define MIB_COUNTER_NUM 0x20
 
@@ -139,6 +141,69 @@ static const struct ksz_mib_names ksz9477_mib_names[] = {
 	{ 0x83, "tx_discards" },
 };
 
+static const struct ksz_dev_ops ksz8_dev_ops = {
+	.setup = ksz8_setup,
+	.get_port_addr = ksz8_get_port_addr,
+	.cfg_port_member = ksz8_cfg_port_member,
+	.flush_dyn_mac_table = ksz8_flush_dyn_mac_table,
+	.port_setup = ksz8_port_setup,
+	.r_phy = ksz8_r_phy,
+	.w_phy = ksz8_w_phy,
+	.r_dyn_mac_table = ksz8_r_dyn_mac_table,
+	.r_sta_mac_table = ksz8_r_sta_mac_table,
+	.w_sta_mac_table = ksz8_w_sta_mac_table,
+	.r_mib_cnt = ksz8_r_mib_cnt,
+	.r_mib_pkt = ksz8_r_mib_pkt,
+	.freeze_mib = ksz8_freeze_mib,
+	.port_init_cnt = ksz8_port_init_cnt,
+	.fdb_dump = ksz8_fdb_dump,
+	.mdb_add = ksz8_mdb_add,
+	.mdb_del = ksz8_mdb_del,
+	.vlan_filtering = ksz8_port_vlan_filtering,
+	.vlan_add = ksz8_port_vlan_add,
+	.vlan_del = ksz8_port_vlan_del,
+	.mirror_add = ksz8_port_mirror_add,
+	.mirror_del = ksz8_port_mirror_del,
+	.get_stp_reg = ksz8_get_stp_reg,
+	.get_caps = ksz8_get_caps,
+	.shutdown = ksz8_reset_switch,
+	.init = ksz8_switch_init,
+	.exit = ksz8_switch_exit,
+};
+
+static const struct ksz_dev_ops ksz9477_dev_ops = {
+	.setup = ksz9477_setup,
+	.get_port_addr = ksz9477_get_port_addr,
+	.cfg_port_member = ksz9477_cfg_port_member,
+	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
+	.port_setup = ksz9477_port_setup,
+	.r_phy = ksz9477_r_phy,
+	.w_phy = ksz9477_w_phy,
+	.r_mib_cnt = ksz9477_r_mib_cnt,
+	.r_mib_pkt = ksz9477_r_mib_pkt,
+	.r_mib_stat64 = ksz_r_mib_stats64,
+	.freeze_mib = ksz9477_freeze_mib,
+	.port_init_cnt = ksz9477_port_init_cnt,
+	.vlan_filtering = ksz9477_port_vlan_filtering,
+	.vlan_add = ksz9477_port_vlan_add,
+	.vlan_del = ksz9477_port_vlan_del,
+	.mirror_add = ksz9477_port_mirror_add,
+	.mirror_del = ksz9477_port_mirror_del,
+	.get_stp_reg = ksz9477_get_stp_reg,
+	.get_caps = ksz9477_get_caps,
+	.fdb_dump = ksz9477_fdb_dump,
+	.fdb_add = ksz9477_fdb_add,
+	.fdb_del = ksz9477_fdb_del,
+	.mdb_add = ksz9477_mdb_add,
+	.mdb_del = ksz9477_mdb_del,
+	.change_mtu = ksz9477_change_mtu,
+	.max_mtu = ksz9477_max_mtu,
+	.shutdown = ksz9477_reset_switch,
+	.dsa_init = ksz9477_dsa_init,
+	.init = ksz9477_switch_init,
+	.exit = ksz9477_switch_exit,
+};
+
 const struct ksz_chip_data ksz_switch_chips[] = {
 	[KSZ8795] = {
 		.chip_id = KSZ8795_CHIP_ID,
@@ -148,6 +213,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -180,6 +246,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -198,6 +265,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -216,6 +284,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x4,	/* can be configured as cpu port */
 		.port_cnt = 3,
+		.ops = &ksz8_dev_ops,
 		.mib_names = ksz88xx_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -232,6 +301,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -254,6 +324,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -276,6 +347,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
+		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -293,6 +365,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1133,8 +1206,7 @@ struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 }
 EXPORT_SYMBOL(ksz_switch_alloc);
 
-int ksz_switch_register(struct ksz_device *dev,
-			const struct ksz_dev_ops *ops)
+int ksz_switch_register(struct ksz_device *dev)
 {
 	const struct ksz_chip_data *info;
 	struct device_node *port, *ports;
@@ -1181,7 +1253,7 @@ int ksz_switch_register(struct ksz_device *dev,
 	if (ret)
 		return ret;
 
-	dev->dev_ops = ops;
+	dev->dev_ops = dev->info->ops;
 
 	ret = dev->dev_ops->init(dev);
 	if (ret)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 23962f47df46..eab5491d463f 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -41,6 +41,7 @@ struct ksz_chip_data {
 	int num_statics;
 	int cpu_ports;
 	int port_cnt;
+	const struct ksz_dev_ops *ops;
 	bool phy_errata_9477;
 	bool ksz87xx_eee_link_erratum;
 	const struct ksz_mib_names *mib_names;
@@ -219,8 +220,7 @@ struct ksz_dev_ops {
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
-int ksz_switch_register(struct ksz_device *dev,
-			const struct ksz_dev_ops *ops);
+int ksz_switch_register(struct ksz_device *dev);
 void ksz_switch_remove(struct ksz_device *dev);
 
 int ksz8_switch_register(struct ksz_device *dev);
-- 
2.36.1

