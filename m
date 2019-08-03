Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA6B8089C
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 01:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfHCXhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 19:37:34 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42641 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbfHCXhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 19:37:34 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so37836037pgb.9
        for <netdev@vger.kernel.org>; Sat, 03 Aug 2019 16:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EctiR7lEKo/nn9xQDfsz0ktTW/AfHWrsgkAcoWtiUfE=;
        b=C5b1wQaV+0GOXEV6gLlwBqgWI6cpw+HJIcSO68wxbS6sXrOajfXLjVL4tjq8q1xk5e
         UWUnMpjzP3qViRvewVt1xT5j7F1FrpnsAceMpeyMh556n/pVB8zjblf6xyG2LX7ZdBCW
         lVB+nWbHJXvVTylCq50HUdTavSweyOfojo0Sc+02QqOokdedDzU87s47LpljKoiYpPyF
         WFyHiwXM1JY2DI9vcRDQvFKPtaPGKa1m0VvLhAvQS+zxCWxcD8pHWpkn5mFSAyfiC1PX
         BVOCMv1JTit2ZUfhOyCL3iaY3sY936IR/oFp2ttq+R13TR9/Ub8T8tYpL/OdOiWsw3v8
         543Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EctiR7lEKo/nn9xQDfsz0ktTW/AfHWrsgkAcoWtiUfE=;
        b=Y4RC1IuPGc8zbbOaPJgW8ZIf5s4neGhF/xrb8sVN//R4OohSw+E32GkuemzCaBawlA
         k+LMTbxtrjYNLL0eor422geij/2iMqIO/2pIjSBrjxgTDfmb3d8Ld1p0ATfe/qflJ8/d
         e0plqb73tCUKVPlCZo0/ZdeuQUAPtoNh1UJvowCx49YE3yro++8uqraZiZmUn5g85Plh
         XXE5ezFviC7YPcjUsnJpLWMuk5+0o37b04WzD6DV8hm3yAYwGjp5RFq+6AKQ8dFHbzBl
         8QxQZpTBQmrR/X+NCtEY/MFOJUnvwtZACl0aLJQMSYuUZIPfVeJ8+EaZaxTjjCtDqLIO
         fHog==
X-Gm-Message-State: APjAAAVF/dzdrBymECvd6AVpwtglfkF9JfZwmHa06jqT0e8Sbl2e59kU
        zLi0VG1jeFKwfi3H34q1v5THZ0gC84c=
X-Google-Smtp-Source: APXvYqzC4NEJTFZlSRHx5fdtcshUYtJajLsnVOhrJEpPCQdEbeDWsd9MOtTtuWak6ky6+S4wjWnPiw==
X-Received: by 2002:a17:90a:360c:: with SMTP id s12mr11435009pjb.30.1564875453209;
        Sat, 03 Aug 2019 16:37:33 -0700 (PDT)
Received: from dancer.lab.teklibre.com ([2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        by smtp.gmail.com with ESMTPSA id x24sm76076336pgl.84.2019.08.03.16.37.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 03 Aug 2019 16:37:32 -0700 (PDT)
From:   Dave Taht <dave.taht@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>
Subject: [PATCH net-next 2/2] fq_codel: Kill useless per-flow dropped statistic
Date:   Sat,  3 Aug 2019 16:37:29 -0700
Message-Id: <1564875449-12122-3-git-send-email-dave.taht@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564875449-12122-1-git-send-email-dave.taht@gmail.com>
References: <1564875449-12122-1-git-send-email-dave.taht@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is almost impossible to get anything other than a 0 out of
flow->dropped statistic with a tc class dump, as it resets to 0
on every round.

It also conflates ecn marks with drops.

It would have been useful had it kept a cumulative drop count, but
it doesn't. This patch doesn't change the API, it just stops
tracking a stat and state that is impossible to measure and nobody
uses.

Signed-off-by: Dave Taht <dave.taht@gmail.com>

---
 net/sched/sch_fq_codel.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index d67b2c40e6e6..9edd0f495001 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -45,7 +45,6 @@ struct fq_codel_flow {
 	struct sk_buff	  *tail;
 	struct list_head  flowchain;
 	int		  deficit;
-	u32		  dropped; /* number of drops (or ECN marks) on this flow */
 	struct codel_vars cvars;
 }; /* please try to keep this structure <= 64 bytes */
 
@@ -175,7 +174,6 @@ static unsigned int fq_codel_drop(struct Qdisc *sch, unsigned int max_packets,
 
 	/* Tell codel to increase its signal strength also */
 	flow->cvars.count += i;
-	flow->dropped += i;
 	q->backlogs[idx] -= len;
 	q->memory_usage -= mem;
 	sch->qstats.drops += i;
@@ -213,7 +211,6 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		list_add_tail(&flow->flowchain, &q->new_flows);
 		q->new_flow_count++;
 		flow->deficit = q->quantum;
-		flow->dropped = 0;
 	}
 	get_codel_cb(skb)->mem_usage = skb->truesize;
 	q->memory_usage += get_codel_cb(skb)->mem_usage;
@@ -312,9 +309,6 @@ static struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
 			    &flow->cvars, &q->cstats, qdisc_pkt_len,
 			    codel_get_enqueue_time, drop_func, dequeue_func);
 
-	flow->dropped += q->cstats.drop_count - prev_drop_count;
-	flow->dropped += q->cstats.ecn_mark - prev_ecn_mark;
-
 	if (!skb) {
 		/* force a pass through old_flows to prevent starvation */
 		if ((head == &q->new_flows) && !list_empty(&q->old_flows))
@@ -660,7 +654,7 @@ static int fq_codel_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 			sch_tree_unlock(sch);
 		}
 		qs.backlog = q->backlogs[idx];
-		qs.drops = flow->dropped;
+		qs.drops = 0;
 	}
 	if (gnet_stats_copy_queue(d, NULL, &qs, qs.qlen) < 0)
 		return -1;
-- 
2.17.1

