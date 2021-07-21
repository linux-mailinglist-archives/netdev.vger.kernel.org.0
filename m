Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE933D1A5A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 01:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhGUWk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 18:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhGUWk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 18:40:28 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EDCC061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 16:21:03 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id 23so3834206qke.0
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 16:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KntcA/+cXFzWeEMJQNYc9VEBauAF/IBg64PduElByCA=;
        b=N5Xl3LAwtPZ6w/JeMgj7/dfn/TyVn7sGxHiBZ0ow++wGCGkcIxKC+VmvfCC5TDqfQW
         BYMV+V826h0qM3l8fbN9rmZQTORVLWXOs04OWBrh0pAgyTjivPIjdxFYGPF80hqv3Un5
         uCxcQKpgwEmlbCCdcHODyYaHgW3wTD9cfmxgY3xcy2AnyBbhvWlTKZat4jFhjusPFTG/
         PZ8b3v3DGr7HyRsW89WNSG6751IHM0jEGt3rmgnus96bb7lrj6NwooPaCQdwvB1AqlEA
         sJ3fbqLmgB1yLtr+KdWLWj+TK8Jtn9l4ZGZz42a0SvtizjAl2Jqdr/P/wWmPNg0GcWv4
         5AtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KntcA/+cXFzWeEMJQNYc9VEBauAF/IBg64PduElByCA=;
        b=sJONzoGK9Faq9CUy0iEOfj5dvR8VEhV9EKBRU0HhShelc96j4cJZkBp+feUMf+pBha
         ox1hlll9PCIqToBRmTTEx+5agFx69ASqBPCVGxXf5Pze8tFiC8ACGdc2NV6nIcleFK3n
         ufYNpziQKIKqPggaT9rbCdApibVAmZ2obmSXzIOWJ8Www2BCJLv7sDhlkyAB+qxsUR7h
         UhXTE4qhCOpJrcLO+vBDb+jUf15qUyrCDBI/ImjnBdkOFYtM0JltWf1fbs5d+04SZoSb
         0Ob4SZ7RpQO59hZo4RBvMlIIVShMcWw2K0H4VKk8nUUTfyAvf4yMQKWxzr+LCycXKKl/
         KLcg==
X-Gm-Message-State: AOAM533FbB/gIPl0upk/dZ6sxWWmVTVRqF8Z0mAyS7UOJBEFTZSB4jmr
        2nVNgeVjfiU7cUGTaKcLMfZ25qOTpA==
X-Google-Smtp-Source: ABdhPJyeVZtByVWSjqa76CtDsZduK26LBlan1+LLap03T7LzdG84whn067kcQmJs21kadNo6W3JYbA==
X-Received: by 2002:a05:620a:4043:: with SMTP id i3mr20162604qko.27.1626909662764;
        Wed, 21 Jul 2021 16:21:02 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id m187sm11782201qkd.131.2021.07.21.16.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 16:21:02 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next] tc/skbmod: Introduce SKBMOD_F_ECN option
Date:   Wed, 21 Jul 2021 16:20:53 -0700
Message-Id: <20210721232053.39077-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
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
Hi all,

The corresponding kernel patch is here, which is currently pending
for review:
https://lore.kernel.org/netdev/f5c5a81d6674a8f4838684ac52ed66da83f92499.1626899889.git.peilin.ye@bytedance.com/T/#u

It also depends on this iproute2 patch, which is also pending:
https://lore.kernel.org/netdev/20210720192145.20166-1-yepeilin.cs@gmail.com/

Thanks,
Peilin Ye

 include/uapi/linux/tc_act/tc_skbmod.h |  1 +
 man/man8/tc-skbmod.8                  | 38 ++++++++++++++++++++-------
 tc/m_skbmod.c                         |  8 +++++-
 3 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/tc_act/tc_skbmod.h b/include/uapi/linux/tc_act/tc_skbmod.h
index c525b3503797..af6ef2cfbf3d 100644
--- a/include/uapi/linux/tc_act/tc_skbmod.h
+++ b/include/uapi/linux/tc_act/tc_skbmod.h
@@ -17,6 +17,7 @@
 #define SKBMOD_F_SMAC	0x2
 #define SKBMOD_F_ETYPE	0x4
 #define SKBMOD_F_SWAPMAC 0x8
+#define SKBMOD_F_ECN	0x10
 
 struct tc_skbmod {
 	tc_gen;
diff --git a/man/man8/tc-skbmod.8 b/man/man8/tc-skbmod.8
index 76512311b17d..52eaf989e80b 100644
--- a/man/man8/tc-skbmod.8
+++ b/man/man8/tc-skbmod.8
@@ -8,7 +8,8 @@ skbmod - user-friendly packet editor action
 .BR tc " ... " "action skbmod " "{ " "set "
 .IR SETTABLE " | "
 .BI swap " SWAPPABLE"
-.RI " } [ " CONTROL " ] [ "
+.RB " | " ecn
+.RI "} [ " CONTROL " ] [ "
 .BI index " INDEX "
 ]
 
@@ -37,6 +38,12 @@ action. Instead of having to manually edit 8-, 16-, or 32-bit chunks of an
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
@@ -51,6 +58,10 @@ Change the ethertype to the specified value.
 .BI mac
 Used to swap mac addresses.
 .TP
+.B ecn
+Used to mark ECN Capable Transport (ECT) IP packets as Congestion Encountered (CE).
+Does not affect Non ECN-Capable Transport (Non-ECT) packets.
+.TP
 .I CONTROL
 The following keywords allow to control how the tree of qdisc, classes,
 filters and actions is further traversed after this action.
@@ -115,7 +126,7 @@ tc filter add dev eth5 parent 1: protocol ip prio 10 \\
 .EE
 .RE
 
-Finally, swap the destination and source mac addresses in the header:
+To swap the destination and source mac addresses in the Ethernet header:
 
 .RS
 .EX
@@ -126,13 +137,22 @@ tc filter add dev eth3 parent 1: protocol ip prio 10 \\
 .EE
 .RE
 
-However, trying to
-.B set
-and
-.B swap
-in a single
-.B skbmod
-command will cause undefined behavior.
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
index 3fe30651a7d8..8d8bac5bc481 100644
--- a/tc/m_skbmod.c
+++ b/tc/m_skbmod.c
@@ -28,7 +28,7 @@
 static void skbmod_explain(void)
 {
 	fprintf(stderr,
-		"Usage:... skbmod { set <SETTABLE> | swap <SWAPPABLE> } [CONTROL] [index INDEX]\n"
+		"Usage:... skbmod { set <SETTABLE> | swap <SWAPPABLE> | ecn } [CONTROL] [index INDEX]\n"
 		"where SETTABLE is: [dmac DMAC] [smac SMAC] [etype ETYPE]\n"
 		"where SWAPPABLE is: \"mac\" to swap mac addresses\n"
 		"\tDMAC := 6 byte Destination MAC address\n"
@@ -111,6 +111,9 @@ static int parse_skbmod(struct action_util *a, int *argc_p, char ***argv_p,
 			p.flags |= SKBMOD_F_SMAC;
 			fprintf(stderr, "src MAC address <%s>\n", saddr);
 			ok += 1;
+		} else if (matches(*argv, "ecn") == 0) {
+			p.flags |= SKBMOD_F_ECN;
+			ok += 1;
 		} else if (matches(*argv, "help") == 0) {
 			skbmod_usage();
 		} else {
@@ -211,6 +214,9 @@ static int print_skbmod(struct action_util *au, FILE *f, struct rtattr *arg)
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

