Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B702392318
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 01:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbhEZXPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 19:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbhEZXPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 19:15:19 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE44C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 16:13:47 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id k4so2893623qkd.0
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 16:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/m6YkZ8Xlr0WgQm7+kY6fbbRbbu0l+LUpzrt8ABt4d8=;
        b=Vx/ro1tfE+dD2R0BVJC7mjU/IlXws4YjCZ2kAb5AlU5N0HQCL1SqRvs+Gzy5Ml8T+5
         5R41x2Z7Q9xnKGvKEAGO2a8tteFP0GpnP53sWWkImo/mn87GLE0H6f/3KZhZ7Ld/SuB/
         oXHWoVZf7fWi9VcXoldAHBc9QCr0Ki9Cv1vq6EcP65ZdeCLQla+w30I7RScSbEIi0+0F
         GOl75nuHK9iqhlM5dtOn7myKqELPX0oTNw0R+F5JmJ8SPWCEEOUUIHkGbe7ww/YKfRas
         sO8OUaFQKyMcX0DcMgMN8lwngCPz39cLBvv5dCTWLG+McPiyp5H3dl6L0nfhIneX1mEJ
         +tDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/m6YkZ8Xlr0WgQm7+kY6fbbRbbu0l+LUpzrt8ABt4d8=;
        b=mYvxA6W1C9uge75FITPjrORCF+bS+A2NtEjLtTmgd1CFTrsT48kWAr7OS3Fap1X8EU
         1xalGW7EnunGtBo6/jsK/Fb3xvX2fQwvNDTgbDGYOGhZc851a4yRb75KY7C0MFR5Pzn2
         NxoZLqdaViB7v/x9JUAczeEa5fXhp+nzGqOxvYHiIttBFzGqLVRNo+ToVesj8FEbXmtd
         mBd2BrGttfPsKzP33XvIZKiWlcV6vkZLJrhY3CwR9EpELq7rtNjg5bIj2WqEOtIi7Qi8
         K42YmCIGGeQ0MhXsZ3WkpwBmTswtQ1mYs4n6GJdOZ4wxZt8FypKThAlXVQ+BQh0fypMY
         W7ng==
X-Gm-Message-State: AOAM5302xF4d7aYsGrlSnsTADIu+omvuax61IjjnAct8AsrBUZQHr3LU
        AYHKeZXf9tin9UbRNLJiUmXwYhVJmHw=
X-Google-Smtp-Source: ABdhPJwlmc3XzP1RFiKmgSDF6eBvtt8wYXpQrFsV8F6Ltr4IAHnX9jkXyEuB9V3yLOyp/EubDBkyJg==
X-Received: by 2002:a37:a683:: with SMTP id p125mr554702qke.332.1622070826607;
        Wed, 26 May 2021 16:13:46 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:557d:8eb6:c0af:d526])
        by smtp.gmail.com with ESMTPSA id k24sm290476qtq.49.2021.05.26.16.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 16:13:46 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        kernel test robot <lkp@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: [PATCH net-next,v2,1/2] once: implement DO_ONCE_LITE for non-fast-path "do once" functionality
Date:   Wed, 26 May 2021 19:13:35 -0400
Message-Id: <20210526231336.2772011-2-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
In-Reply-To: <20210526231336.2772011-1-tannerlove.kernel@gmail.com>
References: <20210526231336.2772011-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Certain uses of "do once" functionality reside outside of fast path,
and so do not require jump label patching via static keys, making
existing DO_ONCE undesirable in such cases.

Replace uses of __section(".data.once") with DO_ONCE_LITE(_IF)?

[ i386 build warnings ]
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 fs/xfs/xfs_message.h      | 13 +++----------
 include/asm-generic/bug.h | 37 +++++++------------------------------
 include/linux/once_lite.h | 24 ++++++++++++++++++++++++
 include/linux/printk.h    | 23 +++--------------------
 kernel/trace/trace.h      | 13 +++----------
 5 files changed, 40 insertions(+), 70 deletions(-)
 create mode 100644 include/linux/once_lite.h

diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 3c392b1512ac..5daf73f21509 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -2,6 +2,8 @@
 #ifndef __XFS_MESSAGE_H
 #define __XFS_MESSAGE_H 1
 
+#include <linux/once_lite.h>
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
index b402494883b6..bafc51f483c4 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler.h>
 #include <linux/instrumentation.h>
+#include <linux/once_lite.h>
 
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
diff --git a/include/linux/once_lite.h b/include/linux/once_lite.h
new file mode 100644
index 000000000000..861e606b820f
--- /dev/null
+++ b/include/linux/once_lite.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_ONCE_LITE_H
+#define _LINUX_ONCE_LITE_H
+
+#include <linux/types.h>
+
+/* Call a function once. Similar to DO_ONCE(), but does not use jump label
+ * patching via static keys.
+ */
+#define DO_ONCE_LITE(func, ...)						\
+	DO_ONCE_LITE_IF(true, func, ##__VA_ARGS__)
+#define DO_ONCE_LITE_IF(condition, func, ...)				\
+	({								\
+		static bool __section(".data.once") __already_done;	\
+		bool __ret_do_once = !!(condition);			\
+									\
+		if (unlikely(__ret_do_once && !__already_done)) {	\
+			__already_done = true;				\
+			func(__VA_ARGS__);				\
+		}							\
+		unlikely(__ret_do_once);				\
+	})
+
+#endif /* _LINUX_ONCE_LITE_H */
diff --git a/include/linux/printk.h b/include/linux/printk.h
index fe7eb2351610..885379a1c9a1 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -8,6 +8,7 @@
 #include <linux/linkage.h>
 #include <linux/cache.h>
 #include <linux/ratelimit_types.h>
+#include <linux/once_lite.h>
 
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
index cd80d046c7a5..d5d8c088a55d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -20,6 +20,7 @@
 #include <linux/irq_work.h>
 #include <linux/workqueue.h>
 #include <linux/ctype.h>
+#include <linux/once_lite.h>
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #include <asm/unistd.h>		/* For NR_SYSCALLS	     */
@@ -99,16 +100,8 @@ enum trace_type {
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
2.32.0.rc0.204.g9fa02ecfa5-goog

