Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E89514314
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 09:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355029AbiD2HT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 03:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350592AbiD2HTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 03:19:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AB92A268;
        Fri, 29 Apr 2022 00:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651216598; x=1682752598;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Jnp7VUJ3Kt3yfs883mG6J/QgdChRVfQlhme5tpgD6Xo=;
  b=FBGjmByuOqTGpnIc3UFAMzcjKw/3JbNs9EefHUQXDdzus2DR1W70+unw
   UL/UQrD71vRbqh1nR/wsTpL9UPW1tNW+XiERXcAwlKi1OdQkCNwr+E5oq
   AWoFCWCIjPfLBMXbZzFgc+xaWasJ2pM3pKPv9pYXOUPZuNW09XMO5LjwM
   Inr3AmurSOUnClIsIZS+SfjmYM/Wbsmu96r5oFhinMjTq7S5r710p0wMW
   ZAc/csLiYry4fVl/RAdgi15vY1z2d45HOq7FTDJxLJxMmK42iAgZJk7Ki
   GSBfFV6d41iBU7b7Dk2yDTVAUm1GhMetVcky24pZPCiCH/TsjfWrg9w6C
   A==;
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="157258539"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Apr 2022 00:16:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 29 Apr 2022 00:16:37 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 29 Apr 2022 00:16:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <richardcochran@gmail.com>, <davem@davemloft.net>, <arnd@arndb.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: lan966x: Fix compilation error
Date:   Fri, 29 Apr 2022 09:19:53 +0200
Message-ID: <20220429071953.4079517-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting from the blamed commit, the lan966x build fails with the
following compilation error:

drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c:342:9: error: implicit declaration of function ‘ptp_find_pin_unlocked’ [-Werror=implicit-function-declaration]
  342 |   pin = ptp_find_pin_unlocked(phc->clock, PTP_PF_EXTTS, 0);

The issue is that there is no stub function for ptp_find_pin_unlocked
in case CONFIG_PTP_1588_CLOCK is not selected. Therefore add one.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: f3d8e0a9c28ba0 ("net: lan966x: Add support for PTP_PF_EXTTS")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/linux/ptp_clock_kernel.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 554454cb8693..e8cc8b6bbf50 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -321,6 +321,10 @@ static inline int ptp_clock_index(struct ptp_clock *ptp)
 static inline int ptp_find_pin(struct ptp_clock *ptp,
 			       enum ptp_pin_function func, unsigned int chan)
 { return -1; }
+static inline int ptp_find_pin_unlocked(struct ptp_clock *ptp,
+					enum ptp_pin_function func,
+					unsigned int chan)
+{ return -1; }
 static inline int ptp_schedule_worker(struct ptp_clock *ptp,
 				      unsigned long delay)
 { return -EOPNOTSUPP; }
-- 
2.33.0

