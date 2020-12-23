Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734832E17B3
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgLWDNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbgLWCSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75BAF23332;
        Wed, 23 Dec 2020 02:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689821;
        bh=VViRNDvVBRjtlr4y6UCpIPwGWBmiSO2kG/4fB/YY6lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gahUObVeCoOMYziaxv0HVIA+45aaUG7DY75VwUMzh7xfYBmqEJmGFtwmPQXbivO8P
         M15AJ5d/DOJQJ3lDYTlqyOIOmUHjGYcU5hS6fydYjIcuWc2YQjTwATb3TwEKONemjt
         m6r8yIj6fZb0xYN76cY5OfDtBxUMWHxjsFJRojf3MkLEAmhagNyaNvZ7UdCRIlaLHb
         9ofS1a63P9YYLdGobHQ0WVtX1zJDsdNmI2T/Vw0m9wuRRL2dRWcSiUHb0gY5jg1Bil
         UJ8cCNUZIYsQmiKdVruF+RfwV/fzClVecTQXAHl9NnA8cPLE1hqQBs4KB7P0C5j7Kw
         4yhOu8lRNkfjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 026/217] net: ethernet: ti: am65-cpsw: fix tx csum offload for multi mac mode
Date:   Tue, 22 Dec 2020 21:13:15 -0500
Message-Id: <20201223021626.2790791-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 97067aaf127487788a297267dede0008cd75bb7b ]

The current implementation uses .ndo_set_features() callback to track
NETIF_F_HW_CSUM feature changes and update generic
CPSW_P0_CONTROL_REG.RX_CHECKSUM_EN option accordingly. It's not going to
work in case of multi-port devices as TX csum offload can be changed per
netdev.

On K3 CPSWxG devices TX csum offload enabled in the following way:

 - the CPSW_P0_CONTROL_REG.RX_CHECKSUM_EN option enables TX csum offload in
generic and affects all TX DMA channels and packets;

 - corresponding fields in TX DMA descriptor have to be filed properly when
upper layer wants to offload TX csum (skb->ip_summed == CHECKSUM_PARTIAL)
and it's per-packet option.

The Linux Network core is expected to never request TX csum offload if
netdev NETIF_F_HW_CSUM feature is disabled, and, as result, TX DMA
descriptors should not be modified, and per-packet TX csum offload will be
disabled (or enabled) on per-netdev basis. Which, in turn, makes it safe to
enable the CPSW_P0_CONTROL_REG.RX_CHECKSUM_EN option unconditionally.

Hence, fix TX csum offload for multi-port devices by:
 - enabling the CPSW_P0_CONTROL_REG.RX_CHECKSUM_EN option in
am65_cpsw_nuss_common_open() unconditionally
 - and removing .ndo_set_features() callback implementation, which was used
only NETIF_F_HW_CSUM feature update purposes

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 30 +-----------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 501d676fd88b9..9c359570178c1 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -426,9 +426,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
 	writel(common->rx_flow_id_base,
 	       host_p->port_base + AM65_CPSW_PORT0_REG_FLOW_ID_OFFSET);
 	/* en tx crc offload */
-	if (features & NETIF_F_HW_CSUM)
-		writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN,
-		       host_p->port_base + AM65_CPSW_P0_REG_CTL);
+	writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN, host_p->port_base + AM65_CPSW_P0_REG_CTL);
 
 	am65_cpsw_nuss_set_p0_ptype(common);
 
@@ -1369,31 +1367,6 @@ static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }
 
-static int am65_cpsw_nuss_ndo_slave_set_features(struct net_device *ndev,
-						 netdev_features_t features)
-{
-	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
-	netdev_features_t changes = features ^ ndev->features;
-	struct am65_cpsw_host *host_p;
-
-	host_p = am65_common_get_host(common);
-
-	if (changes & NETIF_F_HW_CSUM) {
-		bool enable = !!(features & NETIF_F_HW_CSUM);
-
-		dev_info(common->dev, "Turn %s tx-checksum-ip-generic\n",
-			 enable ? "ON" : "OFF");
-		if (enable)
-			writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN,
-			       host_p->port_base + AM65_CPSW_P0_REG_CTL);
-		else
-			writel(0,
-			       host_p->port_base + AM65_CPSW_P0_REG_CTL);
-	}
-
-	return 0;
-}
-
 static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
 	.ndo_open		= am65_cpsw_nuss_ndo_slave_open,
 	.ndo_stop		= am65_cpsw_nuss_ndo_slave_stop,
@@ -1406,7 +1379,6 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
 	.ndo_vlan_rx_add_vid	= am65_cpsw_nuss_ndo_slave_add_vid,
 	.ndo_vlan_rx_kill_vid	= am65_cpsw_nuss_ndo_slave_kill_vid,
 	.ndo_do_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
-	.ndo_set_features	= am65_cpsw_nuss_ndo_slave_set_features,
 	.ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
 };
 
-- 
2.27.0

