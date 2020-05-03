Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0382C1C296F
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 04:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgECCyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 22:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726737AbgECCyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 22:54:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC97BC061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 19:54:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s62so17982474ybs.0
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 19:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WAnULMs9+JtBKLPpt2fdT9wencbeP+ie0ya5DBJ0CpI=;
        b=ddYwECl+ocLWI2dHJHhl1igDzjYkPUAlbtyNhpPmEi0Dyf7OTKzPaidjPmbVKDp476
         1U0LuDiMqIVASZ5fWQR+HoR7+dkCl7/OmFpRr44R+6IcBJcbWoLSTEXahIOVHfP0k0c/
         XAvOExt+OlPu5ObEf4JnPszIx4b7Jy8KxJ+e28bAp7KdNITkslf2niefaz7Lwbb4vgwU
         bVFkJIl67qkXBH1/EeDRfeS+F5xsjNUwST3CjySCD+u3mMRHRrAWrOvlVuMWQjcHf21D
         NWyFvVgKQKJ0q1qKu9P6/TomXhfT3gHb0h1lDXbT2gJK0A+a8FwmVOBuwj+yDzqc9HZV
         4GLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WAnULMs9+JtBKLPpt2fdT9wencbeP+ie0ya5DBJ0CpI=;
        b=ueh3FcCpZWOpvE0CxvJPIH6GpjPIPR5pq0hppUQf9jDljfryd9DkUOUQaLZHk9iaD5
         cnoEjSXupWJ91ssGFa0lJ1rTpaXZfT4ey398vd/udYjdyHX4pAwgXs/l7M4ooh761G6I
         E00+3l0XeyAnbSmnChUq++P93JH1HdfrSXCvvNi3fklg3m0pc2sxFveyqFXSAGkfFYwf
         mDGP+bmZIWoO8a2YDE6WvfzjpxkYYBB/zjXdh41qY+G4h61DvhPRrGuNvYWls/2AI4ld
         95BWKgCjliwtwZ51dnMQcHiDiqso3djIiahcRKj/ythKFtL3M7fwajpDQQm9mFp6cN5y
         gWCQ==
X-Gm-Message-State: AGi0Pua1J3IrUhSv1441zZMBhO9KxnwHEIkG2IMuwnfOYGhvKv17cAiI
        XH9vkb1B2UCaQo+hXJXn8cuz9A7+JNI6kA==
X-Google-Smtp-Source: APiQypLyEvVUpz9VDAp7pk3DUCcUXTLAb6cgZ935swUm71LMQ+nfLeHtYyapqCglL2gOfBcyXbtb7iAvtED5Bw==
X-Received: by 2002:a25:5f4a:: with SMTP id h10mr17689800ybm.372.1588474475900;
 Sat, 02 May 2020 19:54:35 -0700 (PDT)
Date:   Sat,  2 May 2020 19:54:21 -0700
In-Reply-To: <20200503025422.219257-1-edumazet@google.com>
Message-Id: <20200503025422.219257-5-edumazet@google.com>
Mime-Version: 1.0
References: <20200503025422.219257-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 4/5] net_sched: sch_fq: do not call fq_peek() twice
 per packet
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

This refactors the code to not call fq_peek() from fq_dequeue_head()
since the caller can provide the skb.

Also rename fq_dequeue_head() to fq_dequeue_skb() because 'head' is
a bit vague, given the skb could come from t_root rb-tree.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 56e4f3c4380c517136b22862771f9899a7fd99f2..4a28f611edf0cd4ac7fb53fc1c2a4ba12060bf59 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -388,19 +388,17 @@ static void fq_erase_head(struct Qdisc *sch, struct fq_flow *flow,
 	}
 }
 
-/* remove one skb from head of flow queue */
-static struct sk_buff *fq_dequeue_head(struct Qdisc *sch, struct fq_flow *flow)
+/* Remove one skb from flow queue.
+ * This skb must be the return value of prior fq_peek().
+ */
+static void fq_dequeue_skb(struct Qdisc *sch, struct fq_flow *flow,
+			   struct sk_buff *skb)
 {
-	struct sk_buff *skb = fq_peek(flow);
-
-	if (skb) {
-		fq_erase_head(sch, flow, skb);
-		skb_mark_not_on_list(skb);
-		flow->qlen--;
-		qdisc_qstats_backlog_dec(sch, skb);
-		sch->q.qlen--;
-	}
-	return skb;
+	fq_erase_head(sch, flow, skb);
+	skb_mark_not_on_list(skb);
+	flow->qlen--;
+	qdisc_qstats_backlog_dec(sch, skb);
+	sch->q.qlen--;
 }
 
 static void flow_queue_add(struct fq_flow *flow, struct sk_buff *skb)
@@ -538,9 +536,11 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 	if (!sch->q.qlen)
 		return NULL;
 
-	skb = fq_dequeue_head(sch, &q->internal);
-	if (skb)
+	skb = fq_peek(&q->internal);
+	if (unlikely(skb)) {
+		fq_dequeue_skb(sch, &q->internal, skb);
 		goto out;
+	}
 
 	q->ktime_cache = now = ktime_get_ns();
 	fq_check_throttled(q, now);
@@ -580,10 +580,8 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 			INET_ECN_set_ce(skb);
 			q->stat_ce_mark++;
 		}
-	}
-
-	skb = fq_dequeue_head(sch, f);
-	if (!skb) {
+		fq_dequeue_skb(sch, f, skb);
+	} else {
 		head->first = f->next;
 		/* force a pass through old_flows to prevent starvation */
 		if ((head == &q->new_flows) && q->old_flows.first) {
-- 
2.26.2.526.g744177e7f7-goog

