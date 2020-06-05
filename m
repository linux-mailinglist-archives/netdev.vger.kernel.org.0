Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB071EF9D6
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 16:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgFEOBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 10:01:50 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:54342 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbgFEOBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 10:01:38 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 055E1F0R087473;
        Fri, 5 Jun 2020 09:01:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591365675;
        bh=Uw7BIq/8aR9Eby9v1Y+LhVEoYd4l2NcHHo9Wdi4yC9w=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=UvyPXv7dH0v1H0oaAYmVABSKzPaZv+S2b4xGup5btzf/u9Sgvrn3kcu1lMNkLDxPh
         /RvaAkGtCY7tTZGHaqaMTCAJmUuWbdt3K/LRAOn4qzqN/teMCTi+Zt0H21sj36X6P6
         27kxBMkkRcBrZmQxeH9pEiDYAmkAmLf9bougRIYY=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 055E1FRI120261;
        Fri, 5 Jun 2020 09:01:15 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 5 Jun
 2020 09:01:14 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 5 Jun 2020 09:01:14 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 055E1En0030217;
        Fri, 5 Jun 2020 09:01:14 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michael@walle.cc>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net 4/4] net: mscc: Fix OF_MDIO config check
Date:   Fri, 5 Jun 2020 09:01:07 -0500
Message-ID: <20200605140107.31275-5-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200605140107.31275-1-dmurphy@ti.com>
References: <20200605140107.31275-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_OF_MDIO is set to be a module the code block is not
compiled. Use the IS_ENABLED macro that checks for both built in as
well as module.

Fixes: 4f58e6dceb0e4 ("net: phy: Cleanup the Edge-Rate feature in Microsemi PHYs.")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/mscc/mscc.h      | 2 +-
 drivers/net/phy/mscc/mscc_main.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index f828c917b9f7..fbcee5fce7b2 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -374,7 +374,7 @@ struct vsc8531_private {
 #endif
 };
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 struct vsc8531_edge_rate_table {
 	u32 vddmac;
 	u32 slowdown[8];
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 7ed0285206d0..b9d60bc8b6b2 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -98,7 +98,7 @@ static const struct vsc85xx_hw_stat vsc8584_hw_stats[] = {
 	},
 };
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 static const struct vsc8531_edge_rate_table edge_table[] = {
 	{MSCC_VDDMAC_3300, { 0, 2,  4,  7, 10, 17, 29, 53} },
 	{MSCC_VDDMAC_2500, { 0, 3,  6, 10, 14, 23, 37, 63} },
@@ -382,7 +382,7 @@ static void vsc85xx_wol_get(struct phy_device *phydev,
 	mutex_unlock(&phydev->lock);
 }
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
 {
 	u32 vdd, sd;
-- 
2.26.2

