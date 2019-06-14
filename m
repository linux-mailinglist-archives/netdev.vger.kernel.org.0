Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C201546214
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfFNPHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:07:01 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:43456 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725780AbfFNPHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:07:01 -0400
Received: from mailhost.synopsys.com (unknown [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 15BE3C2390;
        Fri, 14 Jun 2019 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1560524821; bh=Op4ZxYsnB/J5QGVqA8PvUdINkiagCSQfGiBRXY2o7c0=;
        h=From:To:Cc:Subject:Date:From;
        b=dBsQifPEpa85HVcpdeXh7YlLop1tFH1dgbIUVMj/+qGvYBo37np+zKGyj5yGZh/Lz
         EQLtISnYcXPrDkB5MiXjpzbptFax6EMHsj2XDHt0vqNDdw9ht+VuxwTue1G4W4uA9w
         pbeKycT5xzRERcspB85uSBJQafSjjbMEGxKN6YEonznaEB7j90ycqm0cKEe2woUQ0w
         /z05pmZwlr8kRmKmJqDA4U6ekBGsYly3Zay0jKcDdz0E/ekoBL2/Rkh3MoamsaulHd
         KbLIxbVb8Gams6DsHkRcspDCqOYmughUsZFZEG9cp3Pqe7b77VYLrgh23vT1fNDFom
         IZY/RIgpNUXUg==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 371EAA022E;
        Fri, 14 Jun 2019 15:06:58 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id D390E3F849;
        Fri, 14 Jun 2019 17:06:58 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next] net: stmmac: Fix wrapper drivers not detecting PHY
Date:   Fri, 14 Jun 2019 17:06:57 +0200
Message-Id: <f4f524805a81c6f680b55d8fb084b1070294a0a8.1560524776.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because of PHYLINK conversion we stopped parsing the phy-handle property
from DT. Unfortunatelly, some wrapper drivers still rely on this phy
node to configure the PHY.

Let's restore the parsing of PHY handle while these wrapper drivers are
not fully converted to PHYLINK.

Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 9 ++++++++-
 include/linux/stmmac.h                                | 1 +
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ad007d8bf9d7..069951590018 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -958,7 +958,7 @@ static int stmmac_init_phy(struct net_device *dev)
 	struct device_node *node;
 	int ret;
 
-	node = priv->plat->phy_node;
+	node = priv->plat->phylink_node;
 
 	if (node) {
 		ret = phylink_of_phy_connect(priv->phylink, node, 0);
@@ -980,7 +980,7 @@ static int stmmac_init_phy(struct net_device *dev)
 
 static int stmmac_phy_setup(struct stmmac_priv *priv)
 {
-	struct device_node *node = priv->plat->phy_node;
+	struct device_node *node = priv->plat->phylink_node;
 	int mode = priv->plat->interface;
 	struct phylink *phylink;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 898f94aced53..49adda9b0ad8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -381,7 +381,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 
 	*mac = of_get_mac_address(np);
 	plat->interface = of_get_phy_mode(np);
-	plat->phy_node = np;
+
+	/* Some wrapper drivers still rely on phy_node. Let's save it while
+	 * they are not converted to phylink. */
+	plat->phy_node = of_parse_phandle(np, "phy-handle", 0);
+
+	/* PHYLINK automatically parses the phy-handle property */
+	plat->phylink_node = np;
 
 	/* Get max speed of operation from device tree */
 	if (of_property_read_u32(np, "max-speed", &plat->max_speed))
@@ -577,6 +583,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 void stmmac_remove_config_dt(struct platform_device *pdev,
 			     struct plat_stmmacenet_data *plat)
 {
+	of_node_put(plat->phy_node);
 	of_node_put(plat->mdio_node);
 }
 #else
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 4335bd771ce5..1250e737f320 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -151,6 +151,7 @@ struct plat_stmmacenet_data {
 	int interface;
 	struct stmmac_mdio_bus_data *mdio_bus_data;
 	struct device_node *phy_node;
+	struct device_node *phylink_node;
 	struct device_node *mdio_node;
 	struct stmmac_dma_cfg *dma_cfg;
 	int clk_csr;
-- 
2.7.4

