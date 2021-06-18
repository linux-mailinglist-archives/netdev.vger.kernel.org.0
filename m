Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CEA3AD00D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbhFRQK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:10:56 -0400
Received: from mail.asbjorn.biz ([185.38.24.25]:50648 "EHLO mail.asbjorn.biz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232455AbhFRQKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 12:10:53 -0400
Received: from x201s (space.labitat.dk [185.38.175.0])
        by mail.asbjorn.biz (Postfix) with ESMTPSA id EEF2D1C29738;
        Fri, 18 Jun 2021 16:08:38 +0000 (UTC)
Received: by x201s (Postfix, from userid 1000)
        id 4B6A32054C0; Fri, 18 Jun 2021 16:07:33 +0000 (UTC)
From:   =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= 
        <asbjorn@asbjorn.st>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= 
        <asbjorn@asbjorn.st>, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2 v3 2/2] tc: pedit: add decrement operation
Date:   Fri, 18 Jun 2021 16:06:35 +0000
Message-Id: <20210618160635.703845-2-asbjorn@asbjorn.st>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210618160635.703845-1-asbjorn@asbjorn.st>
References: <20210618160635.703845-1-asbjorn@asbjorn.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a decrement operation for ttl and hoplimit.

Since this is just syntactic sugar, it goes that:

  tc filter add ... action pedit ex munge ip ttl dec ...
  tc filter add ... action pedit ex munge ip6 hoplimit dec ...

is just a more readable version of this:

  tc filter add ... action pedit ex munge ip ttl add 0xff ...
  tc filter add ... action pedit ex munge ip6 hoplimit add 0xff ...

This feature was suggested by some pseudo tc examples in Mellanox's
documentation[1], but wasn't present in neither their mlnx-iproute2
nor iproute2.

Tested with skip_sw on Mellanox ConnectX-6 Dx.

[1] https://docs.mellanox.com/pages/viewpage.action?pageId=47033989

v3:
   - Use dedicated flags argument in parse_cmd() (David Ahern)
   - Minor rewording of the man page

v2:
   - Fix whitespace issue (Stephen Hemminger)
   - Add to usage info in explain()

Signed-off-by: Asbjørn Sloth Tønnesen <asbjorn@asbjorn.st>
---
 man/man8/tc-pedit.8 |  8 +++++++-
 tc/m_pedit.c        | 25 +++++++++++++++++++------
 tc/m_pedit.h        |  4 ++++
 tc/p_ip.c           |  2 +-
 tc/p_ip6.c          |  2 +-
 5 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
index 376ad4a8..15159ddd 100644
--- a/man/man8/tc-pedit.8
+++ b/man/man8/tc-pedit.8
@@ -77,6 +77,7 @@ pedit - generic packet editor action
 .IR VAL " | "
 .BR add
 .IR VAL " | "
+.BR decrement " | "
 .BR preserve " } [ " retain
 .IR RVAL " ]"
 
@@ -96,7 +97,7 @@ chosen automatically based on the header field size.
 .B ex
 Use extended pedit.
 .I EXTENDED_LAYERED_OP
-and the add
+and the add/decrement
 .I CMD_SPEC
 are allowed only in this mode.
 .TP
@@ -288,6 +289,11 @@ is defined by the size of the addressed header field in
 .IR EXTENDED_LAYERED_OP .
 This operation is supported only for extended layered op.
 .TP
+.BI decrement
+Decrease the addressed data by one.
+This operation is supported only for
+.BR ip " " ttl " and " ip6 " " hoplimit "."
+.TP
 .B preserve
 Keep the addressed data as is.
 .TP
diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index b745c379..54949e43 100644
--- a/tc/m_pedit.c
+++ b/tc/m_pedit.c
@@ -41,7 +41,7 @@ static void explain(void)
 		"\t\tATC:= at <atval> offmask <maskval> shift <shiftval>\n"
 		"\t\tNOTE: offval is byte offset, must be multiple of 4\n"
 		"\t\tNOTE: maskval is a 32 bit hex number\n \t\tNOTE: shiftval is a shift value\n"
