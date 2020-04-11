Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5BF1A5733
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgDKXVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730440AbgDKXN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2902E215A4;
        Sat, 11 Apr 2020 23:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646810;
        bh=7KBDcV+VldsNsgWPBdf6rR21Z7fTkA7aE2nF50A1fIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImxKixyRQ2SjRXKHaWJBf/QubVdjOkZlMB1QKdAgQe2J6WRzl5eBhkEcVrKG1wYc/
         11ZiVgZL3WXxHedM/45GRdsfHcbjeo8zNdVlJuFGL0kkohYZ6IBQ9KjZaCW9BR0uAY
         3ktRcjsd/EMZtJpipvOGbW9xn8W0PWY0+tRwUQHM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/37] net: phy: probe PHY drivers synchronously
Date:   Sat, 11 Apr 2020 19:12:51 -0400
Message-Id: <20200411231327.26550-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231327.26550-1-sashal@kernel.org>
References: <20200411231327.26550-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 16983507742cbcaa5592af530872a82e82fb9c51 ]

If we have scenarios like

mdiobus_register()
	-> loads PHY driver module(s)
	-> registers PHY driver(s)
	-> may schedule async probe
phydev = mdiobus_get_phy()
<phydev action involving PHY driver>

or

phydev = phy_device_create()
	-> loads PHY driver module
	-> registers PHY driver
	-> may schedule async probe
<phydev action involving PHY driver>

then we expect the PHY driver to be bound to the phydev when triggering
the action. This may not be the case in case of asynchronous probing.
Therefore ensure that PHY drivers are probed synchronously.

Default still is sync probing, except async probing is explicitly
requested. I saw some comments that the intention is to promote
async probing for more parallelism in boot process and want to be
prepared for the case that the default is changed to async probing.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 27f1f0b5b8f67..abfe4a6d7eb30 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1887,6 +1887,7 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner)
 	new_driver->mdiodrv.driver.probe = phy_probe;
 	new_driver->mdiodrv.driver.remove = phy_remove;
 	new_driver->mdiodrv.driver.owner = owner;
+	new_driver->mdiodrv.driver.probe_type = PROBE_FORCE_SYNCHRONOUS;
 
 	retval = driver_register(&new_driver->mdiodrv.driver);
 	if (retval) {
-- 
2.20.1

