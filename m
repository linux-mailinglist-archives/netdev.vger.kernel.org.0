Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6BC46AF01
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378237AbhLGAY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:24:56 -0500
Received: from aposti.net ([89.234.176.197]:52468 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378220AbhLGAY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 19:24:56 -0500
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
Subject: [PATCH 2/5] PM: core: Redefine pm_ptr() macro
Date:   Tue,  7 Dec 2021 00:20:59 +0000
Message-Id: <20211207002102.26414-3-paul@crapouillou.net>
In-Reply-To: <20211207002102.26414-1-paul@crapouillou.net>
References: <20211207002102.26414-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pm_ptr() macro was previously conditionally defined, according to
the value of the CONFIG_PM option. This meant that the pointed structure
was either referenced (if CONFIG_PM was set), or never referenced (if
CONFIG_PM was not set), causing it to be detected as unused by the
compiler.

This worked fine, but required the __maybe_unused compiler attribute to
be used to every symbol pointed to by a pointer wrapped with pm_ptr().

We can do better. With this change, the pm_ptr() is now defined the
same, independently of the value of CONFIG_PM. It now uses the (?:)
ternary operator to conditionally resolve to its argument. Since the
condition is known at compile time, the compiler will then choose to
discard the unused symbols, which won't need to be tagged with
__maybe_unused anymore.

This pm_ptr() macro is usually used with pointers to dev_pm_ops
structures created with SIMPLE_DEV_PM_OPS() or similar macros. These do
use a __maybe_unused flag, which is now useless with this change, so it
later can be removed. However in the meantime it causes no harm, and all
the drivers still compile fine with the new pm_ptr() macro.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 include/linux/pm.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 1d8209c09686..b88ac7dcf2a2 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -373,11 +373,7 @@ const struct dev_pm_ops __maybe_unused name = { \
 	SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
 }
 
-#ifdef CONFIG_PM
-#define pm_ptr(_ptr) (_ptr)
-#else
-#define pm_ptr(_ptr) NULL
-#endif
+#define pm_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM), (_ptr))
 
 /*
  * PM_EVENT_ messages
-- 
2.33.0

