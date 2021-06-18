Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F383AD00C
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhFRQKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:10:55 -0400
Received: from mail.asbjorn.biz ([185.38.24.25]:44116 "EHLO mail.asbjorn.biz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232877AbhFRQKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 12:10:52 -0400
Received: from x201s (space.labitat.dk [185.38.175.0])
        by mail.asbjorn.biz (Postfix) with ESMTPSA id EA6521C29733;
        Fri, 18 Jun 2021 16:08:38 +0000 (UTC)
Received: by x201s (Postfix, from userid 1000)
        id DFFE8205104; Fri, 18 Jun 2021 16:07:03 +0000 (UTC)
From:   =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= 
        <asbjorn@asbjorn.st>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= 
        <asbjorn@asbjorn.st>, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 1/2] tc: pedit: parse_cmd: add flags argument
Date:   Fri, 18 Jun 2021 16:06:34 +0000
Message-Id: <20210618160635.703845-1-asbjorn@asbjorn.st>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch just prepares the flags argument, so it's
available to the next patch.

Signed-off-by: Asbjørn Sloth Tønnesen <asbjorn@asbjorn.st>
---
 tc/m_pedit.c |  4 ++--
 tc/m_pedit.h |  2 +-
 tc/p_eth.c   |  6 +++---
 tc/p_ip.c    | 32 ++++++++++++++++----------------
 tc/p_ip6.c   | 14 +++++++-------
 tc/p_tcp.c   |  6 +++---
 tc/p_udp.c   |  4 ++--
 7 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index 74c91e8d..b745c379 100644
--- a/tc/m_pedit.c
+++ b/tc/m_pedit.c
@@ -330,7 +330,7 @@ static int parse_val(int *argc_p, char ***argv_p, __u32 *val, int type)
 }
 
 int parse_cmd(int *argc_p, char ***argv_p, __u32 len, int type, __u32 retain,
-	      struct m_pedit_sel *sel, struct m_pedit_key *tkey)
+	      struct m_pedit_sel *sel, struct m_pedit_key *tkey, int flags)
 {
 	__u32 mask[4] = { 0 };
 	__u32 val[4] = { 0 };
@@ -502,7 +502,7 @@ done:
 		NEXT_ARG();
 	}
 
-	res = parse_cmd(&argc, &argv, len, TU32, retain, sel, tkey);
+	res = parse_cmd(&argc, &argv, len, TU32, retain, sel, tkey, 0);
 
 	*argc_p = argc;
 	*argv_p = argv;
diff --git a/tc/m_pedit.h b/tc/m_pedit.h
index 5d3628a7..7398f66d 100644
--- a/tc/m_pedit.h
+++ b/tc/m_pedit.h
@@ -73,5 +73,5 @@ struct m_pedit_util {
 
 int parse_cmd(int *argc_p, char ***argv_p, __u32 len, int type,
 	      __u32 retain,
-	      struct m_pedit_sel *sel, struct m_pedit_key *tkey);
+	      struct m_pedit_sel *sel, struct m_pedit_key *tkey, int flags);
 #endif
diff --git a/tc/p_eth.c b/tc/p_eth.c
index 674f9c11..7b6b61f8 100644
--- a/tc/p_eth.c
+++ b/tc/p_eth.c
@@ -41,21 +41,21 @@ parse_eth(int *argc_p, char ***argv_p,
 	if (strcmp(*argv, "type") == 0) {
 		NEXT_ARG();
 		tkey->off = 12;
-		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey);
+		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey, 0);
 		goto done;
 	}
 
 	if (strcmp(*argv, "dst") == 0) {
 		NEXT_ARG();
 		tkey->off = 0;
-		res = parse_cmd(&argc, &argv, 6, TMAC, RU32, sel, tkey);
+		res = parse_cmd(&argc, &argv, 6, TMAC, RU32, sel, tkey, 0);
 		goto done;
 	}
 
 	if (strcmp(*argv, "src") == 0) {
 		NEXT_ARG();
 		tkey->off = 6;
-		res = parse_cmd(&argc, &argv, 6, TMAC, RU32, sel, tkey);
+		res = parse_cmd(&argc, &argv, 6, TMAC, RU32, sel, tkey, 0);
 		goto done;
 	}
 
