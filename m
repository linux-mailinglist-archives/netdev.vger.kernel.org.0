Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E78FF3425
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389105AbfKGQHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:07:44 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:20649 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729906AbfKGQHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:07:44 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xA7G7bhV024028;
        Thu, 7 Nov 2019 08:07:38 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 5/6] cxgb4: add Tx and Rx path for ETHOFLD traffic
Date:   Thu,  7 Nov 2019 21:29:08 +0530
Message-Id: <b26aa77dcc514dcc14a6a84413b62ff513210496.1573140612.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement Tx path for traffic flowing through software EOSW_TXQ
and EOHW_TXQ. Since multiple EOSW_TXQ can post packets to a single
EOHW_TXQ, protect the hardware queue with necessary spinlock. Also,
move common code used to generate TSO work request to a common
function.

Implement Rx path to handle Tx completions for successfully
transmitted packets.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   3 +
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 423 ++++++++++++++++--
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h   |   5 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |  30 ++
 5 files changed, 415 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index d9d92dc0d0c5..2dfa98c2d525 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -805,6 +805,7 @@ struct sge_uld_txq_info {
 
 enum sge_eosw_state {
 	CXGB4_EO_STATE_CLOSED = 0, /* Not ready to accept traffic */
+	CXGB4_EO_STATE_ACTIVE, /* Ready to accept traffic */
 };
 
 struct sge_eosw_desc {
@@ -1951,6 +1952,8 @@ void free_tx_desc(struct adapter *adap, struct sge_txq *q,
 void cxgb4_eosw_txq_free_desc(struct adapter *adap, struct sge_eosw_txq *txq,
 			      u32 ndesc);
 void cxgb4_ethofld_restart(unsigned long data);
+int cxgb4_ethofld_rx_handler(struct sge_rspq *q, const __be64 *rsp,
+			     const struct pkt_gl *si);
 void free_txq(struct adapter *adap, struct sge_txq *q);
 void cxgb4_reclaim_completed_tx(struct adapter *adap,
 				struct sge_txq *q, bool unmap);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index 66503ea259e7..e7d3638131e3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -174,7 +174,8 @@ static int cxgb4_mqprio_alloc_hw_resources(struct net_device *dev)
 		eorxq->fl.size = CXGB4_EOHW_FLQ_DEFAULT_DESC_NUM;
 
 		ret = t4_sge_alloc_rxq(adap, &eorxq->rspq, false,
-				       dev, msix, &eorxq->fl, NULL,
+				       dev, msix, &eorxq->fl,
+				       cxgb4_ethofld_rx_handler,
 				       NULL, 0);
 		if (ret)
 			goto out_free_queues;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 3ea2eccde262..6083d54afd00 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -55,6 +55,7 @@
 #include "t4fw_api.h"
 #include "cxgb4_ptp.h"
 #include "cxgb4_uld.h"
+#include "cxgb4_tc_mqprio.h"
 
 /*
  * Rx buffer size.  We use largish buffers if possible but settle for single
@@ -1309,6 +1310,35 @@ static inline void t6_fill_tnl_lso(struct sk_buff *skb,
 	tnl_lso->EthLenOffset_Size = htonl(CPL_TX_TNL_LSO_SIZE_V(skb->len));
 }
 
+static inline void *write_tso_wr(struct adapter *adap, struct sk_buff *skb,
+				 struct cpl_tx_pkt_lso_core *lso)
+{
+	int eth_xtra_len = skb_network_offset(skb) - ETH_HLEN;
+	int l3hdr_len = skb_network_header_len(skb);
+	const struct skb_shared_info *ssi;
+	bool ipv6 = false;
+
+	ssi = skb_shinfo(skb);
+	if (ssi->gso_type & SKB_GSO_TCPV6)
+		ipv6 = true;
+
+	lso->lso_ctrl = htonl(LSO_OPCODE_V(CPL_TX_PKT_LSO) |
+			      LSO_FIRST_SLICE_F | LSO_LAST_SLICE_F |
+			      LSO_IPV6_V(ipv6) |
+			      LSO_ETHHDR_LEN_V(eth_xtra_len / 4) |
+			      LSO_IPHDR_LEN_V(l3hdr_len / 4) |
+			      LSO_TCPHDR_LEN_V(tcp_hdr(skb)->doff));
+	lso->ipid_ofst = htons(0);
+	lso->mss = htons(ssi->gso_size);
+	lso->seqno_offset = htonl(0);
+	if (is_t4(adap->params.chip))
+		lso->len = htonl(skb->len);
+	else
+		lso->len = htonl(LSO_T5_XFER_SIZE_V(skb->len));
+
+	return (void *)(lso + 1);
+}
+
 /**
  *	t4_sge_eth_txq_egress_update - handle Ethernet TX Queue update
  *	@adap: the adapter
@@ -1498,9 +1528,6 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	len += sizeof(*cpl);
 	if (ssi->gso_size) {
 		struct cpl_tx_pkt_lso_core *lso = (void *)(wr + 1);
-		bool v6 = (ssi->gso_type & SKB_GSO_TCPV6) != 0;
-		int l3hdr_len = skb_network_header_len(skb);
-		int eth_xtra_len = skb_network_offset(skb) - ETH_HLEN;
 		struct cpl_tx_tnl_lso *tnl_lso = (void *)(wr + 1);
 
 		if (tnl_type)
@@ -1527,30 +1554,8 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 			if (skb->ip_summed == CHECKSUM_PARTIAL)
 				cntrl = hwcsum(adap->params.chip, skb);
 		} else {
-			lso->lso_ctrl = htonl(LSO_OPCODE_V(CPL_TX_PKT_LSO) |
-					LSO_FIRST_SLICE_F | LSO_LAST_SLICE_F |
-					LSO_IPV6_V(v6) |
-					LSO_ETHHDR_LEN_V(eth_xtra_len / 4) |
-					LSO_IPHDR_LEN_V(l3hdr_len / 4) |
-					LSO_TCPHDR_LEN_V(tcp_hdr(skb)->doff));
-			lso->ipid_ofst = htons(0);
-			lso->mss = htons(ssi->gso_size);
-			lso->seqno_offset = htonl(0);
-			if (is_t4(adap->params.chip))
-				lso->len = htonl(skb->len);
-			else
-				lso->len = htonl(LSO_T5_XFER_SIZE_V(skb->len));
-			cpl = (void *)(lso + 1);
-
-			if (CHELSIO_CHIP_VERSION(adap->params.chip)
-			    <= CHELSIO_T5)
-				cntrl =	TXPKT_ETHHDR_LEN_V(eth_xtra_len);
-			else
-				cntrl = T6_TXPKT_ETHHDR_LEN_V(eth_xtra_len);
-
-			cntrl |= TXPKT_CSUM_TYPE_V(v6 ?
-				 TX_CSUM_TCPIP6 : TX_CSUM_TCPIP) |
-				 TXPKT_IPHDR_LEN_V(l3hdr_len);
+			cpl = write_tso_wr(adap, skb, lso);
+			cntrl = hwcsum(adap->params.chip, skb);
 		}
 		sgl = (u64 *)(cpl + 1); /* sgl start here */
 		if (unlikely((u8 *)sgl >= (u8 *)q->q.stat)) {
@@ -1996,6 +2001,26 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+/**
+ * reclaim_completed_tx_imm - reclaim completed control-queue Tx descs
+ * @q: the SGE control Tx queue
+ *
+ * This is a variant of cxgb4_reclaim_completed_tx() that is used
+ * for Tx queues that send only immediate data (presently just
+ * the control queues) and	thus do not have any sk_buffs to release.
+ */
+static inline void reclaim_completed_tx_imm(struct sge_txq *q)
+{
+	int hw_cidx = ntohs(READ_ONCE(q->stat->cidx));
+	int reclaim = hw_cidx - q->cidx;
+
+	if (reclaim < 0)
+		reclaim += q->size;
+
+	q->in_use -= reclaim;
+	q->cidx = hw_cidx;
+}
+
 static inline void eosw_txq_advance_index(u32 *idx, u32 n, u32 max)
 {
 	u32 val = *idx + n;
@@ -2027,15 +2052,263 @@ void cxgb4_eosw_txq_free_desc(struct adapter *adap,
 	}
 }
 
+static inline void eosw_txq_advance(struct sge_eosw_txq *eosw_txq, u32 n)
+{
+	eosw_txq_advance_index(&eosw_txq->pidx, n, eosw_txq->ndesc);
+	eosw_txq->inuse += n;
+}
+
+static inline int eosw_txq_enqueue(struct sge_eosw_txq *eosw_txq,
+				   struct sk_buff *skb)
+{
+	if (eosw_txq->inuse == eosw_txq->ndesc)
+		return -ENOMEM;
+
+	eosw_txq->desc[eosw_txq->pidx].skb = skb;
+	return 0;
+}
+
+static inline struct sk_buff *eosw_txq_peek(struct sge_eosw_txq *eosw_txq)
+{
+	return eosw_txq->desc[eosw_txq->last_pidx].skb;
+}
+
+static inline u8 ethofld_calc_tx_flits(struct adapter *adap,
+				       struct sk_buff *skb, u32 hdr_len)
+{
+	u8 flits, nsgl = 0;
+	u32 wrlen;
+
+	wrlen = sizeof(struct fw_eth_tx_eo_wr) + sizeof(struct cpl_tx_pkt_core);
+	if (skb_shinfo(skb)->gso_size)
+		wrlen += sizeof(struct cpl_tx_pkt_lso_core);
+
+	wrlen += roundup(hdr_len, 16);
+
+	/* Packet headers + WR + CPLs */
+	flits = DIV_ROUND_UP(wrlen, 8);
+
+	if (skb_shinfo(skb)->nr_frags > 0)
+		nsgl = sgl_len(skb_shinfo(skb)->nr_frags);
+	else if (skb->len - hdr_len)
+		nsgl = sgl_len(1);
+
+	return flits + nsgl;
+}
+
+static inline void *write_eo_wr(struct adapter *adap,
+				struct sge_eosw_txq *eosw_txq,
+				struct sk_buff *skb, struct fw_eth_tx_eo_wr *wr,
+				u32 hdr_len, u32 wrlen)
+{
+	const struct skb_shared_info *ssi = skb_shinfo(skb);
+	struct cpl_tx_pkt_core *cpl;
+	u32 immd_len, wrlen16;
+	bool compl = false;
+
+	wrlen16 = DIV_ROUND_UP(wrlen, 16);
+	immd_len = sizeof(struct cpl_tx_pkt_core);
+	if (skb_shinfo(skb)->gso_size) {
+		if (skb->encapsulation &&
+		    CHELSIO_CHIP_VERSION(adap->params.chip) > CHELSIO_T5)
+			immd_len += sizeof(struct cpl_tx_tnl_lso);
+		else
+			immd_len += sizeof(struct cpl_tx_pkt_lso_core);
+	}
+	immd_len += hdr_len;
+
+	if (!eosw_txq->ncompl ||
+	    eosw_txq->last_compl >= adap->params.ofldq_wr_cred / 2) {
+		compl = true;
+		eosw_txq->ncompl++;
+		eosw_txq->last_compl = 0;
+	}
+
+	wr->op_immdlen = cpu_to_be32(FW_WR_OP_V(FW_ETH_TX_EO_WR) |
+				     FW_ETH_TX_EO_WR_IMMDLEN_V(immd_len) |
+				     FW_WR_COMPL_V(compl));
+	wr->equiq_to_len16 = cpu_to_be32(FW_WR_LEN16_V(wrlen16) |
+					 FW_WR_FLOWID_V(eosw_txq->hwtid));
+	wr->r3 = 0;
+	wr->u.tcpseg.type = FW_ETH_TX_EO_TYPE_TCPSEG;
+	wr->u.tcpseg.ethlen = skb_network_offset(skb);
+	wr->u.tcpseg.iplen = cpu_to_be16(skb_network_header_len(skb));
+	wr->u.tcpseg.tcplen = tcp_hdrlen(skb);
+	wr->u.tcpseg.tsclk_tsoff = 0;
+	wr->u.tcpseg.r4 = 0;
+	wr->u.tcpseg.r5 = 0;
+	wr->u.tcpseg.plen = cpu_to_be32(skb->len - hdr_len);
+
+	if (ssi->gso_size) {
+		struct cpl_tx_pkt_lso_core *lso = (void *)(wr + 1);
+
+		wr->u.tcpseg.mss = cpu_to_be16(ssi->gso_size);
+		cpl = write_tso_wr(adap, skb, lso);
+	} else {
+		wr->u.tcpseg.mss = cpu_to_be16(0xffff);
+		cpl = (void *)(wr + 1);
+	}
+
+	eosw_txq->cred -= wrlen16;
+	eosw_txq->last_compl += wrlen16;
+	return cpl;
+}
+
+static void ethofld_hard_xmit(struct net_device *dev,
+			      struct sge_eosw_txq *eosw_txq)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	u32 wrlen, wrlen16, hdr_len, data_len;
+	u64 cntrl, *start, *end, *sgl;
+	struct sge_eohw_txq *eohw_txq;
+	struct cpl_tx_pkt_core *cpl;
+	struct fw_eth_tx_eo_wr *wr;
+	struct sge_eosw_desc *d;
+	struct sk_buff *skb;
+	u8 flits, ndesc;
+	int left;
+
+	eohw_txq = &adap->sge.eohw_txq[eosw_txq->hwqid];
+	spin_lock(&eohw_txq->lock);
+	reclaim_completed_tx_imm(&eohw_txq->q);
+
+	d = &eosw_txq->desc[eosw_txq->last_pidx];
+	skb = d->skb;
+	skb_tx_timestamp(skb);
+
+	wr = (struct fw_eth_tx_eo_wr *)&eohw_txq->q.desc[eohw_txq->q.pidx];
+	hdr_len = eth_get_headlen(dev, skb->data, skb_headlen(skb));
+	data_len = skb->len - hdr_len;
+	flits = ethofld_calc_tx_flits(adap, skb, hdr_len);
+	ndesc = flits_to_desc(flits);
+	wrlen = flits * 8;
+	wrlen16 = DIV_ROUND_UP(wrlen, 16);
+
+	/* If there are no CPL credits, then wait for credits
+	 * to come back and retry again
+	 */
+	if (unlikely(wrlen16 > eosw_txq->cred))
+		goto out_unlock;
+
+	cpl = write_eo_wr(adap, eosw_txq, skb, wr, hdr_len, wrlen);
+	cntrl = hwcsum(adap->params.chip, skb);
+	if (skb_vlan_tag_present(skb))
+		cntrl |= TXPKT_VLAN_VLD_F | TXPKT_VLAN_V(skb_vlan_tag_get(skb));
+
+	cpl->ctrl0 = cpu_to_be32(TXPKT_OPCODE_V(CPL_TX_PKT_XT) |
+				 TXPKT_INTF_V(pi->tx_chan) |
+				 TXPKT_PF_V(adap->pf));
+	cpl->pack = 0;
+	cpl->len = cpu_to_be16(skb->len);
+	cpl->ctrl1 = cpu_to_be64(cntrl);
+
+	start = (u64 *)(cpl + 1);
+
+	sgl = (u64 *)inline_tx_skb_header(skb, &eohw_txq->q, (void *)start,
+					  hdr_len);
+	if (data_len) {
+		if (unlikely(cxgb4_map_skb(adap->pdev_dev, skb, d->addr))) {
+			memset(d->addr, 0, sizeof(d->addr));
+			eohw_txq->mapping_err++;
+			goto out_unlock;
+		}
+
+		end = (u64 *)wr + flits;
+		if (unlikely(start > sgl)) {
+			left = (u8 *)end - (u8 *)eohw_txq->q.stat;
+			end = (void *)eohw_txq->q.desc + left;
+		}
+
+		if (unlikely((u8 *)sgl >= (u8 *)eohw_txq->q.stat)) {
+			/* If current position is already at the end of the
+			 * txq, reset the current to point to start of the queue
+			 * and update the end ptr as well.
+			 */
+			left = (u8 *)end - (u8 *)eohw_txq->q.stat;
+
+			end = (void *)eohw_txq->q.desc + left;
+			sgl = (void *)eohw_txq->q.desc;
+		}
+
+		cxgb4_write_sgl(skb, &eohw_txq->q, (void *)sgl, end, hdr_len,
+				d->addr);
+	}
+
+	txq_advance(&eohw_txq->q, ndesc);
+	cxgb4_ring_tx_db(adap, &eohw_txq->q, ndesc);
+	eosw_txq_advance_index(&eosw_txq->last_pidx, 1, eosw_txq->ndesc);
+
+out_unlock:
+	spin_unlock(&eohw_txq->lock);
+}
+
+static void ethofld_xmit(struct net_device *dev, struct sge_eosw_txq *eosw_txq)
+{
+	struct sk_buff *skb;
+	int pktcount;
+
+	switch (eosw_txq->state) {
+	case CXGB4_EO_STATE_ACTIVE:
+		pktcount = eosw_txq->pidx - eosw_txq->last_pidx;
+		if (pktcount < 0)
+			pktcount += eosw_txq->ndesc;
+		break;
+	case CXGB4_EO_STATE_CLOSED:
+	default:
+		return;
+	};
+
+	while (pktcount--) {
+		skb = eosw_txq_peek(eosw_txq);
+		if (!skb) {
+			eosw_txq_advance_index(&eosw_txq->last_pidx, 1,
+					       eosw_txq->ndesc);
+			continue;
+		}
+
+		ethofld_hard_xmit(dev, eosw_txq);
+	}
+}
+
 static netdev_tx_t cxgb4_ethofld_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
+	struct cxgb4_tc_port_mqprio *tc_port_mqprio;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct sge_eosw_txq *eosw_txq;
+	u32 qid;
 	int ret;
 
 	ret = cxgb4_validate_skb(skb, dev, ETH_HLEN);
 	if (ret)
 		goto out_free;
 
+	tc_port_mqprio = &adap->tc_mqprio->port_mqprio[pi->port_id];
+	qid = skb_get_queue_mapping(skb) - pi->nqsets;
+	eosw_txq = &tc_port_mqprio->eosw_txq[qid];
+	spin_lock_bh(&eosw_txq->lock);
+	if (eosw_txq->state != CXGB4_EO_STATE_ACTIVE)
+		goto out_unlock;
+
+	ret = eosw_txq_enqueue(eosw_txq, skb);
+	if (ret)
+		goto out_unlock;
+
+	/* SKB is queued for processing until credits are available.
+	 * So, call the destructor now and we'll free the skb later
+	 * after it has been successfully transmitted.
+	 */
+	skb_orphan(skb);
+
+	eosw_txq_advance(eosw_txq, 1);
+	ethofld_xmit(dev, eosw_txq);
+	spin_unlock_bh(&eosw_txq->lock);
+	return NETDEV_TX_OK;
+
+out_unlock:
+	spin_unlock_bh(&eosw_txq->lock);
 out_free:
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
@@ -2055,26 +2328,6 @@ netdev_tx_t t4_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return cxgb4_eth_xmit(skb, dev);
 }
 
-/**
- *	reclaim_completed_tx_imm - reclaim completed control-queue Tx descs
- *	@q: the SGE control Tx queue
- *
- *	This is a variant of cxgb4_reclaim_completed_tx() that is used
- *	for Tx queues that send only immediate data (presently just
- *	the control queues) and	thus do not have any sk_buffs to release.
- */
-static inline void reclaim_completed_tx_imm(struct sge_txq *q)
-{
-	int hw_cidx = ntohs(READ_ONCE(q->stat->cidx));
-	int reclaim = hw_cidx - q->cidx;
-
-	if (reclaim < 0)
-		reclaim += q->size;
-
-	q->in_use -= reclaim;
-	q->cidx = hw_cidx;
-}
-
 /**
  *	is_imm - check whether a packet can be sent as immediate data
  *	@skb: the packet
@@ -3375,12 +3628,86 @@ void cxgb4_ethofld_restart(unsigned long data)
 	if (pktcount < 0)
 		pktcount += eosw_txq->ndesc;
 
-	if (pktcount)
+	if (pktcount) {
 		cxgb4_eosw_txq_free_desc(netdev2adap(eosw_txq->netdev),
 					 eosw_txq, pktcount);
+		eosw_txq->inuse -= pktcount;
+	}
+
+	/* There may be some packets waiting for completions. So,
+	 * attempt to send these packets now.
+	 */
+	ethofld_xmit(eosw_txq->netdev, eosw_txq);
 	spin_unlock(&eosw_txq->lock);
 }
 
+/* cxgb4_ethofld_rx_handler - Process ETHOFLD Tx completions
+ * @q: the response queue that received the packet
+ * @rsp: the response queue descriptor holding the CPL message
+ * @si: the gather list of packet fragments
+ *
+ * Process a ETHOFLD Tx completion. Increment the cidx here, but
+ * free up the descriptors in a tasklet later.
+ */
+int cxgb4_ethofld_rx_handler(struct sge_rspq *q, const __be64 *rsp,
+			     const struct pkt_gl *si)
+{
+	u8 opcode = ((const struct rss_header *)rsp)->opcode;
+
+	/* skip RSS header */
+	rsp++;
+
+	if (opcode == CPL_FW4_ACK) {
+		const struct cpl_fw4_ack *cpl;
+		struct sge_eosw_txq *eosw_txq;
+		struct eotid_entry *entry;
+		struct sk_buff *skb;
+		u32 hdr_len, eotid;
+		u8 flits, wrlen16;
+		int credits;
+
+		cpl = (const struct cpl_fw4_ack *)rsp;
+		eotid = CPL_FW4_ACK_FLOWID_G(ntohl(OPCODE_TID(cpl))) -
+			q->adap->tids.eotid_base;
+		entry = cxgb4_lookup_eotid(&q->adap->tids, eotid);
+		if (!entry)
+			goto out_done;
+
+		eosw_txq = (struct sge_eosw_txq *)entry->data;
+		if (!eosw_txq)
+			goto out_done;
+
+		spin_lock(&eosw_txq->lock);
+		credits = cpl->credits;
+		while (credits > 0) {
+			skb = eosw_txq->desc[eosw_txq->cidx].skb;
+			if (!skb)
+				break;
+
+			hdr_len = eth_get_headlen(eosw_txq->netdev, skb->data,
+						  skb_headlen(skb));
+			flits = ethofld_calc_tx_flits(q->adap, skb, hdr_len);
+			eosw_txq_advance_index(&eosw_txq->cidx, 1,
+					       eosw_txq->ndesc);
+			wrlen16 = DIV_ROUND_UP(flits * 8, 16);
+			credits -= wrlen16;
+		}
+
+		eosw_txq->cred += cpl->credits;
+		eosw_txq->ncompl--;
+
+		spin_unlock(&eosw_txq->lock);
+
+		/* Schedule a tasklet to reclaim SKBs and restart ETHOFLD Tx,
+		 * if there were packets waiting for completion.
+		 */
+		tasklet_schedule(&eosw_txq->qresume_tsk);
+	}
+
+out_done:
+	return 0;
+}
+
 /*
  * The MSI-X interrupt handler for an SGE response queue.
  */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index 38dd41eb959e..575c6abcdae7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -1421,6 +1421,11 @@ enum {
 	CPL_FW4_ACK_FLAGS_FLOWC		= 0x4,	/* fw_flowc_wr complete */
 };
 
+#define CPL_FW4_ACK_FLOWID_S    0
+#define CPL_FW4_ACK_FLOWID_M    0xffffff
+#define CPL_FW4_ACK_FLOWID_G(x) \
+	(((x) >> CPL_FW4_ACK_FLOWID_S) & CPL_FW4_ACK_FLOWID_M)
+
 struct cpl_fw6_msg {
 	u8 opcode;
 	u8 type;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index d603334bae95..ea395b43dbf4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -87,6 +87,7 @@ enum fw_wr_opcodes {
 	FW_ULPTX_WR                    = 0x04,
 	FW_TP_WR                       = 0x05,
 	FW_ETH_TX_PKT_WR               = 0x08,
+	FW_ETH_TX_EO_WR                = 0x1c,
 	FW_OFLD_CONNECTION_WR          = 0x2f,
 	FW_FLOWC_WR                    = 0x0a,
 	FW_OFLD_TX_DATA_WR             = 0x0b,
@@ -534,6 +535,35 @@ struct fw_eth_tx_pkt_wr {
 	__be64 r3;
 };
 
+enum fw_eth_tx_eo_type {
+	FW_ETH_TX_EO_TYPE_TCPSEG = 1,
+};
+
+struct fw_eth_tx_eo_wr {
+	__be32 op_immdlen;
+	__be32 equiq_to_len16;
+	__be64 r3;
+	union fw_eth_tx_eo {
+		struct fw_eth_tx_eo_tcpseg {
+			__u8   type;
+			__u8   ethlen;
+			__be16 iplen;
+			__u8   tcplen;
+			__u8   tsclk_tsoff;
+			__be16 r4;
+			__be16 mss;
+			__be16 r5;
+			__be32 plen;
+		} tcpseg;
+	} u;
+};
+
+#define FW_ETH_TX_EO_WR_IMMDLEN_S	0
+#define FW_ETH_TX_EO_WR_IMMDLEN_M	0x1ff
+#define FW_ETH_TX_EO_WR_IMMDLEN_V(x)	((x) << FW_ETH_TX_EO_WR_IMMDLEN_S)
+#define FW_ETH_TX_EO_WR_IMMDLEN_G(x)	\
+	(((x) >> FW_ETH_TX_EO_WR_IMMDLEN_S) & FW_ETH_TX_EO_WR_IMMDLEN_M)
+
 struct fw_ofld_connection_wr {
 	__be32 op_compl;
 	__be32 len16_pkd;
-- 
2.23.0

