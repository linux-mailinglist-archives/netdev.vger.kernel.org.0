Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC25C3A86D4
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 18:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhFOQt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 12:49:29 -0400
Received: from mail.asbjorn.biz ([185.38.24.25]:50816 "EHLO mail.asbjorn.biz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231363AbhFOQtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 12:49:25 -0400
Received: from x201s (space.labitat.dk [185.38.175.0])
        by mail.asbjorn.biz (Postfix) with ESMTPSA id DFF2D1C29738;
        Tue, 15 Jun 2021 16:47:11 +0000 (UTC)
Received: by x201s (Postfix, from userid 1000)
        id E4061202A16; Tue, 15 Jun 2021 16:43:02 +0000 (UTC)
From:   =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= 
        <asbjorn@asbjorn.st>
To:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= 
        <asbjorn@asbjorn.st>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2 v2] tc: pedit: add decrement operation
Date:   Tue, 15 Jun 2021 16:40:43 +0000
Message-Id: <20210615164043.316835-1-asbjorn@asbjorn.st>
X-Mailer: git-send-email 2.32.0
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

In order to avoid adding an extra parameter to parse_cmd(),
I have re-used the `int type` parameter to also carry flags.

Tested with skip_sw on Mellanox ConnectX-6 Dx.

[1] https://docs.mellanox.com/pages/viewpage.action?pageId=47033989

Signed-off-by: Asbjørn Sloth Tønnesen <asbjorn@asbjorn.st>
---
 man/man8/tc-pedit.8 |  8 +++++++-
 tc/m_pedit.c        | 28 ++++++++++++++++++++++------
 tc/m_pedit.h        |  2 ++
 tc/p_ip.c           |  2 +-
 tc/p_ip6.c          |  2 +-
 5 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
index 376ad4a8..2e2662cd 100644
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
+Decrement the addressed data by one.
+This operation is supported only for
+.BR ip " " ttl " and " ip6 " " hoplimit "."
+.TP
 .B preserve
 Keep the addressed data as is.
 .TP
diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index 74c91e8d..9a16ecc8 100644
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
@@ -340,6 +340,9 @@ int parse_cmd(int *argc_p, char ***argv_p, __u32 len, int type, __u32 retain,
 	int res = -1;
 	int argc = *argc_p;
 	char **argv = *argv_p;
+	int flags = type;
+
+	type &= 0xff; /* strip flags */
 
 	if (argc <= 0)
 		return -1;
@@ -360,15 +363,24 @@ int parse_cmd(int *argc_p, char ***argv_p, __u32 len, int type, __u32 retain,
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
+		if ((flags & TFLAG_ALLOW_DEC) == 0) {
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
@@ -431,6 +443,10 @@ done:
 	*argv_p = argv;
 	return res;
 
+non_ext_only_set_cmd:
+	fprintf(stderr,
+		"Non extended mode. only 'set' command is supported\n");
+	return -1;
 }
 
 static int parse_offset(int *argc_p, char ***argv_p, struct m_pedit_sel *sel,
diff --git a/tc/m_pedit.h b/tc/m_pedit.h
index 5d3628a7..ed6bb8da 100644
--- a/tc/m_pedit.h
+++ b/tc/m_pedit.h
@@ -33,6 +33,8 @@
 #define TU32 4
 #define TMAC 5
 
+#define TFLAG_ALLOW_DEC (1<<8)
+
 #define RU32 0xFFFFFFFF
 #define RU16 0xFFFF
 #define RU8 0xFF
diff --git a/tc/p_ip.c b/tc/p_ip.c
index c385ac6d..5c5a94bf 100644
--- a/tc/p_ip.c
+++ b/tc/p_ip.c
@@ -68,7 +68,7 @@ parse_ip(int *argc_p, char ***argv_p,
 	if (strcmp(*argv, "ttl") == 0) {
 		NEXT_ARG();
 		tkey->off = 8;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32 | TFLAG_ALLOW_DEC, RU8, sel, tkey);
 		goto done;
 	}
 	if (strcmp(*argv, "protocol") == 0) {
diff --git a/tc/p_ip6.c b/tc/p_ip6.c
index 83a6ae81..c82b1244 100644
--- a/tc/p_ip6.c
+++ b/tc/p_ip6.c
@@ -71,7 +71,7 @@ parse_ip6(int *argc_p, char ***argv_p,
 	if (strcmp(*argv, "hoplimit") == 0) {
 		NEXT_ARG();
 		tkey->off = 7;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32 | TFLAG_ALLOW_DEC, RU8, sel, tkey);
 		goto done;
 	}
 	if (strcmp(*argv, "traffic_class") == 0) {
-- 
2.32.0

