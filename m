Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98EA60714E
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 09:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJUHnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 03:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJUHnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 03:43:08 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 21 Oct 2022 00:43:07 PDT
Received: from mx.socionext.com (mx.socionext.com [202.248.49.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32236247E0C;
        Fri, 21 Oct 2022 00:43:06 -0700 (PDT)
Received: from unknown (HELO iyokan2-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 21 Oct 2022 16:42:03 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by iyokan2-ex.css.socionext.com (Postfix) with ESMTP id 1E0E520584CE;
        Fri, 21 Oct 2022 16:42:03 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Fri, 21 Oct 2022 16:42:03 +0900
Received: from plum.e01.socionext.com (unknown [10.212.243.119])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id 65360B62AE;
        Fri, 21 Oct 2022 16:42:02 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net] net: phy: Avoid WARN_ON for PHY_NOLINK during resuming
Date:   Fri, 21 Oct 2022 16:41:54 +0900
Message-Id: <20221021074154.25906-1-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When resuming from sleep, if there is a time lag from link-down to link-up
due to auto-negotiation, the phy status has been still PHY_NOLINK, so
WARN_ON dump occurs in mdio_bus_phy_resume(). For example, UniPhier AVE
ethernet takes about a few seconds to link up after resuming.

To avoid this issue, should remove PHY_NOLINK the WARN_ON conditions.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 drivers/net/phy/phy_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 57849ac0384e..c647d027bb5d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -318,12 +318,12 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 	phydev->suspended_by_mdio_bus = 0;
 
 	/* If we managed to get here with the PHY state machine in a state
-	 * neither PHY_HALTED, PHY_READY nor PHY_UP, this is an indication
-	 * that something went wrong and we should most likely be using
-	 * MAC managed PM, but we are not.
+	 * neither PHY_HALTED, PHY_READY, PHY_UP nor PHY_NOLINK, this is an
+	 * indication that something went wrong and we should most likely
+	 * be using MAC managed PM, but we are not.
 	 */
 	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY &&
-		phydev->state != PHY_UP);
+		phydev->state != PHY_UP && phydev->state != PHY_NOLINK);
 
 	ret = phy_init_hw(phydev);
 	if (ret < 0)
-- 
2.25.1

