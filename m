Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD81193848
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 06:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgCZF62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 01:58:28 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:47768 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbgCZF61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 01:58:27 -0400
Received: from pug.e01.socionext.com (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 02Q5ve94008573;
        Thu, 26 Mar 2020 14:57:40 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 02Q5ve94008573
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585202260;
        bh=dX+mdRt8kcID48UqORTUMY5bdsGeWZDwRFh1lk4J+OY=;
        h=From:To:Cc:Subject:Date:From;
        b=F+31nJQ4Cgf4gt9L3lAD0yTyZM6taU0HcwCkPUB81lu7qxiTtqk/tHtzkh/wAtjZ4
         CF28DzVLBwEyskREvoR6rtnBx8mXTZBWq+C9GQPOET0lsVnrdIJzYYc7Mwy+J3+vPo
         sAe7ySOYigImr3dYkXpLC7r2oa/fL48HjVwRCcUpTzCz38C5MBUGNEXpnrPl3LwCC/
         wL+xhmfmA5VZEaIah5/GJP6AKqawr2QSCcnmWc7MOcELsG4uxWzU6MWRniddWyukwu
         X8J5qiPn7XDM2rl5fMOAHkZSs1ow+LvVLFtQl7+EVuosUu0MJqcGIPwcOFq9Xax6en
         epHo20x8scgLw==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     clang-built-linux@googlegroups.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 1/4] net: wan: wanxl: use allow to pass CROSS_COMPILE_M68k for rebuilding firmware
Date:   Thu, 26 Mar 2020 14:57:15 +0900
Message-Id: <20200326055719.16755-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---

Changes in v2:
  - New patch

 drivers/net/wan/Kconfig  |  2 +-
 drivers/net/wan/Makefile | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 4530840e15ef..dbc0e3f7a3e2 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -200,7 +200,7 @@ config WANXL_BUILD_FIRMWARE
 	depends on WANXL && !PREVENT_FIRMWARE_BUILD
 	help
 	  Allows you to rebuild firmware run by the QUICC processor.
-	  It requires as68k, ld68k and hexdump programs.
+	  It requires m68k toolchains and hexdump programs.
 
 	  You should never need this option, say N.
 
diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index 701f5d2fe3b6..995277c657a1 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -40,17 +40,17 @@ $(obj)/wanxl.o:	$(obj)/wanxlfw.inc
 
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
2.17.1

