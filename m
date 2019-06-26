Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628AE56E97
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfFZQVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:21:00 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40598 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZQU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:20:59 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so1613628pfp.7
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 09:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1JobiI97FdBUbogd5Hrqu/FpGIF923iunOGvCxNutos=;
        b=stNM5SHPh5YR7JmfwBGq8G8ohN6Niu5KOrbNllUXEiLzN+1GAPvjYFNhmo36Slvf/q
         yctwhJl21OG/NRspqtjDlE2I7LBFBl4Ma13CkSWMNCMqbTvitXuHmmi15/C1IM28W04e
         +yM50I1gMwWOlmsx0VKI6zi2kJHzxFbGj3F3fh5vHwH7qhLS6p608jbpEDcXm/tmTJXB
         r1Z8Lqfos8wH8BLD5ZCaQ9C9fQeHN1kt+r23hRrqYMD7kocHAEyoifk3hrd+Uc+oRV2h
         96d8CnkYkRK+gKkGKcMcDY1FwC1M42BraBzjQbXnL/aA/NQM4GEyNjRlZZshyaDlWhAp
         HqSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1JobiI97FdBUbogd5Hrqu/FpGIF923iunOGvCxNutos=;
        b=pmjm0Si9DOyZR8MQ7mtlJLXXK4LfO8eO1KWKd2qxCM/xw74n3aEI6GmYiFuCCRzDeG
         d+aBuEBTaD36CpbU6B4XDJQ2br1McErpWYhXLxuW8l99bjAmFqjoGpPCUPFv0JC8Dkd4
         w2ABVCiJNxURSRV2ytd3k+0gjYrO7W6iAaNdyFxsCp+bTzjITBHRclFgokf8R7CT0r/z
         bYhVcRAmeERvMcETpnbXA6Qt1QTLIKQkiboUlFjMsv5ez4g0UFy1wLV0yukxA+nrSic0
         cDQhxcMSzimNLpw+hXHAhz0GaNvD8ZAkCSystR2XPCeqwDkXSqf65grBRVdisjIdQB6i
         +2mQ==
X-Gm-Message-State: APjAAAWnGLkoDGnHwiLXaQHINLuly6X5IkU0y9l6+RAi7LErsPWWAm67
        s7Ui38Y2AvPxSiPPs1jKNvyuJlOpFY8=
X-Google-Smtp-Source: APXvYqwr8Pg4joqp/LD8w+fjMyi/az5PJhkr0aHiO4Ooc6FbXvr/IZ2OjIskmOXJHGer9QlV4qIocQ==
X-Received: by 2002:a17:90a:cb12:: with SMTP id z18mr5510541pjt.82.1561566058874;
        Wed, 26 Jun 2019 09:20:58 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t24sm18950876pfh.113.2019.06.26.09.20.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 09:20:58 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     arkadis@mellanox.com
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute] devlink: replace print macros with functions
Date:   Wed, 26 Jun 2019 09:20:51 -0700
Message-Id: <20190626162051.22883-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using functions is safer than macros, and printing is not performance
critical.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 devlink/devlink.c | 62 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 559f624e3666..4e277f7b0bc3 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -11,6 +11,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdarg.h>
 #include <string.h>
 #include <stdbool.h>
 #include <unistd.h>
@@ -48,32 +49,53 @@
 #define HEALTH_REPORTER_TIMESTAMP_FMT_LEN 80
 
 static int g_new_line_count;
-
-#define pr_err(args...) fprintf(stderr, ##args)
-#define pr_out(args...)						\
-	do {							\
-		if (g_indent_newline) {				\
-			fprintf(stdout, "%s", g_indent_str);	\
-			g_indent_newline = false;		\
-		}						\
-		fprintf(stdout, ##args);			\
-		g_new_line_count = 0;				\
-	} while (0)
-
-#define pr_out_sp(num, args...)					\
-	do {							\
-		int ret = fprintf(stdout, ##args);		\
-		if (ret < num)					\
-			fprintf(stdout, "%*s", num - ret, "");	\
-		g_new_line_count = 0;				\
-	} while (0)
-
 static int g_indent_level;
 static bool g_indent_newline;
+
 #define INDENT_STR_STEP 2
 #define INDENT_STR_MAXLEN 32
 static char g_indent_str[INDENT_STR_MAXLEN + 1] = "";
 
+static void __attribute__((format(printf, 1, 2)))
+pr_err(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	vfprintf(stderr, fmt, ap);
+	va_end(ap);
+}
+
+static void __attribute__((format(printf, 1, 2)))
+pr_out(const char *fmt, ...)
+{
+	va_list ap;
+
+	if (g_indent_newline) {
+		printf("%s", g_indent_str);
+		g_indent_newline = false;
+	}
+	va_start(ap, fmt);
+	vprintf(fmt, ap);
+	va_end(ap);
+	g_new_line_count = 0;
+}
+
+static void __attribute__((format(printf, 2, 3)))
+pr_out_sp(unsigned int num, const char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = vprintf(fmt, ap);
+	va_end(ap);
+
+	if (ret < num)
+		printf("%*s", num - ret, "");
+	g_new_line_count = 0;			\
+}
+
 static void __pr_out_indent_inc(void)
 {
 	if (g_indent_level + INDENT_STR_STEP > INDENT_STR_MAXLEN)
-- 
2.20.1

