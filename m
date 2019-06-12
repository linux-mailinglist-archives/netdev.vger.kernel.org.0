Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 410E64311C
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389476AbfFLUtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:49:21 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:17381 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388615AbfFLUtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:49:20 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x5CKnF0B004867
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jun 2019 14:49:16 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x5CKnCV4014125
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 12 Jun 2019 14:49:14 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 2/2] net: dsa: microchip: Support optional 125MHz SYNCLKO output
Date:   Wed, 12 Jun 2019 14:49:06 -0600
Message-Id: <1560372546-3153-3-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560372546-3153-1-git-send-email-hancock@sedsystems.ca>
References: <1560372546-3153-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ9477 series chips have a SYNCLKO pin which by default outputs a
25MHz clock, but some board setups require a 125MHz clock instead. Added
a microchip,synclko-125 device tree property to allow indicating a
125MHz clock output is required.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 Documentation/devicetree/bindings/net/dsa/ksz.txt | 2 ++
 drivers/net/dsa/microchip/ksz9477.c               | 4 ++++
 drivers/net/dsa/microchip/ksz_common.c            | 2 ++
 drivers/net/dsa/microchip/ksz_priv.h              | 1 +
 4 files changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/ksz.txt b/Documentation/devicetree/bindings/net/dsa/ksz.txt
index e7db726..4ac21ce 100644
--- a/Documentation/devicetree/bindings/net/dsa/ksz.txt
+++ b/Documentation/devicetree/bindings/net/dsa/ksz.txt
@@ -16,6 +16,8 @@ Required properties:
 Optional properties:
 
 - reset-gpios		: Should be a gpio specifier for a reset line
+- microchip,synclko-125 : Set if the output SYNCLKO frequency should be set to
+			  125MHz instead of 25MHz.
 
 See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
 required and optional properties.
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 7be6d84..508380f 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -258,6 +258,10 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 	data16 |= (BROADCAST_STORM_VALUE * BROADCAST_STORM_PROT_RATE) / 100;
 	ksz_write16(dev, REG_SW_MAC_CTRL_2, data16);
 
+	if (dev->synclko_125)
+		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
+			   SW_ENABLE_REFCLKO | SW_REFCLKO_IS_125MHZ);
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 39dace8..40c57d8 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -460,6 +460,8 @@ int ksz_switch_register(struct ksz_device *dev,
 		ret = of_get_phy_mode(dev->dev->of_node);
 		if (ret >= 0)
 			dev->interface = ret;
+		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
+							 "microchip,synclko-125");
 	}
 
 	ret = dsa_register_switch(dev->ds);
diff --git a/drivers/net/dsa/microchip/ksz_priv.h b/drivers/net/dsa/microchip/ksz_priv.h
index 724301d..c615d2a 100644
--- a/drivers/net/dsa/microchip/ksz_priv.h
+++ b/drivers/net/dsa/microchip/ksz_priv.h
@@ -78,6 +78,7 @@ struct ksz_device {
 	phy_interface_t interface;
 	u32 regs_size;
 	bool phy_errata_9477;
+	bool synclko_125;
 
 	struct vlan_table *vlan_cache;
 
-- 
1.8.3.1

