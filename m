Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956A3356044
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbhDGAZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236278AbhDGAZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88CA86135D;
        Wed,  7 Apr 2021 00:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617755127;
        bh=ZZSSDKuw6U60/IUXxntLjQiuJTcF+qL7DzyhsvdkvJE=;
        h=From:To:Cc:Subject:Date:From;
        b=tO88TaR1IV5TWFmXkRY2MHhwc/VKlnvB6C0fJbErAASjkQ+EWnFr06TvxGp7Ds8E/
         27qz4E5Nq1JQ5Wojh0Npo0nxwu2GCwgCtRm88kDuTgiWoJRygna8huB7tqiPZqEKvq
         vJBydLpuZ8WDWuN2a86n9tx/4juy6ZRKJNVul/HVizfhCG32bGiDgCjhxFyIn+Gyk0
         yZ/PYoengNzGLpCIgAuIKadBuUjOgLNEbp1JxB6a4oV8yHhzF2djnMULV/XpEfeD8Y
         tqTioAkMDzIsQoDkcXxTTKqDVvBif7XP5PBEYc+QFq4XwKLyZIV0pZGnHArgO0iyzR
         BKk9URX0hsezA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH kbuild] Makefile.extrawarn: disable -Woverride-init in W=1
Date:   Wed,  7 Apr 2021 02:24:50 +0200
Message-Id: <20210407002450.10015-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The -Wextra flag enables -Woverride-init in newer versions of GCC.

This causes the compiler to warn when a value is written twice in a
designated initializer, for example:
  int x[1] = {
    [0] = 3,
    [0] = 3,
  };

Note that for clang, this was disabled from the beginning with
-Wno-initializer-overrides in commit a1494304346a3 ("kbuild: add all
Clang-specific flags unconditionally").

This prevents us from implementing complex macros for compile-time
initializers.

For example a macro of the form INITIALIZE_BITMAP(bits...) that can be
used as
  static DECLARE_BITMAP(bm, 64) = INITIALIZE_BITMAP(0, 1, 32, 33);
can only be implemented by allowing a designated initializer to
initialize the same members multiple times (because the compiler
complains even if the multiple initializations initialize to the same
value).

Disable the -Woverride-init flag.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
---
 scripts/Makefile.extrawarn | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index d53825503874..cf7bc1eec5e3 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -36,6 +36,7 @@ KBUILD_CFLAGS += $(call cc-option, -Wstringop-truncation)
 KBUILD_CFLAGS += -Wno-missing-field-initializers
 KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -Wno-type-limits
+KBUILD_CFLAGS += $(call cc-disable-warning, override-init)
 
 KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN1
 
-- 
2.26.2

