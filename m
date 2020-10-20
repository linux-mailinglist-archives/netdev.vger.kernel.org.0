Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31629293277
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389631AbgJTA6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389614AbgJTA6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:58:51 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C7AC0613D3
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:58:50 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CFZy03kDvzKmXL;
        Tue, 20 Oct 2020 02:58:48 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8gPvARuOucKpeeGtwIx19zoR5UzyAayT53YkNHfC9Y=;
        b=gR27rRlAae+WDFTnZKaac/JXtj+vew8LA6tHlqJIzbS8ANI9tcO6USGj2v8kBT/VbCLY8i
        UgN3JRHL3NvzGl1aK+ai9lKDvqWJvTBOK4IbD2H5IYsaHejaSzyNMnj/PXuNIZqpq7/cLQ
        7LOHUdqFGkg7hupPjWtSSRRKOSNwleI1ITaZ2juU4quzCKkXhofStY1kXzv08oW4Tlsvh8
        v+EGCo3xxWZxczl3emMSd12K5Koihr2Yp72OakXA7Pmk9eDwaFSPCs/T6EWcUMMhLxAMh1
        kdNqKsEPveLzxZre7ftwWhET8qBaUciOJsMBnWl6wWrkgWJhxozvKQmOomjEOg==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id fcDZ5kpgNTUB; Tue, 20 Oct 2020 02:58:44 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 02/15] lib: Add parse_one_of(), parse_on_off()
Date:   Tue, 20 Oct 2020 02:58:10 +0200
Message-Id: <194ae677df465086d6cd1d7962c07d790e6d049d.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.09 / 15.00 / 15.00
X-Rspamd-Queue-Id: 6F38E15
X-Rspamd-UID: 1d7c42
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take from the macsec code parse_one_of() and adapt so that it passes the
primary result as the main return value, and error result through a
pointer. That is the simplest way to make the code reusable across data
types without introducing extra magic.

Also from macsec take the specialization of parse_one_of() for parsing
specifically the strings "off" and "on".

Convert the macsec code to the new helpers.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/utils.h |  4 ++++
 ip/ipmacsec.c   | 52 +++++++++++--------------------------------------
 lib/utils.c     | 28 ++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 085b17b1f6e3..bd62cdcd7122 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -325,4 +325,8 @@ char *sprint_time64(__s64 time, char *buf);
 int do_batch(const char *name, bool force,
 	     int (*cmd)(int argc, char *argv[], void *user), void *user);
 
+int parse_one_of(const char *msg, const char *realval, const char * const *list,
+		 size_t len, int *p_err);
+int parse_on_off(const char *msg, const char *realval, int *p_err);
+
 #endif /* __UTILS_H__ */
diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index 18289ecd6d9e..bf48e8b5d0b2 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -23,8 +23,6 @@
 #include "ll_map.h"
 #include "libgenl.h"
 
-static const char * const values_on_off[] = { "off", "on" };
-
 static const char * const validate_str[] = {
 	[MACSEC_VALIDATE_DISABLED] = "disabled",
 	[MACSEC_VALIDATE_CHECK] = "check",
@@ -108,25 +106,6 @@ static void ipmacsec_usage(void)
 	exit(-1);
 }
 
