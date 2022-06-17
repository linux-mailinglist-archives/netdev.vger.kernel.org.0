Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E61E54F35D
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381300AbiFQIpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381327AbiFQIpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:45:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F70969CD1;
        Fri, 17 Jun 2022 01:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655455502; x=1686991502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pvCYWkwWNMaYPiBb8SxJKYQT4lIQCN/6f0r7LqthPMo=;
  b=KDIAMqYL4iQ4L66QuqU13WlV6grJWbC6VhoLGfpEt5snFAj3wiFzgHet
   cugGsyoWo3XBLBaoGU9IQ1p2OGl1wtQvUzHUQeyjOmnnd7BBzLwZ9Xwnt
   hW0i2RGeSWzrxVQoCNBSq5J7PteydZIrHNeqkMTxei3GaoWPebL/GqcnS
   NncJKSKcDx0x0sTx9Tjd4bFmWxEFCPq5El09RWtpvmz82+96bHfL/NKdV
   BiCPlr35Fg/EWfrqu/s8Ix45v9y6DztwdQ79TvWAxoC4ApxgGRxiCJoMe
   jyPcYJVIq2zW3aG0KAYTO0dmqC0DkLFcwfkkuIkcFK2vf6PcLt/d67BBX
   A==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="163828830"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2022 01:45:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Jun 2022 01:45:01 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Jun 2022 01:44:57 -0700
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
Subject: [Patch net-next 10/11] net: dsa: microchip: update fdb add/del/dump in ksz_common
Date:   Fri, 17 Jun 2022 14:12:54 +0530
Message-ID: <20220617084255.19376-11-arun.ramadoss@microchip.com>
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

This patch makes the dsa_switch_hook for fdbs to use ksz_common.c file.
And from ksz_common, individual switches fdb functions are called using
the dev->dev_ops. And removed the r_dyn_mac_table, r_sta_mac_table and
w_sta_mac_table from ksz_dev_ops as it is used only in ksz8795.c

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 40 ++++++++++++++++----
 drivers/net/dsa/microchip/ksz9477.c    | 28 +++++++-------
 drivers/net/dsa/microchip/ksz_common.c | 51 ++++++++++++++------------
 drivers/net/dsa/microchip/ksz_common.h | 17 +++++----
 4 files changed, 85 insertions(+), 51 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 7ebed00777b9..2f93b921b45e 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -953,6 +953,34 @@ static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
+static int ksz8_fdb_dump(struct ksz_device *dev, int port,
+			 dsa_fdb_dump_cb_t *cb, void *data)
+{
+	int ret = 0;
+	u16 i = 0;
+	u16 entries = 0;
+	u8 timestamp = 0;
+	u8 fid;
+	u8 member;
+	struct alu_struct alu;
+
+	do {
+		alu.is_static = false;
+		ret = ksz8_r_dyn_mac_table(dev, i, alu.mac, &fid, &member,
+					   &timestamp, &entries);
+		if (!ret && (member & BIT(port))) {
+			ret = cb(alu.mac, alu.fid, alu.is_static, data);
+			if (ret)
+				break;
+		}
+		i++;
+	} while (i < entries);
+	if (i >= entries)
+		ret = 0;
+
+	return ret;
+}
+
 static int ksz8_mdb_add(struct ksz_device *dev, int port,
 			const struct switchdev_obj_port_mdb *mdb,
 			struct dsa_db db)
