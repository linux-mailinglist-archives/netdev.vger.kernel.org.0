Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D01600D7
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 08:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfGEGLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 02:11:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33222 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfGEGLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 02:11:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6569pZZ139827;
        Fri, 5 Jul 2019 06:11:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=4vzzZBuT490bkXU/lsYya4QniBzzf+C9ZVIUo+BJmYQ=;
 b=pOyDIkEpj+dstJAZVOfNykHyu1jY1Vat7Sm4yZpqixN6wbGUbYXwaqpfKo3By2S7zO0d
 ep3zk34aGWypRtQntB526R/AGzoXnPNrD2ILatpyPz7trs9XxtEixl+UZqsJ74UA3VvD
 03cELqW0SHIQNi2ZcWNN9KcEmUFG6bKRv/RbbsbgVZ9NrPY1rTetAw7cUSi7lkjHYV3e
 Ju7aO8W8sOdPG0qz3B4kfv6Hq8lbHw90SQ8EMvV4CEdG/wsMWIE6w/q8j6Pv47Pg+1Aw
 IXIFHOSY+UMDuneicnac97L+ETdk2qrGQ1KWJEoBCQJcrxktslb54RQ4B41Niff3UlQt Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2te5tc16v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 06:11:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6567fXu108124;
        Fri, 5 Jul 2019 06:11:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2th9ec9cfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 06:11:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x656BSjw000388;
        Fri, 5 Jul 2019 06:11:28 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Jul 2019 23:11:27 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     yanjun.zhu@oracle.com, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH 1/2] forcedeth: add recv cache make nic work steadily
Date:   Fri,  5 Jul 2019 02:19:27 -0400
Message-Id: <1562307568-21549-2-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562307568-21549-1-git-send-email-yanjun.zhu@oracle.com>
References: <1562307568-21549-1-git-send-email-yanjun.zhu@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9308 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9308 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recv cache is added. The size of recv cache is 1000Mb / skb_length.
When the system memory is not enough, this recv cache can make nic work
steadily.
When nic is up, this recv cache and work queue are created. When nic
is down, this recv cache will be destroyed and delayed workqueue is
canceled.
When nic is polled or rx interrupt is triggerred, rx handler will
get a skb from recv cache. Then the state of recv cache is checked.
If recv cache is not in filling up state, a work is queued to fill
up recv cache.
When skb size is changed, the old recv cache is destroyed and new recv
cache is created.
When the system memory is not enough, the allocation of skb failed.
recv cache will continue allocate skb until the recv cache is filled up.
When the system memory is not enough, this can make nic work steadily.
Becase of recv cache, the performance of nic is enhanced.

CC: Joe Jin <joe.jin@oracle.com>
CC: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 100 +++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index b327b29..a673005 100644
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
@@ -844,8 +849,18 @@ struct fe_priv {
 	char name_rx[IFNAMSIZ + 3];       /* -rx    */
 	char name_tx[IFNAMSIZ + 3];       /* -tx    */
 	char name_other[IFNAMSIZ + 6];    /* -other */
+
+	/* This is to schedule work */
+	struct delayed_work     recv_cache_work;
+	/* This list is to store skb queue for recv */
+	struct sk_buff_head recv_list;
+	unsigned long nv_recv_list_state;
 };
 
