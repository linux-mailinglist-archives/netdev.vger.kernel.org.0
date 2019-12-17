Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD49F122D18
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfLQNjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:39:55 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56804 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:39:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZikhvA+8Bg2POLpJnZdM8LNnSsiJOc5Od/Iiq7yaR6w=; b=ux90BeMkrMv++Evy18ujMDm5PZ
        GXM/sBrnptL/aJZP5TZKfsNE2ub5TbQyGoMc2GTfkIThkmCBDbxkpOvnl5I3PdlkmEoZ/UYU5QOqt
        NnW47176NdtKHhypi59bmlDX44tK/7owRh7AsF4MVnv7G/MNjEEM6q+37u24tYtdl69d2BGBL1fNl
        1E9cXnqF207HEoNd8260vmzi2mS3K5bvt3gLFIBDezvI/HfeKSl4hCp1Nrp54jlwZPUmIFcSYrecf
        eg2QVezSKrYNt54Z4ARGpHG78HQ8vNoACSQSbY8+B7pDAlVLRVuGkELoZ/kQTMomKGU8AbyRv21zV
        xaIecYUQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:35592 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4d-0006Fc-9W; Tue, 17 Dec 2019 13:39:39 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4a-0001zB-Rw; Tue, 17 Dec 2019 13:39:36 +0000
In-Reply-To: <20191217133827.GQ25745@shell.armlinux.org.uk>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 08/11] net: phy: marvell: consolidate phy status
 reading
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihD4a-0001zB-Rw@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:39:36 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

marvell_read_status_page_an() always reads the PHY status register, but
marvell_update_link() has already done this.  Rather than wastefully
reading the register twice in quick succession, read it once in
marvell_read_status_page() and use the result for both.

This makes marvell_update_link() rather pointless, so move it into
marvell_read_status_page().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 60 +++++++++++----------------------------
 1 file changed, 17 insertions(+), 43 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4eabb6a26c33..b25eee9314a7 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1183,47 +1183,12 @@ static void fiber_lpa_mod_linkmode_lpa_t(unsigned long *advertising, u32 lpa)
 			 advertising, lpa & LPA_FIBER_1000FULL);
 }
 
-/**
- * marvell_update_link - update link status in real time in @phydev
- * @phydev: target phy_device struct
- *
- * Description: Update the value in phydev->link to reflect the
- *   current link value.
- */
-static int marvell_update_link(struct phy_device *phydev, int fiber)
-{
-	int status;
-
-	/* Use the generic register for copper link, or specific
-	 * register for fiber case
-	 */
-	if (fiber) {
-		status = phy_read(phydev, MII_M1011_PHY_STATUS);
-		if (status < 0)
-			return status;
-
-		if (status & MII_M1011_PHY_STATUS_LINK)
-			phydev->link = 1;
-		else
-			phydev->link = 0;
-	} else {
-		return genphy_update_link(phydev);
-	}
-
-	return 0;
-}
-
 static int marvell_read_status_page_an(struct phy_device *phydev,
-				       int fiber)
+				       int fiber, int status)
 {
-	int status;
 	int lpa;
 	int err;
 
-	status = phy_read(phydev, MII_M1011_PHY_STATUS);
-	if (status < 0)
-		return status;
-
 	if (!fiber) {
 		err = genphy_read_lpa(phydev);
 		if (err < 0)
@@ -1284,27 +1249,36 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
  */
 static int marvell_read_status_page(struct phy_device *phydev, int page)
 {
+	int status;
 	int fiber;
 	int err;
 
-	/* Detect and update the link, but return if there
-	 * was an error
+	status = phy_read(phydev, MII_M1011_PHY_STATUS);
+	if (status < 0)
+		return status;
+
+	/* Use the generic register for copper link status,
+	 * and the PHY status register for fiber link status.
 	 */
+	if (page == MII_MARVELL_FIBER_PAGE) {
+		phydev->link = !!(status & MII_M1011_PHY_STATUS_LINK);
+	} else {
+		err = genphy_update_link(phydev);
+		if (err)
+			return err;
+	}
+
 	if (page == MII_MARVELL_FIBER_PAGE)
 		fiber = 1;
 	else
 		fiber = 0;
 
-	err = marvell_update_link(phydev, fiber);
-	if (err)
-		return err;
-
 	linkmode_zero(phydev->lp_advertising);
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
 
 	if (phydev->autoneg == AUTONEG_ENABLE)
-		err = marvell_read_status_page_an(phydev, fiber);
+		err = marvell_read_status_page_an(phydev, fiber, status);
 	else
 		err = genphy_read_status_fixed(phydev);
 
-- 
2.20.1

