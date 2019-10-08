Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8FCFCF989
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbfJHMLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:11:22 -0400
Received: from inva021.nxp.com ([92.121.34.21]:40764 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbfJHMLU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 08:11:20 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 63BF12002DE;
        Tue,  8 Oct 2019 14:11:18 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 54BA7200181;
        Tue,  8 Oct 2019 14:11:18 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 13ADA205DB;
        Tue,  8 Oct 2019 14:11:18 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        linux-kernel@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH 11/20] dpaa_eth: simplify variables used in dpaa_cleanup_tx_fd()
Date:   Tue,  8 Oct 2019 15:10:32 +0300
Message-Id: <1570536641-25104-12-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
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
index 14ebdb10fcd4..d4601e31261e 100644
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

