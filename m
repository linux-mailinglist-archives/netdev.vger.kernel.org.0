Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DEF36876B
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 21:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239029AbhDVTsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 15:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVTsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 15:48:30 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45A1C06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 12:47:54 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id d19so11868973qkk.12
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 12:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2bSX7Hj382/0LPpLMZUook4VTsK1GZOKkJm2uri9jg4=;
        b=fmCYbt81MnAWvDO2JzMHpnOjz/EcqjJtn+b1NoN6iMI/4nyjAh9cmoptQe4u1jpHG1
         lD7X4giKGcDVSfemNlFlDIAW9x38gJhYTZv0SNHJz78cxnCUJsjNJuaX8pvo275t5YO5
         TSHGsPkgcdyg4ym0AuPocP8JYubaGb98hXyBTnF+46ECrZ6P5TZ784TucMdf2qYbiRip
         jTO2o7XD5eE4+mJgpAkSKOGmY4gZrMdilefeS29dzRzPc0PNlSucqMTP1URb941oC43t
         YKwH90ANXX3jjFFAivJDA66Rb3FJDbJl+BeWmHVg8/Th8wGmVkKYzh7KXCuwExSpzstU
         v4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2bSX7Hj382/0LPpLMZUook4VTsK1GZOKkJm2uri9jg4=;
        b=a5OHGxgHfB6pgUVxoi7kx8WW3utBsgfvk7v4zBs9HTplyXo3eGhW8ifHWiB39xyr59
         NcwItIEw9n81NIYV4wnszbqEkP5ncDJcSIj9yaghRCnN9WcOo0uuGURljfVFbJ7/EO7M
         PjmWOUyQYAalXwPPZPT1uyZ4Urd327RyNmgyOzkgHVQyEWdOeEhE7lE9MqqCiYZfL9IH
         VlJ9diyxjASZB7hI72fGQroQmZcRlor6JeIFAcQI5POgerw1TxPSRQTgMF3Uih3fEsCi
         +XXVozWRw/DRJPISeHgQVAzqCUaIi6t6OOHqaLKgkB0BVKXZsqgESWSfyYB2jE9NJJ0M
         P/yQ==
X-Gm-Message-State: AOAM533ESQNjb3A9josjbGdfAHBy3Ibs1zQLvEHnHk+JxcYVGMK8xgDj
        aW9zRXMYwqQx+eIfG603PFrg9b0u8IY=
X-Google-Smtp-Source: ABdhPJxyHOKrNeTVJegmLvClxJx1pp8PUB6K/B903w8Na30YfvH7eGQczmydP2HgGv9p+rmUFGHV6A==
X-Received: by 2002:a37:c44d:: with SMTP id h13mr408038qkm.414.1619120873746;
        Thu, 22 Apr 2021 12:47:53 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:e069:ac66:9dd7:6f76])
        by smtp.gmail.com with ESMTPSA id a4sm2821781qta.19.2021.04.22.12.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 12:47:53 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: [PATCH net-next 2/3] once: replace uses of __section(".data.once") with DO_ONCE_LITE(_IF)?
Date:   Thu, 22 Apr 2021 15:47:37 -0400
Message-Id: <20210422194738.2175542-3-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
In-Reply-To: <20210422194738.2175542-1-tannerlove.kernel@gmail.com>
References: <20210422194738.2175542-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

DO_ONCE_LITE(_IF)? abstracts this "do once" functionality, presenting
an opportunity for code reuse.

This commit changes the behavior of xfs_printk_once, printk_once and
printk_deferred_once. Before, these macros resulted in code ultimately
evaluating to __print_once. Now, they ultimately evaluate to true.
This is acceptable because none of the clients of these macros relies
on the value.

Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 fs/xfs/xfs_message.h      | 13 +++----------
 include/asm-generic/bug.h | 37 +++++++------------------------------
 include/linux/printk.h    | 23 +++--------------------
 kernel/trace/trace.h      | 13 +++----------
 4 files changed, 16 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 3c392b1512ac..e587e8df6e73 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -2,6 +2,8 @@
 #ifndef __XFS_MESSAGE_H
 #define __XFS_MESSAGE_H 1
 
+#include <linux/once.h>
+
 struct xfs_mount;
 
 extern __printf(2, 3)
@@ -41,16 +43,7 @@ do {									\
 } while (0)
 
 #define xfs_printk_once(func, dev, fmt, ...)			\
