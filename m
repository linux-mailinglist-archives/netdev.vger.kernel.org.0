Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FC541C94A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346255AbhI2QDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:47 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27921 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345586AbhI2QAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLX00Hwpzbmvh;
        Wed, 29 Sep 2021 23:53:52 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:09 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 090/167] net: chelsio: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:17 +0800
Message-ID: <20210929155334.12454-91-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     | 45 +++++++-----
 drivers/net/ethernet/chelsio/cxgb/sge.c       | 12 +--
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   | 54 +++++++++-----
 drivers/net/ethernet/chelsio/cxgb3/sge.c      | 10 ++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c   | 16 ++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 73 ++++++++++++-------
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h |  3 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 14 ++--
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   | 33 ++++++---
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c    |  8 +-
 .../chelsio/inline_crypto/chtls/chtls_main.c  |  3 +-
 11 files changed, 167 insertions(+), 104 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 3fcd628fa449..193c75f5d682 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -186,7 +186,8 @@ static void link_start(struct port_info *p)
 
 static void enable_hw_csum(struct adapter *adapter)
 {
-	if (adapter->port[0].dev->hw_features & NETIF_F_TSO)
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT,
+				    adapter->port[0].dev->hw_features))
 		t1_tp_set_ip_checksum_offload(adapter->tp, 1);	/* for TSO only */
 	t1_tp_set_tcp_checksum_offload(adapter->tp, 1);
 }
@@ -864,18 +865,20 @@ static void t1_fix_features(struct net_device *dev, netdev_features_t *features)
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
-		*features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
-		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					 features);
 }
 
 static int t1_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
 	struct adapter *adapter = dev->ml_priv;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	netdev_feature_xor(&changed, dev->features, features);
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		t1_vlan_mode(adapter, features);
 
 	return 0;
@@ -1033,28 +1036,34 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->mem_start = mmio_start;
 		netdev->mem_end = mmio_start + mmio_len - 1;
 		netdev->ml_priv = adapter;
-		netdev->hw_features |= NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_RXCSUM;
-		netdev->features |= NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_RXCSUM | NETIF_F_LLTX;
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+					NETIF_F_RXCSUM, &netdev->hw_features);
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+					NETIF_F_RXCSUM | NETIF_F_LLTX,
+					&netdev->features);
 
 		if (pci_using_dac)
-			netdev->features |= NETIF_F_HIGHDMA;
+			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+					       &netdev->features);
 		if (vlan_tso_capable(adapter)) {
-			netdev->features |=
-				NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX;
-			netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+						NETIF_F_HW_VLAN_CTAG_RX,
+						&netdev->features);
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					       &netdev->hw_features);
 
 			/* T204: disable TSO */
 			if (!(is_T2(adapter)) || bi->port_number != 4) {
-				netdev->hw_features |= NETIF_F_TSO;
-				netdev->features |= NETIF_F_TSO;
+				netdev_feature_set_bit(NETIF_F_TSO_BIT,
+						       &netdev->hw_features);
+				netdev_feature_set_bit(NETIF_F_TSO_BIT,
+						       &netdev->features);
 			}
 		}
 
 		netdev->netdev_ops = &cxgb_netdev_ops;
-		netdev->hard_header_len += (netdev->hw_features & NETIF_F_TSO) ?
+		netdev->hard_header_len +=
+			netdev_feature_test_bit(NETIF_F_TSO_BIT, netdev->hw_features) ?
 			sizeof(struct cpl_tx_pkt_lso) : sizeof(struct cpl_tx_pkt);
 
 		netif_napi_add(netdev, &adapter->napi, t1_poll, 64);
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index cda01f22c71c..62bb33202def 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -737,7 +737,7 @@ void t1_vlan_mode(struct adapter *adapter, netdev_features_t features)
 {
 	struct sge *sge = adapter->sge;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		sge->sge_control |= F_VLAN_XTRACT;
 	else
 		sge->sge_control &= ~F_VLAN_XTRACT;
@@ -922,7 +922,8 @@ void t1_sge_intr_enable(struct sge *sge)
 	u32 en = SGE_INT_ENABLE;
 	u32 val = readl(sge->adapter->regs + A_PL_ENABLE);
 
-	if (sge->adapter->port[0].dev->hw_features & NETIF_F_TSO)
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT,
+				    sge->adapter->port[0].dev->hw_features))
 		en &= ~F_PACKET_TOO_BIG;
 	writel(en, sge->adapter->regs + A_SG_INT_ENABLE);
 	writel(val | SGE_PL_INTR_MASK, sge->adapter->regs + A_PL_ENABLE);
