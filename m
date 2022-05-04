Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2234351AF18
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357485AbiEDUdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378013AbiEDUdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:33:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B12F4FC66
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA04C61776
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D813C385A4;
        Wed,  4 May 2022 20:29:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dK0vI1Kr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651696183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ReihFPZ40+zlzWSDVKPQqzhj3uP51nGQ6oVA3qbUjH4=;
        b=dK0vI1KrHLqtX6oIN7OmSqJAMWRfmyoTOt/yT5TXzjDq6xdlCa5GFQtvlN6GwI+0EFnNHb
        uqCnHb8vL3RK2zce2R53+hHp4zPmNLqhqtxCbO+aVTwEi40DMJOKcTzOT9EsvueP+aa0YD
        bhJDcr+2jZK/LuwNYgsGFYPXcX2ELSk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0affbf11 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 4 May 2022 20:29:43 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 4/6] wireguard: selftests: restore support for ccache
Date:   Wed,  4 May 2022 22:29:18 +0200
Message-Id: <20220504202920.72908-5-Jason@zx2c4.com>
In-Reply-To: <20220504202920.72908-1-Jason@zx2c4.com>
References: <20220504202920.72908-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLACK autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When moving to non-system toolchains, we inadvertantly killed the
ability to use ccache. So instead, build ccache support into the test
harness directly.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 .../selftests/wireguard/qemu/.gitignore        |  1 +
 .../testing/selftests/wireguard/qemu/Makefile  | 18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/.gitignore b/tools/testing/selftests/wireguard/qemu/.gitignore
index bfa15e6feb2f..42ab9d72b37b 100644
--- a/tools/testing/selftests/wireguard/qemu/.gitignore
+++ b/tools/testing/selftests/wireguard/qemu/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 build/
 distfiles/
+ccache/
diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index 930f59c9e714..e121ef3878af 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -266,6 +266,13 @@ $(info Building for $(CHOST) using $(CBUILD))
 export CROSS_COMPILE := $(CHOST)-
 export PATH := $(TOOLCHAIN_PATH)/bin:$(PATH)
 export CC := $(CHOST)-gcc
+CCACHE_PATH := $(shell which ccache 2>/dev/null)
+ifneq ($(CCACHE_PATH),)
+export KBUILD_BUILD_TIMESTAMP := Fri Jun  5 15:58:00 CEST 2015
+export PATH := $(TOOLCHAIN_PATH)/bin/ccache:$(PATH)
+export CCACHE_SLOPPINESS := file_macro,time_macros
+export CCACHE_DIR ?= $(PWD)/ccache
+endif
 
 USERSPACE_DEPS := $(TOOLCHAIN_PATH)/.installed $(TOOLCHAIN_PATH)/$(CHOST)/include/linux/.installed
 
@@ -329,6 +336,10 @@ $(TOOLCHAIN_PATH)/.installed: $(TOOLCHAIN_TAR)
 	mkdir -p $(BUILD_PATH)
 	flock -s $<.lock tar -C $(BUILD_PATH) -xf $<
 	$(STRIP) -s $(TOOLCHAIN_PATH)/$(CHOST)/lib/libc.so
+ifneq ($(CCACHE_PATH),)
+	mkdir -p $(TOOLCHAIN_PATH)/bin/ccache
+	ln -s $(CCACHE_PATH) $(TOOLCHAIN_PATH)/bin/ccache/$(CC)
+endif
 	touch $@
 
 $(IPERF_PATH)/.installed: $(IPERF_TAR)
@@ -421,8 +432,13 @@ clean:
 distclean: clean
 	rm -rf $(DISTFILES_PATH)
 
+cacheclean: clean
+ifneq ($(CCACHE_DIR),)
+	rm -rf $(CCACHE_DIR)
+endif
+
 menuconfig: $(KERNEL_BUILD_PATH)/.config
 	$(MAKE) -C $(KERNEL_PATH) O=$(KERNEL_BUILD_PATH) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
 
-.PHONY: qemu build clean distclean menuconfig
+.PHONY: qemu build clean distclean cacheclean menuconfig
 .DELETE_ON_ERROR:
-- 
2.35.1

