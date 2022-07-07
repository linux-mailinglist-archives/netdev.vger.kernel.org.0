Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6205696EC
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 02:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiGGAc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 20:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiGGAc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 20:32:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EA620BFF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 17:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B9BA61FEF
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 00:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6312FC3411C;
        Thu,  7 Jul 2022 00:32:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DHQWcA0k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657153942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yvnxa04gdL8v44qAwuXidTQ0PbLOkWBTOD8srR+kACw=;
        b=DHQWcA0klTR42Zv3KrQo+qKcWDjOrpLI7b0PQXMbOBRVxfQSjPM75KPCvfBUez4TbBGj5u
        Syee4QUFBtp8+4yC2f2eFIBwf1F7gOGpy3XKXV4mdH0anW4fr6URWiPx77OvIxro7vHkVJ
        HTcO823chisW9RKY2hBmGUAfKhK6fUU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a1bb04c9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 7 Jul 2022 00:32:22 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/6] wireguard: selftests: set fake real time in init
Date:   Thu,  7 Jul 2022 02:31:52 +0200
Message-Id: <20220707003157.526645-2-Jason@zx2c4.com>
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

Not all platforms have an RTC, and rather than trying to force one into
each, it's much easier to just set a fixed time. This is necessary
because WireGuard's latest handshakes parameter is returned in wallclock
time, and if the system time isn't set, and the system is really fast,
then this returns 0, which trips the test.

Turning this on requires setting CONFIG_COMPAT_32BIT_TIME=y, as musl
doesn't support settimeofday without it.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
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
index c9e128436546..3e49924dd77e 100644
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
@@ -70,6 +71,15 @@ static void seed_rng(void)
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
@@ -259,6 +269,7 @@ int main(int argc, char *argv[])
 	print_banner();
 	mount_filesystems();
 	seed_rng();
+	set_time();
 	kmod_selftests();
 	enable_logging();
 	clear_leaks();
-- 
2.35.1

