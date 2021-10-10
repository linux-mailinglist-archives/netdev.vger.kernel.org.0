Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF897428063
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 12:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhJJKLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 06:11:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32616 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231244AbhJJKLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 06:11:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19A50DgG006647;
        Sun, 10 Oct 2021 03:09:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pfpt0220;
 bh=3O7TRKGp1HWU0vCnCEc0FzSJ4ZWLZgtup/C/tsD/NaI=;
 b=ARwAqBQpsqt/g6Ur0YpOUW347i/6VV9WBu3OTJNuQP5wETJdCw2VOcpEkgMzFzRwQVlu
 F+ZD9N6mtPlRVSYPbkbCY95LuziH1/lfJT8WSzDAOZwU54V674KziNnK2cNPManiFyK1
 uDdAedf6jfunUjFWSfWmlpJIntuJa4V5i9bd6OSG0ThQLVI2lphV/80azD0eXLdeY6oG
 //2mfqCL+6FIV84rAUZ71jMwJfPHRGpWZM/31C6IH6aLw9DuPUxeIF5oRuDj4u//a8+4
 9wiP26K5IDZF2/LJoYdyZ90L59oUVuu7onHT9DzLhicdnGsN7MjpLYHWUQxkKPdr2HIi ew== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bkrkt0u9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Oct 2021 03:09:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 10 Oct
 2021 03:09:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 10 Oct 2021 03:09:39 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id B701D3F7098;
        Sun, 10 Oct 2021 03:09:37 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH v3] octeontx2-pf: Simplify the receive buffer size calculation
Date:   Sun, 10 Oct 2021 15:39:35 +0530
Message-ID: <1633860575-7001-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: UrajGSa9IyHPRw4K_ucDx1JkdbXTq240
X-Proofpoint-ORIG-GUID: UrajGSa9IyHPRw4K_ucDx1JkdbXTq240
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-10_01,2021-10-07_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch separates the logic of configuring hardware
maximum transmit frame size and receive frame size.
This simplifies the logic to calculate receive buffer
size and using cqe descriptor of different size.
Also additional size of skb_shared_info structure is
allocated for each receive buffer pointer given to
hardware which is not necessary. Hence change the
size calculation to remove the size of
skb_shared_info. Add a check for array out of
bounds while adding fragments to the network stack.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---

v3:
 Dropped patches 2 and 3 as per Jakub's comments
v2:
 Fixed compilation error
 error: ‘struct otx2_nic’ has no member named ‘max_frs’


 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 10 +++-----
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 15 +++++------
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 30 +++++++++++++++-------
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  4 +--
 6 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index 95f21df..fd4f083 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -88,7 +88,7 @@ int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	aq->sq.ena = 1;
 	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
 	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
-	aq->sq.smq_rr_weight = mtu_to_dwrr_weight(pfvf, pfvf->max_frs);
+	aq->sq.smq_rr_weight = mtu_to_dwrr_weight(pfvf, pfvf->tx_max_pktlen);
 	aq->sq.default_chan = pfvf->hw.tx_chan_base;
 	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
 	aq->sq.sqb_aura = sqb_aura;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 0c89eb8..66da31f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -231,7 +231,7 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 		return -ENOMEM;
 	}
 
-	req->maxlen = pfvf->max_frs;
+	req->maxlen = pfvf->netdev->mtu + OTX2_ETH_HLEN + OTX2_HW_TIMESTAMP_LEN;
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
 	mutex_unlock(&pfvf->mbox.lock);
@@ -590,7 +590,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 	u64 schq, parent;
 	u64 dwrr_val;
 
-	dwrr_val = mtu_to_dwrr_weight(pfvf, pfvf->max_frs);
+	dwrr_val = mtu_to_dwrr_weight(pfvf, pfvf->tx_max_pktlen);
 
 	req = otx2_mbox_alloc_msg_nix_txschq_cfg(&pfvf->mbox);
 	if (!req)
