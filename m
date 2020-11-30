Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02CC2C91EB
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730901AbgK3XDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730834AbgK3XDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:03:11 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99908C0617A7
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:02:23 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4ClLMm2wSjzQlXb;
        Tue,  1 Dec 2020 00:01:56 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1606777314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JkQrbItmoOWRkjiKm/3CKnxyik/biurDVy6i24zBA+A=;
        b=yng7s34zq+GDxo975HD6rTbVTZnhsV43ufLpQ0kmP1ex68Rkmj10LknDWvf++ypiz61gzt
        XXzMf+QCZZM/CmJqJWfJii3jyBMXz6VAl4YGKZHHulMaJPVXiTtdL/KXYx8HWlDmFmfRXy
        S6V3Vc/maRRxRlvP/kfD9DWY9kcW5X22i3LyZnb1WA7gweCWJFlurxLU1YEAVnggH0Z7mZ
        nzN0YlWVD2LN+rxkTB/+ta1f72HdOdEPqTat0WShKfgHvIMxcWrYdOBUNIYRJ4H8fH86G/
        QyiXo0TiRns+12zBKubuu9MoFd3x0q4wEmPEJwz8J3LR5YBaIdoef9YDMTmYiw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id 9o69qkIDmNcu; Tue,  1 Dec 2020 00:01:52 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, vtlam@google.com,
        leon@kernel.org, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 4/6] lib: Move get_rate(), get_rate64() from tc here
Date:   Mon, 30 Nov 2020 23:59:40 +0100
Message-Id: <423298ba47747a9b7153f329c991cb133a7d86ed.1606774951.git.me@pmachata.org>
In-Reply-To: <cover.1606774951.git.me@pmachata.org>
References: <cover.1606774951.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.59 / 15.00 / 15.00
X-Rspamd-Queue-Id: ED1D61863
X-Rspamd-UID: 23be64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions get_rate() and get_rate64() are useful for parsing rate-like
values. The DCB tool will find these useful in the maxrate subtool.
Move them over to lib so that they can be easily reused.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/utils.h |  2 ++
 lib/utils.c     | 79 +++++++++++++++++++++++++++++++++++++++++++++++++
 tc/tc_util.c    | 79 -------------------------------------------------
 tc/tc_util.h    |  2 --
 4 files changed, 81 insertions(+), 81 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 01454f71cb1a..e2073844f2ef 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -162,6 +162,8 @@ int get_be64(__be64 *val, const char *arg, int base);
 int get_be32(__be32 *val, const char *arg, int base);
 int get_be16(__be16 *val, const char *arg, int base);
 int get_addr64(__u64 *ap, const char *cp);
+int get_rate(unsigned int *rate, const char *str);
+int get_rate64(__u64 *rate, const char *str);
 
 int hex2mem(const char *buf, uint8_t *mem, int count);
 char *hexstring_n2a(const __u8 *str, int len, char *buf, int blen);
diff --git a/lib/utils.c b/lib/utils.c
index a0ba5181160e..1237ae40246c 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -513,6 +513,85 @@ int get_addr64(__u64 *ap, const char *cp)
 	return 1;
 }
 
