Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A7E9EAC2
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 16:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfH0OUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 10:20:21 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:34529 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfH0OUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 10:20:21 -0400
Received: by mail-pl1-f175.google.com with SMTP id d3so11893724plr.1
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 07:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9e1JOz5JdmehXFXDRepHtpPrIAM7Gf6RleGqcbEPsmM=;
        b=cRSxaLcNFlauFBJxGMI7Igebl+s8IHGUnUBD/7EPfAJEIctX6Cepbpvqmk23urSzq4
         BbJb+3Wcpc6v3fT4EnESjO0FXfZtAfsVmBnB0V5qCGYVyFfBDiGkDTE5K+HcnUUSlV3t
         6XZ8y0sQwnQyUY349m+2BBX3GazeaOZj9DCUEdqBntplYogMZ+nMPLHB34dZihIPnTbG
         j+gUuV43XxMofF9Y3sGfY56AOC9pqHJu+JIYeEnXDRpCoYq9ZVcQZTg+lRo6rk4w9deM
         1Z1tp27VJxEk2aIVLCvcqnZgFflwMteyAh2XjT5iryudcpYYHwFpKJbHJ+rM8MbQN3RP
         PUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9e1JOz5JdmehXFXDRepHtpPrIAM7Gf6RleGqcbEPsmM=;
        b=lECewI+fxamnSK6pwDLKEg4fiuupmf8aDlbjh8A2hjihuDaNovlFI/R69tWu/rXfjf
         yF1xsz8WxW35dLEAuHRmu3GHTqHT7d+z88pmxbVrSIjibfj7FuMASUYxs1Xu5FqNADwv
         gavBpaw4K32daODeXehj0EQ4Bh1Y6NLwNVXOohu7meVJ/3/mDGXr8JFhrUOWGq8NYhwS
         n6Xqndf53GMORpPQQNHg3qMeQAYnVRUtRXhW1kSnYeOlXKOKrSGeYrdvEiiApsVEBQLz
         C7z91qRp9z5zZF2ncwV3kgWXtH97fhpmBJro91k5DvzdzewGm6rHiBtMF+uLcgXZWPRU
         VJrg==
X-Gm-Message-State: APjAAAWVYlO1kDqnxVNLhINOvolWaqURNdDDiUcbQAa3JB96637H5M7g
        GCf76Mh6RYYAZSs9D9yrykLitN3ysAX6Qw==
X-Google-Smtp-Source: APXvYqzadaAro/bnDXwSV6D+af5vcVHZuMhrUcusK85dPYflO+3nwJBsfN/zmWSIZIO9Se7WUXpH4A==
X-Received: by 2002:a17:902:a706:: with SMTP id w6mr9503882plq.166.1566915615232;
        Tue, 27 Aug 2019 07:20:15 -0700 (PDT)
Received: from localhost.localdomain ([223.186.224.107])
        by smtp.gmail.com with ESMTPSA id d11sm18015325pfh.59.2019.08.27.07.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 07:20:09 -0700 (PDT)
From:   Gautam Ramakrishnan <gautamramk@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, davem@davemloft.net, xiyou.wangcong@gmail.com,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Dave Taht <dave.taht@gmail.com>
Subject: [net-next] net: sched: pie: enable timestamp based delay calculation
Date:   Tue, 27 Aug 2019 19:49:38 +0530
Message-Id: <20190827141938.23483-1-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 8033 suggests an alternative approach to calculate the queue
delay in PIE by using per packet timestamps. This patch enables the
PIE implementation to do this.

The calculation of queue delay is as follows:
	qdelay = now - packet_enqueue_time

To enable the use of timestamps:
	modprobe sch_pie use_timestamps=1

Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Cc: Dave Taht <dave.taht@gmail.com>
---
 net/sched/sch_pie.c | 55 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index df98a887eb89..1a19c77e6e42 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -19,12 +19,18 @@
 #include <linux/skbuff.h>
 #include <net/pkt_sched.h>
 #include <net/inet_ecn.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
 
 #define QUEUE_THRESHOLD 16384
 #define DQCOUNT_INVALID -1
 #define MAX_PROB 0xffffffffffffffff
 #define PIE_SCALE 8
 
