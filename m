Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD3C28FBB1
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 01:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389331AbgJOXUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 19:20:45 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:44888 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388051AbgJOXUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 19:20:13 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09FNK9mH080166;
        Thu, 15 Oct 2020 18:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1602804009;
        bh=ewROu7Q2O2A+0M4QFg37GhMfdhSj0nn4WoaiLq+SZxw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=bGnq6IsmT0DtEH2iDf66oQBdFu9aQoBIrvAobCm9Tm2ZcmaOGghIFU9BQQ2kSVRiG
         1Xkfy01BHg3L4cYKTLHJKXwbXSgrni0eeU6GYQvQWSnWGqtbd9G/H/sEl3ycLVsQ9/
         Lg7hOKooCr+1597ISiXWor7M3Gnn5xP1Py+sysdU=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09FNK9Zb009598
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 18:20:09 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 15
 Oct 2020 18:20:09 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 15 Oct 2020 18:20:09 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09FNK8cj058893;
        Thu, 15 Oct 2020 18:20:08 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 7/9] net: ethernet: ti: am65-cpsw: fix tx csum offload for multi mac mode
Date:   Fri, 16 Oct 2020 02:19:11 +0300
Message-ID: <20201015231913.30280-8-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201015231913.30280-1-grygorii.strashko@ti.com>
References: <20201015231913.30280-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 30 +-----------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 0bc0eec46709..2aa0c2acd059 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -428,9 +428,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
 	writel(common->rx_flow_id_base,
 	       host_p->port_base + AM65_CPSW_PORT0_REG_FLOW_ID_OFFSET);
 	/* en tx crc offload */
-	if (features & NETIF_F_HW_CSUM)
-		writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN,
-		       host_p->port_base + AM65_CPSW_P0_REG_CTL);
+	writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN, host_p->port_base + AM65_CPSW_P0_REG_CTL);
 
 	am65_cpsw_nuss_set_p0_ptype(common);
 
@@ -1371,31 +1369,6 @@ static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
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
@@ -1408,7 +1381,6 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
 	.ndo_vlan_rx_add_vid	= am65_cpsw_nuss_ndo_slave_add_vid,
 	.ndo_vlan_rx_kill_vid	= am65_cpsw_nuss_ndo_slave_kill_vid,
 	.ndo_do_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
-	.ndo_set_features	= am65_cpsw_nuss_ndo_slave_set_features,
 	.ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
 };
 
-- 
2.17.1

