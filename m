Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3EF3DDEC6
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhHBRzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHBRzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 13:55:11 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110BAC06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 10:55:02 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 184so17435706qkh.1
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 10:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GwfaRUkFdK10dQiPer/wQQ4LnP1Rwsjlne0r4oYL/oE=;
        b=OyYU9jEPoWSQj5YlZ3UpybqQ0BHehxbg1txuOE5FUqVwQSadodojyaCbzpjFK0G5SZ
         j9vNDMpudADCOIDWHBOVSlBZl/nZ/uzLOIUpR0O/6BS4sTxXY4FnBSv3furQ7FoL5HPt
         Ak9plbdV8c9LW28AV8k7aqvGxiUkNX9UXzlMVDjpF+Lvk3JJHIqV4AGEA82Np15hzOfz
         dm3ZhTVsIrnBpkYvAi3lN+y30cHt6tWd4U4fJIKuw/CCXuq43G5wWMoDpcP9t9ZbB8hV
         8jFx8LNpXkURWYVYJe0asAoeTmlZdXy7LilyjpRLqQsN0/6nB/mGWHxkmZn65pdRG9S6
         Wcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GwfaRUkFdK10dQiPer/wQQ4LnP1Rwsjlne0r4oYL/oE=;
        b=T3oNfPvlW5+K+l1YqqQCly59i49NtSYIYnVA7UMxfhoKssaC8879ZDlp9DGtwmpSSS
         yorPYC+1qnPlOSHjV3brpggSeWavvW6whYF0wTikTQjNDQtfu+oZEOGFJFAXJvshLsPp
         qsRMo5flkswoUjkn5lF5/F5oJA7xFQoDoVngeTxZCQIVIo7m1BVJkoEJvZR4myICdhAE
         tlcOm4vHe7X5ZUZZuEUfRqsfSVwKL1gvz1MONwZLrxnxYoVuWYuRTC4Cq4l3YxN9wQRC
         1tCR5g4MZVvCmOrMmbW09NEI0BAA+Ud/+WxvggH65F31cruAQhiKM5FjMGC0KP2U6MaU
         1nOQ==
X-Gm-Message-State: AOAM531LFGEViSeUdShVfLC9sCis8wttRiWiH5fgELKJyguUlsYxcd6T
        T5Z/8txqxZVF8DL5hiDSxXd9Kllkd5bj
X-Google-Smtp-Source: ABdhPJwG+BrjubMRF0vF1JucN1eKkrcO5m+/+xjF1/JobiGjJp23ZDfjBisWhC3JnRJmJD/qCnXlTg==
X-Received: by 2002:a37:90d:: with SMTP id 13mr16710607qkj.386.1627926897956;
        Mon, 02 Aug 2021 10:54:57 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id g26sm6160039qkm.122.2021.08.02.10.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 10:54:57 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next v2] tc/skbmod: Introduce SKBMOD_F_ECN option
Date:   Mon,  2 Aug 2021 10:54:52 -0700
Message-Id: <20210802175452.7734-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721232053.39077-1-yepeilin.cs@gmail.com>
References: <20210721232053.39077-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Recently we added SKBMOD_F_ECN option support to the kernel; support it in
the tc-skbmod(8) front end, and update its man page accordingly.

The 2 least significant bits of the Traffic Class field in IPv4 and IPv6
headers are used to represent different ECN states [1]:

	0b00: "Non ECN-Capable Transport", Non-ECT
	0b10: "ECN Capable Transport", ECT(0)
	0b01: "ECN Capable Transport", ECT(1)
	0b11: "Congestion Encountered", CE

This new option, "ecn", marks ECT(0) and ECT(1) IPv{4,6} packets as CE,
which is useful for ECN-based rate limiting.  For example:

	$ tc filter add dev eth0 parent 1: protocol ip prio 10 \
		u32 match ip protocol 1 0xff flowid 1:2 \
		action skbmod \
		ecn

The updated tc-skbmod SYNOPSIS looks like the following:

	tc ... action skbmod { set SETTABLE | swap SWAPPABLE | ecn } ...

Only one of "set", "swap" or "ecn" shall be used in a single tc-skbmod
command.  Trying to use more than one of them at a time is considered
undefined behavior; pipe multiple tc-skbmod commands together instead.
"set" and "swap" only affect Ethernet packets, while "ecn" only affects
IP packets.

Depends on kernel patch "net/sched: act_skbmod: Add SKBMOD_F_ECN option
support", as well as iproute2 patch "tc/skbmod: Remove misinformation
about the swap action".

[1] https://en.wikipedia.org/wiki/Explicit_Congestion_Notification

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Hi David,

Rebased on iproute2-next, should hunk now; thank you!

There will be a conflict next time you merge iproute2 into iproute2-next
because of this commit:

"tc/skbmod: Remove misinformation about the swap action"
https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=c06d313d86c1acb8dd72589816301853ff5a4ac4

Please just ignore its code change since it is now superseded by this v2.

Thanks!
Peilin Ye

Change since v1:
    - rebased on iproute2-next (David)

 man/man8/tc-skbmod.8 | 46 ++++++++++++++++++++++++++++++++------------
 tc/m_skbmod.c        | 11 ++++++++---
 2 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/man/man8/tc-skbmod.8 b/man/man8/tc-skbmod.8
