Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4C42062D5
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403789AbgFWUem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:34:42 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:63816 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403780AbgFWUej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:34:39 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKYao6019525;
        Tue, 23 Jun 2020 13:34:37 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 02/12] cxgb4: move PTP lock and unlock to caller in Tx path
Date:   Wed, 24 Jun 2020 01:51:32 +0530
Message-Id: <01d0284d68157baf6dafdaa22056380b96b96076.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check for whether PTP is enabled or not at the caller and perform
locking/unlocking at the caller.

Fixes following sparse warning:
sge.c:1641:26: warning: context imbalance in 'cxgb4_eth_xmit' -
different lock contexts for basic block

Fixes: a456950445a0 ("cxgb4: time stamping interface for PTP")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 1359158652b7..f7b5a2f11001 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1425,12 +1425,10 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	qidx = skb_get_queue_mapping(skb);
 	if (ptp_enabled) {
-		spin_lock(&adap->ptp_lock);
 		if (!(adap->ptp_tx_skb)) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			adap->ptp_tx_skb = skb_get(skb);
 		} else {
-			spin_unlock(&adap->ptp_lock);
 			goto out_free;
 		}
 		q = &adap->sge.ptptxq;
@@ -1444,11 +1442,8 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 #ifdef CONFIG_CHELSIO_T4_FCOE
 	ret = cxgb_fcoe_offload(skb, adap, pi, &cntrl);
-	if (unlikely(ret == -ENOTSUPP)) {
-		if (ptp_enabled)
-			spin_unlock(&adap->ptp_lock);
+	if (unlikely(ret == -EOPNOTSUPP))
 		goto out_free;
-	}
 #endif /* CONFIG_CHELSIO_T4_FCOE */
 
 	chip_ver = CHELSIO_CHIP_VERSION(adap->params.chip);
@@ -1461,8 +1456,6 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 		dev_err(adap->pdev_dev,
 			"%s: Tx ring %u full while queue awake!\n",
 			dev->name, qidx);
-		if (ptp_enabled)
-			spin_unlock(&adap->ptp_lock);
 		return NETDEV_TX_BUSY;
 	}
 
@@ -1481,8 +1474,6 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	    unlikely(cxgb4_map_skb(adap->pdev_dev, skb, sgl_sdesc->addr) < 0)) {
 		memset(sgl_sdesc->addr, 0, sizeof(sgl_sdesc->addr));
 		q->mapping_err++;
-		if (ptp_enabled)
-			spin_unlock(&adap->ptp_lock);
 		goto out_free;
 	}
 
@@ -1630,8 +1621,6 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	txq_advance(&q->q, ndesc);
 
 	cxgb4_ring_tx_db(adap, &q->q, ndesc);
-	if (ptp_enabled)
-		spin_unlock(&adap->ptp_lock);
 	return NETDEV_TX_OK;
 
 out_free:
@@ -2377,6 +2366,16 @@ netdev_tx_t t4_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(qid >= pi->nqsets))
 		return cxgb4_ethofld_xmit(skb, dev);
 
+	if (is_ptp_enabled(skb, dev)) {
+		struct adapter *adap = netdev2adap(dev);
+		netdev_tx_t ret;
+
+		spin_lock(&adap->ptp_lock);
+		ret = cxgb4_eth_xmit(skb, dev);
+		spin_unlock(&adap->ptp_lock);
+		return ret;
+	}
+
 	return cxgb4_eth_xmit(skb, dev);
 }
 
-- 
2.24.0

