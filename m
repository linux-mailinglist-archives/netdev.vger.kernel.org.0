Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E01151AF17
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378018AbiEDUdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378016AbiEDUdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:33:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23C04FC60
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35027B828EC
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC7AC385A4;
        Wed,  4 May 2022 20:29:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="O1YqCe1V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651696181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q6MKrl0z+1xHYEI4m1Cyxx+snm1GtCehAoagwuCiTFE=;
        b=O1YqCe1VKO2p97DrwdGsQvWHs24kUazo3/M4sz5ii9+9s/qjh7pcjm3o7eMVRVqdw9DD/J
        qI3YZmI4yPpUYOE9bBAGGCH0DLDv0AhhVF3n3/i4odr6zlOGWOuz/a/zve9dZSZLwYu9Vp
        OTzrfteWR1k1sgLaMfM8MeLn0SgufUw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e307cec8 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 4 May 2022 20:29:41 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 3/6] wireguard: selftests: use newer toolchains to fill out architectures
Date:   Wed,  4 May 2022 22:29:17 +0200
Message-Id: <20220504202920.72908-4-Jason@zx2c4.com>
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

Rather than relying on the system to have cross toolchains available,
simply download musl.cc's ones and use that libc.so, and then we use it
to fill in a few missing platforms, such as riscv64, riscv64, powerpc64,
and s390x.

Since riscv doesn't have a second serial port in its device description,
we have to use virtio's vport. This is actually the same situation on
ARM, but we were previously hacking QEMU up to work around this, which
required a custom QEMU. Instead just do the vport trick on ARM too.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 .../testing/selftests/wireguard/qemu/Makefile | 169 ++++++++++++------
 .../wireguard/qemu/arch/aarch64.config        |   5 +-
 .../wireguard/qemu/arch/aarch64_be.config     |   5 +-
 .../selftests/wireguard/qemu/arch/arm.config  |   5 +-
 .../wireguard/qemu/arch/armeb.config          |   5 +-
 .../wireguard/qemu/arch/powerpc64.config      |  13 ++
 .../wireguard/qemu/arch/riscv32.config        |  12 ++
 .../wireguard/qemu/arch/riscv64.config        |  12 ++
 .../wireguard/qemu/arch/s390x.config          |   6 +
 9 files changed, 169 insertions(+), 63 deletions(-)
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/powerpc64.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/riscv32.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/riscv64.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/s390x.config

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index 4bdd6c1a19d3..930f59c9e714 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -4,26 +4,24 @@
 
 PWD := $(shell pwd)
 
-CHOST := $(shell gcc -dumpmachine)
-HOST_ARCH := $(firstword $(subst -, ,$(CHOST)))
-ifneq (,$(ARCH))
-CBUILD := $(subst -gcc,,$(lastword $(subst /, ,$(firstword $(wildcard $(foreach bindir,$(subst :, ,$(PATH)),$(bindir)/$(ARCH)-*-gcc))))))
-ifeq (,$(CBUILD))
-$(error The toolchain for $(ARCH) is not installed)
-endif
-else
-CBUILD := $(CHOST)
-ARCH := $(firstword $(subst -, ,$(CBUILD)))
-endif
-
 # Set these from the environment to override
 KERNEL_PATH ?= $(PWD)/../../../../..
 BUILD_PATH ?= $(PWD)/build/$(ARCH)
 DISTFILES_PATH ?= $(PWD)/distfiles
 NR_CPUS ?= 4
+ARCH ?=
+CBUILD := $(shell gcc -dumpmachine)
+HOST_ARCH := $(firstword $(subst -, ,$(CBUILD)))
+ifeq ($(ARCH),)
+ARCH := $(HOST_ARCH)
+endif
 
 MIRROR := https://download.wireguard.com/qemu-test/distfiles/
 
+KERNEL_BUILD_PATH := $(BUILD_PATH)/kernel$(if $(findstring yes,$(DEBUG_KERNEL)),-debug)
+rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
+WIREGUARD_SOURCES := $(call rwildcard,$(KERNEL_PATH)/drivers/net/wireguard/,*)
+
 default: qemu
 
 # variable name, tarball project name, version, tarball extension, default URI base
