Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79BA250681
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgHXRdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:33:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:29869 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbgHXRdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 13:33:45 -0400
IronPort-SDR: vhP+OYGdU0+O6I/e9Tonx7Lmv2eKL51CsQS0YysK9zgqGnRJGGXeeAeKNI8GtMx1WRQPflDhlC
 ds9w5uyp1JnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="157008583"
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="157008583"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 10:33:25 -0700
IronPort-SDR: G+pW7vXd0r03G97P4QkiVd8ClgdV0rounvfwiEJURAg+IQg4UuFgBL7YWxPzRN2radMwnAa5Z0
 vV+866uQH9vA==
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="336245358"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 10:33:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: [net-next v5 09/15] iecm: Init and allocate vport
Date:   Mon, 24 Aug 2020 10:33:00 -0700
Message-Id: <20200824173306.3178343-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

Initialize vport and allocate queue resources.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iecm/iecm_lib.c    | 125 ++-
 drivers/net/ethernet/intel/iecm/iecm_txrx.c   | 782 +++++++++++++++++-
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   |  36 +-
 3 files changed, 911 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c b/drivers/net/ethernet/intel/iecm/iecm_lib.c
index 4037d13e4512..8c5e90f275c3 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_lib.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_lib.c
@@ -461,7 +461,15 @@ static void iecm_vport_rel_all(struct iecm_adapter *adapter)
 void iecm_vport_set_hsplit(struct iecm_vport *vport,
 			   struct bpf_prog __always_unused *prog)
 {
-	/* stub */
+	if (prog) {
+		vport->rx_hsplit_en = IECM_RX_NO_HDR_SPLIT;
+		return;
+	}
+	if (iecm_is_cap_ena(vport->adapter, VIRTCHNL_CAP_HEADER_SPLIT) &&
+	    iecm_is_queue_model_split(vport->rxq_model))
+		vport->rx_hsplit_en = IECM_RX_HDR_SPLIT;
+	else
+		vport->rx_hsplit_en = IECM_RX_NO_HDR_SPLIT;
 }
 
 /**
@@ -548,7 +556,19 @@ static void iecm_service_task(struct work_struct *work)
  */
 static int iecm_up_complete(struct iecm_vport *vport)
 {
-	/* stub */
+	int err;
+
+	err = netif_set_real_num_rx_queues(vport->netdev, vport->num_txq);
+	if (err)
+		return err;
+	err = netif_set_real_num_tx_queues(vport->netdev, vport->num_rxq);
+	if (err)
+		return err;
+	netif_carrier_on(vport->netdev);
+	netif_tx_start_all_queues(vport->netdev);
+
+	vport->adapter->state = __IECM_UP;
+	return 0;
 }
 
 /**
@@ -557,7 +577,27 @@ static int iecm_up_complete(struct iecm_vport *vport)
  */
 static void iecm_rx_init_buf_tail(struct iecm_vport *vport)
 {
-	/* stub */
+	int i, j;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct iecm_rxq_group *grp = &vport->rxq_grps[i];
+
+		if (iecm_is_queue_model_split(vport->rxq_model)) {
+			for (j = 0; j < IECM_BUFQS_PER_RXQ_SET; j++) {
+				struct iecm_queue *q =
+					&grp->splitq.bufq_sets[j].bufq;
+
+				writel_relaxed(q->next_to_alloc, q->tail);
+			}
+		} else {
+			for (j = 0; j < grp->singleq.num_rxq; j++) {
+				struct iecm_queue *q =
+					&grp->singleq.rxqs[j];
+
+				writel_relaxed(q->next_to_alloc, q->tail);
+			}
+		}
+	}
 }
 
 /**
@@ -566,7 +606,80 @@ static void iecm_rx_init_buf_tail(struct iecm_vport *vport)
  */
 static int iecm_vport_open(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	int err;
+
+	if (vport->adapter->state != __IECM_DOWN)
+		return -EBUSY;
+
+	/* we do not allow interface up just yet */
+	netif_carrier_off(vport->netdev);
+
+	if (adapter->dev_ops.vc_ops.enable_vport) {
+		err = adapter->dev_ops.vc_ops.enable_vport(vport);
+		if (err)
+			return -EAGAIN;
+	}
+
+	err = adapter->dev_ops.vc_ops.vport_queue_ids_init(vport);
+	if (err) {
+		dev_err(&vport->adapter->pdev->dev,
+			"Call to queue ids init returned %d\n", err);
+		return err;
+	}
+
+	adapter->dev_ops.reg_ops.vportq_reg_init(vport);
+	iecm_rx_init_buf_tail(vport);
+
+	err = iecm_vport_intr_init(vport);
+	if (err) {
+		dev_err(&vport->adapter->pdev->dev,
+			"Call to vport interrupt init returned %d\n", err);
+		return err;
+	}
+
+	err = vport->adapter->dev_ops.vc_ops.config_queues(vport);
+	if (err)
+		goto unroll_config_queues;
+	err = vport->adapter->dev_ops.vc_ops.irq_map_unmap(vport, true);
+	if (err) {
+		dev_err(&vport->adapter->pdev->dev,
+			"Call to irq_map_unmap returned %d\n", err);
+		goto unroll_config_queues;
+	}
+	err = vport->adapter->dev_ops.vc_ops.enable_queues(vport);
+	if (err)
+		goto unroll_enable_queues;
+
+	err = vport->adapter->dev_ops.vc_ops.get_ptype(vport);
+	if (err)
+		goto unroll_get_ptype;
+
+	if (adapter->rss_data.rss_lut)
+		err = iecm_config_rss(vport);
+	else
+		err = iecm_init_rss(vport);
+	if (err)
+		goto unroll_init_rss;
+	err = iecm_up_complete(vport);
+	if (err)
+		goto unroll_up_comp;
+
+	netif_info(vport->adapter, hw, vport->netdev, "%s\n", __func__);
+
+	return 0;
+unroll_up_comp:
+	iecm_deinit_rss(vport);
+unroll_init_rss:
+	adapter->dev_ops.vc_ops.disable_vport(vport);
+unroll_get_ptype:
+	vport->adapter->dev_ops.vc_ops.disable_queues(vport);
+unroll_enable_queues:
+	vport->adapter->dev_ops.vc_ops.irq_map_unmap(vport, false);
+unroll_config_queues:
+	iecm_vport_intr_deinit(vport);
+
+	return err;
 }
 
 /**
@@ -903,7 +1016,9 @@ EXPORT_SYMBOL(iecm_shutdown);
  */
 static int iecm_open(struct net_device *netdev)
 {
-	/* stub */
+	struct iecm_netdev_priv *np = netdev_priv(netdev);
+
+	return iecm_vport_open(np->vport);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iecm/iecm_txrx.c b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
index 8214de2506af..781942f934df 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_txrx.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
@@ -86,7 +86,38 @@ static void iecm_tx_desc_rel_all(struct iecm_vport *vport)
  */
 static int iecm_tx_buf_alloc_all(struct iecm_queue *tx_q)
 {
-	/* stub */
+	int buf_size;
+	int i = 0;
+
+	/* Allocate book keeping buffers only. Buffers to be supplied to HW
+	 * are allocated by kernel network stack and received as part of skb
+	 */
+	buf_size = sizeof(struct iecm_tx_buf) * tx_q->desc_count;
+	tx_q->tx_buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!tx_q->tx_buf)
+		return -ENOMEM;
+
+	/* Initialize Tx buf stack for out-of-order completions if
+	 * flow scheduling offload is enabled
+	 */
+	tx_q->buf_stack.bufs =
+		kcalloc(tx_q->desc_count, sizeof(struct iecm_tx_buf *),
+			GFP_KERNEL);
+	if (!tx_q->buf_stack.bufs)
+		return -ENOMEM;
+
+	for (i = 0; i < tx_q->desc_count; i++) {
+		tx_q->buf_stack.bufs[i] =
+			kzalloc(sizeof(*tx_q->buf_stack.bufs[i]),
+				GFP_KERNEL);
+		if (!tx_q->buf_stack.bufs[i])
+			return IECM_ERR_NO_MEMORY;
+	}
+
+	tx_q->buf_stack.size = tx_q->desc_count;
+	tx_q->buf_stack.top = tx_q->desc_count;
+
+	return 0;
 }
 
 /**
@@ -98,7 +129,40 @@ static int iecm_tx_buf_alloc_all(struct iecm_queue *tx_q)
  */
 static int iecm_tx_desc_alloc(struct iecm_queue *tx_q, bool bufq)
 {
-	/* stub */
+	struct device *dev = tx_q->dev;
+	int err = 0;
+
+	if (bufq) {
+		err = iecm_tx_buf_alloc_all(tx_q);
+		if (err)
+			goto err_alloc;
+		tx_q->size = tx_q->desc_count *
+				sizeof(struct iecm_base_tx_desc);
+	} else {
+		tx_q->size = tx_q->desc_count *
+				sizeof(struct iecm_splitq_tx_compl_desc);
+	}
+
+	/* Allocate descriptors also round up to nearest 4K */
+	tx_q->size = ALIGN(tx_q->size, 4096);
+	tx_q->desc_ring = dmam_alloc_coherent(dev, tx_q->size, &tx_q->dma,
+					      GFP_KERNEL);
+	if (!tx_q->desc_ring) {
+		dev_info(dev, "Unable to allocate memory for the Tx descriptor ring, size=%d\n",
+			 tx_q->size);
+		err = -ENOMEM;
+		goto err_alloc;
+	}
+
+	tx_q->next_to_alloc = 0;
+	tx_q->next_to_use = 0;
+	tx_q->next_to_clean = 0;
+	set_bit(__IECM_Q_GEN_CHK, tx_q->flags);
+
+err_alloc:
+	if (err)
+		iecm_tx_desc_rel(tx_q, bufq);
+	return err;
 }
 
 /**
@@ -109,7 +173,41 @@ static int iecm_tx_desc_alloc(struct iecm_queue *tx_q, bool bufq)
  */
 static int iecm_tx_desc_alloc_all(struct iecm_vport *vport)
 {
-	/* stub */
+	struct pci_dev *pdev = vport->adapter->pdev;
+	int err = 0;
+	int i, j;
+
+	/* Setup buffer queues. In single queue model buffer queues and
+	 * completion queues will be same
+	 */
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		for (j = 0; j < vport->txq_grps[i].num_txq; j++) {
+			err = iecm_tx_desc_alloc(&vport->txq_grps[i].txqs[j],
+						 true);
+			if (err) {
+				dev_err(&pdev->dev,
+					"Allocation for Tx Queue %u failed\n",
+					i);
+				goto err_out;
+			}
+		}
+
+		if (iecm_is_queue_model_split(vport->txq_model)) {
+			/* Setup completion queues */
+			err = iecm_tx_desc_alloc(vport->txq_grps[i].complq,
+						 false);
+			if (err) {
+				dev_err(&pdev->dev,
+					"Allocation for Tx Completion Queue %u failed\n",
+					i);
+				goto err_out;
+			}
+		}
+	}
+err_out:
+	if (err)
+		iecm_tx_desc_rel_all(vport);
+	return err;
 }
 
 /**
@@ -164,7 +262,19 @@ static void iecm_rx_desc_rel_all(struct iecm_vport *vport)
  */
 void iecm_rx_buf_hw_update(struct iecm_queue *rxq, u32 val)
 {
-	/* stub */
+	/* update next to alloc since we have filled the ring */
+	rxq->next_to_alloc = val;
+
+	rxq->next_to_use = val;
+	if (!rxq->tail)
+		return;
+	/* Force memory writes to complete before letting h/w
+	 * know there are new descriptors to fetch.  (Only
+	 * applicable for weak-ordered memory model archs,
+	 * such as IA-64).
+	 */
+	wmb();
+	writel_relaxed(val, rxq->tail);
 }
 
 /**
@@ -177,7 +287,34 @@ void iecm_rx_buf_hw_update(struct iecm_queue *rxq, u32 val)
  */
 bool iecm_rx_buf_hw_alloc(struct iecm_queue *rxq, struct iecm_rx_buf *buf)
 {
-	/* stub */
+	struct page *page = buf->page;
+	dma_addr_t dma;
+
+	/* since we are recycling buffers we should seldom need to alloc */
+	if (likely(page))
+		return true;
+
+	/* alloc new page for storage */
+	page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
+	if (unlikely(!page))
+		return false;
+
+	/* map page for use */
+	dma = dma_map_page(rxq->dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
+
+	/* if mapping failed free memory back to system since
+	 * there isn't much point in holding memory we can't use
+	 */
+	if (dma_mapping_error(rxq->dev, dma)) {
+		__free_pages(page, 0);
+		return false;
+	}
+
+	buf->dma = dma;
+	buf->page = page;
+	buf->page_offset = iecm_rx_offset(rxq);
+
+	return true;
 }
 
 /**
@@ -191,7 +328,34 @@ bool iecm_rx_buf_hw_alloc(struct iecm_queue *rxq, struct iecm_rx_buf *buf)
 static bool iecm_rx_hdr_buf_hw_alloc(struct iecm_queue *rxq,
 				     struct iecm_rx_buf *hdr_buf)
 {
-	/* stub */
+	struct page *page = hdr_buf->page;
+	dma_addr_t dma;
+
+	/* since we are recycling buffers we should seldom need to alloc */
+	if (likely(page))
+		return true;
+
+	/* alloc new page for storage */
+	page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
+	if (unlikely(!page))
+		return false;
+
+	/* map page for use */
+	dma = dma_map_page(rxq->dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
+
+	/* if mapping failed free memory back to system since
+	 * there isn't much point in holding memory we can't use
+	 */
+	if (dma_mapping_error(rxq->dev, dma)) {
+		__free_pages(page, 0);
+		return false;
+	}
+
+	hdr_buf->dma = dma;
+	hdr_buf->page = page;
+	hdr_buf->page_offset = 0;
+
+	return true;
 }
 
 /**
@@ -205,7 +369,59 @@ static bool
 iecm_rx_buf_hw_alloc_all(struct iecm_queue *rxq,
 			 u16 cleaned_count)
 {
-	/* stub */
+	struct iecm_splitq_rx_buf_desc *splitq_rx_desc = NULL;
+	struct iecm_rx_buf *hdr_buf = NULL;
+	u16 nta = rxq->next_to_alloc;
+	struct iecm_rx_buf *buf;
+
+	/* do nothing if no valid netdev defined */
+	if (!rxq->vport->netdev || !cleaned_count)
+		return false;
+
+	splitq_rx_desc = IECM_SPLITQ_RX_BUF_DESC(rxq, nta);
+
+	buf = &rxq->rx_buf.buf[nta];
+	if (rxq->rx_hsplit_en)
+		hdr_buf = &rxq->rx_buf.hdr_buf[nta];
+
+	do {
+		if (rxq->rx_hsplit_en) {
+			if (!iecm_rx_hdr_buf_hw_alloc(rxq, hdr_buf))
+				break;
+
+			splitq_rx_desc->hdr_addr =
+				cpu_to_le64(hdr_buf->dma +
+					    hdr_buf->page_offset);
+			hdr_buf++;
+		}
+
+		if (!iecm_rx_buf_hw_alloc(rxq, buf))
+			break;
+
+		/* Refresh the desc even if buffer_addrs didn't change
+		 * because each write-back erases this info.
+		 */
+		splitq_rx_desc->pkt_addr =
+			cpu_to_le64(buf->dma + buf->page_offset);
+		splitq_rx_desc->qword0.buf_id = cpu_to_le16(nta);
+
+		splitq_rx_desc++;
+		buf++;
+		nta++;
+		if (unlikely(nta == rxq->desc_count)) {
+			splitq_rx_desc = IECM_SPLITQ_RX_BUF_DESC(rxq, 0);
+			buf = rxq->rx_buf.buf;
+			hdr_buf = rxq->rx_buf.hdr_buf;
+			nta = 0;
+		}
+
+		cleaned_count--;
+	} while (cleaned_count);
+
+	if (rxq->next_to_alloc != nta)
+		iecm_rx_buf_hw_update(rxq, nta);
+
+	return !!cleaned_count;
 }
 
 /**
@@ -216,7 +432,44 @@ iecm_rx_buf_hw_alloc_all(struct iecm_queue *rxq,
  */
 static int iecm_rx_buf_alloc_all(struct iecm_queue *rxq)
 {
-	/* stub */
+	int err = 0;
+
+	/* Allocate book keeping buffers */
+	rxq->rx_buf.buf = kcalloc(rxq->desc_count, sizeof(struct iecm_rx_buf),
+				  GFP_KERNEL);
+	if (!rxq->rx_buf.buf) {
+		err = -ENOMEM;
+		goto rx_buf_alloc_all_out;
+	}
+
+	if (rxq->rx_hsplit_en) {
+		rxq->rx_buf.hdr_buf =
+			kcalloc(rxq->desc_count, sizeof(struct iecm_rx_buf),
+				GFP_KERNEL);
+		if (!rxq->rx_buf.hdr_buf) {
+			err = -ENOMEM;
+			goto rx_buf_alloc_all_out;
+		}
+	} else {
+		rxq->rx_buf.hdr_buf = NULL;
+	}
+
+	/* Allocate buffers to be given to HW. Allocate one less than
+	 * total descriptor count as RX splits 4k buffers to 2K and recycles
+	 */
+	if (iecm_is_queue_model_split(rxq->vport->rxq_model)) {
+		if (iecm_rx_buf_hw_alloc_all(rxq,
+					     rxq->desc_count - 1))
+			err = -ENOMEM;
+	} else if (iecm_rx_singleq_buf_hw_alloc_all(rxq,
+						    rxq->desc_count - 1)) {
+		err = -ENOMEM;
+	}
+
+rx_buf_alloc_all_out:
+	if (err)
+		iecm_rx_buf_rel_all(rxq);
+	return err;
 }
 
 /**
@@ -230,7 +483,48 @@ static int iecm_rx_buf_alloc_all(struct iecm_queue *rxq)
 static int iecm_rx_desc_alloc(struct iecm_queue *rxq, bool bufq,
 			      enum virtchnl_queue_model q_model)
 {
-	/* stub */
+	struct device *dev = rxq->dev;
+
+	/* As both single and split descriptors are 32 byte, memory size
+	 * will be same for all three singleq_base Rx, buf., splitq_base
+	 * Rx. So pick anyone of them for size
+	 */
+	if (bufq) {
+		rxq->size = rxq->desc_count *
+			sizeof(struct iecm_splitq_rx_buf_desc);
+	} else {
+		rxq->size = rxq->desc_count *
+			sizeof(union iecm_rx_desc);
+	}
+
+	/* Allocate descriptors and also round up to nearest 4K */
+	rxq->size = ALIGN(rxq->size, 4096);
+	rxq->desc_ring = dmam_alloc_coherent(dev, rxq->size,
+					     &rxq->dma, GFP_KERNEL);
+	if (!rxq->desc_ring) {
+		dev_info(dev, "Unable to allocate memory for the Rx descriptor ring, size=%d\n",
+			 rxq->size);
+		return -ENOMEM;
+	}
+
+	rxq->next_to_alloc = 0;
+	rxq->next_to_clean = 0;
+	rxq->next_to_use = 0;
+	set_bit(__IECM_Q_GEN_CHK, rxq->flags);
+
+	/* Allocate buffers for a Rx queue if the q_model is single OR if it
+	 * is a buffer queue in split queue model
+	 */
+	if (bufq || !iecm_is_queue_model_split(q_model)) {
+		int err = 0;
+
+		err = iecm_rx_buf_alloc_all(rxq);
+		if (err) {
+			iecm_rx_desc_rel(rxq, bufq, q_model);
+			return err;
+		}
+	}
+	return 0;
 }
 
 /**
@@ -241,7 +535,48 @@ static int iecm_rx_desc_alloc(struct iecm_queue *rxq, bool bufq,
  */
 static int iecm_rx_desc_alloc_all(struct iecm_vport *vport)
 {
-	/* stub */
+	struct device *dev = &vport->adapter->pdev->dev;
+	struct iecm_queue *q;
+	int i, j, num_rxq;
+	int err = 0;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		if (iecm_is_queue_model_split(vport->rxq_model))
+			num_rxq = vport->rxq_grps[i].splitq.num_rxq_sets;
+		else
+			num_rxq = vport->rxq_grps[i].singleq.num_rxq;
+
+		for (j = 0; j < num_rxq; j++) {
+			if (iecm_is_queue_model_split(vport->rxq_model))
+				q = &vport->rxq_grps[i].splitq.rxq_sets[j].rxq;
+			else
+				q = &vport->rxq_grps[i].singleq.rxqs[j];
+			err = iecm_rx_desc_alloc(q, false, vport->rxq_model);
+			if (err) {
+				dev_err(dev, "Memory allocation for Rx Queue %u failed\n",
+					i);
+				goto err_out;
+			}
+		}
+
+		if (iecm_is_queue_model_split(vport->rxq_model)) {
+			for (j = 0; j < IECM_BUFQS_PER_RXQ_SET; j++) {
+				q =
+				  &vport->rxq_grps[i].splitq.bufq_sets[j].bufq;
+				err = iecm_rx_desc_alloc(q, true,
+							 vport->rxq_model);
+				if (err) {
+					dev_err(dev, "Memory allocation for Rx Buffer Queue %u failed\n",
+						i);
+					goto err_out;
+				}
+			}
+		}
+	}
+err_out:
+	if (err)
+		iecm_rx_desc_rel_all(vport);
+	return err;
 }
 
 /**
@@ -294,7 +629,23 @@ void iecm_vport_queues_rel(struct iecm_vport *vport)
  */
 static int iecm_vport_init_fast_path_txqs(struct iecm_vport *vport)
 {
-	/* stub */
+	int i, j, k = 0;
+
+	vport->txqs = kcalloc(vport->num_txq, sizeof(struct iecm_queue *),
+			      GFP_KERNEL);
+
+	if (!vport->txqs)
+		return -ENOMEM;
+
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		struct iecm_txq_group *tx_grp = &vport->txq_grps[i];
+
+		for (j = 0; j < tx_grp->num_txq; j++, k++) {
+			vport->txqs[k] = &tx_grp->txqs[j];
+			vport->txqs[k]->idx = k;
+		}
+	}
+	return 0;
 }
 
 /**
@@ -305,7 +656,12 @@ static int iecm_vport_init_fast_path_txqs(struct iecm_vport *vport)
 void iecm_vport_init_num_qs(struct iecm_vport *vport,
 			    struct virtchnl_create_vport *vport_msg)
 {
-	/* stub */
+	vport->num_txq = vport_msg->num_tx_q;
+	vport->num_rxq = vport_msg->num_rx_q;
+	if (iecm_is_queue_model_split(vport->txq_model))
+		vport->num_complq = vport_msg->num_tx_complq;
+	if (iecm_is_queue_model_split(vport->rxq_model))
+		vport->num_bufq = vport_msg->num_rx_bufq;
 }
 
 /**
@@ -314,7 +670,32 @@ void iecm_vport_init_num_qs(struct iecm_vport *vport,
  */
 void iecm_vport_calc_num_q_desc(struct iecm_vport *vport)
 {
-	/* stub */
+	int num_req_txq_desc = vport->adapter->config_data.num_req_txq_desc;
+	int num_req_rxq_desc = vport->adapter->config_data.num_req_rxq_desc;
+
+	vport->complq_desc_count = 0;
+	vport->bufq_desc_count = 0;
+	if (num_req_txq_desc) {
+		vport->txq_desc_count = num_req_txq_desc;
+		if (iecm_is_queue_model_split(vport->txq_model))
+			vport->complq_desc_count = num_req_txq_desc;
+	} else {
+		vport->txq_desc_count =
+			IECM_DFLT_TX_Q_DESC_COUNT;
+		if (iecm_is_queue_model_split(vport->txq_model)) {
+			vport->complq_desc_count =
+				IECM_DFLT_TX_COMPLQ_DESC_COUNT;
+		}
+	}
+	if (num_req_rxq_desc) {
+		vport->rxq_desc_count = num_req_rxq_desc;
+		if (iecm_is_queue_model_split(vport->rxq_model))
+			vport->bufq_desc_count = num_req_rxq_desc;
+	} else {
+		vport->rxq_desc_count = IECM_DFLT_RX_Q_DESC_COUNT;
+		if (iecm_is_queue_model_split(vport->rxq_model))
+			vport->bufq_desc_count = IECM_DFLT_RX_BUFQ_DESC_COUNT;
+	}
 }
 EXPORT_SYMBOL(iecm_vport_calc_num_q_desc);
 
