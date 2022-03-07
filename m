Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B65D4CF5A7
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 10:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbiCGJaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 04:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238480AbiCGJ3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 04:29:14 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBC460D8;
        Mon,  7 Mar 2022 01:27:26 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2278tPG9021320;
        Mon, 7 Mar 2022 01:26:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=14gDONyj5O3VuVpH5BQKuw3VYRkuWDJR5I8g79GSWw0=;
 b=hQkayzxbkgeT34ywlOtkZ6pfZgbA337UK8OjDSDksHeF7fAl3F/V9NRN2/BFjP1nLD1V
 KetMcXyndZ6SBrcoG86slnZ56pijGY1BgmgD1IcIsuqZijGRwxTDs0nyfSMunXt1WZxQ
 MfWbuxVi+6jAn2O2NSJHWM9AuQT1R7z/G7gs2ATVdwGTYFnG0mAFOEvIGFOJeAsUN7Np
 M1ewMFLy7N8t3u4MfjT+5zt8Kh90jVt0vqbuEHgjrEuEd2TWY/cfOES+c07qrFWv1RVf
 m2ydVXIKZRRPlLUKckbKtx0d2LfLjUYf4C6CkQxceH/Bxb43utMXB+zSUQTscFg4zbWU pw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3em63sxck7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 01:26:52 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Mar
 2022 01:26:50 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Mar 2022 01:26:50 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 62ACA3F7043;
        Mon,  7 Mar 2022 01:26:50 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <vburru@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: [PATCH v3 4/7] octeon_ep: add Tx/Rx ring resource setup and cleanup
Date:   Mon, 7 Mar 2022 01:26:43 -0800
Message-ID: <20220307092646.17156-5-vburru@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220307092646.17156-1-vburru@marvell.com>
References: <20220307092646.17156-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0ojrOzJxzqsSW3f3fGYSpKy7RzOXcwvM
X-Proofpoint-GUID: 0ojrOzJxzqsSW3f3fGYSpKy7RzOXcwvM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_01,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement Tx/Rx ring resource allocation and cleanup.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
Signed-off-by: Satananda Burla <sburla@marvell.com>
---
V2 -> V3: 
  - fix the implicit declaration errors for vmalloc() and vfree()
    calls, reported by kernel test robot:
    Reported-by: kernel test robot <lkp@intel.com>

V1 -> V2:
  - created by dividing PATCH 1/4 of original patch series

 .../net/ethernet/marvell/octeon_ep/octep_rx.c | 222 ++++++++++++++++++
 .../net/ethernet/marvell/octeon_ep/octep_tx.c | 219 +++++++++++++++++
 2 files changed, 441 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
index 4fa67f305cc8..7086ede58475 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -7,10 +7,199 @@
 
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
+#include <linux/vmalloc.h>
 
 #include "octep_config.h"
 #include "octep_main.h"
 
