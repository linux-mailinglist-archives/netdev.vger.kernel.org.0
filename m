Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AA52E2069
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgLWS1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgLWS1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:27:05 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73490C061285
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 10:26:25 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4D1M9C6TW9zQlY6;
        Wed, 23 Dec 2020 19:26:23 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1608747982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FT/F710CXdWDjbwe5n/nQYOzCKMrqCurqekM4oEi5ao=;
        b=dp+lhDz7WjjsBX9A8igPp+LTA1O3jJd73cBqYuv7G+MxNqvvomcEJXN2zqReRJ0VNRS/BZ
        q+JIeFkK590XMt/FOUbp0BTjpJiKuInXIEdKIkVYbjIcLk8P9SdBsJVYHjEDYSg+T+GfsL
        hjq5hTJ6bH9hSYyCr4ZxTnkI7wzuYYsKm5UphpTePDpKNcbwEnM15pu1eY9hPd4Jku/I9Q
        4lIpl7gmgFcKfkDxDxKadc9dOE+JHRAssvmwjvQFeZYfAX1DK2dKCWOFyF7FrfndS7Dqz2
        AEKXTFY2fdTk45yU1dLJoL+HESB3bKy8cOaQmC2He/UJtbdGoWMikP1u4/nJ2A==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id fqK1Kc4VJ1eg; Wed, 23 Dec 2020 19:26:20 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 7/9] dcb: Support -n to suppress translation to nice names
Date:   Wed, 23 Dec 2020 19:25:45 +0100
Message-Id: <9a23b6698bd8f223f7789149e8196712d5d624ae.1608746691.git.me@pmachata.org>
In-Reply-To: <cover.1608746691.git.me@pmachata.org>
References: <cover.1608746691.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.49 / 15.00 / 15.00
X-Rspamd-Queue-Id: D457117DF
X-Rspamd-UID: d42362
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some DSCP values can be translated to symbolic names. That may not be
always desirable. Introduce a command-line option similar to other
tools, -n or --no-nice-names, to suppress this translation.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/dcb.c      | 9 +++++++--
 dcb/dcb.h      | 1 +
 man/man8/dcb.8 | 5 +++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index a59b63ac9159..e6cda7337924 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -467,7 +467,8 @@ static void dcb_help(void)
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
 		"where  OBJECT := { buffer | ets | maxrate | pfc }\n"
 		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
-		"                  | -p | --pretty | -s | --statistics | -v | --verbose]\n");
+		"                  | -n | --no-nice-names | -p | --pretty\n"
+		"                  | -s | --statistics | -v | --verbose]\n");
 }
 
 static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
@@ -509,6 +510,7 @@ int main(int argc, char **argv)
 		{ "batch",		required_argument,	NULL, 'b' },
 		{ "iec",		no_argument,		NULL, 'i' },
 		{ "json",		no_argument,		NULL, 'j' },
+		{ "no-nice-names",	no_argument,		NULL, 'n' },
 		{ "pretty",		no_argument,		NULL, 'p' },
 		{ "statistics",		no_argument,		NULL, 's' },
 		{ "Netns",		required_argument,	NULL, 'N' },
@@ -528,7 +530,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "b:fhijpsvN:V",
+	while ((opt = getopt_long(argc, argv, "b:fhijnpsvN:V",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -545,6 +547,9 @@ int main(int argc, char **argv)
 		case 'j':
 			dcb->json_output = true;
 			break;
+		case 'n':
+			dcb->no_nice_names = true;
+			break;
 		case 'p':
 			pretty = true;
 			break;
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 8c7327a43588..f1d089257867 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -14,6 +14,7 @@ struct dcb {
 	bool json_output;
 	bool stats;
 	bool use_iec;
+	bool no_nice_names;
 };
 
 int dcb_parse_mapping(const char *what_key, __u32 key, __u32 max_key,
diff --git a/man/man8/dcb.8 b/man/man8/dcb.8
index 5964f25d386d..46c7a31410b7 100644
--- a/man/man8/dcb.8
+++ b/man/man8/dcb.8
@@ -52,6 +52,11 @@ the 1000-based ones (K, M, B).
 .BR "\-j" , " --json"
 Generate JSON output.
 
+.TP
+.BR "\-n" , " --no-nice-names"
+If the subtool in question translates numbers to symbolic names in some way,
+suppress this translation.
+
 .TP
 .BR "\-p" , " --pretty"
 When combined with -j generate a pretty JSON output.
-- 
2.25.1

