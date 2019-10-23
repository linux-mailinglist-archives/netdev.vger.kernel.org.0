Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A598FE1EA1
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 16:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406390AbfJWOuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 10:50:55 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:40938 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406383AbfJWOuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 10:50:54 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9NEohvu029561;
        Wed, 23 Oct 2019 09:50:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571842243;
        bh=nudqLm1ZcCi8FwR+9N9Muu7GNCUdgMt31d0oOFH0XAk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=NuxMHtliGkMmvIbwrPuyGOspUgm1HlrKg8YVNPwQsPDEDuU1IrrqSn8jxO7f9fmP3
         CfTgdQAGqWeSp+97hq8BYYuVE9lhvMoYSolsq53mC9EnQ5hAuhHzDkHnxj83JRQs4D
         pqtXqrIcDByMovw2b0tWvIklNwbBkYYBC72nufVI=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9NEohgE129608
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Oct 2019 09:50:43 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 23
 Oct 2019 09:50:42 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 23 Oct 2019 09:50:32 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9NEofG6022938;
        Wed, 23 Oct 2019 09:50:42 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 2/2] net: phy: dp83867: move dt parsing to probe
Date:   Wed, 23 Oct 2019 17:48:46 +0300
Message-ID: <20191023144846.1381-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191023144846.1381-1-grygorii.strashko@ti.com>
References: <20191023144846.1381-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move DT parsing code to probe dp83867_probe() as it's one time operation.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/phy/dp83867.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index cf4455bbf888..5816a06a9439 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -299,7 +299,7 @@ static int dp83867_probe(struct phy_device *phydev)
 
 	phydev->priv = dp83867;
 
-	return 0;
+	return dp83867_of_init(phydev);
 }
 
 static int dp83867_config_init(struct phy_device *phydev)
@@ -308,10 +308,6 @@ static int dp83867_config_init(struct phy_device *phydev)
 	int ret, val, bs;
 	u16 delay;
 
-	ret = dp83867_of_init(phydev);
-	if (ret)
-		return ret;
-
 	/* RX_DV/RX_CTRL strapped in mode 1 or mode 2 workaround */
 	if (dp83867->rxctrl_strap_quirk)
 		phy_clear_bits_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4,
-- 
2.17.1

