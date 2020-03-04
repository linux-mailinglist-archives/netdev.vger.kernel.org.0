Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D265A179462
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbgCDQEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:04:39 -0500
Received: from inva021.nxp.com ([92.121.34.21]:60326 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729898AbgCDQEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 11:04:38 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AB48920021D;
        Wed,  4 Mar 2020 17:04:36 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9BF5A2001FC;
        Wed,  4 Mar 2020 17:04:36 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1F836202D2;
        Wed,  4 Mar 2020 17:04:36 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        shawnguo@kernel.org, leoyang.li@nxp.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net v2 4/4] dpaa_eth: FMan erratum A050385 workaround
Date:   Wed,  4 Mar 2020 18:04:28 +0200
Message-Id: <1583337868-3320-5-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1583337868-3320-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1583337868-3320-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

Align buffers, data start, SG fragment length to avoid DMA splits.
These changes prevent the A050385 erratum to manifest itself:

FMAN DMA read or writes under heavy traffic load may cause FMAN
internal resource leak; thus stopping further packet processing.

The FMAN internal queue can overflow when FMAN splits single
read or write transactions into multiple smaller transactions
such that more than 17 AXI transactions are in flight from FMAN
to interconnect. When the FMAN internal queue overflows, it can
stall further packet processing. The issue can occur with any one
of the following three conditions:

  1. FMAN AXI transaction crosses 4K address boundary (Errata
	 A010022)
  2. FMAN DMA address for an AXI transaction is not 16 byte
	 aligned, i.e. the last 4 bits of an address are non-zero
  3. Scatter Gather (SG) frames have more than one SG buffer in
	 the SG list and any one of the buffers, except the last
	 buffer in the SG list has data size that is not a multiple
	 of 16 bytes, i.e., other than 16, 32, 48, 64, etc.

With any one of the above three conditions present, there is
likelihood of stalled FMAN packet processing, especially under
stress with multiple ports injecting line-rate traffic.

To avoid situations that stall FMAN packet processing, all of the
above three conditions must be avoided; therefore, configure the
system with the following rules:

  1. Frame buffers must not span a 4KB address boundary, unless
	 the frame start address is 256 byte aligned
  2. All FMAN DMA start addresses (for example, BMAN buffer
	 address, FD[address] + FD[offset]) are 16B aligned
  3. SG table and buffer addresses are 16B aligned and the size
	 of SG buffers are multiple of 16 bytes, except for the last
	 SG buffer that can be of any size.

Additional workaround notes:
- Address alignment of 64 bytes is recommended for maximally
efficient system bus transactions (although 16 byte alignment is
sufficient to avoid the stall condition)
- To support frame sizes that are larger than 4K bytes, there are
two options:
  1. Large single buffer frames that span a 4KB page boundary can
	 be converted into SG frames to avoid transaction splits at
	 the 4KB boundary,
  2. Align the large single buffer to 256B address boundaries,
	 ensure that the frame address plus offset is 256B aligned.
- If software generated SG frames have buffers that are unaligned
and with random non-multiple of 16 byte lengths, before
transmitting such frames via FMAN, frames will need to be copied
into a new single buffer or multiple buffer SG frame that is
compliant with the three rules listed above.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---

Changes in v2:
 - used CONFIG_DPAA_ERRATUM_A050385
 - removed unnecessary parenthesis
 - changed alignment defines to use only decimal values

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 110 ++++++++++++++++++++++++-
 1 file changed, 107 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index fd93d542f497..e3ac9ec54c7c 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1,4 +1,5 @@
 /* Copyright 2008 - 2016 Freescale Semiconductor Inc.
+ * Copyright 2020 NXP
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
@@ -123,7 +124,22 @@ MODULE_PARM_DESC(tx_timeout, "The Tx timeout in ms");
 #define FSL_QMAN_MAX_OAL	127
 
 /* Default alignment for start of data in an Rx FD */
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+/* aligning data start to 64 avoids DMA transaction splits, unless the buffer
+ * is crossing a 4k page boundary
+ */
+#define DPAA_FD_DATA_ALIGNMENT  (fman_has_errata_a050385() ? 64 : 16)
+/* aligning to 256 avoids DMA transaction splits caused by 4k page boundary
+ * crossings; also, all SG fragments except the last must have a size multiple
+ * of 256 to avoid DMA transaction splits
+ */
+#define DPAA_A050385_ALIGN 256
+#define DPAA_FD_RX_DATA_ALIGNMENT (fman_has_errata_a050385() ? \
+				   DPAA_A050385_ALIGN : 16)
+#else
 #define DPAA_FD_DATA_ALIGNMENT  16
+#define DPAA_FD_RX_DATA_ALIGNMENT DPAA_FD_DATA_ALIGNMENT
+#endif
 
 /* The DPAA requires 256 bytes reserved and mapped for the SGT */
 #define DPAA_SGT_SIZE 256
@@ -158,8 +174,13 @@ MODULE_PARM_DESC(tx_timeout, "The Tx timeout in ms");
 #define DPAA_PARSE_RESULTS_SIZE sizeof(struct fman_prs_result)
 #define DPAA_TIME_STAMP_SIZE 8
 #define DPAA_HASH_RESULTS_SIZE 8
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+#define DPAA_RX_PRIV_DATA_SIZE (DPAA_A050385_ALIGN - (DPAA_PARSE_RESULTS_SIZE\
+	 + DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE))
+#else
 #define DPAA_RX_PRIV_DATA_SIZE	(u16)(DPAA_TX_PRIV_DATA_SIZE + \
 					dpaa_rx_extra_headroom)
