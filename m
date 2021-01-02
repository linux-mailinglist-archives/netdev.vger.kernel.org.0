Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031452E85F5
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 01:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbhABAFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 19:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbhABAE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jan 2021 19:04:58 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F066C06179E
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 16:04:18 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4D72Dw5HVgzQlRV;
        Sat,  2 Jan 2021 01:04:16 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609545854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l7r0rVTfhjlN5k0G+AiGDyIsJ/r+ttbZqoOcy4lOBlc=;
        b=hZrh+mDjrzF7J3OCXEUTOV/XFTCgPF3h9gLQuTnHbxILcO5VR89qAK5vKg7mcN7qmjlUNt
        FEJAfpf5P1y6KRrbJVj+uNkuXq1sGpGKSM/6FjqVXjrKJo7vjTW+nD535YTMbfwKXGRqCU
        ZJtkbiQADTXzbv4WurSPgGOZZ/IlCZ25WpM9mV5J8lOX7wmg4OvJb4ebXocBtzA+xREXCM
        sCKvl18hG+NYg4Y1wQ2jJsxOhZnBRepVNTWMUr9CUQ8wXxNULGyHvUmkKA4Rr2pR4swtQb
        AWFZ4LgOcDKGz6oBDbVJxC9odXKcGB1+YoQRfkhX+gdJgLPMKdlUQ/dcN8jnxg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id XCWCCVMtUfyY; Sat,  2 Jan 2021 01:04:10 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 5/7] dcb: Support -N to suppress translation to human-readable names
Date:   Sat,  2 Jan 2021 01:03:39 +0100
Message-Id: <a13a33ef1e4d38a3175187ae8c284238dc37ff11.1609544200.git.me@pmachata.org>
In-Reply-To: <cover.1609544200.git.me@pmachata.org>
References: <cover.1609544200.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.23 / 15.00 / 15.00
X-Rspamd-Queue-Id: BC4F8171E
X-Rspamd-UID: b49fba
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some DSCP values can be translated to symbolic names. That may not be
always desirable. Introduce a command-line option similar to other tools,
-N or --Numeric, to suppress this translation.

Signed-off-by: Petr Machata <me@pmachata.org>
---

Notes:
    v2:
    - Make it -N / --Numeric instead of -n / --no-nice-names
    - Rename the flag from no_nice_names to numeric as well

 dcb/dcb.c      | 9 +++++++--
 dcb/dcb.h      | 1 +
 man/man8/dcb.8 | 5 +++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 89f9b0ec7ef9..cc5103da84a8 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -467,7 +467,8 @@ static void dcb_help(void)
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -n | --netns ] netnsname\n"
 		"where  OBJECT := { buffer | ets | maxrate | pfc }\n"
 		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
-		"                  | -p | --pretty | -s | --statistics | -v | --verbose]\n");
+		"                  | -N | --Numeric | -p | --pretty\n"
+		"                  | -s | --statistics | -v | --verbose]\n");
 }
 
 static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
@@ -509,6 +510,7 @@ int main(int argc, char **argv)
 		{ "batch",		required_argument,	NULL, 'b' },
 		{ "iec",		no_argument,		NULL, 'i' },
 		{ "json",		no_argument,		NULL, 'j' },
+		{ "Numeric",		no_argument,		NULL, 'N' },
 		{ "pretty",		no_argument,		NULL, 'p' },
 		{ "statistics",		no_argument,		NULL, 's' },
 		{ "netns",		required_argument,	NULL, 'n' },
@@ -528,7 +530,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "b:fhijn:psvV",
+	while ((opt = getopt_long(argc, argv, "b:fhijn:psvNV",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -545,6 +547,9 @@ int main(int argc, char **argv)
 		case 'j':
 			dcb->json_output = true;
 			break;
+		case 'N':
+			dcb->numeric = true;
+			break;
 		case 'p':
 			pretty = true;
 			break;
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 8c7327a43588..37657c594a78 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -14,6 +14,7 @@ struct dcb {
 	bool json_output;
 	bool stats;
 	bool use_iec;
+	bool numeric;
 };
 
 int dcb_parse_mapping(const char *what_key, __u32 key, __u32 max_key,
diff --git a/man/man8/dcb.8 b/man/man8/dcb.8
index 7293bb303577..1e161eb37a58 100644
--- a/man/man8/dcb.8
+++ b/man/man8/dcb.8
@@ -59,6 +59,11 @@ the 1000-based ones (K, M, B).
 .BR "\-j" , " --json"
 Generate JSON output.
 
+.TP
+.BR "\-N" , " --Numeric"
+If the subtool in question translates numbers to symbolic names in some way,
+suppress this translation.
+
 .TP
 .BR "\-p" , " --pretty"
 When combined with -j generate a pretty JSON output.
-- 
2.26.2

