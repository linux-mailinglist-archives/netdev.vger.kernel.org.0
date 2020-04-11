Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB041A5795
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbgDKXMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730067AbgDKXMF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:12:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF02620708;
        Sat, 11 Apr 2020 23:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646725;
        bh=GvIy7VMOBVjJCLIBOncPcXpcMFRxp+6HGu4EVePeFhw=;
        h=From:To:Cc:Subject:Date:From;
        b=I6Jw4Btnrbf0JL3uWoJe8zAkpiKPZUfhjeqpg4xmvH9aRSBvNYTnPWp+dyC0h5PHC
         r081t9DEOvtBumO2v6VgUPfinO216fliErglUcp4g/KC7YLB31g1MnV8rpxg2opHdk
         4ukMuZgVm3ZgmGuL9wmy23bcDfS8xWEKfwof7NyY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/66] net: wan: wanxl: use allow to pass CROSS_COMPILE_M68k for rebuilding firmware
Date:   Sat, 11 Apr 2020 19:10:58 -0400
Message-Id: <20200411231203.25933-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 63b903dfebdea92aa92ad337d8451a6fbfeabf9d ]

As far as I understood from the Kconfig help text, this build rule is
used to rebuild the driver firmware, which runs on an old m68k-based
chip. So, you need m68k tools for the firmware rebuild.

wanxl.c is a PCI driver, but CONFIG_M68K does not select CONFIG_HAVE_PCI.
So, you cannot enable CONFIG_WANXL_BUILD_FIRMWARE for ARCH=m68k. In other
words, ifeq ($(ARCH),m68k) is false here.

I am keeping the dead code for now, but rebuilding the firmware requires
'as68k' and 'ld68k', which I do not have in hand.

Instead, the kernel.org m68k GCC [1] successfully built it.

Allowing a user to pass in CROSS_COMPILE_M68K= is handier.

[1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/9.2.0/x86_64-gcc-9.2.0-nolibc-m68k-linux.tar.xz

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/Kconfig  |  2 +-
 drivers/net/wan/Makefile | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 4e9fe75d70675..21190dfbabb16 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -199,7 +199,7 @@ config WANXL_BUILD_FIRMWARE
 	depends on WANXL && !PREVENT_FIRMWARE_BUILD
 	help
 	  Allows you to rebuild firmware run by the QUICC processor.
-	  It requires as68k, ld68k and hexdump programs.
+	  It requires m68k toolchains and hexdump programs.
 
 	  You should never need this option, say N.
 
diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index 9532e69fda878..c21b7345b50b1 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -41,17 +41,17 @@ $(obj)/wanxl.o:	$(obj)/wanxlfw.inc
 
 ifeq ($(CONFIG_WANXL_BUILD_FIRMWARE),y)
 ifeq ($(ARCH),m68k)
-  AS68K = $(AS)
-  LD68K = $(LD)
+  M68KAS = $(AS)
+  M68KLD = $(LD)
 else
-  AS68K = as68k
-  LD68K = ld68k
+  M68KAS = $(CROSS_COMPILE_M68K)as
+  M68KLD = $(CROSS_COMPILE_M68K)ld
 endif
 
 quiet_cmd_build_wanxlfw = BLD FW  $@
       cmd_build_wanxlfw = \
-	$(CPP) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi $< | $(AS68K) -m68360 -o $(obj)/wanxlfw.o; \
-	$(LD68K) --oformat binary -Ttext 0x1000 $(obj)/wanxlfw.o -o $(obj)/wanxlfw.bin; \
+	$(CPP) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi $< | $(M68KAS) -m68360 -o $(obj)/wanxlfw.o; \
+	$(M68KLD) --oformat binary -Ttext 0x1000 $(obj)/wanxlfw.o -o $(obj)/wanxlfw.bin; \
 	hexdump -ve '"\n" 16/1 "0x%02X,"' $(obj)/wanxlfw.bin | sed 's/0x  ,//g;1s/^/static const u8 firmware[]={/;$$s/,$$/\n};\n/' >$(obj)/wanxlfw.inc; \
 	rm -f $(obj)/wanxlfw.bin $(obj)/wanxlfw.o
 
-- 
2.20.1

