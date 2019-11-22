Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90229105E10
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 02:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKVBIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 20:08:52 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:16792 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfKVBIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 20:08:51 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAM18jhG011887;
        Thu, 21 Nov 2019 17:08:46 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next v2 3/3] cxgb4: add stats for MQPRIO QoS offload Tx path
Date:   Fri, 22 Nov 2019 06:30:03 +0530
Message-Id: <28488132436a491f5fd8fa7da8e84694e70ef9d5.1574383652.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export necessary stats for traffic flowing through MQPRIO QoS offload
Tx path.

v2:
- No change.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c | 13 ++++++++++++-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           | 14 ++++++++++++++
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 04cb8909feeb..a70ac2097892 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -850,6 +850,7 @@ struct sge_eohw_txq {
 	struct sge_txq q; /* HW Txq */
 	struct adapter *adap; /* Backpointer to adapter */
 	unsigned long tso; /* # of TSO requests */
+	unsigned long uso; /* # of USO requests */
 	unsigned long tx_cso; /* # of Tx checksum offloads */
 	unsigned long vlan_ins; /* # of Tx VLAN insertions */
 	unsigned long mapping_err; /* # of I/O MMU packet mapping errors */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index fa229d0f1016..93868dca186a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2797,6 +2797,7 @@ do { \
 		RL("RxAN", stats.an);
 		RL("RxNoMem", stats.nomem);
 		TL("TSO:", tso);
+		TL("USO:", uso);
 		TL("TxCSO:", tx_cso);
 		TL("VLANins:", vlan_ins);
 		TL("TxQFull:", q.stops);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index f57457453561..20ab3b6285a2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -242,9 +242,10 @@ static void collect_sge_port_stats(const struct adapter *adap,
 				   const struct port_info *p,
 				   struct queue_port_stats *s)
 {
-	int i;
 	const struct sge_eth_txq *tx = &adap->sge.ethtxq[p->first_qset];
 	const struct sge_eth_rxq *rx = &adap->sge.ethrxq[p->first_qset];
+	struct sge_eohw_txq *eohw_tx;
+	unsigned int i;
 
 	memset(s, 0, sizeof(*s));
 	for (i = 0; i < p->nqsets; i++, rx++, tx++) {
@@ -257,6 +258,16 @@ static void collect_sge_port_stats(const struct adapter *adap,
 		s->gro_pkts += rx->stats.lro_pkts;
 		s->gro_merged += rx->stats.lro_merged;
 	}
+
+	if (adap->sge.eohw_txq) {
+		eohw_tx = &adap->sge.eohw_txq[p->first_qset];
+		for (i = 0; i < p->nqsets; i++, eohw_tx++) {
+			s->tso += eohw_tx->tso;
+			s->uso += eohw_tx->uso;
+			s->tx_csum += eohw_tx->tx_cso;
+			s->vlan_ins += eohw_tx->vlan_ins;
+		}
+	}
 }
 
 static void collect_adapter_stats(struct adapter *adap, struct adapter_stats *s)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 53f9a821c29f..97cda501e7e8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2262,6 +2262,19 @@ static void ethofld_hard_xmit(struct net_device *dev,
 				d->addr);
 	}
 
+	if (skb_shinfo(skb)->gso_size) {
+		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+			eohw_txq->uso++;
+		else
+			eohw_txq->tso++;
+		eohw_txq->tx_cso += skb_shinfo(skb)->gso_segs;
+	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		eohw_txq->tx_cso++;
+	}
+
+	if (skb_vlan_tag_present(skb))
+		eohw_txq->vlan_ins++;
+
 	txq_advance(&eohw_txq->q, ndesc);
 	cxgb4_ring_tx_db(adap, &eohw_txq->q, ndesc);
 	eosw_txq_advance_index(&eosw_txq->last_pidx, 1, eosw_txq->ndesc);
@@ -4546,6 +4559,7 @@ int t4_sge_alloc_ethofld_txq(struct adapter *adap, struct sge_eohw_txq *txq,
 	spin_lock_init(&txq->lock);
 	txq->adap = adap;
 	txq->tso = 0;
+	txq->uso = 0;
 	txq->tx_cso = 0;
 	txq->vlan_ins = 0;
 	txq->mapping_err = 0;
-- 
2.24.0

