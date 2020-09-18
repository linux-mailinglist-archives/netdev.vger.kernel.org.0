Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A249D26F891
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 10:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgIRInD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 04:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgIRInD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 04:43:03 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BFEC06174A;
        Fri, 18 Sep 2020 01:43:02 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d6so2997056pfn.9;
        Fri, 18 Sep 2020 01:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g6pzFcHPyt2+FBImW9eU7Kyr9g3ZVo/F2gsCXOH7DSA=;
        b=jaR+9KeVlw5GeQ7AUsnmUVXeJugnGR5gK02fYShgulfUJ/waNUASklbXkZuVMmLKtV
         Vh+IStUGrQ+kg4dpNLtcpBXAI9z7w9ZF3NQ9wDcJB5cC9mxpFXy26VyfDnHBiGhM7Cuo
         hiiVQZE89/Lvba86Osb5KCA+ChYx+6A3NAuw9ylYrwqplm7rEX8J+iz43jXYOnxSJvcV
         vQtqtnh52Y8SEmZZ9uS+m6uRb8GuUfeTqEddrjO3CHExo2RYh6/J08l/+JNlVFcn4pfA
         B1sXnkrpeWCFt7l2jfmcAHF8h4OSYc9hrXROlESocJQGnUsjbPchqAvMbvT8xm7bvjAn
         cp3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g6pzFcHPyt2+FBImW9eU7Kyr9g3ZVo/F2gsCXOH7DSA=;
        b=s+SzBgY1hq3wLIbf3LW8LfXdfDIvEGRhy+Ccbdn6IVQ1Gg1Jc4+ozSQfyBHQM1nqab
         WjMgrirwtYO0aGOFi2uTTZtdfpP+WFkNGlqVX27tdYQI/AnkJDRUkjhe2axEgfmRvLwB
         fGaLvjjk4BNMLFqAL0dfYZwI0s57Rd/zAt3o7z5Znk7Wf/7PdBB0ZDkfa2kU9TsVco92
         sk69pU9mjv9+6RX88Eva6H65gnZqj2+LIUJbqBrvKka59WhcTenaFChifgv2rx8EV8C6
         5ec/Y0RlRfwPuo+wUnar36UUwFWs6dZzolwRj111/lFN0FRBogYvvtioYpucM6Gene4E
         FX3Q==
X-Gm-Message-State: AOAM533RLGQM0TV+gkEavlFaNlINofHhAG7FngoS0z4N8S4K1VT9abS/
        M+BKQ1zRwzG8EYMwDEdOGYc=
X-Google-Smtp-Source: ABdhPJzTrkkBeGOQ28cIK6heY1IbrBwQRRdSWhiJaLv5MV/8enLDtWoQijWI6JckWvCEBGCz91neqQ==
X-Received: by 2002:a63:5548:: with SMTP id f8mr25495722pgm.336.1600418582447;
        Fri, 18 Sep 2020 01:43:02 -0700 (PDT)
Received: from localhost.localdomain ([115.192.213.183])
        by smtp.gmail.com with ESMTPSA id r2sm2184487pga.94.2020.09.18.01.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 01:43:01 -0700 (PDT)
From:   Xiaoyong Yan <yanxiaoyong5@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyong Yan <yanxiaoyong5@gmail.com>
Subject: [PATCH] net/sched: cbs: fix calculation error of idleslope credits
Date:   Fri, 18 Sep 2020 01:42:52 -0700
Message-Id: <20200918084252.4200-1-yanxiaoyong5@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in the function cbs_dequeue_soft, when q->credits< 0, (now- q->last)
should be accounted for sendslope, not idleslope.

so the solution is as follows: when q->credits is less than 0, directly
calculate delay time, activate hrtimer and when hrtimer fires, calculate
idleslope credits and update it to q->credits.

