Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC3F1E325D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404350AbgEZWWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:22:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50618 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389655AbgEZWWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 18:22:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fdddWi4Fyen5ZZ8AglAEDrF5VvPFQPW4is4ZtyL2H8s=; b=Yp7g91RGdHZtGFkjxh8Q4I4kO5
        6O4QmINkGNQjHSitcYXUYEAv07fezRDVb5pIIY2Xgf97amTz6AWxwjCa7Vn/Eu5USse8Cw2TKeHST
        ksf/3op+u5TjIrfSZjZvXoKr74+fOA9bB8U3WVkKMnCLsW4HxNaRjTZn/v+AowWMy85I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdhxK-003KTO-88; Wed, 27 May 2020 00:21:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 6/7] net : phy: marvell: Speedup TDR data retrieval by only changing page once
Date:   Wed, 27 May 2020 00:21:42 +0200
Message-Id: <20200526222143.793613-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526222143.793613-1-andrew@lunn.ch>
References: <20200526222143.793613-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Getting the TDR data requires a large number of MDIO bus
transactions. The number can however be reduced if the page is only
changed once. Add the needed locking to allow this, and make use of
unlocked read/write methods where needed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 335e51d6f138..e9deedea5f19 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1751,15 +1751,12 @@ static int marvell_vct5_wait_complete(struct phy_device *phydev)
 	int val;
 
 	for (i = 0; i < 32; i++) {
-		val = phy_read_paged(phydev, MII_MARVELL_VCT5_PAGE,
-				     MII_VCT5_CTRL);
+		val = __phy_read(phydev, MII_VCT5_CTRL);
 		if (val < 0)
 			return val;
 
 		if (val & MII_VCT5_CTRL_COMPLETE)
 			return 0;
-
-		usleep_range(1000, 2000);
 	}
 
 	phydev_err(phydev, "Timeout while waiting for cable test to finish\n");
@@ -1773,7 +1770,7 @@ static int marvell_vct5_amplitude(struct phy_device *phydev, int pair)
 	int reg;
 
 	reg = MII_VCT5_TX_RX_MDI0_COUPLING + pair;
-	val = phy_read_paged(phydev, MII_MARVELL_VCT5_PAGE, reg);
+	val = __phy_read(phydev, reg);
 
 	if (val < 0)
 		return 0;
@@ -1805,9 +1802,8 @@ static int marvell_vct5_amplitude_distance(struct phy_device *phydev,
 	int mV;
 	int i;
 
-	err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
-			      MII_VCT5_SAMPLE_POINT_DISTANCE,
-			      distance);
+	err = __phy_write(phydev, MII_VCT5_SAMPLE_POINT_DISTANCE,
+			  distance);
 	if (err)
 		return err;
 
@@ -1816,8 +1812,7 @@ static int marvell_vct5_amplitude_distance(struct phy_device *phydev,
 		MII_VCT5_CTRL_SAMPLES_DEFAULT |
 		MII_VCT5_CTRL_SAMPLE_POINT |
 		MII_VCT5_CTRL_PEEK_HYST_DEFAULT;
-	err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
-			      MII_VCT5_CTRL, reg);
+	err = __phy_write(phydev, MII_VCT5_CTRL, reg);
 	if (err)
 		return err;
 
@@ -1840,6 +1835,7 @@ static int marvell_vct5_amplitude_graph(struct phy_device *phydev)
 {
 	struct marvell_priv *priv = phydev->priv;
 	int distance;
+	int page;
 	int err;
 	u16 reg;
 
@@ -1853,16 +1849,27 @@ static int marvell_vct5_amplitude_graph(struct phy_device *phydev)
 	if (err)
 		return err;
 
+	/* Reading the TDR data is very MDIO heavy. We need to optimize
+	 * access to keep the time to a minimum. So lock the bus once,
+	 * and don't release it until complete. We can then avoid having
+	 * to change the page for every access, greatly speeding things
+	 * up.
+	 */
+	page = phy_select_page(phydev, MII_MARVELL_VCT5_PAGE);
+	if (page < 0)
+		return page;
+
 	for (distance = priv->first;
 	     distance <= priv->last;
 	     distance += priv->step) {
 		err = marvell_vct5_amplitude_distance(phydev, distance,
 						      priv->pair);
 		if (err)
-			return err;
+			goto restore_page;
 	}
 
-	return 0;
+restore_page:
+	return phy_restore_page(phydev, page, err);
 }
 
 static int marvell_cable_test_start_common(struct phy_device *phydev)
-- 
2.27.0.rc0

