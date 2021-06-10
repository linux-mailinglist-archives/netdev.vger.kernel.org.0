Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F893A2190
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhFJApr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:45:47 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37170 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFJApq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 20:45:46 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 15A0hgB3125931;
        Wed, 9 Jun 2021 19:43:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623285822;
        bh=TWF0rV/swOt00TUr1BLIJqsEXjaJJeA+VDeQwUbOhZU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=VBbPz+KJLM69HXguapwpEpJsIa7jBGIqROgCxBzuyo3NeP3tKXmgBZHsM0sre+fOX
         H85T+fL49GrUBEw7nEaRty8FsXXaT/zEtK0SMKjEEeGyOY+W8u48px6NVOOqtqXJMq
         JC8EIYx4J5khYPkA2pcMxnEiNIcih0HANj+Cu8pQ=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 15A0hgxX079270
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 9 Jun 2021 19:43:42 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 9 Jun
 2021 19:43:42 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 9 Jun 2021 19:43:42 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 15A0hgpY005753;
        Wed, 9 Jun 2021 19:43:42 -0500
From:   <praneeth@ti.com>
To:     Praneeth Bajjuri <praneeth@ti.com>, Andrew Lunn <andrew@lunn.ch>,
        Geet Modi <geet.modi@ti.com>, <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] net: phy: dp83867: perform soft reset and retain established link
Date:   Wed, 9 Jun 2021 19:43:42 -0500
Message-ID: <20210610004342.4493-1-praneeth@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com>
References: <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com>
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

do SW_RESTART to perform a reset not including the registers,
If performed when link is already present,
it will drop the link and trigger re-auto negotiation.

Signed-off-by: Praneeth Bajjuri <praneeth@ti.com>
Signed-off-by: Geet Modi <geet.modi@ti.com>
---
 drivers/net/phy/dp83867.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 9bd9a5c0b1db..6bbc81ad295f 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -826,16 +826,12 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 {
 	int err;
 
-	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESET);
+	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
 	if (err < 0)
 		return err;
 
 	usleep_range(10, 20);
 
-	/* After reset FORCE_LINK_GOOD bit is set. Although the
-	 * default value should be unset. Disable FORCE_LINK_GOOD
-	 * for the phy to work properly.
-	 */
 	return phy_modify(phydev, MII_DP83867_PHYCTRL,
 			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
 }
-- 
2.17.1

