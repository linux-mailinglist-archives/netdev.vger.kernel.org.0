Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5923A70A7
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbhFNUpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:45:04 -0400
Received: from mail.asbjorn.biz ([185.38.24.25]:49359 "EHLO mail.asbjorn.biz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234933AbhFNUpD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:45:03 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2021 16:45:02 EDT
Received: from x201s (space.labitat.dk [185.38.175.0])
        by mail.asbjorn.biz (Postfix) with ESMTPSA id E8C581C29733;
        Mon, 14 Jun 2021 20:36:29 +0000 (UTC)
Received: by x201s (Postfix, from userid 1000)
        id 834A1201BAA; Mon, 14 Jun 2021 20:34:20 +0000 (UTC)
From:   =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= 
        <asbjorn@asbjorn.st>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= 
        <asbjorn@asbjorn.st>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2] tc: pedit: add decrement operation
Date:   Mon, 14 Jun 2021 20:33:24 +0000
Message-Id: <20210614203324.236756-1-asbjorn@asbjorn.st>
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
 tc/m_pedit.c        | 27 ++++++++++++++++++++++-----
 tc/m_pedit.h        |  2 ++
 tc/p_ip.c           |  2 +-
 tc/p_ip6.c          |  2 +-
 5 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
index 376ad4a8..2e2662cd 100644
--- a/man/man8/tc-pedit.8
+++ b/man/man8/tc-pedit.8
@@ -76,8 +76,9 @@ pedit - generic packet editor action
 .BR clear " | " invert " | " set
 .IR VAL " | "
 .BR add
 .IR VAL " | "
+.BR decrement " | "
 .BR preserve " } [ " retain
 .IR RVAL " ]"
 
 .ti -8
@@ -95,9 +96,9 @@ chosen automatically based on the header field size.
 .TP
 .B ex
 Use extended pedit.
 .I EXTENDED_LAYERED_OP
-and the add
+and the add/decrement
 .I CMD_SPEC
 are allowed only in this mode.
 .TP
 .BI offset " OFFSET " "\fR{ \fBu32 \fR| \fBu16 \fR| \fBu8 \fR}"
@@ -287,8 +288,13 @@ Add the addressed data by a specific value. The size of
 is defined by the size of the addressed header field in
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
 .BI retain " RVAL"
diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index 74c91e8d..9ac52336 100644
--- a/tc/m_pedit.c
+++ b/tc/m_pedit.c
@@ -339,8 +339,11 @@ int parse_cmd(int *argc_p, char ***argv_p, __u32 len, int type, __u32 retain,
 	__u32 o = 0xFF;
 	int res = -1;
 	int argc = *argc_p;
 	char **argv = *argv_p;
+	int flags = type;
+
+	type &= 0xff; /* strip flags */
 
 	if (argc <= 0)
 		return -1;
 
@@ -359,17 +362,26 @@ int parse_cmd(int *argc_p, char ***argv_p, __u32 len, int type, __u32 retain,
 		   matches(*argv, "add") == 0) {
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
 		if (matches(*argv, "clear") != 0)
@@ -422,16 +434,21 @@ int parse_cmd(int *argc_p, char ***argv_p, __u32 len, int type, __u32 retain,
 		goto done;
 	}
 
 	return -1;
+
 done:
 	if (pedit_debug)
 		printf("parse_cmd done argc %d %s offset %d length %d\n",
 		       argc, *argv, tkey->off, len);
 	*argc_p = argc;
 	*argv_p = argv;
 	return res;
 
+non_ext_only_set_cmd:
+	fprintf(stderr,
+		"Non extended mode. only 'set' command is supported\n");
+	return -1;
 }
 
 static int parse_offset(int *argc_p, char ***argv_p, struct m_pedit_sel *sel,
 			struct m_pedit_key *tkey)
diff --git a/tc/m_pedit.h b/tc/m_pedit.h
index 5d3628a7..ed6bb8da 100644
--- a/tc/m_pedit.h
+++ b/tc/m_pedit.h
@@ -32,8 +32,10 @@
 #define TINT 3
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
@@ -67,9 +67,9 @@ parse_ip(int *argc_p, char ***argv_p,
 	}
 	if (strcmp(*argv, "ttl") == 0) {
 		NEXT_ARG();
 		tkey->off = 8;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32 | TFLAG_ALLOW_DEC, RU8, sel, tkey);
 		goto done;
 	}
 	if (strcmp(*argv, "protocol") == 0) {
 		NEXT_ARG();
diff --git a/tc/p_ip6.c b/tc/p_ip6.c
index 83a6ae81..c82b1244 100644
--- a/tc/p_ip6.c
+++ b/tc/p_ip6.c
@@ -70,9 +70,9 @@ parse_ip6(int *argc_p, char ***argv_p,
 	}
 	if (strcmp(*argv, "hoplimit") == 0) {
 		NEXT_ARG();
 		tkey->off = 7;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32 | TFLAG_ALLOW_DEC, RU8, sel, tkey);
 		goto done;
 	}
 	if (strcmp(*argv, "traffic_class") == 0) {
 		NEXT_ARG();
-- 
2.32.0