-		"\t\tCMD:= clear | invert | set <setval>| add <addval> | retain\n"
+		"\t\tCMD:= clear | invert | set <setval> | add <addval> | decrement | retain\n"
 		"\t<LAYERED>:= ip <ipdata> | ip6 <ip6data>\n"
 		" \t\t| udp <udpdata> | tcp <tcpdata> | icmp <icmpdata>\n"
 		"\tCONTROL:= reclassify | pipe | drop | continue | pass |\n"
@@ -360,15 +360,24 @@ int parse_cmd(int *argc_p, char ***argv_p, __u32 len, int type, __u32 retain,
 		if (matches(*argv, "add") == 0)
 			tkey->cmd = TCA_PEDIT_KEY_EX_CMD_ADD;
 
-		if (!sel->extended && tkey->cmd) {
-			fprintf(stderr,
-				"Non extended mode. only 'set' command is supported\n");
-			return -1;
-		}
+		if (!sel->extended && tkey->cmd)
+			goto non_ext_only_set_cmd;
 
 		NEXT_ARG();
 		if (parse_val(&argc, &argv, val, type))
 			return -1;
+	} else if (matches(*argv, "decrement") == 0) {
+		if ((flags & PEDIT_ALLOW_DEC) == 0) {
+			fprintf(stderr,
+				"decrement command is not supported for this field\n");
+			return -1;
+		}
+
+		if (!sel->extended)
+			goto non_ext_only_set_cmd;
+
+		tkey->cmd = TCA_PEDIT_KEY_EX_CMD_ADD;
+		*v = retain; /* decrement by overflow */
 	} else if (matches(*argv, "preserve") == 0) {
 		retain = 0;
 	} else {
@@ -431,6 +440,10 @@ done:
 	*argv_p = argv;
 	return res;
 
+non_ext_only_set_cmd:
+	fprintf(stderr,
+		"Non extended mode. only 'set' command is supported\n");
+	return -1;
 }
 
 static int parse_offset(int *argc_p, char ***argv_p, struct m_pedit_sel *sel,
diff --git a/tc/m_pedit.h b/tc/m_pedit.h
index 7398f66d..549bcf86 100644
--- a/tc/m_pedit.h
+++ b/tc/m_pedit.h
@@ -39,6 +39,10 @@
 
 #define PEDITKINDSIZ 16
 
+enum m_pedit_flags {
+	PEDIT_ALLOW_DEC = 1<<0,
+};
+
 struct m_pedit_key {
 	__u32           mask;  /* AND */
 	__u32           val;   /*XOR */
diff --git a/tc/p_ip.c b/tc/p_ip.c
index 2d1643d0..8eed9e8d 100644
--- a/tc/p_ip.c
+++ b/tc/p_ip.c
@@ -68,7 +68,7 @@ parse_ip(int *argc_p, char ***argv_p,
 	if (strcmp(*argv, "ttl") == 0) {
 		NEXT_ARG();
 		tkey->off = 8;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, PEDIT_ALLOW_DEC);
 		goto done;
 	}
 	if (strcmp(*argv, "protocol") == 0) {
diff --git a/tc/p_ip6.c b/tc/p_ip6.c
index f9d5d3b0..f855c59e 100644
--- a/tc/p_ip6.c
+++ b/tc/p_ip6.c
@@ -71,7 +71,7 @@ parse_ip6(int *argc_p, char ***argv_p,
 	if (strcmp(*argv, "hoplimit") == 0) {
 		NEXT_ARG();
 		tkey->off = 7;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, PEDIT_ALLOW_DEC);
 		goto done;
 	}
 	if (strcmp(*argv, "traffic_class") == 0) {
-- 
2.32.0

