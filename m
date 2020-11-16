Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C302B460D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbgKPOmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:42:40 -0500
Received: from inva021.nxp.com ([92.121.34.21]:54612 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729291AbgKPOmk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 09:42:40 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 42F19200D04;
        Mon, 16 Nov 2020 15:42:38 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 35986200C98;
        Mon, 16 Nov 2020 15:42:38 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CA997202AF;
        Mon, 16 Nov 2020 15:42:37 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, brouer@redhat.com, saeed@kernel.org,
        davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v2 1/7] dpaa_eth: add struct for software backpointers
Date:   Mon, 16 Nov 2020 16:42:27 +0200
Message-Id: <48efca21636905fc207be60d92b3db2901722be1.1605535745.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1605535745.git.camelia.groza@nxp.com>
References: <cover.1605535745.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1605535745.git.camelia.groza@nxp.com>
References: <cover.1605535745.git.camelia.groza@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We maintain an skb backpointer in the software annotations area of Tx
frames. Introduce a structure for explicit handling.

Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 16 +++++++++-------
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |  8 ++++++++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 8867693..88533a2 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1633,6 +1633,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	dma_addr_t addr = qm_fd_addr(fd);
 	void *vaddr = phys_to_virt(addr);
 	const struct qm_sg_entry *sgt;
+	struct dpaa_eth_swbp *swbp;
 	struct sk_buff *skb;
 	u64 ns;
 	int i;
@@ -1665,7 +1666,8 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 				 dma_dir);
 	}
 
-	skb = *(struct sk_buff **)vaddr;
+	swbp = (struct dpaa_eth_swbp *)vaddr;
+	skb = swbp->skb;
 
 	/* DMA unmapping is required before accessing the HW provided info */
 	if (ts && priv->tx_tstamp &&
@@ -1879,8 +1881,8 @@ static int skb_to_contig_fd(struct dpaa_priv *priv,
 {
 	struct net_device *net_dev = priv->net_dev;
 	enum dma_data_direction dma_dir;
+	struct dpaa_eth_swbp *swbp;
 	unsigned char *buff_start;
-	struct sk_buff **skbh;
 	dma_addr_t addr;
 	int err;
 
@@ -1891,8 +1893,8 @@ static int skb_to_contig_fd(struct dpaa_priv *priv,
 	buff_start = skb->data - priv->tx_headroom;
 	dma_dir = DMA_TO_DEVICE;
 
-	skbh = (struct sk_buff **)buff_start;
-	*skbh = skb;
+	swbp = (struct dpaa_eth_swbp *)buff_start;
+	swbp->skb = skb;
 
 	/* Enable L3/L4 hardware checksum computation.
 	 *
@@ -1931,8 +1933,8 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	const enum dma_data_direction dma_dir = DMA_TO_DEVICE;
 	const int nr_frags = skb_shinfo(skb)->nr_frags;
 	struct net_device *net_dev = priv->net_dev;
+	struct dpaa_eth_swbp *swbp;
 	struct qm_sg_entry *sgt;
-	struct sk_buff **skbh;
 	void *buff_start;
 	skb_frag_t *frag;
 	dma_addr_t addr;
@@ -2005,8 +2007,8 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	qm_fd_set_sg(fd, priv->tx_headroom, skb->len);
 
 	/* DMA map the SGT page */
-	skbh = (struct sk_buff **)buff_start;
-	*skbh = skb;
+	swbp = (struct dpaa_eth_swbp *)buff_start;
+	swbp->skb = skb;
 
 	addr = dma_map_page(priv->tx_dma_dev, p, 0,
 			    priv->tx_headroom + DPAA_SGT_SIZE, dma_dir);
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
index fc2cc4c..da30e5d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
@@ -144,6 +144,14 @@ struct dpaa_buffer_layout {
 	u16 priv_data_size;
 };
 
+/* Information to be used on the Tx confirmation path. Stored just
+ * before the start of the transmit buffer. Maximum size allowed
+ * is DPAA_TX_PRIV_DATA_SIZE bytes.
+ */
+struct dpaa_eth_swbp {
+	struct sk_buff *skb;
+};
+
 struct dpaa_priv {
 	struct dpaa_percpu_priv __percpu *percpu_priv;
 	struct dpaa_bp *dpaa_bp;
-- 
1.9.1

