Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DEF438BB4
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 21:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhJXTus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 15:50:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55966 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232127AbhJXTup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 15:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=izLbXYMs7eGq7gzIPCDBJSK0Yv1ipRj332tb4a8ijGo=; b=OwhDuFtLaUsITVTOuJr4jkDQkw
        Ix0MDqHQEAZoAGTTQm9P8Ibu+Vet/AS+1qu8IYxcBNOyioOyb2zwiZR1Lhhs1Pfu+OE1A4/oTV8Yv
        qYM//g5qkP4IRzNQVa4lINUdeT2L/xVK9jhDQYMzB+5KQUdYdbo9DktrKxDkovKPb/no=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mejTf-00Bacf-9T; Sun, 24 Oct 2021 21:48:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Walter.Stoll@duagon.com,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 3/4] phy: phy_start_aneg: Add an unlocked version
Date:   Sun, 24 Oct 2021 21:48:04 +0200
Message-Id: <20211024194805.2762333-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211024194805.2762333-1-andrew@lunn.ch>
References: <20211024194805.2762333-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split phy_start_aneg into a wrapper which takes the PHY lock, and a
helper doing the real work. This will be needed when
phy_ethtook_ksettings_set takes the lock.

Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ee584fa8b76d..d845afab1af7 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -700,7 +700,7 @@ static int phy_check_link_status(struct phy_device *phydev)
 }
 
 /**
- * phy_start_aneg - start auto-negotiation for this PHY device
+ * _phy_start_aneg - start auto-negotiation for this PHY device
  * @phydev: the phy_device struct
  *
  * Description: Sanitizes the settings (if we're not autonegotiating
@@ -708,25 +708,43 @@ static int phy_check_link_status(struct phy_device *phydev)
  *   If the PHYCONTROL Layer is operating, we change the state to
  *   reflect the beginning of Auto-negotiation or forcing.
  */
-int phy_start_aneg(struct phy_device *phydev)
+static int _phy_start_aneg(struct phy_device *phydev)
 {
 	int err;
 
+	lockdep_assert_held(&phydev->lock);
+
 	if (!phydev->drv)
 		return -EIO;
 
-	mutex_lock(&phydev->lock);
-
 	if (AUTONEG_DISABLE == phydev->autoneg)
 		phy_sanitize_settings(phydev);
 
 	err = phy_config_aneg(phydev);
 	if (err < 0)
-		goto out_unlock;
+		return err;
 
 	if (phy_is_started(phydev))
 		err = phy_check_link_status(phydev);
-out_unlock:
+
+	return err;
+}
+
+/**
+ * phy_start_aneg - start auto-negotiation for this PHY device
+ * @phydev: the phy_device struct
+ *
+ * Description: Sanitizes the settings (if we're not autonegotiating
+ *   them), and then calls the driver's config_aneg function.
+ *   If the PHYCONTROL Layer is operating, we change the state to
+ *   reflect the beginning of Auto-negotiation or forcing.
+ */
+int phy_start_aneg(struct phy_device *phydev)
+{
+	int err;
+
+	mutex_lock(&phydev->lock);
+	err = _phy_start_aneg(phydev);
 	mutex_unlock(&phydev->lock);
 
 	return err;
-- 
2.33.0

