Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F1E438BB3
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 21:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhJXTuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 15:50:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55960 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232124AbhJXTup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 15:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3Md8mslOkwV/+QOeqkRJJPLvrTv3nlUBSv++1en98rA=; b=g2wc4XSPsShqksw9k6/X5Bpay9
        VgIGrY8+QdaAjuU++gGDyyv1dGiTKg+3T/RYO0gUFcOKTq9jtAu1X+B+uhG2A0bJhWB1Qmuwlwog7
        hcoB3M0ERU7m2vf4G5kHqoQfmHF2LOfYiMCgLIdKPrdaXH/dHxVK+mOhpKXVDBqgau9I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mejTf-00BacZ-6U; Sun, 24 Oct 2021 21:48:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Walter.Stoll@duagon.com,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 1/4] phy: phy_ethtool_ksettings_get: Lock the phy for consistency
Date:   Sun, 24 Oct 2021 21:48:02 +0200
Message-Id: <20211024194805.2762333-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211024194805.2762333-1-andrew@lunn.ch>
References: <20211024194805.2762333-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY structure should be locked while copying information out if
it, otherwise there is no guarantee of self consistency. Without the
lock the PHY state machine could be updating the structure.

Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index f124a8a58bd4..8457b829667e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -299,6 +299,7 @@ EXPORT_SYMBOL(phy_ethtool_ksettings_set);
 void phy_ethtool_ksettings_get(struct phy_device *phydev,
 			       struct ethtool_link_ksettings *cmd)
 {
+	mutex_lock(&phydev->lock);
 	linkmode_copy(cmd->link_modes.supported, phydev->supported);
 	linkmode_copy(cmd->link_modes.advertising, phydev->advertising);
 	linkmode_copy(cmd->link_modes.lp_advertising, phydev->lp_advertising);
@@ -317,6 +318,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 	cmd->base.autoneg = phydev->autoneg;
 	cmd->base.eth_tp_mdix_ctrl = phydev->mdix_ctrl;
 	cmd->base.eth_tp_mdix = phydev->mdix;
+	mutex_unlock(&phydev->lock);
 }
 EXPORT_SYMBOL(phy_ethtool_ksettings_get);
 
-- 
2.33.0

