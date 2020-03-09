Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80D817E747
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgCISfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:35:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53411 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727323AbgCISfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:35:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3A4CE220F1;
        Mon,  9 Mar 2020 14:35:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 Mar 2020 14:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=LWc7MpU2TU1b9aDswT2UBDnMlQzfL/4hn38RQDbiA+A=; b=AvJunZHC
        +HhjpsLleulinVXudsMwndP9GyjjQ4ImDcBiw6zu/8xBncvluprvTsqn3tSE7AFk
        oR/t3jyja27+TOe/IG/dx5L6/OubCwaztrIQ0wLIMCVShqKQlLyWET1E4FTEJi/M
        X3IiCU0kMLuyw1FuCkb5IFtD+QA32X7Q2srBOOMTC+CaYuAS6VTIHtN2IFFoNgMZ
        YonVu5L1M7AKYk1VflgJ9XoSUvB+Eu7UBZphUYX9SzU9h1o8rY5DohYW+mL45GMK
        Q8Q1Whn0Q8jX3iAXAfwqdQeK5qClpVBdA5q+2MlXnL9AW4tu1h/xvrlumld0s2qR
        UUXbXnn31Ijcdg==
X-ME-Sender: <xms:h4xmXh3SU8sbhDw8n4gl1qhi3mX077I95TBJdZ93gVOiY2lBm7-Lfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucffohhmrghinhepshgvthdrihhsnecukfhppeejjedrudefke
    drvdegledrvddtleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:h4xmXsV5V1tMig07XJwombXUEt1jTh-MtXL0SPu0OwaM4KREWGkzfA>
    <xmx:h4xmXs7D7FQkNhTn9c5FYcasgPZv3d-gIF80Jayl-Xky5V7EuYENEQ>
    <xmx:h4xmXjJ8oRVMqu84DhaTrOmlXl0o-zZRUBwne5t4rw87McrGgmiKPQ>
    <xmx:h4xmXjEwb0Vjdrxdi8pIalhKo7_y1AfsU28EVkt8A01cAvYuwzPnEQ>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD39D3060F09;
        Mon,  9 Mar 2020 14:35:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/6] net: sched: RED: Introduce an ECN tail-dropping mode
Date:   Mon,  9 Mar 2020 20:35:00 +0200
Message-Id: <20200309183503.173802-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309183503.173802-1-idosch@idosch.org>
References: <20200309183503.173802-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

When the RED Qdisc is currently configured to enable ECN, the RED algorithm
is used to decide whether a certain SKB should be marked. If that SKB is
not ECN-capable, it is early-dropped.

It is also possible to keep all traffic in the queue, and just mark the
ECN-capable subset of it, as appropriate under the RED algorithm. Some
switches support this mode, and some installations make use of it.

To that end, add a new RED flag, TC_RED_TAILDROP. When the Qdisc is
configured with this flag, non-ECT traffic is enqueued (and tail-dropped
when the queue size is exhausted) instead of being early-dropped.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/pkt_cls.h          |  1 +
 include/net/red.h              |  5 +++++
 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_red.c            | 32 ++++++++++++++++++++++++++------
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 341a66af8d59..9ad369aba678 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -727,6 +727,7 @@ struct tc_red_qopt_offload_params {
 	u32 limit;
 	bool is_ecn;
 	bool is_harddrop;
+	bool is_taildrop;
 	struct gnet_stats_queue *qstats;
 };
 
diff --git a/include/net/red.h b/include/net/red.h
index bb7bac52c365..5f018205e57a 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -188,6 +188,11 @@ static inline bool red_check_flags(unsigned int flags,
 		return false;
 	}
 
+	if ((flags & TC_RED_TAILDROP) && !(flags & TC_RED_ECN)) {
+		NL_SET_ERR_MSG_MOD(extack, "taildrop mode is only meaningful with ECN");
+		return false;
+	}
+
 	return true;
 }
 
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index bbe791b24168..7293085ff157 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -272,6 +272,7 @@ struct tc_red_qopt {
 #define TC_RED_ECN		1
 #define TC_RED_HARDDROP		2
 #define TC_RED_ADAPTATIVE	4
+#define TC_RED_TAILDROP		8
 };
 
 struct tc_red_xstats {
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index f9839d68b811..d72db7643a37 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -44,7 +44,8 @@ struct red_sched_data {
 	struct Qdisc		*qdisc;
 };
 
-#define RED_SUPPORTED_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
+#define RED_SUPPORTED_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | \
+			     TC_RED_ADAPTATIVE | TC_RED_TAILDROP)
 
 static inline int red_use_ecn(struct red_sched_data *q)
 {
@@ -56,6 +57,11 @@ static inline int red_use_harddrop(struct red_sched_data *q)
 	return q->flags & TC_RED_HARDDROP;
 }
 
+static inline int red_use_taildrop(struct red_sched_data *q)
+{
+	return q->flags & TC_RED_TAILDROP;
+}
+
 static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
@@ -76,23 +82,36 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	case RED_PROB_MARK:
 		qdisc_qstats_overlimit(sch);
-		if (!red_use_ecn(q) || !INET_ECN_set_ce(skb)) {
+		if (!red_use_ecn(q)) {
 			q->stats.prob_drop++;
 			goto congestion_drop;
 		}
 
-		q->stats.prob_mark++;
+		if (INET_ECN_set_ce(skb)) {
+			q->stats.prob_mark++;
+		} else if (red_use_taildrop(q)) {
+			q->stats.prob_drop++;
+			goto congestion_drop;
+		}
+
+		/* Non-ECT packet in ECN taildrop mode: queue it. */
 		break;
 
 	case RED_HARD_MARK:
 		qdisc_qstats_overlimit(sch);
-		if (red_use_harddrop(q) || !red_use_ecn(q) ||
-		    !INET_ECN_set_ce(skb)) {
+		if (red_use_harddrop(q) || !red_use_ecn(q)) {
+			q->stats.forced_drop++;
+			goto congestion_drop;
+		}
+
+		if (INET_ECN_set_ce(skb)) {
+			q->stats.forced_mark++;
+		} else if (!red_use_taildrop(q)) {
 			q->stats.forced_drop++;
 			goto congestion_drop;
 		}
 
-		q->stats.forced_mark++;
+		/* Non-ECT packet in ECN taildrop mode: queue it. */
 		break;
 	}
 
@@ -167,6 +186,7 @@ static int red_offload(struct Qdisc *sch, bool enable)
 		opt.set.limit = q->limit;
 		opt.set.is_ecn = red_use_ecn(q);
 		opt.set.is_harddrop = red_use_harddrop(q);
+		opt.set.is_taildrop = red_use_taildrop(q);
 		opt.set.qstats = &sch->qstats;
 	} else {
 		opt.command = TC_RED_DESTROY;
-- 
2.24.1