@@ -946,7 +947,8 @@ bool t1_sge_intr_error_handler(struct sge *sge)
 	u32 cause = readl(adapter->regs + A_SG_INT_CAUSE);
 	bool wake = false;
 
-	if (adapter->port[0].dev->hw_features & NETIF_F_TSO)
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT,
+				    adapter->port[0].dev->hw_features))
 		cause &= ~F_PACKET_TOO_BIG;
 	if (cause & F_RESPQ_EXHAUSTED)
 		sge->stats.respQ_empty++;
@@ -1386,8 +1388,8 @@ static void sge_rx(struct sge *sge, struct freelQ *fl, unsigned int len)
 	dev = adapter->port[p->iff].dev;
 
 	skb->protocol = eth_type_trans(skb, dev);
-	if ((dev->features & NETIF_F_RXCSUM) && p->csum == 0xffff &&
-	    skb->protocol == htons(ETH_P_IP) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->features) &&
+	    p->csum == 0xffff && skb->protocol == htons(ETH_P_IP) &&
 	    (skb->data[9] == IPPROTO_TCP || skb->data[9] == IPPROTO_UDP)) {
 		++st->rx_cso_good;
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 140b40e5c54c..acd2299c1657 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1183,15 +1183,18 @@ static void cxgb_vlan_mode(struct net_device *dev, netdev_features_t features)
 
 	if (adapter->params.rev > 0) {
 		t3_set_vlan_accel(adapter, 1 << pi->port_id,
-				  features & NETIF_F_HW_VLAN_CTAG_RX);
+				  netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+							  features));
 	} else {
 		/* single control for all ports */
-		unsigned int i, have_vlans = features & NETIF_F_HW_VLAN_CTAG_RX;
+		unsigned int i, have_vlans;
 
+		have_vlans = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						     features);
 		for_each_port(adapter, i)
 			have_vlans |=
-				adapter->port[i]->features &
-				NETIF_F_HW_VLAN_CTAG_RX;
+				netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+							adapter->port[i]->features);
 
 		t3_set_vlan_accel(adapter, 1, have_vlans);
 	}
