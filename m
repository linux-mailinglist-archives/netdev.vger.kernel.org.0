Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121FE465B4
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfFNRZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:25:10 -0400
Received: from mail-pf1-f227.google.com ([209.85.210.227]:35771 "EHLO
        mail-pf1-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbfFNRZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 13:25:09 -0400
Received: by mail-pf1-f227.google.com with SMTP id d126so1860849pfd.2
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 10:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev295.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Bw/6dgHVXtXqocEdR4XM76GWElXUNRiicyqxK2R08Lg=;
        b=FOfsK3wJvAq3VWZR34P5uYlee0iB0ddbfk2NEUgIjCKNKDeTgDG+/gZ6ydQHwnzxbE
         ZKkLc4TxRDKmEHMfPsu3k25CP9Bom+rn1bVTYVqBiMdXE0e6PZnzy04XQCjhqWg9ljeh
         sQv+uJoZNBM/xYklECIPh8oAs7Q60OPIXFCIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Bw/6dgHVXtXqocEdR4XM76GWElXUNRiicyqxK2R08Lg=;
        b=oNftj0dYLIMj1gRD9theOqQ0gv0Nuz6+1fqrotjTG46+bgqkm6pitvY3oHljDVl6AL
         8GcYfLOJInMWAPGZuB6v5GG3HNinM6U9DYomDXwJWK7h4eT7rkB4t45nBsysSLE3g/5U
         FU5roSBmp59R9AzN/pRVJVTBkbVTvOWDtAgSIzmjd8/yt+t95uQ9Js8glAAH4piyYVIe
         tpxRyvaf9TDBuIogshoifZAEmMvju2PGTmtVWzk67qzZ/mUAw6LLAkVOpYKK5gz1xgLD
         eM9XMCC/RKjovwPXyvCsSTAGS2DqG3+OWypZjYuVddEsjlWhTbpTUoYUhQI7qqutGct4
         PvBw==
X-Gm-Message-State: APjAAAUcxIH1HEOVukcNx8nzW561nOr5viLAjwZmSEZ/SnBIUXwTwfX0
        QZ9mOaLjeviF2kfTp7prFLPlept/tShtvBnHjBdhF9TxEeW4Zw==
X-Google-Smtp-Source: APXvYqyZzBBTEjIPeF9t3jxN8YMow0YrQizwRnOjVuQIqypMuyVuapGpxKKCFThP+ek9bIDipmqtNvgEpTSh
X-Received: by 2002:a17:90a:216f:: with SMTP id a102mr12441392pje.29.1560533109213;
        Fri, 14 Jun 2019 10:25:09 -0700 (PDT)
Received: from neptune.net (c-69-251-140-241.hsd1.md.comcast.net. [69.251.140.241])
        by smtp-relay.gmail.com with ESMTPS id k103sm384280pje.7.2019.06.14.10.25.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 10:25:09 -0700 (PDT)
X-Relaying-Domain: dev295.com
From:   Pete Morici <pmorici@dev295.com>
To:     netdev@vger.kernel.org
Cc:     Pete Morici <pmorici@dev295.com>
Subject: [PATCH iproute2] Add support for configuring MACsec gcm-aes-256 cipher type.
Date:   Fri, 14 Jun 2019 13:24:59 -0400
Message-Id: <1560533099-8276-1-git-send-email-pmorici@dev295.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Pete Morici <pmorici@dev295.com>
---
 ip/ipmacsec.c        | 28 +++++++++++++++++++---------
 man/man8/ip-macsec.8 |  2 +-
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index 54cd2b8..ad6ad7d 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -95,7 +95,7 @@ static void ipmacsec_usage(void)
 		"       ip macsec show DEV\n"
 		"where  OPTS := [ pn <u32> ] [ on | off ]\n"
 		"       ID   := 128-bit hex string\n"
-		"       KEY  := 128-bit hex string\n"
+		"       KEY  := 128-bit or 256-bit hex string\n"
 		"       SCI  := { sci <u64> | port { 1..2^16-1 } address <lladdr> }\n");
 
 	exit(-1);
@@ -586,14 +586,20 @@ static void print_key(struct rtattr *key)
 				   keyid, sizeof(keyid)));
 }
 
-#define DEFAULT_CIPHER_NAME "GCM-AES-128"
+#define CIPHER_NAME_GCM_AES_128 "GCM-AES-128"
+#define CIPHER_NAME_GCM_AES_256 "GCM-AES-256"
+#define DEFAULT_CIPHER_NAME CIPHER_NAME_GCM_AES_128
 
 static const char *cs_id_to_name(__u64 cid)
 {
 	switch (cid) {
 	case MACSEC_DEFAULT_CIPHER_ID:
-	case MACSEC_DEFAULT_CIPHER_ALT:
 		return DEFAULT_CIPHER_NAME;
+	case MACSEC_CIPHER_ID_GCM_AES_128:
+	     /* MACSEC_DEFAULT_CIPHER_ALT: */
+		return CIPHER_NAME_GCM_AES_128;
+	case MACSEC_CIPHER_ID_GCM_AES_256:
+		return CIPHER_NAME_GCM_AES_256;
 	default:
 		return "(unknown)";
 	}
@@ -1172,7 +1178,7 @@ static void usage(FILE *f)
 {
 	fprintf(f,
 		"Usage: ... macsec [ [ address <lladdr> ] port { 1..2^16-1 } | sci <u64> ]\n"
-		"                  [ cipher { default | gcm-aes-128 } ]\n"
+		"                  [ cipher { default | gcm-aes-128 | gcm-aes-256 } ]\n"
 		"                  [ icvlen { 8..16 } ]\n"
 		"                  [ encrypt { on | off } ]\n"
 		"                  [ send_sci { on | off } ]\n"
@@ -1217,13 +1223,17 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			if (cipher.id)
 				duparg("cipher", *argv);
-			if (strcmp(*argv, "default") == 0 ||
-			    strcmp(*argv, "gcm-aes-128") == 0 ||
-			    strcmp(*argv, "GCM-AES-128") == 0)
+			if (strcmp(*argv, "default") == 0)
 				cipher.id = MACSEC_DEFAULT_CIPHER_ID;
+			else if (strcmp(*argv, "gcm-aes-128") == 0 ||
+			         strcmp(*argv, "GCM-AES-128") == 0)
+				cipher.id = MACSEC_CIPHER_ID_GCM_AES_128;
+			else if (strcmp(*argv, "gcm-aes-256") == 0 ||
+			         strcmp(*argv, "GCM-AES-256") == 0)
+				cipher.id = MACSEC_CIPHER_ID_GCM_AES_256;
 			else
-				invarg("expected: default or gcm-aes-128",
-				       *argv);
+				invarg("expected: default, gcm-aes-128 or"
+				       " gcm-aes-256", *argv);
 		} else if (strcmp(*argv, "icvlen") == 0) {
 			NEXT_ARG();
 			if (cipher.icv_len)
diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index 1aca3bd..4fd8a5b 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -10,7 +10,7 @@ ip-macsec \- MACsec device configuration
 |
 .BI sci " <u64>"
 ] [
-.BR cipher " { " default " | " gcm-aes-128 " } ] ["
+.BR cipher " { " default " | " gcm-aes-128 " | "gcm-aes-256" } ] ["
 .BI icvlen " ICVLEN"
 ] [
 .BR encrypt " { " on " | " off " } ] ["
-- 
1.8.3.1

