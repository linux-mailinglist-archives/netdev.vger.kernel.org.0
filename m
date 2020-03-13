Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C7D1851E4
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 23:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgCMWuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 18:50:13 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:35566 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbgCMWuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 18:50:11 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02DMo55q066111;
        Fri, 13 Mar 2020 17:50:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584139805;
        bh=Ap1wbP9Yro6m4GwNz6sgCmUmSSxitzqx2d/1IhoQstE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=pNjce3pTRcuGsgZbM7Hyonh5knENDKHwrpfJmFUxysLDS/CKRdRl4YMxrdPPlF/Pl
         zUIHX2n1r2iAXpyLG5szryJ9M3uFU1iVw5008nL1BqsEvAQy2iqcnJ2EcejK7gZy71
         qoTjMepIeOnIbBjfLSm3W0CUwbmPHirWDUM0gJt0=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02DMo5Lc049357;
        Fri, 13 Mar 2020 17:50:05 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 13
 Mar 2020 17:50:05 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 13 Mar 2020 17:50:05 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02DMo3eU009689;
        Fri, 13 Mar 2020 17:50:04 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 08/11] net: ethernet: ti: cpts: move rx timestamp processing to ptp worker only
Date:   Sat, 14 Mar 2020 00:49:11 +0200
Message-ID: <20200313224914.5997-9-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313224914.5997-1-grygorii.strashko@ti.com>
References: <20200313224914.5997-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once CPTS IRQ will be enabled the CPTS irq handler may compete with netif
RX sofirq path and so RX timestamp might not be ready at the moment packet
is processed. As result, packet has to be deferred and processed later.

This patch moves RX timestamp processing tx timestamp processing to PTP
worker always the same way as it's been done for TX timestamps.

  napi_rx->cpts_rx_timestamp
   if ptp_packet then
      push to rxq
      ptp_schedule_worker()

  do_aux_work->cpts_overflow_check
    cpts_process_events()

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw.c     |  14 +--
 drivers/net/ethernet/ti/cpsw_new.c |  13 ++-
 drivers/net/ethernet/ti/cpts.c     | 132 ++++++++++++++++++-----------
 drivers/net/ethernet/ti/cpts.h     |   3 +-
 4 files changed, 104 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 6ae4a72e6f43..a27cb1b2190f 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -433,17 +433,21 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	skb->dev = ndev;
 	if (status & CPDMA_RX_VLAN_ENCAP)
 		cpsw_rx_vlan_encap(skb);
-	if (priv->rx_ts_enabled)
-		cpts_rx_timestamp(cpsw->cpts, skb);
-	skb->protocol = eth_type_trans(skb, ndev);
 
 	/* unmap page as no netstack skb page recycling */
 	page_pool_release_page(pool, page);
-	netif_receive_skb(skb);
-
 	ndev->stats.rx_bytes += len;
 	ndev->stats.rx_packets++;
 
+	ret = 0;
+	if (priv->rx_ts_enabled)
+		ret = cpts_rx_timestamp(cpsw->cpts, skb);
+
+	if (!ret) {
+		skb->protocol = eth_type_trans(skb, ndev);
+		netif_receive_skb(skb);
+	}
+
 requeue:
 	xmeta = page_address(new_page) + CPSW_XMETA_OFFSET;
 	xmeta->ndev = ndev;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 71215db7934b..2ee685493147 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -375,17 +375,22 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	skb->dev = ndev;
 	if (status & CPDMA_RX_VLAN_ENCAP)
 		cpsw_rx_vlan_encap(skb);
-	if (priv->rx_ts_enabled)
-		cpts_rx_timestamp(cpsw->cpts, skb);
-	skb->protocol = eth_type_trans(skb, ndev);
 
 	/* unmap page as no netstack skb page recycling */
 	page_pool_release_page(pool, page);
-	netif_receive_skb(skb);
 
 	ndev->stats.rx_bytes += len;
 	ndev->stats.rx_packets++;
 
+	ret = 0;
+	if (priv->rx_ts_enabled)
+		ret = cpts_rx_timestamp(cpsw->cpts, skb);
+
+	if (!ret) {
+		skb->protocol = eth_type_trans(skb, ndev);
+		netif_receive_skb(skb);
+	}
+
 requeue:
 	xmeta = page_address(new_page) + CPSW_XMETA_OFFSET;
 	xmeta->ndev = ndev;
diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 71f9bd410e4a..fcfd578b81ed 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -311,6 +311,66 @@ static bool cpts_match_tx_ts(struct cpts *cpts, struct cpts_event *event)
 	return found;
 }
 
+static bool cpts_match_rx_ts(struct cpts *cpts, struct cpts_event *event)
+{
+	struct sk_buff_head rxq_list;
+	struct sk_buff_head tempq;
+	struct sk_buff *skb, *tmp;
+	unsigned long flags;
+	bool found = false;
+	u32 mtype_seqid;
+
+	mtype_seqid = event->high &
+		      ((MESSAGE_TYPE_MASK << MESSAGE_TYPE_SHIFT) |
+		       (SEQUENCE_ID_MASK << SEQUENCE_ID_SHIFT) |
+		       (EVENT_TYPE_MASK << EVENT_TYPE_SHIFT));
+
+	__skb_queue_head_init(&rxq_list);
+	__skb_queue_head_init(&tempq);
+
+	spin_lock_irqsave(&cpts->rxq.lock, flags);
+	skb_queue_splice_init(&cpts->rxq, &rxq_list);
+	spin_unlock_irqrestore(&cpts->rxq.lock, flags);
+
+	skb_queue_walk_safe(&rxq_list, skb, tmp) {
+		struct skb_shared_hwtstamps *ssh;
+		struct cpts_skb_cb_data *skb_cb =
+					(struct cpts_skb_cb_data *)skb->cb;
+
+		if (mtype_seqid == skb_cb->skb_mtype_seqid) {
+			__skb_unlink(skb, &rxq_list);
+			ssh = skb_hwtstamps(skb);
+			memset(ssh, 0, sizeof(*ssh));
+			ssh->hwtstamp = ns_to_ktime(event->timestamp);
+			found = true;
+			dev_dbg(cpts->dev, "match rx timestamp mtype_seqid %08x\n",
+				mtype_seqid);
+			__skb_queue_tail(&tempq, skb);
+			break;
+		}
+
+		if (time_after(jiffies, skb_cb->tmo)) {
+			/* timeout any expired skbs */
+			dev_dbg(cpts->dev, "expiring rx timestamp\n");
+			__skb_unlink(skb, &rxq_list);
+			__skb_queue_tail(&tempq, skb);
+		}
+	}
+
+	spin_lock_irqsave(&cpts->rxq.lock, flags);
+	skb_queue_splice(&rxq_list, &cpts->rxq);
+	spin_unlock_irqrestore(&cpts->rxq.lock, flags);
+
+	local_bh_disable();
+	while ((skb = __skb_dequeue(&tempq))) {
+		skb->protocol = eth_type_trans(skb, skb->dev);
+		netif_receive_skb(skb);
+	}
+	local_bh_enable();
+
+	return found;
+}
+
 static void cpts_process_events(struct cpts *cpts)
 {
 	struct list_head *this, *next;
@@ -318,6 +378,7 @@ static void cpts_process_events(struct cpts *cpts)
 	unsigned long flags;
 	LIST_HEAD(events);
 	LIST_HEAD(events_free);
+	int type;
 
 	spin_lock_irqsave(&cpts->lock, flags);
 	list_splice_init(&cpts->events, &events);
@@ -325,8 +386,18 @@ static void cpts_process_events(struct cpts *cpts)
 
 	list_for_each_safe(this, next, &events) {
 		event = list_entry(this, struct cpts_event, list);
-		if (cpts_match_tx_ts(cpts, event) ||
-		    time_after(jiffies, event->tmo)) {
+		type = event_type(event);
+
+		if (type == CPTS_EV_TX &&
+		    (cpts_match_tx_ts(cpts, event) ||
+		     time_after(jiffies, event->tmo))) {
+			list_del_init(&event->list);
+			list_add(&event->list, &events_free);
+		}
+
+		if (type == CPTS_EV_RX &&
+		    (cpts_match_rx_ts(cpts, event) ||
+		     time_after(jiffies, event->tmo))) {
 			list_del_init(&event->list);
 			list_add(&event->list, &events_free);
 		}
@@ -422,64 +493,27 @@ static int cpts_skb_get_mtype_seqid(struct sk_buff *skb, u32 *mtype_seqid)
 	return 1;
 }
 
-static u64 cpts_find_ts(struct cpts *cpts, struct sk_buff *skb,
-			int ev_type, u32 skb_mtype_seqid)
-{
-	struct list_head *this, *next;
-	struct cpts_event *event;
-	unsigned long flags;
-	u32 mtype_seqid;
-	u64 ns = 0;
-
-	cpts_fifo_read(cpts, -1);
-	spin_lock_irqsave(&cpts->lock, flags);
-	list_for_each_safe(this, next, &cpts->events) {
-		event = list_entry(this, struct cpts_event, list);
-		if (event_expired(event)) {
-			list_del_init(&event->list);
-			list_add(&event->list, &cpts->pool);
-			continue;
-		}
-
-		mtype_seqid = event->high &
-			      ((MESSAGE_TYPE_MASK << MESSAGE_TYPE_SHIFT) |
-			       (SEQUENCE_ID_MASK << SEQUENCE_ID_SHIFT) |
-			       (EVENT_TYPE_MASK << EVENT_TYPE_SHIFT));
-
-		if (mtype_seqid == skb_mtype_seqid) {
-			ns = event->timestamp;
-			list_del_init(&event->list);
-			list_add(&event->list, &cpts->pool);
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&cpts->lock, flags);
-
-	return ns;
-}
-
-void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb)
+int cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb)
 {
 	struct cpts_skb_cb_data *skb_cb = (struct cpts_skb_cb_data *)skb->cb;
-	struct skb_shared_hwtstamps *ssh;
 	int ret;
-	u64 ns;
 
 	ret = cpts_skb_get_mtype_seqid(skb, &skb_cb->skb_mtype_seqid);
 	if (!ret)
-		return;
+		return 0;
 
 	skb_cb->skb_mtype_seqid |= (CPTS_EV_RX << EVENT_TYPE_SHIFT);
 
 	dev_dbg(cpts->dev, "%s mtype seqid %08x\n",
 		__func__, skb_cb->skb_mtype_seqid);
 
-	ns = cpts_find_ts(cpts, skb, CPTS_EV_RX, skb_cb->skb_mtype_seqid);
-	if (!ns)
-		return;
-	ssh = skb_hwtstamps(skb);
-	memset(ssh, 0, sizeof(*ssh));
-	ssh->hwtstamp = ns_to_ktime(ns);
+	/* Always defer RX TS processing to PTP worker */
+	/* get the timestamp for timeouts */
+	skb_cb->tmo = jiffies + msecs_to_jiffies(CPTS_SKB_RX_TX_TMO);
+	skb_queue_tail(&cpts->rxq, skb);
+	ptp_schedule_worker(cpts->clock, 0);
+
+	return 1;
 }
 EXPORT_SYMBOL_GPL(cpts_rx_timestamp);
 
@@ -514,6 +548,7 @@ int cpts_register(struct cpts *cpts)
 	int err, i;
 
 	skb_queue_head_init(&cpts->txq);
+	skb_queue_head_init(&cpts->rxq);
 	INIT_LIST_HEAD(&cpts->events);
 	INIT_LIST_HEAD(&cpts->pool);
 	for (i = 0; i < CPTS_MAX_EVENTS; i++)
@@ -556,6 +591,7 @@ void cpts_unregister(struct cpts *cpts)
 
 	/* Drop all packet */
 	skb_queue_purge(&cpts->txq);
+	skb_queue_purge(&cpts->rxq);
 
 	clk_disable(cpts->refclk);
 }
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index f16e14d67f5f..993b4cfa4e86 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -115,12 +115,13 @@ struct cpts {
 	struct cpts_event pool_data[CPTS_MAX_EVENTS];
 	unsigned long ov_check_period;
 	struct sk_buff_head txq;
+	struct sk_buff_head rxq;
 	u64 cur_timestamp;
 	u32 mult_new;
 	struct mutex ptp_clk_mutex; /* sync PTP interface and worker */
 };
 
-void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
+int cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
 void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb);
 int cpts_register(struct cpts *cpts);
 void cpts_unregister(struct cpts *cpts);
-- 
2.17.1

