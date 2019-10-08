Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3077FCF970
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfJHMLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:11:41 -0400
Received: from inva021.nxp.com ([92.121.34.21]:40942 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731207AbfJHMLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 08:11:38 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B0A662002CF;
        Tue,  8 Oct 2019 14:11:36 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A27782002C9;
        Tue,  8 Oct 2019 14:11:36 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 61CCC205DB;
        Tue,  8 Oct 2019 14:11:36 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        linux-kernel@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH 20/20] dpaa_eth: cleanup skb_to_contig_fd()
Date:   Tue,  8 Oct 2019 15:10:41 +0300
Message-Id: <1570536641-25104-21-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove cast, align variable name, simplify DMA map size computation.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index c178f1b8c5e5..78651bb45cfe 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1382,7 +1382,7 @@ static void count_ern(struct dpaa_percpu_priv *percpu_priv,
 static int dpaa_enable_tx_csum(struct dpaa_priv *priv,
 			       struct sk_buff *skb,
 			       struct qm_fd *fd,
-			       char *parse_results)
+			       void *parse_results)
 {
 	struct fman_prs_result *parse_result;
 	u16 ethertype = ntohs(skb->protocol);
@@ -1836,7 +1836,7 @@ static int skb_to_contig_fd(struct dpaa_priv *priv,
 {
 	struct net_device *net_dev = priv->net_dev;
 	enum dma_data_direction dma_dir;
-	unsigned char *buffer_start;
+	unsigned char *buff_start;
 	struct sk_buff **skbh;
 	dma_addr_t addr;
 	int err;
@@ -1845,10 +1845,10 @@ static int skb_to_contig_fd(struct dpaa_priv *priv,
 	 * available, so just use that for offset.
 	 */
 	fd->bpid = FSL_DPAA_BPID_INV;
-	buffer_start = skb->data - priv->tx_headroom;
+	buff_start = skb->data - priv->tx_headroom;
 	dma_dir = DMA_TO_DEVICE;
 
-	skbh = (struct sk_buff **)buffer_start;
+	skbh = (struct sk_buff **)buff_start;
 	*skbh = skb;
 
 	/* Enable L3/L4 hardware checksum computation.
@@ -1857,7 +1857,7 @@ static int skb_to_contig_fd(struct dpaa_priv *priv,
 	 * need to write into the skb.
 	 */
 	err = dpaa_enable_tx_csum(priv, skb, fd,
-				  ((char *)skbh) + DPAA_TX_PRIV_DATA_SIZE);
+				  buff_start + DPAA_TX_PRIV_DATA_SIZE);
 	if (unlikely(err < 0)) {
 		if (net_ratelimit())
 			netif_err(priv, tx_err, net_dev, "HW csum error: %d\n",
@@ -1870,8 +1870,8 @@ static int skb_to_contig_fd(struct dpaa_priv *priv,
 	fd->cmd |= cpu_to_be32(FM_FD_CMD_FCO);
 
 	/* Map the entire buffer size that may be seen by FMan, but no more */
-	addr = dma_map_single(priv->tx_dma_dev, skbh,
-			      skb_tail_pointer(skb) - buffer_start, dma_dir);
+	addr = dma_map_single(priv->tx_dma_dev, buff_start,
+			      priv->tx_headroom + skb->len, dma_dir);
 	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
 		if (net_ratelimit())
 			netif_err(priv, tx_err, net_dev, "dma_map_single() failed\n");
-- 
2.1.0

