Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750254465DC
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 16:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhKEPjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 11:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbhKEPjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 11:39:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47ABC061714
        for <netdev@vger.kernel.org>; Fri,  5 Nov 2021 08:37:15 -0700 (PDT)
From:   bage@linutronix.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636126632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=32u/h+AhFNcJdhzZSXFqRmKif6T6lGmEHXrljnikU+A=;
        b=T3FvYUwAv9WK3dD3HTtIlOxXHVmodcJKgHTgr0JAdONtiBCF3qQbxFZI4FyepcwYeJDEIX
        cwN46poBsFrbq3WXsodxIWgs63MheBxefsIm9fIf7xeqzNg0WqOZ9T/b1yknH19KhVyJVw
        qMT79F3vwrPMZRwMCmkbvYlLANoMd9dTeIdhoriJjQ/bzTsnrccNywo366yC2yRDYRr6G3
        500wwiA935Qk2GhdsRdMLYoHdtclWEzVBHWJd0ExWyQseAr9tVlB+oBsDkHoeFuftysHl0
        U0vPk3lisYNg2AY+XwRa4J/5EdRNr4uM4rbZgb0cAMG5SJvsQaQnwClQhT3Q1Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636126632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=32u/h+AhFNcJdhzZSXFqRmKif6T6lGmEHXrljnikU+A=;
        b=fPZQlybeQ0HxyW+wkart5pR1+xMv3iHbB9ZFJHq6jNxyIaM2QwxpY/hfXhNIIH9rKYesNk
        qz3+pEBftp02gKCw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bastian Germann <bage@linutronix.de>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH] phy: phy_ethtool_ksettings_set: Don't discard phy_start_aneg's return
Date:   Fri,  5 Nov 2021 16:36:48 +0100
Message-Id: <20211105153648.8337-1-bage@linutronix.de>
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
Reviewed-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 drivers/net/phy/phy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index a3bfb156c83d..f740b533abba 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -770,6 +770,8 @@ static int phy_poll_aneg_done(struct phy_device *phydev)
 int phy_ethtool_ksettings_set(struct phy_device *phydev,
 			      const struct ethtool_link_ksettings *cmd)
 {
+	int ret = 0;
+
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
 	u8 autoneg = cmd->base.autoneg;
 	u8 duplex = cmd->base.duplex;
@@ -815,10 +817,10 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-	_phy_start_aneg(phydev);
+	ret = _phy_start_aneg(phydev);
 
 	mutex_unlock(&phydev->lock);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(phy_ethtool_ksettings_set);
 
-- 
2.30.2

