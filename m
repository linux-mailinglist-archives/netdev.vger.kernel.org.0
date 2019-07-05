Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58FD600EF
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 08:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfGEGNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 02:13:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35684 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfGEGNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 02:13:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6569Ucg038871;
        Fri, 5 Jul 2019 06:13:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=7AwnfSnuPhOv2+hbEz19CmvEQrS+s7LjFvBAuCy4Q04=;
 b=tNi7pIXyFwJzdwQbtEFNZFCi4DihMmWyZfWnREJq9vtBsUzn+jbiyfr/JIJk7+5tZcHz
 UKxOztprj10dxaLwqVfXb8hbxZg0ZpWAliizBmUdkrPbzEhUIJYDV58RTidg3Xwu5C0D
 rBby2fAw1AMU3TzyyOzdU7vNDs7xje5NetXPrtCODf0Gb+6X2uUtGMmQ8RuG+EEQd4Fv
 zyYuIDqh5LktM/8OQnoOiKlsPvKF/4+aDYQ16Szwrw/6y+rxB3O5bB9VsShli+41glv5
 WycWPDn2C4Rh4SKQju41UnosKirWJDQIbBik7W9u34yGc50N0RKB5ms0We0Z/gNprP8/ MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2te61eh5ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 06:13:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6567fjj108136;
        Fri, 5 Jul 2019 06:11:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2th9ec9cfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 06:11:30 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x656BT2Y031364;
        Fri, 5 Jul 2019 06:11:29 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Jul 2019 23:11:29 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     yanjun.zhu@oracle.com, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH 2/2] forcedeth: disable recv cache by default
Date:   Fri,  5 Jul 2019 02:19:28 -0400
Message-Id: <1562307568-21549-3-git-send-email-yanjun.zhu@oracle.com>
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

The recv cache is to allocate 125MiB memory to reserve for NIC.
In the past time, this recv cache works very well. When the memory
is not enough, this recv cache reserves memory for NIC.
And the communications through this NIC is not affected by the
memory shortage. And the performance of NIC is better because of
this recv cache.
But this recv cache reserves 125MiB memory for one NIC port. Normally
there are 2 NIC ports in one card. So in a host, there are about 250
MiB memory reserved for NIC ports. To a host on which communications
are not mandatory, it is not necessary to reserve memory.
So this recv cache is disabled by default.

CC: Joe Jin <joe.jin@oracle.com>
CC: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 drivers/net/ethernet/nvidia/Kconfig     | 11 +++++++++++
 drivers/net/ethernet/nvidia/Makefile    |  1 +
 drivers/net/ethernet/nvidia/forcedeth.c | 34 ++++++++++++++++++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/Kconfig b/drivers/net/ethernet/nvidia/Kconfig
index faacbd1..9a9f42a 100644
--- a/drivers/net/ethernet/nvidia/Kconfig
+++ b/drivers/net/ethernet/nvidia/Kconfig
@@ -26,4 +26,15 @@ config FORCEDETH
 	  To compile this driver as a module, choose M here. The module
 	  will be called forcedeth.
 
+config	FORCEDETH_RECV_CACHE
+	bool "nForce Ethernet recv cache support"
+	depends on FORCEDETH
+	default n
+	---help---
+	  The recv cache can make nic work steadily when the system memory is
+	  not enough. And it can also enhance nic performance. But to a host
+	  on which the communications are not mandatory, it is not necessary
+	  to reserve 125MiB memory for NIC.
+	  So recv cache is disabled by default.
+
 endif # NET_VENDOR_NVIDIA
diff --git a/drivers/net/ethernet/nvidia/Makefile b/drivers/net/ethernet/nvidia/Makefile
index 8935699..40c055e 100644
--- a/drivers/net/ethernet/nvidia/Makefile
+++ b/drivers/net/ethernet/nvidia/Makefile
@@ -4,3 +4,4 @@
 #
 
 obj-$(CONFIG_FORCEDETH) += forcedeth.o
+ccflags-$(CONFIG_FORCEDETH_RECV_CACHE)	:=	-DFORCEDETH_RECV_CACHE
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index a673005..59f813b 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -674,10 +674,12 @@ struct nv_ethtool_stats {
 	u64 tx_broadcast;
 };
 
+#ifdef FORCEDETH_RECV_CACHE
 /* 1000Mb is 125M bytes, 125 * 1024 * 1024 bytes
  * The length of recv cache is 125M / skb_length
  */
 #define RECV_CACHE_LIST_LENGTH		(125 * 1024 * 1024 / np->rx_buf_sz)
+#endif
 
 #define NV_DEV_STATISTICS_V3_COUNT (sizeof(struct nv_ethtool_stats)/sizeof(u64))
 #define NV_DEV_STATISTICS_V2_COUNT (NV_DEV_STATISTICS_V3_COUNT - 3)
@@ -850,17 +852,22 @@ struct fe_priv {
 	char name_tx[IFNAMSIZ + 3];       /* -tx    */
 	char name_other[IFNAMSIZ + 6];    /* -other */
 
+#ifdef FORCEDETH_RECV_CACHE
 	/* This is to schedule work */
 	struct delayed_work     recv_cache_work;
 	/* This list is to store skb queue for recv */
 	struct sk_buff_head recv_list;
 	unsigned long nv_recv_list_state;
+#endif
 };
 
