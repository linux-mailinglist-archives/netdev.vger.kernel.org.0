Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14981276C3E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 10:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgIXInE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 04:43:04 -0400
Received: from mail.intenta.de ([178.249.25.132]:37150 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgIXInC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 04:43:02 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2020 04:43:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=BXTF18riOp+4eJobrYt1HthX37h7jdYvM9cOfc+Lyds=;
        b=YrhZ1z3dxs5xJfgHRQ4e2i+IEk0e/IPsG3FaTC42q8lQzRI+pk8w8qwDUgxTc7XGMlugGTdf5uUQpx4jgPwxKuBKQIv3++1ZPUPinigheobtxDj9vHm0J18VcXQCnDxoBL0eh93T2QBozV22ENmoNXarKnvrkSAZOXSZtECC2Zia78EoGw2mIyDh+8t6oR5gjTIxRP42TI1U3geUBuJ0CHY/a8HQEBcOqclvHZyJm93fVGF84H7MZ4+FdWIEpKz3meAdpvko/zznaeIB2S3/tORMzpTbiilbYr3He1G8HJltg0TDo3MM1mnQ9c4JLjZzo7EosiQR80xPb2KN7+k9Cg==;
Date:   Thu, 24 Sep 2020 10:37:47 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     David Miller <davem@davemloft.net>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] net: dsa: microchip: really look for phy-mode in port nodes
Message-ID: <20200924083746.GA9410@laureti-dev>
References: <20200910.123257.1333858679864684014.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200910.123257.1333858679864684014.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous implementation failed to account for the "ports" node. The
actual port nodes are not child nodes of the switch node, but a "ports"
node sits in between.

Fixes: edecfa98f602 ("net: dsa: microchip: look for phy-mode in port nodes")
Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

I am very sorry that I need to send a fixup. It turned out that my
testing methodology was flawed. When I reintegrated Linus' master
branch, I noticed that it didn't work. It turned out that our hardware
now correctly implements hardware reset. As a consequence, the correct
setting of the phy-mode now became essential to operating the device.

I'm also looking forward to see "net: dsa: microchip: Improve phy mode
message" (from net-next) being merged. That would have helped me spot
this earlier.

Helmut

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8e755b50c9c1..c796d42730ba 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -387,8 +387,8 @@ EXPORT_SYMBOL(ksz_switch_alloc);
 int ksz_switch_register(struct ksz_device *dev,
 			const struct ksz_dev_ops *ops)
 {
+	struct device_node *port, *ports;
 	phy_interface_t interface;
-	struct device_node *port;
 	unsigned int port_num;
 	int ret;
 
@@ -429,13 +429,17 @@ int ksz_switch_register(struct ksz_device *dev,
 		ret = of_get_phy_mode(dev->dev->of_node, &interface);
 		if (ret == 0)
 			dev->compat_interface = interface;
-		for_each_available_child_of_node(dev->dev->of_node, port) {
-			if (of_property_read_u32(port, "reg", &port_num))
-				continue;
-			if (port_num >= dev->port_cnt)
-				return -EINVAL;
-			of_get_phy_mode(port, &dev->ports[port_num].interface);
-		}
+		ports = of_get_child_by_name(dev->dev->of_node, "ports");
+		if (ports)
+			for_each_available_child_of_node(ports, port) {
+				if (of_property_read_u32(port, "reg",
+							 &port_num))
+					continue;
+				if (port_num >= dev->port_cnt)
+					return -EINVAL;
+				of_get_phy_mode(port,
+						&dev->ports[port_num].interface);
+			}
 		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
 							 "microchip,synclko-125");
 	}
-- 
2.20.1

