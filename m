Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925462C91E7
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbgK3XCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgK3XCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:02:40 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D5CC0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:01:59 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4ClLMn1vzqzQlMn;
        Tue,  1 Dec 2020 00:01:57 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1606777315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yMCNDlNXt76MMhsD27mpaT7LDmRyi7eSltJuKYOFOU4=;
        b=lTNJTfVuHPlZ1VlrDx6J6QcACLCN/ySufKzJqz5XchiMO43cIwsqfu0ZLwy51kVIGgXO4a
        nPXrxiJDFs7utxgelB+NAbUeOptS+L0o4BEO6gy/EehVAC2pW5yTiB2HRjLK9JL0kscrQg
        50kTCJ+MqlJSdQR5iFn2DJM1wv6vHYlWzrHx7SHUkYjWAyV4I9SLmQpWHq4+lDi5o+IUKW
        +hRS8KUGWjzIyp+sstDaIb6xNMW2mFlEv/nc6XGo3M+Jrt4em6u4JaFOCGsXYig2G9tkaQ
        fbuOODZxx5TI1VuRBLH89LFqQN6Vu6xryyoijOnd/ynlZIPx+SLKLMzgJ57C0Q==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id pjSTuFIHtNbR; Tue,  1 Dec 2020 00:01:54 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, vtlam@google.com,
        leon@kernel.org, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 5/6] lib: Move get_size() from tc here
Date:   Mon, 30 Nov 2020 23:59:41 +0100
Message-Id: <43c276eedd5a308a29cb49320ceade2d5d227381.1606774951.git.me@pmachata.org>
In-Reply-To: <cover.1606774951.git.me@pmachata.org>
References: <cover.1606774951.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.64 / 15.00 / 15.00
X-Rspamd-Queue-Id: 3CC721873
X-Rspamd-UID: a36186
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function get_size() serves for parsing of sizes using a handly notation
that supports units and their prefixes, such as 10Kbit. This will be useful
for the DCB buffer size parsing. Move the function from TC to the general
library, so that it can be reused.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/utils.h |  1 +
 lib/utils.c     | 35 +++++++++++++++++++++++++++++++++++
 tc/tc_util.c    | 35 -----------------------------------
 tc/tc_util.h    |  1 -
 4 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index e2073844f2ef..1704392525a2 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -164,6 +164,7 @@ int get_be16(__be16 *val, const char *arg, int base);
 int get_addr64(__u64 *ap, const char *cp);
 int get_rate(unsigned int *rate, const char *str);
 int get_rate64(__u64 *rate, const char *str);
+int get_size(unsigned int *size, const char *str);
 
 int hex2mem(const char *buf, uint8_t *mem, int count);
 char *hexstring_n2a(const __u8 *str, int len, char *buf, int blen);
diff --git a/lib/utils.c b/lib/utils.c
index 1237ae40246c..de875639c608 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -592,6 +592,41 @@ int get_rate64(__u64 *rate, const char *str)
 	return 0;
 }
 
+int get_size(unsigned int *size, const char *str)
+{
+	double sz;
+	char *p;
+
+	sz = strtod(str, &p);
+	if (p == str)
+		return -1;
+
+	if (*p) {
+		if (strcasecmp(p, "kb") == 0 || strcasecmp(p, "k") == 0)
+			sz *= 1024;
+		else if (strcasecmp(p, "gb") == 0 || strcasecmp(p, "g") == 0)
+			sz *= 1024*1024*1024;
+		else if (strcasecmp(p, "gbit") == 0)
+			sz *= 1024*1024*1024/8;
+		else if (strcasecmp(p, "mb") == 0 || strcasecmp(p, "m") == 0)
+			sz *= 1024*1024;
+		else if (strcasecmp(p, "mbit") == 0)
+			sz *= 1024*1024/8;
+		else if (strcasecmp(p, "kbit") == 0)
+			sz *= 1024/8;
+		else if (strcasecmp(p, "b") != 0)
+			return -1;
+	}
+
+	*size = sz;
+
+	/* detect if an overflow happened */
+	if (*size != floor(sz))
+		return -1;
+
+	return 0;
+}
+
 static void set_address_type(inet_prefix *addr)
 {
 	switch (addr->family) {
diff --git a/tc/tc_util.c b/tc/tc_util.c
index 3a133ad84ff9..48065897cee7 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -258,41 +258,6 @@ char *sprint_ticks(__u32 ticks, char *buf)
 	return sprint_time(tc_core_tick2time(ticks), buf);
 }
 
-int get_size(unsigned int *size, const char *str)
-{
-	double sz;
-	char *p;
-
-	sz = strtod(str, &p);
-	if (p == str)
-		return -1;
-
-	if (*p) {
-		if (strcasecmp(p, "kb") == 0 || strcasecmp(p, "k") == 0)
-			sz *= 1024;
-		else if (strcasecmp(p, "gb") == 0 || strcasecmp(p, "g") == 0)
-			sz *= 1024*1024*1024;
-		else if (strcasecmp(p, "gbit") == 0)
-			sz *= 1024*1024*1024/8;
-		else if (strcasecmp(p, "mb") == 0 || strcasecmp(p, "m") == 0)
-			sz *= 1024*1024;
-		else if (strcasecmp(p, "mbit") == 0)
-			sz *= 1024*1024/8;
-		else if (strcasecmp(p, "kbit") == 0)
-			sz *= 1024/8;
-		else if (strcasecmp(p, "b") != 0)
-			return -1;
-	}
-
-	*size = sz;
-
-	/* detect if an overflow happened */
-	if (*size != floor(sz))
-		return -1;
-
-	return 0;
-}
-
 int get_size_and_cell(unsigned int *size, int *cell_log, char *str)
 {
 	char *slash = strchr(str, '/');
diff --git a/tc/tc_util.h b/tc/tc_util.h
index 675fb34269f6..b197bcdd7b80 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -78,7 +78,6 @@ struct filter_util *get_filter_kind(const char *str);
 int get_qdisc_handle(__u32 *h, const char *str);
 int get_percent_rate(unsigned int *rate, const char *str, const char *dev);
 int get_percent_rate64(__u64 *rate, const char *str, const char *dev);
-int get_size(unsigned int *size, const char *str);
 int get_size_and_cell(unsigned int *size, int *cell_log, char *str);
 int get_linklayer(unsigned int *val, const char *arg);
 
-- 
2.25.1