@@ -36,12 +34,11 @@ $(call file_download,$$($(1)_NAME)$(4),$(5),$(6))
 endef
 
 define file_download =
-$(DISTFILES_PATH)/$(1):
+$(DISTFILES_PATH)/$(1): | $(4)
 	mkdir -p $(DISTFILES_PATH)
-	flock -x $$@.lock -c '[ -f $$@ ] && exit 0; wget -O $$@.tmp $(MIRROR)$(1) || wget -O $$@.tmp $(2)$(1) || rm -f $$@.tmp; [ -f $$@.tmp ] || exit 1; if echo "$(3)  $$@.tmp" | sha256sum -c -; then mv $$@.tmp $$@; else rm -f $$@.tmp; exit 71; fi'
+	flock -x $$@.lock -c '[ -f $$@ ] && exit 0; wget -O $$@.tmp $(MIRROR)$(1) || wget -O $$@.tmp $(2)$(1) || rm -f $$@.tmp; [ -f $$@.tmp ] || exit 1; if ([ -n "$(4)" ] && sed -n "s#^\([a-f0-9]\{64\}\)  \($(1)\)\$$$$#\1  $(DISTFILES_PATH)/\2.tmp#p" "$(4)" || echo "$(3)  $$@.tmp") | sha256sum -c -; then mv $$@.tmp $$@; else rm -f $$@.tmp; exit 71; fi'
 endef
 
