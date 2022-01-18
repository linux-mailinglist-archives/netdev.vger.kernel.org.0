Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E2D492448
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238865AbiARLHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:07:15 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39870 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238725AbiARLHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:07:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1642504031; x=1674040031;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OamxD9n2qOQlj3+w09xLq/5caocoDB1vCBarNOrYvtY=;
  b=NbYkSAK+6MwVPk2+WDAnIod2iEBo07UkCfY+HDHu/+sq1dR911PVbYy1
   AVdmtU7aq7a78rdjy3N5+t4g2plPCWgmJ4tc6dg79YZ2zaddj7/qIhdP4
   NszR9P+ExGGfIcieZBGGPzxC0PGlY4gZkhxnnD0Vqu21yO5QgofRfWvgV
   +wZg+rBjX/nxVMOPAzWroGCbDIvAb/jnEsgNurkU37nItozAfJmCbDaBj
   BKO3hBczauSr6Qip9W8qp2+upCjy1qbrXuKCjfo3dvR2HIXc/PQCHxwvf
   OEoBZkENE8Rb8TZuqIEedXXcSzDt4Cm+5LUb5T/w0oRVZMhkn45lPgdel
   g==;
IronPort-SDR: w4+WUTP6+Yh5so1gyotfVB5eR+RobV9+TzLBvuYJC69MyiJnDQOJ3fr3MaIwW5jDZyCbXbm1e4
 7P2IWYGoXqJmxuK9hR3kGCEaxJqvXKkUlJBbZGV8SCZCoMaPJYw9WA1FlgUX4TtQJO4CgSsH0M
 7C6zfQW9VJdUTBcO8r+MdWhtaLZA4XWR+lgZfv2SSTSOqpT371AvmYg99mJtSMKZ1yx9oVH6wO
 EB/VMpi3n+RZfDBtlroYPtTwBx3taeUFTWL7vFs9wOuMugBdGMb7i7fhUYXvkjczJVb73LbMxZ
 ZcoUiXIz9Go8eTklQp8YnHsr
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="150001499"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2022 04:07:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 18 Jan 2022 04:07:08 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 18 Jan 2022 04:07:06 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ioana.ciornei@nxp.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH] net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices
Date:   Tue, 18 Jan 2022 13:08:12 +0200
Message-ID: <20220118110812.1767997-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On a setup with KSZ9131 and MACB drivers it happens on suspend path, from
time to time, that the PHY interrupt arrives after PHY and MACB were
suspended (PHY via genphy_suspend(), MACB via macb_suspend()). In this
case the phy_read() at the beginning of kszphy_handle_interrupt() will
fail (as MACB driver is suspended at this time) leading to phy_error()
being called and a stack trace being displayed on console. To solve this
.suspend/.resume functions for all KSZ devices implementing
.handle_interrupt were replaced with kszphy_suspend()/kszphy_resume()
which disable/enable interrupt before/after calling
genphy_suspend()/genphy_resume().

The fix has been adapted for all KSZ devices which implements
.handle_interrupt but it has been tested only on KSZ9131.

Fixes: 59ca4e58b917 ("net: phy: micrel: implement generic .handle_interrupt() callback")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/phy/micrel.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index aec0fcefdccd..e2ac61f44c94 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1547,8 +1547,8 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= kszphy_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8021,
 	.phy_id_mask	= 0x00ffffff,
@@ -1562,8 +1562,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8031,
 	.phy_id_mask	= 0x00ffffff,
@@ -1577,8 +1577,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8041,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
@@ -1609,8 +1609,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.name		= "Micrel KSZ8051",
 	/* PHY_BASIC_FEATURES */
@@ -1623,8 +1623,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
 	.match_phy_device = ksz8051_match_phy_device,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8001,
 	.name		= "Micrel KSZ8001 or KS8721",
@@ -1638,8 +1638,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8081,
 	.name		= "Micrel KSZ8081 or KSZ8091",
@@ -1669,8 +1669,8 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= ksz8061_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9021,
 	.phy_id_mask	= 0x000ffffe,
@@ -1685,8 +1685,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 	.read_mmd	= genphy_read_mmd_unsupported,
 	.write_mmd	= genphy_write_mmd_unsupported,
 }, {
@@ -1704,7 +1704,7 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
+	.suspend	= kszphy_suspend,
 	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_LAN8814,
@@ -1732,7 +1732,7 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
+	.suspend	= kszphy_suspend,
 	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8873MLL,
-- 
2.32.0

