Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4D054F365
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381224AbiFQIpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381304AbiFQIpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:45:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164A369B56;
        Fri, 17 Jun 2022 01:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655455495; x=1686991495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lN3tvcMO1TdS7hL2bGqt2Fs0WdmZTN/VKWy12uBfde0=;
  b=T7pKLg1i5+UmDZXXaodxeXZzie3vcHKZVs1UYDf4OGhRF00aBmDgGsSH
   CAwXE3DWWI4MZaS7UtIFoLhDkr0ml8Lm0LJfvxOaxM0vgYgOo5oQr+u3W
   HbLo2NLeglCWR7Yjt0VLhhKj0lc4O/fZvcIkMZz+6lzZh/m42kgqJHoq/
   kTcZqJN8efXPjlWzMAKAXHaaRf3DRBijQiGeES1mVPDbtoVPlJY6NuYEP
   OihanFoYENJyI9capSAu+jThuCb/IN0Q3spf91ed6OtBCSBNirHDKU2zG
   PHcVAN5IM2vHWhaq4jrU7d5zeKrW5fB55G53PG5Py2orNIflTLKWKVY3O
   g==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="168803906"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2022 01:44:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Jun 2022 01:44:54 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Jun 2022 01:44:50 -0700
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
Subject: [Patch net-next 09/11] net: dsa: microchip: update the ksz_port_mdb_add/del
Date:   Fri, 17 Jun 2022 14:12:53 +0530
Message-ID: <20220617084255.19376-10-arun.ramadoss@microchip.com>
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

ksz_mdb_add/del in ksz_common.c is specific for the ksz8795.c file. The
ksz9477 has its separate ksz9477_port_mdb_add/del functions.  This patch
moves the ksz8795 specific mdb functionality from ksz_common to ksz8795.
And this dsa_switch_ops hooks for ksz8795/ksz9477 are invoked through
the ksz_port_mdb_add/del.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 76 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz9477.c    | 20 +++----
 drivers/net/dsa/microchip/ksz_common.c | 64 ++--------------------
 drivers/net/dsa/microchip/ksz_common.h |  6 ++
 4 files changed, 98 insertions(+), 68 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 440779a2cca6..7ebed00777b9 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -953,6 +953,80 @@ static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
+static int ksz8_mdb_add(struct ksz_device *dev, int port,
+			const struct switchdev_obj_port_mdb *mdb,
+			struct dsa_db db)
+{
+	struct alu_struct alu;
+	int index;
+	int empty = 0;
+
+	alu.port_forward = 0;
+	for (index = 0; index < dev->info->num_statics; index++) {
+		if (!dev->dev_ops->r_sta_mac_table(dev, index, &alu)) {
+			/* Found one already in static MAC table. */
+			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
+			    alu.fid == mdb->vid)
+				break;
+		/* Remember the first empty entry. */
+		} else if (!empty) {
+			empty = index + 1;
+		}
+	}
+
+	/* no available entry */
+	if (index == dev->info->num_statics && !empty)
+		return -ENOSPC;
+
+	/* add entry */
+	if (index == dev->info->num_statics) {
+		index = empty - 1;
+		memset(&alu, 0, sizeof(alu));
+		memcpy(alu.mac, mdb->addr, ETH_ALEN);
+		alu.is_static = true;
+	}
+	alu.port_forward |= BIT(port);
+	if (mdb->vid) {
+		alu.is_use_fid = true;
+
+		/* Need a way to map VID to FID. */
+		alu.fid = mdb->vid;
+	}
+	dev->dev_ops->w_sta_mac_table(dev, index, &alu);
+
+	return 0;
+}
+
+static int ksz8_mdb_del(struct ksz_device *dev, int port,
+			const struct switchdev_obj_port_mdb *mdb,
+			struct dsa_db db)
+{
+	struct alu_struct alu;
+	int index;
+
+	for (index = 0; index < dev->info->num_statics; index++) {
+		if (!dev->dev_ops->r_sta_mac_table(dev, index, &alu)) {
+			/* Found one already in static MAC table. */
+			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
+			    alu.fid == mdb->vid)
+				break;
+		}
+	}
+
+	/* no available entry */
+	if (index == dev->info->num_statics)
+		goto exit;
+
+	/* clear port */
+	alu.port_forward &= ~BIT(port);
+	if (!alu.port_forward)
+		alu.is_static = false;
+	dev->dev_ops->w_sta_mac_table(dev, index, &alu);
+
+exit:
+	return 0;
+}
+
 static int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
 				    struct netlink_ext_ack *extack)
 {
@@ -1449,6 +1523,8 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.r_mib_pkt = ksz8_r_mib_pkt,
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
+	.mdb_add = ksz8_mdb_add,
+	.mdb_del = ksz8_mdb_del,
 	.vlan_filtering = ksz8_port_vlan_filtering,
 	.vlan_add = ksz8_port_vlan_add,
 	.vlan_del = ksz8_port_vlan_del,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index c90a807610c0..95e1c7b20190 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -653,11 +653,10 @@ static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
 	return ret;
 }
 
