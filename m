Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC35EB2E6
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfJaOiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:38:12 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54818 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbfJaOiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 10:38:10 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CE12F1A0884;
        Thu, 31 Oct 2019 15:38:08 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C0D541A0556;
        Thu, 31 Oct 2019 15:38:08 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 81190205E9;
        Thu, 31 Oct 2019 15:38:08 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com, joe@perches.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [net-next v2 05/13] dpaa_eth: simplify variables used in dpaa_cleanup_tx_fd()
Date:   Thu, 31 Oct 2019 16:37:51 +0200
Message-Id: <1572532679-472-6-git-send-email-madalin.bucur@nxp.com>
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

Avoid casts and repeated conversions.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 75ade6a5599a..bde125a97f51 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1585,13 +1585,13 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	struct device *dev = priv->net_dev->dev.parent;
 	struct skb_shared_hwtstamps shhwtstamps;
 	dma_addr_t addr = qm_fd_addr(fd);
+	void *vaddr = phys_to_virt(addr);
 	const struct qm_sg_entry *sgt;
-	struct sk_buff **skbh, *skb;
+	struct sk_buff *skb;
 	int nr_frags, i;
 	u64 ns;
 
-	skbh = (struct sk_buff **)phys_to_virt(addr);
-	skb = *skbh;
+	skb = *(struct sk_buff **)vaddr;
 
 	if (unlikely(qm_fd_get_format(fd) == qm_fd_sg)) {
 		nr_frags = skb_shinfo(skb)->nr_frags;
@@ -1602,7 +1602,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 		/* The sgt buffer has been allocated with netdev_alloc_frag(),
 		 * it's from lowmem.
 		 */
-		sgt = phys_to_virt(addr + qm_fd_get_offset(fd));
+		sgt = vaddr + qm_fd_get_offset(fd);
 
 		/* sgt[0] is from lowmem, was dma_map_single()-ed */
 		dma_unmap_single(priv->tx_dma_dev, qm_sg_addr(&sgt[0]),
@@ -1617,7 +1617,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 		}
 	} else {
 		dma_unmap_single(priv->tx_dma_dev, addr,
-				 skb_tail_pointer(skb) - (u8 *)skbh, dma_dir);
+				 skb_tail_pointer(skb) - (u8 *)vaddr, dma_dir);
 	}
 
 	/* DMA unmapping is required before accessing the HW provided info */
@@ -1625,7 +1625,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 
-		if (!fman_port_get_tstamp(priv->mac_dev->port[TX], (void *)skbh,
+		if (!fman_port_get_tstamp(priv->mac_dev->port[TX], vaddr,
 					  &ns)) {
 			shhwtstamps.hwtstamp = ns_to_ktime(ns);
 			skb_tstamp_tx(skb, &shhwtstamps);
@@ -1636,7 +1636,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 
 	if (qm_fd_get_format(fd) == qm_fd_sg)
 		/* Free the page frag that we allocated on Tx */
-		skb_free_frag(phys_to_virt(addr));
+		skb_free_frag(vaddr);
 
 	return skb;
 }
-- 
2.1.0