@@ -2249,9 +2252,11 @@ static int cxgb_siocdevprivate(struct net_device *dev,
 
 		if (t.lro >= 0) {
 			if (t.lro)
-				dev->wanted_features |= NETIF_F_GRO;
+				netdev_feature_set_bit(NETIF_F_GRO_BIT,
+						       &dev->wanted_features);
 			else
-				dev->wanted_features &= ~NETIF_F_GRO;
+				netdev_feature_clear_bit(NETIF_F_GRO_BIT,
+							 &dev->wanted_features);
 			netdev_update_features(dev);
 		}
 
@@ -2291,7 +2296,8 @@ static int cxgb_siocdevprivate(struct net_device *dev,
 		t.fl_size[0] = q->fl_size;
 		t.fl_size[1] = q->jumbo_size;
 		t.polling = q->polling;
-		t.lro = !!(dev->features & NETIF_F_GRO);
+		t.lro = netdev_feature_test_bit(NETIF_F_GRO_BIT,
+						dev->features);
 		t.intr_lat = q->coalesce_usecs;
 		t.cong_thres = q->cong_thres;
 		t.qnum = q1;
@@ -2600,17 +2606,19 @@ static void cxgb_fix_features(struct net_device *dev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
-		*features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
-		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					 features);
 }
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	netdev_feature_xor(&changed, dev->features, features);
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		cxgb_vlan_mode(dev, features);
 
 	return 0;
@@ -3214,6 +3222,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	resource_size_t mmio_start, mmio_len;
 	const struct adapter_info *ai;
 	struct adapter *adapter = NULL;
+	netdev_features_t tmp;
 	struct port_info *pi;
 
 	if (!cxgb3_wq) {
@@ -3310,13 +3319,22 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->irq = pdev->irq;
 		netdev->mem_start = mmio_start;
 		netdev->mem_end = mmio_start + mmio_len - 1;
-		netdev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_RX;
-		netdev->features |= netdev->hw_features |
-				    NETIF_F_HW_VLAN_CTAG_TX;
-		netdev->vlan_features |= netdev->features & VLAN_FEAT;
+		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+					NETIF_F_TSO | NETIF_F_RXCSUM |
+					NETIF_F_HW_VLAN_CTAG_RX,
+					&netdev->hw_features);
+		netdev_feature_or(&netdev->features, netdev->features,
+				  netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       &netdev->features);
+		netdev_feature_copy(&tmp, netdev->features);
+		netdev_feature_and_bits(VLAN_FEAT, &tmp);
+		netdev_feature_or(&netdev->vlan_features,
+				  netdev->vlan_features, tmp);
 		if (pci_using_dac)
-			netdev->features |= NETIF_F_HIGHDMA;
+			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+					       &netdev->features);
 
 		netdev->netdev_ops = &cxgb_netdev_ops;
 		netdev->ethtool_ops = &cxgb_ethtool_ops;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index c3afec1041f8..d22843ca6705 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -2093,8 +2093,8 @@ static void rx_eth(struct adapter *adap, struct sge_rspq *rq,
 	skb_pull(skb, sizeof(*p) + pad);
 	skb->protocol = eth_type_trans(skb, adap->port[p->iff]);
 	pi = netdev_priv(skb->dev);
-	if ((skb->dev->features & NETIF_F_RXCSUM) && p->csum_valid &&
-	    p->csum == htons(0xffff) && !p->fragment) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, skb->dev->features) &&
+	    p->csum_valid && p->csum == htons(0xffff) && !p->fragment) {
 		qs->port_stats[SGE_PSTAT_RX_CSUM_GOOD]++;
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	} else
@@ -2174,7 +2174,8 @@ static void lro_add_page(struct adapter *adap, struct sge_qset *qs,
 		offset = 2 + sizeof(struct cpl_rx_pkt);
 		cpl = qs->lro_va = sd->pg_chunk.va + 2;
 
-		if ((qs->netdev->features & NETIF_F_RXCSUM) &&
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    qs->netdev->features) &&
 		     cpl->csum_valid && cpl->csum == htons(0xffff)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			qs->port_stats[SGE_PSTAT_RX_CSUM_GOOD]++;
@@ -2336,7 +2337,8 @@ static int process_responses(struct adapter *adap, struct sge_qset *qs,
 
 	while (likely(budget_left && is_new_response(r, q))) {
 		int packet_complete, eth, ethpad = 2;
-		int lro = !!(qs->netdev->features & NETIF_F_GRO);
+		int lro = netdev_feature_test_bit(NETIF_F_GRO_BIT,
+						  qs->netdev->features);
 		struct sk_buff *skb = NULL;
 		u32 len, flags;
 		__be32 rss_hi, rss_lo;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
index 33b2c0c45509..a10ee671514b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
@@ -79,10 +79,10 @@ int cxgb_fcoe_enable(struct net_device *netdev)
 
 	dev_info(adap->pdev_dev, "Enabling FCoE offload features\n");
 
-	netdev->features |= NETIF_F_FCOE_CRC;
-	netdev->vlan_features |= NETIF_F_FCOE_CRC;
-	netdev->features |= NETIF_F_FCOE_MTU;
-	netdev->vlan_features |= NETIF_F_FCOE_MTU;
+	netdev_feature_set_bit(NETIF_F_FCOE_CRC_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_FCOE_CRC_BIT, &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_FCOE_MTU_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_FCOE_MTU_BIT, &netdev->vlan_features);
 
 	netdev_features_change(netdev);
 
@@ -110,10 +110,10 @@ int cxgb_fcoe_disable(struct net_device *netdev)
 
 	fcoe->flags &= ~CXGB_FCOE_ENABLED;
 
-	netdev->features &= ~NETIF_F_FCOE_CRC;
-	netdev->vlan_features &= ~NETIF_F_FCOE_CRC;
-	netdev->features &= ~NETIF_F_FCOE_MTU;
-	netdev->vlan_features &= ~NETIF_F_FCOE_MTU;
+	netdev_feature_clear_bit(NETIF_F_FCOE_CRC_BIT, &netdev->features);
+	netdev_feature_clear_bit(NETIF_F_FCOE_CRC_BIT, &netdev->vlan_features);
+	netdev_feature_clear_bit(NETIF_F_FCOE_MTU_BIT, &netdev->features);
+	netdev_feature_clear_bit(NETIF_F_FCOE_MTU_BIT, &netdev->vlan_features);
 
 	netdev_features_change(netdev);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 238416724a7c..26c550ae6dd0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -513,7 +513,8 @@ static int link_start(struct net_device *dev)
 	 */
 	ret = t4_set_rxmode(pi->adapter, mb, pi->viid, pi->viid_mirror,
 			    dev->mtu, -1, -1, -1,
-			    !!(dev->features & NETIF_F_HW_VLAN_CTAG_RX), true);
+			    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						    dev->features), true);
 	if (ret == 0)
 		ret = cxgb4_update_mac_filt(pi, pi->viid, &pi->xact_addr_filt,
 					    dev->dev_addr, true, &pi->smt_idx);
@@ -1272,18 +1273,24 @@ int cxgb4_set_rspq_intr_params(struct sge_rspq *q,
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
 	const struct port_info *pi = netdev_priv(dev);
+	netdev_features_t changed;
 	int err;
 
-	if (!(changed & NETIF_F_HW_VLAN_CTAG_RX))
+	netdev_feature_xor(&changed, dev->features, features);
+	if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		return 0;
 
 	err = t4_set_rxmode(pi->adapter, pi->adapter->mbox, pi->viid,
 			    pi->viid_mirror, -1, -1, -1, -1,
-			    !!(features & NETIF_F_HW_VLAN_CTAG_RX), true);
-	if (unlikely(err))
-		dev->features = features ^ NETIF_F_HW_VLAN_CTAG_RX;
+			    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						    features), true);
+	if (unlikely(err)) {
+		netdev_feature_copy(&dev->features, features);
+		netdev_feature_change_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					  &dev->features);
+	}
+
 	return err;
 }
 
