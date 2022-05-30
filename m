Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5926D537947
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbiE3Kn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbiE3Kny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:43:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970F37C174;
        Mon, 30 May 2022 03:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653907419; x=1685443419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FpYsCWC+30aXZIz3b7yNzZn1MmMwXyIwSgDyVY2tRfY=;
  b=cleXRr4MMLAgB0Vtd2goNq7ksezlL78p/trlmMdz838IFXxM4vNRb/iX
   +1dmLuRLSMLt81x7oD3CAsLzLQTJUIrUBXmsN+Iksfw9HIXdT/sYbUWox
   Gq40ACPNZvLxekmUEn3npm9TcoWANozCNpHqiJ4jSQExvALxPAaUdsMoT
   TRMs9PWtX71KHAP91mkLR1btQsFOPt2ovIHTaCmXVdVqkiHL4uCOXEdTG
   uHcGAM78BzOwzBX8fA2xyyybfgEyk1vk6KzWJKJVb90EvMnIh9zOxBdLC
   Qa4+nYMDagPS7TXQ625ro+bUpOo0CsaGGGoP74qU22O8h1FwTHy5j8EEs
   g==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="175663004"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2022 03:43:39 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 30 May 2022 03:43:38 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 30 May 2022 03:43:34 -0700
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
Subject: [RFC Patch net-next v2 03/15] net: dsa: microchip: move tag_protocol & phy read/write to ksz_common
Date:   Mon, 30 May 2022 16:12:45 +0530
Message-ID: <20220530104257.21485-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530104257.21485-1-arun.ramadoss@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
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

This patch move the dsa hook get_tag_protocol to ksz_common file. And
the tag_protocol is returned based on the dev->chip_id.
ksz8795 and ksz9477 implementation on phy read/write hooks are
different. This patch modifies the ksz9477 implementation same as
ksz8795 by updating the ksz9477_dev_ops structure.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 13 +--------
 drivers/net/dsa/microchip/ksz9477.c    | 37 ++++++++------------------
 drivers/net/dsa/microchip/ksz_common.c | 24 +++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  2 ++
 4 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 927db57d02db..6e5f665fa1f6 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -898,17 +898,6 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 	}
 }
 
-static enum dsa_tag_protocol ksz8_get_tag_protocol(struct dsa_switch *ds,
-						   int port,
-						   enum dsa_tag_protocol mp)
-{
-	struct ksz_device *dev = ds->priv;
-
-	/* ksz88x3 uses the same tag schema as KSZ9893 */
-	return ksz_is_ksz88x3(dev) ?
-		DSA_TAG_PROTO_KSZ9893 : DSA_TAG_PROTO_KSZ8795;
-}
-
 static u32 ksz8_sw_get_phy_flags(struct dsa_switch *ds, int port)
 {
 	/* Silicon Errata Sheet (DS80000830A):
@@ -1394,7 +1383,7 @@ static void ksz8_get_caps(struct dsa_switch *ds, int port,
 }
 
 static const struct dsa_switch_ops ksz8_switch_ops = {
-	.get_tag_protocol	= ksz8_get_tag_protocol,
+	.get_tag_protocol	= ksz_get_tag_protocol,
 	.get_phy_flags		= ksz8_sw_get_phy_flags,
 	.setup			= ksz8_setup,
 	.phy_read		= ksz_phy_read16,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 7d3c8f6908b6..4fb96e53487e 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -276,21 +276,8 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	mutex_unlock(&mib->cnt_mutex);
 }
 
-static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
-						      int port,
-						      enum dsa_tag_protocol mp)
+static void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 {
-	enum dsa_tag_protocol proto = DSA_TAG_PROTO_KSZ9477;
-	struct ksz_device *dev = ds->priv;
-
-	if (dev->features & IS_9893)
-		proto = DSA_TAG_PROTO_KSZ9893;
-	return proto;
-}
-
-static int ksz9477_phy_read16(struct dsa_switch *ds, int addr, int reg)
-{
-	struct ksz_device *dev = ds->priv;
 	u16 val = 0xffff;
 
 	/* No real PHY after this. Simulate the PHY.
@@ -335,24 +322,20 @@ static int ksz9477_phy_read16(struct dsa_switch *ds, int addr, int reg)
 		ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
 	}
 
-	return val;
+	*data = val;
 }
 
-static int ksz9477_phy_write16(struct dsa_switch *ds, int addr, int reg,
-			       u16 val)
+static void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 {
-	struct ksz_device *dev = ds->priv;
-
 	/* No real PHY after this. */
 	if (addr >= dev->phy_port_cnt)
-		return 0;
+		return;
 
 	/* No gigabit support.  Do not write to this register. */
 	if (!(dev->features & GBIT_SUPPORT) && reg == MII_CTRL1000)
-		return 0;
-	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
+		return;
 
-	return 0;
+	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
 }
 
 static void ksz9477_cfg_port_member(struct ksz_device *dev, int port,
@@ -1326,10 +1309,10 @@ static int ksz9477_setup(struct dsa_switch *ds)
 }
 
 static const struct dsa_switch_ops ksz9477_switch_ops = {
-	.get_tag_protocol	= ksz9477_get_tag_protocol,
+	.get_tag_protocol	= ksz_get_tag_protocol,
 	.setup			= ksz9477_setup,
-	.phy_read		= ksz9477_phy_read16,
-	.phy_write		= ksz9477_phy_write16,
+	.phy_read		= ksz_phy_read16,
+	.phy_write		= ksz_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.phylink_get_caps	= ksz9477_get_caps,
 	.port_enable		= ksz_enable_port,
@@ -1417,6 +1400,8 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
 	.port_setup = ksz9477_port_setup,
+	.r_phy = ksz9477_r_phy,
+	.w_phy = ksz9477_w_phy,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
 	.r_mib_pkt = ksz9477_r_mib_pkt,
 	.r_mib_stat64 = ksz_r_mib_stats64,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9057cdb5971c..a43b01c2e67f 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -930,6 +930,30 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_port_stp_state_set);
 
+enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
+					   int port, enum dsa_tag_protocol mp)
+{
+	struct ksz_device *dev = ds->priv;
+	enum dsa_tag_protocol proto;
+
+	if (dev->chip_id == KSZ8795_CHIP_ID ||
+	    dev->chip_id == KSZ8794_CHIP_ID ||
+	    dev->chip_id == KSZ8765_CHIP_ID)
+		proto = DSA_TAG_PROTO_KSZ8795;
+
+	if (dev->chip_id == KSZ8830_CHIP_ID ||
+	    dev->chip_id == KSZ9893_CHIP_ID)
+		proto = DSA_TAG_PROTO_KSZ9893;
+
+	if (dev->chip_id == KSZ9477_CHIP_ID ||
+	    dev->chip_id == KSZ9897_CHIP_ID ||
+	    dev->chip_id == KSZ9567_CHIP_ID)
+		proto = DSA_TAG_PROTO_KSZ9477;
+
+	return proto;
+}
+EXPORT_SYMBOL_GPL(ksz_get_tag_protocol);
+
 static int ksz_switch_detect(struct ksz_device *dev)
 {
 	u8 id1, id2;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d16c095cdefb..f253f3f22386 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -231,6 +231,8 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
 void ksz_get_strings(struct dsa_switch *ds, int port,
 		     u32 stringset, uint8_t *buf);
+enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
+					   int port, enum dsa_tag_protocol mp);
 
 /* Common register access functions */
 
-- 
2.36.1

