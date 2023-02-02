Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C3B687E2D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjBBNAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbjBBM7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:59:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ED68E49E;
        Thu,  2 Feb 2023 04:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675342758; x=1706878758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OJg0llhgyQd77eI4/rlRjP9TKpD1ddTPYFukai6jCVo=;
  b=xLZmsHz84cowWyVJQWW4+YybwYQpbdvMkzFa0kw5ALpVBLJ6+I7oDU+p
   REACz9KM8HrG4ltsJxge3ir95wXiJ67FJhjY9xmf1tqCa5iknmsjeTclq
   0bfLiWfxaGGQsQkyeZ5IB6ABFz5Dza9d5bndEJPGIy9zZrBhYEU6D3EQY
   ChK2WJeLazomN0J2oi0DOEMv2pwFCrd3CBRu0/qDwGwp7iSJDljBcQkwc
   TzK03W5kYWRcealhC5rc23OA6aa/+705qJfbVG7pFpePcDVpqyvULSGEF
   sJ09S3fX7jmWqVXqkEJ1knp8Y6p6UmSF4pJqRbHzlFLIjLtjvuoZ16kjN
   A==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="135252001"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 05:59:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 05:59:15 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 05:59:11 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 09/11] net: dsa: microchip: lan937x: update port membership with dsa port
Date:   Thu, 2 Feb 2023 18:29:28 +0530
Message-ID: <20230202125930.271740-10-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like cpu port, cascaded port will act as host port in second switch. And
all ports from both switches should be able to forward packets to cascaded
ports. Add cascaded port (dev->dsa_port) to each port membership.

Current design add bit map of user ports as cpu port membership. Include
cascaded port index as well to this group.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   |  7 ++++---
 drivers/net/dsa/microchip/lan937x_main.c |  2 +-
 include/net/dsa.h                        | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 913296c5dd50..b8b7b5b7b52d 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1748,9 +1748,9 @@ static void ksz_get_strings(struct dsa_switch *ds, int port,
 
 static void ksz_update_port_member(struct ksz_device *dev, int port)
 {
+	u8 port_member = 0, cpu_port, dsa_port;
 	struct ksz_port *p = &dev->ports[port];
 	struct dsa_switch *ds = dev->ds;
-	u8 port_member = 0, cpu_port;
 	const struct dsa_port *dp;
 	int i, j;
 
@@ -1759,6 +1759,7 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
 
 	dp = dsa_to_port(ds, port);
 	cpu_port = BIT(dsa_upstream_port(ds, port));
+	dsa_port = BIT(dev->dsa_port);
 
 	for (i = 0; i < ds->num_ports; i++) {
 		const struct dsa_port *other_dp = dsa_to_port(ds, i);
@@ -1798,10 +1799,10 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
 				val |= BIT(j);
 		}
 
-		dev->dev_ops->cfg_port_member(dev, i, val | cpu_port);
+		dev->dev_ops->cfg_port_member(dev, i, val | cpu_port | dsa_port);
 	}
 
-	dev->dev_ops->cfg_port_member(dev, port, port_member | cpu_port);
+	dev->dev_ops->cfg_port_member(dev, port, port_member | cpu_port | dsa_port);
 }
 
 static int ksz_sw_mdio_read(struct mii_bus *bus, int addr, int regnum)
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 5108a3f4bf76..b17bb1ea2a4a 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -198,7 +198,7 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 				 true);
 
 	if (cpu_port)
-		member = dsa_user_ports(ds);
+		member = dsa_user_ports(ds) | dsa_dsa_ports(ds);
 	else
 		member = BIT(dsa_upstream_port(ds, port));
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 55651ad29193..939aa6ff1a38 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -591,6 +591,10 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	dsa_switch_for_each_port((_dp), (_ds)) \
 		if (dsa_port_is_cpu((_dp)))
 
+#define dsa_switch_for_each_dsa_port(_dp, _ds) \
+	dsa_switch_for_each_port((_dp), (_ds)) \
+		if (dsa_port_is_dsa((_dp)))
+
 #define dsa_switch_for_each_cpu_port_continue_reverse(_dp, _ds) \
 	dsa_switch_for_each_port_continue_reverse((_dp), (_ds)) \
 		if (dsa_port_is_cpu((_dp)))
@@ -617,6 +621,17 @@ static inline u32 dsa_cpu_ports(struct dsa_switch *ds)
 	return mask;
 }
 
+static inline u32 dsa_dsa_ports(struct dsa_switch *ds)
+{
+	struct dsa_port *dsa_dp;
+	u32 mask = 0;
+
+	dsa_switch_for_each_dsa_port(dsa_dp, ds)
+		mask |= BIT(dsa_dp->index);
+
+	return mask;
+}
+
 /* Return the local port used to reach an arbitrary switch device */
 static inline unsigned int dsa_routing_port(struct dsa_switch *ds, int device)
 {
-- 
2.34.1