-({								\
-	static bool __section(".data.once") __print_once;	\
-	bool __ret_print_once = !__print_once; 			\
-								\
-	if (!__print_once) {					\
-		__print_once = true;				\
-		func(dev, fmt, ##__VA_ARGS__);			\
-	}							\
-	unlikely(__ret_print_once);				\
-})
+	DO_ONCE_LITE(func, dev, fmt, ##__VA_ARGS__)
 
 #define xfs_emerg_ratelimited(dev, fmt, ...)				\
 	xfs_printk_ratelimited(xfs_emerg, dev, fmt, ##__VA_ARGS__)
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 76a10e0dca9f..c93adb63780e 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler.h>
 #include <linux/instrumentation.h>
+#include <linux/once.h>
 
 #define CUT_HERE		"------------[ cut here ]------------\n"
 
@@ -140,39 +141,15 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 })
 
 #ifndef WARN_ON_ONCE
-#define WARN_ON_ONCE(condition)	({				\
-	static bool __section(".data.once") __warned;		\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once && !__warned)) {		\
-		__warned = true;				\
-		WARN_ON(1);					\
-	}							\
-	unlikely(__ret_warn_once);				\
-})
+#define WARN_ON_ONCE(condition)					\
+	DO_ONCE_LITE_IF(condition, WARN_ON, 1)
 #endif
 
-#define WARN_ONCE(condition, format...)	({			\
-	static bool __section(".data.once") __warned;		\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once && !__warned)) {		\
-		__warned = true;				\
-		WARN(1, format);				\
-	}							\
-	unlikely(__ret_warn_once);				\
-})
+#define WARN_ONCE(condition, format...)				\
+	DO_ONCE_LITE_IF(condition, WARN, 1, format)
 
-#define WARN_TAINT_ONCE(condition, taint, format...)	({	\
-	static bool __section(".data.once") __warned;		\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once && !__warned)) {		\
-		__warned = true;				\
-		WARN_TAINT(1, taint, format);			\
-	}							\
-	unlikely(__ret_warn_once);				\
-})
+#define WARN_TAINT_ONCE(condition, taint, format...)		\
+	DO_ONCE_LITE_IF(condition, WARN_TAINT, 1, taint, format)
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
diff --git a/include/linux/printk.h b/include/linux/printk.h
index fe7eb2351610..f706be99f0b6 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -8,6 +8,7 @@
 #include <linux/linkage.h>
 #include <linux/cache.h>
 #include <linux/ratelimit_types.h>
+#include <linux/once.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
@@ -436,27 +437,9 @@ extern int kptr_restrict;
 
 #ifdef CONFIG_PRINTK
 #define printk_once(fmt, ...)					\
-({								\
-	static bool __section(".data.once") __print_once;	\
-	bool __ret_print_once = !__print_once;			\
-								\
-	if (!__print_once) {					\
-		__print_once = true;				\
-		printk(fmt, ##__VA_ARGS__);			\
-	}							\
-	unlikely(__ret_print_once);				\
-})
+	DO_ONCE_LITE(printk, fmt, ##__VA_ARGS__)
 #define printk_deferred_once(fmt, ...)				\
-({								\
-	static bool __section(".data.once") __print_once;	\
-	bool __ret_print_once = !__print_once;			\
-								\
-	if (!__print_once) {					\
-		__print_once = true;				\
-		printk_deferred(fmt, ##__VA_ARGS__);		\
-	}							\
-	unlikely(__ret_print_once);				\
-})
+	DO_ONCE_LITE(printk_deferred, fmt, ##__VA_ARGS__)
 #else
 #define printk_once(fmt, ...)					\
 	no_printk(fmt, ##__VA_ARGS__)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a6446c03cfbc..8c868e5b4525 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -20,6 +20,7 @@
 #include <linux/irq_work.h>
 #include <linux/workqueue.h>
 #include <linux/ctype.h>
+#include <linux/once.h>
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #include <asm/unistd.h>		/* For NR_SYSCALLS	     */
@@ -98,16 +99,8 @@ enum trace_type {
 #include "trace_entries.h"
 
 /* Use this for memory failure errors */
-#define MEM_FAIL(condition, fmt, ...) ({			\
-	static bool __section(".data.once") __warned;		\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once && !__warned)) {		\
-		__warned = true;				\
-		pr_err("ERROR: " fmt, ##__VA_ARGS__);		\
-	}							\
-	unlikely(__ret_warn_once);				\
-})
+#define MEM_FAIL(condition, fmt, ...)					\
+	DO_ONCE_LITE_IF(condition, pr_err, "ERROR: " fmt, ##__VA_ARGS__)
 
 /*
  * syscalls are special, and need special handling, this is why
-- 
2.31.1.498.g6c1eba8ee3d-goog

