Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B0FCF98A
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731114AbfJHMLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:11:25 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54166 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731099AbfJHMLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 08:11:24 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D44221A0158;
        Tue,  8 Oct 2019 14:11:20 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C53621A002E;
        Tue,  8 Oct 2019 14:11:20 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 79183205DB;
        Tue,  8 Oct 2019 14:11:20 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        linux-kernel@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH 12/20] dpaa_eth: use fd information in dpaa_cleanup_tx_fd()
Date:   Tue,  8 Oct 2019 15:10:33 +0300
Message-Id: <1570536641-25104-13-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of reading skb fields, use information from the DPAA frame
descriptor.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index d4601e31261e..20f0062afdec 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1588,13 +1588,10 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	void *vaddr = phys_to_virt(addr);
 	const struct qm_sg_entry *sgt;
 	struct sk_buff *skb;
-	int nr_frags, i;
 	u64 ns;
-
-	skb = *(struct sk_buff **)vaddr;
+	int i;
 
 	if (unlikely(qm_fd_get_format(fd) == qm_fd_sg)) {
-		nr_frags = skb_shinfo(skb)->nr_frags;
 		dma_unmap_single(priv->tx_dma_dev, addr,
 				 qm_fd_get_offset(fd) + DPAA_SGT_SIZE,
 				 dma_dir);
@@ -1609,7 +1606,8 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 				 qm_sg_entry_get_len(&sgt[0]), dma_dir);
 
 		/* remaining pages were mapped with skb_frag_dma_map() */
-		for (i = 1; i <= nr_frags; i++) {
+		for (i = 1; (i < DPAA_SGT_MAX_ENTRIES) &&
+		     !qm_sg_entry_is_final(&sgt[i - 1]); i++) {
 			WARN_ON(qm_sg_entry_is_ext(&sgt[i]));
 
 			dma_unmap_page(priv->tx_dma_dev, qm_sg_addr(&sgt[i]),
@@ -1617,9 +1615,12 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 		}
 	} else {
 		dma_unmap_single(priv->tx_dma_dev, addr,
-				 skb_tail_pointer(skb) - (u8 *)vaddr, dma_dir);
+				 priv->tx_headroom + qm_fd_get_length(fd),
+				 dma_dir);
 	}
 
+	skb = *(struct sk_buff **)vaddr;
+
 	/* DMA unmapping is required before accessing the HW provided info */
 	if (ts && priv->tx_tstamp &&
 	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-- 
2.1.0

