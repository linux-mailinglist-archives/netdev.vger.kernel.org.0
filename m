Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EBF1D57A2
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgEORXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:23:21 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:62499 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgEORXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:23:19 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04FHNHEd028036;
        Fri, 15 May 2020 10:23:18 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 1/3] cxgb4: improve credits recovery in TC-MQPRIO Tx path
Date:   Fri, 15 May 2020 22:41:03 +0530
Message-Id: <d44865b350d88b89ff83c7673ff452535c90e0f9.1589562017.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
References: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
References: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Request credit update for every half credits consumed, including
the current request. Also, avoid re-trying to post packets when there
are no credits left. The credit update reply via interrupt will
eventually restore the credits and will invoke the Tx path again.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 40 +++++++++++++++---------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 6516c45864b3..1359158652b7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2091,10 +2091,9 @@ static inline u8 ethofld_calc_tx_flits(struct adapter *adap,
 	return flits + nsgl;
 }
 
-static inline void *write_eo_wr(struct adapter *adap,
-				struct sge_eosw_txq *eosw_txq,
-				struct sk_buff *skb, struct fw_eth_tx_eo_wr *wr,
-				u32 hdr_len, u32 wrlen)
+static void *write_eo_wr(struct adapter *adap, struct sge_eosw_txq *eosw_txq,
+			 struct sk_buff *skb, struct fw_eth_tx_eo_wr *wr,
+			 u32 hdr_len, u32 wrlen)
 {
 	const struct skb_shared_info *ssi = skb_shinfo(skb);
 	struct cpl_tx_pkt_core *cpl;
@@ -2113,7 +2112,8 @@ static inline void *write_eo_wr(struct adapter *adap,
 	immd_len += hdr_len;
 
 	if (!eosw_txq->ncompl ||
-	    eosw_txq->last_compl >= adap->params.ofldq_wr_cred / 2) {
+	    (eosw_txq->last_compl + wrlen16) >=
+	    (adap->params.ofldq_wr_cred / 2)) {
 		compl = true;
 		eosw_txq->ncompl++;
 		eosw_txq->last_compl = 0;
@@ -2153,8 +2153,8 @@ static inline void *write_eo_wr(struct adapter *adap,
 	return cpl;
 }
 
-static void ethofld_hard_xmit(struct net_device *dev,
-			      struct sge_eosw_txq *eosw_txq)
+static int ethofld_hard_xmit(struct net_device *dev,
+			     struct sge_eosw_txq *eosw_txq)
 {
 	struct port_info *pi = netdev2pinfo(dev);
 	struct adapter *adap = netdev2adap(dev);
@@ -2167,8 +2167,8 @@ static void ethofld_hard_xmit(struct net_device *dev,
 	bool skip_eotx_wr = false;
 	struct tx_sw_desc *d;
 	struct sk_buff *skb;
+	int left, ret = 0;
 	u8 flits, ndesc;
-	int left;
 
 	eohw_txq = &adap->sge.eohw_txq[eosw_txq->hwqid];
 	spin_lock(&eohw_txq->lock);
@@ -2198,11 +2198,19 @@ static void ethofld_hard_xmit(struct net_device *dev,
 	wrlen = flits * 8;
 	wrlen16 = DIV_ROUND_UP(wrlen, 16);
 
-	/* If there are no CPL credits, then wait for credits
-	 * to come back and retry again
+	left = txq_avail(&eohw_txq->q) - ndesc;
+
+	/* If there are no descriptors left in hardware queues or no
+	 * CPL credits left in software queues, then wait for them
+	 * to come back and retry again. Note that we always request
+	 * for credits update via interrupt for every half credits
+	 * consumed. So, the interrupt will eventually restore the
+	 * credits and invoke the Tx path again.
 	 */
-	if (unlikely(wrlen16 > eosw_txq->cred))
+	if (unlikely(left < 0 || wrlen16 > eosw_txq->cred)) {
+		ret = -ENOMEM;
 		goto out_unlock;
+	}
 
 	if (unlikely(skip_eotx_wr)) {
 		start = (u64 *)wr;
@@ -2231,7 +2239,8 @@ static void ethofld_hard_xmit(struct net_device *dev,
 	sgl = (u64 *)inline_tx_skb_header(skb, &eohw_txq->q, (void *)start,
 					  hdr_len);
 	if (data_len) {
-		if (unlikely(cxgb4_map_skb(adap->pdev_dev, skb, d->addr))) {
+		ret = cxgb4_map_skb(adap->pdev_dev, skb, d->addr);
+		if (unlikely(ret)) {
 			memset(d->addr, 0, sizeof(d->addr));
 			eohw_txq->mapping_err++;
 			goto out_unlock;
@@ -2277,12 +2286,13 @@ static void ethofld_hard_xmit(struct net_device *dev,
 
 out_unlock:
 	spin_unlock(&eohw_txq->lock);
+	return ret;
 }
 
 static void ethofld_xmit(struct net_device *dev, struct sge_eosw_txq *eosw_txq)
 {
 	struct sk_buff *skb;
-	int pktcount;
+	int pktcount, ret;
 
 	switch (eosw_txq->state) {
 	case CXGB4_EO_STATE_ACTIVE:
@@ -2307,7 +2317,9 @@ static void ethofld_xmit(struct net_device *dev, struct sge_eosw_txq *eosw_txq)
 			continue;
 		}
 
-		ethofld_hard_xmit(dev, eosw_txq);
+		ret = ethofld_hard_xmit(dev, eosw_txq);
+		if (ret)
+			break;
 	}
 }
 
-- 
2.24.0

