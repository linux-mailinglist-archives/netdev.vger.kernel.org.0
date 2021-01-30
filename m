Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C1430971C
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 18:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhA3RI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 12:08:58 -0500
Received: from [1.6.215.26] ([1.6.215.26]:38272 "EHLO hyd1soter2"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S232302AbhA3RIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 12:08:41 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jan 2021 12:02:22 EST
Received: from hyd1soter2.caveonetworks.com (localhost [127.0.0.1])
        by hyd1soter2 (8.15.2/8.15.2/Debian-3) with ESMTP id 10UGsSgl092302;
        Sat, 30 Jan 2021 22:24:28 +0530
Received: (from geetha@localhost)
        by hyd1soter2.caveonetworks.com (8.15.2/8.15.2/Submit) id 10UGsSdp092301;
        Sat, 30 Jan 2021 22:24:28 +0530
From:   Geetha sowjanya <gakula@marvell.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next 11/14] octeontx2-pf: cn10k: Get max mtu supported from admin function
Date:   Sat, 30 Jan 2021 22:24:26 +0530
Message-Id: <1612025666-92261-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

CN10K supports max mtu of 16K on lmac links and 64k on lbk
links and Octeontx2 silicon supports 9K mtu on both links. Get the same
from nix_get_hw_info mbox message in netdev probe.

remove updating port field value in ethtool(get_link_ksettings) as
firmware does not support the same.

octeontx2-pf: Use multi segments in NIX CQE_RX

To receive frame sizes upto 64K a single receive
packet buffer is not sufficient because maximum
receive buffer size which can be set is 32K
(configured in NIX_RQ_CTX_S[LPB_SIZEM1]<35:24>).
Hardware transfers bigger frames using RX scatter
gather and writes the CQE RX descriptor with
addresses of all the segments of the packet.
This patch modifies current code to read
all the segments in CQE_RX and to use fixed
size packet receive buffers of 4K.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 42 ++++++++++++++++++++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 29 ++++++++++++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 27 ++++++++++----
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  1 -
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  2 +-
 7 files changed, 88 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index 1c7d478..238238b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -108,7 +108,7 @@ int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
 	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
 	/* FIXME: set based on NIX_AF_DWRR_RPM_MTU*/
-	aq->sq.smq_rr_weight = OTX2_MAX_MTU;
+	aq->sq.smq_rr_weight = pfvf->netdev->mtu;
 	aq->sq.default_chan = pfvf->hw.tx_chan_base;
 	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
 	aq->sq.sqb_aura = sqb_aura;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 2accdc7..61aea78 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -217,7 +217,6 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 		return -ENOMEM;
 	}
 
-	pfvf->max_frs = mtu +  OTX2_ETH_HLEN;
 	req->maxlen = pfvf->max_frs;
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
@@ -591,7 +590,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 	/* Set topology e.t.c configuration */
 	if (lvl == NIX_TXSCH_LVL_SMQ) {
 		req->reg[0] = NIX_AF_SMQX_CFG(schq);
-		req->regval[0] = ((OTX2_MAX_MTU + OTX2_ETH_HLEN) << 8) |
+		req->regval[0] = ((pfvf->netdev->max_mtu + OTX2_ETH_HLEN) << 8) |
 				   OTX2_MIN_MTU;
 
 		req->regval[0] |= (0x20ULL << 51) | (0x80ULL << 39) |
@@ -1618,6 +1617,45 @@ void otx2_set_cints_affinity(struct otx2_nic *pfvf)
 	}
 }
 
+u16 otx2_get_max_mtu(struct otx2_nic *pfvf)
+{
+	struct nix_hw_info *rsp;
+	struct msg_req *req;
+	u16 max_mtu;
+	int rc;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_nix_get_hw_info(&pfvf->mbox);
+	if (!req) {
+		rc =  -ENOMEM;
+		goto out;
+	}
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (!rc) {
+		rsp = (struct nix_hw_info *)
+		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+
+		/* HW counts VLAN insertion bytes (8 for double tag)
+		 * irrespective of whether SQE is requesting to insert VLAN
+		 * in the packet or not. Hence these 8 bytes have to be
+		 * discounted from max packet size otherwise HW will throw
+		 * SMQ errors
+		 */
+		max_mtu = rsp->max_mtu - 8 - OTX2_ETH_HLEN;
+	}
+
+out:
+	mutex_unlock(&pfvf->mbox.lock);
+	if (rc) {
+		dev_warn(pfvf->dev,
+			 "Failed to get MTU from hardware setting default value(1500)\n");
+		max_mtu = 1500;
+	}
+	return max_mtu;
+}
+
 #define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
 int __weak								\
 otx2_mbox_up_handler_ ## _fn_name(struct otx2_nic *pfvf,		\
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index b6bdc6f..1cc7772 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -790,5 +790,5 @@ int otx2_del_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable);
 int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf);
-
+u16 otx2_get_max_mtu(struct otx2_nic *pfvf);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 7ad1ddc..f4aa642 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1290,6 +1290,7 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	struct nix_lf_free_req *free_req;
 	struct mbox *mbox = &pf->mbox;
 	struct otx2_hw *hw = &pf->hw;
