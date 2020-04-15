Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745AF1A9DDF
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 13:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897623AbgDOLrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 07:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409331AbgDOLqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:46:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38D02206A2;
        Wed, 15 Apr 2020 11:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951207;
        bh=4ePs0/n5DCwcFojc0Lv1HVDePUTl7V28aT9dI6HNJt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiBcyYG4mKISTUhncM0uEiAZ1n/eMKBcxtXHNjvD4cH3NmpO2YeO2nssDeVcH5gZw
         HdQvtv64LlKA+fTgebFQ/vEvl1Z1zQFuDU8Ue9dgliDOpIjKIKy4W0wu4K6gnb+ft0
         /OBZ/x/zqLIkZPylLHcP8SlYbTMaTbpPhZd1K2zQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/40] net: dsa: bcm_sf2: Do not register slave MDIO bus with OF
Date:   Wed, 15 Apr 2020 07:46:03 -0400
Message-Id: <20200415114623.14972-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114623.14972-1-sashal@kernel.org>
References: <20200415114623.14972-1-sashal@kernel.org>
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
index 8c69789fbe094..b56b2eaf654e1 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -461,7 +461,7 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	priv->slave_mii_bus->parent = ds->dev->parent;
 	priv->slave_mii_bus->phy_mask = ~priv->indir_phy_mask;
 
-	err = of_mdiobus_register(priv->slave_mii_bus, dn);
+	err = mdiobus_register(priv->slave_mii_bus);
 	if (err && dn)
 		of_node_put(dn);
 
-- 
2.20.1

