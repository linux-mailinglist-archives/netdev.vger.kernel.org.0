Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45444AA2E5
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 14:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732595AbfIEMU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 08:20:27 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:36060 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfIEMU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 08:20:27 -0400
Received: by mail-ua1-f73.google.com with SMTP id t8so283461uaq.3
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 05:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+YiXRV2wgKBm9gn4xVvMlYra2CziYJZyDLgxhVElrUM=;
        b=NEUUfthsmY424w71yLpR48VKg2APiw9eV+IsmSvqH7edQq58RHFX/NnPKkolEx/33v
         WPmqc+6kAlxi5AN/8vL0cfjZwhT1GhVcY703Oxbm+YO386xGh2cnrCEWo5mALFM8G5eT
         IM5UxpDq6434a0ngOx2Jebdl/wHEs2wltOlb7llJ0u1ETBIIy2QBenEMKq4zIFYLgHob
         uAXdA8647ueAZBI4W5NBIArTifZoKncoPthXxbUpiDBsF8orRp6BTqEgqy0YwW5IXYSV
         UFGT0k9Gy6GkGvbPWpiITMVVYA9+lhNS8DjWqU2MTk46UzI4HI8V2EsBN3Y9OLUfuBPj
         z7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+YiXRV2wgKBm9gn4xVvMlYra2CziYJZyDLgxhVElrUM=;
        b=hKT/Tcx8+wl3mpQpCW3w0KfaQ9kNbUEXg8ZknBxHMYnjFoj38RJQsa0K2ka9carcOG
         pGJP1AW7SvIFv5oZUisM3kfu1dKKp/Q9Yn2TAY0TCxRiuhoej/MlZRx/HGI5/glcr4KI
         9OGc28Ag27nXcAv+bfFC4pdMVt0a5jnZgYcbj8th3PZvr9VGRrRfXCnOj6zmPunVs3pu
         I+KGpvFnAgjI8dGPbJaxQoFocHXAhik1q2KI1Qv0J9FFxt5CJ9Pq9CrGTm+pltyJamjF
         v67FCgsv1rL2Aj0YFFu0TAxrga/T1/w1opPZFQ35nYAUEIAfGq0ffJ66Fpk7NNvRASY0
         H55g==
X-Gm-Message-State: APjAAAUxc8jq0BQaV2BEz2oetoVFc4g3Ci4dSybdgMlTzU3clm+lLsTE
        bjyDeLLKZCYsKBH7SBz85MTysI1pBK0Dww==
X-Google-Smtp-Source: APXvYqzBjhYtyVOSvg63FRsIf2Xfq2PfQQ0/gPhj/JFFM6NteW51kUYlqo0D7+QG3K4Lk+0a6R13p/RUn97Nhw==
X-Received: by 2002:ab0:1d88:: with SMTP id l8mr1196778uak.98.1567686026096;
 Thu, 05 Sep 2019 05:20:26 -0700 (PDT)
Date:   Thu,  5 Sep 2019 05:20:22 -0700
Message-Id: <20190905122022.106680-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH net] net: sched: fix reordering issues
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever MQ is not used on a multiqueue device, we experience
serious reordering problems. Bisection found the cited
commit.

The issue can be described this way :

- A single qdisc hierarchy is shared by all transmit queues.
  (eg : tc qdisc replace dev eth0 root fq_codel)

- When/if try_bulk_dequeue_skb_slow() dequeues a packet targetting
  a different transmit queue than the one used to build a packet train,
  we stop building the current list and save the 'bad' skb (P1) in a
  special queue. (bad_txq)

- When dequeue_skb() calls qdisc_dequeue_skb_bad_txq() and finds this
  skb (P1), it checks if the associated transmit queues is still in frozen
  state. If the queue is still blocked (by BQL or NIC tx ring full),
  we leave the skb in bad_txq and return NULL.

- dequeue_skb() calls q->dequeue() to get another packet (P2)

  The other packet can target the problematic queue (that we found
  in frozen state for the bad_txq packet), but another cpu just ran
  TX completion and made room in the txq that is now ready to accept
  new packets.

- Packet P2 is sent while P1 is still held in bad_txq, P1 might be sent
  at next round. In practice P2 is the lead of a big packet train
  (P2,P3,P4 ...) filling the BQL budget and delaying P1 by many packets :/

To solve this problem, we have to block the dequeue process as long
as the first packet in bad_txq can not be sent. Reordering issues
disappear and no side effects have been seen.

Fixes: a53851e2c321 ("net: sched: explicit locking in gso_cpu fallback")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
---
 net/sched/sch_generic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 137db1cbde8538e124133c6e148acc3e92e56a74..ac28f6a5d70e0b38ae8ce7858f08e9d15778c22f 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -46,6 +46,8 @@ EXPORT_SYMBOL(default_qdisc_ops);
  * - updates to tree and tree walking are only done under the rtnl mutex.
  */
 
+#define SKB_XOFF_MAGIC ((struct sk_buff *)1UL)
+
 static inline struct sk_buff *__skb_dequeue_bad_txq(struct Qdisc *q)
 {
 	const struct netdev_queue *txq = q->dev_queue;
@@ -71,7 +73,7 @@ static inline struct sk_buff *__skb_dequeue_bad_txq(struct Qdisc *q)
 				q->q.qlen--;
 			}
 		} else {
-			skb = NULL;
+			skb = SKB_XOFF_MAGIC;
 		}
 	}
 
@@ -253,8 +255,11 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 		return skb;
 
 	skb = qdisc_dequeue_skb_bad_txq(q);
-	if (unlikely(skb))
+	if (unlikely(skb)) {
+		if (skb == SKB_XOFF_MAGIC)
+			return NULL;
 		goto bulk;
+	}
 	skb = q->dequeue(q);
 	if (skb) {
 bulk:
-- 
2.23.0.187.g17f5b7556c-goog

