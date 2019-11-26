Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED92A109D65
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 12:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfKZL7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 06:59:36 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:34142 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbfKZL7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 06:59:36 -0500
Received: by mail-pg1-f175.google.com with SMTP id z188so8892952pgb.1
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 03:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=09TH+4iIQsnNiQbMaBYxN+dXZ3Drgq1+CzhwbSDrT6E=;
        b=GZQP4JSlRLKXAEHv3X1mLktGjDyGy/IULT4l3HOgu6LWFcT3SPYaf93LsnrP4K5VmN
         AhRyug/s8oLmsYq8ue8NdKK0RviPCzyShl1HYjVocTEhvztS//R/AOYHyFBxQllzTm98
         Q3XQ4yLLMok40vfXXRCnmfVHcR9nKuBHFRFDhfZwQidoCWJxtlYhHFs905yeiSiJkzuf
         o847c7H0t1yMtOsQx9h9yd0CtrTMXkj4Br9uyGpIw1G+rNTexp85D+g+gr6ejydvvZsp
         Xrzup6PUZeiVKl14InDCuHSAHBJa14+uPc33SDCAxbyPzaSoTIFErcs/wsM0kKQVAmSu
         vKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=09TH+4iIQsnNiQbMaBYxN+dXZ3Drgq1+CzhwbSDrT6E=;
        b=ZINCObXyTTsx60CmvKNMN08ESmnK6A3m+6/s9X73Kmx0YCYwEiuVg9AxDqeEmTJd+T
         B3DouwjEH3CRhnx7xun7Tou6dFtEUF6iYT9er3U9gMlMnCWv1ICpP2QNMPn09MK636h4
         VYPCvZFlVYtAxu5jkF7Kibuu7Hx4gIdtH5ithz3QXsMykaCAgmmZ2mF8RHjIr1psro1P
         ScwPQv/1w2lXk57NBGlw1cfdcxmgQeL+ghPYnxKJ81lpHF2++6ABbKzGcjvLhA78fj4L
         yGqqZHqoN0nmFri15SkRq5anG1HQ5cdAvM01KdgFJpPFAbL8FOuhNyz8wZvDRhEXzQHb
         mufg==
X-Gm-Message-State: APjAAAVTJtDYh3Ghvad870iPAXmLQhmXiglYsYyMhPlwcnzIAq9ni1Gs
        uar07e23itxhSwSzuPCvhSs=
X-Google-Smtp-Source: APXvYqxI9KWk9wJJFtZ6IUXRwEtwslPK4Hzd5ABrIKJpws4y7zPOJWpV/0gWrBdlTjehLyUZls4qjg==
X-Received: by 2002:a62:8c:: with SMTP id 134mr41686149pfa.31.1574769574888;
        Tue, 26 Nov 2019 03:59:34 -0800 (PST)
Received: from localhost.localdomain ([223.186.201.1])
        by smtp.gmail.com with ESMTPSA id e8sm12455655pga.17.2019.11.26.03.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 03:59:33 -0800 (PST)
From:   Gautam Ramakrishnan <gautamramk@gmail.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, Gautam Ramakrishnan <gautamramk@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>
Subject: [PATCH iproute2] tc: pie: add dq_rate_estimator option
Date:   Tue, 26 Nov 2019 17:28:07 +0530
Message-Id: <20191126115807.27843-1-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PIE now uses per packet timestamps to calculate queuing
delay. The average dequeue rate based queue delay
calculation is now made optional. This patch adds the option
to enable or disable the use of Little's law to calculate
queuing delay.

Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
---
 bash-completion/tc |  1 +
 man/man8/tc-pie.8  | 31 ++++++++++++++++++++++++++-----
 tc/q_pie.c         | 35 +++++++++++++++++++++++++++++------
 3 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/bash-completion/tc b/bash-completion/tc
index 007e1c2e..fe0d51ec 100644
--- a/bash-completion/tc
+++ b/bash-completion/tc
@@ -323,6 +323,7 @@ _tc_qdisc_options()
             _tc_once_attr 'limit target tupdate alpha beta'
             _tc_one_of_list 'bytemode nobytemode'
             _tc_one_of_list 'ecn noecn'
