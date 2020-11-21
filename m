Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB2E2BC1D9
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 20:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgKUTxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 14:53:36 -0500
Received: from condef-02.nifty.com ([202.248.20.67]:51719 "EHLO
        condef-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbgKUTxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 14:53:35 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2020 14:53:34 EST
Received: from conuserg-07.nifty.com ([10.126.8.70])by condef-02.nifty.com with ESMTP id 0ALJiGEX025043;
        Sun, 22 Nov 2020 04:44:43 +0900
Received: from grover.flets-west.jp (softbank126090211135.bbtec.net [126.90.211.135]) (authenticated)
        by conuserg-07.nifty.com with ESMTP id 0ALJhlQW018082;
        Sun, 22 Nov 2020 04:43:48 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com 0ALJhlQW018082
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1605987828;
        bh=kMMLEunEMIDisWEYWqEwz2gIWOM0bj/iT9P6aQkYuAA=;
        h=From:To:Cc:Subject:Date:From;
        b=Ed4YR6jCsEtGEDLmMjHzJsPekt449R4rvo+kLcDiqhConMsBK7GnZj47QGbL9Zfvz
         F7JN4vuT9U42wImHJxZC+JkSuW358QGOQsiIWcKKZt0X5K85iY4qxq4urVA3MoG+dJ
         HdGOZZ9UcddBdtjwbgdME9cB6bRr9PPT0YA3ZgBqxHvync6gU9yfgKSoCXMC2O6bP5
         E5JpIg82ZiGWVerVt3xqwloF+WbkRVv6L5JjdF38neunrDIRCBP34+JIuLX3KARh2+
         gpLzk4lSZFr22g9gqJGBDP1+T6Jz7yNfHWOCtfFIqtyA3Z3LpAWQWN7nt/nJuhj0TL
         h8TjAVnBvm7AA==
X-Nifty-SrcIP: [126.90.211.135]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com
Subject: [PATCH] compiler_attribute: remove CONFIG_ENABLE_MUST_CHECK
Date:   Sun, 22 Nov 2020 04:43:39 +0900
Message-Id: <20201121194339.52290-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revert commit cebc04ba9aeb ("add CONFIG_ENABLE_MUST_CHECK").

A lot of warn_unused_result warnings existed in 2006, but until now
they have been fixed thanks to people doing allmodconfig tests.

Our goal is to always enable __must_check where appreciate, so this
CONFIG option is no longer needed.

I see a lot of defconfig (arch/*/configs/*_defconfig) files having:

    # CONFIG_ENABLE_MUST_CHECK is not set

I did not touch them for now since it would be a big churn. If arch
maintainers want to clean them up, please go ahead.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 include/linux/compiler_types.h                      | 4 ----
 lib/Kconfig.debug                                   | 8 --------
 tools/testing/selftests/wireguard/qemu/debug.config | 1 -
 3 files changed, 13 deletions(-)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index ac3fa37a84f9..02f6d3fbad9d 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -110,11 +110,7 @@ struct ftrace_likely_data {
 	unsigned long			constant;
 };
 
-#ifdef CONFIG_ENABLE_MUST_CHECK
 #define __must_check		__attribute__((__warn_unused_result__))
-#else
-#define __must_check
-#endif
 
 #if defined(CC_USING_HOTPATCH)
 #define notrace			__attribute__((hotpatch(0, 0)))
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
2.25.1

