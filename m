Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C9F229C67
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733294AbgGVP4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:56:47 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53150 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733221AbgGVP4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:56:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MFsX24008864;
        Wed, 22 Jul 2020 08:56:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=zS0D2xqWH6fEMmnPectJQZgM/k93cgYZ441B5zCe7LU=;
 b=uxMVbug3ypvh2I6zrY/ToN3fE5Kc+SWwTOE93OXndsb+K6/D1PH44fKKH2aAMAAco/z+
 LHfOnXlYeRkP2AuHQzX5VIcRFfPMN9sbNugOnPKvugO3g8WyAcSHj3iCf1dpXrdBRPjP
 JijGh0gDov4Kn8vkE3p3L+Br+ue/QbpfGpn9RBMbxyRNIB7GVmlILXTi+vy7ahkPy8QM
 ngVHDTpA0ivzCCSDsoFRDE/jUGRXEr4uyxrQ5vg9mnanLgS5ZBYCOIDjynZB7rYhzy26
 0SOvj9LNYALo+pgEReHGsSbOsSRMlYTs7EUrG0HM0e4HueaCdpyaytuIT06r6yl4ouci 1g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkrkrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 08:55:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 08:55:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 08:55:58 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 326E43F703F;
        Wed, 22 Jul 2020 08:55:51 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Doug Ledford" <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 14/15] qede: refactor XDP Tx processing
Date:   Wed, 22 Jul 2020 18:53:48 +0300
Message-ID: <20200722155349.747-15-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722155349.747-1-alobakin@marvell.com>
References: <20200722155349.747-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_09:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current XDP Tx logic is suboptimal and can't be reused for XDP_REDIRECT
path.
Make qede_xdp_{tx_int,xmit}() more universal and effective in general to
allow future expanding.

Misc: use unlikely() hints where appropriate and replace "fallthrough"
comments with pseudo-keywords.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h    |  1 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 89 +++++++++++-----------
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index e8ed0bb94ee0..308c66a5f98f 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -455,6 +455,7 @@ struct qede_fastpath {
 	u8				id;
 
 	u8				xdp_xmit;
+#define QEDE_XDP_TX			BIT(0)
 
 	struct napi_struct		napi;
 	struct qed_sb_info		*sb_info;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 1c4ece0713f8..c80bf6d37b89 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -302,48 +302,37 @@ static inline void qede_update_tx_producer(struct qede_tx_queue *txq)
 	wmb();
 }
 
