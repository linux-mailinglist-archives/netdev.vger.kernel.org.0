Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84D03251D5
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBYO6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 09:58:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhBYO6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 09:58:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0504864EC3;
        Thu, 25 Feb 2021 14:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614265074;
        bh=hKnrb7BDV9TIMzXlWP4pNXmJJKiuS87VGbVD1hVF7OM=;
        h=From:To:Cc:Subject:Date:From;
        b=a4uAqtE4rqkDu+NB/ydjWO/+A6y8IciUikjtofjaHraPdImIG+xB8VMqm20GFI5GH
         +DCvkYElh2ffIuXc6pOXCHc2x2ewVx8h6jF1PN4LLATCKzhFE/d+m1UYXBOADY7LK/
         hY7GI39AkZKy7+9vGG8dkxWJUWUjqkpLu7K9WOfop1OtKz+N1gHS8EBhSUx3xmAiE/
         gZ50XyhxezTI60aJGFGZPEWWo+CmkeNFiMBYX1sEHJ7oyvR3qhvRyUMADL5MnewGl4
         bTEUgCtmQMfcwTnuynhy0xmwad8cBpuBdKpo2t43lqHvMUUSuLAruc2boRoRiev0nU
         sca+T3oczW5MA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: make mdio_bus_phy_suspend/resume as __maybe_unused
Date:   Thu, 25 Feb 2021 15:57:27 +0100
Message-Id: <20210225145748.404410-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When CONFIG_PM_SLEEP is disabled, the compiler warns about unused
functions:

drivers/net/phy/phy_device.c:273:12: error: unused function 'mdio_bus_phy_suspend' [-Werror,-Wunused-function]
static int mdio_bus_phy_suspend(struct device *dev)
drivers/net/phy/phy_device.c:293:12: error: unused function 'mdio_bus_phy_resume' [-Werror,-Wunused-function]
static int mdio_bus_phy_resume(struct device *dev)

The logic is intentional, so just mark these two as __maybe_unused
and remove the incorrect #ifdef.

Fixes: 4c0d2e96ba05 ("net: phy: consider that suspend2ram may cut off PHY power")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/phy/phy_device.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ce495473cd5d..cc38e326405a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -230,7 +230,6 @@ static struct phy_driver genphy_driver;
 static LIST_HEAD(phy_fixup_list);
 static DEFINE_MUTEX(phy_fixup_lock);
 
-#ifdef CONFIG_PM
 static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 {
 	struct device_driver *drv = phydev->mdio.dev.driver;
@@ -270,7 +269,7 @@ static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 	return !phydev->suspended;
 }
 
-static int mdio_bus_phy_suspend(struct device *dev)
+static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
@@ -290,7 +289,7 @@ static int mdio_bus_phy_suspend(struct device *dev)
 	return phy_suspend(phydev);
 }
 
-static int mdio_bus_phy_resume(struct device *dev)
+static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 	int ret;
@@ -316,7 +315,6 @@ static int mdio_bus_phy_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(mdio_bus_phy_pm_ops, mdio_bus_phy_suspend,
 			 mdio_bus_phy_resume);
-#endif /* CONFIG_PM */
 
 /**
  * phy_register_fixup - creates a new phy_fixup and adds it to the list
-- 
2.29.2

