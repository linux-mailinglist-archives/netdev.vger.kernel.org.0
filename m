Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9858F6C9EC8
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbjC0JAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbjC0I7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:59:51 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9634061B9;
        Mon, 27 Mar 2023 01:58:15 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32R8w2Xt121737;
        Mon, 27 Mar 2023 03:58:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679907482;
        bh=fRFUtDSpjBgtjXNs7TIIZRl4u88+v8cZSnRyn1XoXlc=;
        h=From:To:CC:Subject:Date;
        b=ig2Rg/gazakZLJRzJ3DFM8VTjuvWmOGeiBv5fcuvROUVQ92acMeSzKiBkOtT3AmOu
         hv0xhW+isk3F0ELLKEnyfudlRruLDJH222pgmX9qZohrg/i0bqLg/iOsGg0FVokuX5
         cEgj5H7WrBpsiT/QA5PeRqQVbNxrr8oAM25O6VXo=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32R8w2cf036372
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Mar 2023 03:58:02 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 27
 Mar 2023 03:58:02 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 27 Mar 2023 03:58:02 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32R8vxLW069500;
        Mon, 27 Mar 2023 03:57:59 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next] net: ethernet: ti: am65-cpsw: add .ndo to set dma per-queue rate
Date:   Mon, 27 Mar 2023 14:27:58 +0530
Message-ID: <20230327085758.3237155-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Enable rate limiting TX DMA queues for CPSW interface by configuring the
rate in absolute Mb/s units per TX queue.

Example:
    ethtool -L eth0 tx 4

    echo 100 > /sys/class/net/eth0/queues/tx-0/tx_maxrate
    echo 200 > /sys/class/net/eth0/queues/tx-1/tx_maxrate
    echo 50 > /sys/class/net/eth0/queues/tx-2/tx_maxrate
    echo 30 > /sys/class/net/eth0/queues/tx-3/tx_maxrate

    # disable
    echo 0 > /sys/class/net/eth0/queues/tx-0/tx_maxrate

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c |  12 ++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |   2 +
 drivers/net/ethernet/ti/am65-cpsw-qos.c  | 113 +++++++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-qos.h  |   4 +
 4 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 9ddb79776c88..44368ecd994a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -428,6 +428,8 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 	else
 		am65_cpsw_init_host_port_switch(common);
 
+	am65_cpsw_qos_tx_p0_rate_init(common);
+
 	for (i = 0; i < common->rx_chns.descs_num; i++) {
 		skb = __netdev_alloc_skb_ip_align(NULL,
 						  AM65_CPSW_MAX_PACKET_SIZE,
@@ -599,8 +601,12 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 		goto runtime_put;
 	}
 
-	for (i = 0; i < common->tx_ch_num; i++)
-		netdev_tx_reset_queue(netdev_get_tx_queue(ndev, i));
+	for (i = 0; i < common->tx_ch_num; i++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(ndev, i);
+
+		netdev_tx_reset_queue(txq);
+		txq->tx_maxrate =  common->tx_chns[i].rate_mbps;
+	}
 
 	ret = am65_cpsw_nuss_common_open(common);
 	if (ret)
@@ -1425,6 +1431,7 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= am65_cpsw_nuss_ndo_slave_kill_vid,
 	.ndo_eth_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
 	.ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
+	.ndo_set_tx_maxrate	= am65_cpsw_qos_ndo_tx_p0_set_maxrate,
 };
 
 static void am65_cpsw_disable_phy(struct phy *phy)
@@ -1616,6 +1623,7 @@ void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
 
 	devm_remove_action(dev, am65_cpsw_nuss_free_tx_chns, common);
 