Signed-off-by: Xiaoyong Yan <yanxiaoyong5@gmail.com>
---
 net/sched/sch_cbs.c | 71 ++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 23 deletions(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 2eaac2ff380f..b870576839d1 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -76,7 +76,9 @@ struct cbs_sched_data {
 	s32 hicredit; /* in bytes */
 	s64 sendslope; /* in bytes/s */
 	s64 idleslope; /* in bytes/s */
-	struct qdisc_watchdog watchdog;
+	struct hrtimer timer;
+	struct Qdisc *sch;
+	u64 last_expires;
 	int (*enqueue)(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free);
 	struct sk_buff *(*dequeue)(struct Qdisc *sch);
@@ -84,6 +86,41 @@ struct cbs_sched_data {
 	struct list_head cbs_list;
 };
 
+/* timediff is in ns, slope is in bytes/s */
+static s64 timediff_to_credits(s64 timediff, s64 slope)
+{
+	return div64_s64(timediff * slope, NSEC_PER_SEC);
+}
+
+static void cbs_timer_schedule(struct cbs_sched_data *q, u64 expires)
+{
+	if (test_bit(__QDISC_STATE_DEACTIVATED,
+				&qdisc_root_sleeping(q->sch)->state))
+		return;
+	if (q->last_expires == expires)
+		return;
+	q->last_expires = expires;
+	hrtimer_start(&q->timer,
+			ns_to_ktime(expires),
+			HRTIMER_MODE_ABS_PINNED);
+
+}
+static enum hrtimer_restart cbs_timer(struct hrtimer *timer)
+{
+	struct cbs_sched_data *q = container_of(timer, struct cbs_sched_data, timer);
+	s64 now = ktime_get_ns();
+	s64 credits;
+
+	credits = timediff_to_credits(now- q->last, q->idleslope);
+	credits = q->credits+ credits;
+	q->credits = clamp_t(s64, credits, q->locredit, q->hicredit);
+	q->last = now;
+	rcu_read_lock();
+	__netif_schedule(qdisc_root(q->sch));
+	rcu_read_unlock();
+
+	return HRTIMER_NORESTART;
+}
 static int cbs_child_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			     struct Qdisc *child,
 			     struct sk_buff **to_free)
@@ -135,12 +172,6 @@ static int cbs_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return q->enqueue(skb, sch, to_free);
 }
 
-/* timediff is in ns, slope is in bytes/s */
-static s64 timediff_to_credits(s64 timediff, s64 slope)
-{
-	return div64_s64(timediff * slope, NSEC_PER_SEC);
-}
-
 static s64 delay_from_credits(s64 credits, s64 slope)
 {
 	if (unlikely(slope == 0))
@@ -183,25 +214,17 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 
 	/* The previous packet is still being sent */
 	if (now < q->last) {
-		qdisc_watchdog_schedule_ns(&q->watchdog, q->last);
+		cbs_timer_schedule(q, q->last);
 		return NULL;
 	}
 	if (q->credits < 0) {
-		credits = timediff_to_credits(now - q->last, q->idleslope);
-
-		credits = q->credits + credits;
-		q->credits = min_t(s64, credits, q->hicredit);
-
-		if (q->credits < 0) {
-			s64 delay;
-
-			delay = delay_from_credits(q->credits, q->idleslope);
-			qdisc_watchdog_schedule_ns(&q->watchdog, now + delay);
+		s64 delay;
 
-			q->last = now;
+		delay = delay_from_credits(q->credits, q->idleslope);
+	    cbs_timer_schedule(q, now+ delay);
+		q->last = now;
 
-			return NULL;
-		}
+		return NULL;
 	}
 	skb = cbs_child_dequeue(sch, qdisc);
 	if (!skb)
@@ -424,7 +447,9 @@ static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
 	q->enqueue = cbs_enqueue_soft;
 	q->dequeue = cbs_dequeue_soft;
 
-	qdisc_watchdog_init(&q->watchdog, sch);
+	hrtimer_init(&q->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
+	q->timer.function = cbs_timer;
+	q->sch = sch;
 
 	return cbs_change(sch, opt, extack);
 }
@@ -438,7 +463,7 @@ static void cbs_destroy(struct Qdisc *sch)
 	if (!q->qdisc)
 		return;
 
-	qdisc_watchdog_cancel(&q->watchdog);
+	hrtimer_cancel(&q->timer);
 	cbs_disable_offload(dev, q);
 
 	spin_lock(&cbs_list_lock);
-- 
2.25.1

