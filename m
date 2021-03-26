Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3081E34A78A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhCZMuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhCZMub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 08:50:31 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29442C0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 05:50:30 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h13so6173622eds.5
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 05:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8mebednsoDGaWPLWEp0kPnnA/d61KDL9L4xviCnrJvY=;
        b=zvvAY8injIYqG2o8eYDSg3PLknb6Y3Mn1MuJSqciogBHsLL4t4KMQlcB5cDyyRywnR
         +n+pyXlALbPfTEYXY6otHB6s9LlyQJIom8pkITxkzREnPWTVLzZ+9ZD/BcS2TEmaqddr
         evLU7SEXrj1GO4GYRBqo+6o4StUQrVrQ5GWuCjw0rdk7oYpSX/kKhcIRZz/6srXyL/c9
         bElWHT7yU/b+mRNOIeio/K0a+1Hy4vuE1jjj9xLNAK2xb3swmYNO3XAp8seJ2zGMClX6
         3N+ZqvOxmm4wDuXMouryYdT7aDzd41629Hrk15h2hfooh+iTNZY5clJIad4omxaLWOH6
         18SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8mebednsoDGaWPLWEp0kPnnA/d61KDL9L4xviCnrJvY=;
        b=ZO78nwcPj9ga5mGz38TeCc+gIc/Upr+D7ty/ztAFPYW38SPxSlzAB1v5vfFpqKW3Tt
         GGiEYkSa8DKD/Q/55vbTB85lBlXK0cQHKyz7COzrHhxNMdtA3k2nmSPbkoZraXDjsCAS
         3yIng9V1ODcDT5oZypMnLKFxcl/ZP2VpgoB3RoPbyEVMqTPTHT4LQplUG4WcP5D/Otsa
         LhM3a+Q0B9BFDW3Pn/YTRdmhXX++Txd1gVlKjlqqdtrsYpmFLkHsrsVTdF3nNrNogVJW
         mYeVnrRqoN9lhs8yyC+dzMFo1J3V+ymZ1WjOKc5SHxehnSG+rT2fxJFRbT7awfv6evH0
         XslQ==
X-Gm-Message-State: AOAM530pLeVl6Ae88brc5bRVzsbxBw9JywgszCHX/N6U9Ie4IK6rc+7W
        Slet/lRBjXukgeaM4wZkPs6XjvRbKeZaEg==
X-Google-Smtp-Source: ABdhPJyODnSW1HSTY8w4eYFL4O+R6SfvhJu5yKAu74zyae2G2Yff8U9b8UZtAXgoPuCdHu8bU6x36A==
X-Received: by 2002:aa7:c5cf:: with SMTP id h15mr5337885eds.190.1616763028897;
        Fri, 26 Mar 2021 05:50:28 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id gn3sm3728112ejc.2.2021.03.26.05.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 05:50:27 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: [PATCH iproute2-next] police: add support for packet-per-second rate limiting
Date:   Fri, 26 Mar 2021 13:50:18 +0100
Message-Id: <20210326125018.32091-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Allow a policer action to enforce a rate-limit based on packets-per-second,
configurable using a packet-per-second rate and burst parameters.

e.g.
 # $TC actions add action police pkts_rate 1000 pkts_burst 200 index 1
 # $TC actions ls action police
 total acts 1

	action order 0:  police 0x1 rate 0bit burst 0b mtu 4096Mb pkts_rate 1000 pkts_burst 200
	ref 1 bind 0

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
---
 man/man8/tc-police.8 | 35 ++++++++++++++++++++++++-------
 tc/m_police.c        | 50 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/man/man8/tc-police.8 b/man/man8/tc-police.8
index 52279755..86e263bb 100644
--- a/man/man8/tc-police.8
+++ b/man/man8/tc-police.8
@@ -5,9 +5,11 @@ police - policing action
 .SH SYNOPSIS
 .in +8
 .ti -8
