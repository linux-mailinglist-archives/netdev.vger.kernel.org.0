Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1821BB22B
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgD0XvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726364AbgD0XvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 19:51:06 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0658C03C1A7
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:51:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c21so6788688plz.4
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NuXkYasNKdE8gXAViAwS/O7ZbHUpG4zZKK3dPqbMz2I=;
        b=bfhyUc6ozaKp1G1b7AP1E+47ho7sC1t2z7ApoII0Nrqz0s+8V13c9UpSJQAMPtqJco
         nYDQISHvGiQJQPZJ3Yv9j82DOotJ1JjpGsX5H+vkWM8KFB0cay952xQLAH5C1LhHqolc
         iqvwr3Ut3vLfq5lfpHNU8ydH3YqrApXUl0t20=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NuXkYasNKdE8gXAViAwS/O7ZbHUpG4zZKK3dPqbMz2I=;
        b=OZfZW1u9WKYGMyxYphNpJBKO1HbOt9lrECrrphIlG1iaUlKL9PHZhlyzpIfG55jDwx
         Y2Pz+QNvGTauvfjxRqqhGa9vEmo5jGTL72QwRCr9DpXeWERGIAkrlXiVUJ5zLV5tOiRu
         N1SeHgY918l6zh7yqKsZ0stACBbh0lWbVFHv3E2QXUYszD143fVdcMK0dy2Rz7YlKWJb
         L812QWveKby38XbuAjszLSNDNgjB6GMUdYU4VtU/aJKvuz1wS+P5cpvqdk/BHdX59P90
         Myw7skRMdaodmxohbcnBJoozNiiqDoLnjPJNjlA8KuQ2VnyGjckkJGqi0dkZ0Bg3samz
         ji/g==
X-Gm-Message-State: AGi0PubDQ3HgRjT5U0+eLpNKYKKTvTHV7/abpdHNv8ccOqS0yh0k/3Ao
        QujgWufECwhzWVFsDT7M3iaiLvyHaH0=
X-Google-Smtp-Source: APiQypIWy0W8HAblCbU2Qo2hbbPfj6oH48NPrxaMJmIsveId1PB5rk4/Rt7SvYYgMGemxba6SG2Obw==
X-Received: by 2002:a17:902:7241:: with SMTP id c1mr24362379pll.113.1588031465696;
        Mon, 27 Apr 2020 16:51:05 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id 128sm13058106pfy.5.2020.04.27.16.51.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 16:51:05 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2 5/7] json_print: Return number of characters printed
Date:   Tue, 28 Apr 2020 08:50:49 +0900
Message-Id: <20200427235051.250058-6-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
References: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When outputting in normal mode, forward the return value from
color_fprintf().

Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 include/json_print.h | 24 ++++++-----
 lib/json_print.c     | 95 +++++++++++++++++++++++++++-----------------
 2 files changed, 73 insertions(+), 46 deletions(-)

diff --git a/include/json_print.h b/include/json_print.h
index 34444793..50e71de4 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -44,20 +44,24 @@ void close_json_array(enum output_type type, const char *delim);
 void print_nl(void);
 
 #define _PRINT_FUNC(type_name, type)					\
-	void print_color_##type_name(enum output_type t,		\
-				     enum color_attr color,		\
-				     const char *key,			\
-				     const char *fmt,			\
-				     type value);			\
+	int print_color_##type_name(enum output_type t,			\
+				    enum color_attr color,		\
+				    const char *key,			\
+				    const char *fmt,			\
+				    type value);			\
 									\
-	static inline void print_##type_name(enum output_type t,	\
-					     const char *key,		\
-					     const char *fmt,		\
-					     type value)		\
+	static inline int print_##type_name(enum output_type t,		\
+					    const char *key,		\
+					    const char *fmt,		\
+					    type value)			\
 	{								\
-		print_color_##type_name(t, COLOR_NONE, key, fmt, value);	\
+		return print_color_##type_name(t, COLOR_NONE, key, fmt,	\
+					       value);			\
 	}
 
+/* These functions return 0 if printing to a JSON context, number of
+ * characters printed otherwise (as calculated by printf(3)).
+ */
 _PRINT_FUNC(int, int)
 _PRINT_FUNC(s64, int64_t)
 _PRINT_FUNC(bool, bool)
diff --git a/lib/json_print.c b/lib/json_print.c
index 8e7f32dc..fe0705bf 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -123,20 +123,22 @@ void close_json_array(enum output_type type, const char *str)
  */
 #define _PRINT_FUNC(type_name, type)					\
 	__attribute__((format(printf, 4, 0)))				\
-	void print_color_##type_name(enum output_type t,		\
-				     enum color_attr color,		\
-				     const char *key,			\
-				     const char *fmt,			\
-				     type value)			\
+	int print_color_##type_name(enum output_type t,			\
+				    enum color_attr color,		\
+				    const char *key,			\
+				    const char *fmt,			\
+				    type value)				\
 	{								\
+		int ret = 0;						\
 		if (_IS_JSON_CONTEXT(t)) {				\
 			if (!key)					\
 				jsonw_##type_name(_jw, value);		\
 			else						\
 				jsonw_##type_name##_field(_jw, key, value); \
 		} else if (_IS_FP_CONTEXT(t)) {				\
-			color_fprintf(stdout, color, fmt, value);          \
+			ret = color_fprintf(stdout, color, fmt, value); \
 		}							\
+		return ret;						\
 	}
 _PRINT_FUNC(int, int);
 _PRINT_FUNC(s64, int64_t);
