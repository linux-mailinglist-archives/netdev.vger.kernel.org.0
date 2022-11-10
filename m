Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129176238CB
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 02:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiKJB1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 20:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiKJB1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 20:27:42 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6488122B13;
        Wed,  9 Nov 2022 17:27:41 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,152,1665414000"; 
   d="scan'208";a="139532487"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 10 Nov 2022 10:27:40 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 14F4041311DC;
        Thu, 10 Nov 2022 10:27:40 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] net: ethernet: renesas: rswitch: Fix build error about ptp
Date:   Thu, 10 Nov 2022 10:27:20 +0900
Message-Id: <20221110012720.3552060-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_PTP_1588_CLOCK_OPTIONAL=m and CONFIG_RENESAS_ETHER_SWITCH=y,
the following build error happened:

    aarch64-linux-ld: DWARF error: could not find abbrev number 60
    drivers/net/ethernet/renesas/rswitch.o: in function `rswitch_get_ts_info':
    rswitch.c:(.text+0x408): undefined reference to `ptp_clock_index'
    aarch64-linux-ld: DWARF error: could not find abbrev number 1190123
    drivers/net/ethernet/renesas/rcar_gen4_ptp.o: in function `rcar_gen4_ptp_register':
    rcar_gen4_ptp.c:(.text+0x4dc): undefined reference to `ptp_clock_register'
    aarch64-linux-ld: drivers/net/ethernet/renesas/rcar_gen4_ptp.o: in function `rcar_gen4_ptp_unregister':
    rcar_gen4_ptp.c:(.text+0x584): undefined reference to `ptp_clock_unregister'

To fix the issue, add "depends on PTP_1588_CLOCK_OPTIONAL" into the
Kconfig.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 6c6fa1a00ad3 ("net: ethernet: renesas: rswitch: Add R-Car Gen4 gPTP support")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/Kconfig b/drivers/net/ethernet/renesas/Kconfig
index 7a5e26b6ea9b..3ceb57408ed0 100644
--- a/drivers/net/ethernet/renesas/Kconfig
+++ b/drivers/net/ethernet/renesas/Kconfig
@@ -45,6 +45,7 @@ config RAVB
 config RENESAS_ETHER_SWITCH
 	tristate "Renesas Ethernet Switch support"
 	depends on ARCH_RENESAS || COMPILE_TEST
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select CRC32
 	select MII
 	select PHYLINK
-- 
2.25.1