index eb3c38fa6bf3..52eaf989e80b 100644
--- a/man/man8/tc-skbmod.8
+++ b/man/man8/tc-skbmod.8
@@ -5,12 +5,13 @@ skbmod - user-friendly packet editor action
 .SH SYNOPSIS
 .in +8
 .ti -8
-.BR tc " ... " "action skbmod " "{ [ " "set "
-.IR SETTABLE " ] [ "
+.BR tc " ... " "action skbmod " "{ " "set "
+.IR SETTABLE " | "
 .BI swap " SWAPPABLE"
-.RI " ] [ " CONTROL " ] [ "
+.RB " | " ecn
+.RI "} [ " CONTROL " ] [ "
 .BI index " INDEX "
-] }
+]
 
 .ti -8
 .IR SETTABLE " := "
@@ -25,6 +26,7 @@ skbmod - user-friendly packet editor action
 .IR SWAPPABLE " := "
 .B mac
 .ti -8
+
 .IR CONTROL " := {"
 .BR reclassify " | " pipe " | " drop " | " shot " | " continue " | " pass " }"
 .SH DESCRIPTION
@@ -36,6 +38,12 @@ action. Instead of having to manually edit 8-, 16-, or 32-bit chunks of an
 ethernet header,
 .B skbmod
 allows complete substitution of supported elements.
+Action must be one of
+.BR set ", " swap " and " ecn "."
+.BR set " and " swap
+only affect Ethernet packets, while
+.B ecn
+only affects IP packets.
 .SH OPTIONS
 .TP
 .BI dmac " DMAC"
@@ -48,10 +56,11 @@ Change the source mac to the specified address.
 Change the ethertype to the specified value.
 .TP
 .BI mac
-Used to swap mac addresses. The
-.B swap mac
-directive is performed
-after any outstanding D/SMAC changes.
+Used to swap mac addresses.
+.TP
+.B ecn
+Used to mark ECN Capable Transport (ECT) IP packets as Congestion Encountered (CE).
+Does not affect Non ECN-Capable Transport (Non-ECT) packets.
 .TP
 .I CONTROL
 The following keywords allow to control how the tree of qdisc, classes,
@@ -117,7 +126,7 @@ tc filter add dev eth5 parent 1: protocol ip prio 10 \\
 .EE
 .RE
 
-Finally, swap the destination and source mac addresses in the header:
+To swap the destination and source mac addresses in the Ethernet header:
 
 .RS
 .EX
@@ -128,9 +137,22 @@ tc filter add dev eth3 parent 1: protocol ip prio 10 \\
 .EE
 .RE
 
-As mentioned above, the swap action will occur after any
-.B " smac/dmac "
-substitutions are executed, if they are present.
+Finally, to mark the CE codepoint in the IP header for ECN Capable Transport (ECT) packets:
+
+.RS
+.EX
+tc filter add dev eth0 parent 1: protocol ip prio 10 \\
+	u32 match ip protocol 1 0xff flowid 1:2 \\
+	action skbmod \\
+	ecn
+.EE
+.RE
+
+Only one of
+.BR set ", " swap " and " ecn
+shall be used in a single command.
+Trying to use more than one of them in a single command is considered undefined behavior; pipe
+multiple commands together instead.
 
 .SH SEE ALSO
 .BR tc (8),
diff --git a/tc/m_skbmod.c b/tc/m_skbmod.c
index e13d3f16bfcb..8d8bac5bc481 100644
--- a/tc/m_skbmod.c
+++ b/tc/m_skbmod.c
@@ -28,10 +28,9 @@
 static void skbmod_explain(void)
 {
 	fprintf(stderr,
-		"Usage:... skbmod {[set <SETTABLE>] [swap <SWAPABLE>]} [CONTROL] [index INDEX]\n"
+		"Usage:... skbmod { set <SETTABLE> | swap <SWAPPABLE> | ecn } [CONTROL] [index INDEX]\n"
 		"where SETTABLE is: [dmac DMAC] [smac SMAC] [etype ETYPE]\n"
-		"where SWAPABLE is: \"mac\" to swap mac addresses\n"
-		"note: \"swap mac\" is done after any outstanding D/SMAC change\n"
+		"where SWAPPABLE is: \"mac\" to swap mac addresses\n"
 		"\tDMAC := 6 byte Destination MAC address\n"
 		"\tSMAC := optional 6 byte Source MAC address\n"
 		"\tETYPE := optional 16 bit ethertype\n"
@@ -112,6 +111,9 @@ static int parse_skbmod(struct action_util *a, int *argc_p, char ***argv_p,
 			p.flags |= SKBMOD_F_SMAC;
 			fprintf(stderr, "src MAC address <%s>\n", saddr);
 			ok += 1;
+		} else if (matches(*argv, "ecn") == 0) {
+			p.flags |= SKBMOD_F_ECN;
+			ok += 1;
 		} else if (matches(*argv, "help") == 0) {
 			skbmod_usage();
 		} else {
@@ -212,6 +214,9 @@ static int print_skbmod(struct action_util *au, FILE *f, struct rtattr *arg)
 	if (p->flags & SKBMOD_F_SWAPMAC)
 		fprintf(f, "swap mac ");
 
+	if (p->flags & SKBMOD_F_ECN)
+		fprintf(f, "ecn ");
+
 	fprintf(f, "\n\t index %u ref %d bind %d", p->index, p->refcnt,
 		p->bindcnt);
 	if (show_stats) {
-- 
2.20.1