-.BR tc " ... " "action police"
+.BR tc " ... " "action police ["
 .BI rate " RATE " burst
-.IR BYTES [\fB/ BYTES "] ["
+.IR BYTES [\fB/ BYTES "] ] ["
+.BI pkts_rate " RATE " pkts_burst
+.IR PACKETS "] ["
 .B mtu
 .IR BYTES [\fB/ BYTES "] ] ["
 .BI peakrate " RATE"
@@ -34,19 +36,29 @@ police - policing action
 .SH DESCRIPTION
 The
 .B police
-action allows to limit bandwidth of traffic matched by the filter it is
-attached to. Basically there are two different algorithms available to measure
-the packet rate: The first one uses an internal dual token bucket and is
-configured using the
+action allows limiting of the byte or packet rate of traffic matched by the
+filter it is attached to.
+.P
+There are two different algorithms available to measure the byte rate: The
+first one uses an internal dual token bucket and is configured using the
 .BR rate ", " burst ", " mtu ", " peakrate ", " overhead " and " linklayer
 parameters. The second one uses an in-kernel sampling mechanism. It can be
 fine-tuned using the
 .B estimator
 filter parameter.
+.P
+There is one algorithm available to measure packet rate and it is similar to
+the first algorithm described for byte rate. It is configured using the
+.BR pkt_rate " and " pkt_burst
+parameters.
+.P
+At least one of the
+.BR rate " and " pkt_rate "
+parameters must be configured.
 .SH OPTIONS
 .TP
 .BI rate " RATE"
-The maximum traffic rate of packets passing this action. Those exceeding it will
+The maximum byte rate of packets passing this action. Those exceeding it will
 be treated as defined by the
 .B conform-exceed
 option.
@@ -55,6 +67,15 @@ option.
 Set the maximum allowed burst in bytes, optionally followed by a slash ('/')
 sign and cell size which must be a power of 2.
 .TP
+.BI pkt_rate " RATE"
+The maximum packet rate or packets passing this action. Those exceeding it will
+be treated as defined by the
+.B conform-exceed
+option.
+.TP
+.BI pkt_burst " PACKETS"
+Set the maximum allowed burst in packets.
+.TP
 .BI mtu " BYTES\fR[\fB/\fIBYTES\fR]"
 This is the maximum packet size handled by the policer (larger ones will be
 handled like they exceeded the configured rate). Setting this value correctly
diff --git a/tc/m_police.c b/tc/m_police.c
index bb51df68..9ef0e40b 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -38,7 +38,8 @@ struct action_util police_action_util = {
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: ... police rate BPS burst BYTES[/BYTES] [ mtu BYTES[/BYTES] ]\n"
+		"Usage: ... police [ rate BPS burst BYTES[/BYTES] ] \n"
+		"		[ pkts_rate RATE pkts_burst PACKETS ] [ mtu BYTES[/BYTES] ]\n"
 		"		[ peakrate BPS ] [ avrate BPS ] [ overhead BYTES ]\n"
 		"		[ linklayer TYPE ] [ CONTROL ]\n"
 		"Where: CONTROL := conform-exceed <EXCEEDACT>[/NOTEXCEEDACT]\n"
@@ -67,6 +68,7 @@ static int act_parse_police(struct action_util *a, int *argc_p, char ***argv_p,
 	int Rcell_log =  -1, Pcell_log = -1;
 	struct rtattr *tail;
 	__u64 rate64 = 0, prate64 = 0;
+	__u64 pps64 = 0, ppsburst64 = 0;
 
 	if (a) /* new way of doing things */
 		NEXT_ARG();
@@ -144,6 +146,18 @@ static int act_parse_police(struct action_util *a, int *argc_p, char ***argv_p,
 			NEXT_ARG();
 			if (get_linklayer(&linklayer, *argv))
 				invarg("linklayer", *argv);
+		} else if (matches(*argv, "pkts_rate") == 0) {
+			NEXT_ARG();
+			if (pps64)
+				duparg("pkts_rate", *argv);
+			if (get_u64(&pps64, *argv, 10))
+				invarg("pkts_rate", *argv);
+		} else if (matches(*argv, "pkts_burst") == 0) {
+			NEXT_ARG();
+			if (ppsburst64)
+				duparg("pkts_burst", *argv);
+			if (get_u64(&ppsburst64, *argv, 10))
+				invarg("pkts_burst", *argv);
 		} else if (strcmp(*argv, "help") == 0) {
 			usage();
 		} else {
@@ -161,8 +175,8 @@ action_ctrl_ok:
 		return -1;
 
 	/* Must at least do late binding, use TB or ewma policing */
-	if (!rate64 && !avrate && !p.index && !mtu) {
-		fprintf(stderr, "'rate' or 'avrate' or 'mtu' MUST be specified.\n");
+	if (!rate64 && !avrate && !p.index && !mtu && !pps64) {
+		fprintf(stderr, "'rate' or 'avrate' or 'mtu' or 'pkts_rate' MUST be specified.\n");
 		return -1;
 	}
 
@@ -172,6 +186,18 @@ action_ctrl_ok:
 		return -1;
 	}
 
+	/* When the packets TB policer is used, pkts_burst is required */
+	if (pps64 && !ppsburst64) {
+		fprintf(stderr, "'pkts_burst' requires 'pkts_rate'.\n");
+		return -1;
+	}
+
+	/* forbid rate and pkts_rate in same action */
+	if (pps64 && rate64) {
+		fprintf(stderr, "'rate' and 'pkts_rate' are not allowed in same action.\n");
+		return -1;
+	}
+
 	if (prate64) {
 		if (!rate64) {
 			fprintf(stderr, "'peakrate' requires 'rate'.\n");
@@ -223,6 +249,12 @@ action_ctrl_ok:
 	if (presult)
 		addattr32(n, MAX_MSG, TCA_POLICE_RESULT, presult);
 
+	if (pps64) {
+		addattr64(n, MAX_MSG, TCA_POLICE_PKTRATE64, pps64);
+		ppsburst64 = tc_calc_xmittime(pps64, ppsburst64);
+		addattr64(n, MAX_MSG, TCA_POLICE_PKTBURST64, ppsburst64);
+	}
+
 	addattr_nest_end(n, tail);
 	res = 0;
 
@@ -244,6 +276,7 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	unsigned int buffer;
 	unsigned int linklayer;
 	__u64 rate64, prate64;
+	__u64 pps64, ppsburst64;
 
 	if (arg == NULL)
 		return 0;
@@ -287,6 +320,17 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 		tc_print_rate(PRINT_FP, NULL, "avrate %s ",
 			      rta_getattr_u32(tb[TCA_POLICE_AVRATE]));
 
+	if ((tb[TCA_POLICE_PKTRATE64] &&
+	     RTA_PAYLOAD(tb[TCA_POLICE_PKTRATE64]) >= sizeof(pps64)) &&
+	     (tb[TCA_POLICE_PKTBURST64] &&
+	      RTA_PAYLOAD(tb[TCA_POLICE_PKTBURST64]) >= sizeof(ppsburst64))) {
+		pps64 = rta_getattr_u64(tb[TCA_POLICE_PKTRATE64]);
+		ppsburst64 = rta_getattr_u64(tb[TCA_POLICE_PKTBURST64]);
+		ppsburst64 = tc_calc_xmitsize(pps64, ppsburst64);
+		fprintf(f, "pkts_rate %llu ", pps64);
+		fprintf(f, "pkts_burst %llu ", ppsburst64);
+	}
+
 	print_action_control(f, "action ", p->action, "");
 
 	if (tb[TCA_POLICE_RESULT]) {
-- 
2.20.1