@@ -162,12 +164,14 @@ _PRINT_NAME_VALUE_FUNC(uint, unsigned int, u);
 _PRINT_NAME_VALUE_FUNC(string, const char*, s);
 #undef _PRINT_NAME_VALUE_FUNC
 
-void print_color_string(enum output_type type,
-			enum color_attr color,
-			const char *key,
-			const char *fmt,
-			const char *value)
+int print_color_string(enum output_type type,
+		       enum color_attr color,
+		       const char *key,
+		       const char *fmt,
+		       const char *value)
 {
+	int ret = 0;
+
 	if (_IS_JSON_CONTEXT(type)) {
 		if (key && !value)
 			jsonw_name(_jw, key);
@@ -176,8 +180,10 @@ void print_color_string(enum output_type type,
 		else
 			jsonw_string_field(_jw, key, value);
 	} else if (_IS_FP_CONTEXT(type)) {
-		color_fprintf(stdout, color, fmt, value);
+		ret = color_fprintf(stdout, color, fmt, value);
 	}
+
+	return ret;
 }
 
 /*
@@ -185,47 +191,58 @@ void print_color_string(enum output_type type,
  * a value to it, you will need to use "is_json_context()" to have different
  * branch for json and regular output. grep -r "print_bool" for example
  */
-void print_color_bool(enum output_type type,
-		      enum color_attr color,
-		      const char *key,
-		      const char *fmt,
-		      bool value)
+int print_color_bool(enum output_type type,
+		     enum color_attr color,
+		     const char *key,
+		     const char *fmt,
+		     bool value)
 {
+	int ret = 0;
+
 	if (_IS_JSON_CONTEXT(type)) {
 		if (key)
 			jsonw_bool_field(_jw, key, value);
 		else
 			jsonw_bool(_jw, value);
 	} else if (_IS_FP_CONTEXT(type)) {
-		color_fprintf(stdout, color, fmt, value ? "true" : "false");
+		ret = color_fprintf(stdout, color, fmt,
+				    value ? "true" : "false");
 	}
+
+	return ret;
 }
 
 /*
  * In JSON context uses hardcode %#x format: 42 -> 0x2a
  */
-void print_color_0xhex(enum output_type type,
-		       enum color_attr color,
-		       const char *key,
-		       const char *fmt,
-		       unsigned long long hex)
+int print_color_0xhex(enum output_type type,
+		      enum color_attr color,
+		      const char *key,
+		      const char *fmt,
+		      unsigned long long hex)
 {
+	int ret = 0;
+
 	if (_IS_JSON_CONTEXT(type)) {
 		SPRINT_BUF(b1);
 
 		snprintf(b1, sizeof(b1), "%#llx", hex);
 		print_string(PRINT_JSON, key, NULL, b1);
 	} else if (_IS_FP_CONTEXT(type)) {
-		color_fprintf(stdout, color, fmt, hex);
+		ret = color_fprintf(stdout, color, fmt, hex);
 	}
+
+	return ret;
 }
 
-void print_color_hex(enum output_type type,
-		     enum color_attr color,
-		     const char *key,
-		     const char *fmt,
-		     unsigned int hex)
+int print_color_hex(enum output_type type,
+		    enum color_attr color,
+		    const char *key,
+		    const char *fmt,
+		    unsigned int hex)
 {
+	int ret = 0;
+
 	if (_IS_JSON_CONTEXT(type)) {
 		SPRINT_BUF(b1);
 
@@ -235,28 +252,34 @@ void print_color_hex(enum output_type type,
 		else
 			jsonw_string(_jw, b1);
 	} else if (_IS_FP_CONTEXT(type)) {
-		color_fprintf(stdout, color, fmt, hex);
+		ret = color_fprintf(stdout, color, fmt, hex);
 	}
+
+	return ret;
 }
 
 /*
  * In JSON context we don't use the argument "value" we simply call jsonw_null
  * whereas FP context can use "value" to output anything
  */
-void print_color_null(enum output_type type,
-		      enum color_attr color,
-		      const char *key,
-		      const char *fmt,
-		      const char *value)
+int print_color_null(enum output_type type,
+		     enum color_attr color,
+		     const char *key,
+		     const char *fmt,
+		     const char *value)
 {
+	int ret = 0;
+
 	if (_IS_JSON_CONTEXT(type)) {
 		if (key)
 			jsonw_null_field(_jw, key);
 		else
 			jsonw_null(_jw);
 	} else if (_IS_FP_CONTEXT(type)) {
-		color_fprintf(stdout, color, fmt, value);
+		ret = color_fprintf(stdout, color, fmt, value);
 	}
+
+	return ret;
 }
 
 /* Print line separator (if not in JSON mode) */
-- 
2.26.0

