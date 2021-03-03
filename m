Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9843132C490
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443191AbhCDAPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1835111AbhCCSCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 13:02:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C90AF64EE4;
        Wed,  3 Mar 2021 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614794018;
        bh=Xy6bbNJjRA+au+O/dSm09MnBghUD0TZFOxQtt3CtaAE=;
        h=Date:From:To:Cc:Subject:Reply-To:From;
        b=hkTNKZF28rH8UF/ZxZjYJocKXOwuOii49q2ccZmB8pRcrXWfm2vNoQ8JBOY+PUb4D
         2kd2+AiGG8/qI4W/RirIIQB/Ia43eyvWN/Do5QvabFsryCiyjOhglZU8ARmqNboaPE
         jRdcfOvzdnKBu1yNG9OvChupsuCuOBrMZyBH7NCwsjoInNeM9ZN6M6dd0m0RxUKV0c
         wSyf/0aFNuiA4V9Gco+nnYWbKZks6I/ghGhN7844RiN4v0VAwhpop1Eq0ndhNOhTpg
         wts1XKDBaMOT7K70vw7Sq4divfM734emVf/0yIjFPZAGNUnnPF22xdJQPtevUlYK6e
         5nxzvOZ8gwncQ==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 64D5835237A1; Wed,  3 Mar 2021 09:53:38 -0800 (PST)
Date:   Wed, 3 Mar 2021 09:53:38 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH drivers/net] #ifdef mdio_bus_phy_suspend() and
 mdio_bus_phy_suspend()
Message-ID: <20210303175338.GA15338@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net: #ifdef mdio_bus_phy_suspend() and mdio_bus_phy_suspend()

The following build error is emitted by rcutorture builds of v5.12-rc1:

drivers/net/phy/phy_device.c:293:12: warning: ‘mdio_bus_phy_resume’ defined but not used [-Wunused-function]
drivers/net/phy/phy_device.c:273:12: warning: ‘mdio_bus_phy_suspend’ defined but not used [-Wunused-function]

The problem is that these functions are only used by SIMPLE_DEV_PM_OPS(),
which creates a dev_pm_ops structure only in CONFIG_PM_SLEEP=y kernels.
Therefore, the mdio_bus_phy_suspend() and mdio_bus_phy_suspend() functions
will be used only in CONFIG_PM_SLEEP=y kernels.  This commit therefore
wraps them in #ifdef CONFIG_PM_SLEEP.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: <netdev@vger.kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ce49547..d6fb6e7 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -270,6 +270,8 @@ static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 	return !phydev->suspended;
 }
 
+#ifdef CONFIG_PM_SLEEP
+
 static int mdio_bus_phy_suspend(struct device *dev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
@@ -314,6 +316,8 @@ static int mdio_bus_phy_resume(struct device *dev)
 	return 0;
 }
 
+#endif
+
 static SIMPLE_DEV_PM_OPS(mdio_bus_phy_pm_ops, mdio_bus_phy_suspend,
 			 mdio_bus_phy_resume);
 #endif /* CONFIG_PM */