-static int ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb,
-				struct dsa_db db)
+static int ksz9477_mdb_add(struct ksz_device *dev, int port,
+			   const struct switchdev_obj_port_mdb *mdb,
+			   struct dsa_db db)
 {
-	struct ksz_device *dev = ds->priv;
 	u32 static_table[4];
 	u32 data;
 	int index;
@@ -729,11 +728,10 @@ static int ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 	return err;
 }
 
-static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb,
-				struct dsa_db db)
+static int ksz9477_mdb_del(struct ksz_device *dev, int port,
+			   const struct switchdev_obj_port_mdb *mdb,
+			   struct dsa_db db)
 {
-	struct ksz_device *dev = ds->priv;
 	u32 static_table[4];
 	u32 data;
 	int index;
@@ -1315,8 +1313,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_fdb_dump		= ksz9477_port_fdb_dump,
 	.port_fdb_add		= ksz9477_port_fdb_add,
 	.port_fdb_del		= ksz9477_port_fdb_del,
-	.port_mdb_add           = ksz9477_port_mdb_add,
-	.port_mdb_del           = ksz9477_port_mdb_del,
+	.port_mdb_add           = ksz_port_mdb_add,
+	.port_mdb_del           = ksz_port_mdb_del,
 	.port_mirror_add	= ksz_port_mirror_add,
 	.port_mirror_del	= ksz_port_mirror_del,
 	.get_stats64		= ksz_get_stats64,
@@ -1399,6 +1397,8 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
 	.get_caps = ksz9477_get_caps,
+	.mdb_add = ksz9477_mdb_add,
+	.mdb_del = ksz9477_mdb_del,
 	.shutdown = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 827ca7522a20..ce3037e9d548 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -814,44 +814,11 @@ int ksz_port_mdb_add(struct dsa_switch *ds, int port,
 		     struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
-	struct alu_struct alu;
-	int index;
-	int empty = 0;
-
-	alu.port_forward = 0;
-	for (index = 0; index < dev->info->num_statics; index++) {
-		if (!dev->dev_ops->r_sta_mac_table(dev, index, &alu)) {
-			/* Found one already in static MAC table. */
-			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
-			    alu.fid == mdb->vid)
-				break;
-		/* Remember the first empty entry. */
-		} else if (!empty) {
-			empty = index + 1;
-		}
-	}
-
-	/* no available entry */
-	if (index == dev->info->num_statics && !empty)
-		return -ENOSPC;
 
-	/* add entry */
-	if (index == dev->info->num_statics) {
-		index = empty - 1;
-		memset(&alu, 0, sizeof(alu));
-		memcpy(alu.mac, mdb->addr, ETH_ALEN);
-		alu.is_static = true;
-	}
-	alu.port_forward |= BIT(port);
-	if (mdb->vid) {
-		alu.is_use_fid = true;
-
-		/* Need a way to map VID to FID. */
-		alu.fid = mdb->vid;
-	}
-	dev->dev_ops->w_sta_mac_table(dev, index, &alu);
+	if (!dev->dev_ops->mdb_add)
+		return -EOPNOTSUPP;
 
-	return 0;
+	return dev->dev_ops->mdb_add(dev, port, mdb, db);
 }
 EXPORT_SYMBOL_GPL(ksz_port_mdb_add);
 
@@ -860,30 +827,11 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 		     struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
-	struct alu_struct alu;
-	int index;
-
-	for (index = 0; index < dev->info->num_statics; index++) {
-		if (!dev->dev_ops->r_sta_mac_table(dev, index, &alu)) {
-			/* Found one already in static MAC table. */
-			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
-			    alu.fid == mdb->vid)
-				break;
-		}
-	}
 
-	/* no available entry */
-	if (index == dev->info->num_statics)
-		goto exit;
-
-	/* clear port */
-	alu.port_forward &= ~BIT(port);
-	if (!alu.port_forward)
-		alu.is_static = false;
-	dev->dev_ops->w_sta_mac_table(dev, index, &alu);
+	if (!dev->dev_ops->mdb_del)
+		return -EOPNOTSUPP;
 
-exit:
-	return 0;
+	return dev->dev_ops->mdb_del(dev, port, mdb, db);
 }
 EXPORT_SYMBOL_GPL(ksz_port_mdb_del);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index af5f37dbb2ab..4bc10165460f 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -193,6 +193,12 @@ struct ksz_dev_ops {
 			  bool ingress, struct netlink_ext_ack *extack);
 	void (*mirror_del)(struct ksz_device *dev, int port,
 			   struct dsa_mall_mirror_tc_entry *mirror);
+	int (*mdb_add)(struct ksz_device *dev, int port,
+		       const struct switchdev_obj_port_mdb *mdb,
+		       struct dsa_db db);
+	int (*mdb_del)(struct ksz_device *dev, int port,
+		       const struct switchdev_obj_port_mdb *mdb,
+		       struct dsa_db db);
 	void (*get_caps)(struct ksz_device *dev, int port,
 			 struct phylink_config *config);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
-- 
2.36.1