+/* This is recv list state to fill up recv cache */
+enum recv_list_state {
+	RECV_LIST_ALLOCATE
+};
 /*
  * Maximum number of loops until we assume that a bit in the irq mask
  * is stuck. Overridable with module param.
@@ -1804,7 +1819,11 @@ static int nv_alloc_rx(struct net_device *dev)
 		less_rx = np->last_rx.orig;
 
 	while (np->put_rx.orig != less_rx) {
-		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		struct sk_buff *skb = skb_dequeue(&np->recv_list);
+
+		if (!test_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state))
+			schedule_delayed_work(&np->recv_cache_work, 0);
+
 		if (likely(skb)) {
 			np->put_rx_ctx->skb = skb;
 			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
@@ -1845,7 +1864,11 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
 		less_rx = np->last_rx.ex;
 
 	while (np->put_rx.ex != less_rx) {
-		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		struct sk_buff *skb = skb_dequeue(&np->recv_list);
+
+		if (!test_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state))
+			schedule_delayed_work(&np->recv_cache_work, 0);
+
 		if (likely(skb)) {
 			np->put_rx_ctx->skb = skb;
 			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
@@ -1957,6 +1980,40 @@ static void nv_init_tx(struct net_device *dev)
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
+			ndelay(3);
+			continue;
+		}
+
+		skb_queue_tail(&np->recv_list, skb);
+	}
+}
+
+static void nv_destroy_recv_cache(struct net_device *dev)
+{
+	struct sk_buff *skb;
+	struct fe_priv *np = netdev_priv(dev);
+
+	cancel_delayed_work_sync(&np->recv_cache_work);
+	WARN_ON(delayed_work_pending(&np->recv_cache_work));
+
+	while ((skb = skb_dequeue(&np->recv_list)))
+		kfree_skb(skb);
+
+	WARN_ON(skb_queue_len(&np->recv_list));
+}
+
 static int nv_init_ring(struct net_device *dev)
 {
 	struct fe_priv *np = netdev_priv(dev);
@@ -3047,6 +3104,8 @@ static int nv_change_mtu(struct net_device *dev, int new_mtu)
 		nv_drain_rxtx(dev);
 		/* reinit driver view of the rx queue */
 		set_bufsize(dev);
+		nv_destroy_recv_cache(dev);
+		nv_init_recv_cache(dev);
 		if (nv_init_ring(dev)) {
 			if (!np->in_shutdown)
 				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
@@ -4074,6 +4133,32 @@ static void nv_free_irq(struct net_device *dev)
 	}
 }
 
+static void nv_recv_cache_worker(struct work_struct *work)
+{
+	struct fe_priv *np = container_of(work, struct fe_priv,
+					  recv_cache_work.work);
+
+	set_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
+	while (skb_queue_len(&np->recv_list) < RECV_CACHE_LIST_LENGTH) {
+		struct sk_buff *skb = netdev_alloc_skb(np->dev,
+				np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		/* skb is null. This indicates that memory is not
+		 * enough.
+		 * When the system memory is not enough, the kernel
+		 * will compact memory or drop caches. At that time,
+		 * if memory allocation fails, it had better wait some
+		 * time for memory.
+		 */
+		if (unlikely(!skb)) {
+			ndelay(3);
+			continue;
+		}
+
+		skb_queue_tail(&np->recv_list, skb);
+	}
+	clear_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
+}
+
 static void nv_do_nic_poll(struct timer_list *t)
 {
 	struct fe_priv *np = from_timer(np, t, nic_poll);
@@ -4129,6 +4214,8 @@ static void nv_do_nic_poll(struct timer_list *t)
 			nv_drain_rxtx(dev);
 			/* reinit driver view of the rx queue */
 			set_bufsize(dev);
+			nv_destroy_recv_cache(dev);
+			nv_init_recv_cache(dev);
 			if (nv_init_ring(dev)) {
 				if (!np->in_shutdown)
 					mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
@@ -4681,6 +4768,8 @@ static int nv_set_ringparam(struct net_device *dev, struct ethtool_ringparam* ri
 	if (netif_running(dev)) {
 		/* reinit driver view of the queues */
 		set_bufsize(dev);
+		nv_destroy_recv_cache(dev);
+		nv_init_recv_cache(dev);
 		if (nv_init_ring(dev)) {
 			if (!np->in_shutdown)
 				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
@@ -5402,6 +5491,10 @@ static int nv_open(struct net_device *dev)
 
 	/* initialize descriptor rings */
 	set_bufsize(dev);
+	nv_init_recv_cache(dev);
+
+	INIT_DELAYED_WORK(&np->recv_cache_work, nv_recv_cache_worker);
+	clear_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
 	oom = nv_init_ring(dev);
 
 	writel(0, base + NvRegLinkSpeed);
@@ -5583,6 +5676,9 @@ static int nv_close(struct net_device *dev)
 		nv_txrx_gate(dev, true);
 	}
 
+	/* free all SKBs in recv cache */
+	nv_destroy_recv_cache(dev);
+
 	/* FIXME: power down nic */
 
 	return 0;
-- 
2.7.4