@@ -1460,7 +1467,8 @@ static int cxgb4_port_mirror_start(struct net_device *dev)
 	ret = t4_set_rxmode(adap, adap->mbox, pi->viid, pi->viid_mirror,
 			    dev->mtu, (dev->flags & IFF_PROMISC) ? 1 : 0,
 			    (dev->flags & IFF_ALLMULTI) ? 1 : 0, 1,
-			    !!(dev->features & NETIF_F_HW_VLAN_CTAG_RX), true);
+			    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						    dev->features), true);
 	if (ret) {
 		dev_err(adap->pdev_dev,
 			"Failed start up Rx mode for Mirror VI 0x%x, ret: %d\n",
@@ -3848,15 +3856,16 @@ static void cxgb_features_check(struct sk_buff *skb, struct net_device *dev,
 		return;
 
 	/* Offload is not supported for this encapsulated packet */
-	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+				  features);
 }
 
 static void cxgb_fix_features(struct net_device *dev,
 			      netdev_features_t *features)
 {
 	/* Disable GRO, if RX_CSUM is disabled */
-	if (!(*features & NETIF_F_RXCSUM))
-		*features &= ~NETIF_F_GRO;
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_GRO_BIT, features);
 }
 
 static const struct net_device_ops cxgb4_netdev_ops = {
@@ -6816,35 +6825,41 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pi->port_id = i;
 		netdev->irq = pdev->irq;
 
-		netdev->hw_features = NETIF_F_SG | TSO_FLAGS |
+		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_set_bits(NETIF_F_SG | TSO_FLAGS |
 			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			NETIF_F_RXCSUM | NETIF_F_RXHASH | NETIF_F_GRO |
 			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_TC | NETIF_F_NTUPLE;
+			NETIF_F_HW_TC | NETIF_F_NTUPLE, &netdev->hw_features);
 
 		if (chip_ver > CHELSIO_T5) {
-			netdev->hw_enc_features |= NETIF_F_IP_CSUM |
-						   NETIF_F_IPV6_CSUM |
-						   NETIF_F_RXCSUM |
-						   NETIF_F_GSO_UDP_TUNNEL |
-						   NETIF_F_GSO_UDP_TUNNEL_CSUM |
-						   NETIF_F_TSO | NETIF_F_TSO6;
-
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-					       NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					       NETIF_F_HW_TLS_RECORD;
+			netdev_feature_set_bits(NETIF_F_IP_CSUM |
+						NETIF_F_IPV6_CSUM |
+						NETIF_F_RXCSUM |
+						NETIF_F_GSO_UDP_TUNNEL |
+						NETIF_F_GSO_UDP_TUNNEL_CSUM |
+						NETIF_F_TSO | NETIF_F_TSO6,
+						&netdev->hw_enc_features);
+			netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
+						NETIF_F_GSO_UDP_TUNNEL_CSUM |
+						NETIF_F_HW_TLS_RECORD,
+						&netdev->hw_features);
 
 			if (adapter->rawf_cnt)
 				netdev->udp_tunnel_nic_info = &cxgb_udp_tunnels;
 		}
 
 		if (highdma)
