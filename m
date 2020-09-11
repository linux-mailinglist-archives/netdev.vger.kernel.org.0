Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C962D265927
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 08:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgIKGKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 02:10:48 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:40058 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgIKGKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 02:10:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599804644; x=1631340644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Ew6L9puofX2BrE+gc4fVOAW56/4A+Bp1vYL6oL7OEyM=;
  b=gSzXJx9qB4smiBlSW5qzTJQGfBnCaXyAphJVXyVaYRQeVh2rFNnhU6dm
   OZklkb3TVTD9yTjMd3tCilOfQnnsfEqh7hRcuFs7qjbbSjuouPqYARuUk
   ynFUKL1cy3+3NhaZ3lxQyrGAx0AXoQi4P5gpnzER8n/ZGmGt9ne2BFop4
   Rv46NoGnriMjcOElIKhmGvWeKoLlaUzXE0MHuWdP8FMGuCEqQuQ1WfunQ
   Sh/ONvRdDn+OqEwf8dXywu+jF8qBC0vYSLgrvy67ve1MvcFN3Ow27KFop
   HTynY9pGG2IS2oyH4kS6jQykRbRp5GvryCbsI/24Hi05wCYd1lpgH5ycb
   A==;
IronPort-SDR: KqmD+Z4XGw/zmsz5iYseYqeCNCJJTmDwq0ozZNYTD2iDltnYoM/xYPDw0/9fhCvYI1VE54euYK
 OnGxiF1+fL9UITXO8K7eAEkOUTn6FhtRwd6pWpOvKKLj6fayJhcohjFrgI4Xi7/MfEOMQ52VHT
 VJABWw08/8QIvz3iGcix+rHJazM5M396XnxhhlwFPXZ4qmWjfXhKea31eHOiyXdAXs2yWR9wfu
 DmC2IxnSZmULqi2KxSk4DUxBCvJOr6NMUoLDaK/uQmzOsCLHEea+u+F7rSR0kCGspVpIGZYkof
 PV4=
X-IronPort-AV: E=Sophos;i="5.76,414,1592895600"; 
   d="scan'208";a="88679903"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Sep 2020 23:10:43 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Sep 2020 23:10:02 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 10 Sep 2020 23:10:40 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <marex@denx.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v2 net-next] net: phy: mchp: Add support for LAN8814 QUAD PHY
Date:   Fri, 11 Sep 2020 11:40:20 +0530
Message-ID: <20200911061020.22413-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200909093419.32102-1-Divya.Koppera@microchip.com>
References: <20200909093419.32102-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN8814 is a low-power, quad-port triple-speed (10BASE-T/100BASETX/1000BASE-T)
Ethernet physical layer transceiver (PHY). It supports transmission and
reception of data on standard CAT-5, as well as CAT-5e and CAT-6, unshielded
twisted pair (UTP) cables.

LAN8814 supports industry-standard QSGMII (Quad Serial Gigabit Media
Independent Interface) and Q-USGMII (Quad Universal Serial Gigabit Media
Independent Interface) providing chip-to-chip connection to four Gigabit
Ethernet MACs using a single serialized link (differential pair) in each
direction.

The LAN8814 SKU supports high-accuracy timestamping functions to
support IEEE-1588 solutions using Microchip Ethernet switches, as well as
customer solutions based on SoCs and FPGAs.

The LAN8804 SKU has same features as that of LAN8814 SKU except that it does
not support 1588, SyncE, or Q-USGMII with PCH/MCH.

This adds support for 10BASE-T, 100BASE-TX, and 1000BASE-T,
QSGMII link with the MAC.

Signed-off-by: Divya Koppera<divya.koppera@microchip.com>
---
v1 -> v2:
* Removing get_features and config_init as the Errata mentioned and other
  functionality related things are not applicable for this phy.
  Addressed review comments.
---
 drivers/net/phy/micrel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 9f60865587ea..a7f74b3b97af 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1320,8 +1320,6 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Microchip INDY Gigabit Quad PHY",
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
-	.get_features	= ksz9031_get_features,
-	.config_init	= ksz9031_config_init,
 	.soft_reset	= genphy_soft_reset,
 	.read_status	= ksz9031_read_status,
 	.get_sset_count	= kszphy_get_sset_count,
-- 
2.17.1

