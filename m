Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D05EAF02
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfJaLhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:37:07 -0400
Received: from inva021.nxp.com ([92.121.34.21]:44198 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbfJaLhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:37:06 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 22702200501;
        Thu, 31 Oct 2019 12:37:05 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 15A282004F1;
        Thu, 31 Oct 2019 12:37:05 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D4D18205E9;
        Thu, 31 Oct 2019 12:37:04 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [net-next 03/13] dpaa_eth: perform DMA unmapping before read
Date:   Thu, 31 Oct 2019 13:36:49 +0200
Message-Id: <1572521819-10458-4-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1572521819-10458-1-git-send-email-madalin.bucur@nxp.com>
References: <1572521819-10458-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DMA unmapping is required before accessing the HW provided timestamping
information.

Fixes: 4664856e9ca2 ("dpaa_eth: add support for hardware timestamping")
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 32 ++++++++++++++------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 388d3ccb5fdb..efb4753f0723 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1591,18 +1591,6 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	skbh = (struct sk_buff **)phys_to_virt(addr);
 	skb = *skbh;
 
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
-
-		if (!fman_port_get_tstamp(priv->mac_dev->port[TX], (void *)skbh,
-					  &ns)) {
-			shhwtstamps.hwtstamp = ns_to_ktime(ns);
-			skb_tstamp_tx(skb, &shhwtstamps);
-		} else {
-			dev_warn(dev, "fman_port_get_tstamp failed!\n");
-		}
-	}
-
 	if (unlikely(qm_fd_get_format(fd) == qm_fd_sg)) {
 		nr_frags = skb_shinfo(skb)->nr_frags;
 		dma_unmap_single(priv->tx_dma_dev, addr,
@@ -1625,14 +1613,28 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 			dma_unmap_page(priv->tx_dma_dev, qm_sg_addr(&sgt[i]),
 				       qm_sg_entry_get_len(&sgt[i]), dma_dir);
 		}
-
-		/* Free the page frag that we allocated on Tx */
-		skb_free_frag(phys_to_virt(addr));
 	} else {
 		dma_unmap_single(priv->tx_dma_dev, addr,
 				 skb_tail_pointer(skb) - (u8 *)skbh, dma_dir);
 	}
 
+	/* DMA unmapping is required before accessing the HW provided info */
+	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+
+		if (!fman_port_get_tstamp(priv->mac_dev->port[TX], (void *)skbh,
+					  &ns)) {
+			shhwtstamps.hwtstamp = ns_to_ktime(ns);
+			skb_tstamp_tx(skb, &shhwtstamps);
+		} else {
+			dev_warn(dev, "fman_port_get_tstamp failed!\n");
+		}
+	}
+
+	if (qm_fd_get_format(fd) == qm_fd_sg)
+		/* Free the page frag that we allocated on Tx */
+		skb_free_frag(phys_to_virt(addr));
+
 	return skb;
 }
 
-- 
2.1.0

