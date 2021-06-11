Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FF93A4304
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 15:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhFKN3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 09:29:46 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37720 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhFKN3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 09:29:45 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 15BDRhsj053019;
        Fri, 11 Jun 2021 08:27:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623418063;
        bh=kCNd5UQ6OfFdSiYnFuwzAogCcAMzU3mcN6YcXGRBPyE=;
        h=From:To:CC:Subject:Date;
        b=uPfMM3BV83X7p9MeFtMHqSyVbyAMDm3SLK8BSqvosr2RJobHfFPSs6UQF80QqxVxt
         OMAnXBa7ti3VVa9k+uCh/lYijJvol9/a04qY824vNXUYEVhiZHG3m58q3jqLza1glO
         B+psAtWdujhrh1Ic59RPU2yq++CcyWQd0iklbAHQ=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 15BDRgYw023175
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Jun 2021 08:27:43 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 11
 Jun 2021 08:27:42 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 11 Jun 2021 08:27:42 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 15BDRf3h116489;
        Fri, 11 Jun 2021 08:27:41 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ben Hutchings <ben.hutchings@essensium.com>
CC:     <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Lokesh Vutla <lokeshvutla@ti.com>,
        <stable@vger.kernel.org>
Subject: [PATCH net] net: ethernet: ti: cpsw: fix min eth packet size for non-switch use-cases
Date:   Fri, 11 Jun 2021 16:27:32 +0300
Message-ID: <20210611132732.10690-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CPSW switchdev driver inherited fix from commit 9421c9015047 ("net:
ethernet: ti: cpsw: fix min eth packet size") which changes min TX packet
size to 64bytes (VLAN_ETH_ZLEN, excluding ETH_FCS). It was done to fix HW
packed drop issue when packets are sent from Host to the port with PVID and
un-tagging enabled. Unfortunately this breaks some other non-switch
specific use-cases, like:
- [1] CPSW port as DSA CPU port with DSA-tag applied at the end of the
packet
- [2] Some industrial protocols, which expects min TX packet size 60Bytes
(excluding FCS).

Fix it by configuring min TX packet size depending driver mode
 - 60Bytes (ETH_ZLEN) for multi mac (dual-mac) mode
 - 64Bytes (VLAN_ETH_ZLEN) for switch mode

[1] https://lore.kernel.org/netdev/20210531124051.GA15218@cephalopod/
[2] https://e2e.ti.com/support/arm/sitara_arm/f/791/t/701669

Cc: Ben Hutchings <ben.hutchings@essensium.com>
Cc: stable@vger.kernel.org
Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_new.c  | 12 +++++++++---
 drivers/net/ethernet/ti/cpsw_priv.h |  4 +++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 11f536138495..401909bff319 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -918,14 +918,17 @@ static netdev_tx_t cpsw_ndo_start_xmit(struct sk_buff *skb,
 	struct cpts *cpts = cpsw->cpts;
 	struct netdev_queue *txq;
 	struct cpdma_chan *txch;
+	unsigned int len;
 	int ret, q_idx;
 
-	if (skb_padto(skb, CPSW_MIN_PACKET_SIZE)) {
+	if (skb_padto(skb, priv->tx_packet_min)) {
 		cpsw_err(priv, tx_err, "packet pad failed\n");
 		ndev->stats.tx_dropped++;
 		return NET_XMIT_DROP;
 	}
 
+	len = skb->len < priv->tx_packet_min ? priv->tx_packet_min : skb->len;
+
 	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
 	    priv->tx_ts_enabled && cpts_can_timestamp(cpts, skb))
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
@@ -937,7 +940,7 @@ static netdev_tx_t cpsw_ndo_start_xmit(struct sk_buff *skb,
 	txch = cpsw->txv[q_idx].ch;
 	txq = netdev_get_tx_queue(ndev, q_idx);
 	skb_tx_timestamp(skb);
-	ret = cpdma_chan_submit(txch, skb, skb->data, skb->len,
+	ret = cpdma_chan_submit(txch, skb, skb->data, len,
 				priv->emac_port);
 	if (unlikely(ret != 0)) {
 		cpsw_err(priv, tx_err, "desc submit failed\n");
@@ -1100,7 +1103,7 @@ static int cpsw_ndo_xdp_xmit(struct net_device *ndev, int n,
 
 	for (i = 0; i < n; i++) {
 		xdpf = frames[i];
-		if (xdpf->len < CPSW_MIN_PACKET_SIZE)
+		if (xdpf->len < priv->tx_packet_min)
 			break;
 
 		if (cpsw_xdp_tx_frame(priv, xdpf, NULL, priv->emac_port))
@@ -1389,6 +1392,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		priv->dev  = dev;
 		priv->msg_enable = netif_msg_init(debug_level, CPSW_DEBUG);
 		priv->emac_port = i + 1;
+		priv->tx_packet_min = CPSW_MIN_PACKET_SIZE;
 
 		if (is_valid_ether_addr(slave_data->mac_addr)) {
 			ether_addr_copy(priv->mac_addr, slave_data->mac_addr);
@@ -1686,6 +1690,7 @@ static int cpsw_dl_switch_mode_set(struct devlink *dl, u32 id,
 
 			priv = netdev_priv(sl_ndev);
 			slave->port_vlan = vlan;
+			priv->tx_packet_min = CPSW_MIN_PACKET_SIZE_VLAN;
 			if (netif_running(sl_ndev))
 				cpsw_port_add_switch_def_ale_entries(priv,
 								     slave);
@@ -1714,6 +1719,7 @@ static int cpsw_dl_switch_mode_set(struct devlink *dl, u32 id,
 
 			priv = netdev_priv(slave->ndev);
 			slave->port_vlan = slave->data->dual_emac_res_vlan;
+			priv->tx_packet_min = CPSW_MIN_PACKET_SIZE;
 			cpsw_port_add_dual_emac_def_ale_entries(priv, slave);
 		}
 
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index a323bea54faa..2951fb7b9dae 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -89,7 +89,8 @@ do {								\
 
 #define CPSW_POLL_WEIGHT	64
 #define CPSW_RX_VLAN_ENCAP_HDR_SIZE		4
-#define CPSW_MIN_PACKET_SIZE	(VLAN_ETH_ZLEN)
+#define CPSW_MIN_PACKET_SIZE_VLAN	(VLAN_ETH_ZLEN)
+#define CPSW_MIN_PACKET_SIZE	(ETH_ZLEN)
 #define CPSW_MAX_PACKET_SIZE	(VLAN_ETH_FRAME_LEN +\
 				 ETH_FCS_LEN +\
 				 CPSW_RX_VLAN_ENCAP_HDR_SIZE)
@@ -380,6 +381,7 @@ struct cpsw_priv {
 	u32 emac_port;
 	struct cpsw_common *cpsw;
 	int offload_fwd_mark;
+	u32 tx_packet_min;
 };
 
 #define ndev_to_cpsw(ndev) (((struct cpsw_priv *)netdev_priv(ndev))->cpsw)
-- 
2.17.1

