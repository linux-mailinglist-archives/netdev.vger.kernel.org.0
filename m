Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E522AABBA
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 16:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgKHPIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 10:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgKHPIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 10:08:32 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2321C0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 07:08:32 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CTcvf4GJ2zQjgg;
        Sun,  8 Nov 2020 16:08:30 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604848108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UQPqtFPni3LKjqH2SE5mPQslRREm+4iBNCJmGmvPc5E=;
        b=WeEHpf6YwCeg+OnpH/ODQv08JClRz7i6Ajg06hpeooIa9cnjFsEZkEoWFMrkqoRy07IXeM
        1DsADcaZ5vGVBVNzzzqvVEdkaaSM8Gt/AUgb+0fQZrkBUOhtvep/LGrvuAQwEUW6axqfsD
        h2znIAP2oWpJHEk9JmWA8e/GghTYw7/OXNHbXIOxRFpc6F5WIa4DIWuFx6ui5/CUeZWCd6
        UajdtyhmyGXoX46pQ1N+CBVrR6Toh3PXLzTTl/NGFU+yk71oXOHKjL2iBH/1PSIYafy9az
        9pPZSjShaPyZwS7kE60aAhwyBMC1nDoNIyNXHFb8UN4hm3JkrW+HVKQPwQrrJg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id ngWyXRcieWpM; Sun,  8 Nov 2020 16:08:27 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v3 03/11] lib: json_print: Add print_on_off()
Date:   Sun,  8 Nov 2020 16:07:24 +0100
Message-Id: <f9e1baac29bddcb406d41e06d8414a4b4d6bcf62.1604847919.git.me@pmachata.org>
In-Reply-To: <cover.1604847919.git.me@pmachata.org>
References: <cover.1604847919.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.55 / 15.00 / 15.00
X-Rspamd-Queue-Id: 97E5A1720
X-Rspamd-UID: cc98d5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of a number of booleans is shown as "on" and "off" in the plain
output, and as an actual boolean in JSON mode. Add a function that does
that.

RDMA tool already uses a function named print_on_off(). This function
always shows "on" and "off", even in JSON mode. Since there are probably
very few if any consumers of this interface at this point, migrate it to
the new central print_on_off() as well.

Signed-off-by: Petr Machata <me@pmachata.org>
---

Notes:
    v3:
    - Rename to print_on_off(). [David Ahern]
    - Move over to json_print.c and make it a variant of print_bool().
      Convert RDMA tool over to print_on_off(). [Leon Romanovsky]

 include/json_print.h |  1 +
 lib/json_print.c     | 34 +++++++++++++++++++++++++++-------
 rdma/dev.c           |  2 +-
 rdma/rdma.h          |  1 -
 rdma/res-cq.c        |  2 +-
 rdma/utils.c         |  5 -----
 6 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/include/json_print.h b/include/json_print.h
index 50e71de443ab..096a999a4de4 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -65,6 +65,7 @@ void print_nl(void);
 _PRINT_FUNC(int, int)
 _PRINT_FUNC(s64, int64_t)
 _PRINT_FUNC(bool, bool)
+_PRINT_FUNC(on_off, bool)
 _PRINT_FUNC(null, const char*)
 _PRINT_FUNC(string, const char*)
 _PRINT_FUNC(uint, unsigned int)
diff --git a/lib/json_print.c b/lib/json_print.c
index fe0705bf6965..62eeb1f1fb31 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -191,11 +191,12 @@ int print_color_string(enum output_type type,
  * a value to it, you will need to use "is_json_context()" to have different
  * branch for json and regular output. grep -r "print_bool" for example
  */
-int print_color_bool(enum output_type type,
-		     enum color_attr color,
-		     const char *key,
-		     const char *fmt,
-		     bool value)
+static int __print_color_bool(enum output_type type,
+			      enum color_attr color,
+			      const char *key,
+			      const char *fmt,
+			      bool value,
+			      const char *str)
 {
 	int ret = 0;
 
@@ -205,13 +206,32 @@ int print_color_bool(enum output_type type,
 		else
 			jsonw_bool(_jw, value);
 	} else if (_IS_FP_CONTEXT(type)) {
-		ret = color_fprintf(stdout, color, fmt,
-				    value ? "true" : "false");
+		ret = color_fprintf(stdout, color, fmt, str);
 	}
 
 	return ret;
 }
 
+int print_color_bool(enum output_type type,
+		     enum color_attr color,
+		     const char *key,
+		     const char *fmt,
+		     bool value)
+{
+	return __print_color_bool(type, color, key, fmt, value,
+				  value ? "true" : "false");
+}
+
+int print_color_on_off(enum output_type type,
+		       enum color_attr color,
+		       const char *key,
+		       const char *fmt,
+		       bool value)
+{
+	return __print_color_bool(type, color, key, fmt, value,
+				  value ? "on" : "off");
+}
+
 /*
  * In JSON context uses hardcode %#x format: 42 -> 0x2a
  */
diff --git a/rdma/dev.c b/rdma/dev.c
index a11081b82170..c684dde4a56f 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -159,7 +159,7 @@ static void dev_print_dim_setting(struct rd *rd, struct nlattr **tb)
 	if (dim_setting > 1)
 		return;
 
-	print_on_off(rd, "adaptive-moderation", dim_setting);
+	print_on_off(PRINT_ANY, "adaptive-moderation", "adaptive-moderation %s ", dim_setting);
 
 }
 
diff --git a/rdma/rdma.h b/rdma/rdma.h
index a6c6bdea5a80..8638b2a39aeb 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -138,7 +138,6 @@ void print_driver_table(struct rd *rd, struct nlattr *tb);
 void print_raw_data(struct rd *rd, struct nlattr **nla_line);
 void newline(struct rd *rd);
 void newline_indent(struct rd *rd);
-void print_on_off(struct rd *rd, const char *key_str, bool on);
 void print_raw_data(struct rd *rd, struct nlattr **nla_line);
 #define MAX_LINE_LENGTH 80
 
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index 313f929a29b5..9e7c4f512b72 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -36,7 +36,7 @@ static void print_cq_dim_setting(struct rd *rd, struct nlattr *attr)
 	if (dim_setting > 1)
 		return;
 
-	print_on_off(rd, "adaptive-moderation", dim_setting);
+	print_on_off(PRINT_ANY, "adaptive-moderation", "adaptive-moderation %s ", dim_setting);
 }
 
 static int res_cq_line_raw(struct rd *rd, const char *name, int idx,
diff --git a/rdma/utils.c b/rdma/utils.c
index 4d3de4fadba2..2a201aa4aeb7 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -781,11 +781,6 @@ static int print_driver_string(struct rd *rd, const char *key_str,
 	return 0;
 }
 
-void print_on_off(struct rd *rd, const char *key_str, bool on)
-{
-	print_driver_string(rd, key_str, (on) ? "on":"off");
-}
-
 static int print_driver_s32(struct rd *rd, const char *key_str, int32_t val,
 			      enum rdma_nldev_print_type print_type)
 {
-- 
2.25.1

