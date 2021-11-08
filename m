Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE0D44813B
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240364AbhKHOWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:22:20 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57552 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240369AbhKHOV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 09:21:58 -0500
From:   bage@linutronix.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636381130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b8hzfb8Wmp1WPwNw4clkoEnCjxnpmgeTQi5Gr7DjGfM=;
        b=DPM3e1h6k/tdN5mUFgiEOHA2+w3jv6HCGtkjshW0yD/ZQ1yuQHBN/JUTyZ/4yKAzQlMr0W
        wxPbRtpebjaRi+7keqvgf9c79yW+Shp+4smCoj+7jABgHLctpmq7CPCb/aVDKaZmY39UYV
        fnbt95drM9ZmBHXaVOiSKSbZR/bRMClkXud9MkMPLgwO6jXIqHHGxhEIfK3eIecmAI4BoO
        BYz6QdTz7gZh3xXyvoliqJfPpnR+Awuiu08MI8V3locgq1zhJ2qU7GGs7UcUDkfZ5bqXC4
        yRSiuMOPtM/OAAwle7SwJBNUxzs+l+REymaOTsrUo4FMb94tbb1cbc5SaIWjBg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636381130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b8hzfb8Wmp1WPwNw4clkoEnCjxnpmgeTQi5Gr7DjGfM=;
        b=V+axK6sJHvn7oaDAr+mIPb5sKHbBkI265YrNQ0P7OaVPcbng+cqDO0S/g/EyxSMzzx6OTi
        +OVrsmhpd9S8OYBQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bastian Germann <bage@linutronix.de>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        netdev@vger.kernel.org, b.spranger@linutronix.de
Subject: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't discard phy_start_aneg's return
Date:   Mon,  8 Nov 2021 15:18:34 +0100
Message-Id: <20211108141834.19105-1-bage@linutronix.de>
In-Reply-To: <20211105153648.8337-1-bage@linutronix.de>
References: <20211105153648.8337-1-bage@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bastian Germann <bage@linutronix.de>

Take the return of phy_start_aneg into account so that ethtool will handle
negotiation errors and not silently accept invalid input.

Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Signed-off-by: Bastian Germann <bage@linutronix.de>
---
 drivers/net/phy/phy.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index beb2b66da132..59e024891f50 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -770,6 +770,8 @@ static int phy_poll_aneg_done(struct phy_device *phydev)
 int phy_ethtool_ksettings_set(struct phy_device *phydev,
 			      const struct ethtool_link_ksettings *cmd)
 {
+	int ret;
+
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
 	u8 autoneg = cmd->base.autoneg;
 	u8 duplex = cmd->base.duplex;
@@ -818,12 +820,13 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	if (phy_is_started(phydev)) {
 		phydev->state = PHY_UP;
 		phy_trigger_machine(phydev);
+		ret = 0;
 	} else {
-		_phy_start_aneg(phydev);
+		ret = _phy_start_aneg(phydev);
 	}
 
 	mutex_unlock(&phydev->lock);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(phy_ethtool_ksettings_set);
 
-- 
2.30.2

