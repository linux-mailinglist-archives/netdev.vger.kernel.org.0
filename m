Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2666B4AEF32
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 11:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiBIKWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 05:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbiBIKWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 05:22:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1162DE1238F7;
        Wed,  9 Feb 2022 02:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644401803; x=1675937803;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gOYuPQ6dWgF1FusoULpbO/FDaKmDWcPywDql506vEek=;
  b=RLdIK9Nc8GJZ3QYzHmVWNLaRk5Po9P1kzz4vbSb51xIJLWAV9FxSpctl
   roA4cdh463sJ/Si4D2oF8SV6O13rbMsrzhLXSInFAwAbifNAeoujdsGuR
   EOfmDvc5CpBwO1KIMMMp1/tSE/cHvwyrGJ+VDY9GwspVjSHY5bFkCmEV+
   6nRDMJPckTwsdrtljVogHcrAjOOzxp986j5a54vTlSsWEl6BWagzH3Tj4
   qyLtBR2tHuqqXqJoFXh6wfo5wBovlHw01fo0P3FqehQCYrob12ZQ+/aTN
   Y7q1qVmHuX65lr+f8s+azNBs7yrc7zzw3GaLIFXED3akZioVeJnTElOwO
   Q==;
IronPort-SDR: ntgf5eIqpbSay6+2xVHrEe4VepzensbJ0vhqzV8pIDje/eZl4hBICneIOSf2nL6FybI0slvbyo
 rqplrHVelTB4pceejbEVidLc5fui7CQFnxLpoDZWRlPQ4heQ/7X+64BkRpQFuiNK9LM+licBJr
 k0bvqaef7mjk1307nW+oLbxHY3y+sy5dAj/qg8wNNJ+GMdI5a1MMZgnI+XHDSpaYlz1l8KV5Vb
 a5FkR0xzPmRQVxVW9kW3uBP43qj2VvzwD3Eoo9jDVqo491NarwFlLbEzcF3AM8Ezbo3Q4U/vMU
 5aoRswjdnorX84cPEwLpfLrN
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="152969584"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2022 03:16:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 9 Feb 2022 03:16:03 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 9 Feb 2022 03:16:01 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, Horatiu Vultur <horatiu.vultur@microchip.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: lan966x: Fix when CONFIG_IPV6 is not set
Date:   Wed, 9 Feb 2022 11:18:23 +0100
Message-ID: <20220209101823.1270489-1-horatiu.vultur@microchip.com>
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

When CONFIG_IPV6 is not set, then the compilation of the lan966x driver
fails with the following error:

drivers/net/ethernet/microchip/lan966x/lan966x_main.c:444: undefined
reference to `ipv6_mc_check_mld'

The fix consists in adding #ifdef around this code.

Fixes: 47aeea0d57e80c ("net: lan966x: Implement the callback SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index d62484f14564..526dc41e98f8 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -439,10 +439,12 @@ static bool lan966x_hw_offload(struct lan966x *lan966x, u32 port,
 	    ip_hdr(skb)->protocol == IPPROTO_IGMP)
 		return false;
 
+#if IS_ENABLED(CONFIG_IPV6)
 	if (skb->protocol == htons(ETH_P_IPV6) &&
 	    ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
 	    !ipv6_mc_check_mld(skb))
 		return false;
+#endif
 
 	return true;
 }
-- 
2.33.0

