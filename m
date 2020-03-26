Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B03193842
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 06:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgCZF60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 01:58:26 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:47754 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgCZF60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 01:58:26 -0400
Received: from pug.e01.socionext.com (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 02Q5ve96008573;
        Thu, 26 Mar 2020 14:57:41 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 02Q5ve96008573
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585202262;
        bh=RjmAIJifJD5EjYLBPngifFMr8SyoOw1VRH4zJbCaW44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0npEybbV/z2lQiHwEs9TcPf5+poHUosRxXgwWfTNlY0D593Lc5sxgg3TW8bgnxjmY
         7hX43Es4EaTmdEOf4fzkcusWx/1+rz6MrwYd6v+Sgx5BafCADuzRTM9ELLBUC7o/V0
         p0CChm95KUAbSKBF8tUVnBi2vopRnHPeWX6kc4ikco8XHPW2fuRYfqS5ef6B5L67yx
         l82dEkMArUHtg2RAAgAAkB68/UWwxidScmcuTX1Jrgch3QVGFzcj0jzOKZLW6EaLJB
         DWXLqcaQCOUX5TqMRC+xe0gQ8t3tlF3zs+s5tPdGhdAB4j9vo6qHcv2R1J7YOvSgkh
         mP0gwu3qrBwjA==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     clang-built-linux@googlegroups.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 3/4] net: wan: wanxl: refactor the firmware rebuild rule
Date:   Thu, 26 Mar 2020 14:57:17 +0900
Message-Id: <20200326055719.16755-3-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200326055719.16755-1-masahiroy@kernel.org>
References: <20200326055719.16755-1-masahiroy@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the big recipe into 3 stages, compile, link, and hexdump.

After this commit, the build log with CONFIG_WANXL_BUILD_FIRMWARE
will look like this:

  M68KAS  drivers/net/wan/wanxlfw.o
  M68KLD  drivers/net/wan/wanxlfw.bin
  BLDFW   drivers/net/wan/wanxlfw.inc
  CC [M]  drivers/net/wan/wanxl.o

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

Changes in v2: None

 drivers/net/wan/Makefile | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index cf7a0a65aae8..380271a011e4 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -47,14 +47,23 @@ else
   M68KLD = $(CROSS_COMPILE_M68K)ld
 endif
 
-quiet_cmd_build_wanxlfw = BLD FW  $@
-      cmd_build_wanxlfw = \
-	$(M68KCC) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi -c -o $(obj)/wanxlfw.o $<; \
-	$(M68KLD) --oformat binary -Ttext 0x1000 $(obj)/wanxlfw.o -o $(obj)/wanxlfw.bin; \
-	hexdump -ve '"\n" 16/1 "0x%02X,"' $(obj)/wanxlfw.bin | sed 's/0x  ,//g;1s/^/static const u8 firmware[]={/;$$s/,$$/\n};\n/' >$(obj)/wanxlfw.inc; \
-	rm -f $(obj)/wanxlfw.bin $(obj)/wanxlfw.o
-
-$(obj)/wanxlfw.inc:	$(src)/wanxlfw.S
-	$(call if_changed_dep,build_wanxlfw)
-targets += wanxlfw.inc
+quiet_cmd_build_wanxlfw = BLDFW   $@
+      cmd_build_wanxlfw = hexdump -ve '"\n" 16/1 "0x%02X,"' $< | \
+	sed 's/0x  ,//g;1s/^/static const u8 firmware[]={/;$$s/,$$/\n};\n/' > $@
+
+$(obj)/wanxlfw.inc: $(obj)/wanxlfw.bin FORCE
+	$(call if_changed,build_wanxlfw)
+
+quiet_cmd_m68kld_bin_o = M68KLD  $@
+      cmd_m68kld_bin_o = $(M68KLD) --oformat binary -Ttext 0x1000 $< -o $@
+
+$(obj)/wanxlfw.bin: $(obj)/wanxlfw.o FORCE
+	$(call if_changed,m68kld_bin_o)
+
+quiet_cmd_m68kas_o_S = M68KAS  $@
+      cmd_m68kas_o_S = $(M68KCC) -D__ASSEMBLY__ -Wp,-MD,$(depfile) -I$(srctree)/include/uapi -c -o $@ $<
+
+$(obj)/wanxlfw.o: $(src)/wanxlfw.S FORCE
+	$(call if_changed_dep,m68kas_o_S)
 endif
+targets += wanxlfw.inc wanxlfw.bin wanxlfw.o
-- 
2.17.1

