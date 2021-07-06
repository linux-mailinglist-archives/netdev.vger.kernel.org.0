Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76983BCC25
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhGFLS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232384AbhGFLSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B73E961C43;
        Tue,  6 Jul 2021 11:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570128;
        bh=X0vuEX7gbgXVikkrOrMJN4xe+EpY/dDaKKOHLoFDWpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6dceCbZq3muGGnY7AX7Z+qDzAtxOd9okgbHeTGjdgOMUVoZRXgIlnED0SvqbmBJU
         wVJ55jzc5xz3gdc39rpm0efkX1w/OqcM59AIENMgF9xTJd5+GhmzCaFqAhGhfDMlvH
         KiU+OiBtjWCrpf/kVAdhLKkgOsYPFH1nIE5+W+kNys3a7zEK96PwJRfgYuQBPxdnfy
         Y3cLaTqCPTuA2n3/C75Q4tmmT8damFFtkyKWYUGem4JuCzZ7gTdZHwfzY4bLFck5JO
         4Db2EhOV1GJ8r2ntYGohG/Xm/2d13SOD1QJwfQk6XBURBsC3WFlxzs349gFPqsGxuK
         vgnJE3gSJ1MAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 056/189] net: stmmac: the XPCS obscures a potential "PHY not found" error
Date:   Tue,  6 Jul 2021 07:11:56 -0400
Message-Id: <20210706111409.2058071-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index b750074f8f9c..e293bf1ce9f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -503,6 +503,12 @@ int stmmac_mdio_register(struct net_device *ndev)
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
@@ -511,6 +517,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 
 		xpcs->bus = new_bus;
 
+		found = 0;
 		for (addr = 0; addr < max_addr; addr++) {
 			xpcs->addr = addr;
 
@@ -520,13 +527,12 @@ int stmmac_mdio_register(struct net_device *ndev)
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
@@ -534,6 +540,9 @@ int stmmac_mdio_register(struct net_device *ndev)
 
 	return 0;
 
+no_xpcs_found:
+no_phy_found:
+	mdiobus_unregister(new_bus);
 bus_register_fail:
 	mdiobus_free(new_bus);
 	return err;
-- 
2.30.2

