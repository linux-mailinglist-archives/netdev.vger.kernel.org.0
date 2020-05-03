Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43321C296C
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 04:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgECCyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 22:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726737AbgECCya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 22:54:30 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D40C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 19:54:29 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id i2so14824818qkl.5
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 19:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fWjzSYjTGco7pWuHebrBfRYVO4oH3x5pydhOrUh5rCo=;
        b=ud9JjMvZ+28hw6ozGPsiaX6fsq0pWj/1tnUJyogdFXU6WCifXltdBWfPOqQ+4m0aJA
         z6cbqK7M8cu6ax6hOiqdhLSpLIBPvj0EPSQa69fN+G26+PGvQoiZWgAQ+c+1KhSTKm6B
         I7UGGvbNweY9xZPD7lQmOyRBLbxzLYcaQUJGaJ1x3wrla5f9mzrHYdpQ++Sq9lV42msl
         RJTM4MEaDYQ15YGwyQwTCnLGMEicuqjaotp7QQlaF0dCzrgt5/NrNHKa8uB+q6TD0rgP
         K7vJlk7KbCAED5v+ilouCR2mKZ+YQERfToIBJFc7WritwQmnI36sWAp+j0iplWffS+xo
         sZnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fWjzSYjTGco7pWuHebrBfRYVO4oH3x5pydhOrUh5rCo=;
        b=VLd9fXiNfcEobkCsPJS2OeiyXp4na2UZ09vJDoPhrJO8hPqmPhJLPVstFbez++g7W5
         +DRqn/O3gqd2pKCMZwe+1QFUJXqmJySHQqH3gok76XbRj0YTWoU/xb1d0L929UR3nqBi
         cvtyJ4zfCI0F33jpPWkJNIzMCbk4jvi9t5olCm6ZdfhYHNkLpIh6Twk41GS3mnSu/KPn
         CSl5amXFJ76NvMTHCox+j/eypj/MhaI4pC9QIYcQkwhWEyz8VLNJXD536+EjR/q4GF25
         q+NIyAXE9L2EaRlbevLTaN4Rt2rYxnvgTZBe6wnCO+l0ZMsXkCD/gGGlcaVNHESok42/
         eGng==
X-Gm-Message-State: AGi0PuboMO/g/1xaOTar2C5ZewAe6tPWp2RQhSLAW+v6W/IV69azr0mn
        qEHHrW1UzWMMqNBFH5wlO4n2BQm3Hymx3Q==
X-Google-Smtp-Source: APiQypLuljkL39yAbyazNqXN9+Muv+kNFv8wbpr8eN43afXjocWup1EJioebCqDSjJuDtNcdbJbyhO3w3JwvWQ==
X-Received: by 2002:a05:6214:12e4:: with SMTP id w4mr10540199qvv.190.1588474468317;
 Sat, 02 May 2020 19:54:28 -0700 (PDT)
Date:   Sat,  2 May 2020 19:54:18 -0700
In-Reply-To: <20200503025422.219257-1-edumazet@google.com>
Message-Id: <20200503025422.219257-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200503025422.219257-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 1/5] net_sched: sch_fq: avoid touching f->next from fq_gc()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A significant amount of cpu cycles is spent in fq_gc()

When fq_gc() does its lookup in the rb-tree, it needs the
following fields from struct fq_flow :

f->sk       (lookup key in the rb-tree)
f->fq_node  (anchor in the rb-tree)
f->next     (used to determine if the flow is detached)
f->age      (used to determine if the flow is candidate for gc)

This unfortunately spans two cache lines (assuming 64 bytes cache lines)

We can avoid using f->next, if we use the low order bit of f->{age|tail}

This low order bit is 0, if f->tail points to an sk_buff.
We set the low order bit to 1, if the union contains a jiffies value.

Combined with the following patch, this makes sure we only need
to bring into cpu caches one cache line per flow.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index fa228df22e5dbf3fb5eb18279b79ab397d36ac58..1649928fe2c1b7476050e5eee3c494c76d114c62 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -70,14 +70,14 @@ struct fq_flow {
 	struct sk_buff	*head;		/* list of skbs for this flow : first skb */
 	union {
 		struct sk_buff *tail;	/* last skb in the list */
-		unsigned long  age;	/* jiffies when flow was emptied, for gc */
+		unsigned long  age;	/* (jiffies | 1UL) when flow was emptied, for gc */
 	};
 	struct rb_node	fq_node;	/* anchor in fq_root[] trees */
 	struct sock	*sk;
 	int		qlen;		/* number of packets in flow queue */
 	int		credit;
 	u32		socket_hash;	/* sk_hash */
-	struct fq_flow *next;		/* next pointer in RR lists, or &detached */
+	struct fq_flow *next;		/* next pointer in RR lists */
 
 	struct rb_node  rate_node;	/* anchor in q->delayed tree */
 	u64		time_next_packet;
@@ -130,20 +130,25 @@ struct fq_sched_data {
 	struct qdisc_watchdog watchdog;
 };
 
-/* special value to mark a detached flow (not on old/new list) */
-static struct fq_flow detached, throttled;
-
+/*
+ * f->tail and f->age share the same location.
+ * We can use the low order bit to differentiate if this location points
+ * to a sk_buff or contains a jiffies value, if we force this value to be odd.
+ * This assumes f->tail low order bit must be 0 since alignof(struct sk_buff) >= 2
+ */
 static void fq_flow_set_detached(struct fq_flow *f)
 {
-	f->next = &detached;
-	f->age = jiffies;
+	f->age = jiffies | 1UL;
 }
 
 static bool fq_flow_is_detached(const struct fq_flow *f)
 {
-	return f->next == &detached;
+	return !!(f->age & 1UL);
 }
 
+/* special value to mark a throttled flow (not on old/new list) */
+static struct fq_flow throttled;
+
 static bool fq_flow_is_throttled(const struct fq_flow *f)
 {
 	return f->next == &throttled;
-- 
2.26.2.526.g744177e7f7-goog

