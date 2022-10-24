Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A925D609B37
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 09:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiJXHWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 03:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJXHWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 03:22:47 -0400
Received: from mx.socionext.com (mx.socionext.com [202.248.49.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AD9A5D13A;
        Mon, 24 Oct 2022 00:22:43 -0700 (PDT)
Received: from unknown (HELO iyokan2-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 24 Oct 2022 16:22:41 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by iyokan2-ex.css.socionext.com (Postfix) with ESMTP id 7078F20584CE;
        Mon, 24 Oct 2022 16:22:41 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Mon, 24 Oct 2022 16:22:41 +0900
Received: from plum.e01.socionext.com (unknown [10.212.243.119])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id C1CA7B62A4;
        Mon, 24 Oct 2022 16:22:40 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller " <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net] net: ethernet: ave: Fix MAC to be in charge of PHY PM
Date:   Mon, 24 Oct 2022 16:22:27 +0900
Message-Id: <20221024072227.24769-1-hayashi.kunihiko@socionext.com>
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

The phylib callback is called after MAC driver's own resume callback is
called. For AVE driver, after resuming immediately, PHY state machine is
in PHY_NOLINK because there is a time lag from link-down to link-up due to
autoneg. The result is WARN_ON() dump in mdio_bus_phy_resume().

Since ave_resume() itself calls phy_resume(), AVE driver should manage
PHY PM. To indicate that MAC driver manages PHY PM, set
phydev->mac_managed_pm to true to avoid the unnecessary phylib call and
add missing phy_init_hw() to ave_resume().

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 drivers/net/ethernet/socionext/sni_ave.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 1fa09b49ba7f..d2c6a5dfdc0e 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1229,6 +1229,8 @@ static int ave_init(struct net_device *ndev)
 
 	phy_support_asym_pause(phydev);
 
+	phydev->mac_managed_pm = true;
+
 	phy_attached_info(phydev);
 
 	return 0;
@@ -1756,6 +1758,10 @@ static int ave_resume(struct device *dev)
 
 	ave_global_reset(ndev);
 
+	ret = phy_init_hw(ndev->phydev);
+	if (ret)
+		return ret;
+
 	ave_ethtool_get_wol(ndev, &wol);
 	wol.wolopts = priv->wolopts;
 	__ave_ethtool_set_wol(ndev, &wol);
-- 
2.25.1

