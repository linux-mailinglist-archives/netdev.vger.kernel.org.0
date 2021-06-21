Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8853AEA5F
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFUNwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhFUNwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:52:17 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DC5C061574;
        Mon, 21 Jun 2021 06:50:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m15-20020a17090a5a4fb029016f385ffad0so42017pji.0;
        Mon, 21 Jun 2021 06:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OBrCHO0tuZVBJieIjRNRGhNU8OnoyFF5mjeTtNd26b8=;
        b=vcKZB8lc1DNNmTfHst0H4rvRBalfqu649rA+GhCF9+y4ZRT7DQua3DTfN/uDo9a6tn
         QUY5Uj0Pg4C4Dn83hm3pwKGwXKfZaR1zioXqBIaLmAPLrts9VzN0X8+NFEpw0S8ntleQ
         5t6ftWepnzN1qAAFdFI+64by8DCUt9kLMjhL5RHwiUDB1M02Ma2oeizSZk4pLxvKLT/v
         Y1ay1g6u0S0I4bVc3SKKrauUDlbBxXsIKTtuzEcsGQCMv2Wu/0mYcCUnU9SDGt13YYxj
         tFTbiltK+00hM/ISqZjHbimox6y6lrbCb1+8rBWLl/nIDv0sXt4i/pFwBiotzgeMgsj8
         e2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OBrCHO0tuZVBJieIjRNRGhNU8OnoyFF5mjeTtNd26b8=;
        b=j+NyjGCVM6GLz3kD6fVwqNbsP7l0eb7MJTa5wzV/C7lndqjEEwXkYcx9qhYXvi8e/n
         D5bn+lcGYvePVrjRyzmUL81QH7v0DxQnaWbTAX9ZDLyErVcNTehyEdsYhny8XnOeSkPq
         i6dCGWelbTCE6KMM5zcPUxNma/Kj7w2IYkgduevcEoCsvR17Co07rWKEwiCbu59hwiKT
         icSzdKbDoJFyz5J67TDwHNFqxsWRStTKewHNWr7KMoq0b9LNpjTqT9j6bFhXqmu6gs46
         jsKqyzgoaCmUmQ4Eehqv/hm7AMg4lu1zc0ICYbejsNztfabLOevdWNnJmtQF/GNpa4z8
         WZLw==
X-Gm-Message-State: AOAM5320eOAElZTS9l0MSUj2Vf3ww6eNlBgx+MwAEj6G8YutKrelaNUm
        A+3ku64HkLpsZKVXzQlT26I=
X-Google-Smtp-Source: ABdhPJxy3fT+wgDw89imJJu6L0T2FoaHlXyfZ/p+a2aqXn4UKILxfcz5lzLvVKXisq3D04tcz6E1ng==
X-Received: by 2002:a17:902:8c87:b029:11d:6f72:78aa with SMTP id t7-20020a1709028c87b029011d6f7278aamr18254523plo.12.1624283401263;
        Mon, 21 Jun 2021 06:50:01 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i6sm4279390pjg.31.2021.06.21.06.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:50:00 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 05/19] staging: qlge: rename rx to completion queue and seperate rx_ring from completion queue
Date:   Mon, 21 Jun 2021 21:48:48 +0800
Message-Id: <20210621134902.83587-6-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses the following TODO items,
> * rename "rx" queues to "completion" queues. Calling tx completion queues "rx
>   queues" is confusing.
> * struct rx_ring is used for rx and tx completions, with some members relevant
>   to one case only

The first part of the completion queue (index range: [0, qdev->rss_ring_count))
is for inbound completions and the remaining part (index range:
[qdev->rss_ring_count, qdev->cq_count)) is for outbound completions.

Note the structure filed name and reserved is unused, remove it to
reduce holes.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO           |   4 -
 drivers/staging/qlge/qlge.h         |  30 +--
 drivers/staging/qlge/qlge_dbg.c     |   6 +-
 drivers/staging/qlge/qlge_ethtool.c |  24 +--
 drivers/staging/qlge/qlge_main.c    | 291 +++++++++++++++-------------
 5 files changed, 188 insertions(+), 167 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index 49cb09fc2be4..b7a60425fcd2 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -4,10 +4,6 @@
   ql_build_rx_skb(). That function is now used exclusively to handle packets
   that underwent header splitting but it still contains code to handle non
   split cases.
-* rename "rx" queues to "completion" queues. Calling tx completion queues "rx
-  queues" is confusing.
-* struct rx_ring is used for rx and tx completions, with some members relevant
-  to one case only
 * the flow control implementation in firmware is buggy (sends a flood of pause
   frames, resets the link, device and driver buffer queues become
   desynchronized), disable it by default
diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 09d5878b95f7..926af25b14fa 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -1456,15 +1456,15 @@ struct qlge_bq {
 		     (_bq)->next_to_clean); \
 })
 
