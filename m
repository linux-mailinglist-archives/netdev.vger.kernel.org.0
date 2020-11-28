Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F40F2C708D
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 19:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733219AbgK1SAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 13:00:25 -0500
Received: from condef-03.nifty.com ([202.248.20.68]:63837 "EHLO
        condef-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729846AbgK1R6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 12:58:17 -0500
Received: from conuserg-08.nifty.com ([10.126.8.71])by condef-03.nifty.com with ESMTP id 0AS8lwls020580;
        Sat, 28 Nov 2020 17:48:24 +0900
Received: from localhost.localdomain (softbank126090211135.bbtec.net [126.90.211.135]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 0AS8klCf024281;
        Sat, 28 Nov 2020 17:46:47 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 0AS8klCf024281
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1606553208;
        bh=3ZxQhTM55h3T1rci5XqtW4G9136NvehcsYvGcG3kcgc=;
        h=From:To:Cc:Subject:Date:From;
        b=SElIFciYjQNJuulProNcUJ6g9mjA6O9qq6ZNcU+lGQxM4xJ2H6GbcjQChrwQVdtMy
         43+MEC/tZn52+NUzUIE+ZDL1Cw8daDnSbuD+PgRrWJADV7BHkydbLYUfzOWruBqV56
         Vhf4Hes+x+8MiHQxt2sU5gyJMHCYXBwmEulcrBlxZaqCA61wi+yO7X9URuIez0xvwu
         kdGZNqcJ8SGzfFt0E0i9BVkt1t+vMk/FuamGdUGmFlHBuC6fnWAGf7gS1t2qNTF0PH
         pvten505D/ZiSdoqoEPIG4NNVRLMudKUr6O1qbSoZ4zLx2t8m2rp2X3Ktut9GMNRh3
         7sqLNV4Grz0eA==
X-Nifty-SrcIP: [126.90.211.135]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com
Subject: [PATCH v2] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
Date:   Sat, 28 Nov 2020 17:46:39 +0900
Message-Id: <20201128084639.149153-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revert commit cebc04ba9aeb ("add CONFIG_ENABLE_MUST_CHECK").

A lot of warn_unused_result wearings existed in 2006, but until now
they have been fixed thanks to people doing allmodconfig tests.

Our goal is to always enable __must_check where appropriate, so this
CONFIG option is no longer needed.

I see a lot of defconfig (arch/*/configs/*_defconfig) files having:

    # CONFIG_ENABLE_MUST_CHECK is not set

I did not touch them for now since it would be a big churn. If arch
maintainers want to clean them up, please go ahead.

While I was here, I also moved __must_check to compiler_attributes.h
from compiler_types.h

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

Changes in v2:
  - Move __must_check to compiler_attributes.h

 include/linux/compiler_attributes.h                 | 7 +++++++
 include/linux/compiler_types.h                      | 6 ------
 lib/Kconfig.debug                                   | 8 --------
 tools/testing/selftests/wireguard/qemu/debug.config | 1 -
 4 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index b2a3f4f641a7..5f3b7edad1a7 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -171,6 +171,13 @@
  */
 #define __mode(x)                       __attribute__((__mode__(x)))
 
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-warn_005funused_005fresult-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#nodiscard-warn-unused-result
+ *
+ */
+#define __must_check                    __attribute__((__warn_unused_result__))
+
 /*
  * Optional: only supported since gcc >= 7
  *
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index ac3fa37a84f9..7ef20d1a6c28 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -110,12 +110,6 @@ struct ftrace_likely_data {
 	unsigned long			constant;
 };
 
-#ifdef CONFIG_ENABLE_MUST_CHECK
-#define __must_check		__attribute__((__warn_unused_result__))
-#else
-#define __must_check
-#endif
-
 #if defined(CC_USING_HOTPATCH)
 #define notrace			__attribute__((hotpatch(0, 0)))
 #elif defined(CC_USING_PATCHABLE_FUNCTION_ENTRY)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c789b39ed527..cb8ef4fd0d02 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -286,14 +286,6 @@ config GDB_SCRIPTS
 
 endif # DEBUG_INFO
 
-config ENABLE_MUST_CHECK
-	bool "Enable __must_check logic"
-	default y
-	help
-	  Enable the __must_check logic in the kernel build.  Disable this to
-	  suppress the "warning: ignoring return value of 'foo', declared with
-	  attribute warn_unused_result" messages.
-
 config FRAME_WARN
 	int "Warn for stack frames larger than"
 	range 0 8192
diff --git a/tools/testing/selftests/wireguard/qemu/debug.config b/tools/testing/selftests/wireguard/qemu/debug.config
index b50c2085c1ac..fe07d97df9fa 100644
--- a/tools/testing/selftests/wireguard/qemu/debug.config
+++ b/tools/testing/selftests/wireguard/qemu/debug.config
@@ -1,5 +1,4 @@
 CONFIG_LOCALVERSION="-debug"
-CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_FRAME_POINTER=y
 CONFIG_STACK_VALIDATION=y
 CONFIG_DEBUG_KERNEL=y
-- 
2.27.0

