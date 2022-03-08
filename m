Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B454D1707
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 13:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346744AbiCHMPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 07:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346732AbiCHMPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 07:15:50 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A46A43ED1;
        Tue,  8 Mar 2022 04:14:54 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: aratiu)
        with ESMTPSA id EC43A1F43C2C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1646741693;
        bh=5+4CFM6veuq5rDnjMnbblwZsgeeLINo0x7U43XEkG9c=;
        h=From:To:Cc:Subject:Date:From;
        b=IuRYrUkUF0SCi0ER2nCHqEw02YkcL/vPTUhWSs79ZyitkMk0dynGcY39jBfxLIiaZ
         hmf9tTBEZf1t1e6xosUT5h1Su28aKNtYQeAP2kKvAAfO5dHgAslutstLuwA3QIQNUN
         zkRYUuUbl4pZTho63yPNAiMvo/5ikHBr/CvcBxefFVs2Jtj14kwJdWJwYO5WJxRZI/
         r6eHwi2RPudIMXeXHSAaMlntMUlBToduBaM0nYcDWprzdmx+9zp5m4QFPSnBZTqiyn
         uQvI+dkLx6F0gD6mHFxqn6mS0ilxypk2AS+BR1mtR2DAR1CtxcG1+bV5y+GHU3ltKx
         25knDK62+s5UQ==
From:   Adrian Ratiu <adrian.ratiu@collabora.com>
To:     netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kernel@collabora.com,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Manoj Gupta <manojgupta@chromium.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH bpf v2] tools: fix unavoidable GCC call in Clang builds
Date:   Tue,  8 Mar 2022 14:14:28 +0200
Message-Id: <20220308121428.81735-1-adrian.ratiu@collabora.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ChromeOS and Gentoo we catch any unwanted mixed Clang/LLVM
and GCC/binutils usage via toolchain wrappers which fail builds.
This has revealed that GCC is called unconditionally in Clang
configured builds to populate GCC_TOOLCHAIN_DIR.

Allow the user to override CLANG_CROSS_FLAGS to avoid the GCC
call - in our case we set the var directly in the ebuild recipe.

In theory Clang could be able to autodetect these settings so
this logic could be removed entirely, but in practice as the
commit cebdb7374577 ("tools: Help cross-building with clang")
mentions, this does not always work, so giving distributions
more control to specify their flags & sysroot is beneficial.

Suggested-by: Manoj Gupta <manojgupta@chromium.com>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Adrian Ratiu <adrian.ratiu@collabora.com>
---
Changes in v2:
  * Replaced variable override GCC_TOOLCHAIN_DIR -> CLANG_CROSS_FLAGS
---
 tools/scripts/Makefile.include | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 79d102304470..b9b1deacc4eb 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -89,6 +89,9 @@ ifeq ($(CC_NO_CLANG), 1)
 EXTRA_WARNINGS += -Wstrict-aliasing=3
 
 else ifneq ($(CROSS_COMPILE),)
+# allow userspace to override CLANG_CROSS_FLAGS to specify their own
+# sysroots and flags or to avoid the GCC call in pure Clang builds
+ifeq ($(CLANG_CROSS_FLAGS),)
 CLANG_CROSS_FLAGS := --target=$(notdir $(CROSS_COMPILE:%-=%))
 GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)gcc 2>/dev/null))
 ifneq ($(GCC_TOOLCHAIN_DIR),)
@@ -96,6 +99,7 @@ CLANG_CROSS_FLAGS += --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
 CLANG_CROSS_FLAGS += --sysroot=$(shell $(CROSS_COMPILE)gcc -print-sysroot)
 CLANG_CROSS_FLAGS += --gcc-toolchain=$(realpath $(GCC_TOOLCHAIN_DIR)/..)
 endif # GCC_TOOLCHAIN_DIR
+endif # CLANG_CROSS_FLAGS
 CFLAGS += $(CLANG_CROSS_FLAGS)
 AFLAGS += $(CLANG_CROSS_FLAGS)
 endif # CROSS_COMPILE
-- 
2.35.1