-struct qlge_rx_ring {
+struct qlge_cq {
 	struct cqicb cqicb;	/* The chip's completion queue init control block. */
 
 	/* Completion queue elements. */
+	u16 cq_id;
 	void *cq_base;
 	dma_addr_t cq_base_dma;
 	u32 cq_size;
 	u32 cq_len;
-	u16 cq_id;
 	__le32 *prod_idx_sh_reg;	/* Shadowed producer register. */
 	dma_addr_t prod_idx_sh_reg_dma;
 	void __iomem *cnsmr_idx_db_reg;	/* PCI doorbell mem area + 0 */
@@ -1472,6 +1472,13 @@ struct qlge_rx_ring {
 	struct qlge_net_rsp_iocb *curr_entry;	/* next entry on queue */
 	void __iomem *valid_db_reg;	/* PCI doorbell mem area + 0x04 */
 
+	/* Misc. handler elements. */
+	u32 irq;		/* Which vector this ring is assigned. */
+	u32 cpu;		/* Which CPU this should run on. */
+	struct qlge_adapter *qdev;
+};
+
+struct qlge_rx_ring {
 	/* Large buffer queue elements. */
 	struct qlge_bq lbq;
 	struct qlge_page_chunk master_chunk;
@@ -1480,19 +1487,15 @@ struct qlge_rx_ring {
 	/* Small buffer queue elements. */
 	struct qlge_bq sbq;
 
-	/* Misc. handler elements. */
-	u32 irq;		/* Which vector this ring is assigned. */
-	u32 cpu;		/* Which CPU this should run on. */
-	struct delayed_work refill_work;
-	char name[IFNAMSIZ + 5];
 	struct napi_struct napi;
-	u8 reserved;
-	struct qlge_adapter *qdev;
+	struct delayed_work refill_work;
 	u64 rx_packets;
 	u64 rx_multicast;
 	u64 rx_bytes;
 	u64 rx_dropped;
 	u64 rx_errors;
+	struct qlge_adapter *qdev;
+	u16 cq_id;
 };
 
 /*
@@ -1753,7 +1756,7 @@ enum {
 #define SHADOW_REG_SHIFT	20
 
 struct qlge_nic_misc {
-	u32 rx_ring_count;
+	u32 cq_count;
 	u32 tx_ring_count;
 	u32 intr_count;
 	u32 function;
@@ -2127,14 +2130,15 @@ struct qlge_adapter {
 	int tx_ring_count;	/* One per online CPU. */
 	u32 rss_ring_count;	/* One per irq vector.  */
 	/*
-	 * rx_ring_count =
+	 * cq_count =
 	 *  (CPU count * outbound completion rx_ring) +
 	 *  (irq_vector_cnt * inbound (RSS) completion rx_ring)
 	 */
-	int rx_ring_count;
+	int cq_count;
 	int ring_mem_size;
 	void *ring_mem;
 
+	struct qlge_cq cq[MAX_RX_RINGS];
 	struct qlge_rx_ring rx_ring[MAX_RX_RINGS];
 	struct qlge_tx_ring tx_ring[MAX_TX_RINGS];
 	unsigned int lbq_buf_order;
@@ -2287,6 +2291,6 @@ void qlge_get_dump(struct qlge_adapter *qdev, void *buff);
 netdev_tx_t qlge_lb_send(struct sk_buff *skb, struct net_device *ndev);
 void qlge_check_lb_frame(struct qlge_adapter *qdev, struct sk_buff *skb);
 int qlge_own_firmware(struct qlge_adapter *qdev);
-int qlge_clean_lb_rx_ring(struct qlge_rx_ring *rx_ring, int budget);
+int qlge_clean_lb_cq(struct qlge_cq *cq, int budget);
 
 #endif /* _QLGE_H_ */
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 37e593f0fd82..d093e6c9f19c 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -403,7 +403,7 @@ static void qlge_get_intr_states(struct qlge_adapter *qdev, u32 *buf)
 {
 	int i;
 
-	for (i = 0; i < qdev->rx_ring_count; i++, buf++) {
+	for (i = 0; i < qdev->cq_count; i++, buf++) {
 		qlge_write32(qdev, INTR_EN,
 			     qdev->intr_context[i].intr_read_mask);
 		*buf = qlge_read32(qdev, INTR_EN);
@@ -1074,7 +1074,7 @@ int qlge_core_dump(struct qlge_adapter *qdev, struct qlge_mpi_coredump *mpi_core
 				       sizeof(struct mpi_coredump_segment_header)
 				       + sizeof(mpi_coredump->misc_nic_info),
 				       "MISC NIC INFO");
-	mpi_coredump->misc_nic_info.rx_ring_count = qdev->rx_ring_count;
+	mpi_coredump->misc_nic_info.cq_count = qdev->cq_count;
 	mpi_coredump->misc_nic_info.tx_ring_count = qdev->tx_ring_count;
 	mpi_coredump->misc_nic_info.intr_count = qdev->intr_count;
 	mpi_coredump->misc_nic_info.function = qdev->func;
@@ -1237,7 +1237,7 @@ static void qlge_gen_reg_dump(struct qlge_adapter *qdev,
 				       sizeof(struct mpi_coredump_segment_header)
 				       + sizeof(mpi_coredump->misc_nic_info),
 				       "MISC NIC INFO");
-	mpi_coredump->misc_nic_info.rx_ring_count = qdev->rx_ring_count;
+	mpi_coredump->misc_nic_info.cq_count = qdev->cq_count;
 	mpi_coredump->misc_nic_info.tx_ring_count = qdev->tx_ring_count;
 	mpi_coredump->misc_nic_info.intr_count = qdev->intr_count;
 	mpi_coredump->misc_nic_info.function = qdev->func;
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index 22c27b97a908..7f77f99cc047 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -186,7 +186,7 @@ static const char qlge_gstrings_test[][ETH_GSTRING_LEN] = {
 static int qlge_update_ring_coalescing(struct qlge_adapter *qdev)
 {
 	int i, status = 0;
-	struct qlge_rx_ring *rx_ring;
+	struct qlge_cq *cq;
 	struct cqicb *cqicb;
 
 	if (!netif_running(qdev->ndev))
@@ -195,18 +195,18 @@ static int qlge_update_ring_coalescing(struct qlge_adapter *qdev)
 	/* Skip the default queue, and update the outbound handler
 	 * queues if they changed.
 	 */
-	cqicb = (struct cqicb *)&qdev->rx_ring[qdev->rss_ring_count];
+	cqicb = (struct cqicb *)&qdev->cq[qdev->rss_ring_count];
 	if (le16_to_cpu(cqicb->irq_delay) != qdev->tx_coalesce_usecs ||
 	    le16_to_cpu(cqicb->pkt_delay) != qdev->tx_max_coalesced_frames) {
-		for (i = qdev->rss_ring_count; i < qdev->rx_ring_count; i++) {
-			rx_ring = &qdev->rx_ring[i];
-			cqicb = (struct cqicb *)rx_ring;
+		for (i = qdev->rss_ring_count; i < qdev->cq_count; i++) {
+			cq = &qdev->cq[i];
+			cqicb = (struct cqicb *)cq;
 			cqicb->irq_delay = cpu_to_le16(qdev->tx_coalesce_usecs);
 			cqicb->pkt_delay =
 				cpu_to_le16(qdev->tx_max_coalesced_frames);
 			cqicb->flags = FLAGS_LI;
 			status = qlge_write_cfg(qdev, cqicb, sizeof(*cqicb),
-						CFG_LCQ, rx_ring->cq_id);
+						CFG_LCQ, cq->cq_id);
 			if (status) {
 				netif_err(qdev, ifup, qdev->ndev,
 					  "Failed to load CQICB.\n");
@@ -216,18 +216,18 @@ static int qlge_update_ring_coalescing(struct qlge_adapter *qdev)
 	}
 
 	/* Update the inbound (RSS) handler queues if they changed. */
-	cqicb = (struct cqicb *)&qdev->rx_ring[0];
+	cqicb = (struct cqicb *)&qdev->cq[0];
 	if (le16_to_cpu(cqicb->irq_delay) != qdev->rx_coalesce_usecs ||
 	    le16_to_cpu(cqicb->pkt_delay) != qdev->rx_max_coalesced_frames) {
-		for (i = 0; i < qdev->rss_ring_count; i++, rx_ring++) {
-			rx_ring = &qdev->rx_ring[i];
-			cqicb = (struct cqicb *)rx_ring;
+		for (i = 0; i < qdev->rss_ring_count; i++, cq++) {
+			cq = &qdev->cq[i];
+			cqicb = (struct cqicb *)cq;
 			cqicb->irq_delay = cpu_to_le16(qdev->rx_coalesce_usecs);
 			cqicb->pkt_delay =
 				cpu_to_le16(qdev->rx_max_coalesced_frames);
 			cqicb->flags = FLAGS_LI;
 			status = qlge_write_cfg(qdev, cqicb, sizeof(*cqicb),
-						CFG_LCQ, rx_ring->cq_id);
+						CFG_LCQ, cq->cq_id);
 			if (status) {
 				netif_err(qdev, ifup, qdev->ndev,
 					  "Failed to load CQICB.\n");
@@ -554,7 +554,7 @@ static int qlge_run_loopback_test(struct qlge_adapter *qdev)
 	}
 	/* Give queue time to settle before testing results. */
 	msleep(2);
-	qlge_clean_lb_rx_ring(&qdev->rx_ring[0], 128);
+	qlge_clean_lb_cq(&qdev->cq[0], 128);
 	return atomic_read(&qdev->lb_count) ? -EIO : 0;
 }
 
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 77c71ae698ab..94853b182608 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -982,19 +982,19 @@ static struct qlge_bq_desc *qlge_get_curr_lchunk(struct qlge_adapter *qdev,
 }
 
 /* Update an rx ring index. */
-static void qlge_update_cq(struct qlge_rx_ring *rx_ring)
+static void qlge_update_cq(struct qlge_cq *cq)
 {
-	rx_ring->cnsmr_idx++;
-	rx_ring->curr_entry++;
-	if (unlikely(rx_ring->cnsmr_idx == rx_ring->cq_len)) {
-		rx_ring->cnsmr_idx = 0;
-		rx_ring->curr_entry = rx_ring->cq_base;
+	cq->cnsmr_idx++;
+	cq->curr_entry++;
+	if (unlikely(cq->cnsmr_idx == cq->cq_len)) {
+		cq->cnsmr_idx = 0;
+		cq->curr_entry = cq->cq_base;
 	}
 }
 
-static void qlge_write_cq_idx(struct qlge_rx_ring *rx_ring)
+static void qlge_write_cq_idx(struct qlge_cq *cq)
 {
-	qlge_write_db_reg(rx_ring->cnsmr_idx, rx_ring->cnsmr_idx_db_reg);
+	qlge_write_db_reg(cq->cnsmr_idx, cq->cnsmr_idx_db_reg);
 }
 
 static const char * const bq_type_name[] = {
@@ -2087,21 +2087,21 @@ static void qlge_process_chip_ae_intr(struct qlge_adapter *qdev,
 	}
 }
 
-static int qlge_clean_outbound_rx_ring(struct qlge_rx_ring *rx_ring)
+static int qlge_clean_outbound_cq(struct qlge_cq *cq)
 {
-	struct qlge_adapter *qdev = rx_ring->qdev;
-	u32 prod = qlge_read_sh_reg(rx_ring->prod_idx_sh_reg);
+	struct qlge_adapter *qdev = cq->qdev;
+	u32 prod = qlge_read_sh_reg(cq->prod_idx_sh_reg);
 	struct qlge_ob_mac_iocb_rsp *net_rsp = NULL;
 	int count = 0;
 
 	struct qlge_tx_ring *tx_ring;
 	/* While there are entries in the completion queue. */
-	while (prod != rx_ring->cnsmr_idx) {
+	while (prod != cq->cnsmr_idx) {
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 			     "cq_id = %d, prod = %d, cnsmr = %d\n",
-			     rx_ring->cq_id, prod, rx_ring->cnsmr_idx);
+			     cq->cq_id, prod, cq->cnsmr_idx);
 
-		net_rsp = (struct qlge_ob_mac_iocb_rsp *)rx_ring->curr_entry;
+		net_rsp = (struct qlge_ob_mac_iocb_rsp *)cq->curr_entry;
 		rmb();
 		switch (net_rsp->opcode) {
 		case OPCODE_OB_MAC_TSO_IOCB:
@@ -2114,12 +2114,12 @@ static int qlge_clean_outbound_rx_ring(struct qlge_rx_ring *rx_ring)
 				     net_rsp->opcode);
 		}
 		count++;
-		qlge_update_cq(rx_ring);
-		prod = qlge_read_sh_reg(rx_ring->prod_idx_sh_reg);
+		qlge_update_cq(cq);
+		prod = qlge_read_sh_reg(cq->prod_idx_sh_reg);
 	}
 	if (!net_rsp)
 		return 0;
-	qlge_write_cq_idx(rx_ring);
+	qlge_write_cq_idx(cq);
 	tx_ring = &qdev->tx_ring[net_rsp->txq_idx];
 	if (__netif_subqueue_stopped(qdev->ndev, tx_ring->wq_id)) {
 		if ((atomic_read(&tx_ring->tx_count) > (tx_ring->wq_len / 4)))
@@ -2133,20 +2133,21 @@ static int qlge_clean_outbound_rx_ring(struct qlge_rx_ring *rx_ring)
 	return count;
 }
 
-static int qlge_clean_inbound_rx_ring(struct qlge_rx_ring *rx_ring, int budget)
+static int qlge_clean_inbound_cq(struct qlge_cq *cq, int budget)
 {
-	struct qlge_adapter *qdev = rx_ring->qdev;
-	u32 prod = qlge_read_sh_reg(rx_ring->prod_idx_sh_reg);
+	struct qlge_adapter *qdev = cq->qdev;
+	u32 prod = qlge_read_sh_reg(cq->prod_idx_sh_reg);
+	struct qlge_rx_ring *rx_ring = &qdev->rx_ring[cq->cq_id];
 	struct qlge_net_rsp_iocb *net_rsp;
 	int count = 0;
 
 	/* While there are entries in the completion queue. */
-	while (prod != rx_ring->cnsmr_idx) {
+	while (prod != cq->cnsmr_idx) {
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 			     "cq_id = %d, prod = %d, cnsmr = %d\n",
-			     rx_ring->cq_id, prod, rx_ring->cnsmr_idx);
+			     cq->cq_id, prod, cq->cnsmr_idx);
 
-		net_rsp = rx_ring->curr_entry;
+		net_rsp = cq->curr_entry;
 		rmb();
 		switch (net_rsp->opcode) {
 		case OPCODE_IB_MAC_IOCB:
@@ -2166,13 +2167,13 @@ static int qlge_clean_inbound_rx_ring(struct qlge_rx_ring *rx_ring, int budget)
 			break;
 		}
 		count++;
-		qlge_update_cq(rx_ring);
-		prod = qlge_read_sh_reg(rx_ring->prod_idx_sh_reg);
+		qlge_update_cq(cq);
+		prod = qlge_read_sh_reg(cq->prod_idx_sh_reg);
 		if (count == budget)
 			break;
 	}
 	qlge_update_buffer_queues(rx_ring, GFP_ATOMIC, 0);
-	qlge_write_cq_idx(rx_ring);
+	qlge_write_cq_idx(cq);
 	return count;
 }
 
@@ -2180,45 +2181,46 @@ static int qlge_napi_poll_msix(struct napi_struct *napi, int budget)
 {
 	struct qlge_rx_ring *rx_ring = container_of(napi, struct qlge_rx_ring, napi);
 	struct qlge_adapter *qdev = rx_ring->qdev;
-	struct qlge_rx_ring *trx_ring;
+	struct qlge_cq *tcq, *rcq;
 	int i, work_done = 0;
 	struct intr_context *ctx = &qdev->intr_context[rx_ring->cq_id];
 
+	rcq =  &qdev->cq[rx_ring->cq_id];
+
 	netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 		     "Enter, NAPI POLL cq_id = %d.\n", rx_ring->cq_id);
 
 	/* Service the TX rings first.  They start
 	 * right after the RSS rings.
 	 */
-	for (i = qdev->rss_ring_count; i < qdev->rx_ring_count; i++) {
-		trx_ring = &qdev->rx_ring[i];
+	for (i = qdev->rss_ring_count; i < qdev->cq_count; i++) {
+		tcq = &qdev->cq[i];
 		/* If this TX completion ring belongs to this vector and
 		 * it's not empty then service it.
 		 */
-		if ((ctx->irq_mask & (1 << trx_ring->cq_id)) &&
-		    (qlge_read_sh_reg(trx_ring->prod_idx_sh_reg) !=
-		     trx_ring->cnsmr_idx)) {
+		if ((ctx->irq_mask & (1 << tcq->cq_id)) &&
+		    (qlge_read_sh_reg(tcq->prod_idx_sh_reg) !=
+		     tcq->cnsmr_idx)) {
 			netif_printk(qdev, intr, KERN_DEBUG, qdev->ndev,
 				     "%s: Servicing TX completion ring %d.\n",
-				     __func__, trx_ring->cq_id);
-			qlge_clean_outbound_rx_ring(trx_ring);
+				     __func__, tcq->cq_id);
+			qlge_clean_outbound_cq(tcq);
 		}
 	}
 
 	/*
 	 * Now service the RSS ring if it's active.
 	 */
-	if (qlge_read_sh_reg(rx_ring->prod_idx_sh_reg) !=
-	    rx_ring->cnsmr_idx) {
+	if (qlge_read_sh_reg(rcq->prod_idx_sh_reg) != rcq->cnsmr_idx) {
 		netif_printk(qdev, intr, KERN_DEBUG, qdev->ndev,
 			     "%s: Servicing RX completion ring %d.\n",
-			     __func__, rx_ring->cq_id);
-		work_done = qlge_clean_inbound_rx_ring(rx_ring, budget);
+			     __func__, rcq->cq_id);
+		work_done = qlge_clean_inbound_cq(rcq, budget);
 	}
 
 	if (work_done < budget) {
 		napi_complete_done(napi, work_done);
-		qlge_enable_completion_interrupt(qdev, rx_ring->irq);
+		qlge_enable_completion_interrupt(qdev, rcq->irq);
 	}
 	return work_done;
 }
@@ -2368,8 +2370,10 @@ static void qlge_restore_vlan(struct qlge_adapter *qdev)
 /* MSI-X Multiple Vector Interrupt Handler for inbound completions. */
 static irqreturn_t qlge_msix_rx_isr(int irq, void *dev_id)
 {
-	struct qlge_rx_ring *rx_ring = dev_id;
+	struct qlge_cq *cq = dev_id;
+	struct qlge_rx_ring *rx_ring;
 
+	rx_ring = &cq->qdev->rx_ring[cq->cq_id];
 	napi_schedule(&rx_ring->napi);
 	return IRQ_HANDLED;
 }
@@ -2381,11 +2385,16 @@ static irqreturn_t qlge_msix_rx_isr(int irq, void *dev_id)
  */
 static irqreturn_t qlge_isr(int irq, void *dev_id)
 {
-	struct qlge_rx_ring *rx_ring = dev_id;
-	struct qlge_adapter *qdev = rx_ring->qdev;
-	struct intr_context *intr_context = &qdev->intr_context[0];
-	u32 var;
+	struct intr_context *intr_context;
+	struct qlge_rx_ring *rx_ring;
+	struct qlge_cq *cq = dev_id;
+	struct qlge_adapter *qdev;
 	int work_done = 0;
+	u32 var;
+
+	qdev = cq->qdev;
+	rx_ring = &qdev->rx_ring[cq->cq_id];
+	intr_context = &qdev->intr_context[0];
 
 	/* Experience shows that when using INTx interrupts, interrupts must
 	 * be masked manually.
@@ -2767,7 +2776,7 @@ static void qlge_free_rx_buffers(struct qlge_adapter *qdev)
 {
 	int i;
 
-	for (i = 0; i < qdev->rx_ring_count; i++) {
+	for (i = 0; i < qdev->rss_ring_count; i++) {
 		struct qlge_rx_ring *rx_ring = &qdev->rx_ring[i];
 
 		if (rx_ring->lbq.queue)
@@ -2815,9 +2824,12 @@ static int qlge_init_bq(struct qlge_bq *bq)
 	return 0;
 }
 
-static void qlge_free_rx_resources(struct qlge_adapter *qdev,
-				   struct qlge_rx_ring *rx_ring)
+static void qlge_free_cq_resources(struct qlge_adapter *qdev,
+				   struct qlge_cq *cq)
 {
+	struct qlge_rx_ring *rx_ring;
+
+	rx_ring = &qdev->rx_ring[cq->cq_id];
 	/* Free the small buffer queue. */
 	if (rx_ring->sbq.base) {
 		dma_free_coherent(&qdev->pdev->dev, QLGE_BQ_SIZE,
@@ -2836,40 +2848,43 @@ static void qlge_free_rx_resources(struct qlge_adapter *qdev,
 		rx_ring->lbq.base = NULL;
 	}
 
+	rx_ring = &qdev->rx_ring[cq->cq_id];
 	/* Free the large buffer queue control blocks. */
 	kfree(rx_ring->lbq.queue);
 	rx_ring->lbq.queue = NULL;
 
-	/* Free the rx queue. */
-	if (rx_ring->cq_base) {
+	/* Free the completion queue. */
+	if (cq->cq_base) {
 		dma_free_coherent(&qdev->pdev->dev,
-				  rx_ring->cq_size,
-				  rx_ring->cq_base, rx_ring->cq_base_dma);
-		rx_ring->cq_base = NULL;
+				  cq->cq_size,
+				  cq->cq_base, cq->cq_base_dma);
+		cq->cq_base = NULL;
 	}
 }
 
 /* Allocate queues and buffers for this completions queue based
  * on the values in the parameter structure.
  */
-static int qlge_alloc_rx_resources(struct qlge_adapter *qdev,
-				   struct qlge_rx_ring *rx_ring)
+static int qlge_alloc_cq_resources(struct qlge_adapter *qdev,
+				   struct qlge_cq *cq)
 {
+	struct qlge_rx_ring *rx_ring;
 	/*
 	 * Allocate the completion queue for this rx_ring.
 	 */
-	rx_ring->cq_base =
-		dma_alloc_coherent(&qdev->pdev->dev, rx_ring->cq_size,
-				   &rx_ring->cq_base_dma, GFP_ATOMIC);
+	cq->cq_base =
+		dma_alloc_coherent(&qdev->pdev->dev, cq->cq_size,
+				   &cq->cq_base_dma, GFP_ATOMIC);
 
-	if (!rx_ring->cq_base) {
-		netif_err(qdev, ifup, qdev->ndev, "rx_ring alloc failed.\n");
+	if (!cq->cq_base) {
+		netif_err(qdev, ifup, qdev->ndev, "cq alloc failed.\n");
 		return -ENOMEM;
 	}
 
-	if (rx_ring->cq_id < qdev->rss_ring_count &&
+	rx_ring = &qdev->rx_ring[cq->cq_id];
+	if (cq->cq_id < qdev->rss_ring_count &&
 	    (qlge_init_bq(&rx_ring->sbq) || qlge_init_bq(&rx_ring->lbq))) {
-		qlge_free_rx_resources(qdev, rx_ring);
+		qlge_free_cq_resources(qdev, cq);
 		return -ENOMEM;
 	}
 
@@ -2910,8 +2925,8 @@ static void qlge_free_mem_resources(struct qlge_adapter *qdev)
 
 	for (i = 0; i < qdev->tx_ring_count; i++)
 		qlge_free_tx_resources(qdev, &qdev->tx_ring[i]);
-	for (i = 0; i < qdev->rx_ring_count; i++)
-		qlge_free_rx_resources(qdev, &qdev->rx_ring[i]);
+	for (i = 0; i < qdev->cq_count; i++)
+		qlge_free_cq_resources(qdev, &qdev->cq[i]);
 	qlge_free_shadow_space(qdev);
 }
 
@@ -2923,8 +2938,8 @@ static int qlge_alloc_mem_resources(struct qlge_adapter *qdev)
 	if (qlge_alloc_shadow_space(qdev))
 		return -ENOMEM;
 
-	for (i = 0; i < qdev->rx_ring_count; i++) {
-		if (qlge_alloc_rx_resources(qdev, &qdev->rx_ring[i]) != 0) {
+	for (i = 0; i < qdev->cq_count; i++) {
+		if (qlge_alloc_cq_resources(qdev, &qdev->cq[i]) != 0) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "RX resource allocation failed.\n");
 			goto err_mem;
@@ -2949,56 +2964,43 @@ static int qlge_alloc_mem_resources(struct qlge_adapter *qdev)
  * The control block is defined as
  * "Completion Queue Initialization Control Block", or cqicb.
  */
-static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct qlge_rx_ring *rx_ring)
+static int qlge_start_cq(struct qlge_adapter *qdev, struct qlge_cq *cq)
 {
-	struct cqicb *cqicb = &rx_ring->cqicb;
+	struct cqicb *cqicb = &cq->cqicb;
 	void *shadow_reg = qdev->rx_ring_shadow_reg_area +
-		(rx_ring->cq_id * RX_RING_SHADOW_SPACE);
+		(cq->cq_id * RX_RING_SHADOW_SPACE);
 	u64 shadow_reg_dma = qdev->rx_ring_shadow_reg_dma +
-		(rx_ring->cq_id * RX_RING_SHADOW_SPACE);
+		(cq->cq_id * RX_RING_SHADOW_SPACE);
 	void __iomem *doorbell_area =
-		qdev->doorbell_area + (DB_PAGE_SIZE * (128 + rx_ring->cq_id));
+		qdev->doorbell_area + (DB_PAGE_SIZE * (128 + cq->cq_id));
+	struct qlge_rx_ring *rx_ring;
 	int err = 0;
 	u64 tmp;
 	__le64 *base_indirect_ptr;
 	int page_entries;
 
-	/* Set up the shadow registers for this ring. */
-	rx_ring->prod_idx_sh_reg = shadow_reg;
-	rx_ring->prod_idx_sh_reg_dma = shadow_reg_dma;
-	*rx_ring->prod_idx_sh_reg = 0;
-	shadow_reg += sizeof(u64);
-	shadow_reg_dma += sizeof(u64);
-	rx_ring->lbq.base_indirect = shadow_reg;
-	rx_ring->lbq.base_indirect_dma = shadow_reg_dma;
-	shadow_reg += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
-	shadow_reg_dma += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
-	rx_ring->sbq.base_indirect = shadow_reg;
-	rx_ring->sbq.base_indirect_dma = shadow_reg_dma;
+	/* Set up the shadow registers for this cq. */
+	cq->prod_idx_sh_reg = shadow_reg;
+	cq->prod_idx_sh_reg_dma = shadow_reg_dma;
+	*cq->prod_idx_sh_reg = 0;
 
 	/* PCI doorbell mem area + 0x00 for consumer index register */
-	rx_ring->cnsmr_idx_db_reg = (u32 __iomem *)doorbell_area;
-	rx_ring->cnsmr_idx = 0;
-	rx_ring->curr_entry = rx_ring->cq_base;
+	cq->cnsmr_idx_db_reg = (u32 __iomem *)doorbell_area;
+	cq->cnsmr_idx = 0;
+	cq->curr_entry = cq->cq_base;
 
 	/* PCI doorbell mem area + 0x04 for valid register */
-	rx_ring->valid_db_reg = doorbell_area + 0x04;
-
-	/* PCI doorbell mem area + 0x18 for large buffer consumer */
-	rx_ring->lbq.prod_idx_db_reg = (u32 __iomem *)(doorbell_area + 0x18);
-
-	/* PCI doorbell mem area + 0x1c */
-	rx_ring->sbq.prod_idx_db_reg = (u32 __iomem *)(doorbell_area + 0x1c);
+	cq->valid_db_reg = doorbell_area + 0x04;
 
 	memset((void *)cqicb, 0, sizeof(struct cqicb));
-	cqicb->msix_vect = rx_ring->irq;
+	cqicb->msix_vect = cq->irq;
 
-	cqicb->len = cpu_to_le16(QLGE_FIT16(rx_ring->cq_len) | LEN_V |
+	cqicb->len = cpu_to_le16(QLGE_FIT16(cq->cq_len) | LEN_V |
 				 LEN_CPP_CONT);
 
-	cqicb->addr = cpu_to_le64(rx_ring->cq_base_dma);
+	cqicb->addr = cpu_to_le64(cq->cq_base_dma);
 
-	cqicb->prod_idx_addr = cpu_to_le64(rx_ring->prod_idx_sh_reg_dma);
+	cqicb->prod_idx_addr = cpu_to_le64(cq->prod_idx_sh_reg_dma);
 
 	/*
 	 * Set up the control block load flags.
@@ -3006,7 +3008,23 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct qlge_rx_ring *rx
 	cqicb->flags = FLAGS_LC |	/* Load queue base address */
 		FLAGS_LV |		/* Load MSI-X vector */
 		FLAGS_LI;		/* Load irq delay values */
-	if (rx_ring->cq_id < qdev->rss_ring_count) {
+
+	if (cq->cq_id < qdev->rss_ring_count) {
+		rx_ring = &qdev->rx_ring[cq->cq_id];
+		shadow_reg += sizeof(u64);
+		shadow_reg_dma += sizeof(u64);
+		rx_ring->lbq.base_indirect = shadow_reg;
+		rx_ring->lbq.base_indirect_dma = shadow_reg_dma;
+		shadow_reg += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
+		shadow_reg_dma += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
+		rx_ring->sbq.base_indirect = shadow_reg;
+		rx_ring->sbq.base_indirect_dma = shadow_reg_dma;
+		/* PCI doorbell mem area + 0x18 for large buffer consumer */
+		rx_ring->lbq.prod_idx_db_reg = (u32 __iomem *)(doorbell_area + 0x18);
+
+		/* PCI doorbell mem area + 0x1c */
+		rx_ring->sbq.prod_idx_db_reg = (u32 __iomem *)(doorbell_area + 0x1c);
+
 		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
 		tmp = (u64)rx_ring->lbq.base_dma;
 		base_indirect_ptr = rx_ring->lbq.base_indirect;
@@ -3034,14 +3052,12 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct qlge_rx_ring *rx
 			base_indirect_ptr++;
 			page_entries++;
 		} while (page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
-		cqicb->sbq_addr =
-			cpu_to_le64(rx_ring->sbq.base_indirect_dma);
+		cqicb->sbq_addr = cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(QLGE_SMALL_BUFFER_SIZE);
 		cqicb->sbq_len = cpu_to_le16(QLGE_FIT16(QLGE_BQ_LEN));
 		rx_ring->sbq.next_to_use = 0;
 		rx_ring->sbq.next_to_clean = 0;
-	}
-	if (rx_ring->cq_id < qdev->rss_ring_count) {
+
 		/* Inbound completion handling rx_rings run in
 		 * separate NAPI contexts.
 		 */
@@ -3054,7 +3070,7 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct qlge_rx_ring *rx
 		cqicb->pkt_delay = cpu_to_le16(qdev->tx_max_coalesced_frames);
 	}
 	err = qlge_write_cfg(qdev, cqicb, sizeof(struct cqicb),
-			     CFG_LCQ, rx_ring->cq_id);
+			     CFG_LCQ, cq->cq_id);
 	if (err) {
 		netif_err(qdev, ifup, qdev->ndev, "Failed to load CQICB.\n");
 		return err;
@@ -3195,20 +3211,20 @@ static void qlge_set_tx_vect(struct qlge_adapter *qdev)
 	if (likely(test_bit(QL_MSIX_ENABLED, &qdev->flags))) {
 		/* Assign irq vectors to TX rx_rings.*/
 		for (vect = 0, j = 0, i = qdev->rss_ring_count;
-		     i < qdev->rx_ring_count; i++) {
+		     i < qdev->cq_count; i++) {
 			if (j == tx_rings_per_vector) {
 				vect++;
 				j = 0;
 			}
-			qdev->rx_ring[i].irq = vect;
+			qdev->cq[i].irq = vect;
 			j++;
 		}
 	} else {
 		/* For single vector all rings have an irq
 		 * of zero.
 		 */
-		for (i = 0; i < qdev->rx_ring_count; i++)
-			qdev->rx_ring[i].irq = 0;
+		for (i = 0; i < qdev->cq_count; i++)
+			qdev->cq[i].irq = 0;
 	}
 }
 
@@ -3226,21 +3242,21 @@ static void qlge_set_irq_mask(struct qlge_adapter *qdev, struct intr_context *ct
 		/* Add the RSS ring serviced by this vector
 		 * to the mask.
 		 */
-		ctx->irq_mask = (1 << qdev->rx_ring[vect].cq_id);
+		ctx->irq_mask = (1 << qdev->cq[vect].cq_id);
 		/* Add the TX ring(s) serviced by this vector
 		 * to the mask.
 		 */
 		for (j = 0; j < tx_rings_per_vector; j++) {
 			ctx->irq_mask |=
-				(1 << qdev->rx_ring[qdev->rss_ring_count +
+				(1 << qdev->cq[qdev->rss_ring_count +
 				 (vect * tx_rings_per_vector) + j].cq_id);
 		}
 	} else {
 		/* For single vector we just shift each queue's
 		 * ID into the mask.
 		 */
-		for (j = 0; j < qdev->rx_ring_count; j++)
-			ctx->irq_mask |= (1 << qdev->rx_ring[j].cq_id);
+		for (j = 0; j < qdev->cq_count; j++)
+			ctx->irq_mask |= (1 << qdev->cq[j].cq_id);
 	}
 }
 
@@ -3261,7 +3277,7 @@ static void qlge_resolve_queues_to_irqs(struct qlge_adapter *qdev)
 		 * vectors for each queue.
 		 */
 		for (i = 0; i < qdev->intr_count; i++, intr_context++) {
-			qdev->rx_ring[i].irq = i;
+			qdev->cq[i].irq = i;
 			intr_context->intr = i;
 			intr_context->qdev = qdev;
 			/* Set up this vector's bit-mask that indicates
@@ -3357,9 +3373,9 @@ static void qlge_free_irq(struct qlge_adapter *qdev)
 		if (intr_context->hooked) {
 			if (test_bit(QL_MSIX_ENABLED, &qdev->flags)) {
 				free_irq(qdev->msi_x_entry[i].vector,
-					 &qdev->rx_ring[i]);
+					 &qdev->cq[i]);
 			} else {
-				free_irq(qdev->pdev->irq, &qdev->rx_ring[0]);
+				free_irq(qdev->pdev->irq, &qdev->cq[0]);
 			}
 		}
 	}
@@ -3381,7 +3397,7 @@ static int qlge_request_irq(struct qlge_adapter *qdev)
 					     intr_context->handler,
 					     0,
 					     intr_context->name,
-					     &qdev->rx_ring[i]);
+					     &qdev->cq[i]);
 			if (status) {
 				netif_err(qdev, ifup, qdev->ndev,
 					  "Failed request for MSIX interrupt %d.\n",
@@ -3398,13 +3414,13 @@ static int qlge_request_irq(struct qlge_adapter *qdev)
 				     intr_context->name);
 			netif_printk(qdev, ifup, KERN_DEBUG, qdev->ndev,
 				     "%s: dev_id = 0x%p.\n", __func__,
-				     &qdev->rx_ring[0]);
+				     &qdev->cq[0]);
 			status =
 				request_irq(pdev->irq, qlge_isr,
 					    test_bit(QL_MSI_ENABLED, &qdev->flags)
 					    ? 0
 					    : IRQF_SHARED,
-					    intr_context->name, &qdev->rx_ring[0]);
+					    intr_context->name, &qdev->cq[0]);
 			if (status)
 				goto err_irq;
 
@@ -3620,8 +3636,8 @@ static int qlge_adapter_initialize(struct qlge_adapter *qdev)
 		qdev->wol = WAKE_MAGIC;
 
 	/* Start up the rx queues. */
-	for (i = 0; i < qdev->rx_ring_count; i++) {
-		status = qlge_start_rx_ring(qdev, &qdev->rx_ring[i]);
+	for (i = 0; i < qdev->cq_count; i++) {
+		status = qlge_start_cq(qdev, &qdev->cq[i]);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to start rx ring[%d].\n", i);
@@ -3916,10 +3932,11 @@ static void qlge_set_lb_size(struct qlge_adapter *qdev)
 
 static int qlge_configure_rings(struct qlge_adapter *qdev)
 {
-	int i;
+	int cpu_cnt = min_t(int, MAX_CPUS, num_online_cpus());
 	struct qlge_rx_ring *rx_ring;
 	struct qlge_tx_ring *tx_ring;
-	int cpu_cnt = min_t(int, MAX_CPUS, num_online_cpus());
+	struct qlge_cq *cq;
+	int i;
 
 	/* In a perfect world we have one RSS ring for each CPU
 	 * and each has it's own vector.  To do that we ask for
@@ -3933,7 +3950,7 @@ static int qlge_configure_rings(struct qlge_adapter *qdev)
 	/* Adjust the RSS ring count to the actual vector count. */
 	qdev->rss_ring_count = qdev->intr_count;
 	qdev->tx_ring_count = cpu_cnt;
-	qdev->rx_ring_count = qdev->tx_ring_count + qdev->rss_ring_count;
+	qdev->cq_count = qdev->tx_ring_count + qdev->rss_ring_count;
 
 	for (i = 0; i < qdev->tx_ring_count; i++) {
 		tx_ring = &qdev->tx_ring[i];
@@ -3951,31 +3968,35 @@ static int qlge_configure_rings(struct qlge_adapter *qdev)
 		tx_ring->cq_id = qdev->rss_ring_count + i;
 	}
 
-	for (i = 0; i < qdev->rx_ring_count; i++) {
-		rx_ring = &qdev->rx_ring[i];
-		memset((void *)rx_ring, 0, sizeof(*rx_ring));
-		rx_ring->qdev = qdev;
-		rx_ring->cq_id = i;
-		rx_ring->cpu = i % cpu_cnt;	/* CPU to run handler on. */
+	for (i = 0; i < qdev->cq_count; i++) {
+		cq = &qdev->cq[i];
+		memset((void *)cq, 0, sizeof(*cq));
+		cq->qdev = qdev;
+		cq->cq_id = i;
+		cq->cpu = i % cpu_cnt;	/* CPU to run handler on. */
 		if (i < qdev->rss_ring_count) {
 			/*
 			 * Inbound (RSS) queues.
 			 */
-			rx_ring->cq_len = qdev->rx_ring_size;
-			rx_ring->cq_size =
-				rx_ring->cq_len * sizeof(struct qlge_net_rsp_iocb);
+			cq->cq_len = qdev->rx_ring_size;
+			cq->cq_size =
+				cq->cq_len * sizeof(struct qlge_net_rsp_iocb);
+			rx_ring = &qdev->rx_ring[i];
+			memset((void *)rx_ring, 0, sizeof(*rx_ring));
 			rx_ring->lbq.type = QLGE_LB;
+			rx_ring->cq_id = i;
 			rx_ring->sbq.type = QLGE_SB;
 			INIT_DELAYED_WORK(&rx_ring->refill_work,
 					  &qlge_slow_refill);
+			rx_ring->qdev = qdev;
 		} else {
 			/*
 			 * Outbound queue handles outbound completions only.
 			 */
 			/* outbound cq is same size as tx_ring it services. */
-			rx_ring->cq_len = qdev->tx_ring_size;
-			rx_ring->cq_size =
-				rx_ring->cq_len * sizeof(struct qlge_net_rsp_iocb);
+			cq->cq_len = qdev->tx_ring_size;
+			cq->cq_size =
+				cq->cq_len * sizeof(struct qlge_net_rsp_iocb);
 		}
 	}
 	return 0;
@@ -4648,9 +4669,9 @@ netdev_tx_t qlge_lb_send(struct sk_buff *skb, struct net_device *ndev)
 	return qlge_send(skb, ndev);
 }
 
-int qlge_clean_lb_rx_ring(struct qlge_rx_ring *rx_ring, int budget)
+int qlge_clean_lb_cq(struct qlge_cq *cq, int budget)
 {
-	return qlge_clean_inbound_rx_ring(rx_ring, budget);
+	return qlge_clean_inbound_cq(cq, budget);
 }
 
 static void qlge_remove(struct pci_dev *pdev)
-- 
2.32.0

