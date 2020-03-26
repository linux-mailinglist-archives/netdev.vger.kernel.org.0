Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79C8193845
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 06:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgCZF61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 01:58:27 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:47767 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgCZF61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 01:58:27 -0400
Received: from pug.e01.socionext.com (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 02Q5ve95008573;
        Thu, 26 Mar 2020 14:57:41 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 02Q5ve95008573
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585202261;
        bh=2uTOiFNH4QFbkxz4iV+NRyMxIQi1X//IkZ1ebTA/LHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6p2A1sH/cOcvVT/1JsRsQgwZEZoGisPwlm7JAHSbQSW+JPUEEw+aDGk9u2hFkQVQ
         mK1WV49gdetPYWbd9qKYAW7o97Hu+5ngzn8Bqb5Hbui5lN8WuXRGTdV0DU/BPCYlBj
         Fvuv4LEJTkyHKftCZj5WoJWy0G6q1TOsiSkwSf3zqPl4E1dnRrBWlEDUSTE0fT3xP/
         al+ATvhSjduBLqWePdFthUvmRSxUudD6IS9hDemffxVTz6ZfYEwGb5Mso3Oficmwkj
         1Aelk8H+LqMyKnNMIaSS3O51iDRn2hsPubTX2SaphOVqaVaB3R7a9CjBLQ87yQu+oV
         Nxa78ly4HUaEQ==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     clang-built-linux@googlegroups.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/4] net: wan: wanxl: use $(M68KCC) instead of $(M68KAS) for rebuilding firmware
Date:   Thu, 26 Mar 2020 14:57:16 +0900
Message-Id: <20200326055719.16755-2-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200326055719.16755-1-masahiroy@kernel.org>
References: <20200326055719.16755-1-masahiroy@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The firmware source, wanxlfw.S, is currently compiled by the combo of
$(CPP) and $(M68KAS). This is not what we usually do for compiling *.S
files. In fact, this Makefile is the only user of $(AS) in the kernel
build.

Instead of combining $(CPP) and (AS) from different tool sets, using
$(M68KCC) as an assembler driver is simpler, and saner.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

Changes in v2: None

 drivers/net/wan/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index 995277c657a1..cf7a0a65aae8 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -40,16 +40,16 @@ $(obj)/wanxl.o:	$(obj)/wanxlfw.inc
 
 ifeq ($(CONFIG_WANXL_BUILD_FIRMWARE),y)
 ifeq ($(ARCH),m68k)
-  M68KAS = $(AS)
+  M68KCC = $(CC)
   M68KLD = $(LD)
 else
-  M68KAS = $(CROSS_COMPILE_M68K)as
+  M68KCC = $(CROSS_COMPILE_M68K)gcc
   M68KLD = $(CROSS_COMPILE_M68K)ld
 endif
 
 quiet_cmd_build_wanxlfw = BLD FW  $@
       cmd_build_wanxlfw = \
-	$(CPP) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi $< | $(M68KAS) -m68360 -o $(obj)/wanxlfw.o; \
+	$(M68KCC) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi -c -o $(obj)/wanxlfw.o $<; \
 	$(M68KLD) --oformat binary -Ttext 0x1000 $(obj)/wanxlfw.o -o $(obj)/wanxlfw.bin; \
 	hexdump -ve '"\n" 16/1 "0x%02X,"' $(obj)/wanxlfw.bin | sed 's/0x  ,//g;1s/^/static const u8 firmware[]={/;$$s/,$$/\n};\n/' >$(obj)/wanxlfw.inc; \
 	rm -f $(obj)/wanxlfw.bin $(obj)/wanxlfw.o
-- 
2.17.1

