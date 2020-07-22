Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5277229C5E
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733262AbgGVP40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:56:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19592 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733241AbgGVP4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:56:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MFsbKs008880;
        Wed, 22 Jul 2020 08:56:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=3Po8RfnWucc3DJIq3LC7D4FFGro0yJZkEt/sSt+5JX0=;
 b=pC8Wy6sUi1EZtC8ulDQYTuOTsjBKPZlVSOR16JqH0/RzLVi396L/3OwcgNjVUkhgJASO
 Qn9MptpObwUsLPROXgDyFxmn9A3WpwGRy8HwQMBqadxSvUUWmr4m1npKsblWYWun+KYc
 3sjZgKxBYMZEcZxlLr804qaYX6ZHoseOFy2IG32Z2I3U7mRsxFNyiRhiWJW7mrjykzjN
 zfBpfsC1DT06OQqB6w/I2myPfPNuIz55m45plO/FC058dPto4Neuo81wOsvqxI7kBnBr
 gGSbLoU0u4CKGeStatmUchMMDvKJSb2TKo8PM1ZPwZH5oN2qOMaGdwYlSaqwoAdMi3IG lQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkrks5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 08:56:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 08:56:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 08:56:04 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 6B5803F703F;
        Wed, 22 Jul 2020 08:55:58 -0700 (PDT)
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
Subject: [PATCH net-next 15/15] qede: add .ndo_xdp_xmit() and XDP_REDIRECT support
Date:   Wed, 22 Jul 2020 18:53:49 +0300
Message-ID: <20200722155349.747-16-alobakin@marvell.com>
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