+#ifdef FORCEDETH_RECV_CACHE
 /* This is recv list state to fill up recv cache */
 enum recv_list_state {
 	RECV_LIST_ALLOCATE
 };
+#endif
+
 /*
  * Maximum number of loops until we assume that a bit in the irq mask
  * is stuck. Overridable with module param.
@@ -1819,11 +1826,15 @@ static int nv_alloc_rx(struct net_device *dev)
 		less_rx = np->last_rx.orig;
 
 	while (np->put_rx.orig != less_rx) {
+#ifdef FORCEDETH_RECV_CACHE
 		struct sk_buff *skb = skb_dequeue(&np->recv_list);
 
 		if (!test_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state))
 			schedule_delayed_work(&np->recv_cache_work, 0);
-
+#else
+		struct sk_buff *skb = netdev_alloc_skb(np->dev,
+					 np->rx_buf_sz + NV_RX_ALLOC_PAD);
+#endif
 		if (likely(skb)) {
 			np->put_rx_ctx->skb = skb;
 			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
@@ -1864,11 +1875,15 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
 		less_rx = np->last_rx.ex;
 
 	while (np->put_rx.ex != less_rx) {
+#ifdef FORCEDETH_RECV_CACHE
 		struct sk_buff *skb = skb_dequeue(&np->recv_list);
 
 		if (!test_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state))
 			schedule_delayed_work(&np->recv_cache_work, 0);
-
+#else
+		struct sk_buff *skb = netdev_alloc_skb(np->dev,
+					np->rx_buf_sz + NV_RX_ALLOC_PAD);
+#endif
 		if (likely(skb)) {
 			np->put_rx_ctx->skb = skb;
 			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
@@ -1980,6 +1995,7 @@ static void nv_init_tx(struct net_device *dev)
 	}
 }
 
+#ifdef FORCEDETH_RECV_CACHE
 static void nv_init_recv_cache(struct net_device *dev)
 {
 	struct fe_priv *np = netdev_priv(dev);
@@ -2013,6 +2029,7 @@ static void nv_destroy_recv_cache(struct net_device *dev)
 
 	WARN_ON(skb_queue_len(&np->recv_list));
 }
+#endif
 
 static int nv_init_ring(struct net_device *dev)
 {
@@ -3104,8 +3121,10 @@ static int nv_change_mtu(struct net_device *dev, int new_mtu)
 		nv_drain_rxtx(dev);
 		/* reinit driver view of the rx queue */
 		set_bufsize(dev);
+#ifdef FORCEDETH_RECV_CACHE
 		nv_destroy_recv_cache(dev);
 		nv_init_recv_cache(dev);
+#endif
 		if (nv_init_ring(dev)) {
 			if (!np->in_shutdown)
 				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
@@ -4133,6 +4152,7 @@ static void nv_free_irq(struct net_device *dev)
 	}
 }
 
+#ifdef FORCEDETH_RECV_CACHE
 static void nv_recv_cache_worker(struct work_struct *work)
 {
 	struct fe_priv *np = container_of(work, struct fe_priv,
@@ -4158,6 +4178,7 @@ static void nv_recv_cache_worker(struct work_struct *work)
 	}
 	clear_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
 }
+#endif
 
 static void nv_do_nic_poll(struct timer_list *t)
 {
@@ -4214,8 +4235,10 @@ static void nv_do_nic_poll(struct timer_list *t)
 			nv_drain_rxtx(dev);
 			/* reinit driver view of the rx queue */
 			set_bufsize(dev);
+#ifdef FORCEDETH_RECV_CACHE
 			nv_destroy_recv_cache(dev);
 			nv_init_recv_cache(dev);
+#endif
 			if (nv_init_ring(dev)) {
 				if (!np->in_shutdown)
 					mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
@@ -4768,8 +4791,10 @@ static int nv_set_ringparam(struct net_device *dev, struct ethtool_ringparam* ri
 	if (netif_running(dev)) {
 		/* reinit driver view of the queues */
 		set_bufsize(dev);
+#ifdef FORCEDETH_RECV_CACHE
 		nv_destroy_recv_cache(dev);
 		nv_init_recv_cache(dev);
+#endif
 		if (nv_init_ring(dev)) {
 			if (!np->in_shutdown)
 				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
@@ -5491,10 +5516,12 @@ static int nv_open(struct net_device *dev)
 
 	/* initialize descriptor rings */
 	set_bufsize(dev);
+#ifdef FORCEDETH_RECV_CACHE
 	nv_init_recv_cache(dev);
 
 	INIT_DELAYED_WORK(&np->recv_cache_work, nv_recv_cache_worker);
 	clear_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
+#endif
 	oom = nv_init_ring(dev);
 
 	writel(0, base + NvRegLinkSpeed);
@@ -5676,9 +5703,10 @@ static int nv_close(struct net_device *dev)
 		nv_txrx_gate(dev, true);
 	}
 
+#ifdef FORCEDETH_RECV_CACHE
 	/* free all SKBs in recv cache */
 	nv_destroy_recv_cache(dev);
-
+#endif
 	/* FIXME: power down nic */
 
 	return 0;
-- 
2.7.4

