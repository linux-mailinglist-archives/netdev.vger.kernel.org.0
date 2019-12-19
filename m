Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E7F126447
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 15:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLSOIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 09:08:53 -0500
Received: from inva021.nxp.com ([92.121.34.21]:57870 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbfLSOIx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 09:08:53 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CDA5F20041B;
        Thu, 19 Dec 2019 15:08:51 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C086C200414;
        Thu, 19 Dec 2019 15:08:51 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8BF9B203C8;
        Thu, 19 Dec 2019 15:08:51 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH] dpaa_eth: fix DMA mapping leak
Date:   Thu, 19 Dec 2019 16:08:48 +0200
Message-Id: <1576764528-10742-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

On the error path some fragments remain DMA mapped. Adding a fix
that unmaps all the fragments.

Fixes: 8151ee88bad56 (dpaa_eth: use page backed rx buffers)
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 6a9d12dad5d9..ff9e9a2637e7 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1719,7 +1719,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 	int page_offset;
 	unsigned int sz;
 	int *count_ptr;
-	int i;
+	int i, j;
 
 	vaddr = phys_to_virt(addr);
 	WARN_ON(!IS_ALIGNED((unsigned long)vaddr, SMP_CACHE_BYTES));
@@ -1727,7 +1727,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 	/* Iterate through the SGT entries and add data buffers to the skb */
 	sgt = vaddr + fd_off;
 	skb = NULL;
-	for (i = 0; i < DPAA_SGT_MAX_ENTRIES; i++) {
+	for (i = 0, j = 0; i < DPAA_SGT_MAX_ENTRIES; i++) {
 		/* Extension bit is not supported */
 		WARN_ON(qm_sg_entry_is_ext(&sgt[i]));
 
@@ -1744,6 +1744,9 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 		count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
 		dma_unmap_page(priv->rx_dma_dev, sg_addr,
 			       DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
+
+		j++; /* fragments up to j were DMA unmapped */
+
 		if (!skb) {
 			sz = dpaa_bp->size +
 				SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
@@ -1812,6 +1815,9 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 	for (i = 0; i < DPAA_SGT_MAX_ENTRIES ; i++) {
 		sg_addr = qm_sg_addr(&sgt[i]);
 		sg_vaddr = phys_to_virt(sg_addr);
+		if (i >= j)
+			dma_unmap_page(priv->rx_dma_dev, qm_sg_addr(&sgt[i]),
+				       DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
 		free_pages((unsigned long)sg_vaddr, 0);
 		dpaa_bp = dpaa_bpid2pool(sgt[i].bpid);
 		if (dpaa_bp) {
-- 
2.1.0

