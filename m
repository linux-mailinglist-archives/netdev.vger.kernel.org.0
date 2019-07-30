Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B1D7B5A7
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 00:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388081AbfG3WVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 18:21:43 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56222 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387946AbfG3WVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 18:21:42 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E6BFB80070;
        Tue, 30 Jul 2019 22:21:40 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 30 Jul
 2019 15:21:37 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH v2 net-next 3/3] net: use listified RX for handling
 GRO_NORMAL skbs
To:     David Miller <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>,
        netdev <netdev@vger.kernel.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>
References: <9bcebf59-a0e7-f461-36ef-8564ecb33282@solarflare.com>
Message-ID: <9e4ded56-ab86-444d-f37e-1c0b5898ffdc@solarflare.com>
Date:   Tue, 30 Jul 2019 23:21:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <9bcebf59-a0e7-f461-36ef-8564ecb33282@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24810.005
X-TM-AS-Result: No-1.483300-4.000000-10
X-TMASE-MatchedRID: TKn6ZIai6dLKwN16h9UrzYbV85w+dhNK3WFaxVW7M2gPlzJSBZBv1aug
        UFxFBp3uG1ka/sXRDMM8pc2TPmsEmDioZoQj+LvGuoibJpHRrFmo0+WMW5QyiX5Isu006IGGKrU
        t7wST3HUovVGYpPY1pvWJifqwo44RIeFIFB+CV+wD2WXLXdz+AS9Xl/s/QdUMqUWwvF+Noemoqd
        fL9A1mFfsgPUthMfdWsgBrZaAKIwIqHnF/HDVTocn9tWHiLD2G9fvWztwgm5NVZCccrGnfyLv9B
        oX1wbnF5OwtT7igF3IA/1OfGloJ/x8owvkAm18tzNIobH2DzGHJdPzrUs4bbLKeTtOdjMy6W2g2
        r2LI8m284YboA40xfweVY2lBlw7gEnYSfd7qcmT0hv/rD7WVZAILzOoe9wbaiiKPXbEds+4cUnI
        Iyt02SQlf3FsdyZ+9V7dIi1ZiKvqvvxILmKK/HDl/1fD/GopdcmfM3DjaQLHEQdG7H66TyHEqm8
        QYBtMOZxaQep9QXsKOhNqV/tcbww0hScO7iNRzQ0hH0pYJBJcfsqMFHrxsdyzDiK4If8VUiCfOc
        HaWUC6W3hdorIaOvbQKq19iyUewGhBWFwMpQfUlEjOZsGnBpCAkKbrKkYtniQWaoMYDBaY=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.483300-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24810.005
X-MDID: 1564525301-gx7TNsW5FEp4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When GRO decides not to coalesce a packet, in napi_frags_finish(), instead
 of passing it to the stack immediately, place it on a list in the napi
 struct.  Then, at flush time (napi_complete_done(), napi_poll(), or
 napi_busy_loop()), call netif_receive_skb_list_internal() on the list.
We'd like to do that in napi_gro_flush(), but it's not called if
 !napi->gro_bitmask, so we have to do it in the callers instead.  (There are
 a handful of drivers that call napi_gro_flush() themselves, but it's not
 clear why, or whether this will affect them.)
