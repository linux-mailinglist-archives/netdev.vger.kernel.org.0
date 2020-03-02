Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F01175E07
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 16:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgCBPSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 10:18:51 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53676 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgCBPSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 10:18:51 -0500
Received: by mail-pj1-f65.google.com with SMTP id cx7so1391930pjb.3
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 07:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hEQxyDr/z3Ege8bJmFhXxokmZ7WijYnR55gJgVyhrM8=;
        b=Ini05Wx/yhCx6qpO19bjY6UHTx8DiOJ76pDKyBlHmjiUV7j2Xn5D65Tw/iPnAlWwC9
         0gMdnWa75QxOtiup8NJ1yozuBdBTmz8bVnnMx5/NyIYGcUwHWU+QarQjj4gUQUw4DJkF
         SHxe+U7nKT34XZhlVU/89CcEWuq11Vz+Tdi5l1nHL58omBu5LHieaWEbaX13F50Tw+Zc
         0LJwg1y+meKa88o11mM8RVtImC4jwIqmzLckopwU+hmpMlmOlJKcyOX0T3dT1wR+OpYA
         wNZx06asIMWX9G0ueqMH+3//GDLlUOltBi6NKL51jnY4sRx4vO4d/nuWlMQHeitzx5mg
         vb4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hEQxyDr/z3Ege8bJmFhXxokmZ7WijYnR55gJgVyhrM8=;
        b=RMIl3r0wO93OeZcI7oFDQowxJvH32HBUD95fdNcEtL2YmOXEZGyfbHUof/QK8DfOnr
         lqyLVshd8RcghviW5KR+KWE74EqoXOEFWt6YsQ996BCN7CDHQ4TRScYXoHCq3rUqQKhy
         a2cdV9sihItNZRlgj9f7pLTANTqJIezsMPAt5oU22gF6RVdtMO6z5Fb9981SxNbj3G6/
         KCMTUuT6wHGeL1Jz13rGMzNwr/AZKOATYrBGA8WjpjLh8OwlzEuoYl7sByfluvt8US7D
         cypwHhdJC82YTYB005k5EY0HRA+NBZzVdfYU9tx1ffTFhD9X/Fzh/zH8AECy116vZG2R
         Ctxg==
X-Gm-Message-State: ANhLgQ0QstcMAS3gWneaL9E3l+ay4I1iaw0L//dV7HP6PTJ2lEHKiZZ+
        aMeQA6k+lJT4pM/L8084uuwTuW63
X-Google-Smtp-Source: ADFU+vt+irRUSBKmrX4fu32M1/KTFVUdlHWOxqy82dOaDeddAC5qpnhCQ13PQ9+kGdo7U7oGzDFCuQ==
X-Received: by 2002:a17:90a:9dc3:: with SMTP id x3mr77238pjv.45.1583162328542;
        Mon, 02 Mar 2020 07:18:48 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id s206sm21908529pfs.100.2020.03.02.07.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 07:18:47 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tahiliani@nitk.edu.in, gautamramk@gmail.com
Subject: [PATCH net-next 3/4] pie: remove pie_vars->accu_prob_overflows
Date:   Mon,  2 Mar 2020 20:48:30 +0530
Message-Id: <20200302151831.2811-4-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200302151831.2811-1-lesliemonis@gmail.com>
References: <20200302151831.2811-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable pie_vars->accu_prob is used as an accumulator for
probability values. Since probabilty values are scaled using the
MAX_PROB macro denoting (2^64 - 1), pie_vars->accu_prob is
likely to overflow as it is of type u64.

The variable pie_vars->accu_prob_overflows counts the number of
times the variable pie_vars->accu_prob overflows.

The MAX_PROB macro needs to be equal to at least (2^39 - 1) in
order to do precise calculations without any underflow. Thus
MAX_PROB can be reduced to (2^56 - 1) without affecting the
precision in calculations drastically. Doing so will eliminate
the need for the variable pie_vars->accu_prob_overflows as the
variable pie_vars->accu_prob will never overflow.

Removing the variable pie_vars->accu_prob_overflows also reduces
the size of the structure pie_vars to exactly 64 bytes.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 include/net/pie.h      |  5 +----
 net/sched/sch_fq_pie.c |  1 -
 net/sched/sch_pie.c    | 21 ++++++---------------
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 24f68c1e9919..1c645b76a2ed 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -8,7 +8,7 @@
 #include <net/inet_ecn.h>
 #include <net/pkt_sched.h>
 
-#define MAX_PROB	U64_MAX
+#define MAX_PROB	(U64_MAX >> BITS_PER_BYTE)
 #define DTIME_INVALID	U64_MAX
 #define QUEUE_THRESHOLD	16384
 #define DQCOUNT_INVALID	-1
@@ -47,7 +47,6 @@ struct pie_params {
  * @dq_count:			number of bytes dequeued in a measurement cycle
  * @avg_dq_rate:		calculated average dq rate
  * @backlog_old:		queue backlog during previous qdelay calculation
- * @accu_prob_overflows:	number of times accu_prob overflows
  */
 struct pie_vars {
 	psched_time_t qdelay;
@@ -59,7 +58,6 @@ struct pie_vars {
 	u64 dq_count;
 	u32 avg_dq_rate;
 	u32 backlog_old;
-	u8 accu_prob_overflows;
 };
 
 /**
@@ -107,7 +105,6 @@ static inline void pie_vars_init(struct pie_vars *vars)
 	vars->accu_prob = 0;
 	vars->dq_count = DQCOUNT_INVALID;
 	vars->avg_dq_rate = 0;
-	vars->accu_prob_overflows = 0;
 }
 
 static inline struct pie_skb_cb *get_pie_cb(const struct sk_buff *skb)
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index 214657eb3dfd..a9da8776bf5b 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -189,7 +189,6 @@ static int fq_pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 out:
 	q->stats.dropped++;
 	sel_flow->vars.accu_prob = 0;
-	sel_flow->vars.accu_prob_overflows = 0;
 	__qdisc_drop(skb, to_free);
 	qdisc_qstats_drop(sch);
 	return NET_XMIT_CN;
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 198cfa34a00a..718ac61f4d47 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -62,27 +62,19 @@ bool pie_drop_early(struct Qdisc *sch, struct pie_params *params,
 	else
 		local_prob = vars->prob;
 
-	if (local_prob == 0) {
+	if (local_prob == 0)
 		vars->accu_prob = 0;
-		vars->accu_prob_overflows = 0;
-	}
-
-	if (local_prob > MAX_PROB - vars->accu_prob)
-		vars->accu_prob_overflows++;
-
-	vars->accu_prob += local_prob;
+	else
+		vars->accu_prob += local_prob;
 
-	if (vars->accu_prob_overflows == 0 &&
-	    vars->accu_prob < (MAX_PROB / 100) * 85)
+	if (vars->accu_prob < (MAX_PROB / 100) * 85)
 		return false;
-	if (vars->accu_prob_overflows == 8 &&
-	    vars->accu_prob >= MAX_PROB / 2)
+	if (vars->accu_prob >= (MAX_PROB / 2) * 17)
 		return true;
 
-	prandom_bytes(&rnd, 8);
+	prandom_bytes(&rnd, 7);
 	if (rnd < local_prob) {
 		vars->accu_prob = 0;
-		vars->accu_prob_overflows = 0;
 		return true;
 	}
 
@@ -129,7 +121,6 @@ static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 out:
 	q->stats.dropped++;
 	q->vars.accu_prob = 0;
-	q->vars.accu_prob_overflows = 0;
 	return qdisc_drop(skb, sch, to_free);
 }
 
-- 
2.17.1

