Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C15D2D6B85
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389091AbgLJXEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbgLJXED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:04:03 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C07C0611CD
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:03:23 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CsTwJ1RXzzQlXM;
        Fri, 11 Dec 2020 00:02:56 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607641374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8wot+aWIl0JNcS5G8bJr2c+d5hyHu62ImVpKafa4ygs=;
        b=EiEGay+PxCEziX7YBShCakHf8cHfejanQ2vx6qa9fJNBUlBlCg4scKeQUjrDj/2J70PKEd
        VrB4KMKc47Ughcj+nw3uj1TNCNt8i5RptugQpd0bYexrzMFH+Q6w9jqPkVHnFejHgFwgei
        /GlzIURD2f4SQSpFy4l+7/b47mToxO+sUn1QjMf9u43rr47Cdg8dvR2BF0V8ccoFzgNs6F
        r9+SnI2p2MH+XrrURiqHAC1eCXjjRCGSA65LwsRgJVaat9vm/VUQLnAcl7cp1LkMBmlMiw
        F0N/DOo9WGU2Yzh+/o2NQkRZ6ItETiK5J+l43NzH+I5Gc7Bi1f29w2SQNAXaVg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id B5TJ6DPkPiXe; Fri, 11 Dec 2020 00:02:53 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 06/10] dcb: Add -s to enable statistics
Date:   Fri, 11 Dec 2020 00:02:20 +0100
Message-Id: <5e766bd1ebd9f622c1f59646c06490ab6c5f023d.1607640819.git.me@pmachata.org>
In-Reply-To: <cover.1607640819.git.me@pmachata.org>
References: <cover.1607640819.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.12 / 15.00 / 15.00
X-Rspamd-Queue-Id: 3C35017C2
X-Rspamd-UID: 9a0b07
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow selective display of statistical counters by passing -s.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/dcb.c      | 9 +++++++--
 dcb/dcb.h      | 1 +
 man/man8/dcb.8 | 5 +++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 7c0beee43686..9332a8b2e3d4 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -310,7 +310,8 @@ static void dcb_help(void)
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
 		"where  OBJECT := ets\n"
-		"       OPTIONS := [ -V | --Version | -j | --json | -p | --pretty | -v | --verbose ]\n");
+		"       OPTIONS := [ -V | --Version | -j | --json | -p | --pretty\n"
+		"                  | -s | --statistics | -v | --verbose ]\n");
 }
 
 static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
@@ -346,6 +347,7 @@ int main(int argc, char **argv)
 		{ "batch",		required_argument,	NULL, 'b' },
 		{ "json",		no_argument,		NULL, 'j' },
 		{ "pretty",		no_argument,		NULL, 'p' },
+		{ "statistics",		no_argument,		NULL, 's' },
 		{ "Netns",		required_argument,	NULL, 'N' },
 		{ "help",		no_argument,		NULL, 'h' },
 		{ NULL, 0, NULL, 0 }
@@ -363,7 +365,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "b:fhjpvN:V",
+	while ((opt = getopt_long(argc, argv, "b:fhjpsvN:V",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -383,6 +385,9 @@ int main(int argc, char **argv)
 		case 'p':
 			pretty = true;
 			break;
+		case 's':
+			dcb->stats = true;
+			break;
 		case 'N':
 			if (netns_switch(optarg)) {
 				ret = EXIT_FAILURE;
diff --git a/dcb/dcb.h b/dcb/dcb.h
index d22176888811..b2a13b3065f2 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -11,6 +11,7 @@ struct dcb {
 	char *buf;
 	struct mnl_socket *nl;
 	bool json_output;
+	bool stats;
 };
 
 int dcb_parse_mapping(const char *what_key, __u32 key, __u32 max_key,
diff --git a/man/man8/dcb.8 b/man/man8/dcb.8
index f318435caa98..f853b7baaf33 100644
--- a/man/man8/dcb.8
+++ b/man/man8/dcb.8
@@ -51,6 +51,11 @@ Generate JSON output.
 .BR "\-p" , " --pretty"
 When combined with -j generate a pretty JSON output.
 
+.TP
+.BR "\-s" , " --statistics"
+If the object in question contains any statistical counters, shown them as
+part of the "show" output.
+
 .SH OBJECTS
 
 .TP
-- 
2.25.1

