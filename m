Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78EC59017E
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbiHKPzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236929AbiHKPyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:54:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AC088DEB;
        Thu, 11 Aug 2022 08:45:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80DA6616F2;
        Thu, 11 Aug 2022 15:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C6DC433C1;
        Thu, 11 Aug 2022 15:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232756;
        bh=OglZk3lvIIpnspeCkp4O55N82sJMle/dH7SfPmuFBaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYOehzT9X85fswKuvbsO9M4ql9ayRVfEPXOcZA7sf1U5aZSDgsd/hJmNBXU0c7pbW
         gjw0TXPe5b7qM4DieN46C1bhaWT9BiHe5suZa37Wq4+s0kl+VM3v4kopJjaspayWnI
         imD1KOvut8OI7svCfXy2FOftpPPzesB2Q+yWPlqhasue8odl9NhVuZGcKMk2R5wiHm
         WnW6DETUNaZmB4e+To6ggsW+A7LGGVQZNtLYQQy1hpk85T0sY/P6QueAj1naJ+zqEr
         ZrNgatR6MfYVt5yFzPE/PqwoYym2sFY+RvZsupkbEMXhrRLzE0s4apv6ettg9qhRbG
         zL0cTnBn0adig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Emilio Riva <emilio.riva@ericsson.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 28/93] net: stmmac: make mdio register skips PHY scanning for fixed-link
Date:   Thu, 11 Aug 2022 11:41:22 -0400
Message-Id: <20220811154237.1531313-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

[ Upstream commit ab21cf920928a791aa70b8665b395294da17667c ]

stmmac_mdio_register() lacks fixed-link consideration and only skip PHY
scanning if it has done DT style PHY discovery. So, for DT or ACPI _DSD
setting of fixed-link, the PHY scanning should not happen.

v2: fix incorrect order related to fwnode that is not caught in non-DT
    platform.

Tested-by: Emilio Riva <emilio.riva@ericsson.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 +++++++-----
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 14 ++++++++++++++
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6a7f63a58aef..98c4abbcd469 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1119,18 +1119,20 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
 static int stmmac_init_phy(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	struct device_node *node;
+	struct fwnode_handle *fwnode;
 	int ret;
 
-	node = priv->plat->phylink_node;
+	fwnode = of_fwnode_handle(priv->plat->phylink_node);
+	if (!fwnode)
+		fwnode = dev_fwnode(priv->device);
 
-	if (node)
-		ret = phylink_of_phy_connect(priv->phylink, node, 0);
+	if (fwnode)
+		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
 
 	/* Some DT bindings do not set-up the PHY handle. Let's try to
 	 * manually parse it
 	 */
-	if (!node || ret) {
+	if (!fwnode || ret) {
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index a5d150c5f3d8..971e287aeb05 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -442,9 +442,11 @@ int stmmac_mdio_register(struct net_device *ndev)
 	int err = 0;
 	struct mii_bus *new_bus;
 	struct stmmac_priv *priv = netdev_priv(ndev);
+	struct fwnode_handle *fwnode = of_fwnode_handle(priv->plat->phylink_node);
 	struct stmmac_mdio_bus_data *mdio_bus_data = priv->plat->mdio_bus_data;
 	struct device_node *mdio_node = priv->plat->mdio_node;
 	struct device *dev = ndev->dev.parent;
+	struct fwnode_handle *fixed_node;
 	int addr, found, max_addr;
 
 	if (!mdio_bus_data)
@@ -498,6 +500,18 @@ int stmmac_mdio_register(struct net_device *ndev)
 	if (priv->plat->has_xgmac)
 		stmmac_xgmac2_mdio_read(new_bus, 0, MII_ADDR_C45);
 
+	/* If fixed-link is set, skip PHY scanning */
+	if (!fwnode)
+		fwnode = dev_fwnode(priv->device);
+
+	if (fwnode) {
+		fixed_node = fwnode_get_named_child_node(fwnode, "fixed-link");
+		if (fixed_node) {
+			fwnode_handle_put(fixed_node);
+			goto bus_register_done;
+		}
+	}
+
 	if (priv->plat->phy_node || mdio_node)
 		goto bus_register_done;
 
-- 
2.35.1

