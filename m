Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F25A5549C3
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357386AbiFVJLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357329AbiFVJKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:10:47 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE113A71A;
        Wed, 22 Jun 2022 02:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888970; x=1687424970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l0Kj04sfNSdlbcV7V2E7Mg91bYQl9+8GsvuEOGClYr0=;
  b=YwHgc8xJCr73Nw+h9njHC4A9mGv5yFoa6DANBiJJUC9wfckTGOE5rVsy
   DPWV2LRjCgxcbVjVDhgl/ENpoxOtrTPrQ5v/JmodbXV9DwtJi7TLtduLH
   q9qRZH+DSFm0A5LPLutoE3ssHT/rA6OSCgFBSh7OFEPU1YdvQGeoU7Tdb
   MO2H6rqF/67YKR7RXfXqjpupbZXRr8gOngrRjWo8sUBBi1WOjnjA8NHOo
   KltciJdf+9XWA3HedFU0gza6Fsl2QIzoLL5ikQAcEfcudlJeWpq5nbKgG
   DMowROFmIaKwq1nSeba/pL9bsRXsVLHtyBufCZKKrQDSEnyFQUtfa3G8p
   w==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="169425377"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:09:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:09:23 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:09:18 -0700
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
Subject: [Patch net-next 11/13] net: dsa: microchip: move ksz_dev_ops to ksz_common.c
Date:   Wed, 22 Jun 2022 14:34:23 +0530
Message-ID: <20220622090425.17709-12-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220622090425.17709-1-arun.ramadoss@microchip.com>
References: <20220622090425.17709-1-arun.ramadoss@microchip.com>
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

This patch move the ksz_dev_ops from individual files to ksz_common.c.
And the dev_ops is assigned to ksz_device based on the switch detect.
This reduces the redundant function and allows to reuse the
functionality for LAN937x which has similar register set.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8.h       |  48 +++++++++
 drivers/net/dsa/microchip/ksz8795.c    | 119 +++++++++--------------
 drivers/net/dsa/microchip/ksz9477.c    | 129 +++++++++----------------
 drivers/net/dsa/microchip/ksz9477.h    |  60 ++++++++++++
 drivers/net/dsa/microchip/ksz_common.c |  75 +++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h |   4 +-
 6 files changed, 271 insertions(+), 164 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz9477.h

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index cae76f5e7787..de246989c81b 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -9,6 +9,8 @@
 #define __KSZ8XXX_H
 
 #include <linux/types.h>
