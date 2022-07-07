Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BF55696F1
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 02:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbiGGAcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 20:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbiGGAce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 20:32:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBCA26AF1
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 17:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE82E61FF5
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 00:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9623C3411C;
        Thu,  7 Jul 2022 00:32:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="eD7yjb4C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657153950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQJyCdPpqNRO/vvFWnF8a0gFuGGzNFFkaQaNdWGmotA=;
        b=eD7yjb4CRLvhPN9dCAuYRYq1SUtb7iyYVC1qnBtr9YoP587wp5hhcybxDaIrQJ+aJmjGu6
        4eGxN2FGVJImTKecDvt4ivIOkcUyHZpba35Yk8MjaDvUXQ5K6wscvRQ+G3GvoFjUMzcHR3
        z5J9CTwfFeC8maBK7pBo4X1i+DxYf+E=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 358a5412 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 7 Jul 2022 00:32:30 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 4/6] wireguard: selftests: use microvm on x86
Date:   Thu,  7 Jul 2022 02:31:55 +0200
Message-Id: <20220707003157.526645-5-Jason@zx2c4.com>
In-Reply-To: <20220707003157.526645-1-Jason@zx2c4.com>
References: <20220707003157.526645-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes for faster tests, faster compile time, and allows us to ditch
ACPI finally.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/Makefile        | 10 ++++++----
 .../testing/selftests/wireguard/qemu/arch/i686.config  |  7 +++++--
 .../selftests/wireguard/qemu/arch/x86_64.config        |  7 +++++--
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index ce6176928a7d..9700358e4337 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -107,20 +107,22 @@ CHOST := x86_64-linux-musl
 QEMU_ARCH := x86_64
 KERNEL_ARCH := x86_64
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/x86/boot/bzImage
+QEMU_VPORT_RESULT := virtio-serial-device
 ifeq ($(HOST_ARCH),$(ARCH))
-QEMU_MACHINE := -cpu host -machine q35,accel=kvm
+QEMU_MACHINE := -cpu host -machine microvm,accel=kvm,pit=off,pic=off,rtc=off -no-acpi
 else
-QEMU_MACHINE := -cpu max -machine q35
+QEMU_MACHINE := -cpu max -machine microvm -no-acpi
 endif
 else ifeq ($(ARCH),i686)
 CHOST := i686-linux-musl
 QEMU_ARCH := i386
 KERNEL_ARCH := x86
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/x86/boot/bzImage
+QEMU_VPORT_RESULT := virtio-serial-device
 ifeq ($(subst x86_64,i686,$(HOST_ARCH)),$(ARCH))
-QEMU_MACHINE := -cpu host -machine q35,accel=kvm
+QEMU_MACHINE := -cpu host -machine microvm,accel=kvm,pit=off,pic=off,rtc=off -no-acpi
 else
-QEMU_MACHINE := -cpu max -machine q35
+QEMU_MACHINE := -cpu coreduo -machine microvm -no-acpi
 endif
 else ifeq ($(ARCH),mips64)
 CHOST := mips64-linux-musl
diff --git a/tools/testing/selftests/wireguard/qemu/arch/i686.config b/tools/testing/selftests/wireguard/qemu/arch/i686.config
index cd864b9be6fb..35b06502606f 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/i686.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/i686.config
@@ -1,7 +1,10 @@
-CONFIG_ACPI=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_VIRTIO_MENU=y
+CONFIG_VIRTIO_MMIO=y
+CONFIG_VIRTIO_CONSOLE=y
+CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y
 CONFIG_COMPAT_32BIT_TIME=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=vport0p1 panic_on_warn=1 reboot=t"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/x86_64.config b/tools/testing/selftests/wireguard/qemu/arch/x86_64.config
index efa00693e08b..cf2d1376d121 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/x86_64.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/x86_64.config
@@ -1,6 +1,9 @@
-CONFIG_ACPI=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_VIRTIO_MENU=y
+CONFIG_VIRTIO_MMIO=y
+CONFIG_VIRTIO_CONSOLE=y
+CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
+CONFIG_CMDLINE="console=ttyS0 wg.success=vport0p1 panic_on_warn=1 reboot=t"
 CONFIG_FRAME_WARN=1280
-- 
2.35.1

