Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C47E54F36C
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381403AbiFQIpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381312AbiFQIpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:45:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A93569CFB;
        Fri, 17 Jun 2022 01:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655455512; x=1686991512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uk+n0I8GWOYKIi0v7lHVXzSbCHRx1vQYNucjrMSj1hI=;
  b=0LmtPmu4h45dfJuL9YYpPj5SI8hXx5ZbOBVbbLprxQK4A2oalkT8YoEm
   o7NNU3dWvQgtAisNFLOEo0HsDQL0VohIXhsAvxz6WAkoJuKS1pIA1D0Yw
   mP0hth04fxJrnB/bf39Wf7j/OMiZHOoF6FirIKoP2BxkPiKH6Y8/xWyz4
   9eiNUr1zsV8A+GkdY2qMd0kayKfyvcM2y/w6p4dlSpmt036ZVhFiBsMXO
   ufzlRp74yJ8xWbTakFSBqPdKdcrqy0gJ/dcn+nLvUeITIhfgzbFIAsF13
   7sn9omGWCCbZFDuigHue0r7tw/ewp1HNy/0H+5TBjZf30FOun1HdNPSJ1
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="100484991"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2022 01:45:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Jun 2022 01:45:10 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Jun 2022 01:45:05 -0700
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
Subject: [Patch net-next 11/11] net: dsa: microchip: move get_phy_flags & mtu to ksz_common
Date:   Fri, 17 Jun 2022 14:12:55 +0530
Message-ID: <20220617084255.19376-12-arun.ramadoss@microchip.com>
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

This patch assigns the get_phy_flags & mtu  hook of ksz8795 and ksz9477
in dsa_switch_ops to ksz_common.  For get_phy_flags hooks,checks whether
the chip is ksz8863/kss8793 then it returns error for port1.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 14 +--------
 drivers/net/dsa/microchip/ksz9477.c    | 11 +++----
 drivers/net/dsa/microchip/ksz_common.c | 40 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  5 ++++
 4 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 2f93b921b45e..23ed05f4efcc 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -898,18 +898,6 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 	}
 }
 
-static u32 ksz8_sw_get_phy_flags(struct dsa_switch *ds, int port)
-{
-	/* Silicon Errata Sheet (DS80000830A):
-	 * Port 1 does not work with LinkMD Cable-Testing.
-	 * Port 1 does not respond to received PAUSE control frames.
-	 */
-	if (!port)
-		return MICREL_KSZ8_P1_ERRATA;
-
-	return 0;
-}
-
 static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 {
 	u8 data;
@@ -1470,7 +1458,7 @@ static void ksz8_get_caps(struct ksz_device *dev, int port,
 
 static const struct dsa_switch_ops ksz8_switch_ops = {
 	.get_tag_protocol	= ksz_get_tag_protocol,
-	.get_phy_flags		= ksz8_sw_get_phy_flags,
+	.get_phy_flags		= ksz_get_phy_flags,
 	.setup			= ksz8_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 1213ff643d05..5b4fc16e1692 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -47,9 +47,8 @@ static void ksz9477_port_cfg32(struct ksz_device *dev, int port, int offset,
 			   bits, set ? bits : 0);
 }
 
-static int ksz9477_change_mtu(struct dsa_switch *ds, int port, int mtu)
+static int ksz9477_change_mtu(struct ksz_device *dev, int port, int mtu)
 {
-	struct ksz_device *dev = ds->priv;
 	u16 frame_size, max_frame = 0;
 	int i;
 
@@ -65,7 +64,7 @@ static int ksz9477_change_mtu(struct dsa_switch *ds, int port, int mtu)
 				  REG_SW_MTU_MASK, max_frame);
 }
 
-static int ksz9477_max_mtu(struct dsa_switch *ds, int port)
+static int ksz9477_max_mtu(struct ksz_device *dev, int port)
 {
 	return KSZ9477_MAX_FRAME_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
 }
@@ -1315,8 +1314,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_mirror_add	= ksz_port_mirror_add,
 	.port_mirror_del	= ksz_port_mirror_del,
 	.get_stats64		= ksz_get_stats64,
-	.port_change_mtu	= ksz9477_change_mtu,
-	.port_max_mtu		= ksz9477_max_mtu,
+	.port_change_mtu	= ksz_change_mtu,
+	.port_max_mtu		= ksz_max_mtu,
 };
 
 static u32 ksz9477_get_port_addr(int port, int offset)
@@ -1399,6 +1398,8 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.fdb_del = ksz9477_fdb_del,
 	.mdb_add = ksz9477_mdb_add,
 	.mdb_del = ksz9477_mdb_del,
+	.change_mtu = ksz9477_change_mtu,
+	.max_mtu = ksz9477_max_mtu,
 	.shutdown = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 5e98e39e4c40..3fc401959f00 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -16,6 +16,7 @@
 #include <linux/if_bridge.h>
 #include <linux/of_device.h>
 #include <linux/of_net.h>
+#include <linux/micrel_phy.h>
 #include <net/dsa.h>
 #include <net/switchdev.h>
 
@@ -705,6 +706,23 @@ int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val)
 }
 EXPORT_SYMBOL_GPL(ksz_phy_write16);
 
+u32 ksz_get_phy_flags(struct dsa_switch *ds, int port)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (dev->chip_id == KSZ8830_CHIP_ID) {
+		/* Silicon Errata Sheet (DS80000830A):
+		 * Port 1 does not work with LinkMD Cable-Testing.
+		 * Port 1 does not respond to received PAUSE control frames.
+		 */
+		if (!port)
+			return MICREL_KSZ8_P1_ERRATA;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ksz_get_phy_flags);
+
 void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 		       phy_interface_t interface)
 {
@@ -984,6 +1002,28 @@ void ksz_port_mirror_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_port_mirror_del);
 
+int ksz_change_mtu(struct dsa_switch *ds, int port, int mtu)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (!dev->dev_ops->change_mtu)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->change_mtu(dev, port, mtu);
+}
+EXPORT_SYMBOL_GPL(ksz_change_mtu);
+
+int ksz_max_mtu(struct dsa_switch *ds, int port)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (!dev->dev_ops->max_mtu)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->max_mtu(dev, port);
+}
+EXPORT_SYMBOL_GPL(ksz_max_mtu);
+
 static int ksz_switch_detect(struct ksz_device *dev)
 {
 	u8 id1, id2;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index e507e951ce2b..ebcfa688ea2c 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -200,6 +200,8 @@ struct ksz_dev_ops {
 		       struct dsa_db db);
 	void (*get_caps)(struct ksz_device *dev, int port,
 			 struct phylink_config *config);
+	int (*change_mtu)(struct ksz_device *dev, int port, int mtu);
+	int (*max_mtu)(struct ksz_device *dev, int port);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
@@ -227,6 +229,7 @@ extern const struct ksz_chip_data ksz_switch_chips[];
 
 int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg);
 int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val);
+u32 ksz_get_phy_flags(struct dsa_switch *ds, int port);
 void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 		       phy_interface_t interface);
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
@@ -267,6 +270,8 @@ int ksz_port_mirror_add(struct dsa_switch *ds, int port,
 			bool ingress, struct netlink_ext_ack *extack);
 void ksz_port_mirror_del(struct dsa_switch *ds, int port,
 			 struct dsa_mall_mirror_tc_entry *mirror);
+int ksz_change_mtu(struct dsa_switch *ds, int port, int mtu);
+int ksz_max_mtu(struct dsa_switch *ds, int port);
 
 /* Common register access functions */
 
-- 
2.36.1