-			netdev->hw_features |= NETIF_F_HIGHDMA;
-		netdev->features |= netdev->hw_features;
-		netdev->vlan_features = netdev->features & VLAN_FEAT;
+			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+					       &netdev->hw_features);
+		netdev_feature_or(&netdev->features, netdev->features,
+				  netdev->hw_features);
+		netdev_feature_copy(&netdev->vlan_features, netdev->features);
+		netdev_feature_and_bits(VLAN_FEAT, &netdev->vlan_features);
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_TLS_HW) {
-			netdev->hw_features |= NETIF_F_HW_TLS_TX;
+			netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
+					       &netdev->hw_features);
 			netdev->tlsdev_ops = &cxgb4_ktls_ops;
 			/* initialize the refcount */
 			refcount_set(&pi->adapter->chcr_ktls.ktls_refcount, 0);
@@ -6852,8 +6867,10 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif /* CONFIG_CHELSIO_TLS_DEVICE */
 #if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
 		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_IPSEC_INLINE) {
-			netdev->hw_enc_features |= NETIF_F_HW_ESP;
-			netdev->features |= NETIF_F_HW_ESP;
+			netdev_feature_set_bit(NETIF_F_HW_ESP_BIT,
+					       &netdev->hw_enc_features);
+			netdev_feature_set_bit(NETIF_F_HW_ESP_BIT,
+					       &netdev->features);
 			netdev->xfrmdev_ops = &cxgb4_xfrmdev_ops;
 		}
 #endif /* CONFIG_CHELSIO_IPSEC_INLINE */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h
index 70a07b7cca56..bcaa07591eab 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h
@@ -41,7 +41,8 @@ static inline bool can_tc_u32_offload(struct net_device *dev)
 {
 	struct adapter *adap = netdev2adap(dev);
 
-	return (dev->features & NETIF_F_HW_TC) && adap->tc_u32 ? true : false;
+	return netdev_feature_test_bit(NETIF_F_HW_TC_BIT, dev->features) &&
+		adap->tc_u32 ? true : false;
 }
 
 int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index fa5b596ff23a..002d74d1ddc3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -3466,7 +3466,8 @@ static void do_gro(struct sge_eth_rxq *rxq, const struct pkt_gl *gl,
 	if (pi->rxtstamp)
 		cxgb4_sgetim_to_hwtstamp(adapter, skb_hwtstamps(skb),
 					 gl->sgetstamp);
-	if (rxq->rspq.netdev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				    rxq->rspq.netdev->features))
 		skb_set_hash(skb, (__force u32)pkt->rsshdr.hash_val,
 			     PKT_HASH_TYPE_L3);
 
@@ -3708,7 +3709,8 @@ int t4_ethrx_handler(struct sge_rspq *q, const __be64 *rsp,
 	}
 
 	csum_ok = pkt->csum_calc && !err_vec &&
-		  (q->netdev->features & NETIF_F_RXCSUM);
+		  netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					  q->netdev->features);
 
 	if (err_vec)
 		rxq->stats.bad_rx_pkts++;
@@ -3719,9 +3721,9 @@ int t4_ethrx_handler(struct sge_rspq *q, const __be64 *rsp,
 			return 0;
 	}
 