+	size_t max_pkt_bytes;
 	struct msg_req *req;
 	int err = 0, lvl;
 
@@ -1301,9 +1302,29 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	hw->sqpool_cnt = hw->tx_queues;
 	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
 
-	/* Get the size of receive buffers to allocate */
-	pf->rbsize = RCV_FRAG_LEN(OTX2_HW_TIMESTAMP_LEN + pf->netdev->mtu +
-				  OTX2_ETH_HLEN);
+	/* The data transferred by NIX to memory consists of actual packet
+	 * plus additional data which has timestamp and/or EDSA/HIGIG2
+	 * headers if interface is configured in corresponding modes.
+	 * NIX transfers entire data using 6 segments/buffers and writes
+	 * a CQE_RX descriptor with those segment addresses. First segment
+	 * has additional data prepended to packet. Also software omits a
+	 * headroom of 128 bytes in each receive buffer. Hence the maximum
+	 * number of actual packet bytes per one CQE_RX descriptor with a
+	 * receive buffer of size 4K is:
+	 * ((4k - 128) * 6) - additional bytes in segment 1.
+	 */
+
+	max_pkt_bytes = DMA_BUFFER_LEN(0x1000) * 6;
+	max_pkt_bytes -= OTX2_ETH_HLEN + OTX2_HW_TIMESTAMP_LEN;
+
+	/* Use packet receive buffers of size 4K since hardware can support
+	 * MTU of size 16K for RPM and 64K for LBK. If MTU is more than
+	 * maximum pkt_bytes then use receive buffers of size 12K so that
+	 * it works for 64K MTU.
+	 */
+	pf->rbsize = 0x1000;
+	if (pf->netdev->mtu > max_pkt_bytes)
+		pf->rbsize = 0x3000;
 
 	mutex_lock(&mbox->lock);
 	/* NPA init */
@@ -2426,7 +2447,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* MTU range: 64 - 9190 */
 	netdev->min_mtu = OTX2_MIN_MTU;
-	netdev->max_mtu = OTX2_MAX_MTU;
+	netdev->max_mtu = otx2_get_max_mtu(pf);
 
 	err = register_netdev(netdev);
 	if (err) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index cdae83c..00e9e65 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -256,12 +256,11 @@ static bool otx2_check_rcv_errors(struct otx2_nic *pfvf,
 		/* For now ignore all the NPC parser errors and
 		 * pass the packets to stack.
 		 */
-		if (cqe->sg.segs == 1)
-			return false;
+		return false;
 	}
 
 	/* If RXALL is enabled pass on packets to stack. */
-	if (cqe->sg.segs == 1 && (pfvf->netdev->features & NETIF_F_RXALL))
+	if (pfvf->netdev->features & NETIF_F_RXALL)
 		return false;
 
 	/* Free buffer back to pool */
@@ -276,9 +275,14 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 				 struct nix_cqe_rx_s *cqe)
 {
 	struct nix_rx_parse_s *parse = &cqe->parse;
+	struct nix_rx_sg_s *sg = &cqe->sg;
 	struct sk_buff *skb = NULL;
+	void *end, *start;
+	u64 *seg_addr;
+	u16 *seg_size;
+	int seg;
 
-	if (unlikely(parse->errlev || parse->errcode || cqe->sg.segs > 1)) {
+	if (unlikely(parse->errlev || parse->errcode)) {
 		if (otx2_check_rcv_errors(pfvf, cqe, cq->cq_idx))
 			return;
 	}
@@ -287,9 +291,18 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	if (unlikely(!skb))
 		return;
 
-	otx2_skb_add_frag(pfvf, skb, cqe->sg.seg_addr, cqe->sg.seg_size, parse);
-	cq->pool_ptrs++;
-
+	start = (void *)sg;
+	end = start + ((cqe->parse.desc_sizem1 + 1) * 16);
+	while (start < end) {
+		sg = (struct nix_rx_sg_s *)start;
+		seg_addr = &sg->seg_addr;
+		seg_size = (void *)sg;
+		for (seg = 0; seg < sg->segs; seg++, seg_addr++) {
+			otx2_skb_add_frag(pfvf, skb, *seg_addr, seg_size[seg], parse);
+			cq->pool_ptrs++;
+		}
+		start += sizeof(*sg);
+	}
 	otx2_set_rxhash(pfvf, cqe, skb);
 
 	skb_record_rx_queue(skb, cq->cq_idx);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index d2b26b3..52486c1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -24,7 +24,6 @@
 
 #define	OTX2_ETH_HLEN		(VLAN_ETH_HLEN + VLAN_HLEN)
 #define	OTX2_MIN_MTU		64
-#define	OTX2_MAX_MTU		(9212 - OTX2_ETH_HLEN)
 
 #define OTX2_MAX_GSO_SEGS	255
 #define OTX2_MAX_FRAGS_IN_SQE	9
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 3dd20e5..c301c47 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -586,7 +586,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* MTU range: 68 - 9190 */
 	netdev->min_mtu = OTX2_MIN_MTU;
-	netdev->max_mtu = OTX2_MAX_MTU;
+	netdev->max_mtu = otx2_get_max_mtu(vf);
 
 	INIT_WORK(&vf->reset_task, otx2vf_reset_task);
 
-- 
2.7.4

