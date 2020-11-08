Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0DC2AAD8A
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 22:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgKHVOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 16:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgKHVOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 16:14:41 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1B4C0613D3
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 13:14:41 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CTn276FwLzQlL2;
        Sun,  8 Nov 2020 22:14:39 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604870078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=reJsB5/K3a/oTlTqeGRODg6xD0dkFikmeb1Md1DF2xI=;
        b=THiGxhZW+GzTbExGes1cTlygCJYV8qLoHDYjE/lXMlDRJR/VsvRyEnkIeSCJqx0O3P4d+e
        pT4zsIO0UG4mdhTJYQ7eAjaiJT+yeBS/fwPpu6cker4LiV7GXjakjyz/RqDcnWrCPIpdjx
        jUOoDpLqOHFpZSJNcMwpWmn/dxd2aI5pHt4IrqQN9Sto6MPqXi1AfvnZ1ygvhwwu35rDrA
        ysjsmIaH80FZpa+H1Mj4fpLw0Xnz4ckvM1a/Td/QM/6/kF0oMkbmT9IL+Zj9pffNjvd8sN
        735Cy0Gyt24W2aM8rgLThjSKb4OkoainANG6cHN01r9TlL+59lXP0LMXyDSGfA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id vTk8kza3um1H; Sun,  8 Nov 2020 22:14:36 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v4 02/11] lib: Add parse_one_of(), parse_on_off()
Date:   Sun,  8 Nov 2020 22:14:07 +0100
Message-Id: <abe74cb8f0997ce40f8f02c7066e0230a154e0ce.1604869679.git.me@pmachata.org>
In-Reply-To: <cover.1604869679.git.me@pmachata.org>
References: <cover.1604869679.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.14 / 15.00 / 15.00
X-Rspamd-Queue-Id: C3148170E
X-Rspamd-UID: c18a31
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

Notes:
    v3:
    - Have parse_on_off() return a boolean. [David Ahern]

 include/utils.h |  4 ++++
 ip/ipmacsec.c   | 52 +++++++++++--------------------------------------
 lib/utils.c     | 28 ++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 085b17b1f6e3..d7653273af5f 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -325,4 +325,8 @@ char *sprint_time64(__s64 time, char *buf);
 int do_batch(const char *name, bool force,
 	     int (*cmd)(int argc, char *argv[], void *user), void *user);
 
+int parse_one_of(const char *msg, const char *realval, const char * const *list,
+		 size_t len, int *p_err);
+bool parse_on_off(const char *msg, const char *realval, int *p_err);
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
index 9815e328c9e0..eab0839a13c7 100644
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
+bool parse_on_off(const char *msg, const char *realval, int *p_err)
+{
+	static const char * const values_on_off[] = { "off", "on" };
+
+	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
+}
-- 
2.25.1