-static int qede_xdp_xmit(struct qede_dev *edev, struct qede_fastpath *fp,
-			 struct sw_rx_data *metadata, u16 padding, u16 length)
+static int qede_xdp_xmit(struct qede_tx_queue *txq, dma_addr_t dma, u16 pad,
+			 u16 len, struct page *page)
 {
-	struct qede_tx_queue *txq = fp->xdp_tx;
-	struct eth_tx_1st_bd *first_bd;
-	u16 idx = txq->sw_tx_prod;
+	struct eth_tx_1st_bd *bd;
+	struct sw_tx_xdp *xdp;
 	u16 val;
 
-	if (!qed_chain_get_elem_left(&txq->tx_pbl)) {
+	if (unlikely(qed_chain_get_elem_used(&txq->tx_pbl) >=
+		     txq->num_tx_buffers)) {
 		txq->stopped_cnt++;
 		return -ENOMEM;
 	}
 
-	first_bd = (struct eth_tx_1st_bd *)qed_chain_produce(&txq->tx_pbl);
+	bd = qed_chain_produce(&txq->tx_pbl);
+	bd->data.nbds = 1;
+	bd->data.bd_flags.bitfields = BIT(ETH_TX_1ST_BD_FLAGS_START_BD_SHIFT);
 
-	memset(first_bd, 0, sizeof(*first_bd));
-	first_bd->data.bd_flags.bitfields =
-	    BIT(ETH_TX_1ST_BD_FLAGS_START_BD_SHIFT);
-
-	val = (length & ETH_TX_DATA_1ST_BD_PKT_LEN_MASK) <<
+	val = (len & ETH_TX_DATA_1ST_BD_PKT_LEN_MASK) <<
 	       ETH_TX_DATA_1ST_BD_PKT_LEN_SHIFT;
 
-	first_bd->data.bitfields |= cpu_to_le16(val);
-	first_bd->data.nbds = 1;
+	bd->data.bitfields = cpu_to_le16(val);
 
 	/* We can safely ignore the offset, as it's 0 for XDP */
-	BD_SET_UNMAP_ADDR_LEN(first_bd, metadata->mapping + padding, length);
+	BD_SET_UNMAP_ADDR_LEN(bd, dma + pad, len);
 
-	/* Synchronize the buffer back to device, as program [probably]
-	 * has changed it.
-	 */
-	dma_sync_single_for_device(&edev->pdev->dev,
-				   metadata->mapping + padding,
-				   length, PCI_DMA_TODEVICE);
+	xdp = txq->sw_tx_ring.xdp + txq->sw_tx_prod;
+	xdp->mapping = dma;
+	xdp->page = page;
 
-	txq->sw_tx_ring.xdp[idx].page = metadata->data;
-	txq->sw_tx_ring.xdp[idx].mapping = metadata->mapping;
 	txq->sw_tx_prod = (txq->sw_tx_prod + 1) % txq->num_tx_buffers;
 
-	/* Mark the fastpath for future XDP doorbell */
-	fp->xdp_xmit = 1;
-
 	return 0;
 }
 
@@ -362,20 +351,21 @@ int qede_txq_has_work(struct qede_tx_queue *txq)
 
 static void qede_xdp_tx_int(struct qede_dev *edev, struct qede_tx_queue *txq)
 {
-	u16 hw_bd_cons, idx;
+	struct sw_tx_xdp *xdp_info, *xdp_arr = txq->sw_tx_ring.xdp;
+	struct device *dev = &edev->pdev->dev;
+	u16 hw_bd_cons;
 
 	hw_bd_cons = le16_to_cpu(*txq->hw_cons_ptr);
 	barrier();
 
 	while (hw_bd_cons != qed_chain_get_cons_idx(&txq->tx_pbl)) {
-		qed_chain_consume(&txq->tx_pbl);
-		idx = txq->sw_tx_cons;
+		xdp_info = xdp_arr + txq->sw_tx_cons;
 
-		dma_unmap_page(&edev->pdev->dev,
-			       txq->sw_tx_ring.xdp[idx].mapping,
-			       PAGE_SIZE, DMA_BIDIRECTIONAL);
-		__free_page(txq->sw_tx_ring.xdp[idx].page);
+		dma_unmap_page(dev, xdp_info->mapping, PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
+		__free_page(xdp_info->page);
 
+		qed_chain_consume(&txq->tx_pbl);
 		txq->sw_tx_cons = (txq->sw_tx_cons + 1) % txq->num_tx_buffers;
 		txq->xmit_pkts++;
 	}
@@ -1064,32 +1054,39 @@ static bool qede_rx_xdp(struct qede_dev *edev,
 	switch (act) {
 	case XDP_TX:
 		/* We need the replacement buffer before transmit. */
-		if (qede_alloc_rx_buffer(rxq, true)) {
+		if (unlikely(qede_alloc_rx_buffer(rxq, true))) {
 			qede_recycle_rx_bd_ring(rxq, 1);
+
 			trace_xdp_exception(edev->ndev, prog, act);
-			return false;
+			break;
 		}
 
 		/* Now if there's a transmission problem, we'd still have to
 		 * throw current buffer, as replacement was already allocated.
 		 */
-		if (qede_xdp_xmit(edev, fp, bd, *data_offset, *len)) {
-			dma_unmap_page(rxq->dev, bd->mapping,
-				       PAGE_SIZE, DMA_BIDIRECTIONAL);
+		if (unlikely(qede_xdp_xmit(fp->xdp_tx, bd->mapping,
+					   *data_offset, *len, bd->data))) {
+			dma_unmap_page(rxq->dev, bd->mapping, PAGE_SIZE,
+				       rxq->data_direction);
 			__free_page(bd->data);
+
 			trace_xdp_exception(edev->ndev, prog, act);
+		} else {
+			dma_sync_single_for_device(rxq->dev,
+						   bd->mapping + *data_offset,
+						   *len, rxq->data_direction);
+			fp->xdp_xmit |= QEDE_XDP_TX;
 		}
 
 		/* Regardless, we've consumed an Rx BD */
 		qede_rx_bd_ring_consume(rxq);
-		return false;
-
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* Fall through */
+		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(edev->ndev, prog, act);
-		/* Fall through */
+		fallthrough;
 	case XDP_DROP:
 		qede_recycle_rx_bd_ring(rxq, cqe->bd_num);
 	}
@@ -1353,6 +1350,9 @@ int qede_poll(struct napi_struct *napi, int budget)
 						napi);
 	struct qede_dev *edev = fp->edev;
 	int rx_work_done = 0;
+	u16 xdp_prod;
+
+	fp->xdp_xmit = 0;
 
 	if (likely(fp->type & QEDE_FASTPATH_TX)) {
 		int cos;
@@ -1380,10 +1380,9 @@ int qede_poll(struct napi_struct *napi, int budget)
 		}
 	}
 
-	if (fp->xdp_xmit) {
-		u16 xdp_prod = qed_chain_get_prod_idx(&fp->xdp_tx->tx_pbl);
+	if (fp->xdp_xmit & QEDE_XDP_TX) {
+		xdp_prod = qed_chain_get_prod_idx(&fp->xdp_tx->tx_pbl);
 
-		fp->xdp_xmit = 0;
 		fp->xdp_tx->tx_db.data.bd_prod = cpu_to_le16(xdp_prod);
 		qede_update_tx_producer(fp->xdp_tx);
 	}
-- 
2.25.1

