Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C80C4AD1CE
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 07:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347804AbiBHGwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 01:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346913AbiBHGws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 01:52:48 -0500
X-Greylist: delayed 542 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 22:52:47 PST
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C6DC0401EF
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 22:52:47 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644302623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6xP7BZ9F1nyN1TcSc1tGHcFJ8ICMaLqoqWx8tQJUo2A=;
        b=r+f6T/gDP8BMOnpfH0BmxVlmXVTD1aGOZCNLe5DtJwSohhmL3l6KOpkhJ2hcHTZn9l0Wnu
        a1/bwYabzPUEjWUmCXj/vIy/bE9wuI73R4pi66hEfLRpZrNAsgK+vpoc33Bcmn6bpglz55
        fNcW01CyBxVUDjFSpifrrGbRMZ349NA=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: dev: introduce netdev_drop_inc()
Date:   Tue,  8 Feb 2022 14:43:18 +0800
Message-Id: <20220208064318.1075849-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will use 'sudo perf record -g -a -e skb:kfree_skb' command to trace
the dropped packets when dropped increase in the output of ifconfig.
But there are two cases, one is only called kfree_skb(), another is
increasing the dropped and called kfree_skb(). The latter is what
we need. So we need to separate these two cases.

From the other side, the dropped packet came from the core network and
the driver, we also need to separate these two cases.

Add netdev_drop_inc() and add a tracepoint for the core network dropped
packets. use 'sudo perf record -g -a -e net:netdev_drop' and 'sudo perf
 script' will recored the dropped packets by the core network.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/linux/netdevice.h  |  7 +++++++
 include/trace/events/net.h | 27 +++++++++++++++++++++++++++
 net/core/dev.c             | 30 ++++++++++++++++++++++++------
 3 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3fb6fb67ed77..f7e8b1e33076 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2285,6 +2285,13 @@ struct net_device {
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
+enum netdev_drop {
+	NETDEV_RX_DROPPED,
+	NETDEV_TX_DROPPED,
+	NETDEV_RX_NOHANDLER,
+};
+void netdev_drop_inc(struct net_device *dev, enum netdev_drop drop);
+
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
 	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 78c448c6ab4c..0f8e9762a856 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -118,6 +118,33 @@ TRACE_EVENT(net_dev_xmit_timeout,
 		__get_str(name), __get_str(driver), __entry->queue_index)
 );
 
+TRACE_EVENT(netdev_drop,
+
+	TP_PROTO(struct net_device *dev, void *location),
+
+	TP_ARGS(dev, location),
+
+	TP_STRUCT__entry(
+		__string(name,          dev->name)
+		__field(void *,         location)
+		__field(unsigned long,  rx_dropped)
+		__field(unsigned long,  tx_dropped)
+		__field(unsigned long,  rx_nohandler)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev->name);
+		__entry->location     = location;
+		__entry->rx_dropped   = (unsigned long)atomic_long_read(&dev->rx_dropped);
+		__entry->tx_dropped   = (unsigned long)atomic_long_read(&dev->tx_dropped);
+		__entry->rx_nohandler = (unsigned long)atomic_long_read(&dev->rx_nohandler);
+	),
+
+	TP_printk("dev=%s rx_dropped=%lu tx_dropped=%lu rx_nohandler=%lu location=%p",
+		  __get_str(name), __entry->rx_dropped, __entry->tx_dropped, __entry->rx_nohandler,
+		  __entry->location)
+);
+
 DECLARE_EVENT_CLASS(net_dev_template,
 
 	TP_PROTO(struct sk_buff *skb),
diff --git a/net/core/dev.c b/net/core/dev.c
index f662c6a7d7b4..213f9d1eaa8d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -392,6 +392,24 @@ static void unlist_netdevice(struct net_device *dev)
 	dev_base_seq_inc(dev_net(dev));
 }
 
+void netdev_drop_inc(struct net_device *dev, enum netdev_drop drop)
+{
+	switch (drop) {
+	case NETDEV_RX_DROPPED:
+		atomic_long_inc(&dev->rx_dropped);
+		break;
+	case NETDEV_TX_DROPPED:
+		atomic_long_inc(&dev->tx_dropped);
+		break;
+	case NETDEV_RX_NOHANDLER:
+		atomic_long_inc(&dev->rx_nohandler);
+		break;
+	default:
+		break;
+	}
+	trace_netdev_drop(dev, __builtin_return_address(0));
+}
+EXPORT_SYMBOL(netdev_drop_inc);
 /*
  *	Our notifier list
  */
@@ -3586,7 +3604,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 out_kfree_skb:
 	kfree_skb(skb);
 out_null:
-	atomic_long_inc(&dev->tx_dropped);
+	netdev_drop_inc(dev, NETDEV_TX_DROPPED);
 	return NULL;
 }
 
@@ -4136,7 +4154,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	rc = -ENETDOWN;
 	rcu_read_unlock_bh();
 
-	atomic_long_inc(&dev->tx_dropped);
+	netdev_drop_inc(dev, NETDEV_TX_DROPPED);
 	kfree_skb_list(skb);
 	return rc;
 out:
@@ -4188,7 +4206,7 @@ int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 	local_bh_enable();
 	return ret;
 drop:
-	atomic_long_inc(&dev->tx_dropped);
+	netdev_drop_inc(dev, NETDEV_TX_DROPPED);
 	kfree_skb_list(skb);
 	return NET_XMIT_DROP;
 }
@@ -4557,7 +4575,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 
 	local_irq_restore(flags);
 
-	atomic_long_inc(&skb->dev->rx_dropped);
+	netdev_drop_inc(skb->dev, NETDEV_RX_DROPPED);
 	kfree_skb(skb);
 	return NET_RX_DROP;
 }
@@ -5319,9 +5337,9 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	} else {
 drop:
 		if (!deliver_exact)
-			atomic_long_inc(&skb->dev->rx_dropped);
+			netdev_drop_inc(skb->dev, NETDEV_RX_DROPPED);
 		else
-			atomic_long_inc(&skb->dev->rx_nohandler);
+			netdev_drop_inc(skb->dev, NETDEV_RX_NOHANDLER);
 		kfree_skb(skb);
 		/* Jamal, now you will not able to escape explaining
 		 * me how you were going to use this. :-)
-- 
2.25.1

