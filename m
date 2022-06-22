Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915F2554658
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357098AbiFVJJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357417AbiFVJIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:08:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF633B294;
        Wed, 22 Jun 2022 02:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888837; x=1687424837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cc5/cgPrPK1aVpFLqwticyalG9c5OBsR+RbNPPNIVSY=;
  b=gXT0LxSRqshX9Ks0pynSCRlapLeVxHwpyPRFivDwe9DUT0eKe49A4esH
   IM5b7Xe/x6PR6r0Qh6pNrlzRr5i+vjyxln9hMZuMrCjV65VP0yqvRZJxe
   Dm0ce7XHm4FvkkCihBcJFEizdvF/kF8WhxooP3NLddOt3Dt/UprnBnEf9
   3ID2paHkJmVuHbrKrV+YRGNPQR8Qn7f+g9+Vu1IP6HdE53JxbFkQu/xPA
   HwkFMAhpfuth1OYSBG9LpAV7WETcqbt0W186wpk90zuahfKWR1IAvlwXF
   n5+jsQd/Z4FJh4938kzIJHmIh9dnhRKooCbkFNTwtmdS9x+Gbb3CoqP0t
   w==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="179017210"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:07:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:07:16 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:07:11 -0700
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
Subject: [Patch net-next 04/13] net: dsa: microchip: move setup function to ksz_common
Date:   Wed, 22 Jun 2022 14:34:16 +0530
Message-ID: <20220622090425.17709-5-arun.ramadoss@microchip.com>
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

This patch move the common initialization of switches to ksz_setup and
perform the switch specific initialization using the ksz_dev_ops
function pointer.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 24 +++---------------
 drivers/net/dsa/microchip/ksz9477.c    | 22 ++---------------
 drivers/net/dsa/microchip/ksz_common.c | 34 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  2 ++
 4 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 30052dc5b9a1..3d692d5816cb 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1387,18 +1387,7 @@ static int ksz8_enable_stp_addr(struct ksz_device *dev)
 static int ksz8_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
-	int i, ret = 0;
-
-	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
-				       dev->info->num_vlans, GFP_KERNEL);
-	if (!dev->vlan_cache)
-		return -ENOMEM;
-
-	ret = dev->dev_ops->reset(dev);
-	if (ret) {
-		dev_err(ds->dev, "failed to reset switch\n");
-		return ret;
-	}
+	int i;
 
 	ksz_cfg(dev, S_REPLACE_VID_CTRL, SW_FLOW_CTRL, true);
 
@@ -1417,8 +1406,6 @@ static int ksz8_setup(struct dsa_switch *ds)
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP,
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP);
 
-	dev->dev_ops->config_cpu_port(ds);
-
 	ksz_cfg(dev, REG_SW_CTRL_2, MULTICAST_STORM_DISABLE, true);
 
 	ksz_cfg(dev, S_REPLACE_VID_CTRL, SW_REPLACE_VID, false);
@@ -1437,12 +1424,6 @@ static int ksz8_setup(struct dsa_switch *ds)
 	for (i = 0; i < (dev->info->num_vlans / 4); i++)
 		ksz8_r_vlan_entries(dev, i);
 
-	dev->dev_ops->enable_stp_addr(dev);
-
-	ksz_init_mib_timer(dev);
-
-	ds->configure_vlan_while_not_filtering = false;
-
 	return ksz8_handle_global_errata(ds);
 }
 
@@ -1467,7 +1448,7 @@ static void ksz8_get_caps(struct ksz_device *dev, int port,
 static const struct dsa_switch_ops ksz8_switch_ops = {
 	.get_tag_protocol	= ksz_get_tag_protocol,
 	.get_phy_flags		= ksz_get_phy_flags,
-	.setup			= ksz8_setup,
+	.setup			= ksz_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
 	.phylink_get_caps	= ksz_phylink_get_caps,
@@ -1534,6 +1515,7 @@ static void ksz8_switch_exit(struct ksz_device *dev)
 }
 
 static const struct ksz_dev_ops ksz8_dev_ops = {
+	.setup = ksz8_setup,
 	.get_port_addr = ksz8_get_port_addr,
 	.cfg_port_member = ksz8_cfg_port_member,
 	.flush_dyn_mac_table = ksz8_flush_dyn_mac_table,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 6ca0d5753df0..c8965012d1c7 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1271,17 +1271,6 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	struct ksz_device *dev = ds->priv;
 	int ret = 0;
 
-	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
-				       dev->info->num_vlans, GFP_KERNEL);
-	if (!dev->vlan_cache)
-		return -ENOMEM;
-
-	ret = dev->dev_ops->reset(dev);
-	if (ret) {
-		dev_err(ds->dev, "failed to reset switch\n");
-		return ret;
-	}
-
 	/* Required for port partitioning. */
 	ksz9477_cfg32(dev, REG_SW_QM_CTRL__4, UNICAST_VLAN_BOUNDARY,
 		      true);
@@ -1298,8 +1287,6 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	dev->dev_ops->config_cpu_port(ds);
-
 	ksz_cfg(dev, REG_SW_MAC_CTRL_1, MULTICAST_STORM_DISABLE, true);
 
 	/* queue based egress rate limit */
@@ -1311,18 +1298,12 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	/* start switch */
 	ksz_cfg(dev, REG_SW_OPERATION, SW_START, true);
 
-	dev->dev_ops->enable_stp_addr(dev);
-
-	ksz_init_mib_timer(dev);
-
-	ds->configure_vlan_while_not_filtering = false;
-
 	return 0;
 }
 
 static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.get_tag_protocol	= ksz_get_tag_protocol,
-	.setup			= ksz9477_setup,
+	.setup			= ksz_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
@@ -1408,6 +1389,7 @@ static void ksz9477_switch_exit(struct ksz_device *dev)
 }
 
 static const struct ksz_dev_ops ksz9477_dev_ops = {
+	.setup = ksz9477_setup,
 	.get_port_addr = ksz9477_get_port_addr,
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 3fc401959f00..792f891579ae 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -607,6 +607,40 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
 	dev->dev_ops->cfg_port_member(dev, port, port_member | cpu_port);
 }
 
+int ksz_setup(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret;
+
+	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
+				       dev->info->num_vlans, GFP_KERNEL);
+	if (!dev->vlan_cache)
+		return -ENOMEM;
+
+	ret = dev->dev_ops->reset(dev);
+	if (ret) {
+		dev_err(ds->dev, "failed to reset switch\n");
+		return ret;
+	}
+
+	dev->dev_ops->config_cpu_port(ds);
+
+	dev->dev_ops->enable_stp_addr(dev);
+
+	ksz_init_mib_timer(dev);
+
+	ds->configure_vlan_while_not_filtering = false;
+
+	if (dev->dev_ops->setup) {
+		ret = dev->dev_ops->setup(ds);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ksz_setup);
+
 static void port_r_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index e38bdf1f5b41..3b8e1d1887b8 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -162,6 +162,7 @@ struct alu_struct {
 };
 
 struct ksz_dev_ops {
+	int (*setup)(struct dsa_switch *ds);
 	u32 (*get_port_addr)(int port, int offset);
 	void (*cfg_port_member)(struct ksz_device *dev, int port, u8 member);
 	void (*flush_dyn_mac_table)(struct ksz_device *dev, int port);
@@ -229,6 +230,7 @@ extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common DSA access functions */
 
+int ksz_setup(struct dsa_switch *ds);
 int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg);
 int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val);
 u32 ksz_get_phy_flags(struct dsa_switch *ds, int port);
-- 
2.36.1