-static int one_of(const char *msg, const char *realval, const char * const *list,
-		  size_t len, int *index)
-{
-	int i;
-
-	for (i = 0; i < len; i++) {
-		if (matches(realval, list[i]) == 0) {
-			*index = i;
-			return 0;
-		}
-	}
-
-	fprintf(stderr, "Error: argument of \"%s\" must be one of ", msg);
-	for (i = 0; i < len; i++)
-		fprintf(stderr, "\"%s\", ", list[i]);
-	fprintf(stderr, "not \"%s\"\n", realval);
-	return -1;
-}
-
 static int get_an(__u8 *val, const char *arg)
 {
 	int ret = get_u8(val, arg, 0);
@@ -559,8 +538,7 @@ static int do_offload(enum cmd c, int argc, char **argv)
 	if (argc == 0)
 		ipmacsec_usage();
 
-	ret = one_of("offload", *argv, offload_str, ARRAY_SIZE(offload_str),
-		     (int *)&offload);
+	offload = parse_one_of("offload", *argv, offload_str, ARRAY_SIZE(offload_str), &ret);
 	if (ret)
 		ipmacsec_usage();
 
@@ -1334,8 +1312,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			int i;
 
-			ret = one_of("encrypt", *argv, values_on_off,
-				     ARRAY_SIZE(values_on_off), &i);
+			i = parse_on_off("encrypt", *argv, &ret);
 			if (ret != 0)
 				return ret;
 			addattr8(n, MACSEC_BUFLEN, IFLA_MACSEC_ENCRYPT, i);
@@ -1343,8 +1320,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			int i;
 
-			ret = one_of("send_sci", *argv, values_on_off,
-				     ARRAY_SIZE(values_on_off), &i);
+			i = parse_on_off("send_sci", *argv, &ret);
 			if (ret != 0)
 				return ret;
 			send_sci = i;
@@ -1354,8 +1330,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			int i;
 
-			ret = one_of("end_station", *argv, values_on_off,
-				     ARRAY_SIZE(values_on_off), &i);
+			i = parse_on_off("end_station", *argv, &ret);
 			if (ret != 0)
 				return ret;
 			es = i;
@@ -1364,8 +1339,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			int i;
 
-			ret = one_of("scb", *argv, values_on_off,
-				     ARRAY_SIZE(values_on_off), &i);
+			i = parse_on_off("scb", *argv, &ret);
 			if (ret != 0)
 				return ret;
 			scb = i;
@@ -1374,8 +1348,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			int i;
 
-			ret = one_of("protect", *argv, values_on_off,
-				     ARRAY_SIZE(values_on_off), &i);
+			i = parse_on_off("protect", *argv, &ret);
 			if (ret != 0)
 				return ret;
 			addattr8(n, MACSEC_BUFLEN, IFLA_MACSEC_PROTECT, i);
@@ -1383,8 +1356,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			int i;
 
-			ret = one_of("replay", *argv, values_on_off,
-				     ARRAY_SIZE(values_on_off), &i);
+			i = parse_on_off("replay", *argv, &ret);
 			if (ret != 0)
 				return ret;
 			replay_protect = !!i;
@@ -1395,9 +1367,8 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 				invarg("expected replay window size", *argv);
 		} else if (strcmp(*argv, "validate") == 0) {
 			NEXT_ARG();
-			ret = one_of("validate", *argv,
-				     validate_str, ARRAY_SIZE(validate_str),
-				     (int *)&validate);
+			validate = parse_one_of("validate", *argv, validate_str,
+						ARRAY_SIZE(validate_str), &ret);
 			if (ret != 0)
 				return ret;
 			addattr8(n, MACSEC_BUFLEN,
@@ -1411,9 +1382,8 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 				invarg("expected an { 0..3 }", *argv);
 		} else if (strcmp(*argv, "offload") == 0) {
 			NEXT_ARG();
-			ret = one_of("offload", *argv,
-				     offload_str, ARRAY_SIZE(offload_str),
-				     (int *)&offload);
+			offload = parse_one_of("offload", *argv, offload_str,
+					       ARRAY_SIZE(offload_str), &ret);
 			if (ret != 0)
 				return ret;
 			addattr8(n, MACSEC_BUFLEN,
diff --git a/lib/utils.c b/lib/utils.c
index 9815e328c9e0..930877ae0f0d 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1735,3 +1735,31 @@ int do_batch(const char *name, bool force,
 
 	return ret;
 }
+
+int parse_one_of(const char *msg, const char *realval, const char * const *list,
+		 size_t len, int *p_err)
+{
+	int i;
+
+	for (i = 0; i < len; i++) {
+		if (list[i] && matches(realval, list[i]) == 0) {
+			*p_err = 0;
+			return i;
+		}
+	}
+
+	fprintf(stderr, "Error: argument of \"%s\" must be one of ", msg);
+	for (i = 0; i < len; i++)
+		if (list[i])
+			fprintf(stderr, "\"%s\", ", list[i]);
+	fprintf(stderr, "not \"%s\"\n", realval);
+	*p_err = -EINVAL;
+	return 0;
+}
+
+int parse_on_off(const char *msg, const char *realval, int *p_err)
+{
+	static const char * const values_on_off[] = { "off", "on" };
+
+	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
+}
-- 
2.25.1

