Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB910EB2E9
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfJaOiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:38:16 -0400
Received: from inva021.nxp.com ([92.121.34.21]:35652 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbfJaOiO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 10:38:14 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 77B70200530;
        Thu, 31 Oct 2019 15:38:12 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6A7D5200527;
        Thu, 31 Oct 2019 15:38:12 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2529420605;
        Thu, 31 Oct 2019 15:38:12 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com, joe@perches.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [net-next v2 08/13] dpaa_eth: use a page to store the SGT
Date:   Thu, 31 Oct 2019 16:37:54 +0200
Message-Id: <1572532679-472-9-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1572532679-472-1-git-send-email-madalin.bucur@nxp.com>
References: <1572532679-472-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a page to store the scatter gather table on the transmit path.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 43 +++++++++++++-------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 1084bc1b1d34..ee22ed3207b4 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1592,9 +1592,9 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	int i;
 
 	if (unlikely(qm_fd_get_format(fd) == qm_fd_sg)) {
-		dma_unmap_single(priv->tx_dma_dev, addr,
-				 qm_fd_get_offset(fd) + DPAA_SGT_SIZE,
-				 dma_dir);
+		dma_unmap_page(priv->tx_dma_dev, addr,
+			       qm_fd_get_offset(fd) + DPAA_SGT_SIZE,
+			       dma_dir);
 
 		/* The sgt buffer has been allocated with netdev_alloc_frag(),
 		 * it's from lowmem.
@@ -1636,8 +1636,8 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	}
 
 	if (qm_fd_get_format(fd) == qm_fd_sg)
-		/* Free the page frag that we allocated on Tx */
-		skb_free_frag(vaddr);
+		/* Free the page that we allocated on Tx for the SGT */
+		free_pages((unsigned long)vaddr, 0);
 
 	return skb;
 }
@@ -1885,21 +1885,20 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	struct net_device *net_dev = priv->net_dev;
 	struct qm_sg_entry *sgt;
 	struct sk_buff **skbh;
-	int i, j, err, sz;
-	void *buffer_start;
+	void *buff_start;
 	skb_frag_t *frag;
 	dma_addr_t addr;
 	size_t frag_len;
-	void *sgt_buf;
-
-	/* get a page frag to store the SGTable */
-	sz = SKB_DATA_ALIGN(priv->tx_headroom + DPAA_SGT_SIZE);
-	sgt_buf = netdev_alloc_frag(sz);
-	if (unlikely(!sgt_buf)) {
-		netdev_err(net_dev, "netdev_alloc_frag() failed for size %d\n",
-			   sz);
+	struct page *p;
+	int i, j, err;
+
+	/* get a page to store the SGTable */
+	p = dev_alloc_pages(0);
+	if (unlikely(!p)) {
+		netdev_err(net_dev, "dev_alloc_pages() failed\n");
 		return -ENOMEM;
 	}
+	buff_start = page_address(p);
 
 	/* Enable L3/L4 hardware checksum computation.
 	 *
@@ -1907,7 +1906,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	 * need to write into the skb.
 	 */
 	err = dpaa_enable_tx_csum(priv, skb, fd,
-				  sgt_buf + DPAA_TX_PRIV_DATA_SIZE);
+				  buff_start + DPAA_TX_PRIV_DATA_SIZE);
 	if (unlikely(err < 0)) {
 		if (net_ratelimit())
 			netif_err(priv, tx_err, net_dev, "HW csum error: %d\n",
@@ -1916,7 +1915,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	}
 
 	/* SGT[0] is used by the linear part */
-	sgt = (struct qm_sg_entry *)(sgt_buf + priv->tx_headroom);
+	sgt = (struct qm_sg_entry *)(buff_start + priv->tx_headroom);
 	frag_len = skb_headlen(skb);
 	qm_sg_entry_set_len(&sgt[0], frag_len);
 	sgt[0].bpid = FSL_DPAA_BPID_INV;
@@ -1954,15 +1953,15 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	/* Set the final bit in the last used entry of the SGT */
 	qm_sg_entry_set_f(&sgt[nr_frags], frag_len);
 
+	/* set fd offset to priv->tx_headroom */
 	qm_fd_set_sg(fd, priv->tx_headroom, skb->len);
 
 	/* DMA map the SGT page */
-	buffer_start = (void *)sgt - priv->tx_headroom;
-	skbh = (struct sk_buff **)buffer_start;
+	skbh = (struct sk_buff **)buff_start;
 	*skbh = skb;
 
-	addr = dma_map_single(priv->tx_dma_dev, buffer_start,
-			      priv->tx_headroom + DPAA_SGT_SIZE, dma_dir);
+	addr = dma_map_page(priv->tx_dma_dev, p, 0,
+			    priv->tx_headroom + DPAA_SGT_SIZE, dma_dir);
 	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
 		netdev_err(priv->net_dev, "DMA mapping failed\n");
 		err = -EINVAL;
@@ -1982,7 +1981,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 			       qm_sg_entry_get_len(&sgt[j]), dma_dir);
 sg0_map_failed:
 csum_failed:
-	skb_free_frag(sgt_buf);
+	free_pages((unsigned long)buff_start, 0);
 
 	return err;
 }
-- 
2.1.0