+#endif
 
 #define DPAA_ETH_PCD_RXQ_NUM	128
 
@@ -180,7 +201,12 @@ static struct dpaa_bp *dpaa_bp_array[BM_MAX_NUM_OF_POOLS];
 
 #define DPAA_BP_RAW_SIZE 4096
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+#define dpaa_bp_size(raw_size) (SKB_WITH_OVERHEAD(raw_size) & \
+				~(DPAA_A050385_ALIGN - 1))
+#else
 #define dpaa_bp_size(raw_size) SKB_WITH_OVERHEAD(raw_size)
+#endif
 
 static int dpaa_max_frm;
 
@@ -1192,7 +1218,7 @@ static int dpaa_eth_init_rx_port(struct fman_port *port, struct dpaa_bp *bp,
 	buf_prefix_content.pass_prs_result = true;
 	buf_prefix_content.pass_hash_result = true;
 	buf_prefix_content.pass_time_stamp = true;
-	buf_prefix_content.data_align = DPAA_FD_DATA_ALIGNMENT;
+	buf_prefix_content.data_align = DPAA_FD_RX_DATA_ALIGNMENT;
 
 	rx_p = &params.specific_params.rx_params;
 	rx_p->err_fqid = errq->fqid;
@@ -1662,6 +1688,8 @@ static u8 rx_csum_offload(const struct dpaa_priv *priv, const struct qm_fd *fd)
 	return CHECKSUM_NONE;
 }
 
+#define PTR_IS_ALIGNED(x, a) (IS_ALIGNED((unsigned long)(x), (a)))
+
 /* Build a linear skb around the received buffer.
  * We are guaranteed there is enough room at the end of the data buffer to
  * accommodate the shared info area of the skb.
@@ -1733,8 +1761,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 
 		sg_addr = qm_sg_addr(&sgt[i]);
 		sg_vaddr = phys_to_virt(sg_addr);
-		WARN_ON(!IS_ALIGNED((unsigned long)sg_vaddr,
-				    SMP_CACHE_BYTES));
+		WARN_ON(!PTR_IS_ALIGNED(sg_vaddr, SMP_CACHE_BYTES));
 
 		dma_unmap_page(priv->rx_dma_dev, sg_addr,
 			       DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
@@ -2022,6 +2049,75 @@ static inline int dpaa_xmit(struct dpaa_priv *priv,
 	return 0;
 }
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+int dpaa_a050385_wa(struct net_device *net_dev, struct sk_buff **s)
+{
+	struct dpaa_priv *priv = netdev_priv(net_dev);
+	struct sk_buff *new_skb, *skb = *s;
+	unsigned char *start, i;
+
+	/* check linear buffer alignment */
+	if (!PTR_IS_ALIGNED(skb->data, DPAA_A050385_ALIGN))
+		goto workaround;
+
+	/* linear buffers just need to have an aligned start */
+	if (!skb_is_nonlinear(skb))
+		return 0;
+
+	/* linear data size for nonlinear skbs needs to be aligned */
+	if (!IS_ALIGNED(skb_headlen(skb), DPAA_A050385_ALIGN))
+		goto workaround;
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+
+		/* all fragments need to have aligned start addresses */
+		if (!IS_ALIGNED(skb_frag_off(frag), DPAA_A050385_ALIGN))
+			goto workaround;
+
+		/* all but last fragment need to have aligned sizes */
+		if (!IS_ALIGNED(skb_frag_size(frag), DPAA_A050385_ALIGN) &&
+		    (i < skb_shinfo(skb)->nr_frags - 1))
+			goto workaround;
+	}
+
+	return 0;
+
+workaround:
+	/* copy all the skb content into a new linear buffer */
+	new_skb = netdev_alloc_skb(net_dev, skb->len + DPAA_A050385_ALIGN - 1 +
+						priv->tx_headroom);
+	if (!new_skb)
+		return -ENOMEM;
+
+	/* NET_SKB_PAD bytes already reserved, adding up to tx_headroom */
+	skb_reserve(new_skb, priv->tx_headroom - NET_SKB_PAD);
+
+	/* Workaround for DPAA_A050385 requires data start to be aligned */
+	start = PTR_ALIGN(new_skb->data, DPAA_A050385_ALIGN);
+	if (start - new_skb->data != 0)
+		skb_reserve(new_skb, start - new_skb->data);
+
+	skb_put(new_skb, skb->len);
+	skb_copy_bits(skb, 0, new_skb->data, skb->len);
+	skb_copy_header(new_skb, skb);
+	new_skb->dev = skb->dev;
+
+	/* We move the headroom when we align it so we have to reset the
+	 * network and transport header offsets relative to the new data
+	 * pointer. The checksum offload relies on these offsets.
+	 */
+	skb_set_network_header(new_skb, skb_network_offset(skb));
+	skb_set_transport_header(new_skb, skb_transport_offset(skb));
+
+	/* TODO: does timestamping need the result in the old skb? */
+	dev_kfree_skb(skb);
+	*s = new_skb;
+
+	return 0;
+}
+#endif
+
 static netdev_tx_t
 dpaa_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 {
@@ -2068,6 +2164,14 @@ dpaa_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 		nonlinear = skb_is_nonlinear(skb);
 	}
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+	if (unlikely(fman_has_errata_a050385())) {
+		if (dpaa_a050385_wa(net_dev, &skb))
+			goto enomem;
+		nonlinear = skb_is_nonlinear(skb);
+	}
+#endif
+
 	if (nonlinear) {
 		/* Just create a S/G fd based on the skb */
 		err = skb_to_sg_fd(priv, skb, &fd);
-- 
2.1.0