+#include <net/dsa.h>
+#include "ksz_common.h"
 
 enum ksz_regs {
 	REG_IND_CTRL_0,
@@ -68,4 +70,50 @@ struct ksz8 {
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
+void ksz8_config_cpu_port(struct dsa_switch *ds);
+int ksz8_enable_stp_addr(struct ksz_device *dev);
+int ksz8_reset_switch(struct ksz_device *dev);
+int ksz8_switch_detect(struct ksz_device *dev);
+int ksz8_switch_init(struct ksz_device *dev);
+void ksz8_switch_exit(struct ksz_device *dev);
+
 #endif
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 0734ee63ed19..78fa33a23b4e 100644
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
 
@@ -908,7 +907,7 @@ static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 	ksz_pwrite8(dev, port, P_MIRROR_CTRL, data);
 }
 
-static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
+void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
 	u8 learn[DSA_MAX_PORTS];
 	int first, index, cnt;
@@ -941,8 +940,8 @@ static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
-static int ksz8_fdb_dump(struct ksz_device *dev, int port,
-			 dsa_fdb_dump_cb_t *cb, void *data)
+int ksz8_fdb_dump(struct ksz_device *dev, int port,
+		  dsa_fdb_dump_cb_t *cb, void *data)
 {
 	int ret = 0;
 	u16 i = 0;
@@ -969,9 +968,8 @@ static int ksz8_fdb_dump(struct ksz_device *dev, int port,
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
@@ -1013,9 +1011,8 @@ static int ksz8_mdb_add(struct ksz_device *dev, int port,
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
@@ -1043,8 +1040,8 @@ static int ksz8_mdb_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
-				    struct netlink_ext_ack *extack)
+int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
+			     struct netlink_ext_ack *extack)
 {
 	if (ksz_is_ksz88x3(dev))
 		return -ENOTSUPP;
@@ -1070,9 +1067,9 @@ static void ksz8_port_enable_pvid(struct ksz_device *dev, int port, bool state)
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
@@ -1142,8 +1139,8 @@ static int ksz8_port_vlan_add(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz8_port_vlan_del(struct ksz_device *dev, int port,
-			      const struct switchdev_obj_port_vlan *vlan)
+int ksz8_port_vlan_del(struct ksz_device *dev, int port,
+		       const struct switchdev_obj_port_vlan *vlan)
 {
 	u16 data, pvid;
 	u8 fid, member, valid;
@@ -1174,9 +1171,9 @@ static int ksz8_port_vlan_del(struct ksz_device *dev, int port,
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
@@ -1196,8 +1193,8 @@ static int ksz8_port_mirror_add(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static void ksz8_port_mirror_del(struct ksz_device *dev, int port,
-				 struct dsa_mall_mirror_tc_entry *mirror)
+void ksz8_port_mirror_del(struct ksz_device *dev, int port,
+			  struct dsa_mall_mirror_tc_entry *mirror)
 {
 	u8 data;
 
@@ -1264,7 +1261,7 @@ static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
 	p->phydev.duplex = 1;
 }
 
-static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct dsa_switch *ds = dev->ds;
 	struct ksz8 *ksz8 = dev->priv;
@@ -1301,7 +1298,7 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	ksz8_cfg_port_member(dev, port, member);
 }
 
-static void ksz8_config_cpu_port(struct dsa_switch *ds)
+void ksz8_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz8 *ksz8 = dev->priv;
@@ -1368,7 +1365,7 @@ static int ksz8_handle_global_errata(struct dsa_switch *ds)
 	return ret;
 }
 
-static int ksz8_enable_stp_addr(struct ksz_device *dev)
+int ksz8_enable_stp_addr(struct ksz_device *dev)
 {
 	struct alu_struct alu;
 
@@ -1384,7 +1381,7 @@ static int ksz8_enable_stp_addr(struct ksz_device *dev)
 	return 0;
 }
 
-static int ksz8_setup(struct dsa_switch *ds)
+int ksz8_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	int i;
@@ -1419,8 +1416,8 @@ static int ksz8_setup(struct dsa_switch *ds)
 	return ksz8_handle_global_errata(ds);
 }
 
-static void ksz8_get_caps(struct ksz_device *dev, int port,
-			  struct phylink_config *config)
+void ksz8_get_caps(struct ksz_device *dev, int port,
+		   struct phylink_config *config)
 {
 	config->mac_capabilities = MAC_10 | MAC_100;
 
@@ -1437,12 +1434,12 @@ static void ksz8_get_caps(struct ksz_device *dev, int port,
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
 
@@ -1473,42 +1470,14 @@ static int ksz8_switch_init(struct ksz_device *dev)
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
-	.get_caps = ksz8_get_caps,
-	.config_cpu_port = ksz8_config_cpu_port,
-	.enable_stp_addr = ksz8_enable_stp_addr,
-	.reset = ksz8_reset_switch,
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
index 4fcc7923da4d..fe471626350f 100644
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
@@ -207,8 +208,7 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 	return 0;
 }
 
-static void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
-			      u64 *cnt)
+void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 {
 	struct ksz_port *p = &dev->ports[port];
 	unsigned int val;
@@ -235,14 +235,14 @@ static void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
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
@@ -256,7 +256,7 @@ static void ksz9477_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 	mutex_unlock(&p->mib.cnt_mutex);
 }
 
-static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
+void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
 
@@ -269,7 +269,7 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	mutex_unlock(&mib->cnt_mutex);
 }
 
-static void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
+void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 {
 	u16 val = 0xffff;
 
@@ -318,7 +318,7 @@ static void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 	*data = val;
 }
 
-static void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
+void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 {
 	/* No real PHY after this. */
 	if (addr >= dev->phy_port_cnt)
@@ -331,13 +331,12 @@ static void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
 }
 
-static void ksz9477_cfg_port_member(struct ksz_device *dev, int port,
-				    u8 member)
+void ksz9477_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 {
 	ksz_pwrite32(dev, port, REG_PORT_VLAN_MEMBERSHIP__4, member);
 }
 
-static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
+void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
 	u8 data;
 
@@ -359,9 +358,8 @@ static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
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
@@ -376,9 +374,9 @@ static int ksz9477_port_vlan_filtering(struct ksz_device *dev, int port,
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
@@ -412,8 +410,8 @@ static int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
-				 const struct switchdev_obj_port_vlan *vlan)
+int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
+			  const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	u32 vlan_table[3];
@@ -445,9 +443,8 @@ static int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
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
@@ -502,9 +499,8 @@ static int ksz9477_fdb_add(struct ksz_device *dev, int port,
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
@@ -592,8 +588,8 @@ static void ksz9477_convert_alu(struct alu_struct *alu, u32 *alu_table)
 	alu->mac[5] = alu_table[3] & 0xFF;
 }
 
-static int ksz9477_fdb_dump(struct ksz_device *dev, int port,
-			    dsa_fdb_dump_cb_t *cb, void *data)
+int ksz9477_fdb_dump(struct ksz_device *dev, int port,
+		     dsa_fdb_dump_cb_t *cb, void *data)
 {
 	int ret = 0;
 	u32 ksz_data;
@@ -643,9 +639,8 @@ static int ksz9477_fdb_dump(struct ksz_device *dev, int port,
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
@@ -718,9 +713,8 @@ static int ksz9477_mdb_add(struct ksz_device *dev, int port,
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
@@ -793,9 +787,9 @@ static int ksz9477_mdb_del(struct ksz_device *dev, int port,
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
@@ -832,8 +826,8 @@ static int ksz9477_port_mirror_add(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static void ksz9477_port_mirror_del(struct ksz_device *dev, int port,
-				    struct dsa_mall_mirror_tc_entry *mirror)
+void ksz9477_port_mirror_del(struct ksz_device *dev, int port,
+			     struct dsa_mall_mirror_tc_entry *mirror)
 {
 	bool in_use = false;
 	u8 data;
@@ -1056,8 +1050,8 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
 	ksz9477_port_mmd_write(dev, port, 0x1c, 0x20, 0xeeee);
 }
 
-static void ksz9477_get_caps(struct ksz_device *dev, int port,
-			     struct phylink_config *config)
+void ksz9477_get_caps(struct ksz_device *dev, int port,
+		      struct phylink_config *config)
 {
 	config->mac_capabilities = MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
 				   MAC_SYM_PAUSE;
@@ -1066,7 +1060,7 @@ static void ksz9477_get_caps(struct ksz_device *dev, int port,
 		config->mac_capabilities |= MAC_1000FD;
 }
 
-static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct ksz_port *p = &dev->ports[port];
 	struct dsa_switch *ds = dev->ds;
@@ -1163,7 +1157,7 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		ksz_pread16(dev, port, REG_PORT_PHY_INT_ENABLE, &data16);
 }
 
-static void ksz9477_config_cpu_port(struct dsa_switch *ds)
+void ksz9477_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p;
@@ -1233,7 +1227,7 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 	}
 }
 
-static int ksz9477_enable_stp_addr(struct ksz_device *dev)
+int ksz9477_enable_stp_addr(struct ksz_device *dev)
 {
 	u32 data;
 	int ret;
@@ -1263,7 +1257,7 @@ static int ksz9477_enable_stp_addr(struct ksz_device *dev)
 	return 0;
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
@@ -1344,47 +1338,14 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 	return 0;
 }
 
-static void ksz9477_switch_exit(struct ksz_device *dev)
+void ksz9477_switch_exit(struct ksz_device *dev)
 {
 	ksz9477_reset_switch(dev);
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
-	.get_caps = ksz9477_get_caps,
-	.fdb_dump = ksz9477_fdb_dump,
-	.fdb_add = ksz9477_fdb_add,
-	.fdb_del = ksz9477_fdb_del,
-	.mdb_add = ksz9477_mdb_add,
-	.mdb_del = ksz9477_mdb_del,
-	.change_mtu = ksz9477_change_mtu,
-	.max_mtu = ksz9477_max_mtu,
-	.config_cpu_port = ksz9477_config_cpu_port,
-	.enable_stp_addr = ksz9477_enable_stp_addr,
-	.reset = ksz9477_reset_switch,
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
index 000000000000..cd278b307b3c
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz9477.h
@@ -0,0 +1,60 @@
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
+void ksz9477_config_cpu_port(struct dsa_switch *ds);
+int ksz9477_enable_stp_addr(struct ksz_device *dev);
+int ksz9477_reset_switch(struct ksz_device *dev);
+int ksz9477_dsa_init(struct ksz_device *dev);
+int ksz9477_switch_init(struct ksz_device *dev);
+void ksz9477_switch_exit(struct ksz_device *dev);
+
+#endif
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d5d1aab54003..59582eb3bcaf 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -21,6 +21,8 @@
 #include <net/switchdev.h>
 
 #include "ksz_common.h"
+#include "ksz8.h"
+#include "ksz9477.h"
 
 #define MIB_COUNTER_NUM 0x20
 
@@ -139,6 +141,66 @@ static const struct ksz_mib_names ksz9477_mib_names[] = {
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
+	.get_caps = ksz8_get_caps,
+	.config_cpu_port = ksz8_config_cpu_port,
+	.enable_stp_addr = ksz8_enable_stp_addr,
+	.reset = ksz8_reset_switch,
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
+	.get_caps = ksz9477_get_caps,
+	.fdb_dump = ksz9477_fdb_dump,
+	.fdb_add = ksz9477_fdb_add,
+	.fdb_del = ksz9477_fdb_del,
+	.mdb_add = ksz9477_mdb_add,
+	.mdb_del = ksz9477_mdb_del,
+	.change_mtu = ksz9477_change_mtu,
+	.max_mtu = ksz9477_max_mtu,
+	.config_cpu_port = ksz9477_config_cpu_port,
+	.enable_stp_addr = ksz9477_enable_stp_addr,
+	.reset = ksz9477_reset_switch,
+	.init = ksz9477_switch_init,
+	.exit = ksz9477_switch_exit,
+};
+
 const struct ksz_chip_data ksz_switch_chips[] = {
 	[KSZ8795] = {
 		.chip_id = KSZ8795_CHIP_ID,
@@ -148,6 +210,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -184,6 +247,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -206,6 +270,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -228,6 +293,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x4,	/* can be configured as cpu port */
 		.port_cnt = 3,
+		.ops = &ksz8_dev_ops,
 		.mib_names = ksz88xx_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -248,6 +314,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -274,6 +341,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -300,6 +368,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
+		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -321,6 +390,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1209,8 +1279,7 @@ struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 }
 EXPORT_SYMBOL(ksz_switch_alloc);
 
-int ksz_switch_register(struct ksz_device *dev,
-			const struct ksz_dev_ops *ops)
+int ksz_switch_register(struct ksz_device *dev)
 {
 	const struct ksz_chip_data *info;
 	struct device_node *port, *ports;
@@ -1257,7 +1326,7 @@ int ksz_switch_register(struct ksz_device *dev,
 	if (ret)
 		return ret;
 
-	dev->dev_ops = ops;
+	dev->dev_ops = dev->info->ops;
 
 	ret = dev->dev_ops->init(dev);
 	if (ret)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 8a2ebce37a49..4d8f09b67c5f 100644
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
@@ -216,8 +217,7 @@ struct ksz_dev_ops {
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
-int ksz_switch_register(struct ksz_device *dev,
-			const struct ksz_dev_ops *ops);
+int ksz_switch_register(struct ksz_device *dev);
 void ksz_switch_remove(struct ksz_device *dev);
 
 int ksz8_switch_register(struct ksz_device *dev);
-- 
2.36.1

