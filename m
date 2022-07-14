Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C985742F0
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 06:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiGNE2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 00:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235811AbiGNE1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 00:27:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91A227B06;
        Wed, 13 Jul 2022 21:24:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72489B82374;
        Thu, 14 Jul 2022 04:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E6CC341C6;
        Thu, 14 Jul 2022 04:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772658;
        bh=KZbsROFz/14gdWxcQ8R7J4JMxfsXF0zLuzjDa3ZmnNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFOoz3x8BGHTauzufs2Xj92Pqx/UPCKGERnpdf+HYymZiv2EndcVne+HMvz4vPEnY
         Mvaajy+KX2iVm0t3o23OXcu6QOycjP3tBHM71/yjJEvKekv3RrwL9jK31sDAE0OBKS
         DDiUjERbVDyihPeHq/bvy2g2eOgFFTSReJLLo5FMJ36TdtppsvRZ/xUc/uvGN7G1UF
         R2+fgFst1fxso7tI3oy4y6X4rIgV6QJyolac/NXW2BrQJd0ZFSnjuOjglyV84KoXT1
         QZ9MmQewktLAZ5czeHsmvP3UfyuNOkfEHIH4lrHws2O9e4ktauYtIckH1wm+2dSr2R
         DvrBww6vmbZEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 38/41] wireguard: selftests: set fake real time in init
Date:   Thu, 14 Jul 2022 00:22:18 -0400
Message-Id: <20220714042221.281187-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 829be057dbc1e71383b8d7de8edb31dcf07b4aa0 ]

Not all platforms have an RTC, and rather than trying to force one into
each, it's much easier to just set a fixed time. This is necessary
because WireGuard's latest handshakes parameter is returned in wallclock
time, and if the system time isn't set, and the system is really fast,
then this returns 0, which trips the test.

Turning this on requires setting CONFIG_COMPAT_32BIT_TIME=y, as musl
doesn't support settimeofday without it.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/wireguard/qemu/arch/arm.config  |  1 +
 .../selftests/wireguard/qemu/arch/armeb.config        |  1 +
 .../testing/selftests/wireguard/qemu/arch/i686.config |  1 +
 .../testing/selftests/wireguard/qemu/arch/m68k.config |  1 +
 .../testing/selftests/wireguard/qemu/arch/mips.config |  1 +
 .../selftests/wireguard/qemu/arch/mipsel.config       |  1 +
 .../selftests/wireguard/qemu/arch/powerpc.config      |  1 +
 tools/testing/selftests/wireguard/qemu/init.c         | 11 +++++++++++
 8 files changed, 18 insertions(+)

diff --git a/tools/testing/selftests/wireguard/qemu/arch/arm.config b/tools/testing/selftests/wireguard/qemu/arch/arm.config
index fc7959bef9c2..0579c66be83e 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/arm.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/arm.config
@@ -7,6 +7,7 @@ CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 CONFIG_VIRTIO_MENU=y
 CONFIG_VIRTIO_MMIO=y
 CONFIG_VIRTIO_CONSOLE=y
+CONFIG_COMPAT_32BIT_TIME=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/armeb.config b/tools/testing/selftests/wireguard/qemu/arch/armeb.config
index f3066be81c19..2a3307bbe534 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/armeb.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/armeb.config
@@ -7,6 +7,7 @@ CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 CONFIG_VIRTIO_MENU=y
 CONFIG_VIRTIO_MMIO=y
 CONFIG_VIRTIO_CONSOLE=y
+CONFIG_COMPAT_32BIT_TIME=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyAMA0 wg.success=vport0p1 panic_on_warn=1"
 CONFIG_CPU_BIG_ENDIAN=y
diff --git a/tools/testing/selftests/wireguard/qemu/arch/i686.config b/tools/testing/selftests/wireguard/qemu/arch/i686.config
index 6d90892a85a2..cd864b9be6fb 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/i686.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/i686.config
@@ -1,6 +1,7 @@
 CONFIG_ACPI=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_COMPAT_32BIT_TIME=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/m68k.config b/tools/testing/selftests/wireguard/qemu/arch/m68k.config
index 82c925e49beb..9639bfe06074 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/m68k.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/m68k.config
@@ -5,5 +5,6 @@ CONFIG_MAC=y
 CONFIG_SERIAL_PMACZILOG=y
 CONFIG_SERIAL_PMACZILOG_TTYS=y
 CONFIG_SERIAL_PMACZILOG_CONSOLE=y
+CONFIG_COMPAT_32BIT_TIME=y
 CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/mips.config b/tools/testing/selftests/wireguard/qemu/arch/mips.config
index d7ec63c17b30..2a84402353ab 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/mips.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/mips.config
@@ -6,6 +6,7 @@ CONFIG_POWER_RESET=y
 CONFIG_POWER_RESET_SYSCON=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_COMPAT_32BIT_TIME=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/mipsel.config b/tools/testing/selftests/wireguard/qemu/arch/mipsel.config
index 18a498293737..56146a101e7e 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/mipsel.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/mipsel.config
@@ -7,6 +7,7 @@ CONFIG_POWER_RESET=y
 CONFIG_POWER_RESET_SYSCON=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_COMPAT_32BIT_TIME=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
diff --git a/tools/testing/selftests/wireguard/qemu/arch/powerpc.config b/tools/testing/selftests/wireguard/qemu/arch/powerpc.config
index 5e04882e8e35..174a9ffe2a36 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/powerpc.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/powerpc.config
@@ -4,6 +4,7 @@ CONFIG_PPC_85xx=y
 CONFIG_PHYS_64BIT=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_COMPAT_32BIT_TIME=y
 CONFIG_MATH_EMULATION=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
diff --git a/tools/testing/selftests/wireguard/qemu/init.c b/tools/testing/selftests/wireguard/qemu/init.c
index 2a0f48fac925..542c34b00eb0 100644
--- a/tools/testing/selftests/wireguard/qemu/init.c
+++ b/tools/testing/selftests/wireguard/qemu/init.c
@@ -11,6 +11,7 @@
 #include <stdlib.h>
 #include <stdbool.h>
 #include <fcntl.h>
+#include <time.h>
 #include <sys/wait.h>
 #include <sys/mount.h>
 #include <sys/stat.h>
@@ -67,6 +68,15 @@ static void seed_rng(void)
 	close(fd);
 }
 
+static void set_time(void)
+{
+	if (time(NULL))
+		return;
+	pretty_message("[+] Setting fake time...");
+	if (stime(&(time_t){1433512680}) < 0)
+		panic("settimeofday()");
+}
+
 static void mount_filesystems(void)
 {
 	pretty_message("[+] Mounting filesystems...");
@@ -256,6 +266,7 @@ int main(int argc, char *argv[])
 	print_banner();
 	mount_filesystems();
 	seed_rng();
+	set_time();
 	kmod_selftests();
 	enable_logging();
 	clear_leaks();
-- 
2.35.1