+            _tc_one_of_list 'dq_rate_estimator no_dq_rate_estimator'
             return 0
             ;;
         red)
diff --git a/man/man8/tc-pie.8 b/man/man8/tc-pie.8
index a302132f..bdcfba51 100644
--- a/man/man8/tc-pie.8
+++ b/man/man8/tc-pie.8
@@ -21,6 +21,10 @@ int ] [
 .B bytemode
 |
 .B nobytemode
+] [
+.B dq_rate_estimator
+|
+.B no_dq_rate_estimator
 ]
 
 .SH DESCRIPTION
@@ -71,7 +75,7 @@ alpha and beta are parameters chosen to control the drop probability. These
 should be in the range between 0 and 32.
 
 .SS ecn | noecn
-is used to mark packets instead of dropping
+is used to mark packets instead of dropping.
 .B ecn
 to turn on ecn mode,
 .B noecn
@@ -80,7 +84,7 @@ to turn off ecn mode. By default,
 is turned off.
 
 .SS bytemode | nobytemode
-is used to scale drop probability proportional to packet size
+is used to scale drop probability proportional to packet size.
 .B bytemode
 to turn on bytemode,
 .B nobytemode
@@ -88,21 +92,38 @@ to turn off bytemode. By default,
 .B bytemode
 is turned off.
 
+.SS dq_rate_estimator | no_dq_rate_estimator
+is used to calculate delay using Little's law.
+.B dq_rate_estimator
+to turn on dq_rate_estimator,
+.B no_dq_rate_estimator
+to turn off no_dq_rate_estimator. By default,
+.B dq_rate_estimator
+is turned off.
+
 .SH EXAMPLES
  # tc qdisc add dev eth0 root pie
  # tc -s qdisc show
    qdisc pie 8036: dev eth0 root refcnt 2 limit 1000p target 15.0ms tupdate 16.0ms alpha 2 beta 20
     Sent 31216108 bytes 20800 pkt (dropped 80, overlimits 0 requeues 0)
     backlog 16654b 11p requeues 0
-   prob 0.006161 delay 15666us avg_dq_rate 1159667
+   prob 0.006161 delay 15666us
    pkts_in 20811 overlimit 0 dropped 80 maxq 50 ecn_mark 0
 
+ # tc qdisc add dev eth0 root pie dq_rate_estimator
+ # tc -s qdisc show
+   qdisc pie 8036: dev eth0 root refcnt 2 limit 1000p target 15.0ms tupdate 16.0ms alpha 2 beta 20
+    Sent 63947420 bytes 42414 pkt (dropped 41, overlimits 0 requeues 0)
+    backlog 271006b 179p requeues 0
+   prob 0.000092 delay 22200us avg_dq_rate 12145996
+   pkts_in 41 overlimit 343 dropped 0 maxq 50 ecn_mark 0
+
  # tc qdisc add dev eth0 root pie limit 100 target 20ms tupdate 30ms ecn
  # tc -s qdisc show
    qdisc pie 8036: dev eth0 root refcnt 2 limit 100p target 20.0ms tupdate 32.0ms alpha 2 beta 20 ecn
     Sent 6591724 bytes 4442 pkt (dropped 27, overlimits 0 requeues 0)
     backlog 18168b 12p requeues 0
-   prob 0.008845 delay 11348us avg_dq_rate 1342773
+   prob 0.008845 delay 11348us
    pkts_in 4454 overlimit 0 dropped 27 maxq 65 ecn_mark 0
 
  # tc qdisc add dev eth0 root pie limit 100 target 50ms tupdate 30ms bytemode
@@ -110,7 +131,7 @@ is turned off.
    qdisc pie 8036: dev eth0 root refcnt 2 limit 100p target 50.0ms tupdate 32.0ms alpha 2 beta 20 bytemode
     Sent 1616274 bytes 1137 pkt (dropped 0, overlimits 0 requeues 0)
     backlog 13626b 9p requeues 0
