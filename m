Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB75C6F341
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 14:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfGUMpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 08:45:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53956 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfGUMpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 08:45:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6LCjSEg045568;
        Sun, 21 Jul 2019 12:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=03ATwE3wTZig3pYEHdY70MC9Twai/MUdha6vtSPy/jk=;
 b=1rQ6mlrr9dy9M8LhfnCIMdikmq2YOP0KlL8I/5vtJQRp3GCzuXggaHkUlLbIwCnMFcKy
 pJpK5/Pwr0Xp15uMD/pUlwJNMyzW/sYLmE0ia3xHK+bIByu5L4T5W84OEygxEUDoOl6o
 /yfFuWFw4qDqwgN1Fd59ODmQrAF3A23ToktjzQF5a7lso3TW6oT6h5i3Iymk35vgTTc7
 pPPKM6xSDI5j6ag5bOJlP8YzwVBOPjnatSHxI0BEhgVabBLsQoKodjQBOCRc3Z5Ia0A0
 yFrmYiFfqB/8H+O4E5ii/ZXDZMBNtE8bSOuPtCRQtPYPMvHCt8+LAhKT0et4iL+g2ccH Ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tutwp2qdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 12:45:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6LChKb9119263;
        Sun, 21 Jul 2019 12:45:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tur2tdjg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 12:45:41 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6LCjeWe024900;
        Sun, 21 Jul 2019 12:45:40 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 21 Jul 2019 12:45:39 +0000
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     yanjun.zhu@oracle.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCHv2 1/2] forcedeth: add recv cache to make nic work steadily
Date:   Sun, 21 Jul 2019 08:53:52 -0400
Message-Id: <1563713633-25528-2-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563713633-25528-1-git-send-email-yanjun.zhu@oracle.com>
References: <1563713633-25528-1-git-send-email-yanjun.zhu@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9324 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907210153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9324 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907210153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recv cache is added. The size of recv cache is 1000Mbit / skb_length.
When the system memory is not enough, this recv cache can make nic work
steadily.
When nic is up, this recv cache and work queue are created. When nic
is down, this recv cache will be destroyed and delayed workqueue is
canceled.
When nic is polled or rx interrupt is triggerred, rx handler will
get a skb from recv cache. Then a work is queued to fill up recv cache.
When skb size is changed, the old recv cache is destroyed and new recv
cache is created.
When the system memory is not enough, the allocation of skb failed. Then
recv cache will continue allocate skb with GFP_KERNEL until the recv
cache is filled up. When the system memory is not enough, this can make
nic work steadily. Becase of recv cache, the performance of nic is
enhanced.

CC: Joe Jin <joe.jin@oracle.com>
CC: Junxiao Bi <junxiao.bi@oracle.com>
Tested-by: Nan san <nan.1986san@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 103 +++++++++++++++++++++++++++++++-
 1 file changed, 101 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index b327b29..f8e766f 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -674,6 +674,11 @@ struct nv_ethtool_stats {
 	u64 tx_broadcast;
 };
 
+/* 1000Mb is 125M bytes, 125 * 1024 * 1024 bytes
+ * The length of recv cache is 125M / skb_length
+ */
+#define RECV_CACHE_LIST_LENGTH		(125 * 1024 * 1024 / np->rx_buf_sz)
+
 #define NV_DEV_STATISTICS_V3_COUNT (sizeof(struct nv_ethtool_stats)/sizeof(u64))
 #define NV_DEV_STATISTICS_V2_COUNT (NV_DEV_STATISTICS_V3_COUNT - 3)
 #define NV_DEV_STATISTICS_V1_COUNT (NV_DEV_STATISTICS_V2_COUNT - 6)
