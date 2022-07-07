Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9C65696EE
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 02:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbiGGAcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 20:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiGGAca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 20:32:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBBB24F3C
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 17:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA9B5B81F44
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 00:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE4BC3411C;
        Thu,  7 Jul 2022 00:32:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="l3kV60dM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657153945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I+TF9Hlh7iGKbqgXvNLANO3wTapgDoMryBVAU48FOJY=;
        b=l3kV60dMs5fqhignEnp41fjx3z5wP/NPVYlcOjiNwfyCT9/2jBMAATbFOhHMsyXc3G04bO
        Of2aB0Hw67pl0U1yIcJAkQBb4ZblmrPWdQMVIFjxbuW77XKAlfpjZ5I26Bm8y1m5iTd1z5
        owrtmU1Inae2/bvoFTayvFnKpOi7gK8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d618f5c2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 7 Jul 2022 00:32:25 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 2/6] wireguard: selftests: use virt machine on m68k
Date:   Thu,  7 Jul 2022 02:31:53 +0200
Message-Id: <20220707003157.526645-3-Jason@zx2c4.com>
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

This should be a bit more stable hopefully.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/Makefile         | 5 +++--
 tools/testing/selftests/wireguard/qemu/arch/m68k.config | 9 +++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index 7d1b80988d8a..ed07fdc4589c 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -208,10 +208,11 @@ QEMU_ARCH := m68k
 KERNEL_ARCH := m68k
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/vmlinux
 KERNEL_CMDLINE := $(shell sed -n 's/CONFIG_CMDLINE=\(.*\)/\1/p' arch/m68k.config)
+QEMU_VPORT_RESULT := virtio-serial-device
 ifeq ($(HOST_ARCH),$(ARCH))
-QEMU_MACHINE := -cpu host,accel=kvm -machine q800 -append $(KERNEL_CMDLINE)
+QEMU_MACHINE := -cpu host,accel=kvm -machine virt -append $(KERNEL_CMDLINE)
 else
-QEMU_MACHINE := -machine q800 -smp 1 -append $(KERNEL_CMDLINE)
+QEMU_MACHINE := -machine virt -smp 1 -append $(KERNEL_CMDLINE)
 endif
 else ifeq ($(ARCH),riscv64)
 CHOST := riscv64-linux-musl
diff --git a/tools/testing/selftests/wireguard/qemu/arch/m68k.config b/tools/testing/selftests/wireguard/qemu/arch/m68k.config
index 9639bfe06074..39c48cba56b7 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/m68k.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/m68k.config
@@ -1,10 +1,7 @@
 CONFIG_MMU=y
+CONFIG_VIRT=y
 CONFIG_M68KCLASSIC=y
-CONFIG_M68040=y
-CONFIG_MAC=y
-CONFIG_SERIAL_PMACZILOG=y
-CONFIG_SERIAL_PMACZILOG_TTYS=y
-CONFIG_SERIAL_PMACZILOG_CONSOLE=y
+CONFIG_VIRTIO_CONSOLE=y
 CONFIG_COMPAT_32BIT_TIME=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
+CONFIG_CMDLINE="console=ttyGF0 wg.success=vport0p1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
-- 
2.35.1