+	common->tx_ch_rate_msk = 0;
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index cad04662739c..bf40c88fbd9b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -79,6 +79,7 @@ struct am65_cpsw_tx_chn {
 	u32 id;
 	u32 descs_num;
 	char tx_chn_name[128];
+	u32 rate_mbps;
 };
 
 struct am65_cpsw_rx_chn {
@@ -126,6 +127,7 @@ struct am65_cpsw_common {
 	int			usage_count; /* number of opened ports */
 	struct cpsw_ale		*ale;
 	int			tx_ch_num;
+	u32			tx_ch_rate_msk;
 	u32			rx_flow_id_base;
 
 	struct am65_cpsw_tx_chn	tx_chns[AM65_CPSW_MAX_TX_QUEUES];
diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index 8dc2c3085dcf..3a908db6e5b2 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -19,6 +19,7 @@
 #define AM65_CPSW_PN_REG_CTL			0x004
 #define AM65_CPSW_PN_REG_FIFO_STATUS		0x050
 #define AM65_CPSW_PN_REG_EST_CTL		0x060
+#define AM65_CPSW_PN_REG_PRI_CIR(pri)		(0x140 + 4 * (pri))
 
 /* AM65_CPSW_REG_CTL register fields */
 #define AM65_CPSW_CTL_EST_EN			BIT(18)
@@ -819,3 +820,115 @@ void am65_cpsw_qos_link_down(struct net_device *ndev)
 
 	port->qos.link_speed = SPEED_UNKNOWN;
 }
+
+static u32
+am65_cpsw_qos_tx_rate_calc(u32 rate_mbps, unsigned long bus_freq)
+{
+	u32 ir;
+
+	bus_freq /= 1000000;
+	ir = DIV_ROUND_UP(((u64)rate_mbps * 32768),  bus_freq);
+	return ir;
+}
+
+static void
+am65_cpsw_qos_tx_p0_rate_apply(struct am65_cpsw_common *common,
+			       int tx_ch, u32 rate_mbps)
+{
+	struct am65_cpsw_host *host = am65_common_get_host(common);
+	u32 ch_cir;
+	int i;
+
+	ch_cir = am65_cpsw_qos_tx_rate_calc(rate_mbps, common->bus_freq);
+	writel(ch_cir, host->port_base + AM65_CPSW_PN_REG_PRI_CIR(tx_ch));
+
+	/* update rates for every port tx queues */
+	for (i = 0; i < common->port_num; i++) {
+		struct net_device *ndev = common->ports[i].ndev;
+
+		if (!ndev)
+			continue;
+		netdev_get_tx_queue(ndev, tx_ch)->tx_maxrate = rate_mbps;
+	}
+}
+
+int am65_cpsw_qos_ndo_tx_p0_set_maxrate(struct net_device *ndev,
+					int queue, u32 rate_mbps)
+{
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	struct am65_cpsw_common *common = port->common;
+	struct am65_cpsw_tx_chn *tx_chn;
+	u32 ch_rate, tx_ch_rate_msk_new;
+	u32 ch_msk = 0;
+	int ret;
+
+	dev_dbg(common->dev, "apply TX%d rate limiting %uMbps tx_rate_msk%x\n",
+		queue, rate_mbps, common->tx_ch_rate_msk);
+
+	if (common->pf_p0_rx_ptype_rrobin) {
+		dev_err(common->dev, "TX Rate Limiting failed - rrobin mode\n");
+		return -EINVAL;
+	}
+
+	ch_rate = netdev_get_tx_queue(ndev, queue)->tx_maxrate;
+	if (ch_rate == rate_mbps)
+		return 0;
+
+	ret = pm_runtime_get_sync(common->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(common->dev);
+		return ret;
+	}
+	ret = 0;
+
+	tx_ch_rate_msk_new = common->tx_ch_rate_msk;
+	if (rate_mbps && !(tx_ch_rate_msk_new & BIT(queue))) {
+		tx_ch_rate_msk_new |= BIT(queue);
+		ch_msk = GENMASK(common->tx_ch_num - 1, queue);
+		ch_msk = tx_ch_rate_msk_new ^ ch_msk;
+	} else if (!rate_mbps) {
+		tx_ch_rate_msk_new &= ~BIT(queue);
+		ch_msk = queue ? GENMASK(queue - 1, 0) : 0;
+		ch_msk = tx_ch_rate_msk_new & ch_msk;
+	}
+
+	if (ch_msk) {
+		dev_err(common->dev, "TX rate limiting has to be enabled sequentially hi->lo tx_rate_msk:%x tx_rate_msk_new:%x\n",
+			common->tx_ch_rate_msk, tx_ch_rate_msk_new);
+		ret = -EINVAL;
+		goto exit_put;
+	}
+
+	tx_chn = &common->tx_chns[queue];
+	tx_chn->rate_mbps = rate_mbps;
+	common->tx_ch_rate_msk = tx_ch_rate_msk_new;
+
+	if (!common->usage_count)
+		/* will be applied on next netif up */
+		goto exit_put;
+
+	am65_cpsw_qos_tx_p0_rate_apply(common, queue, rate_mbps);
+
+exit_put:
+	pm_runtime_put(common->dev);
+	return ret;
+}
+
+void am65_cpsw_qos_tx_p0_rate_init(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_host *host = am65_common_get_host(common);
+	int tx_ch;
+
+	for (tx_ch = 0; tx_ch < common->tx_ch_num; tx_ch++) {
+		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[tx_ch];
+		u32 ch_cir;
+
+		if (!tx_chn->rate_mbps)
+			continue;
+
+		ch_cir = am65_cpsw_qos_tx_rate_calc(tx_chn->rate_mbps,
+						    common->bus_freq);
+		writel(ch_cir,
+		       host->port_base + AM65_CPSW_PN_REG_PRI_CIR(tx_ch));
+	}
+}
diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.h b/drivers/net/ethernet/ti/am65-cpsw-qos.h
index fb223b43b196..0cc2a3b3d7f9 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.h
@@ -8,6 +8,8 @@
 #include <linux/netdevice.h>
 #include <net/pkt_sched.h>
 
+struct am65_cpsw_common;
+
 struct am65_cpsw_est {
 	int buf;
 	/* has to be the last one */
@@ -33,5 +35,7 @@ int am65_cpsw_qos_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			       void *type_data);
 void am65_cpsw_qos_link_up(struct net_device *ndev, int link_speed);
 void am65_cpsw_qos_link_down(struct net_device *ndev);
+int am65_cpsw_qos_ndo_tx_p0_set_maxrate(struct net_device *ndev, int queue, u32 rate_mbps);
+void am65_cpsw_qos_tx_p0_rate_init(struct am65_cpsw_common *common);
 
 #endif /* AM65_CPSW_QOS_H_ */
-- 
2.25.1

