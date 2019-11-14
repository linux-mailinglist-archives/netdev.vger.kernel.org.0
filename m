Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3744EFBDBE
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 02:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfKNB4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 20:56:04 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:25028 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKNB4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 20:56:03 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Nov 2019 20:56:02 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573696561;
        s=strato-dkim-0002; d=fpond.eu;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=uMxTUaPwVAs5izf1xPwlCKfIu4we8J5Vz/qHtiy15RQ=;
        b=ZBrV0WHlpYlEdwABcCM0cp2N/rpjARO1ikiMOfoBhrXH04bSjp376ioKAC8efFfToZ
        +pClSVK5AIz3SmjhMPa79A1EBmxVscvLZUtvFfcaiZjnP6HgxeHQ54NGEqjNSAFeVpgk
        L18UxcLDlliUizpOHV5FrVimwmbBWwHXcyxNlOCRTAOHJDiQngCwkJyHNMQ0Oi2F+xMo
        mDir255vPzidfoLGTrZ1G7f7he/ksjqjXhnFqWJL0h+NmLekXQIO2S8Ck6ocXGsDBH3j
        cRFwtcHY3Hp/5WU4h81MixU88izQOiWgpI7VKQs/AobP/6CaBO/VdMgL42zRUztZ5fiH
        LGIg==
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvJ7600n36gyr98zhBjcZ0="
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
        by smtp.strato.de (RZmta 44.29.0 SBL|AUTH)
        with ESMTPSA id n0b4f3vAE1oBy8e
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 14 Nov 2019 02:50:11 +0100 (CET)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sergei.shtylyov@cogentembedded.com, niklas.soderlund@ragnatech.se,
        wsa@the-dreams.de, horms@verge.net.au, magnus.damm@gmail.com,
        geert@glider.be, Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH v4] ravb: implement MTU change while device is up
Date:   Thu, 14 Nov 2019 02:49:49 +0100
Message-Id: <20191114014949.31057-1-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pre-allocates buffers sufficient for the maximum supported MTU (2026) in
order to eliminate the possibility of resource exhaustion when changing the
MTU while the device is up.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
---
 drivers/net/ethernet/renesas/ravb.h      |  3 ++-
 drivers/net/ethernet/renesas/ravb_main.c | 26 +++++++++++++-----------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index a9c89d5d8898..9f88b5db4f89 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -955,6 +955,8 @@ enum RAVB_QUEUE {
 #define NUM_RX_QUEUE	2
 #define NUM_TX_QUEUE	2
 
+#define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
+
 /* TX descriptors per packet */
 #define NUM_TX_DESC_GEN2	2
 #define NUM_TX_DESC_GEN3	1
@@ -1018,7 +1020,6 @@ struct ravb_private {
 	u32 dirty_rx[NUM_RX_QUEUE];	/* Producer ring indices */
 	u32 cur_tx[NUM_TX_QUEUE];
 	u32 dirty_tx[NUM_TX_QUEUE];
-	u32 rx_buf_sz;			/* Based on MTU+slack. */
 	struct napi_struct napi[NUM_RX_QUEUE];
 	struct work_struct work;
 	/* MII transceiver section. */
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 5ea14b5fbed8..4b13a184bfc7 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -230,7 +230,7 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 					       le32_to_cpu(desc->dptr)))
 				dma_unmap_single(ndev->dev.parent,
 						 le32_to_cpu(desc->dptr),
-						 priv->rx_buf_sz,
+						 RX_BUF_SZ,
 						 DMA_FROM_DEVICE);
 		}
 		ring_size = sizeof(struct ravb_ex_rx_desc) *
@@ -293,9 +293,9 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
 		/* RX descriptor */
 		rx_desc = &priv->rx_ring[q][i];
-		rx_desc->ds_cc = cpu_to_le16(priv->rx_buf_sz);
+		rx_desc->ds_cc = cpu_to_le16(RX_BUF_SZ);
 		dma_addr = dma_map_single(ndev->dev.parent, priv->rx_skb[q][i]->data,
-					  priv->rx_buf_sz,
+					  RX_BUF_SZ,
 					  DMA_FROM_DEVICE);
 		/* We just set the data size to 0 for a failed mapping which
 		 * should prevent DMA from happening...
@@ -342,9 +342,6 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 	int ring_size;
 	int i;
 
-	priv->rx_buf_sz = (ndev->mtu <= 1492 ? PKT_BUF_SZ : ndev->mtu) +
-		ETH_HLEN + VLAN_HLEN + sizeof(__sum16);
-
 	/* Allocate RX and TX skb rings */
 	priv->rx_skb[q] = kcalloc(priv->num_rx_ring[q],
 				  sizeof(*priv->rx_skb[q]), GFP_KERNEL);
@@ -354,7 +351,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 		goto error;
 
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
-		skb = netdev_alloc_skb(ndev, priv->rx_buf_sz + RAVB_ALIGN - 1);
+		skb = netdev_alloc_skb(ndev, RX_BUF_SZ + RAVB_ALIGN - 1);
 		if (!skb)
 			goto error;
 		ravb_set_buffer_align(skb);
@@ -584,7 +581,7 @@ static bool ravb_rx(struct net_device *ndev, int *quota, int q)
 			skb = priv->rx_skb[q][entry];
 			priv->rx_skb[q][entry] = NULL;
 			dma_unmap_single(ndev->dev.parent, le32_to_cpu(desc->dptr),
-					 priv->rx_buf_sz,
+					 RX_BUF_SZ,
 					 DMA_FROM_DEVICE);
 			get_ts &= (q == RAVB_NC) ?
 					RAVB_RXTSTAMP_TYPE_V2_L2_EVENT :
@@ -617,11 +614,11 @@ static bool ravb_rx(struct net_device *ndev, int *quota, int q)
 	for (; priv->cur_rx[q] - priv->dirty_rx[q] > 0; priv->dirty_rx[q]++) {
 		entry = priv->dirty_rx[q] % priv->num_rx_ring[q];
 		desc = &priv->rx_ring[q][entry];
-		desc->ds_cc = cpu_to_le16(priv->rx_buf_sz);
+		desc->ds_cc = cpu_to_le16(RX_BUF_SZ);
 
 		if (!priv->rx_skb[q][entry]) {
 			skb = netdev_alloc_skb(ndev,
-					       priv->rx_buf_sz +
+					       RX_BUF_SZ +
 					       RAVB_ALIGN - 1);
 			if (!skb)
 				break;	/* Better luck next round. */
@@ -1801,10 +1798,15 @@ static int ravb_do_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 static int ravb_change_mtu(struct net_device *ndev, int new_mtu)
 {
-	if (netif_running(ndev))
-		return -EBUSY;
+	struct ravb_private *priv = netdev_priv(ndev);
 
 	ndev->mtu = new_mtu;
+
+	if (netif_running(ndev)) {
+		synchronize_irq(priv->emac_irq);
+		ravb_emac_init(ndev);
+	}
+
 	netdev_update_features(ndev);
 
 	return 0;
-- 
2.17.1

