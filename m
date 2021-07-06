Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E563BCF03
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbhGFL1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235021AbhGFLZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 737CE613B0;
        Tue,  6 Jul 2021 11:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570369;
        bh=0Wy9fBuu9zLIzEWuEq2BQP5HGVGbgrHZtJ8KSTWatYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSbeKcknNB0zxjynOfehA7FdZvO1y/8BuTrrUWrY80DVAXIBJRlb6A5VQF0uH9c4h
         O9MqDs1MJZLid7sb4ZeZRxD8rYXqq3pXTFCHQaazQoTQSEIP5PHeYrP0B4jIk+LVwF
         FBtyfz7y9YLvZXVrFDK7j+dB4m6PC72NrI33C4h2OiLDi93c7mYMVFTS3xwrr5mzmF
         SEsrNA6+CeXxL3FrUqBfquH8c5nZK8N8h+6WEipzTprwk5L/pLbOxQYOfAjRWxxf77
         rueDC5OIqqcK5jaieT1qYEHo8dTwkcWQzPmxx9taCvqnT43YL5yMR1SxS+X3zQR3Cp
         eSnGFs6URmF4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 046/160] net: stmmac: the XPCS obscures a potential "PHY not found" error
Date:   Tue,  6 Jul 2021 07:16:32 -0400
Message-Id: <20210706111827.2060499-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4751d2aa321f2828d8c5d2f7ce4ed18a01e47f46 ]

stmmac_mdio_register() has logic to search for PHYs on the MDIO bus and
assign them IRQ lines, as well as to set priv->plat->phy_addr.

If no PHY is found, the "found" variable remains set to 0 and the
function errors out.

After the introduction of commit f213bbe8a9d6 ("net: stmmac: Integrate
it with DesignWare XPCS"), the "found" variable was immediately reused
for searching for a PCS on the same MDIO bus.

This can result in 2 types of potential problems (none of them seems to
be seen on the only Intel system that sets has_xpcs = true, otherwise it
would have been reported):

1. If a PCS is found but a PHY is not, then the code happily exits with
   no error. One might say "yes, but this is not possible, because
   of_mdiobus_register will probe a PHY for all MDIO addresses,
   including for the XPCS, so if an XPCS exists, then a PHY certainly
   exists too". Well, that is not true, see intel_mgbe_common_data():

	/* Ensure mdio bus scan skips intel serdes and pcs-xpcs */
	plat->mdio_bus_data->phy_mask = 1 << INTEL_MGBE_ADHOC_ADDR;
	plat->mdio_bus_data->phy_mask |= 1 << INTEL_MGBE_XPCS_ADDR;

2. A PHY is found but an MDIO device with the XPCS PHY ID isn't, and in
   that case, the error message will be "No PHY found". Confusing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20210527155959.3270478-1-olteanv@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index d64116e0543e..a4ba27bf3131 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -444,6 +444,12 @@ int stmmac_mdio_register(struct net_device *ndev)
 		found = 1;
 	}
 
+	if (!found && !mdio_node) {
+		dev_warn(dev, "No PHY found\n");
+		err = -ENODEV;
+		goto no_phy_found;
+	}
+
 	/* Try to probe the XPCS by scanning all addresses. */
 	if (priv->hw->xpcs) {
 		struct mdio_xpcs_args *xpcs = &priv->hw->xpcs_args;
@@ -452,6 +458,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 
 		xpcs->bus = new_bus;
 
+		found = 0;
 		for (addr = 0; addr < max_addr; addr++) {
 			xpcs->addr = addr;
 
@@ -461,13 +468,12 @@ int stmmac_mdio_register(struct net_device *ndev)
 				break;
 			}
 		}
-	}
 
-	if (!found && !mdio_node) {
-		dev_warn(dev, "No PHY found\n");
-		mdiobus_unregister(new_bus);
-		mdiobus_free(new_bus);
-		return -ENODEV;
+		if (!found && !mdio_node) {
+			dev_warn(dev, "No XPCS found\n");
+			err = -ENODEV;
+			goto no_xpcs_found;
+		}
 	}
 
 bus_register_done:
@@ -475,6 +481,9 @@ int stmmac_mdio_register(struct net_device *ndev)
 
 	return 0;
 
+no_xpcs_found:
+no_phy_found:
+	mdiobus_unregister(new_bus);
 bus_register_fail:
 	mdiobus_free(new_bus);
 	return err;
-- 
2.30.2

