Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA42686684
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjBANPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbjBANPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:15:33 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D13066A6F;
        Wed,  1 Feb 2023 05:15:31 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,263,1669042800"; 
   d="scan'208";a="148127788"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 01 Feb 2023 22:15:29 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 21494400C738;
        Wed,  1 Feb 2023 22:15:29 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v5 4/5] net: renesas: rswitch: Add phy_power_{on,off}() calling
Date:   Wed,  1 Feb 2023 22:14:53 +0900
Message-Id: <20230201131454.1928136-5-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201131454.1928136-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230201131454.1928136-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some Ethernet PHYs (like marvell10g) will decide the host interface
mode by the media-side speed. So, the rswitch driver needs to
initialize one of the Ethernet SERDES (r8a779f0-eth-serdes) ports
after linked the Ethernet PHY up. The r8a779f0-eth-serdes driver has
.init() for initializing all ports and .power_on() for initializing
each port. So, add phy_power_{on,off} calling for it.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index f8b3a81c0447..f1a0dd1098f9 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1146,6 +1146,11 @@ static void rswitch_adjust_link(struct net_device *ndev)
 	/* Current hardware has a restriction not to change speed at runtime */
 	if (phydev->link != rdev->etha->link) {
 		phy_print_status(phydev);
+		if (phydev->link)
+			phy_power_on(rdev->serdes);
+		else
+			phy_power_off(rdev->serdes);
+
 		rdev->etha->link = phydev->link;
 	}
 }
-- 
2.25.1