@@ -326,7 +707,51 @@ EXPORT_SYMBOL(iecm_vport_calc_num_q_desc);
 void iecm_vport_calc_total_qs(struct virtchnl_create_vport *vport_msg,
 			      int num_req_qs)
 {
-	/* stub */
+	int dflt_splitq_txq_grps, dflt_singleq_txqs;
+	int dflt_splitq_rxq_grps, dflt_singleq_rxqs;
+	int num_txq_grps, num_rxq_grps;
+	int num_cpus;
+
+	/* Restrict num of queues to cpus online as a default configuration to
+	 * give best performance. User can always override to a max number
+	 * of queues via ethtool.
+	 */
+	num_cpus = num_online_cpus();
+	dflt_splitq_txq_grps = min_t(int, IECM_DFLT_SPLITQ_TX_Q_GROUPS,
+				     num_cpus);
+	dflt_singleq_txqs = min_t(int, IECM_DFLT_SINGLEQ_TXQ_PER_GROUP,
+				  num_cpus);
+	dflt_splitq_rxq_grps = min_t(int, IECM_DFLT_SPLITQ_RX_Q_GROUPS,
+				     num_cpus);
+	dflt_singleq_rxqs = min_t(int, IECM_DFLT_SINGLEQ_RXQ_PER_GROUP,
+				  num_cpus);
+
+	if (iecm_is_queue_model_split(vport_msg->txq_model)) {
+		num_txq_grps = num_req_qs ? num_req_qs : dflt_splitq_txq_grps;
+		vport_msg->num_tx_complq = num_txq_grps *
+			IECM_COMPLQ_PER_GROUP;
+		vport_msg->num_tx_q = num_txq_grps *
+				      IECM_DFLT_SPLITQ_TXQ_PER_GROUP;
+	} else {
+		num_txq_grps = IECM_DFLT_SINGLEQ_TX_Q_GROUPS;
+		vport_msg->num_tx_q = num_txq_grps *
+				      (num_req_qs ? num_req_qs :
+				       dflt_singleq_txqs);
+		vport_msg->num_tx_complq = 0;
+	}
+	if (iecm_is_queue_model_split(vport_msg->rxq_model)) {
+		num_rxq_grps = num_req_qs ? num_req_qs : dflt_splitq_rxq_grps;
+		vport_msg->num_rx_bufq = num_rxq_grps *
+					 IECM_BUFQS_PER_RXQ_SET;
+		vport_msg->num_rx_q = num_rxq_grps *
+				      IECM_DFLT_SPLITQ_RXQ_PER_GROUP;
+	} else {
+		num_rxq_grps = IECM_DFLT_SINGLEQ_RX_Q_GROUPS;
+		vport_msg->num_rx_bufq = 0;
+		vport_msg->num_rx_q = num_rxq_grps *
+				      (num_req_qs ? num_req_qs :
+				       dflt_singleq_rxqs);
+	}
 }
 
 /**
@@ -335,7 +760,15 @@ void iecm_vport_calc_total_qs(struct virtchnl_create_vport *vport_msg,
  */
 void iecm_vport_calc_num_q_groups(struct iecm_vport *vport)
 {
-	/* stub */
+	if (iecm_is_queue_model_split(vport->txq_model))
+		vport->num_txq_grp = vport->num_txq;
+	else
+		vport->num_txq_grp = IECM_DFLT_SINGLEQ_TX_Q_GROUPS;
+
+	if (iecm_is_queue_model_split(vport->rxq_model))
+		vport->num_rxq_grp = vport->num_rxq;
+	else
+		vport->num_rxq_grp = IECM_DFLT_SINGLEQ_RX_Q_GROUPS;
 }
 EXPORT_SYMBOL(iecm_vport_calc_num_q_groups);
 
