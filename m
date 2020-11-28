Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAF22C70EF
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 22:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389318AbgK1Vt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:58 -0500
Received: from conuserg-09.nifty.com ([210.131.2.76]:40107 "EHLO
        conuserg-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387560AbgK1Tft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 14:35:49 -0500
Received: from grover.RMN.KIBA.LAB.jp (softbank126090211135.bbtec.net [126.90.211.135]) (authenticated)
        by conuserg-09.nifty.com with ESMTP id 0ASJXeQS028710;
        Sun, 29 Nov 2020 04:33:41 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 0ASJXeQS028710
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1606592021;
        bh=jLumgvXrvZOXOwLum8VDFamzZ4g8hoOKUXqB+QzEoCA=;
        h=From:To:Cc:Subject:Date:From;
        b=a03Y7n9C7d/dHHXZ1jz3AFYINn0HlDsQm2lJGA0pKZQ4bJCsNX99LqpbVopvMAFlX
         hc/QOVEnWUjS8P3yUr2mzZqP4mfIfnygFf3Jt1kzXNlYc4alRYYc6DytXa6RVU+CYj
         RoMovrncDjfucSCfllR9iOAVFgueYxy2XAPSOcEzUINlCE85RFG8b2YkvBQXrP/PVc
         kDhXulbieo7rN6tYorDFy0Kjj6BQ2cglNu+VYzP9nzvvACYCz/lWzaT9JgSSL9yOpL
         ndCCWdHK+L/gDNAF2U+HPGomEfrPFb5GWWcP6f67RKlsUSYS6xWprBhQ/m3zCRMOrt
         QVyN+POsrIXmA==
X-Nifty-SrcIP: [126.90.211.135]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com
Subject: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
Date:   Sun, 29 Nov 2020 04:33:35 +0900
Message-Id: <20201128193335.219395-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revert commit cebc04ba9aeb ("add CONFIG_ENABLE_MUST_CHECK").

A lot of warn_unused_result warnings existed in 2006, but until now
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
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
---

Changes in v3:
  - Fix a typo

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

