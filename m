Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FFF54F349
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381150AbiFQIoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381153AbiFQIoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:44:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B75694B8;
        Fri, 17 Jun 2022 01:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655455449; x=1686991449;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hJitJMQq2DlsnhcJXbwfiNSwdg4yOnq8J5j58GL8qFo=;
  b=lhlOQtk3rBJqJ4P9KBUALeSn+p223OsgsyKVP2G9bG5RyaItNnkksPjs
   xlWgp3YxvaD2VsjMIIyVdAd1yMr9eohikB39wDzPc+EfGjXCOeDI3L74V
   7n08yBOqCrFUsbtPQou/Mf8U5VWhfhZ1xMOFTcOwtKdP/ADZm2ro7h+Sw
   fdbrm0M4vysy3CBCiWe8wRSyaboUZ+2SAoBUHqmWKOpBLaTLLwjTadDKR
   C8K86VqRFHjR2f0drj9/xRu2TxcQW5NNgRwagyuPbA7pPHCY16Ilu7ucG
   2XOaG56tUTDU3GNt45A9tlZ4u/85uOWu+n+X61t6lmsGtuWeBcMSwFMQW
   A==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="168803779"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2022 01:44:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Jun 2022 01:44:09 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Jun 2022 01:44:04 -0700
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
Subject: [Patch net-next 04/11] net: dsa: microchip: ksz9477: use ksz_read_phy16 & ksz_write_phy16
Date:   Fri, 17 Jun 2022 14:12:48 +0530
Message-ID: <20220617084255.19376-5-arun.ramadoss@microchip.com>
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

ksz8795 and ksz9477 implementation on phy read/write hooks are
different. This patch modifies the ksz9477 implementation same as
ksz8795 by updating the ksz9477_dev_ops structure.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index ab3fbb8e15a1..4fb96e53487e 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -276,9 +276,8 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	mutex_unlock(&mib->cnt_mutex);
 }
 
-static int ksz9477_phy_read16(struct dsa_switch *ds, int addr, int reg)
+static void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 {
-	struct ksz_device *dev = ds->priv;
 	u16 val = 0xffff;
 
 	/* No real PHY after this. Simulate the PHY.
@@ -323,24 +322,20 @@ static int ksz9477_phy_read16(struct dsa_switch *ds, int addr, int reg)
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
@@ -1316,8 +1311,8 @@ static int ksz9477_setup(struct dsa_switch *ds)
 static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.get_tag_protocol	= ksz_get_tag_protocol,
 	.setup			= ksz9477_setup,
-	.phy_read		= ksz9477_phy_read16,
-	.phy_write		= ksz9477_phy_write16,
+	.phy_read		= ksz_phy_read16,
+	.phy_write		= ksz_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.phylink_get_caps	= ksz9477_get_caps,
 	.port_enable		= ksz_enable_port,
@@ -1405,6 +1400,8 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
 	.port_setup = ksz9477_port_setup,
+	.r_phy = ksz9477_r_phy,
+	.w_phy = ksz9477_w_phy,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
 	.r_mib_pkt = ksz9477_r_mib_pkt,
 	.r_mib_stat64 = ksz_r_mib_stats64,
-- 
2.36.1

