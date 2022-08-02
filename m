Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEA6587CBA
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbiHBM4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236793AbiHBM4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:56:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C0912616
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 05:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E20B7B81EFC
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 12:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044CBC433D6;
        Tue,  2 Aug 2022 12:56:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kddcOKjp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1659444992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dHBUFAj2/ZzR0/nMiac9EsPHiKtUrJjdR+I+mamrQM4=;
        b=kddcOKjpwfe4NWqJ615n+BAiToAHjLhmf0rYJL/RReRdzdWB6ttQsWKnEdUBDryi+ZS2G6
        EKYt/X8ZzwMlRLwwXf3IbufAwr5Yxmfypz3lBMA9I6TQJsD15WErvv+QDdiqp9rDrtMW1M
        YopOxKjdt5yHM9dUeesWWcB0ha8difs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 986f0f7c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 2 Aug 2022 12:56:32 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kuba@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH next-next 4/4] wireguard: selftests: support UML
Date:   Tue,  2 Aug 2022 14:56:13 +0200
Message-Id: <20220802125613.340848-5-Jason@zx2c4.com>
In-Reply-To: <20220802125613.340848-1-Jason@zx2c4.com>
References: <20220802125613.340848-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This shoud open up various possibilities like time travel execution, and
is also just another platform to help shake out bugs.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/Makefile | 17 ++++++++++++++++-
 .../selftests/wireguard/qemu/arch/um.config     |  3 +++
 2 files changed, 19 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/um.config

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index 9700358e4337..fda76282d34b 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -248,8 +248,13 @@ QEMU_MACHINE := -cpu host,accel=kvm -machine s390-ccw-virtio -append $(KERNEL_CM
 else
 QEMU_MACHINE := -cpu max -machine s390-ccw-virtio -append $(KERNEL_CMDLINE)
 endif
+else ifeq ($(ARCH),um)
+CHOST := $(HOST_ARCH)-linux-musl
+KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/vmlinux
+KERNEL_ARCH := um
+KERNEL_CMDLINE := $(shell sed -n 's/CONFIG_CMDLINE=\(.*\)/\1/p' arch/um.config)
 else
-$(error I only build: x86_64, i686, arm, armeb, aarch64, aarch64_be, mips, mipsel, mips64, mips64el, powerpc64, powerpc64le, powerpc, m68k, riscv64, riscv32, s390x)
+$(error I only build: x86_64, i686, arm, armeb, aarch64, aarch64_be, mips, mipsel, mips64, mips64el, powerpc64, powerpc64le, powerpc, m68k, riscv64, riscv32, s390x, um)
 endif
 
 TOOLCHAIN_FILENAME := $(CHOST)-cross.tgz
@@ -262,7 +267,9 @@ $(eval $(call file_download,$(TOOLCHAIN_FILENAME),$(TOOLCHAIN_DIR),,$(DISTFILES_
 STRIP := $(CHOST)-strip
 CROSS_COMPILE_FLAG := --build=$(CBUILD) --host=$(CHOST)
 $(info Building for $(CHOST) using $(CBUILD))
+ifneq ($(ARCH),um)
 export CROSS_COMPILE := $(CHOST)-
+endif
 export PATH := $(TOOLCHAIN_PATH)/bin:$(PATH)
 export CC := $(CHOST)-gcc
 CCACHE_PATH := $(shell which ccache 2>/dev/null)
@@ -279,6 +286,7 @@ comma := ,
 build: $(KERNEL_BZIMAGE)
 qemu: $(KERNEL_BZIMAGE)
 	rm -f $(BUILD_PATH)/result
+ifneq ($(ARCH),um)
 	timeout --foreground 20m qemu-system-$(QEMU_ARCH) \
 		-nodefaults \
 		-nographic \
@@ -291,6 +299,13 @@ qemu: $(KERNEL_BZIMAGE)
 		-no-reboot \
 		-monitor none \
 		-kernel $<
+else
+	timeout --foreground 20m $< \
+		$(KERNEL_CMDLINE) \
+		mem=$$(grep -q CONFIG_DEBUG_KMEMLEAK=y $(KERNEL_BUILD_PATH)/.config && echo 1G || echo 256M) \
+		noreboot \
+		con1=fd:51 51>$(BUILD_PATH)/result </dev/null 2>&1 | cat
+endif
 	grep -Fq success $(BUILD_PATH)/result
 
 $(BUILD_PATH)/init-cpio-spec.txt: $(TOOLCHAIN_PATH)/.installed $(BUILD_PATH)/init
diff --git a/tools/testing/selftests/wireguard/qemu/arch/um.config b/tools/testing/selftests/wireguard/qemu/arch/um.config
new file mode 100644
index 000000000000..c8b229e0810e
--- /dev/null
+++ b/tools/testing/selftests/wireguard/qemu/arch/um.config
@@ -0,0 +1,3 @@
+CONFIG_64BIT=y
+CONFIG_CMDLINE="wg.success=tty1 panic_on_warn=1"
+CONFIG_FRAME_WARN=1280
-- 
2.35.1

