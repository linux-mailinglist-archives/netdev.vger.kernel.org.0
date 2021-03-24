Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2489D346E69
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbhCXBAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:00:39 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:52450 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhCXBAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:00:10 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 12O106E7054994;
        Tue, 23 Mar 2021 20:00:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1616547606;
        bh=OjpD16SEHbWEPQmbV9P5NDctK6JffTrG6UyzgQM3Gg0=;
        h=From:To:CC:Subject:Date;
        b=qWws5k45Q5qBYrl84RzNTnaNVD41FlnX5oDofDGCGiHyEHp/5ZtPQ2Ya+qXry7Deg
         +GHukmep+5u7a1kWGS7IDuonnF1U7zhKyeCj5Tc3PmjK5fklgamKOx+lkbVYseZJtU
         +FoEI308udNkFWeAnfnELg1tW3sC2eq6wVS09DEU=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 12O106M4002688
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Mar 2021 20:00:06 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 23
 Mar 2021 20:00:06 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Tue, 23 Mar 2021 20:00:06 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 12O106Y6041688;
        Tue, 23 Mar 2021 20:00:06 -0500
From:   <praneeth@ti.com>
To:     Praneeth Bajjuri <praneeth@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Geet Modi <geet.modi@ti.com>
Subject: [PATCH] net: phy: dp83867: perform soft reset and retain established link
Date:   Tue, 23 Mar 2021 20:00:06 -0500
Message-ID: <20210324010006.32576-1-praneeth@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Praneeth Bajjuri <praneeth@ti.com>

Current logic is performing hard reset and causing the programmed
registers to be wiped out.

as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
8.6.26 Control Register (CTRL)
do SW_RESTART to perform a reset not including the registers and is
acceptable to do this if a link is already present.

Signed-off-by: Praneeth Bajjuri <praneeth@ti.com>
Signed-off-by: Geet Modi <geet.modi@ti.com>
---
 drivers/net/phy/dp83867.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 9bd9a5c0b1db..29ab49e894db 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -826,7 +826,7 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 {
 	int err;
 
-	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESET);
+	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
 	if (err < 0)
 		return err;
 
-- 
2.17.1

