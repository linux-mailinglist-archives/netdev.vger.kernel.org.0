Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012394B37BE
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 21:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiBLUBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 15:01:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiBLUBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 15:01:18 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C31E606D7;
        Sat, 12 Feb 2022 12:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644696072; x=1676232072;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d0DS+k2B48x1LKNiNwOvKw674APKKWNOcQf8jm2jyIw=;
  b=zzyRgJ6w05KLUQGkK5vwe1we4VwXPEeks5CvCTbgl8Ml+fS9VYYm0k9I
   iyumOQy8YYQ8fDZ6V2jhawUMVNZS+j1oweaj8wOFdg6hNks45FqWxJ0Y2
   i8pJzzhwQHXUBeQrbfCKGRQEVq0iaO1nyZMiIaxPB5fU6rls4+adQp+6D
   SmQhTXBarD3XOrTPY/COXUjH+DM4mqUVkQ7VePlLhq5xAVU+nPcyUXwmm
   jfAP0QCP4Z7pqUjy/EZwzkpRHR+G3KLKdACarE2LzIe5vO08aiiehBm2Y
   S4t2nPq3+Mfa5lW5SbcGkJg89TsYeU8Cx93ovfeDIJuQ0vTe5NzBXlSp6
   Q==;
IronPort-SDR: C5ZbInOsxj80jUP9AlvyA3up/q2OqrDAPvigCxZQNuIygKh9mXvKXalcFj1zscSmI+1xPlptHD
 WI6Hc7tex7fhyAFlzKSfdRfF8EFfKCvTEyCCK5DNbHy9JgPWAzq2t6AyOdDlAjU3mKmNVUEAGz
 W7sB79zLKc64ngFPItm9INMruj6B/Pidj3bTulAjUacjzoZTe1amqTeYzYzYPNIMvDnjIQh2lX
 PCRiq6906m4QV7YQmclXyGLQYmk4MMHwVwgaSm3wLSVoolXezFT10Pa8mIQYbnNpSKBHhMajQm
 u/bVLt/qr/5nMIsA0Mirw7kS
X-IronPort-AV: E=Sophos;i="5.88,364,1635231600"; 
   d="scan'208";a="85518995"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2022 13:01:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 12 Feb 2022 13:01:10 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 12 Feb 2022 13:01:09 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "kernel test robot" <lkp@intel.com>
Subject: [PATCH net-next v2] net: lan966x: Fix when CONFIG_IPV6 is not set
Date:   Sat, 12 Feb 2022 21:03:43 +0100
Message-ID: <20220212200343.921107-1-horatiu.vultur@microchip.com>
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

When CONFIG_IPV6 is not set, then the linking of the lan966x driver
fails with the following error:

drivers/net/ethernet/microchip/lan966x/lan966x_main.c:444: undefined
reference to `ipv6_mc_check_mld'

The fix consists in adding a check also for IS_ENABLED(CONFIG_IPV6)

Fixes: 47aeea0d57e80c ("net: lan966x: Implement the callback SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v1->v2:
- use IS_ENABLED(CONFIG_IPV6) instead of #ifdef
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index d62484f14564..4e877d9859bf 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -439,7 +439,8 @@ static bool lan966x_hw_offload(struct lan966x *lan966x, u32 port,
 	    ip_hdr(skb)->protocol == IPPROTO_IGMP)
 		return false;
 
-	if (skb->protocol == htons(ETH_P_IPV6) &&
+	if (IS_ENABLED(CONFIG_IPV6) &&
+	    skb->protocol == htons(ETH_P_IPV6) &&
 	    ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
 	    !ipv6_mc_check_mld(skb))
 		return false;
-- 
2.33.0