Because a full 64 packets is an inefficiently large batch, also consume the
 list whenever it exceeds gro_normal_batch, a new net/core sysctl that
 defaults to 8.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 include/linux/netdevice.h  |  3 +++
 net/core/dev.c             | 44 +++++++++++++++++++++++++++++++++++---
 net/core/sysctl_net_core.c |  8 +++++++
 3 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 88292953aa6f..55ac223553f8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -332,6 +332,8 @@ struct napi_struct {
 	struct net_device	*dev;
 	struct gro_list		gro_hash[GRO_HASH_BUCKETS];
 	struct sk_buff		*skb;
+	struct list_head	rx_list; /* Pending GRO_NORMAL skbs */
+	int			rx_count; /* length of rx_list */
 	struct hrtimer		timer;
 	struct list_head	dev_list;
 	struct hlist_node	napi_hash_node;
@@ -4239,6 +4241,7 @@ extern int		dev_weight_rx_bias;
 extern int		dev_weight_tx_bias;
 extern int		dev_rx_weight;
 extern int		dev_tx_weight;
+extern int		gro_normal_batch;
 
 bool netdev_has_upper_dev(struct net_device *dev, struct net_device *upper_dev);
 struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
diff --git a/net/core/dev.c b/net/core/dev.c
index fc676b2610e3..b749eb2bfb0c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3963,6 +3963,8 @@ int dev_weight_rx_bias __read_mostly = 1;  /* bias for backlog weight */
 int dev_weight_tx_bias __read_mostly = 1;  /* bias for output_queue quota */
 int dev_rx_weight __read_mostly = 64;
 int dev_tx_weight __read_mostly = 64;
+/* Maximum number of GRO_NORMAL skbs to batch up for list-RX */
+int gro_normal_batch __read_mostly = 8;
 
 /* Called with irq disabled */
 static inline void ____napi_schedule(struct softnet_data *sd,
@@ -5742,6 +5744,26 @@ struct sk_buff *napi_get_frags(struct napi_struct *napi)
 }
 EXPORT_SYMBOL(napi_get_frags);
 
+/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
+static void gro_normal_list(struct napi_struct *napi)
+{
+	if (!napi->rx_count)
+		return;
+	netif_receive_skb_list_internal(&napi->rx_list);
+	INIT_LIST_HEAD(&napi->rx_list);
+	napi->rx_count = 0;
+}
+
+/* Queue one GRO_NORMAL SKB up for list processing.  If batch size exceeded,
+ * pass the whole batch up to the stack.
+ */
+static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
+{
+	list_add_tail(&skb->list, &napi->rx_list);
+	if (++napi->rx_count >= gro_normal_batch)
+		gro_normal_list(napi);
+}
+
 static gro_result_t napi_frags_finish(struct napi_struct *napi,
 				      struct sk_buff *skb,
 				      gro_result_t ret)
@@ -5751,8 +5773,8 @@ static gro_result_t napi_frags_finish(struct napi_struct *napi,
 	case GRO_HELD:
 		__skb_push(skb, ETH_HLEN);
 		skb->protocol = eth_type_trans(skb, skb->dev);
-		if (ret == GRO_NORMAL && netif_receive_skb_internal(skb))
-			ret = GRO_DROP;
+		if (ret == GRO_NORMAL)
+			gro_normal_one(napi, skb);
 		break;
 
 	case GRO_DROP:
@@ -6029,6 +6051,8 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 				 NAPIF_STATE_IN_BUSY_POLL)))
 		return false;
 
+	gro_normal_list(n);
+
 	if (n->gro_bitmask) {
 		unsigned long timeout = 0;
 
@@ -6114,10 +6138,19 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
 	 * Ideally, a new ndo_busy_poll_stop() could avoid another round.
 	 */
 	rc = napi->poll(napi, BUSY_POLL_BUDGET);
+	/* We can't gro_normal_list() here, because napi->poll() might have
+	 * rearmed the napi (napi_complete_done()) in which case it could
+	 * already be running on another CPU.
+	 */
 	trace_napi_poll(napi, rc, BUSY_POLL_BUDGET);
 	netpoll_poll_unlock(have_poll_lock);
-	if (rc == BUSY_POLL_BUDGET)
+	if (rc == BUSY_POLL_BUDGET) {
+		/* As the whole budget was spent, we still own the napi so can
+		 * safely handle the rx_list.
+		 */
+		gro_normal_list(napi);
 		__napi_schedule(napi);
+	}
 	local_bh_enable();
 }
 
@@ -6162,6 +6195,7 @@ void napi_busy_loop(unsigned int napi_id,
 		}
 		work = napi_poll(napi, BUSY_POLL_BUDGET);
 		trace_napi_poll(napi, work, BUSY_POLL_BUDGET);
+		gro_normal_list(napi);
 count:
 		if (work > 0)
 			__NET_ADD_STATS(dev_net(napi->dev),
@@ -6267,6 +6301,8 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 	napi->timer.function = napi_watchdog;
 	init_gro_hash(napi);
 	napi->skb = NULL;
+	INIT_LIST_HEAD(&napi->rx_list);
+	napi->rx_count = 0;
 	napi->poll = poll;
 	if (weight > NAPI_POLL_WEIGHT)
 		netdev_err_once(dev, "%s() called with weight %d\n", __func__,
@@ -6363,6 +6399,8 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 		goto out_unlock;
 	}
 
+	gro_normal_list(n);
+
 	if (n->gro_bitmask) {
 		/* flush too old packets
 		 * If HZ < 1000, flush all packets.
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index f9204719aeee..dba52f53eace 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -569,6 +569,14 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_do_static_key,
 	},
+	{
+		.procname	= "gro_normal_batch",
+		.data		= &gro_normal_batch,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+	},
 	{ }
 };
 