-$(eval $(call tar_download,MUSL,musl,1.2.0,.tar.gz,https://musl.libc.org/releases/,c6de7b191139142d3f9a7b5b702c9cae1b5ee6e7f57e582da9328629408fd4e8))
 $(eval $(call tar_download,IPERF,iperf,3.7,.tar.gz,https://downloads.es.net/pub/iperf/,d846040224317caf2f75c843d309a950a7db23f9b44b94688ccbe557d6d1710c))
 $(eval $(call tar_download,BASH,bash,5.0,.tar.gz,https://ftp.gnu.org/gnu/bash/,b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d))
 $(eval $(call tar_download,IPROUTE2,iproute2,5.6.0,.tar.xz,https://www.kernel.org/pub/linux/utils/net/iproute2/,1b5b0e25ce6e23da7526ea1da044e814ad85ba761b10dd29c2b027c056b04692))
@@ -50,28 +47,20 @@ $(eval $(call tar_download,NMAP,nmap,7.80,.tar.bz2,https://nmap.org/dist/,fcfa5a
 $(eval $(call tar_download,IPUTILS,iputils,s20190709,.tar.gz,https://github.com/iputils/iputils/archive/s20190709.tar.gz/#,a15720dd741d7538dd2645f9f516d193636ae4300ff7dbc8bfca757bf166490a))
 $(eval $(call tar_download,WIREGUARD_TOOLS,wireguard-tools,1.0.20200206,.tar.xz,https://git.zx2c4.com/wireguard-tools/snapshot/,f5207248c6a3c3e3bfc9ab30b91c1897b00802ed861e1f9faaed873366078c64))
 
-KERNEL_BUILD_PATH := $(BUILD_PATH)/kernel$(if $(findstring yes,$(DEBUG_KERNEL)),-debug)
-rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
-WIREGUARD_SOURCES := $(call rwildcard,$(KERNEL_PATH)/drivers/net/wireguard/,*)
-
-export CFLAGS ?= -O3 -pipe
-export LDFLAGS ?=
-export CPPFLAGS := -I$(BUILD_PATH)/include
-
+export CFLAGS := -O3 -pipe
 ifeq ($(HOST_ARCH),$(ARCH))
-CROSS_COMPILE_FLAG := --host=$(CHOST)
 CFLAGS += -march=native
-STRIP := strip
-else
-$(info Cross compilation: building for $(CBUILD) using $(CHOST))
-CROSS_COMPILE_FLAG := --build=$(CBUILD) --host=$(CHOST)
-export CROSS_COMPILE=$(CBUILD)-
-STRIP := $(CBUILD)-strip
 endif
+export LDFLAGS :=
+export CPPFLAGS :=
+
+QEMU_VPORT_RESULT :=
 ifeq ($(ARCH),aarch64)
+CHOST := aarch64-linux-musl
 QEMU_ARCH := aarch64
 KERNEL_ARCH := arm64
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/arm64/boot/Image
+QEMU_VPORT_RESULT := virtio-serial-device
 ifeq ($(HOST_ARCH),$(ARCH))
 QEMU_MACHINE := -cpu host -machine virt,gic_version=host,accel=kvm
 else
@@ -79,9 +68,11 @@ QEMU_MACHINE := -cpu cortex-a53 -machine virt
 CFLAGS += -march=armv8-a -mtune=cortex-a53
 endif
 else ifeq ($(ARCH),aarch64_be)
+CHOST := aarch64_be-linux-musl
 QEMU_ARCH := aarch64
 KERNEL_ARCH := arm64
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/arm64/boot/Image
+QEMU_VPORT_RESULT := virtio-serial-device
 ifeq ($(HOST_ARCH),$(ARCH))
 QEMU_MACHINE := -cpu host -machine virt,gic_version=host,accel=kvm
 else
@@ -89,9 +80,11 @@ QEMU_MACHINE := -cpu cortex-a53 -machine virt
 CFLAGS += -march=armv8-a -mtune=cortex-a53
 endif
 else ifeq ($(ARCH),arm)
+CHOST := arm-linux-musleabi
 QEMU_ARCH := arm
 KERNEL_ARCH := arm
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/arm/boot/zImage
+QEMU_VPORT_RESULT := virtio-serial-device
 ifeq ($(HOST_ARCH),$(ARCH))
 QEMU_MACHINE := -cpu host -machine virt,gic_version=host,accel=kvm
 else
@@ -99,9 +92,11 @@ QEMU_MACHINE := -cpu cortex-a15 -machine virt
 CFLAGS += -march=armv7-a -mtune=cortex-a15 -mabi=aapcs-linux
 endif
 else ifeq ($(ARCH),armeb)
+CHOST := armeb-linux-musleabi
 QEMU_ARCH := arm
 KERNEL_ARCH := arm
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/arm/boot/zImage
+QEMU_VPORT_RESULT := virtio-serial-device
 ifeq ($(HOST_ARCH),$(ARCH))
 QEMU_MACHINE := -cpu host -machine virt,gic_version=host,accel=kvm
 else
@@ -110,6 +105,7 @@ CFLAGS += -march=armv7-a -mabi=aapcs-linux # We don't pass -mtune=cortex-a15 due
 LDFLAGS += -Wl,--be8
 endif
 else ifeq ($(ARCH),x86_64)
+CHOST := x86_64-linux-musl
 QEMU_ARCH := x86_64
 KERNEL_ARCH := x86_64
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/x86/boot/bzImage
@@ -120,6 +116,7 @@ QEMU_MACHINE := -cpu Skylake-Server -machine q35
 CFLAGS += -march=skylake-avx512
 endif
 else ifeq ($(ARCH),i686)
+CHOST := i686-linux-musl
 QEMU_ARCH := i386
 KERNEL_ARCH := x86
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/x86/boot/bzImage
@@ -130,6 +127,7 @@ QEMU_MACHINE := -cpu coreduo -machine q35
 CFLAGS += -march=prescott
 endif
 else ifeq ($(ARCH),mips64)
+CHOST := mips64-linux-musl
 QEMU_ARCH := mips64
 KERNEL_ARCH := mips
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/vmlinux
@@ -141,6 +139,7 @@ QEMU_MACHINE := -cpu MIPS64R2-generic -machine malta -smp 1
 CFLAGS += -march=mips64r2 -EB
 endif
 else ifeq ($(ARCH),mips64el)
+CHOST := mips64el-linux-musl
 QEMU_ARCH := mips64el
 KERNEL_ARCH := mips
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/vmlinux
@@ -152,6 +151,7 @@ QEMU_MACHINE := -cpu MIPS64R2-generic -machine malta -smp 1
 CFLAGS += -march=mips64r2 -EL
 endif
 else ifeq ($(ARCH),mips)
+CHOST := mips-linux-musl
 QEMU_ARCH := mips
 KERNEL_ARCH := mips
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/vmlinux
@@ -163,6 +163,7 @@ QEMU_MACHINE := -cpu 24Kf -machine malta -smp 1
 CFLAGS += -march=mips32r2 -EB
 endif
 else ifeq ($(ARCH),mipsel)
+CHOST := mipsel-linux-musl
 QEMU_ARCH := mipsel
 KERNEL_ARCH := mips
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/vmlinux
@@ -173,7 +174,18 @@ else
 QEMU_MACHINE := -cpu 24Kf -machine malta -smp 1
 CFLAGS += -march=mips32r2 -EL
 endif
+else ifeq ($(ARCH),powerpc64)
+CHOST := powerpc64-linux-musl
+QEMU_ARCH := ppc64
+KERNEL_ARCH := powerpc
+KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/vmlinux
+ifeq ($(HOST_ARCH),$(ARCH))
+QEMU_MACHINE := -cpu host,accel=kvm -machine pseries
+else
+QEMU_MACHINE := -machine pseries
+endif
 else ifeq ($(ARCH),powerpc64le)
+CHOST := powerpc64le-linux-musl
 QEMU_ARCH := ppc64
 KERNEL_ARCH := powerpc
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/vmlinux
@@ -182,8 +194,8 @@ QEMU_MACHINE := -cpu host,accel=kvm -machine pseries
 else
 QEMU_MACHINE := -machine pseries
 endif
-CFLAGS += -mcpu=powerpc64le -mlong-double-64
 else ifeq ($(ARCH),powerpc)
+CHOST := powerpc-linux-musl
 QEMU_ARCH := ppc
 KERNEL_ARCH := powerpc
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/powerpc/boot/uImage
@@ -192,26 +204,72 @@ QEMU_MACHINE := -cpu host,accel=kvm -machine ppce500
 else
 QEMU_MACHINE := -machine ppce500
 endif
-CFLAGS += -mcpu=powerpc -mlong-double-64 -msecure-plt
 else ifeq ($(ARCH),m68k)
+CHOST := m68k-linux-musl
 QEMU_ARCH := m68k
 KERNEL_ARCH := m68k
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/vmlinux
 KERNEL_CMDLINE := $(shell sed -n 's/CONFIG_CMDLINE=\(.*\)/\1/p' arch/m68k.config)
 ifeq ($(HOST_ARCH),$(ARCH))
-QEMU_MACHINE := -cpu host,accel=kvm -machine q800 -smp 1 -append $(KERNEL_CMDLINE)
+QEMU_MACHINE := -cpu host,accel=kvm -machine q800 -append $(KERNEL_CMDLINE)
 else
 QEMU_MACHINE := -machine q800 -smp 1 -append $(KERNEL_CMDLINE)
 endif
+else ifeq ($(ARCH),riscv64)
+CHOST := riscv64-linux-musl
+QEMU_ARCH := riscv64
+KERNEL_ARCH := riscv
+KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/riscv/boot/Image
+QEMU_VPORT_RESULT := virtio-serial-device
+ifeq ($(HOST_ARCH),$(ARCH))
+QEMU_MACHINE := -cpu host,accel=kvm -machine virt
+else
+QEMU_MACHINE := -cpu rv64 -machine virt
+endif
+else ifeq ($(ARCH),riscv32)
+CHOST := riscv32-linux-musl
+QEMU_ARCH := riscv32
+KERNEL_ARCH := riscv
+KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/riscv/boot/Image
+QEMU_VPORT_RESULT := virtio-serial-device
+ifeq ($(HOST_ARCH),$(ARCH))
+QEMU_MACHINE := -cpu host,accel=kvm -machine virt
+else
+QEMU_MACHINE := -cpu rv32 -machine virt
+endif
+else ifeq ($(ARCH),s390x)
+CHOST := s390x-linux-musl
+QEMU_ARCH := s390x
+KERNEL_ARCH := s390
+KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/s390/boot/bzImage
+KERNEL_CMDLINE := $(shell sed -n 's/CONFIG_CMDLINE=\(.*\)/\1/p' arch/s390x.config)
+QEMU_VPORT_RESULT := virtio-serial-ccw
+ifeq ($(HOST_ARCH),$(ARCH))
+QEMU_MACHINE := -cpu host,accel=kvm -machine s390-ccw-virtio -append $(KERNEL_CMDLINE)
 else
-$(error I only build: x86_64, i686, arm, armeb, aarch64, aarch64_be, mips, mipsel, mips64, mips64el, powerpc64le, powerpc, m68k)
+QEMU_MACHINE := -machine s390-ccw-virtio -append $(KERNEL_CMDLINE)
 endif
+else
+$(error I only build: x86_64, i686, arm, armeb, aarch64, aarch64_be, mips, mipsel, mips64, mips64el, powerpc64, powerpc64le, powerpc, m68k, riscv64, riscv32, s390x)
+endif
+
+TOOLCHAIN_FILENAME := $(CHOST)-cross.tgz
+TOOLCHAIN_TAR := $(DISTFILES_PATH)/$(TOOLCHAIN_FILENAME)
+TOOLCHAIN_PATH := $(BUILD_PATH)/$(CHOST)-cross
+TOOLCHAIN_DIR := https://download.wireguard.com/qemu-test/toolchains/20211123/
+$(eval $(call file_download,toolchain-sha256sums-20211123,$(TOOLCHAIN_DIR)SHA256SUMS#,83da033fd8c798df476c21d9612da2dfb896ec62fbed4ceec5eefc0e56b3f0c8))
+$(eval $(call file_download,$(TOOLCHAIN_FILENAME),$(TOOLCHAIN_DIR),,$(DISTFILES_PATH)/toolchain-sha256sums-20211123))
 
-REAL_CC := $(CBUILD)-gcc
-MUSL_CC := $(BUILD_PATH)/musl-gcc
-export CC := $(MUSL_CC)
-USERSPACE_DEPS := $(MUSL_CC) $(BUILD_PATH)/include/.installed $(BUILD_PATH)/include/linux/.installed
+STRIP := $(CHOST)-strip
+CROSS_COMPILE_FLAG := --build=$(CBUILD) --host=$(CHOST)
+$(info Building for $(CHOST) using $(CBUILD))
+export CROSS_COMPILE := $(CHOST)-
+export PATH := $(TOOLCHAIN_PATH)/bin:$(PATH)
+export CC := $(CHOST)-gcc
+
+USERSPACE_DEPS := $(TOOLCHAIN_PATH)/.installed $(TOOLCHAIN_PATH)/$(CHOST)/include/linux/.installed
 
+comma := ,
 build: $(KERNEL_BZIMAGE)
 qemu: $(KERNEL_BZIMAGE)
 	rm -f $(BUILD_PATH)/result
@@ -222,13 +280,14 @@ qemu: $(KERNEL_BZIMAGE)
 		$(QEMU_MACHINE) \
 		-m $$(grep -q CONFIG_DEBUG_KMEMLEAK=y $(KERNEL_BUILD_PATH)/.config && echo 1G || echo 256M) \
 		-serial stdio \
-		-serial file:$(BUILD_PATH)/result \
+		-chardev file,path=$(BUILD_PATH)/result,id=result \
+		$(if $(QEMU_VPORT_RESULT),-device $(QEMU_VPORT_RESULT) -device virtserialport$(comma)chardev=result,-serial chardev:result) \
 		-no-reboot \
 		-monitor none \
 		-kernel $<
 	grep -Fq success $(BUILD_PATH)/result
 
-$(BUILD_PATH)/init-cpio-spec.txt:
+$(BUILD_PATH)/init-cpio-spec.txt: $(TOOLCHAIN_PATH)/.installed $(BUILD_PATH)/init
 	mkdir -p $(BUILD_PATH)
 	echo "file /init $(BUILD_PATH)/init 755 0 0" > $@
 	echo "file /init.sh $(PWD)/../netns.sh 755 0 0" >> $@
@@ -246,10 +305,10 @@ $(BUILD_PATH)/init-cpio-spec.txt:
 	echo "slink /bin/iptables xtables-legacy-multi 777 0 0" >> $@
 	echo "slink /bin/ping6 ping 777 0 0" >> $@
 	echo "dir /lib 755 0 0" >> $@
-	echo "file /lib/libc.so $(MUSL_PATH)/lib/libc.so 755 0 0" >> $@
-	echo "slink /lib/ld-linux.so.1 libc.so 777 0 0" >> $@
+	echo "file /lib/libc.so $(TOOLCHAIN_PATH)/$(CHOST)/lib/libc.so 755 0 0" >> $@
+	echo "slink $$($(CHOST)-readelf -p .interp '$(BUILD_PATH)/init'| grep -o '/lib/.*') libc.so 777 0 0" >> $@
 
-$(KERNEL_BUILD_PATH)/.config: kernel.config arch/$(ARCH).config
+$(KERNEL_BUILD_PATH)/.config: $(TOOLCHAIN_PATH)/.installed kernel.config arch/$(ARCH).config
 	mkdir -p $(KERNEL_BUILD_PATH)
 	cp kernel.config $(KERNEL_BUILD_PATH)/minimal.config
 	printf 'CONFIG_NR_CPUS=$(NR_CPUS)\nCONFIG_INITRAMFS_SOURCE="$(BUILD_PATH)/init-cpio-spec.txt"\n' >> $(KERNEL_BUILD_PATH)/minimal.config
@@ -258,29 +317,20 @@ $(KERNEL_BUILD_PATH)/.config: kernel.config arch/$(ARCH).config
 	cd $(KERNEL_BUILD_PATH) && ARCH=$(KERNEL_ARCH) $(KERNEL_PATH)/scripts/kconfig/merge_config.sh -n $(KERNEL_BUILD_PATH)/.config $(KERNEL_BUILD_PATH)/minimal.config
 	$(if $(findstring yes,$(DEBUG_KERNEL)),cp debug.config $(KERNEL_BUILD_PATH) && cd $(KERNEL_BUILD_PATH) && ARCH=$(KERNEL_ARCH) $(KERNEL_PATH)/scripts/kconfig/merge_config.sh -n $(KERNEL_BUILD_PATH)/.config debug.config,)
 
-$(KERNEL_BZIMAGE): $(KERNEL_BUILD_PATH)/.config $(BUILD_PATH)/init-cpio-spec.txt $(MUSL_PATH)/lib/libc.so $(IPERF_PATH)/src/iperf3 $(IPUTILS_PATH)/ping $(BASH_PATH)/bash $(IPROUTE2_PATH)/misc/ss $(IPROUTE2_PATH)/ip/ip $(IPTABLES_PATH)/iptables/xtables-legacy-multi $(NMAP_PATH)/ncat/ncat $(WIREGUARD_TOOLS_PATH)/src/wg $(BUILD_PATH)/init ../netns.sh $(WIREGUARD_SOURCES)
+$(KERNEL_BZIMAGE): $(TOOLCHAIN_PATH)/.installed $(KERNEL_BUILD_PATH)/.config $(BUILD_PATH)/init-cpio-spec.txt $(IPERF_PATH)/src/iperf3 $(IPUTILS_PATH)/ping $(BASH_PATH)/bash $(IPROUTE2_PATH)/misc/ss $(IPROUTE2_PATH)/ip/ip $(IPTABLES_PATH)/iptables/xtables-legacy-multi $(NMAP_PATH)/ncat/ncat $(WIREGUARD_TOOLS_PATH)/src/wg $(BUILD_PATH)/init ../netns.sh $(WIREGUARD_SOURCES)
 	$(MAKE) -C $(KERNEL_PATH) O=$(KERNEL_BUILD_PATH) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE)
 
-$(BUILD_PATH)/include/linux/.installed: | $(KERNEL_BUILD_PATH)/.config
-	$(MAKE) -C $(KERNEL_PATH) O=$(KERNEL_BUILD_PATH) INSTALL_HDR_PATH=$(BUILD_PATH) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) headers_install
+$(TOOLCHAIN_PATH)/$(CHOST)/include/linux/.installed: | $(KERNEL_BUILD_PATH)/.config $(TOOLCHAIN_PATH)/.installed
+	rm -rf $(TOOLCHAIN_PATH)/$(CHOST)/include/linux
+	$(MAKE) -C $(KERNEL_PATH) O=$(KERNEL_BUILD_PATH) INSTALL_HDR_PATH=$(TOOLCHAIN_PATH)/$(CHOST) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) headers_install
 	touch $@
 
-$(MUSL_PATH)/lib/libc.so: $(MUSL_TAR)
+$(TOOLCHAIN_PATH)/.installed: $(TOOLCHAIN_TAR)
 	mkdir -p $(BUILD_PATH)
 	flock -s $<.lock tar -C $(BUILD_PATH) -xf $<
-	cd $(MUSL_PATH) && CC=$(REAL_CC) ./configure --prefix=/ --disable-static --build=$(CBUILD)
-	$(MAKE) -C $(MUSL_PATH)
-	$(STRIP) -s $@
-
-$(BUILD_PATH)/include/.installed: $(MUSL_PATH)/lib/libc.so
-	$(MAKE) -C $(MUSL_PATH) DESTDIR=$(BUILD_PATH) install-headers
+	$(STRIP) -s $(TOOLCHAIN_PATH)/$(CHOST)/lib/libc.so
 	touch $@
 
-$(MUSL_CC): $(MUSL_PATH)/lib/libc.so
-	sh $(MUSL_PATH)/tools/musl-gcc.specs.sh $(BUILD_PATH)/include $(MUSL_PATH)/lib /lib/ld-linux.so.1 > $(BUILD_PATH)/musl-gcc.specs
-	printf '#!/bin/sh\nexec "$(REAL_CC)" --specs="$(BUILD_PATH)/musl-gcc.specs" "$$@"\n' > $(BUILD_PATH)/musl-gcc
-	chmod +x $(BUILD_PATH)/musl-gcc
-
 $(IPERF_PATH)/.installed: $(IPERF_TAR)
 	mkdir -p $(BUILD_PATH)
 	flock -s $<.lock tar -C $(BUILD_PATH) -xf $<
@@ -289,6 +339,7 @@ $(IPERF_PATH)/.installed: $(IPERF_TAR)
 	touch $@
 
 $(IPERF_PATH)/src/iperf3: | $(IPERF_PATH)/.installed $(USERSPACE_DEPS)
+	cd $(IPERF_PATH) && autoreconf -fi
 	cd $(IPERF_PATH) && CFLAGS="$(CFLAGS) -D_GNU_SOURCE" ./configure --prefix=/ $(CROSS_COMPILE_FLAG) --enable-static --disable-shared --with-openssl=no
 	$(MAKE) -C $(IPERF_PATH)
 	$(STRIP) -s $@
@@ -304,7 +355,7 @@ $(WIREGUARD_TOOLS_PATH)/src/wg: | $(WIREGUARD_TOOLS_PATH)/.installed $(USERSPACE
 
 $(BUILD_PATH)/init: init.c | $(USERSPACE_DEPS)
 	mkdir -p $(BUILD_PATH)
-	$(MUSL_CC) -o $@ $(CFLAGS) $(LDFLAGS) -std=gnu11 $<
+	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -std=gnu11 $<
 	$(STRIP) -s $@
 
 $(IPUTILS_PATH)/.installed: $(IPUTILS_TAR)
diff --git a/tools/testing/selftests/wireguard/qemu/arch/aarch64.config b/tools/testing/selftests/wireguard/qemu/arch/aarch64.config
index 3d063bb247bb..e9ac41f6b3ae 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/aarch64.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/aarch64.config
@@ -1,5 +1,8 @@
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
+CONFIG_VIRTIO_MENU=y
+CONFIG_VIRTIO_MMIO=y
+CONFIG_VIRTIO_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyAMA0 wg.success=ttyAMA1"
+CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1"
 CONFIG_FRAME_WARN=1280
diff --git a/tools/testing/selftests/wireguard/qemu/arch/aarch64_be.config b/tools/testing/selftests/wireguard/qemu/arch/aarch64_be.config
index dbdc7e406a7b..03609a203e8c 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/aarch64_be.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/aarch64_be.config
@@ -1,6 +1,9 @@
 CONFIG_CPU_BIG_ENDIAN=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
+CONFIG_VIRTIO_MENU=y
+CONFIG_VIRTIO_MMIO=y
+CONFIG_VIRTIO_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyAMA0 wg.success=ttyAMA1"
+CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1"
 CONFIG_FRAME_WARN=1280
diff --git a/tools/testing/selftests/wireguard/qemu/arch/arm.config b/tools/testing/selftests/wireguard/qemu/arch/arm.config
index 148f49905418..c616124fdd59 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/arm.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/arm.config
@@ -4,6 +4,9 @@ CONFIG_ARCH_VIRT=y
 CONFIG_THUMB2_KERNEL=n
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
+CONFIG_VIRTIO_MENU=y
+CONFIG_VIRTIO_MMIO=y
+CONFIG_VIRTIO_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyAMA0 wg.success=ttyAMA1"
+CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/armeb.config b/tools/testing/selftests/wireguard/qemu/arch/armeb.config
index bd76b07d00a2..d3a40a974e16 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/armeb.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/armeb.config
@@ -4,7 +4,10 @@ CONFIG_ARCH_VIRT=y
 CONFIG_THUMB2_KERNEL=n
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
+CONFIG_VIRTIO_MENU=y
+CONFIG_VIRTIO_MMIO=y
+CONFIG_VIRTIO_CONSOLE=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyAMA0 wg.success=ttyAMA1"
+CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1"
 CONFIG_CPU_BIG_ENDIAN=y
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/powerpc64.config b/tools/testing/selftests/wireguard/qemu/arch/powerpc64.config
new file mode 100644
index 000000000000..c19c7b519d8b
--- /dev/null
+++ b/tools/testing/selftests/wireguard/qemu/arch/powerpc64.config
@@ -0,0 +1,13 @@
+CONFIG_PPC64=y
+CONFIG_PPC_PSERIES=y
+CONFIG_ALTIVEC=y
+CONFIG_VSX=y
+CONFIG_PPC_OF_BOOT_TRAMPOLINE=y
+CONFIG_PPC_RADIX_MMU=y
+CONFIG_HVC_CONSOLE=y
+CONFIG_CPU_BIG_ENDIAN=y
+CONFIG_CMDLINE_BOOL=y
+CONFIG_CMDLINE="console=hvc0 wg.success=hvc1"
+CONFIG_SECTION_MISMATCH_WARN_ONLY=y
+CONFIG_FRAME_WARN=1280
+CONFIG_THREAD_SHIFT=14
diff --git a/tools/testing/selftests/wireguard/qemu/arch/riscv32.config b/tools/testing/selftests/wireguard/qemu/arch/riscv32.config
new file mode 100644
index 000000000000..ea53e78e923e
--- /dev/null
+++ b/tools/testing/selftests/wireguard/qemu/arch/riscv32.config
@@ -0,0 +1,12 @@
+CONFIG_ARCH_RV32I=y
+CONFIG_MMU=y
+CONFIG_FPU=y
+CONFIG_SOC_VIRT=y
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
+CONFIG_VIRTIO_MENU=y
+CONFIG_VIRTIO_MMIO=y
+CONFIG_VIRTIO_CONSOLE=y
+CONFIG_CMDLINE="console=ttyS0 wg.success=vport0p1"
+CONFIG_CMDLINE_FORCE=y
diff --git a/tools/testing/selftests/wireguard/qemu/arch/riscv64.config b/tools/testing/selftests/wireguard/qemu/arch/riscv64.config
new file mode 100644
index 000000000000..4a08d8c1d4af
--- /dev/null
+++ b/tools/testing/selftests/wireguard/qemu/arch/riscv64.config
@@ -0,0 +1,12 @@
+CONFIG_ARCH_RV64I=y
+CONFIG_MMU=y
+CONFIG_FPU=y
+CONFIG_SOC_VIRT=y
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
+CONFIG_VIRTIO_MENU=y
+CONFIG_VIRTIO_MMIO=y
+CONFIG_VIRTIO_CONSOLE=y
+CONFIG_CMDLINE="console=ttyS0 wg.success=vport0p1"
+CONFIG_CMDLINE_FORCE=y
diff --git a/tools/testing/selftests/wireguard/qemu/arch/s390x.config b/tools/testing/selftests/wireguard/qemu/arch/s390x.config
new file mode 100644
index 000000000000..274a44f4e49c
--- /dev/null
+++ b/tools/testing/selftests/wireguard/qemu/arch/s390x.config
@@ -0,0 +1,6 @@
+CONFIG_SCLP_VT220_TTY=y
+CONFIG_SCLP_VT220_CONSOLE=y
+CONFIG_VIRTIO_MENU=y
+CONFIG_VIRTIO_CONSOLE=y
+CONFIG_S390_GUEST=y
+CONFIG_CMDLINE="console=ttysclp0 wg.success=vport0p1"
-- 
2.35.1