@@ -844,6 +849,11 @@ struct fe_priv {
 	char name_rx[IFNAMSIZ + 3];       /* -rx    */
 	char name_tx[IFNAMSIZ + 3];       /* -tx    */
 	char name_other[IFNAMSIZ + 6];    /* -other */
+
+	/* This is to schedule work */
+	struct delayed_work     recv_cache_work;
+	/* This list is to store skb queue for recv */
+	struct sk_buff_head recv_list;
 };
 
 /*
@@ -1804,7 +1814,8 @@ static int nv_alloc_rx(struct net_device *dev)
 		less_rx = np->last_rx.orig;
 
 	while (np->put_rx.orig != less_rx) {
-		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		struct sk_buff *skb = skb_dequeue(&np->recv_list);
+
 		if (likely(skb)) {
 			np->put_rx_ctx->skb = skb;
 			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
@@ -1829,9 +1840,15 @@ static int nv_alloc_rx(struct net_device *dev)
 			u64_stats_update_begin(&np->swstats_rx_syncp);
 			np->stat_rx_dropped++;
 			u64_stats_update_end(&np->swstats_rx_syncp);
+
+			schedule_delayed_work(&np->recv_cache_work, 0);
+
 			return 1;
 		}
 	}
+
+	schedule_delayed_work(&np->recv_cache_work, 0);
+
 	return 0;
 }
 
@@ -1845,7 +1862,8 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
 		less_rx = np->last_rx.ex;
 
 	while (np->put_rx.ex != less_rx) {
-		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		struct sk_buff *skb = skb_dequeue(&np->recv_list);
+
 		if (likely(skb)) {
 			np->put_rx_ctx->skb = skb;
 			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
@@ -1871,9 +1889,15 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
 			u64_stats_update_begin(&np->swstats_rx_syncp);
 			np->stat_rx_dropped++;
 			u64_stats_update_end(&np->swstats_rx_syncp);
+
+			schedule_delayed_work(&np->recv_cache_work, 0);
+
 			return 1;
 		}
 	}
+
+	schedule_delayed_work(&np->recv_cache_work, 0);
+
 	return 0;
 }
 
@@ -1957,6 +1981,43 @@ static void nv_init_tx(struct net_device *dev)
 	}
 }
 
+static void nv_init_recv_cache(struct net_device *dev)
+{
+	struct fe_priv *np = netdev_priv(dev);
+
+	skb_queue_head_init(&np->recv_list);
+	while (skb_queue_len(&np->recv_list) < RECV_CACHE_LIST_LENGTH) {
+		struct sk_buff *skb = netdev_alloc_skb(dev,
+				 np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		/* skb is null. This indicates that memory is not
+		 * enough.
+		 */
+		if (unlikely(!skb)) {
+			/* When allocating memory with GFP_ATOMIC fails,
+			 * allocating with GFP_KERNEL will get memory
+			 * finally.
+			 */
+			skb = __netdev_alloc_skb(dev,
+						 np->rx_buf_sz +
+						 NV_RX_ALLOC_PAD,
+						 GFP_KERNEL);
+		}
+
+		skb_queue_tail(&np->recv_list, skb);
+	}
+}
+
+static void nv_destroy_recv_cache(struct net_device *dev)
+{
+	struct fe_priv *np = netdev_priv(dev);
+
+	cancel_delayed_work_sync(&np->recv_cache_work);
+	WARN_ON(delayed_work_pending(&np->recv_cache_work));
+
+	skb_queue_purge(&np->recv_list);
+	WARN_ON(skb_queue_len(&np->recv_list));
+}
+
 static int nv_init_ring(struct net_device *dev)
 {
 	struct fe_priv *np = netdev_priv(dev);
@@ -3047,6 +3108,8 @@ static int nv_change_mtu(struct net_device *dev, int new_mtu)
 		nv_drain_rxtx(dev);
 		/* reinit driver view of the rx queue */
 		set_bufsize(dev);
+		nv_destroy_recv_cache(dev);
+		nv_init_recv_cache(dev);
 		if (nv_init_ring(dev)) {
 			if (!np->in_shutdown)
 				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
@@ -4074,6 +4137,32 @@ static void nv_free_irq(struct net_device *dev)
 	}
 }
 
+static void nv_recv_cache_worker(struct work_struct *work)
+{
+	struct fe_priv *np = container_of(work, struct fe_priv,
+					  recv_cache_work.work);
+
+	while (skb_queue_len(&np->recv_list) < RECV_CACHE_LIST_LENGTH) {
+		struct sk_buff *skb = netdev_alloc_skb(np->dev,
+				np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		/* skb is null. This indicates that memory is not
+		 * enough.
+		 */
+		if (unlikely(!skb)) {
+			/* When allocating memory with GFP_ATOMIC fails,
+			 * allocating with GFP_KERNEL will get memory
+			 * finally.
+			 */
+			skb = __netdev_alloc_skb(np->dev,
+						 np->rx_buf_sz +
+						 NV_RX_ALLOC_PAD,
+						 GFP_KERNEL);
+		}
+
+		skb_queue_tail(&np->recv_list, skb);
+	}
+}
+
 static void nv_do_nic_poll(struct timer_list *t)
 {
 	struct fe_priv *np = from_timer(np, t, nic_poll);
@@ -4129,6 +4218,8 @@ static void nv_do_nic_poll(struct timer_list *t)
 			nv_drain_rxtx(dev);
 			/* reinit driver view of the rx queue */
 			set_bufsize(dev);
+			nv_destroy_recv_cache(dev);
+			nv_init_recv_cache(dev);
 			if (nv_init_ring(dev)) {
 				if (!np->in_shutdown)
 					mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
@@ -4681,6 +4772,8 @@ static int nv_set_ringparam(struct net_device *dev, struct ethtool_ringparam* ri
 	if (netif_running(dev)) {
 		/* reinit driver view of the queues */
 		set_bufsize(dev);
+		nv_destroy_recv_cache(dev);
+		nv_init_recv_cache(dev);
 		if (nv_init_ring(dev)) {
 			if (!np->in_shutdown)
 				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
@@ -5402,6 +5495,9 @@ static int nv_open(struct net_device *dev)
 
 	/* initialize descriptor rings */
 	set_bufsize(dev);
+	nv_init_recv_cache(dev);
+
+	INIT_DELAYED_WORK(&np->recv_cache_work, nv_recv_cache_worker);
 	oom = nv_init_ring(dev);
 
 	writel(0, base + NvRegLinkSpeed);
@@ -5583,6 +5679,9 @@ static int nv_close(struct net_device *dev)
 		nv_txrx_gate(dev, true);
 	}
 
+	/* free all SKBs in recv cache */
+	nv_destroy_recv_cache(dev);
+
 	/* FIXME: power down nic */
 
 	return 0;
-- 
2.7.4