-	if (((pkt->l2info & htonl(RXF_TCP_F)) ||
-	     tnl_hdr_len) &&
-	    (q->netdev->features & NETIF_F_GRO) && csum_ok && !pkt->ip_frag) {
+	if (((pkt->l2info & htonl(RXF_TCP_F)) || tnl_hdr_len) &&
+	    netdev_feature_test_bit(NETIF_F_GRO_BIT, q->netdev->features) &&
+	    csum_ok && !pkt->ip_frag) {
 		do_gro(rxq, si, pkt, tnl_hdr_len);
 		return 0;
 	}
@@ -3752,7 +3754,7 @@ int t4_ethrx_handler(struct sge_rspq *q, const __be64 *rsp,
 
 	skb->protocol = eth_type_trans(skb, q->netdev);
 	skb_record_rx_queue(skb, q->idx);
-	if (skb->dev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, skb->dev->features))
 		skb_set_hash(skb, (__force u32)pkt->rsshdr.hash_val,
 			     PKT_HASH_TYPE_L3);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 6d46d460a0a1..772b513b6ba1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1180,21 +1180,24 @@ static void cxgb4vf_fix_features(struct net_device *dev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
-		*features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
-		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					 features);
 }
 
 static int cxgb4vf_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct port_info *pi = netdev_priv(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	netdev_feature_xor(&changed, dev->features, features);
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		t4vf_set_rxmode(pi->adapter, pi->viid, -1, -1, -1, -1,
-				features & NETIF_F_HW_VLAN_CTAG_TX, 0);
+				netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+							features), 0);
 
 	return 0;
 }
@@ -3069,13 +3072,19 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 		pi->xact_addr_filt = -1;
 		netdev->irq = pdev->irq;
 
-		netdev->hw_features = NETIF_F_SG | TSO_FLAGS | NETIF_F_GRO |
-			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-		netdev->features = netdev->hw_features;
+		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_set_bits(NETIF_F_SG | TSO_FLAGS | NETIF_F_GRO |
+					NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+					NETIF_F_RXCSUM |
+					NETIF_F_HW_VLAN_CTAG_TX |
+					NETIF_F_HW_VLAN_CTAG_RX,
+					&netdev->hw_features);
+		netdev_feature_copy(&netdev->features, netdev->hw_features);
 		if (pci_using_dac)
-			netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features = netdev->features & VLAN_FEAT;
+			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+					       &netdev->features);
+		netdev_feature_copy(&netdev->vlan_features, netdev->features);
+		netdev_feature_and_bits(VLAN_FEAT, &netdev->vlan_features);
 
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 		netdev->min_mtu = 81;
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 0295b2406646..ffa3cd2ebef0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -1617,7 +1617,8 @@ int t4vf_ethrx_handler(struct sge_rspq *rspq, const __be64 *rsp,
 	struct sk_buff *skb;
 	const struct cpl_rx_pkt *pkt = (void *)rsp;
 	bool csum_ok = pkt->csum_calc && !pkt->err_vec &&
-		       (rspq->netdev->features & NETIF_F_RXCSUM);
+		       netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					       rspq->netdev->features);
 	struct sge_eth_rxq *rxq = container_of(rspq, struct sge_eth_rxq, rspq);
 	struct adapter *adapter = rspq->adapter;
 	struct sge *s = &adapter->sge;
@@ -1628,8 +1629,9 @@ int t4vf_ethrx_handler(struct sge_rspq *rspq, const __be64 *rsp,
 	 * enabled, handle the packet in the GRO path.
 	 */
 	if ((pkt->l2info & cpu_to_be32(RXF_TCP_F)) &&
-	    (rspq->netdev->features & NETIF_F_GRO) && csum_ok &&
-	    !pkt->ip_frag) {
+	    netdev_feature_test_bit(NETIF_F_GRO_BIT,
+				    rspq->netdev->features) &&
+	    csum_ok && !pkt->ip_frag) {
 		do_gro(rxq, gl, pkt);
 		return 0;
 	}
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
index 9098b3eed4da..d879cf91cf7b 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
@@ -135,7 +135,8 @@ static int chtls_inline_feature(struct tls_toe_device *dev)
 
 	for (i = 0; i < cdev->lldi->nports; i++) {
 		netdev = cdev->ports[i];
-		if (netdev->features & NETIF_F_HW_TLS_RECORD)
+		if (netdev_feature_test_bit(NETIF_F_HW_TLS_RECORD_BIT,
+					    netdev->features))
 			return 1;
 	}
 	return 0;
-- 
2.33.0

