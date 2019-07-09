Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5885E63BED
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbfGIT3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:29:49 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:57840 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729103AbfGIT3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 15:29:48 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7286BB40071;
        Tue,  9 Jul 2019 19:29:47 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 9 Jul
 2019 12:29:43 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH net-next 3/3] net: use listified RX for handling
 GRO_NORMAL skbs
To:     David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
Message-ID: <73f51a03-e4bc-5b2a-6b04-3d69608b65d0@solarflare.com>
Date:   Tue, 9 Jul 2019 20:29:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24748.005
X-TM-AS-Result: No-5.299300-4.000000-10
X-TMASE-MatchedRID: sUyKNvGW0IzKwN16h9UrzYbV85w+dhNK3WFaxVW7M2j5LkL/TyFZzWeR
        BFuDVenEnbLB5zXDLB2NbrkeBy1VEOrio6p+t0cn9uIPtqMvtZBbD9LQcHt6g4a99Umv81URPce
        F8D/DWUBLXsRJE17xkXDlPghqPnfyYlldA0POS1KKYdYQLbymTbto11mU6Hl80SxMhOhuA0QOp2
        0k3epy6bI8I7aC+mrEDvKAJFGGt+SD66TlvUkVYGY+xOrx57jW2LlbtF/6zpCLxWuV11DGxoKf6
        0S1dkoA4TaAoQNTPViDfOmzG3QTUNTFyyH6K17fpqbreSinCdOC7C2rJeUToRw0HKhKjTfpRyqM
        LIj/WA1gFIAgRGpqPEk9Dfhu2L8aOXyRIvc0XEOeAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0e
        Ps7A07YFInLyeDAoZyQuNvzwGYqiV9RcM8WVOvLzmoY38A24tjqpz3aMM22BhKFR4oY/kyg==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.299300-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24748.005
X-MDID: 1562700588-DfotKpML3CrA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When GRO decides not to coalesce a packet, in napi_frags_finish(), instead
 of passing it to the stack immediately, place it on a list in the napi
 struct.  Then, at flush time (napi_complete_done() or napi_poll()), call
 netif_receive_skb_list_internal() on the list.  We'd like to do that in
 napi_gro_flush(), but it's not called if !napi->gro_bitmask, so we have to
 do it in the callers instead.  (There are a handful of drivers that call
 napi_gro_flush() themselves, but it's not clear why, or whether this will
 affect them.)
Because a full 64 packets is an inefficiently large batch, also consume the
 list whenever it exceeds gro_normal_batch, a new net/core sysctl that
 defaults to 8.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 include/linux/netdevice.h  |  3 +++
 net/core/dev.c             | 32 ++++++++++++++++++++++++++++++--
 net/core/sysctl_net_core.c |  8 ++++++++
 3 files changed, 41 insertions(+), 2 deletions(-)

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
index fc676b2610e3..4b6f2ec67fbc 100644
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
 
@@ -6267,6 +6291,8 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 	napi->timer.function = napi_watchdog;
 	init_gro_hash(napi);
 	napi->skb = NULL;
+	INIT_LIST_HEAD(&napi->rx_list);
+	napi->rx_count = 0;
 	napi->poll = poll;
 	if (weight > NAPI_POLL_WEIGHT)
 		netdev_err_once(dev, "%s() called with weight %d\n", __func__,
@@ -6363,6 +6389,8 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
 