-   prob 0.000000 delay 0us avg_dq_rate 0
+   prob 0.000000 delay 0us
    pkts_in 1146 overlimit 0 dropped 0 maxq 23 ecn_mark 0
 
 .SH SEE ALSO
diff --git a/tc/q_pie.c b/tc/q_pie.c
index 40982f96..935548a2 100644
--- a/tc/q_pie.c
+++ b/tc/q_pie.c
@@ -31,9 +31,10 @@
 static void explain(void)
 {
 	fprintf(stderr,
-		"Usage: ... pie	[ limit PACKETS ][ target TIME us]\n"
-		"		[ tupdate TIME us][ alpha ALPHA ]"
-		"[beta BETA ][bytemode | nobytemode][ecn | noecn ]\n");
+		"Usage: ... pie [ limit PACKETS ] [ target TIME ]\n"
+		"               [ tupdate TIME ] [ alpha ALPHA ] [ beta BETA ]\n"
+		"               [ bytemode | nobytemode ] [ ecn | noecn ]\n"
+		"               [ dq_rate_estimator | no_dq_rate_estimator ]\n");
 }
 
 #define ALPHA_MAX 32
@@ -49,6 +50,7 @@ static int pie_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	unsigned int beta    = 0;
 	int ecn = -1;
 	int bytemode = -1;
+	int dq_rate_estimator = -1;
 	struct rtattr *tail;
 
 	while (argc > 0) {
@@ -92,6 +94,10 @@ static int pie_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 			bytemode = 1;
 		} else if (strcmp(*argv, "nobytemode") == 0) {
 			bytemode = 0;
+		} else if (strcmp(*argv, "dq_rate_estimator") == 0) {
+			dq_rate_estimator = 1;
+		} else if (strcmp(*argv, "no_dq_rate_estimator") == 0) {
+			dq_rate_estimator = 0;
 		} else if (strcmp(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -120,6 +126,9 @@ static int pie_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	if (bytemode != -1)
 		addattr_l(n, 1024, TCA_PIE_BYTEMODE, &bytemode,
 			  sizeof(bytemode));
+	if (dq_rate_estimator != -1)
+		addattr_l(n, 1024, TCA_PIE_DQ_RATE_ESTIMATOR,
+			  &dq_rate_estimator, sizeof(dq_rate_estimator));
 
 	addattr_nest_end(n, tail);
 	return 0;
@@ -135,6 +144,7 @@ static int pie_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	unsigned int beta;
 	unsigned int ecn;
 	unsigned int bytemode;
+	unsigned int dq_rate_estimator;
 
 	SPRINT_BUF(b1);
 
@@ -182,6 +192,14 @@ static int pie_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 			fprintf(f, "bytemode ");
 	}
 
+	if (tb[TCA_PIE_DQ_RATE_ESTIMATOR] &&
+	    RTA_PAYLOAD(tb[TCA_PIE_DQ_RATE_ESTIMATOR]) >= sizeof(__u32)) {
+		dq_rate_estimator =
+				rta_getattr_u32(tb[TCA_PIE_DQ_RATE_ESTIMATOR]);
+		if (dq_rate_estimator)
+			fprintf(f, "dq_rate_estimator ");
+	}
+
 	return 0;
 }
 
@@ -198,9 +216,14 @@ static int pie_print_xstats(struct qdisc_util *qu, FILE *f,
 
 	st = RTA_DATA(xstats);
 	/*prob is returned as a fracion of maximum integer value */
-	fprintf(f, "prob %f delay %uus avg_dq_rate %u\n",
-		(double)st->prob / UINT64_MAX, st->delay,
-		st->avg_dq_rate);
+	fprintf(f, "prob %f delay %uus",
+		(double)st->prob / UINT64_MAX, st->delay);
+
+	if (st->dq_rate_estimating)
+		fprintf(f, " avg_dq_rate %u\n", st->avg_dq_rate);
+	else
+		fprintf(f, "\n");
+
 	fprintf(f, "pkts_in %u overlimit %u dropped %u maxq %u ecn_mark %u\n",
 		st->packets_in, st->overlimit, st->dropped, st->maxq,
 		st->ecn_mark);
-- 
2.17.1

