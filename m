Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA10E2CFF23
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgLEVPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbgLEVPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 16:15:47 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D383C061A54
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 13:14:53 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CpMlQ5MtRzQlF7;
        Sat,  5 Dec 2020 22:14:26 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607202864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yMCNDlNXt76MMhsD27mpaT7LDmRyi7eSltJuKYOFOU4=;
        b=ioeDe0yrKuUR2wZn9ZJ/M9cd6mktmt8x8vRH4G+sudvI6HaO+s+Wu7+aRIrPJI59wyBpTu
        hraetD+aC68FgGExnDiXwvnaOGwHBgrN2psxT/ZbmbA2rr2V/vV9fysY5cZoU9JvawVnbr
        PdXR6VFddeYkbRHrgMNRuv17iCuleg/nYECLONzBb6rOK/r4NOS0xD8puO4kcTn2pWFgMm
        q1TkoCW2TU1OJmd2f/mq8qTkOUC/sUN0ZJJ60SlMOkVRxrgPjT/C9cDWzQsgLxwOXhmsEX
        rfoLppU+gDKuMJkrmSA1jdh3GEKQbcRXmnWIJj0Cq6LUgsXEI59kb9QhS+c4yw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id xuOyHn-UllG7; Sat,  5 Dec 2020 22:14:23 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, leon@kernel.org,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 7/7] lib: Move get_size() from tc here
Date:   Sat,  5 Dec 2020 22:13:35 +0100
Message-Id: <a9c329b19046144dbe06359d8aaeab8db84b9f41.1607201857.git.me@pmachata.org>
In-Reply-To: <cover.1607201857.git.me@pmachata.org>
References: <cover.1607201857.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 2.10 / 15.00 / 15.00
X-Rspamd-Queue-Id: 9F7EA17A9
X-Rspamd-UID: 4518e7
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

