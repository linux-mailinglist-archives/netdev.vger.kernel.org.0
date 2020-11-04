Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008652A6601
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbgKDOKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730269AbgKDOKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:10:00 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948EDC0613D3;
        Wed,  4 Nov 2020 06:10:00 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id e7so17332749pfn.12;
        Wed, 04 Nov 2020 06:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AZ6+rlXfznzQ0Lu5gqEZPCDs1i51ZdHtuCE0TSF7lhA=;
        b=l6Ouer1Y/gm/Kh1LS9X++/y6xrVq2XutHlo6VSqvFtmlZmvTUZYK8+U5BlEjBNRuT3
         7x2zepVrC7jVnZf/wU41IquHtHQwJEKNyf64ai/PHn+9gDR8ONdTUe2zbaDaJIbtTSHQ
         661KwlEofbHLKXOkLKtp/VFbP09AoIiKN9Cj2RS1kglyqzFiZV5g0aywB1wyIgPE4BZy
         j9EFBh8NAmw2dOYPBA42ZShjCHx4VQQhpXItwOGBkDsJ6rVfcZBtWXJy17FaeRiUODHL
         HNzWKaIwiu5Um5Hl5+Wa4CyZjHkEncrlfEezYcOpIervYyDsWc+hhF7jbRfo4TRII5RR
         V+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AZ6+rlXfznzQ0Lu5gqEZPCDs1i51ZdHtuCE0TSF7lhA=;
        b=m2stmXF0zUuvyf0qXWPfNLt5XhxcifDVZVfVFxdBULSus4hJk9ozpG3ZVVzHdOOQ69
         WglZRgSOWirJ9F1HaiVAOaycTYw6YwsWtGN5SpK/R9wUsFTSPsLoWa4eztTtTuEFsfMr
         MkUccSTC6HRRsJ+n6lTCQQ9URnkecQgCY2y8RU6nebnywIhud14PqMJALg9dB+cIyKSq
         ALWVrLS8KIEqU+v4+phTMGizbwufXxgyC/JG9W2/XuUTeTE/LDso1Rvv7e4rIRMrB/HS
         GUCCR4GAONpfZetSsoe+KohPF0T4c9XzN9OuT9T8lePatIEYFCKfCYQyrQ5eQNW8yBWe
         X/5A==
X-Gm-Message-State: AOAM533ztxsPX485Cuwp05Ruzm5oxUVjoLQRExhJaT6i8OLG8FtKk801
        Wzj4WYikRAYCLBGrTfvZPRs=
X-Google-Smtp-Source: ABdhPJzaXWWs5OxgXYSyx5QhVlu6J1XaDvscJDMSoQc6GvVNtGqXUgObfAuz/462z1S+pVAaAaVBWg==
X-Received: by 2002:a17:90a:5309:: with SMTP id x9mr4423708pjh.98.1604499000150;
        Wed, 04 Nov 2020 06:10:00 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q123sm2724818pfq.56.2020.11.04.06.09.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:09:59 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 6/6] i40e: use batched xsk Tx interfaces to increase performance
Date:   Wed,  4 Nov 2020 15:09:02 +0100
Message-Id: <1604498942-24274-7-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Use the new batched xsk interfaces for the Tx path in the i40e driver
to improve performance. On my machine, this yields a throughput
increase of 4% for the l2fwd sample app in xdpsock. If we instead just
look at the Tx part, this patch set increases throughput with above
20% for Tx.