@@ -603,9 +603,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 	/* Set topology e.t.c configuration */
 	if (lvl == NIX_TXSCH_LVL_SMQ) {
 		req->reg[0] = NIX_AF_SMQX_CFG(schq);
-		req->regval[0] = ((pfvf->netdev->max_mtu + OTX2_ETH_HLEN) << 8)
-				  | OTX2_MIN_MTU;
-
+		req->regval[0] = ((u64)pfvf->tx_max_pktlen << 8) | OTX2_MIN_MTU;
 		req->regval[0] |= (0x20ULL << 51) | (0x80ULL << 39) |
 				  (0x2ULL << 36);
 		req->num_regs++;
@@ -800,7 +798,7 @@ int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	aq->sq.ena = 1;
 	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
 	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
-	aq->sq.smq_rr_quantum = mtu_to_dwrr_weight(pfvf, pfvf->max_frs);
+	aq->sq.smq_rr_quantum = mtu_to_dwrr_weight(pfvf, pfvf->tx_max_pktlen);
 	aq->sq.default_chan = pfvf->hw.tx_chan_base;
 	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
 	aq->sq.sqb_aura = sqb_aura;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index a05f6bd..61e5281 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -326,7 +326,7 @@ struct otx2_nic {
 	struct net_device	*netdev;
 	struct dev_hw_ops	*hw_ops;
 	void			*iommu_domain;
-	u16			max_frs;
+	u16			tx_max_pktlen;
 	u16			rbsize; /* Receive buffer size */
 
 #define OTX2_FLAG_RX_TSTAMP_ENABLED		BIT_ULL(0)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index f24e920..1e0d0c9c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1312,16 +1312,14 @@ static int otx2_get_rbuf_size(struct otx2_nic *pf, int mtu)
 	 * NIX transfers entire data using 6 segments/buffers and writes
 	 * a CQE_RX descriptor with those segment addresses. First segment
 	 * has additional data prepended to packet. Also software omits a
-	 * headroom of 128 bytes and sizeof(struct skb_shared_info) in
-	 * each segment. Hence the total size of memory needed
-	 * to receive a packet with 'mtu' is:
+	 * headroom of 128 bytes in each segment. Hence the total size of
+	 * memory needed to receive a packet with 'mtu' is:
 	 * frame size =  mtu + additional data;
-	 * memory = frame_size + (headroom + struct skb_shared_info size) * 6;
+	 * memory = frame_size + headroom * 6;
 	 * each receive buffer size = memory / 6;
 	 */
 	frame_size = mtu + OTX2_ETH_HLEN + OTX2_HW_TIMESTAMP_LEN;
-	total_size = frame_size + (OTX2_HEAD_ROOM +
-		     OTX2_DATA_ALIGN(sizeof(struct skb_shared_info))) * 6;
+	total_size = frame_size + OTX2_HEAD_ROOM * 6;
 	rbuf_size = total_size / 6;
 
 	return ALIGN(rbuf_size, 2048);
@@ -1343,7 +1341,8 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	hw->sqpool_cnt = hw->tot_tx_queues;
 	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
 
-	pf->max_frs = pf->netdev->mtu + OTX2_ETH_HLEN + OTX2_HW_TIMESTAMP_LEN;
+	/* Maximum hardware supported transmit length */
+	pf->tx_max_pktlen = pf->netdev->max_mtu + OTX2_ETH_HLEN;
 
 	pf->rbsize = otx2_get_rbuf_size(pf, pf->netdev->mtu);
 
@@ -1807,7 +1806,7 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	/* Check for minimum and maximum packet length */
 	if (skb->len <= ETH_HLEN ||
-	    (!skb_shinfo(skb)->gso_size && skb->len > pf->max_frs)) {
+	    (!skb_shinfo(skb)->gso_size && skb->len > pf->tx_max_pktlen)) {
 		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 2d2b673..0cc6353 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -181,8 +181,9 @@ static void otx2_set_rxtstamp(struct otx2_nic *pfvf,
 	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(tsns);
 }
 
-static void otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
-			      u64 iova, int len, struct nix_rx_parse_s *parse)
+static bool otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
+			      u64 iova, int len, struct nix_rx_parse_s *parse,
+			      int qidx)
 {
 	struct page *page;
 	int off = 0;
@@ -203,11 +204,22 @@ static void otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
 	}
 
 	page = virt_to_page(va);
-	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
-			va - page_address(page) + off, len - off, pfvf->rbsize);
+	if (likely(skb_shinfo(skb)->nr_frags < MAX_SKB_FRAGS)) {
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
+				va - page_address(page) + off,
+				len - off, pfvf->rbsize);
+
+		otx2_dma_unmap_page(pfvf, iova - OTX2_HEAD_ROOM,
+				    pfvf->rbsize, DMA_FROM_DEVICE);
+		return true;
+	}
 
-	otx2_dma_unmap_page(pfvf, iova - OTX2_HEAD_ROOM,
-			    pfvf->rbsize, DMA_FROM_DEVICE);
+	/* If more than MAX_SKB_FRAGS fragments are received then
+	 * give back those buffer pointers to hardware for reuse.
+	 */
+	pfvf->hw_ops->aura_freeptr(pfvf, qidx, iova & ~0x07ULL);
+
+	return false;
 }
 
 static void otx2_set_rxhash(struct otx2_nic *pfvf,
@@ -349,9 +361,9 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 		seg_addr = &sg->seg_addr;
 		seg_size = (void *)sg;
 		for (seg = 0; seg < sg->segs; seg++, seg_addr++) {
-			otx2_skb_add_frag(pfvf, skb, *seg_addr, seg_size[seg],
-					  parse);
-			cq->pool_ptrs++;
+			if (otx2_skb_add_frag(pfvf, skb, *seg_addr,
+					      seg_size[seg], parse, cq->cq_idx))
+				cq->pool_ptrs++;
 		}
 		start += sizeof(*sg);
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 5c05774..f1a04cf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -39,9 +39,7 @@
 #define RCV_FRAG_LEN(x)	\
 		((RCV_FRAG_LEN1(x) < 2048) ? 2048 : RCV_FRAG_LEN1(x))
 
-#define DMA_BUFFER_LEN(x)		\
-		((x) - OTX2_HEAD_ROOM - \
-		OTX2_DATA_ALIGN(sizeof(struct skb_shared_info)))
+#define DMA_BUFFER_LEN(x)	((x) - OTX2_HEAD_ROOM)
 
 /* IRQ triggered when NIX_LF_CINTX_CNT[ECOUNT]
  * is equal to this value.
-- 
2.7.4

