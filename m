Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4BE1AA04E
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393975AbgDOMZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409187AbgDOLph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A480320768;
        Wed, 15 Apr 2020 11:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951137;
        bh=Vew8/XVYckcfekfoGuNehZoXUSeAOak6CSjr48af9ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6BL8QCVBo27kCdXr46U0/8dJt60mWzZEOeMd33oDU9kOAf5qYWs9+NxyjllhLJK5
         rfqdNZGKCCxUBS3y38kEpwUahLzkyO8xzRTX+ZHW9JbHFga1s0yvyZh+PrgCG4gNib
         lsFe4rkyWqxelUTBUyfwjGgPma1GaJXj2cz2TgLg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 47/84] net: dsa: bcm_sf2: Do not register slave MDIO bus with OF
Date:   Wed, 15 Apr 2020 07:44:04 -0400
Message-Id: <20200415114442.14166-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 536fab5bf5826404534a6c271f622ad2930d9119 ]

We were registering our slave MDIO bus with OF and doing so with
assigning the newly created slave_mii_bus of_node to the master MDIO bus
controller node. This is a bad thing to do for a number of reasons:

- we are completely lying about the slave MII bus is arranged and yet we
  still want to control which MDIO devices it probes. It was attempted
  before to play tricks with the bus_mask to perform that:
  https://www.spinics.net/lists/netdev/msg429420.html but the approach
  was rightfully rejected

- the device_node reference counting is messed up and we are effectively
  doing a double probe on the devices we already probed using the
  master, this messes up all resources reference counts (such as clocks)

The proper fix for this as indicated by David in his reply to the
thread above is to use a platform data style registration so as to
control exactly which devices we probe:
https://www.spinics.net/lists/netdev/msg430083.html

By using mdiobus_register(), our slave_mii_bus->phy_mask value is used
as intended, and all the PHY addresses that must be redirected towards
our slave MDIO bus is happening while other addresses get redirected
towards the master MDIO bus.

Fixes: 461cd1b03e32 ("net: dsa: bcm_sf2: Register our slave MDIO bus")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 46dc913da852d..4878400584c23 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -459,7 +459,7 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	priv->slave_mii_bus->parent = ds->dev->parent;
 	priv->slave_mii_bus->phy_mask = ~priv->indir_phy_mask;
 
-	err = of_mdiobus_register(priv->slave_mii_bus, dn);
+	err = mdiobus_register(priv->slave_mii_bus);
 	if (err && dn)
 		of_node_put(dn);
 
-- 
2.20.1