+/* See http://physics.nist.gov/cuu/Units/binary.html */
+static const struct rate_suffix {
+	const char *name;
+	double scale;
+} suffixes[] = {
+	{ "bit",	1. },
+	{ "Kibit",	1024. },
+	{ "kbit",	1000. },
+	{ "mibit",	1024.*1024. },
+	{ "mbit",	1000000. },
+	{ "gibit",	1024.*1024.*1024. },
+	{ "gbit",	1000000000. },
+	{ "tibit",	1024.*1024.*1024.*1024. },
+	{ "tbit",	1000000000000. },
+	{ "Bps",	8. },
+	{ "KiBps",	8.*1024. },
+	{ "KBps",	8000. },
+	{ "MiBps",	8.*1024*1024. },
+	{ "MBps",	8000000. },
+	{ "GiBps",	8.*1024.*1024.*1024. },
+	{ "GBps",	8000000000. },
+	{ "TiBps",	8.*1024.*1024.*1024.*1024. },
+	{ "TBps",	8000000000000. },
+	{ NULL }
+};
+
+int get_rate(unsigned int *rate, const char *str)
+{
+	char *p;
+	double bps = strtod(str, &p);
+	const struct rate_suffix *s;
+
+	if (p == str)
+		return -1;
+
+	for (s = suffixes; s->name; ++s) {
+		if (strcasecmp(s->name, p) == 0) {
+			bps *= s->scale;
+			p += strlen(p);
+			break;
+		}
+	}
+
+	if (*p)
+		return -1; /* unknown suffix */
+
+	bps /= 8; /* -> bytes per second */
+	*rate = bps;
+	/* detect if an overflow happened */
+	if (*rate != floor(bps))
+		return -1;
+	return 0;
+}
+
+int get_rate64(__u64 *rate, const char *str)
+{
+	char *p;
+	double bps = strtod(str, &p);
+	const struct rate_suffix *s;
+
+	if (p == str)
+		return -1;
+
+	for (s = suffixes; s->name; ++s) {
+		if (strcasecmp(s->name, p) == 0) {
+			bps *= s->scale;
+			p += strlen(p);
+			break;
+		}
+	}
+
+	if (*p)
+		return -1; /* unknown suffix */
+
+	bps /= 8; /* -> bytes per second */
+	*rate = bps;
+	return 0;
+}
+
 static void set_address_type(inet_prefix *addr)
 {
 	switch (addr->family) {
diff --git a/tc/tc_util.c b/tc/tc_util.c
index ff979c617b9b..3a133ad84ff9 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -164,32 +164,6 @@ char *sprint_tc_classid(__u32 h, char *buf)
 	return buf;
 }
 
-/* See http://physics.nist.gov/cuu/Units/binary.html */
-static const struct rate_suffix {
-	const char *name;
-	double scale;
-} suffixes[] = {
-	{ "bit",	1. },
-	{ "Kibit",	1024. },
-	{ "kbit",	1000. },
-	{ "mibit",	1024.*1024. },
-	{ "mbit",	1000000. },
-	{ "gibit",	1024.*1024.*1024. },
-	{ "gbit",	1000000000. },
-	{ "tibit",	1024.*1024.*1024.*1024. },
-	{ "tbit",	1000000000000. },
-	{ "Bps",	8. },
-	{ "KiBps",	8.*1024. },
-	{ "KBps",	8000. },
-	{ "MiBps",	8.*1024*1024. },
-	{ "MBps",	8000000. },
-	{ "GiBps",	8.*1024.*1024.*1024. },
-	{ "GBps",	8000000000. },
-	{ "TiBps",	8.*1024.*1024.*1024.*1024. },
-	{ "TBps",	8000000000000. },
-	{ NULL }
-};
-
 /* Parse a percent e.g: '30%'
  * return: 0 = ok, -1 = error, 1 = out of range
  */
@@ -273,59 +247,6 @@ int get_percent_rate64(__u64 *rate, const char *str, const char *dev)
 	return get_rate64(rate, r_str);
 }
 
-int get_rate(unsigned int *rate, const char *str)
-{
-	char *p;
-	double bps = strtod(str, &p);
-	const struct rate_suffix *s;
-
-	if (p == str)
-		return -1;
-
-	for (s = suffixes; s->name; ++s) {
-		if (strcasecmp(s->name, p) == 0) {
-			bps *= s->scale;
-			p += strlen(p);
-			break;
-		}
-	}
-
-	if (*p)
-		return -1; /* unknown suffix */
-
-	bps /= 8; /* -> bytes per second */
-	*rate = bps;
-	/* detect if an overflow happened */
-	if (*rate != floor(bps))
-		return -1;
-	return 0;
-}
-
-int get_rate64(__u64 *rate, const char *str)
-{
-	char *p;
-	double bps = strtod(str, &p);
-	const struct rate_suffix *s;
-
-	if (p == str)
-		return -1;
-
-	for (s = suffixes; s->name; ++s) {
-		if (strcasecmp(s->name, p) == 0) {
-			bps *= s->scale;
-			p += strlen(p);
-			break;
-		}
-	}
-
-	if (*p)
-		return -1; /* unknown suffix */
-
-	bps /= 8; /* -> bytes per second */
-	*rate = bps;
-	return 0;
-}
-
 void tc_print_rate(enum output_type t, const char *key, const char *fmt,
 		   unsigned long long rate)
 {
diff --git a/tc/tc_util.h b/tc/tc_util.h
index d3b38c69155d..675fb34269f6 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -76,9 +76,7 @@ struct qdisc_util *get_qdisc_kind(const char *str);
 struct filter_util *get_filter_kind(const char *str);
 
 int get_qdisc_handle(__u32 *h, const char *str);
-int get_rate(unsigned int *rate, const char *str);
 int get_percent_rate(unsigned int *rate, const char *str, const char *dev);
-int get_rate64(__u64 *rate, const char *str);
 int get_percent_rate64(__u64 *rate, const char *str, const char *dev);
 int get_size(unsigned int *size, const char *str);
 int get_size_and_cell(unsigned int *size, int *cell_log, char *str);
-- 
2.25.1

