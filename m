Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30861BABFE
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgD0SFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726560AbgD0SFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:05:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1407C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:05:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s8so21470070ybj.9
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4GUbghb2GyxnSQ8cGN3x0+FHk6GAzGRMG5qAj3e9H1M=;
        b=HSBPP8nKGzdfIjIUfGPD8Jgsdb/F9xGCV+ct4XGZz5ptPmBXrjp4hlVHfnCOn0o7Bp
         lkd2UESug4yiuP9DEGUZIT7YPAJf+B1Xxd2S5pkhuxqaEOpfH1upUbvYIVA3GSkKYN7M
         JrP/EcUU9mfKiq/mNAEdUPyqHFb15Gv2TsC37y5sJovCXqfFlFDV+PaUwR7To6FP7cgF
         gufmDui2jmLmnANGW5EZkQDKU30cAzXEJXj98CoDnkZ9nc5kX3IE0djH5qx6Fg6hlJPV
         tY/HNhOPwzMODx1ZGRT9yBzjFKG+pqftq//IrfiIgmQjYPbn0DebayYIPmJxFtbkmLPA
         Jxjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4GUbghb2GyxnSQ8cGN3x0+FHk6GAzGRMG5qAj3e9H1M=;
        b=gxcMsdLIxC3XIZEQ/M3PD8LHK2fvpYrnYx/HlvMuov1sx2lXVjQ5Ab8michFbLqtYi
         gD//7bp65HYtSnp48hoJmsR7J1LeuKXAZ9c0oEKANTySmG0TibVz4FhPjcy4QPkPZde3
         gEWCZcca9JIJSuo0m05OdyBhddsoWmMMaBo/uMkpQODa7sRNlxC22BfDScp94/8zmYca
         GbmBKM21qtwiYQAgmkrLBZz79QyDeU4vpSFPPb55VEN+CTmIophuzJT/1dbjeC2iVWI2
         MrmOsevPeoFKt4Od8Jmp57a2ZJbHSagmhDoOMdqkUOHBxorUHL1JsIYf32KM3sjIYR2u
         0k9A==
X-Gm-Message-State: AGi0PuZm+KOgnJQG3aK04Jltrp5Ln1O7wJS+3nGxNlTnLiw1wzdtPyGa
        tgEZ0/gdb3bz9lmAO5DqCOK2FQnQkmdptA==
X-Google-Smtp-Source: APiQypIy6RMbCrrLpzDMwSk1M9IXnay7LD7BN46LBaCQQxit8P1tRl5CCTPIYsjD/PxYyhUqCJSsS+CL90mb0A==
X-Received: by 2002:a25:be08:: with SMTP id h8mr36110778ybk.136.1588010746090;
 Mon, 27 Apr 2020 11:05:46 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:05:43 -0700
Message-Id: <20200427180543.230025-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH iproute2] tc: fq: add timer_slack parameter
From:   Eric Dumazet <edumazet@google.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 583396f4ca4d ("net_sched: sch_fq: enable use of hrtimer slack")
added TCA_FQ_TIMER_SLACK parameter, with a default value of 10 usec.

Add the corresponding tc support to get/set this tunable.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 tc/q_fq.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tc/q_fq.c b/tc/q_fq.c
index 44d8a7e03b9986a86d91bdba4310156269601a60..ffae0523b1abe6a9328c6542160ff938ad666532 100644
--- a/tc/q_fq.c
+++ b/tc/q_fq.c
@@ -57,6 +57,7 @@ static void explain(void)
 		"		[ [no]pacing ] [ refill_delay TIME ]\n"
 		"		[ low_rate_threshold RATE ]\n"
 		"		[ orphan_mask MASK]\n"
+		"		[ timer_slack TIME]\n"
 		"		[ ce_threshold TIME ]\n");
 }
 
@@ -86,6 +87,7 @@ static int fq_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	unsigned int refill_delay;
 	unsigned int orphan_mask;
 	unsigned int ce_threshold;
+	unsigned int timer_slack;
 	bool set_plimit = false;
 	bool set_flow_plimit = false;
 	bool set_quantum = false;
@@ -96,6 +98,7 @@ static int fq_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	bool set_orphan_mask = false;
 	bool set_low_rate_threshold = false;
 	bool set_ce_threshold = false;
+	bool set_timer_slack = false;
 	int pacing = -1;
 	struct rtattr *tail;
 
@@ -146,6 +149,20 @@ static int fq_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 				return -1;
 			}
 			set_ce_threshold = true;
+		} else if (strcmp(*argv, "timer_slack") == 0) {
+			__s64 t64;
+
+			NEXT_ARG();
+			if (get_time64(&t64, *argv)) {
+				fprintf(stderr, "Illegal \"timer_slack\"\n");
+				return -1;
+			}
+			timer_slack = t64;
+			if (timer_slack != t64) {
+				fprintf(stderr, "Illegal (out of range) \"timer_slack\"\n");
+				return -1;
+			}
+			set_timer_slack = true;
 		} else if (strcmp(*argv, "defrate") == 0) {
 			NEXT_ARG();
 			if (strchr(*argv, '%')) {
@@ -240,6 +257,9 @@ static int fq_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	if (set_ce_threshold)
 		addattr_l(n, 1024, TCA_FQ_CE_THRESHOLD,
 			  &ce_threshold, sizeof(ce_threshold));
+    if (set_timer_slack)
+		addattr_l(n, 1024, TCA_FQ_TIMER_SLACK,
+			  &timer_slack, sizeof(timer_slack));
 	addattr_nest_end(n, tail);
 	return 0;
 }
@@ -254,6 +274,7 @@ static int fq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	unsigned int refill_delay;
 	unsigned int orphan_mask;
 	unsigned int ce_threshold;
+	unsigned int timer_slack;
 
 	SPRINT_BUF(b1);
 
@@ -355,6 +376,12 @@ static int fq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		}
 	}
 
+	if (tb[TCA_FQ_TIMER_SLACK] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_TIMER_SLACK]) >= sizeof(__u32)) {
+		timer_slack = rta_getattr_u32(tb[TCA_FQ_TIMER_SLACK]);
+		fprintf(f, "timer_slack %s ", sprint_time64(timer_slack, b1));
+	}
+
 	return 0;
 }
 
-- 
2.26.2.303.gf8c07b1a785-goog