+static unsigned int use_timestamps; /* to calculate delay */
+module_param(use_timestamps, int, 0644);
+MODULE_PARM_DESC(use_timestamps, "enables timestamp based delay calculation.");
+
 /* parameters used */
 struct pie_params {
 	psched_time_t target;	/* user specified target delay in pschedtime */
@@ -79,6 +85,27 @@ static void pie_params_init(struct pie_params *params)
 	params->bytemode = false;
 }
 
+/* private skb vars */
+struct pie_skb_cb {
+	psched_time_t enqueue_time;
+};
+
+static struct pie_skb_cb *get_pie_cb(const struct sk_buff *skb)
+{
+	qdisc_cb_private_validate(skb, sizeof(struct pie_skb_cb));
+	return (struct pie_skb_cb *)qdisc_skb_cb(skb)->data;
+}
+
+static psched_time_t pie_get_enqueue_time(const struct sk_buff *skb)
+{
+	return get_pie_cb(skb)->enqueue_time;
+}
+
+static void pie_set_enqueue_time(struct sk_buff *skb)
+{
+	get_pie_cb(skb)->enqueue_time = psched_get_time();
+}
+
 static void pie_vars_init(struct pie_vars *vars)
 {
 	vars->dq_count = DQCOUNT_INVALID;
@@ -172,6 +199,9 @@ static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	/* we can enqueue the packet */
 	if (enqueue) {
+		if (use_timestamps)
+			pie_set_enqueue_time(skb);
+
 		q->stats.packets_in++;
 		if (qdisc_qlen(sch) > q->stats.maxq)
 			q->stats.maxq = qdisc_qlen(sch);
@@ -323,6 +353,10 @@ static void pie_process_dequeue(struct Qdisc *sch, struct sk_buff *skb)
 				else
 					q->vars.burst_time = 0;
 			}
+
+			if (use_timestamps)
+				q->vars.qdelay = now -
+						 pie_get_enqueue_time(skb);
 		}
 	}
 }
@@ -332,19 +366,25 @@ static void calculate_probability(struct Qdisc *sch)
 	struct pie_sched_data *q = qdisc_priv(sch);
 	u32 qlen = sch->qstats.backlog;	/* queue size in bytes */
 	psched_time_t qdelay = 0;	/* in pschedtime */
-	psched_time_t qdelay_old = q->vars.qdelay;	/* in pschedtime */
+	psched_time_t qdelay_old = 0;	/* in pschedtime */
 	s64 delta = 0;		/* determines the change in probability */
 	u64 oldprob;
 	u64 alpha, beta;
 	u32 power;
 	bool update_prob = true;
 
-	q->vars.qdelay_old = q->vars.qdelay;
+	if (use_timestamps) {
+		qdelay = q->vars.qdelay;
+		qdelay_old = q->vars.qdelay_old;
+	} else {
+		qdelay_old = q->vars.qdelay;
+		q->vars.qdelay_old = q->vars.qdelay;
 
-	if (q->vars.avg_dq_rate > 0)
-		qdelay = (qlen << PIE_SCALE) / q->vars.avg_dq_rate;
-	else
-		qdelay = 0;
+		if (q->vars.avg_dq_rate > 0)
+			qdelay = (qlen << PIE_SCALE) / q->vars.avg_dq_rate;
+		else
+			qdelay = 0;
+	}
 
 	/* If qdelay is zero and qlen is not, it means qlen is very small, less
 	 * than dequeue_rate, so we do not update probabilty in this round
@@ -438,6 +478,9 @@ static void calculate_probability(struct Qdisc *sch)
 	    q->vars.prob == 0 &&
 	    q->vars.avg_dq_rate > 0)
 		pie_vars_init(&q->vars);
+
+	if (use_timestamps)
+		q->vars.qdelay_old = qdelay;
 }
 
 static void pie_timer(struct timer_list *t)
-- 
2.17.1