Add XDP_REDIRECT case handling and the corresponding NDO to support
redirecting XDP frames. This also includes registering driver memory
model (currently order-0 page mode) in BPF subsystem.
The total number of XDP queues is usually 1:1 with Rx ones.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h      |  8 ++
 drivers/net/ethernet/qlogic/qede/qede_fp.c   | 97 +++++++++++++++++++-
 drivers/net/ethernet/qlogic/qede/qede_main.c | 18 ++++
 3 files changed, 118 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 308c66a5f98f..803c1fcca8ad 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -199,6 +199,7 @@ struct qede_dev {
 	u8				fp_num_rx;
 	u16				req_queues;
 	u16				num_queues;
+	u16				total_xdp_queues;
 
 #define QEDE_QUEUE_CNT(edev)		((edev)->num_queues)
 #define QEDE_RSS_COUNT(edev)		((edev)->num_queues - (edev)->fp_num_tx)
@@ -381,6 +382,7 @@ struct sw_tx_bd {
 
 struct sw_tx_xdp {
 	struct page			*page;
+	struct xdp_frame		*xdpf;
 	dma_addr_t			mapping;
 };
 
@@ -403,6 +405,9 @@ struct qede_tx_queue {
 	void __iomem			*doorbell_addr;
 	union db_prod			tx_db;
 
+	/* Spinlock for XDP queues in case of XDP_REDIRECT */
+	spinlock_t			xdp_tx_lock;
+
 	int				index; /* Slowpath only */
 #define QEDE_TXQ_XDP_TO_IDX(edev, txq)	((txq)->index - \
 					 QEDE_MAX_TSS_CNT(edev))
@@ -456,6 +461,7 @@ struct qede_fastpath {
 
 	u8				xdp_xmit;
 #define QEDE_XDP_TX			BIT(0)
+#define QEDE_XDP_REDIRECT		BIT(1)
 
 	struct napi_struct		napi;
 	struct qed_sb_info		*sb_info;
@@ -516,6 +522,8 @@ struct qede_reload_args {
 
 /* Datapath functions definition */
 netdev_tx_t qede_start_xmit(struct sk_buff *skb, struct net_device *ndev);
+int qede_xdp_transmit(struct net_device *dev, int n_frames,
+		      struct xdp_frame **frames, u32 flags);
 u16 qede_select_queue(struct net_device *dev, struct sk_buff *skb,
 		      struct net_device *sb_dev);
 netdev_features_t qede_features_check(struct sk_buff *skb,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index c80bf6d37b89..a2494bf85007 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -303,7 +303,7 @@ static inline void qede_update_tx_producer(struct qede_tx_queue *txq)
 }
 
 static int qede_xdp_xmit(struct qede_tx_queue *txq, dma_addr_t dma, u16 pad,
-			 u16 len, struct page *page)
+			 u16 len, struct page *page, struct xdp_frame *xdpf)
 {
 	struct eth_tx_1st_bd *bd;
 	struct sw_tx_xdp *xdp;
@@ -330,12 +330,66 @@ static int qede_xdp_xmit(struct qede_tx_queue *txq, dma_addr_t dma, u16 pad,
 	xdp = txq->sw_tx_ring.xdp + txq->sw_tx_prod;
 	xdp->mapping = dma;
 	xdp->page = page;
+	xdp->xdpf = xdpf;
 
 	txq->sw_tx_prod = (txq->sw_tx_prod + 1) % txq->num_tx_buffers;
 
 	return 0;
 }
 
+int qede_xdp_transmit(struct net_device *dev, int n_frames,
+		      struct xdp_frame **frames, u32 flags)
+{
+	struct qede_dev *edev = netdev_priv(dev);
+	struct device *dmadev = &edev->pdev->dev;
+	struct qede_tx_queue *xdp_tx;
+	struct xdp_frame *xdpf;
+	dma_addr_t mapping;
+	int i, drops = 0;
+	u16 xdp_prod;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	if (unlikely(!netif_running(dev)))
+		return -ENETDOWN;
+
+	i = smp_processor_id() % edev->total_xdp_queues;
+	xdp_tx = edev->fp_array[i].xdp_tx;
+
+	spin_lock(&xdp_tx->xdp_tx_lock);
+
+	for (i = 0; i < n_frames; i++) {
+		xdpf = frames[i];
+
+		mapping = dma_map_single(dmadev, xdpf->data, xdpf->len,
+					 DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dmadev, mapping))) {
+			xdp_return_frame_rx_napi(xdpf);
+			drops++;
+
+			continue;
+		}
+
+		if (unlikely(qede_xdp_xmit(xdp_tx, mapping, 0, xdpf->len,
+					   NULL, xdpf))) {
+			xdp_return_frame_rx_napi(xdpf);
+			drops++;
+		}
+	}
+
+	if (flags & XDP_XMIT_FLUSH) {
+		xdp_prod = qed_chain_get_prod_idx(&xdp_tx->tx_pbl);
+
+		xdp_tx->tx_db.data.bd_prod = cpu_to_le16(xdp_prod);
+		qede_update_tx_producer(xdp_tx);
+	}
+
+	spin_unlock(&xdp_tx->xdp_tx_lock);
+
+	return n_frames - drops;
+}
+
 int qede_txq_has_work(struct qede_tx_queue *txq)
 {
 	u16 hw_bd_cons;
@@ -353,6 +407,7 @@ static void qede_xdp_tx_int(struct qede_dev *edev, struct qede_tx_queue *txq)
 {
 	struct sw_tx_xdp *xdp_info, *xdp_arr = txq->sw_tx_ring.xdp;
 	struct device *dev = &edev->pdev->dev;
+	struct xdp_frame *xdpf;
 	u16 hw_bd_cons;
 
 	hw_bd_cons = le16_to_cpu(*txq->hw_cons_ptr);
@@ -360,10 +415,19 @@ static void qede_xdp_tx_int(struct qede_dev *edev, struct qede_tx_queue *txq)
 
 	while (hw_bd_cons != qed_chain_get_cons_idx(&txq->tx_pbl)) {
 		xdp_info = xdp_arr + txq->sw_tx_cons;
+		xdpf = xdp_info->xdpf;
+
+		if (xdpf) {
+			dma_unmap_single(dev, xdp_info->mapping, xdpf->len,
+					 DMA_TO_DEVICE);
+			xdp_return_frame(xdpf);
 
-		dma_unmap_page(dev, xdp_info->mapping, PAGE_SIZE,
-			       DMA_BIDIRECTIONAL);
-		__free_page(xdp_info->page);
+			xdp_info->xdpf = NULL;
+		} else {
+			dma_unmap_page(dev, xdp_info->mapping, PAGE_SIZE,
+				       DMA_BIDIRECTIONAL);
+			__free_page(xdp_info->page);
+		}
 
 		qed_chain_consume(&txq->tx_pbl);
 		txq->sw_tx_cons = (txq->sw_tx_cons + 1) % txq->num_tx_buffers;
@@ -1065,7 +1129,8 @@ static bool qede_rx_xdp(struct qede_dev *edev,
 		 * throw current buffer, as replacement was already allocated.
 		 */
 		if (unlikely(qede_xdp_xmit(fp->xdp_tx, bd->mapping,
-					   *data_offset, *len, bd->data))) {
+					   *data_offset, *len, bd->data,
+					   NULL))) {
 			dma_unmap_page(rxq->dev, bd->mapping, PAGE_SIZE,
 				       rxq->data_direction);
 			__free_page(bd->data);
@@ -1079,6 +1144,25 @@ static bool qede_rx_xdp(struct qede_dev *edev,
 		}
 
 		/* Regardless, we've consumed an Rx BD */
+		qede_rx_bd_ring_consume(rxq);
+		break;
+	case XDP_REDIRECT:
+		/* We need the replacement buffer before transmit. */
+		if (unlikely(qede_alloc_rx_buffer(rxq, true))) {
+			qede_recycle_rx_bd_ring(rxq, 1);
+
+			trace_xdp_exception(edev->ndev, prog, act);
+			break;
+		}
+
+		dma_unmap_page(rxq->dev, bd->mapping, PAGE_SIZE,
+			       rxq->data_direction);
+
+		if (unlikely(xdp_do_redirect(edev->ndev, &xdp, prog)))
+			DP_NOTICE(edev, "Failed to redirect the packet\n");
+		else
+			fp->xdp_xmit |= QEDE_XDP_REDIRECT;
+
 		qede_rx_bd_ring_consume(rxq);
 		break;
 	default:
@@ -1387,6 +1471,9 @@ int qede_poll(struct napi_struct *napi, int budget)
 		qede_update_tx_producer(fp->xdp_tx);
 	}
 
+	if (fp->xdp_xmit & QEDE_XDP_REDIRECT)
+		xdp_do_flush_map();
+
 	return rx_work_done;
 }
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 92bcdfa27961..1aaae3203f5a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -672,6 +672,7 @@ static const struct net_device_ops qede_netdev_ops = {
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= qede_rx_flow_steer,
 #endif
+	.ndo_xdp_xmit		= qede_xdp_transmit,
 	.ndo_setup_tc		= qede_setup_tc_offload,
 };
 
@@ -712,6 +713,7 @@ static const struct net_device_ops qede_netdev_vf_xdp_ops = {
 	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= qede_features_check,
 	.ndo_bpf		= qede_xdp,
+	.ndo_xdp_xmit		= qede_xdp_transmit,
 };
 
 /* -------------------------------------------------------------------------
@@ -1712,6 +1714,7 @@ static void qede_init_fp(struct qede_dev *edev)
 {
 	int queue_id, rxq_index = 0, txq_index = 0;
 	struct qede_fastpath *fp;
+	bool init_xdp = false;
 
 	for_each_queue(queue_id) {
 		fp = &edev->fp_array[queue_id];
@@ -1723,6 +1726,9 @@ static void qede_init_fp(struct qede_dev *edev)
 			fp->xdp_tx->index = QEDE_TXQ_IDX_TO_XDP(edev,
 								rxq_index);
 			fp->xdp_tx->is_xdp = 1;
+
+			spin_lock_init(&fp->xdp_tx->xdp_tx_lock);
+			init_xdp = true;
 		}
 
 		if (fp->type & QEDE_FASTPATH_RX) {
@@ -1738,6 +1744,13 @@ static void qede_init_fp(struct qede_dev *edev)
 			/* Driver have no error path from here */
 			WARN_ON(xdp_rxq_info_reg(&fp->rxq->xdp_rxq, edev->ndev,
 						 fp->rxq->rxq_id) < 0);
+
+			if (xdp_rxq_info_reg_mem_model(&fp->rxq->xdp_rxq,
+						       MEM_TYPE_PAGE_ORDER0,
+						       NULL)) {
+				DP_NOTICE(edev,
+					  "Failed to register XDP memory model\n");
+			}
 		}
 
 		if (fp->type & QEDE_FASTPATH_TX) {
@@ -1763,6 +1776,11 @@ static void qede_init_fp(struct qede_dev *edev)
 		snprintf(fp->name, sizeof(fp->name), "%s-fp-%d",
 			 edev->ndev->name, queue_id);
 	}
+
+	if (init_xdp) {
+		edev->total_xdp_queues = QEDE_RSS_COUNT(edev);
+		DP_INFO(edev, "Total XDP queues: %u\n", edev->total_xdp_queues);
+	}
 }
 
 static int qede_set_real_num_queues(struct qede_dev *edev)
-- 
2.25.1

