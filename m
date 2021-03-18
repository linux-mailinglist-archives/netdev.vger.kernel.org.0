Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D329E34004E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 08:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhCRHfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 03:35:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55846 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhCRHfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 03:35:24 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616052923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJllEztXUvBTqFdL0vrfNIskyAFol/VtCOfL4X5tRTA=;
        b=Zgl7TPlOpjQbvthyIAD5J+zizPiw5heS3qzbwZ2aMmoSfmDL6zLYiOK4agKLbD/1XUg4CJ
        5VvDg3evG88DZ18GHwQmobIXPDlxAiZ2+1EuswRZqvRSo1tvgiCNBK7Ck+fku3zxpENZjZ
        wQ/hJjqvQ8ZQWxkX9MBuIEzTWOXR4IMiETtVbYprTzKkUoRTdVu4nbKZw8WjW1b0nRTCBV
        LFO7GGIIAcBwZwo17X6Jm3DIxRG4bsQihdX8hmhUwXOeFcMQakfZ6VtgE5ARlFEqffNnwy
        fLkq4Sh6qds8gao9cFVi8gcAB2EaeuJ0trwKvsrDzoPJwduLtAChz/pVc1VySQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616052923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJllEztXUvBTqFdL0vrfNIskyAFol/VtCOfL4X5tRTA=;
        b=H/4L/ubn4P1CI7QjSCO2GZ0XKlVuInxb+4Sg+PIt8wAmxZItq1OdDPZEFSGemKJE60qhn6
        Pr7WZ8TZjHHuuPAg==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 1/1] taprio: Handle short intervals and large packets
Date:   Thu, 18 Mar 2021 08:34:55 +0100
Message-Id: <20210318073455.17281-2-kurt@linutronix.de>
In-Reply-To: <20210318073455.17281-1-kurt@linutronix.de>
References: <20210318073455.17281-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using short intervals e.g. below one millisecond, large packets won't be
transmitted at all. The software implementations checks whether the packet can
be fit into the remaining interval. Therefore, it takes the packet length and
the transmission speed into account. That is correct.

However, for large packets it may be that the transmission time exceeds the
interval resulting in no packet transmission. The same situation works fine with
hardware offloading applied.

The problem has been observed with the following schedule and iperf3:

|tc qdisc replace dev lan1 parent root handle 100 taprio \
|   num_tc 8 \
|   map 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7 \
|   queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
|   base-time $base \
|   sched-entry S 0x40 500000 \
|   sched-entry S 0xbf 500000 \
|   clockid CLOCK_TAI \
|   flags 0x00

[...]

|root@tsn:~# iperf3 -c 192.168.2.105
|Connecting to host 192.168.2.105, port 5201
|[  5] local 192.168.2.121 port 52610 connected to 192.168.2.105 port 5201
|[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
|[  5]   0.00-1.00   sec  45.2 KBytes   370 Kbits/sec    0   1.41 KBytes
|[  5]   1.00-2.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes

After debugging, it seems that the packet length stored in the SKB is about
7000-8000 bytes. Using a 100 Mbit/s link the transmission time is about 600us
which larger than the interval of 500us.

Therefore, segment the SKB into smaller chunks if the packet is too big. This
yields similar results than the hardware offload:

|root@tsn:~# iperf3 -c 192.168.2.105
|Connecting to host 192.168.2.105, port 5201
|- - - - - - - - - - - - - - - - - - - - - - - - -
|[ ID] Interval           Transfer     Bitrate         Retr
|[  5]   0.00-10.00  sec  48.9 MBytes  41.0 Mbits/sec    0             sender
|[  5]   0.00-10.02  sec  48.7 MBytes  40.7 Mbits/sec                  receiver

Furthermore, the segmentation can be skipped for the full offload case, as the
driver or the hardware is expected to handle this.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 net/sched/sch_taprio.c | 64 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8287894541e3..922ed6b91abb 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -411,18 +411,10 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
 	return txtime;
 }
 
-static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
-			  struct sk_buff **to_free)
+static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
+			      struct Qdisc *child, struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
-	struct Qdisc *child;
-	int queue;
-
-	queue = skb_get_queue_mapping(skb);
-
-	child = q->qdiscs[queue];
-	if (unlikely(!child))
-		return qdisc_drop(skb, sch, to_free);
 
 	if (skb->sk && sock_flag(skb->sk, SOCK_TXTIME)) {
 		if (!is_valid_interval(skb, sch))
@@ -439,6 +431,58 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return qdisc_enqueue(skb, child, to_free);
 }
 
+static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+			  struct sk_buff **to_free)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct Qdisc *child;
+	int queue;
+
+	queue = skb_get_queue_mapping(skb);
+
+	child = q->qdiscs[queue];
+	if (unlikely(!child))
+		return qdisc_drop(skb, sch, to_free);
+
+	/* Large packets might not be transmitted when the transmission duration
+	 * exceeds any configured interval. Therefore, segment the skb into
+	 * smaller chunks. Skip it for the full offload case, as the driver
+	 * and/or the hardware is expected to handle this.
+	 */
+	if (skb_is_gso(skb) && !FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+		unsigned int slen = 0, numsegs = 0, len = qdisc_pkt_len(skb);
+		netdev_features_t features = netif_skb_features(skb);
+		struct sk_buff *segs, *nskb;
+		int ret;
+
+		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+		if (IS_ERR_OR_NULL(segs))
+			return qdisc_drop(skb, sch, to_free);
+
+		skb_list_walk_safe(segs, segs, nskb) {
+			skb_mark_not_on_list(segs);
+			qdisc_skb_cb(segs)->pkt_len = segs->len;
+			slen += segs->len;
+
+			ret = taprio_enqueue_one(segs, sch, child, to_free);
+			if (ret != NET_XMIT_SUCCESS) {
+				if (net_xmit_drop_count(ret))
+					qdisc_qstats_drop(sch);
+			} else {
+				numsegs++;
+			}
+		}
+
+		if (numsegs > 1)
+			qdisc_tree_reduce_backlog(sch, 1 - numsegs, len - slen);
+		consume_skb(skb);
+
+		return numsegs > 0 ? NET_XMIT_SUCCESS : NET_XMIT_DROP;
+	}
+
+	return taprio_enqueue_one(skb, sch, child, to_free);
+}
+
 static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
-- 
2.20.1

