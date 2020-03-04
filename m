Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE8A179874
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388280AbgCDS4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:56:21 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34223 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388226AbgCDS4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 13:56:21 -0500
Received: by mail-pl1-f194.google.com with SMTP id j7so1430727plt.1
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 10:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y8wxH2nA14A7hv8o/g+zRpjVLB3YpsPt7xyiLMGkmyo=;
        b=lkF0Vj4Ng0+R+w93S40KtnHzuC13VZFXVHt3Hb3BcEo7dLXr6Z1eJBIKwZvC3scq8R
         pRqJ7YN7C/AbAhSYnL0/omOL8PrVbrqOZH6N+Wa/U+FfoEUTi59UOFmDPaUdLhBodf25
         PWGDeBfczRU3+FCp9y3tv/HwjLFdk1hWsAbn/hoaqS/mu/9BlIYxuoSRg6UN4diDMRW7
         ZDalfo3XOoBoJRjWXxmKWsCmb5GJ7Hj9CDsErMt8ZaTan/dC0VWo5XwfaVgcJQctKb3q
         ZvIrHX63XPi4WO2lsqFzMKIMzvm/hmB1Wri5Gk1lbP5OUK9cBn3YAFB2Uw/hiR2jPlv8
         JARA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y8wxH2nA14A7hv8o/g+zRpjVLB3YpsPt7xyiLMGkmyo=;
        b=fQrvbR0r5nbSOYWlb3jiTpsNneaVvrbA3hE7TW/EJ2L6+kKIJTzTVB9c8Nia1ylsxC
         DsZ9w5Dq8B4Yz4e6ONVK7AfSLnbgcmeVwpt9vBhNOHQ+A0rTBZddIpSL657HuiLbSm7c
         PSb5a2TR4rnBMyi6KdTkGBxJsHzxWUJEDHsZr+SSRT9HJstpZvbdUjpgSB3LL7rK3Fq3
         FIijQZvEBIg1ZTBgwTeDQJfDnsccOSvna7ZGTLZeenVc7uuxNFs7z8lx1WIta2T6hsX+
         Kbzbe0vB7SsLzCFxXefoxuAPbg3Czlyp/fUw6M3o3toQcgI5KDjqjxGG6NaivCXfFgmk
         slNA==
X-Gm-Message-State: ANhLgQ1l6ub5122gU+t+d5PG9d3nPBUXoJmcfSr4W+yRCQlgTipXJwwZ
        epb4g7AadteT2qrQSA1vRARy7nVz
X-Google-Smtp-Source: ADFU+vsALTAOTQ6Y2nWin+WMu9bpgI1uyVLTynDV3Nl4tfS0LW+a8JOK4CoYYui/msFKnnwwaiwtgw==
X-Received: by 2002:a17:90a:ae0a:: with SMTP id t10mr4504093pjq.2.1583348179844;
        Wed, 04 Mar 2020 10:56:19 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id h12sm12720021pfk.124.2020.03.04.10.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:56:19 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tahiliani@nitk.edu.in, gautamramk@gmail.com
Subject: [PATCH net-next v2 3/4] pie: remove pie_vars->accu_prob_overflows
Date:   Thu,  5 Mar 2020 00:26:01 +0530
Message-Id: <20200304185602.2540-4-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304185602.2540-1-lesliemonis@gmail.com>
References: <20200304185602.2540-1-lesliemonis@gmail.com>
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
index 198cfa34a00a..f52442d39bf5 100644
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
 
 	prandom_bytes(&rnd, 8);
-	if (rnd < local_prob) {
+	if ((rnd >> BITS_PER_BYTE) < local_prob) {
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

