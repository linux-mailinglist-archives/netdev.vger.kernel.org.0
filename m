Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8EDE25B460
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgIBT1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:27:14 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:55142 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgIBT1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 15:27:13 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 082JR6Ff126257;
        Wed, 2 Sep 2020 14:27:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599074826;
        bh=+v1Nd8+n/OOggdgxRjBCSgV9osCcfdst9MC44sB2akY=;
        h=From:To:CC:Subject:Date;
        b=MPSylcV6CufnB7j6DskaCDpB4OJNwwqJsp6JsiBY0beiaijftf4L6SeGWnLpW8nML
         K1IaFoBpnGJL84NneTOlHkfzBaH7lylOOIwdNjAV/4MITltzcmgRzaNglYdwl5Y0YR
         9MhyRPsE/n69IsOAybI6NB79PWZtTNfPw9TruhUA=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 082JR6p4047335
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 2 Sep 2020 14:27:06 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 2 Sep
 2020 14:27:05 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 2 Sep 2020 14:27:05 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 082JR53Z071593;
        Wed, 2 Sep 2020 14:27:05 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net] net: dp83867: Fix WoL SecureOn password
Date:   Wed, 2 Sep 2020 14:27:04 -0500
Message-ID: <20200902192704.9220-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the registers being written to as the values were being over written
when writing the same registers.

Fixes: caabee5b53f5 ("net: phy: dp83867: support Wake on LAN")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83867.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index f3c04981b8da..cd7032628a28 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -215,9 +215,9 @@ static int dp83867_set_wol(struct phy_device *phydev,
 		if (wol->wolopts & WAKE_MAGICSECURE) {
 			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
 				      (wol->sopass[1] << 8) | wol->sopass[0]);
-			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
+			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP2,
 				      (wol->sopass[3] << 8) | wol->sopass[2]);
-			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
+			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP3,
 				      (wol->sopass[5] << 8) | wol->sopass[4]);
 
 			val_rxcfg |= DP83867_WOL_SEC_EN;
-- 
2.28.0