Note that I had to explicitly loop unroll the inner loop to get to
this performance level, by using a pragma. It is honored by both clang
and gcc and should be ignored by versions that do not support
it. Using the -funroll-loops compiler command line switch on the
source file resulted in a loop unrolling on a higher level that
lead to a performance decrease instead of an increase.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c    |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    |  14 ++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c     | 127 ++++++++++++++++++-------
 5 files changed, 110 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 26ba1f3..dc34867 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2025,7 +2025,7 @@ static int i40e_set_ringparam(struct net_device *netdev,
 			 */
 			tx_rings[i].desc = NULL;
 			tx_rings[i].rx_bi = NULL;
-			err = i40e_setup_tx_descriptors(&tx_rings[i]);
+			err = i40e_setup_tx_descriptors(&tx_rings[i], false);
 			if (err) {
 				while (i) {
 					i--;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4f8a2154..c93774a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3030,13 +3030,13 @@ static int i40e_vsi_setup_tx_resources(struct i40e_vsi *vsi)
 	int i, err = 0;
 
 	for (i = 0; i < vsi->num_queue_pairs && !err; i++)
-		err = i40e_setup_tx_descriptors(vsi->tx_rings[i]);
+		err = i40e_setup_tx_descriptors(vsi->tx_rings[i], false);
 
 	if (!i40e_enabled_xdp_vsi(vsi))
 		return err;
 
 	for (i = 0; i < vsi->num_queue_pairs && !err; i++)
-		err = i40e_setup_tx_descriptors(vsi->xdp_rings[i]);
+		err = i40e_setup_tx_descriptors(vsi->xdp_rings[i], true);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index d43ce13..3e13e0e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -676,6 +676,8 @@ void i40e_free_tx_resources(struct i40e_ring *tx_ring)
 	i40e_clean_tx_ring(tx_ring);
 	kfree(tx_ring->tx_bi);
 	tx_ring->tx_bi = NULL;
+	kfree(tx_ring->xsk_descs);
+	tx_ring->xsk_descs = NULL;
 
 	if (tx_ring->desc) {
 		dma_free_coherent(tx_ring->dev, tx_ring->size,
@@ -1259,10 +1261,11 @@ void i40e_clean_programming_status(struct i40e_ring *rx_ring, u64 qword0_raw,
 /**
  * i40e_setup_tx_descriptors - Allocate the Tx descriptors
  * @tx_ring: the tx ring to set up
+ * @xdp_ring: true if this is an XDP Tx ring
  *
  * Return 0 on success, negative on error
  **/
-int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
+int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring, bool xdp_ring)
 {
 	struct device *dev = tx_ring->dev;
 	int bi_size;
@@ -1277,6 +1280,13 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
 	if (!tx_ring->tx_bi)
 		goto err;
 
+	if (xdp_ring) {
+		tx_ring->xsk_descs = kcalloc(I40E_MAX_NUM_DESCRIPTORS, sizeof(*tx_ring->xsk_descs),
+					     GFP_KERNEL);
+		if (!tx_ring->xsk_descs)
+			goto err;
+	}
+
 	u64_stats_init(&tx_ring->syncp);
 
 	/* round up to nearest 4K */
@@ -1300,6 +1310,8 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
 	return 0;
 
 err:
+	kfree(tx_ring->xsk_descs);
+	tx_ring->xsk_descs = NULL;
 	kfree(tx_ring->tx_bi);
 	tx_ring->tx_bi = NULL;
 	return -ENOMEM;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 2feed92..628d5d7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -389,6 +389,7 @@ struct i40e_ring {
 	struct i40e_channel *ch;
 	struct xdp_rxq_info xdp_rxq;
 	struct xsk_buff_pool *xsk_pool;
+	struct xdp_desc *xsk_descs;      /* For storing descriptors in the AF_XDP ZC path */
 } ____cacheline_internodealigned_in_smp;
 
 static inline bool ring_uses_build_skb(struct i40e_ring *ring)
@@ -451,7 +452,7 @@ bool i40e_alloc_rx_buffers(struct i40e_ring *rxr, u16 cleaned_count);
 netdev_tx_t i40e_lan_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
 void i40e_clean_tx_ring(struct i40e_ring *tx_ring);
 void i40e_clean_rx_ring(struct i40e_ring *rx_ring);
-int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring);
+int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring, bool xdp_ring);
 int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring);
 void i40e_free_tx_resources(struct i40e_ring *tx_ring);
 void i40e_free_rx_resources(struct i40e_ring *rx_ring);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index eabe1a3..515d856 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -383,6 +383,78 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	return failure ? budget : (int)total_rx_packets;
 }
 
+static void i40e_xmit_pkt(struct i40e_ring *xdp_ring, struct xdp_desc *desc,
+			  unsigned int *total_bytes)
+{
+	struct i40e_tx_desc *tx_desc;
+	dma_addr_t dma;
+
+	dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc->addr);
+	xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, desc->len);
+
+	tx_desc = I40E_TX_DESC(xdp_ring, xdp_ring->next_to_use++);
+	tx_desc->buffer_addr = cpu_to_le64(dma);
+	tx_desc->cmd_type_offset_bsz = build_ctob(I40E_TX_DESC_CMD_ICRC | I40E_TX_DESC_CMD_EOP,
+						  0, desc->len, 0);
+
+	*total_bytes += desc->len;
+}
+
+/* This value should match the pragma below. Why 4? It is strictly
+ * empirical. It seems to be a good compromise between the advantage
+ * of having simultaneous outstanding reads to the DMA array that can
+ * hide each others latency and the disadvantage of having a larger
+ * code path.
+ */
+#define PKTS_PER_BATCH 4
+
+static void i40e_xmit_pkt_batch(struct i40e_ring *xdp_ring, struct xdp_desc *desc,
+				unsigned int *total_bytes)
+{
+	u16 ntu = xdp_ring->next_to_use;
+	struct i40e_tx_desc *tx_desc;
+	dma_addr_t dma;
+	u32 i;
+
+#pragma GCC unroll 4
+	for (i = 0; i < PKTS_PER_BATCH; i++) {
+		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc[i].addr);
+		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, desc[i].len);
+
+		tx_desc = I40E_TX_DESC(xdp_ring, ntu++);
+		tx_desc->buffer_addr = cpu_to_le64(dma);
+		tx_desc->cmd_type_offset_bsz = build_ctob(I40E_TX_DESC_CMD_ICRC |
+							  I40E_TX_DESC_CMD_EOP,
+							  0, desc[i].len, 0);
+
+		*total_bytes += desc[i].len;
+	}
+
+	xdp_ring->next_to_use = ntu;
+}
+
+static void i40e_fill_tx_hw_ring(struct i40e_ring *xdp_ring, struct xdp_desc *descs, u32 nb_pkts,
+				 unsigned int *total_bytes)
+{
+	u32 batched, leftover, i;
+
+	batched = nb_pkts & ~(PKTS_PER_BATCH - 1);
+	leftover = nb_pkts & (PKTS_PER_BATCH - 1);
+	for (i = 0; i < batched; i += PKTS_PER_BATCH)
+		i40e_xmit_pkt_batch(xdp_ring, &descs[i], total_bytes);
+	for (i = batched; i < batched + leftover; i++)
+		i40e_xmit_pkt(xdp_ring, &descs[i], total_bytes);
+}
+
+static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
+{
+	u16 ntu = xdp_ring->next_to_use ? xdp_ring->next_to_use - 1 : xdp_ring->count - 1;
+	struct i40e_tx_desc *tx_desc;
+
+	tx_desc = I40E_TX_DESC(xdp_ring, ntu);
+	tx_desc->cmd_type_offset_bsz |= (I40E_TX_DESC_CMD_RS << I40E_TXD_QW1_CMD_SHIFT);
+}
+
 /**
  * i40e_xmit_zc - Performs zero-copy Tx AF_XDP
  * @xdp_ring: XDP Tx ring
@@ -392,45 +464,30 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
  **/
 static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 {
-	unsigned int sent_frames = 0, total_bytes = 0;
-	struct i40e_tx_desc *tx_desc = NULL;
-	struct xdp_desc desc;
-	dma_addr_t dma;
-
-	while (budget-- > 0) {
-		if (!xsk_tx_peek_desc(xdp_ring->xsk_pool, &desc))
-			break;
-
-		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc.addr);
-		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma,
-						 desc.len);
-
-		tx_desc = I40E_TX_DESC(xdp_ring, xdp_ring->next_to_use);
-		tx_desc->buffer_addr = cpu_to_le64(dma);
-		tx_desc->cmd_type_offset_bsz =
-			build_ctob(I40E_TX_DESC_CMD_ICRC
-				   | I40E_TX_DESC_CMD_EOP,
-				   0, desc.len, 0);
-
-		sent_frames++;
-		total_bytes += desc.len;
-
-		xdp_ring->next_to_use++;
-		if (xdp_ring->next_to_use == xdp_ring->count)
-			xdp_ring->next_to_use = 0;
+	struct xdp_desc *descs = xdp_ring->xsk_descs;
+	u32 nb_pkts, nb_processed = 0;
+	unsigned int total_bytes = 0;
+
+	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, descs, budget);
+	if (!nb_pkts)
+		return false;
+
+	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
+		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
+		i40e_fill_tx_hw_ring(xdp_ring, descs, nb_processed, &total_bytes);
+		xdp_ring->next_to_use = 0;
 	}
 
-	if (tx_desc) {
-		/* Request an interrupt for the last frame and bump tail ptr. */
-		tx_desc->cmd_type_offset_bsz |= (I40E_TX_DESC_CMD_RS <<
-						 I40E_TXD_QW1_CMD_SHIFT);
-		i40e_xdp_ring_update_tail(xdp_ring);
+	i40e_fill_tx_hw_ring(xdp_ring, &descs[nb_processed], nb_pkts - nb_processed,
+			     &total_bytes);
 
-		xsk_tx_release(xdp_ring->xsk_pool);
-		i40e_update_tx_stats(xdp_ring, sent_frames, total_bytes);
-	}
+	/* Request an interrupt for the last frame and bump tail ptr. */
+	i40e_set_rs_bit(xdp_ring);
+	i40e_xdp_ring_update_tail(xdp_ring);
+
+	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
 
-	return !!budget;
+	return true;
 }
 
 /**
-- 
2.7.4

