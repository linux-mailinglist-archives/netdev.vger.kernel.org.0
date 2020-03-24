Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3381915F8
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgCXQQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:16:14 -0400
Received: from conuserg-11.nifty.com ([210.131.2.78]:61249 "EHLO
        conuserg-11.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgCXQQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 12:16:13 -0400
Received: from grover.flets-west.jp (softbank126093102113.bbtec.net [126.93.102.113]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id 02OGFgQZ015903;
        Wed, 25 Mar 2020 01:15:43 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 02OGFgQZ015903
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585066543;
        bh=SHxHi5gK5rZIIYUYvBbvkIHDsBapKZs/OlS5DzaqpoA=;
        h=From:To:Cc:Subject:Date:From;
        b=j1MkgGRCnXStt4YVeJwYA4MBLvZJzYSi6RfmjZOwXGvsag0kl1/UlVDf4d6EJfkw1
         4teW3iULx4yOqJJdzvXZTwfrpHmDPDt+DYHYqtqVALycfUsXIWf+fNTXapALPdOVCp
         JdPkcGNtUj0pLJ/WbzYe0NP4B2obIwmFV7wmgJwot60weiwWjMRRQg86zTxECzMGrW
         TEuyIJT8dvTer+EEPgcvK4nrsBB+t86pPejB24hrkZ+HwJFGkvbJeUcamGe008+iud
         eBP5v8vWjOnEt+4Rx6/umhTtuQOG6SD2UFU7bqvASOx/x4bE5s/Dqp0ndll+0OzSP3
         VWZZkPfRT17Lg==
X-Nifty-SrcIP: [126.93.102.113]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 1/3] net: wan: wanxl: use $(CC68K) instead of $(AS68K) for rebuilding firmware
Date:   Wed, 25 Mar 2020 01:15:37 +0900
Message-Id: <20200324161539.7538-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As far as I understood from the Kconfig help text, this build rule is
used to rebuild the driver firmware, which runs on the QUICC, m68k-based
Motorola 68360.

The firmware source, wanxlfw.S, is currently compiled by the combo of
$(CPP) and $(AS68K). This is not what we usually do for compiling *.S
files. In fact, this is the only user of $(AS) in the kernel build.

Moreover, $(CPP) is not likely to be a m68k tool because wanxl.c is a
PCI driver, but CONFIG_M68K does not select CONFIG_HAVE_PCI.
Instead of combining $(CPP) and (AS) from different tool sets, using
single $(CC68K) seems simpler, and saner.

After this commit, the firmware rebuild will require cc68k instead of
as68k. I do not know how many people care about this, though.

I do not have cc68k/ld68k in hand, but I was able to build it by using
the kernel.org m68k toolchain. [1]

[1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/9.2.0/x86_64-gcc-9.2.0-nolibc-m68k-linux.tar.xz

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 drivers/net/wan/Kconfig  | 2 +-
 drivers/net/wan/Makefile | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 4530840e15ef..0f35ad097744 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -200,7 +200,7 @@ config WANXL_BUILD_FIRMWARE
 	depends on WANXL && !PREVENT_FIRMWARE_BUILD
 	help
 	  Allows you to rebuild firmware run by the QUICC processor.
-	  It requires as68k, ld68k and hexdump programs.
+	  It requires cc68k, ld68k and hexdump programs.
 
 	  You should never need this option, say N.
 
diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index 701f5d2fe3b6..d21a99711070 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -40,16 +40,16 @@ $(obj)/wanxl.o:	$(obj)/wanxlfw.inc
 
 ifeq ($(CONFIG_WANXL_BUILD_FIRMWARE),y)
 ifeq ($(ARCH),m68k)
-  AS68K = $(AS)
+  CC68K = $(CC)
   LD68K = $(LD)
 else
-  AS68K = as68k
+  CC68K = cc68k
   LD68K = ld68k
 endif
 
 quiet_cmd_build_wanxlfw = BLD FW  $@
       cmd_build_wanxlfw = \
-	$(CPP) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi $< | $(AS68K) -m68360 -o $(obj)/wanxlfw.o; \
+	$(CC68K) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi -c -o $(obj)/wanxlfw.o $<; \
 	$(LD68K) --oformat binary -Ttext 0x1000 $(obj)/wanxlfw.o -o $(obj)/wanxlfw.bin; \
 	hexdump -ve '"\n" 16/1 "0x%02X,"' $(obj)/wanxlfw.bin | sed 's/0x  ,//g;1s/^/static const u8 firmware[]={/;$$s/,$$/\n};\n/' >$(obj)/wanxlfw.inc; \
 	rm -f $(obj)/wanxlfw.bin $(obj)/wanxlfw.o
-- 
2.17.1