+static void octep_oq_reset_indices(struct octep_oq *oq)
+{
+	oq->host_read_idx = 0;
+	oq->host_refill_idx = 0;
+	oq->refill_count = 0;
+	oq->last_pkt_count = 0;
+	oq->pkts_pending = 0;
+}
+
+/**
+ * octep_oq_fill_ring_buffers() - fill initial receive buffers for Rx ring.
+ *
+ * @oq: Octeon Rx queue data structure.
+ *
+ * Return: 0, if successfully filled receive buffers for all descriptors.
+ *         -1, if failed to allocate a buffer or failed to map for DMA.
+ */
+static int octep_oq_fill_ring_buffers(struct octep_oq *oq)
+{
+	struct octep_oq_desc_hw *desc_ring = oq->desc_ring;
+	struct page *page;
+	u32 i;
+
+	for (i = 0; i < oq->max_count; i++) {
+		page = dev_alloc_page();
+		if (unlikely(!page)) {
+			dev_err(oq->dev, "Rx buffer alloc failed\n");
+			goto rx_buf_alloc_err;
+		}
+		desc_ring[i].buffer_ptr = dma_map_page(oq->dev, page, 0,
+						       PAGE_SIZE,
+						       DMA_FROM_DEVICE);
+		if (dma_mapping_error(oq->dev, desc_ring[i].buffer_ptr)) {
+			dev_err(oq->dev,
+				"OQ-%d buffer alloc: DMA mapping error!\n",
+				oq->q_no);
+			put_page(page);
+			goto dma_map_err;
+		}
+		oq->buff_info[i].page = page;
+	}
+
+	return 0;
+
+dma_map_err:
+rx_buf_alloc_err:
+	while (i) {
+		i--;
+		dma_unmap_page(oq->dev, desc_ring[i].buffer_ptr, PAGE_SIZE, DMA_FROM_DEVICE);
+		put_page(oq->buff_info[i].page);
+		oq->buff_info[i].page = NULL;
+	}
+
+	return -1;
+}
+
+/**
+ * octep_setup_oq() - Setup a Rx queue.
+ *
+ * @oct: Octeon device private data structure.
+ * @q_no: Rx queue number to be setup.
+ *
+ * Allocate resources for a Rx queue.
+ */
+static int octep_setup_oq(struct octep_device *oct, int q_no)
+{
+	struct octep_oq *oq;
+	u32 desc_ring_size;
+
+	oq = vzalloc(sizeof(*oq));
+	if (!oq)
+		goto create_oq_fail;
+	oct->oq[q_no] = oq;
+
+	oq->octep_dev = oct;
+	oq->netdev = oct->netdev;
+	oq->dev = &oct->pdev->dev;
+	oq->q_no = q_no;
+	oq->max_count = CFG_GET_OQ_NUM_DESC(oct->conf);
+	oq->ring_size_mask = oq->max_count - 1;
+	oq->buffer_size = CFG_GET_OQ_BUF_SIZE(oct->conf);
+	oq->max_single_buffer_size = oq->buffer_size - OCTEP_OQ_RESP_HW_SIZE;
+
+	/* When the hardware/firmware supports additional capabilities,
+	 * additional header is filled-in by Octeon after length field in
+	 * Rx packets. this header contains additional packet information.
+	 */
+	if (oct->caps_enabled)
+		oq->max_single_buffer_size -= OCTEP_OQ_RESP_HW_EXT_SIZE;
+
+	oq->refill_threshold = CFG_GET_OQ_REFILL_THRESHOLD(oct->conf);
+
+	desc_ring_size = oq->max_count * OCTEP_OQ_DESC_SIZE;
+	oq->desc_ring = dma_alloc_coherent(oq->dev, desc_ring_size,
+					   &oq->desc_ring_dma, GFP_KERNEL);
+
+	if (unlikely(!oq->desc_ring)) {
+		dev_err(oq->dev,
+			"Failed to allocate DMA memory for OQ-%d !!\n", q_no);
+		goto desc_dma_alloc_err;
+	}
+
+	oq->buff_info = (struct octep_rx_buffer *)
+			vzalloc(oq->max_count * OCTEP_OQ_RECVBUF_SIZE);
+	if (unlikely(!oq->buff_info)) {
+		dev_err(&oct->pdev->dev,
+			"Failed to allocate buffer info for OQ-%d\n", q_no);
+		goto buf_list_err;
+	}
+
+	if (octep_oq_fill_ring_buffers(oq))
+		goto oq_fill_buff_err;
+
+	octep_oq_reset_indices(oq);
+	oct->hw_ops.setup_oq_regs(oct, q_no);
+	oct->num_oqs++;
+
+	return 0;
+
+oq_fill_buff_err:
+	vfree(oq->buff_info);
+	oq->buff_info = NULL;
+buf_list_err:
+	dma_free_coherent(oq->dev, desc_ring_size,
+			  oq->desc_ring, oq->desc_ring_dma);
+	oq->desc_ring = NULL;
+desc_dma_alloc_err:
+	vfree(oq);
+	oct->oq[q_no] = NULL;
+create_oq_fail:
+	return -1;
+}
+
+/**
+ * octep_oq_free_ring_buffers() - Free ring buffers.
+ *
+ * @oq: Octeon Rx queue data structure.
+ *
+ * Free receive buffers in unused Rx queue descriptors.
+ */
+static void octep_oq_free_ring_buffers(struct octep_oq *oq)
+{
+	struct octep_oq_desc_hw *desc_ring = oq->desc_ring;
+	int  i;
+
+	if (!oq->desc_ring || !oq->buff_info)
+		return;
+
+	for (i = 0; i < oq->max_count; i++)  {
+		if (oq->buff_info[i].page) {
+			dma_unmap_page(oq->dev, desc_ring[i].buffer_ptr,
+				       PAGE_SIZE, DMA_FROM_DEVICE);
+			put_page(oq->buff_info[i].page);
+			oq->buff_info[i].page = NULL;
+			desc_ring[i].buffer_ptr = 0;
+		}
+	}
+	octep_oq_reset_indices(oq);
+}
+
+/**
+ * octep_free_oq() - Free Rx queue resources.
+ *
+ * @oq: Octeon Rx queue data structure.
+ *
+ * Free all resources of a Rx queue.
+ */
+static int octep_free_oq(struct octep_oq *oq)
+{
+	struct octep_device *oct = oq->octep_dev;
+	int q_no = oq->q_no;
+
+	octep_oq_free_ring_buffers(oq);
+
+	if (oq->buff_info)
+		vfree(oq->buff_info);
+
+	if (oq->desc_ring)
+		dma_free_coherent(oq->dev,
+				  oq->max_count * OCTEP_OQ_DESC_SIZE,
+				  oq->desc_ring, oq->desc_ring_dma);
+
+	vfree(oq);
+	oct->oq[q_no] = NULL;
+	oct->num_oqs--;
+	return 0;
+}
+
 /**
  * octep_setup_oqs() - setup resources for all Rx queues.
  *
@@ -18,6 +207,26 @@
  */
 int octep_setup_oqs(struct octep_device *oct)
 {
+	int i, retval = 0;
+
+	oct->num_oqs = 0;
+	for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++) {
+		retval = octep_setup_oq(oct, i);
+		if (retval) {
+			dev_err(&oct->pdev->dev,
+				"Failed to setup OQ(RxQ)-%d.\n", i);
+			goto oq_setup_err;
+		}
+		dev_dbg(&oct->pdev->dev, "Successfully setup OQ(RxQ)-%d.\n", i);
+	}
+
+	return 0;
+
+oq_setup_err:
+	while (i) {
+		i--;
+		octep_free_oq(oct->oq[i]);
+	}
 	return -1;
 }
 
