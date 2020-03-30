Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1549319805E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgC3QCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:02:11 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:64643 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728738AbgC3QCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:02:11 -0400
IronPort-SDR: GttmZn8y512m6vL+lQWEvqWi+0Sg9Q7x7GBoOD4qxRx9pC9P7UDcGGRE8zXsadi8DW3CPCFLot
 BzwDwOETzSIhP4w9RaOE9gtlHeiE1TeTOqwwLhHqTqh7gEfyC6D/fStsxLmfDPqOanFVtYbVRe
 7On/Hzm0+U5wUycuObKh2SR6XTfw+iLceIlKrhhD9FVgcJLn+M8/Rkoup9/rM6eD0JaHH3WIL3
 M4oAPNuKoM5egs6wyikvKLi2WuCSqDeFKE0NA1f7vRly0uPndNUaWQWEpqOEfvz6cfhI1QySjV
 zpM=
X-IronPort-AV: E=Sophos;i="5.72,324,1580799600"; 
   d="scan'208";a="70742983"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Mar 2020 09:02:10 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Mar 2020 09:02:09 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 30 Mar 2020 09:01:54 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Subject: [PATCH] net: mdio: of: Do not treat fixed-link as PHY
Date:   Mon, 30 Mar 2020 19:01:36 +0300
Message-ID: <20200330160136.23018-1-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some ethernet controllers, such as cadence's macb, have an embedded MDIO.
For this reason, the ethernet PHY nodes are not under an MDIO bus, but
directly under the ethernet node. Since these drivers might use
of_mdiobus_child_is_phy(), we should fix this function by returning false
if a fixed-link is found.

Fixes: 801a8ef54e8b ("of: phy: Only register a phy device for phys")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---
 drivers/of/of_mdio.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 9f982c0627a0..7cf8aad645a4 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -195,12 +195,17 @@ static const struct of_device_id whitelist_phys[] = {
  * o Compatible string of "ethernet-phy-ieee802.3-c22"
  * o In the white list above (and issue a warning)
  * o No compatibility string
+ * o Not a fixed-link
  *
  * A device which is not a phy is expected to have a compatible string
  * indicating what sort of device it is.
  */
 bool of_mdiobus_child_is_phy(struct device_node *child)
 {
+	const struct of_device_id fixed_link[] = {
+		{ .name = "fixed-link" },
+		{}
+	};
 	u32 phy_id;
 
 	if (of_get_phy_id(child, &phy_id) != -EINVAL)
@@ -219,7 +224,8 @@ bool of_mdiobus_child_is_phy(struct device_node *child)
 		return true;
 	}
 
-	if (!of_find_property(child, "compatible", NULL))
+	if (!of_find_property(child, "compatible", NULL) &&
+	    !of_match_node(fixed_link, child))
 		return true;
 
 	return false;
-- 
2.20.1

