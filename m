Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD374B37FE
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 21:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiBLUnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 15:43:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiBLUnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 15:43:31 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986315F8E9;
        Sat, 12 Feb 2022 12:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644698606; x=1676234606;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=865xgBAGLS9M9pQmk730tUbkudteDk+0PgJQjpc9UcQ=;
  b=2HRnSd7nZMkxzmYde7SHUZ3M7ABe0DznrdktXKOfRs1B68hR9lMtTWQ1
   2DYpLdnIznMHV8BoH0eXmIkSCqQ4BJIXmFIXMEXj1D43dy8vrQmyUciRs
   2/lMkc/0J9RwIDH0jO9A00fQqmcKMQRmZ2tinOrT/KPo8XpokuQzIgCqo
   bmsenzM1DE/xuDFpL0VSTE4ASBLGpOYrPPaGCoKSEKFInwg98dX1vo3tI
   jB875RfFHPqV3tAnzPzjO5r6nBX4k9LVPqR1PNZvxDhmGf+874CcxgjvL
   G/6WcFDSoL3+gQoT6NhZgXNP2e/7VHPF27O584s3yzhy9Mlc/m1rli9Ib
   w==;
IronPort-SDR: O+oR+Kbr27QK/vOlB0HaonLLrgiTC3irxJj7Phq/fTKnQgK/rxJOrTN+uT4c3Jwpxt8W8+8V5C
 oT+lSYqjQaxOH5lRUE380tGFw4onzSi46ibGfREYDxAZLQXZqFVgOhUInlYphJ0572aX5hpZCM
 2wPUtN1HWDoDCYhmscs8cPcEWS331A6K2wejJtGTJvw2SaOxubq/c3zW60q3O2eEjVV90yLLen
 3Ut40a+2tuyfNUm2kh+yX5DaGR3sQEowljAlMLONTF3VQas5Jbeju8S8PSiQ8jlajUB1oqHnLi
 dehGsEeLEVJCBphFOdGRRibl
X-IronPort-AV: E=Sophos;i="5.88,364,1635231600"; 
   d="scan'208";a="153393716"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2022 13:43:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 12 Feb 2022 13:43:24 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 12 Feb 2022 13:43:23 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: lan966x: Fix when CONFIG_PTP_1588_CLOCK is compiled as module
Date:   Sat, 12 Feb 2022 21:45:44 +0100
Message-ID: <20220212204544.972787-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_PTP_1588_CLOCK is compiled as a module, then the linking of
the lan966x fails because it can't find references to the following
functions 'ptp_clock_index', 'ptp_clock_register' and
'ptp_clock_unregister'

The fix consists in adding CONFIG_PTP_1588_CLOCK_OPTIONAL as a
dependency for the driver.

Fixes: d096459494a887 ("net: lan966x: Add support for ptp clocks")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
index ac273f84b69e..4241ff0e5098 100644
--- a/drivers/net/ethernet/microchip/lan966x/Kconfig
+++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
@@ -1,5 +1,6 @@
 config LAN966X_SWITCH
 	tristate "Lan966x switch driver"
+	depends on PTP_1588_CLOCK_OPTIONAL
 	depends on HAS_IOMEM
 	depends on OF
 	depends on NET_SWITCHDEV
-- 
2.33.0