diff --git a/tc/p_ip.c b/tc/p_ip.c
index c385ac6d..2d1643d0 100644
--- a/tc/p_ip.c
+++ b/tc/p_ip.c
@@ -40,13 +40,13 @@ parse_ip(int *argc_p, char ***argv_p,
 	if (strcmp(*argv, "src") == 0) {
 		NEXT_ARG();
 		tkey->off = 12;
-		res = parse_cmd(&argc, &argv, 4, TIPV4, RU32, sel, tkey);
+		res = parse_cmd(&argc, &argv, 4, TIPV4, RU32, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "dst") == 0) {
 		NEXT_ARG();
 		tkey->off = 16;
-		res = parse_cmd(&argc, &argv, 4, TIPV4, RU32, sel, tkey);
+		res = parse_cmd(&argc, &argv, 4, TIPV4, RU32, sel, tkey, 0);
 		goto done;
 	}
 	/* jamal - look at these and make them either old or new
@@ -56,64 +56,64 @@ parse_ip(int *argc_p, char ***argv_p,
 	if (strcmp(*argv, "tos") == 0 || matches(*argv, "dsfield") == 0) {
 		NEXT_ARG();
 		tkey->off = 1;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "ihl") == 0) {
 		NEXT_ARG();
 		tkey->off = 0;
-		res = parse_cmd(&argc, &argv, 1, TU32, 0x0f, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, 0x0f, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "ttl") == 0) {
 		NEXT_ARG();
 		tkey->off = 8;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "protocol") == 0) {
 		NEXT_ARG();
 		tkey->off = 9;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
 		goto done;
 	}
 	/* jamal - fix this */
 	if (matches(*argv, "precedence") == 0) {
 		NEXT_ARG();
 		tkey->off = 1;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
 		goto done;
 	}
 	/* jamal - validate this at some point */
 	if (strcmp(*argv, "nofrag") == 0) {
 		NEXT_ARG();
 		tkey->off = 6;
-		res = parse_cmd(&argc, &argv, 1, TU32, 0x3F, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, 0x3F, sel, tkey, 0);
 		goto done;
 	}
 	/* jamal - validate this at some point */
 	if (strcmp(*argv, "firstfrag") == 0) {
 		NEXT_ARG();
 		tkey->off = 6;
-		res = parse_cmd(&argc, &argv, 1, TU32, 0x1F, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, 0x1F, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "ce") == 0) {
 		NEXT_ARG();
 		tkey->off = 6;
-		res = parse_cmd(&argc, &argv, 1, TU32, 0x80, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, 0x80, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "df") == 0) {
 		NEXT_ARG();
 		tkey->off = 6;
-		res = parse_cmd(&argc, &argv, 1, TU32, 0x40, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, 0x40, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "mf") == 0) {
 		NEXT_ARG();
 		tkey->off = 6;
-		res = parse_cmd(&argc, &argv, 1, TU32, 0x20, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, 0x20, sel, tkey, 0);
 		goto done;
 	}
 
@@ -126,25 +126,25 @@ parse_ip(int *argc_p, char ***argv_p,
 	if (strcmp(*argv, "dport") == 0) {
 		NEXT_ARG();
 		tkey->off = 22;
-		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey);
+		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "sport") == 0) {
 		NEXT_ARG();
 		tkey->off = 20;
-		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey);
+		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "icmp_type") == 0) {
 		NEXT_ARG();
 		tkey->off = 20;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "icmp_code") == 0) {
 		NEXT_ARG();
 		tkey->off = 20;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
 		goto done;
 	}
 	return -1;
diff --git a/tc/p_ip6.c b/tc/p_ip6.c
index 83a6ae81..f9d5d3b0 100644
--- a/tc/p_ip6.c
+++ b/tc/p_ip6.c
@@ -41,43 +41,43 @@ parse_ip6(int *argc_p, char ***argv_p,
 	if (strcmp(*argv, "src") == 0) {
 		NEXT_ARG();
 		tkey->off = 8;
-		res = parse_cmd(&argc, &argv, 16, TIPV6, RU32, sel, tkey);
+		res = parse_cmd(&argc, &argv, 16, TIPV6, RU32, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "dst") == 0) {
 		NEXT_ARG();
 		tkey->off = 24;
-		res = parse_cmd(&argc, &argv, 16, TIPV6, RU32, sel, tkey);
+		res = parse_cmd(&argc, &argv, 16, TIPV6, RU32, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "flow_lbl") == 0) {
 		NEXT_ARG();
 		tkey->off = 0;
-		res = parse_cmd(&argc, &argv, 4, TU32, 0x0007ffff, sel, tkey);
+		res = parse_cmd(&argc, &argv, 4, TU32, 0x0007ffff, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "payload_len") == 0) {
 		NEXT_ARG();
 		tkey->off = 4;
-		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey);
+		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "nexthdr") == 0) {
 		NEXT_ARG();
 		tkey->off = 6;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "hoplimit") == 0) {
 		NEXT_ARG();
 		tkey->off = 7;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
 		goto done;
 	}
 	if (strcmp(*argv, "traffic_class") == 0) {
 		NEXT_ARG();
 		tkey->off = 1;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
 
 		/* Shift the field by 4 bits on success. */
 		if (!res) {
diff --git a/tc/p_tcp.c b/tc/p_tcp.c
index d2dbfd71..ec7b08a2 100644
--- a/tc/p_tcp.c
+++ b/tc/p_tcp.c
@@ -41,21 +41,21 @@ parse_tcp(int *argc_p, char ***argv_p,
 	if (strcmp(*argv, "sport") == 0) {
 		NEXT_ARG();
 		tkey->off = 0;
-		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey);
+		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey, 0);
 		goto done;
 	}
 
 	if (strcmp(*argv, "dport") == 0) {
 		NEXT_ARG();
 		tkey->off = 2;
-		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey);
+		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey, 0);
 		goto done;
 	}
 
 	if (strcmp(*argv, "flags") == 0) {
 		NEXT_ARG();
 		tkey->off = 13;
-		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
 		goto done;
 	}
 
diff --git a/tc/p_udp.c b/tc/p_udp.c
index bab456de..742955e6 100644
--- a/tc/p_udp.c
+++ b/tc/p_udp.c
@@ -41,14 +41,14 @@ parse_udp(int *argc_p, char ***argv_p,
 	if (strcmp(*argv, "sport") == 0) {
 		NEXT_ARG();
 		tkey->off = 0;
-		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey);
+		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey, 0);
 		goto done;
 	}
 
 	if (strcmp(*argv, "dport") == 0) {
 		NEXT_ARG();
 		tkey->off = 2;
-		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey);
+		res = parse_cmd(&argc, &argv, 2, TU32, RU16, sel, tkey, 0);
 		goto done;
 	}
 
-- 
2.32.0

