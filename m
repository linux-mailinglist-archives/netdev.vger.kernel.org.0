Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CD62A0F52
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgJ3URF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:17:05 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37826 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727765AbgJ3UHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 16:07:36 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09UK7VkD104283;
        Fri, 30 Oct 2020 15:07:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604088451;
        bh=fiLBsddS8oeahHp6ZyDsEru2iPFfG4L/M00y9mHY89I=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=orhyjvNjhUzbPlbRf/mXQyha70abKBZ3EMGfqwjEa7dTO5wL5vW9awUSe5iixFRPb
         JtLJhDg6Gw+6PftK6qCQaydYi5ZYQgQRyX0DY2dUphiBaYnoeZmRXnUuPfOVOJyYfi
         W6ri0SrsbkOvc49b7kTo1FhugDC3K0jpyZD1DOGY=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09UK7Vl1052155
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 15:07:31 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 30
 Oct 2020 15:07:31 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 30 Oct 2020 15:07:31 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09UK7UqG070942;
        Fri, 30 Oct 2020 15:07:31 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        "Reviewed-by : Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 07/10] net: ethernet: ti: am65-cpsw: fix tx csum offload for multi mac mode
Date:   Fri, 30 Oct 2020 22:07:04 +0200
Message-ID: <20201030200707.24294-8-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201030200707.24294-1-grygorii.strashko@ti.com>
References: <20201030200707.24294-1-grygorii.strashko@ti.com>
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
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
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

