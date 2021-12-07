Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E52146AF07
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378291AbhLGAZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:25:07 -0500
Received: from aposti.net ([89.234.176.197]:52486 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378328AbhLGAZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 19:25:03 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <jic23@kernel.org>
Cc:     list@opendingux.net, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 3/5] PM: core: Add new *_PM_OPS macros, deprecate old ones
Date:   Tue,  7 Dec 2021 00:21:00 +0000
Message-Id: <20211207002102.26414-4-paul@crapouillou.net>
In-Reply-To: <20211207002102.26414-1-paul@crapouillou.net>
References: <20211207002102.26414-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces the following macros:
SYSTEM_SLEEP_PM_OPS()
LATE_SYSTEM_SLEEP_PM_OPS()
NOIRQ_SYSTEM_SLEEP_PM_OPS()
RUNTIME_PM_OPS()

These new macros are very similar to their SET_*_PM_OPS() equivalent.
They however differ in the fact that the callbacks they set will always
be seen as referenced by the compiler. This means that the callback
functions don't need to be wrapped with a #ifdef CONFIG_PM guard, or
tagged with __maybe_unused, to prevent the compiler from complaining
about unused static symbols. The compiler will then simply evaluate at
compile time whether or not these symbols are dead code.

The callbacks that are only useful with CONFIG_PM_SLEEP is enabled, are
now also wrapped with a new pm_sleep_ptr() macro, which is inspired from
pm_ptr(). This is needed for drivers that use different callbacks for
sleep and runtime PM, to handle the case where CONFIG_PM is set and
CONFIG_PM_SLEEP is not.

This commit also deprecates the following macros:
SIMPLE_DEV_PM_OPS()
UNIVERSAL_DEV_PM_OPS()

And introduces the following macros:
DEFINE_SIMPLE_DEV_PM_OPS()
DEFINE_UNIVERSAL_DEV_PM_OPS()

These macros are similar to the functions they were created to replace,
with the following differences:
- They use the new macros introduced above, and as such always reference
  the provided callback functions;
- They are not tagged with __maybe_unused. They are meant to be used
  with pm_ptr() or pm_sleep_ptr() for DEFINE_UNIVERSAL_DEV_PM_OPS() and
  DEFINE_SIMPLE_DEV_PM_OPS() respectively.
- They declare the symbol static, since every driver seems to do that
  anyway; and if a non-static use-case is needed an indirection pointer
  could be used.

The point of this change, is to progressively switch from a code model
where PM callbacks are all protected behind CONFIG_PM guards, to a code
model where the PM callbacks are always seen by the compiler, but
discarded if not used.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 include/linux/pm.h | 74 +++++++++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index b88ac7dcf2a2..fc9691cb01b4 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -300,47 +300,59 @@ struct dev_pm_ops {
 	int (*runtime_idle)(struct device *dev);
 };
 
+#define SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	.suspend = pm_sleep_ptr(suspend_fn), \
+	.resume = pm_sleep_ptr(resume_fn), \
+	.freeze = pm_sleep_ptr(suspend_fn), \
+	.thaw = pm_sleep_ptr(resume_fn), \
+	.poweroff = pm_sleep_ptr(suspend_fn), \
+	.restore = pm_sleep_ptr(resume_fn),
+
+#define LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	.suspend_late = pm_sleep_ptr(suspend_fn), \
+	.resume_early = pm_sleep_ptr(resume_fn), \
+	.freeze_late = pm_sleep_ptr(suspend_fn), \
+	.thaw_early = pm_sleep_ptr(resume_fn), \
+	.poweroff_late = pm_sleep_ptr(suspend_fn), \
+	.restore_early = pm_sleep_ptr(resume_fn),
+
+#define NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	.suspend_noirq = pm_sleep_ptr(suspend_fn), \
+	.resume_noirq = pm_sleep_ptr(resume_fn), \
+	.freeze_noirq = pm_sleep_ptr(suspend_fn), \
+	.thaw_noirq = pm_sleep_ptr(resume_fn), \
+	.poweroff_noirq = pm_sleep_ptr(suspend_fn), \
+	.restore_noirq = pm_sleep_ptr(resume_fn),
+
+#define RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
+	.runtime_suspend = suspend_fn, \
+	.runtime_resume = resume_fn, \
+	.runtime_idle = idle_fn,
+
 #ifdef CONFIG_PM_SLEEP
 #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
-	.suspend = suspend_fn, \
-	.resume = resume_fn, \
-	.freeze = suspend_fn, \
-	.thaw = resume_fn, \
-	.poweroff = suspend_fn, \
-	.restore = resume_fn,
+	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #else
 #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #endif
 
 #ifdef CONFIG_PM_SLEEP
 #define SET_LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
-	.suspend_late = suspend_fn, \
-	.resume_early = resume_fn, \
-	.freeze_late = suspend_fn, \
-	.thaw_early = resume_fn, \
-	.poweroff_late = suspend_fn, \
-	.restore_early = resume_fn,
+	LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #else
 #define SET_LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #endif
 
 #ifdef CONFIG_PM_SLEEP
 #define SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
-	.suspend_noirq = suspend_fn, \
-	.resume_noirq = resume_fn, \
-	.freeze_noirq = suspend_fn, \
-	.thaw_noirq = resume_fn, \
-	.poweroff_noirq = suspend_fn, \
-	.restore_noirq = resume_fn,
+	NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #else
 #define SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #endif
 
 #ifdef CONFIG_PM
 #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
-	.runtime_suspend = suspend_fn, \
-	.runtime_resume = resume_fn, \
-	.runtime_idle = idle_fn,
+	RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
 #else
 #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
 #endif
@@ -349,9 +361,9 @@ struct dev_pm_ops {
  * Use this if you want to use the same suspend and resume callbacks for suspend
  * to RAM and hibernation.
  */
-#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
-const struct dev_pm_ops __maybe_unused name = { \
-	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+#define DEFINE_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
+static const struct dev_pm_ops name = { \
+	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 }
 
 /*
@@ -367,6 +379,19 @@ const struct dev_pm_ops __maybe_unused name = { \
  * .resume_early(), to the same routines as .runtime_suspend() and
  * .runtime_resume(), respectively (and analogously for hibernation).
  */
+#define DEFINE_UNIVERSAL_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
+static const struct dev_pm_ops name = { \
+	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
+}
+
+/* Deprecated. Use DEFINE_SIMPLE_DEV_PM_OPS() instead. */
+#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
+const struct dev_pm_ops __maybe_unused name = { \
+	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+}
+
+/* Deprecated. Use DEFINE_UNIVERSAL_DEV_PM_OPS() instead. */
 #define UNIVERSAL_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
 const struct dev_pm_ops __maybe_unused name = { \
 	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
@@ -374,6 +399,7 @@ const struct dev_pm_ops __maybe_unused name = { \
 }
 
 #define pm_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM), (_ptr))
+#define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
 
 /*
  * PM_EVENT_ messages
-- 
2.33.0