@@ -963,7 +991,7 @@ static int ksz8_mdb_add(struct ksz_device *dev, int port,
 
 	alu.port_forward = 0;
 	for (index = 0; index < dev->info->num_statics; index++) {
-		if (!dev->dev_ops->r_sta_mac_table(dev, index, &alu)) {
+		if (!ksz8_r_sta_mac_table(dev, index, &alu)) {
 			/* Found one already in static MAC table. */
 			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
 			    alu.fid == mdb->vid)
@@ -992,7 +1020,7 @@ static int ksz8_mdb_add(struct ksz_device *dev, int port,
 		/* Need a way to map VID to FID. */
 		alu.fid = mdb->vid;
 	}
-	dev->dev_ops->w_sta_mac_table(dev, index, &alu);
+	ksz8_w_sta_mac_table(dev, index, &alu);
 
 	return 0;
 }
@@ -1005,7 +1033,7 @@ static int ksz8_mdb_del(struct ksz_device *dev, int port,
 	int index;
 
 	for (index = 0; index < dev->info->num_statics; index++) {
-		if (!dev->dev_ops->r_sta_mac_table(dev, index, &alu)) {
+		if (!ksz8_r_sta_mac_table(dev, index, &alu)) {
 			/* Found one already in static MAC table. */
 			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
 			    alu.fid == mdb->vid)
@@ -1021,7 +1049,7 @@ static int ksz8_mdb_del(struct ksz_device *dev, int port,
 	alu.port_forward &= ~BIT(port);
 	if (!alu.port_forward)
 		alu.is_static = false;
-	dev->dev_ops->w_sta_mac_table(dev, index, &alu);
+	ksz8_w_sta_mac_table(dev, index, &alu);
 
 exit:
 	return 0;
@@ -1516,13 +1544,11 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.port_setup = ksz8_port_setup,
 	.r_phy = ksz8_r_phy,
 	.w_phy = ksz8_w_phy,
-	.r_dyn_mac_table = ksz8_r_dyn_mac_table,
-	.r_sta_mac_table = ksz8_r_sta_mac_table,
-	.w_sta_mac_table = ksz8_w_sta_mac_table,
 	.r_mib_cnt = ksz8_r_mib_cnt,
 	.r_mib_pkt = ksz8_r_mib_pkt,
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
+	.fdb_dump = ksz8_fdb_dump,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
 	.vlan_filtering = ksz8_port_vlan_filtering,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 95e1c7b20190..1213ff643d05 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -452,11 +452,10 @@ static int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid,
-				struct dsa_db db)
+static int ksz9477_fdb_add(struct ksz_device *dev, int port,
+			   const unsigned char *addr, u16 vid,
+			   struct dsa_db db)
 {
-	struct ksz_device *dev = ds->priv;
 	u32 alu_table[4];
 	u32 data;
 	int ret = 0;
@@ -510,11 +509,10 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 	return ret;
 }
 
-static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid,
-				struct dsa_db db)
+static int ksz9477_fdb_del(struct ksz_device *dev, int port,
+			   const unsigned char *addr, u16 vid,
+			   struct dsa_db db)
 {
-	struct ksz_device *dev = ds->priv;
 	u32 alu_table[4];
 	u32 data;
 	int ret = 0;
@@ -601,10 +599,9 @@ static void ksz9477_convert_alu(struct alu_struct *alu, u32 *alu_table)
 	alu->mac[5] = alu_table[3] & 0xFF;
 }
 
-static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
-				 dsa_fdb_dump_cb_t *cb, void *data)
+static int ksz9477_fdb_dump(struct ksz_device *dev, int port,
+			    dsa_fdb_dump_cb_t *cb, void *data)
 {
-	struct ksz_device *dev = ds->priv;
 	int ret = 0;
 	u32 ksz_data;
 	u32 alu_table[4];
@@ -1310,9 +1307,9 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_vlan_filtering	= ksz_port_vlan_filtering,
 	.port_vlan_add		= ksz_port_vlan_add,
 	.port_vlan_del		= ksz_port_vlan_del,
-	.port_fdb_dump		= ksz9477_port_fdb_dump,
-	.port_fdb_add		= ksz9477_port_fdb_add,
-	.port_fdb_del		= ksz9477_port_fdb_del,
+	.port_fdb_dump		= ksz_port_fdb_dump,
+	.port_fdb_add		= ksz_port_fdb_add,
+	.port_fdb_del		= ksz_port_fdb_del,
 	.port_mdb_add           = ksz_port_mdb_add,
 	.port_mdb_del           = ksz_port_mdb_del,
 	.port_mirror_add	= ksz_port_mirror_add,
@@ -1397,6 +1394,9 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
 	.get_caps = ksz9477_get_caps,
+	.fdb_dump = ksz9477_fdb_dump,
+	.fdb_add = ksz9477_fdb_add,
+	.fdb_del = ksz9477_fdb_del,
 	.mdb_add = ksz9477_mdb_add,
 	.mdb_del = ksz9477_mdb_del,
 	.shutdown = ksz9477_reset_switch,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index ce3037e9d548..5e98e39e4c40 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -778,34 +778,39 @@ void ksz_port_fast_age(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL_GPL(ksz_port_fast_age);
 
+int ksz_port_fdb_add(struct dsa_switch *ds, int port,
+		     const unsigned char *addr, u16 vid, struct dsa_db db)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (!dev->dev_ops->fdb_add)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->fdb_add(dev, port, addr, vid, db);
+}
+EXPORT_SYMBOL_GPL(ksz_port_fdb_add);
+
+int ksz_port_fdb_del(struct dsa_switch *ds, int port,
+		     const unsigned char *addr, u16 vid, struct dsa_db db)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (!dev->dev_ops->fdb_del)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->fdb_del(dev, port, addr, vid, db);
+}
+EXPORT_SYMBOL_GPL(ksz_port_fdb_del);
+
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data)
 {
 	struct ksz_device *dev = ds->priv;
-	int ret = 0;
-	u16 i = 0;
-	u16 entries = 0;
-	u8 timestamp = 0;
-	u8 fid;
-	u8 member;
-	struct alu_struct alu;
-
-	do {
-		alu.is_static = false;
-		ret = dev->dev_ops->r_dyn_mac_table(dev, i, alu.mac, &fid,
-						    &member, &timestamp,
-						    &entries);
-		if (!ret && (member & BIT(port))) {
-			ret = cb(alu.mac, alu.fid, alu.is_static, data);
-			if (ret)
-				break;
-		}
-		i++;
-	} while (i < entries);
-	if (i >= entries)
-		ret = 0;
 
-	return ret;
+	if (!dev->dev_ops->fdb_dump)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->fdb_dump(dev, port, cb, data);
 }
 EXPORT_SYMBOL_GPL(ksz_port_fdb_dump);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 4bc10165460f..e507e951ce2b 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -169,13 +169,6 @@ struct ksz_dev_ops {
 	void (*port_setup)(struct ksz_device *dev, int port, bool cpu_port);
 	void (*r_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
 	void (*w_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
-	int (*r_dyn_mac_table)(struct ksz_device *dev, u16 addr, u8 *mac_addr,
-			       u8 *fid, u8 *src_port, u8 *timestamp,
-			       u16 *entries);
-	int (*r_sta_mac_table)(struct ksz_device *dev, u16 addr,
-			       struct alu_struct *alu);
-	void (*w_sta_mac_table)(struct ksz_device *dev, u16 addr,
-				struct alu_struct *alu);
 	void (*r_mib_cnt)(struct ksz_device *dev, int port, u16 addr,
 			  u64 *cnt);
 	void (*r_mib_pkt)(struct ksz_device *dev, int port, u16 addr,
@@ -193,6 +186,12 @@ struct ksz_dev_ops {
 			  bool ingress, struct netlink_ext_ack *extack);
 	void (*mirror_del)(struct ksz_device *dev, int port,
 			   struct dsa_mall_mirror_tc_entry *mirror);
+	int (*fdb_add)(struct ksz_device *dev, int port,
+		       const unsigned char *addr, u16 vid, struct dsa_db db);
+	int (*fdb_del)(struct ksz_device *dev, int port,
+		       const unsigned char *addr, u16 vid, struct dsa_db db);
+	int (*fdb_dump)(struct ksz_device *dev, int port,
+			dsa_fdb_dump_cb_t *cb, void *data);
 	int (*mdb_add)(struct ksz_device *dev, int port,
 		       const struct switchdev_obj_port_mdb *mdb,
 		       struct dsa_db db);
@@ -239,6 +238,10 @@ void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
+int ksz_port_fdb_add(struct dsa_switch *ds, int port,
+		     const unsigned char *addr, u16 vid, struct dsa_db db);
+int ksz_port_fdb_del(struct dsa_switch *ds, int port,
+		     const unsigned char *addr, u16 vid, struct dsa_db db);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
 int ksz_port_mdb_add(struct dsa_switch *ds, int port,
-- 
2.36.1