@@ -348,7 +781,15 @@ EXPORT_SYMBOL(iecm_vport_calc_num_q_groups);
 static void iecm_vport_calc_numq_per_grp(struct iecm_vport *vport,
 					 int *num_txq, int *num_rxq)
 {
-	/* stub */
+	if (iecm_is_queue_model_split(vport->txq_model))
+		*num_txq = IECM_DFLT_SPLITQ_TXQ_PER_GROUP;
+	else
+		*num_txq = vport->num_txq;
+
+	if (iecm_is_queue_model_split(vport->rxq_model))
+		*num_rxq = IECM_DFLT_SPLITQ_RXQ_PER_GROUP;
+	else
+		*num_rxq = vport->num_rxq;
 }
 
 /**
@@ -359,7 +800,10 @@ static void iecm_vport_calc_numq_per_grp(struct iecm_vport *vport,
  */
 void iecm_vport_calc_num_q_vec(struct iecm_vport *vport)
 {
-	/* stub */
+	if (iecm_is_queue_model_split(vport->txq_model))
+		vport->num_q_vectors = vport->num_txq_grp;
+	else
+		vport->num_q_vectors = vport->num_txq;
 }
 
 /**
@@ -371,7 +815,68 @@ void iecm_vport_calc_num_q_vec(struct iecm_vport *vport)
  */
 static int iecm_txq_group_alloc(struct iecm_vport *vport, int num_txq)
 {
-	/* stub */
+	struct iecm_itr tx_itr = { 0 };
+	int err = 0;
+	int i;
+
+	vport->txq_grps = kcalloc(vport->num_txq_grp,
+				  sizeof(*vport->txq_grps), GFP_KERNEL);
+	if (!vport->txq_grps)
+		return -ENOMEM;
+
+	tx_itr.target_itr = IECM_ITR_TX_DEF;
+	tx_itr.itr_idx = VIRTCHNL_ITR_IDX_1;
+	tx_itr.next_update = jiffies + 1;
+
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		struct iecm_txq_group *tx_qgrp = &vport->txq_grps[i];
+		int j;
+
+		tx_qgrp->vport = vport;
+		tx_qgrp->num_txq = num_txq;
+		tx_qgrp->txqs = kcalloc(num_txq, sizeof(*tx_qgrp->txqs),
+					GFP_KERNEL);
+		if (!tx_qgrp->txqs) {
+			err = -ENOMEM;
+			goto err_alloc;
+		}
+
+		for (j = 0; j < tx_qgrp->num_txq; j++) {
+			struct iecm_queue *q = &tx_qgrp->txqs[j];
+
+			q->dev = &vport->adapter->pdev->dev;
+			q->desc_count = vport->txq_desc_count;
+			q->vport = vport;
+			q->txq_grp = tx_qgrp;
+			hash_init(q->sched_buf_hash);
+
+			if (!iecm_is_queue_model_split(vport->txq_model))
+				q->itr = tx_itr;
+		}
+
+		if (!iecm_is_queue_model_split(vport->txq_model))
+			continue;
+
+		tx_qgrp->complq = kcalloc(IECM_COMPLQ_PER_GROUP,
+					  sizeof(*tx_qgrp->complq),
+					  GFP_KERNEL);
+		if (!tx_qgrp->complq) {
+			err = -ENOMEM;
+			goto err_alloc;
+		}
+
+		tx_qgrp->complq->dev = &vport->adapter->pdev->dev;
+		tx_qgrp->complq->desc_count = vport->complq_desc_count;
+		tx_qgrp->complq->vport = vport;
+		tx_qgrp->complq->txq_grp = tx_qgrp;
+
+		tx_qgrp->complq->itr = tx_itr;
+	}
+
+err_alloc:
+	if (err)
+		iecm_txq_group_rel(vport);
+	return err;
 }
 
 /**
@@ -383,7 +888,115 @@ static int iecm_txq_group_alloc(struct iecm_vport *vport, int num_txq)
  */
 static int iecm_rxq_group_alloc(struct iecm_vport *vport, int num_rxq)
 {
-	/* stub */
+	struct iecm_itr rx_itr = {0};
+	struct iecm_queue *q;
+	int i, err = 0;
+
+	vport->rxq_grps = kcalloc(vport->num_rxq_grp,
+				  sizeof(struct iecm_rxq_group), GFP_KERNEL);
+	if (!vport->rxq_grps)
+		return -ENOMEM;
+
+	rx_itr.target_itr = IECM_ITR_RX_DEF;
+	rx_itr.itr_idx = VIRTCHNL_ITR_IDX_0;
+	rx_itr.next_update = jiffies + 1;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct iecm_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+		int j;
+
+		rx_qgrp->vport = vport;
+		if (iecm_is_queue_model_split(vport->rxq_model)) {
+			rx_qgrp->splitq.num_rxq_sets = num_rxq;
+			rx_qgrp->splitq.rxq_sets =
+				kcalloc(num_rxq,
+					sizeof(struct iecm_rxq_set),
+					GFP_KERNEL);
+			if (!rx_qgrp->splitq.rxq_sets) {
+				err = -ENOMEM;
+				goto err_alloc;
+			}
+
+			rx_qgrp->splitq.bufq_sets =
+				kcalloc(IECM_BUFQS_PER_RXQ_SET,
+					sizeof(struct iecm_bufq_set),
+					GFP_KERNEL);
+			if (!rx_qgrp->splitq.bufq_sets) {
+				err = -ENOMEM;
+				goto err_alloc;
+			}
+
+			for (j = 0; j < IECM_BUFQS_PER_RXQ_SET; j++) {
+				int swq_size = sizeof(struct iecm_sw_queue);
+
+				q = &rx_qgrp->splitq.bufq_sets[j].bufq;
+				q->dev = &vport->adapter->pdev->dev;
+				q->desc_count = vport->bufq_desc_count;
+				q->vport = vport;
+				q->rxq_grp = rx_qgrp;
+				q->idx = j;
+				q->rx_buf_size = IECM_RX_BUF_2048;
+				q->rsc_low_watermark = IECM_LOW_WATERMARK;
+				q->rx_buf_stride = IECM_RX_BUF_STRIDE;
+				q->itr = rx_itr;
+
+				if (vport->rx_hsplit_en) {
+					q->rx_hsplit_en = vport->rx_hsplit_en;
+					q->rx_hbuf_size = IECM_HDR_BUF_SIZE;
+				}
+
+				rx_qgrp->splitq.bufq_sets[j].num_refillqs =
+					num_rxq;
+				rx_qgrp->splitq.bufq_sets[j].refillqs =
+					kcalloc(num_rxq, swq_size, GFP_KERNEL);
+				if (!rx_qgrp->splitq.bufq_sets[j].refillqs) {
+					err = -ENOMEM;
+					goto err_alloc;
+				}
+			}
+		} else {
+			rx_qgrp->singleq.num_rxq = num_rxq;
+			rx_qgrp->singleq.rxqs = kcalloc(num_rxq,
+							sizeof(struct iecm_queue),
+							GFP_KERNEL);
+			if (!rx_qgrp->singleq.rxqs)  {
+				err = -ENOMEM;
+				goto err_alloc;
+			}
+		}
+
+		for (j = 0; j < num_rxq; j++) {
+			if (iecm_is_queue_model_split(vport->rxq_model)) {
+				q = &rx_qgrp->splitq.rxq_sets[j].rxq;
+				rx_qgrp->splitq.rxq_sets[j].refillq0 =
+				      &rx_qgrp->splitq.bufq_sets[0].refillqs[j];
+				rx_qgrp->splitq.rxq_sets[j].refillq1 =
+				      &rx_qgrp->splitq.bufq_sets[1].refillqs[j];
+
+				if (vport->rx_hsplit_en) {
+					q->rx_hsplit_en = vport->rx_hsplit_en;
+					q->rx_hbuf_size = IECM_HDR_BUF_SIZE;
+				}
+
+			} else {
+				q = &rx_qgrp->singleq.rxqs[j];
+			}
+			q->dev = &vport->adapter->pdev->dev;
+			q->desc_count = vport->rxq_desc_count;
+			q->vport = vport;
+			q->rxq_grp = rx_qgrp;
+			q->idx = (i * num_rxq) + j;
+			q->rx_buf_size = IECM_RX_BUF_2048;
+			q->rsc_low_watermark = IECM_LOW_WATERMARK;
+			q->rx_max_pkt_size = vport->netdev->mtu +
+					     IECM_PACKET_HDR_PAD;
+			q->itr = rx_itr;
+		}
+	}
+err_alloc:
+	if (err)
+		iecm_rxq_group_rel(vport);
+	return err;
 }
 
 /**
@@ -394,7 +1007,20 @@ static int iecm_rxq_group_alloc(struct iecm_vport *vport, int num_rxq)
  */
 static int iecm_vport_queue_grp_alloc_all(struct iecm_vport *vport)
 {
-	/* stub */
+	int num_txq, num_rxq;
+	int err;
+
+	iecm_vport_calc_numq_per_grp(vport, &num_txq, &num_rxq);
+
+	err = iecm_txq_group_alloc(vport, num_txq);
+	if (err)
+		goto err_out;
+
+	err = iecm_rxq_group_alloc(vport, num_rxq);
+err_out:
+	if (err)
+		iecm_vport_queue_grp_rel_all(vport);
+	return err;
 }
 
 /**
@@ -406,7 +1032,28 @@ static int iecm_vport_queue_grp_alloc_all(struct iecm_vport *vport)
  */
 int iecm_vport_queues_alloc(struct iecm_vport *vport)
 {
-	/* stub */
+	int err;
+
+	err = iecm_vport_queue_grp_alloc_all(vport);
+	if (err)
+		goto err_out;
+
+	err = iecm_tx_desc_alloc_all(vport);
+	if (err)
+		goto err_out;
+
+	err = iecm_rx_desc_alloc_all(vport);
+	if (err)
+		goto err_out;
+
+	err = iecm_vport_init_fast_path_txqs(vport);
+	if (err)
+		goto err_out;
+
+	return 0;
+err_out:
+	iecm_vport_queues_rel(vport);
+	return err;
 }
 
 /**
@@ -1794,7 +2441,16 @@ EXPORT_SYMBOL(iecm_vport_calc_num_q_vec);
  */
 int iecm_config_rss(struct iecm_vport *vport)
 {
-	/* stub */
+	int err = iecm_send_get_set_rss_key_msg(vport, false);
+
+	if (!err)
+		err = vport->adapter->dev_ops.vc_ops.get_set_rss_lut(vport,
+								     false);
+	if (!err)
+		err = vport->adapter->dev_ops.vc_ops.get_set_rss_hash(vport,
+								      false);
+
+	return err;
 }
 
 /**
@@ -1806,7 +2462,20 @@ int iecm_config_rss(struct iecm_vport *vport)
  */
 void iecm_get_rx_qid_list(struct iecm_vport *vport, u16 *qid_list)
 {
-	/* stub */
+	int i, j, k = 0;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct iecm_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+
+		if (iecm_is_queue_model_split(vport->rxq_model)) {
+			for (j = 0; j < rx_qgrp->splitq.num_rxq_sets; j++)
+				qid_list[k++] =
+					rx_qgrp->splitq.rxq_sets[j].rxq.q_id;
+		} else {
+			for (j = 0; j < rx_qgrp->singleq.num_rxq; j++)
+				qid_list[k++] = rx_qgrp->singleq.rxqs[j].q_id;
+		}
+	}
 }
 
 /**
@@ -1818,7 +2487,13 @@ void iecm_get_rx_qid_list(struct iecm_vport *vport, u16 *qid_list)
  */
 void iecm_fill_dflt_rss_lut(struct iecm_vport *vport, u16 *qid_list)
 {
-	/* stub */
+	int num_lut_segs, lut_seg, i, k = 0;
+
+	num_lut_segs = vport->adapter->rss_data.rss_lut_size / vport->num_rxq;
+	for (lut_seg = 0; lut_seg < num_lut_segs; lut_seg++) {
+		for (i = 0; i < vport->num_rxq; i++)
+			vport->adapter->rss_data.rss_lut[k++] = qid_list[i];
+	}
 }
 
 /**
@@ -1829,7 +2504,64 @@ void iecm_fill_dflt_rss_lut(struct iecm_vport *vport, u16 *qid_list)
  */
 int iecm_init_rss(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	u16 *qid_list;
+
+	adapter->rss_data.rss_key = kzalloc(adapter->rss_data.rss_key_size,
+					    GFP_KERNEL);
+	if (!adapter->rss_data.rss_key)
+		return -ENOMEM;
+	adapter->rss_data.rss_lut = kzalloc(adapter->rss_data.rss_lut_size,
+					    GFP_KERNEL);
+	if (!adapter->rss_data.rss_lut) {
+		kfree(adapter->rss_data.rss_key);
+		adapter->rss_data.rss_key = NULL;
+		return -ENOMEM;
+	}
+
+	/* Initialize default rss key */
+	netdev_rss_key_fill((void *)adapter->rss_data.rss_key,
+			    adapter->rss_data.rss_key_size);
+
+	/* Initialize default rss lut */
+	if (adapter->rss_data.rss_lut_size % vport->num_rxq) {
+		u16 dflt_qid;
+		int i;
+
+		/* Set all entries to a default RX queue if the algorithm below
+		 * won't fill all entries
+		 */
+		if (iecm_is_queue_model_split(vport->rxq_model))
+			dflt_qid =
+				vport->rxq_grps[0].splitq.rxq_sets[0].rxq.q_id;
+		else
+			dflt_qid =
+				vport->rxq_grps[0].singleq.rxqs[0].q_id;
+
+		for (i = 0; i < adapter->rss_data.rss_lut_size; i++)
+			adapter->rss_data.rss_lut[i] = dflt_qid;
+	}
+
+	qid_list = kcalloc(vport->num_rxq, sizeof(u16), GFP_KERNEL);
+	if (!qid_list) {
+		kfree(adapter->rss_data.rss_lut);
+		adapter->rss_data.rss_lut = NULL;
+		kfree(adapter->rss_data.rss_key);
+		adapter->rss_data.rss_key = NULL;
+		return -ENOMEM;
+	}
+
+	iecm_get_rx_qid_list(vport, qid_list);
+
+	/* Fill the default RSS lut values*/
+	iecm_fill_dflt_rss_lut(vport, qid_list);
+
+	kfree(qid_list);
+
+	 /* Initialize default rss HASH */
+	adapter->rss_data.rss_hash = IECM_DEFAULT_RSS_HASH_EXPANDED;
+
+	return iecm_config_rss(vport);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
index b8cf8eb15052..36b284aa8be2 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
@@ -663,7 +663,19 @@ int iecm_send_destroy_vport_msg(struct iecm_vport *vport)
  */
 int iecm_send_enable_vport_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	struct virtchnl_vport v_id;
+	int err;
+
+	v_id.vport_id = vport->vport_id;
+
+	err = iecm_send_mb_msg(adapter, VIRTCHNL_OP_ENABLE_VPORT,
+			       sizeof(v_id), (u8 *)&v_id);
+	if (err)
+		return err;
+
+	return iecm_wait_for_event(adapter, IECM_VC_ENA_VPORT,
+				   IECM_VC_ENA_VPORT_ERR);
 }
 
 /**
@@ -1839,7 +1851,27 @@ EXPORT_SYMBOL(iecm_vc_core_init);
 static void iecm_vport_init(struct iecm_vport *vport,
 			    __always_unused int vport_id)
 {
-	/* stub */
+	struct virtchnl_create_vport *vport_msg;
+
+	vport_msg = (struct virtchnl_create_vport *)
+				vport->adapter->vport_params_recvd[0];
+	vport->txq_model = vport_msg->txq_model;
+	vport->rxq_model = vport_msg->rxq_model;
+	vport->vport_type = (u16)vport_msg->vport_type;
+	vport->vport_id = vport_msg->vport_id;
+	vport->adapter->rss_data.rss_key_size = min_t(u16, NETDEV_RSS_KEY_LEN,
+						      vport_msg->rss_key_size);
+	vport->adapter->rss_data.rss_lut_size = vport_msg->rss_lut_size;
+	ether_addr_copy(vport->default_mac_addr, vport_msg->default_mac_addr);
+	vport->max_mtu = IECM_MAX_MTU;
+
+	iecm_vport_set_hsplit(vport, NULL);
+
+	init_waitqueue_head(&vport->sw_marker_wq);
+	iecm_vport_init_num_qs(vport, vport_msg);
+	iecm_vport_calc_num_q_desc(vport);
+	iecm_vport_calc_num_q_groups(vport);
+	iecm_vport_calc_num_q_vec(vport);
 }
 
 /**
-- 
2.26.2