@@ -30,6 +239,10 @@ int octep_setup_oqs(struct octep_device *oct)
  */
 void octep_oq_dbell_init(struct octep_device *oct)
 {
+	int i;
+
+	for (i = 0; i < oct->num_oqs; i++)
+		writel(oct->oq[i]->max_count, oct->oq[i]->pkts_credit_reg);
 }
 
 /**
@@ -39,4 +252,13 @@ void octep_oq_dbell_init(struct octep_device *oct)
  */
 void octep_free_oqs(struct octep_device *oct)
 {
+	int i;
+
+	for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++) {
+		if (!oct->oq[i])
+			continue;
+		octep_free_oq(oct->oq[i]);
+		dev_dbg(&oct->pdev->dev,
+			"Successfully freed OQ(RxQ)-%d.\n", i);
+	}
 }
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
index f0e1cc142b2e..185522d72475 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
@@ -7,10 +7,75 @@
 
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
+#include <linux/vmalloc.h>
 
 #include "octep_config.h"
 #include "octep_main.h"
 
+/* Reset various index of Tx queue data structure. */
+static void octep_iq_reset_indices(struct octep_iq *iq)
+{
+	iq->fill_cnt = 0;
+	iq->host_write_index = 0;
+	iq->octep_read_index = 0;
+	iq->flush_index = 0;
+	iq->pkts_processed = 0;
+	iq->pkt_in_done = 0;
+	atomic_set(&iq->instr_pending, 0);
+}
+
+/**
+ * octep_iq_free_pending() - Free Tx buffers for pending completions.
+ *
+ * @iq: Octeon Tx queue data structure.
+ */
+static void octep_iq_free_pending(struct octep_iq *iq)
+{
+	struct octep_tx_buffer *tx_buffer;
+	struct skb_shared_info *shinfo;
+	u32 fi = iq->flush_index;
+	struct sk_buff *skb;
+	u8 frags, i;
+
+	while (fi != iq->host_write_index) {
+		tx_buffer = iq->buff_info + fi;
+		skb = tx_buffer->skb;
+
+		fi++;
+		if (unlikely(fi == iq->max_count))
+			fi = 0;
+
+		if (!tx_buffer->gather) {
+			dma_unmap_single(iq->dev, tx_buffer->dma,
+					 tx_buffer->skb->len, DMA_TO_DEVICE);
+			dev_kfree_skb_any(skb);
+			continue;
+		}
+
+		/* Scatter/Gather */
+		shinfo = skb_shinfo(skb);
+		frags = shinfo->nr_frags;
+
+		dma_unmap_single(iq->dev,
+				 tx_buffer->sglist[0].dma_ptr[0],
+				 tx_buffer->sglist[0].len[0],
+				 DMA_TO_DEVICE);
+
+		i = 1; /* entry 0 is main skb, unmapped above */
+		while (frags--) {
+			dma_unmap_page(iq->dev, tx_buffer->sglist[i >> 2].dma_ptr[i & 3],
+				       tx_buffer->sglist[i >> 2].len[i & 3], DMA_TO_DEVICE);
+			i++;
+		}
+
+		dev_kfree_skb_any(skb);
+	}
+
+	atomic_set(&iq->instr_pending, 0);
+	iq->flush_index = fi;
+	netdev_tx_reset_queue(netdev_get_tx_queue(iq->netdev, iq->q_no));
+}
+
 /**
  * octep_clean_iqs()  - Clean Tx queues to shutdown the device.
  *
@@ -21,6 +86,133 @@
  */
 void octep_clean_iqs(struct octep_device *oct)
 {
+	int i;
+
+	for (i = 0; i < oct->num_iqs; i++) {
+		octep_iq_free_pending(oct->iq[i]);
+		octep_iq_reset_indices(oct->iq[i]);
+	}
+}
+
+/**
+ * octep_setup_iq() - Setup a Tx queue.
+ *
+ * @oct: Octeon device private data structure.
+ * @q_no: Tx queue number to be setup.
+ *
+ * Allocate resources for a Tx queue.
+ */
+static int octep_setup_iq(struct octep_device *oct, int q_no)
+{
+	u32 desc_ring_size, buff_info_size, sglist_size;
+	struct octep_iq *iq;
+	int i;
+
+	iq = vzalloc(sizeof(*iq));
+	if (!iq)
+		goto iq_alloc_err;
+	oct->iq[q_no] = iq;
+
+	iq->octep_dev = oct;
+	iq->netdev = oct->netdev;
+	iq->dev = &oct->pdev->dev;
+	iq->q_no = q_no;
+	iq->max_count = CFG_GET_IQ_NUM_DESC(oct->conf);
+	iq->ring_size_mask = iq->max_count - 1;
+	iq->fill_threshold = CFG_GET_IQ_DB_MIN(oct->conf);
+	iq->netdev_q = netdev_get_tx_queue(iq->netdev, q_no);
+
+	/* Allocate memory for hardware queue descriptors */
+	desc_ring_size = OCTEP_IQ_DESC_SIZE * CFG_GET_IQ_NUM_DESC(oct->conf);
+	iq->desc_ring = dma_alloc_coherent(iq->dev, desc_ring_size,
+					   &iq->desc_ring_dma, GFP_KERNEL);
+	if (unlikely(!iq->desc_ring)) {
+		dev_err(iq->dev,
+			"Failed to allocate DMA memory for IQ-%d\n", q_no);
+		goto desc_dma_alloc_err;
+	}
+
+	/* Allocate memory for hardware SGLIST descriptors */
+	sglist_size = OCTEP_SGLIST_SIZE_PER_PKT *
+		      CFG_GET_IQ_NUM_DESC(oct->conf);
+	iq->sglist = dma_alloc_coherent(iq->dev, sglist_size,
+					&iq->sglist_dma, GFP_KERNEL);
+	if (unlikely(!iq->sglist)) {
+		dev_err(iq->dev,
+			"Failed to allocate DMA memory for IQ-%d SGLIST\n",
+			q_no);
+		goto sglist_alloc_err;
+	}
+
+	/* allocate memory to manage Tx packets pending completion */
+	buff_info_size = OCTEP_IQ_TXBUFF_INFO_SIZE * iq->max_count;
+	iq->buff_info = vzalloc(buff_info_size);
+	if (!iq->buff_info) {
+		dev_err(iq->dev,
+			"Failed to allocate buff info for IQ-%d\n", q_no);
+		goto buff_info_err;
+	}
+
+	/* Setup sglist addresses in tx_buffer entries */
+	for (i = 0; i < CFG_GET_IQ_NUM_DESC(oct->conf); i++) {
+		struct octep_tx_buffer *tx_buffer;
+
+		tx_buffer = &iq->buff_info[i];
+		tx_buffer->sglist =
+			&iq->sglist[i * OCTEP_SGLIST_ENTRIES_PER_PKT];
+		tx_buffer->sglist_dma =
+			iq->sglist_dma + (i * OCTEP_SGLIST_SIZE_PER_PKT);
+	}
+
+	octep_iq_reset_indices(iq);
+	oct->hw_ops.setup_iq_regs(oct, q_no);
+
+	oct->num_iqs++;
+	return 0;
+
+buff_info_err:
+	dma_free_coherent(iq->dev, sglist_size, iq->sglist, iq->sglist_dma);
+sglist_alloc_err:
+	dma_free_coherent(iq->dev, desc_ring_size,
+			  iq->desc_ring, iq->desc_ring_dma);
+desc_dma_alloc_err:
+	vfree(iq);
+	oct->iq[q_no] = NULL;
+iq_alloc_err:
+	return -1;
+}
+
+/**
+ * octep_free_iq() - Free Tx queue resources.
+ *
+ * @iq: Octeon Tx queue data structure.
+ *
+ * Free all the resources allocated for a Tx queue.
+ */
+static void octep_free_iq(struct octep_iq *iq)
+{
+	struct octep_device *oct = iq->octep_dev;
+	u64 desc_ring_size, sglist_size;
+	int q_no = iq->q_no;
+
+	desc_ring_size = OCTEP_IQ_DESC_SIZE * CFG_GET_IQ_NUM_DESC(oct->conf);
+
+	if (iq->buff_info)
+		vfree(iq->buff_info);
+
+	if (iq->desc_ring)
+		dma_free_coherent(iq->dev, desc_ring_size,
+				  iq->desc_ring, iq->desc_ring_dma);
+
+	sglist_size = OCTEP_SGLIST_SIZE_PER_PKT *
+		      CFG_GET_IQ_NUM_DESC(oct->conf);
+	if (iq->sglist)
+		dma_free_coherent(iq->dev, sglist_size,
+				  iq->sglist, iq->sglist_dma);
+
+	vfree(iq);
+	oct->iq[q_no] = NULL;
+	oct->num_iqs--;
 }
 
 /**
@@ -30,6 +222,25 @@ void octep_clean_iqs(struct octep_device *oct)
  */
 int octep_setup_iqs(struct octep_device *oct)
 {
+	int i;
+
+	oct->num_iqs = 0;
+	for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++) {
+		if (octep_setup_iq(oct, i)) {
+			dev_err(&oct->pdev->dev,
+				"Failed to setup IQ(TxQ)-%d.\n", i);
+			goto iq_setup_err;
+		}
+		dev_dbg(&oct->pdev->dev, "Successfully setup IQ(TxQ)-%d.\n", i);
+	}
+
+	return 0;
+
+iq_setup_err:
+	while (i) {
+		i--;
+		octep_free_iq(oct->iq[i]);
+	}
 	return -1;
 }
 
@@ -40,4 +251,12 @@ int octep_setup_iqs(struct octep_device *oct)
  */
 void octep_free_iqs(struct octep_device *oct)
 {
+	int i;
+
+	for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++) {
+		octep_free_iq(oct->iq[i]);
+		dev_dbg(&oct->pdev->dev,
+			"Successfully destroyed IQ(TxQ)-%d.\n", i);
+	}
+	oct->num_iqs = 0;
 }
-- 
2.17.1

