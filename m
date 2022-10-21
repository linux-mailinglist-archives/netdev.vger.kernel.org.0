Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38B5607DD3
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 19:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJURqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 13:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiJURq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 13:46:27 -0400
Received: from mx.socionext.com (mx.socionext.com [202.248.49.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3628E21E101;
        Fri, 21 Oct 2022 10:46:17 -0700 (PDT)
Received: from unknown (HELO iyokan2-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 22 Oct 2022 02:46:17 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by iyokan2-ex.css.socionext.com (Postfix) with ESMTP id 33C4F20584CE;
        Sat, 22 Oct 2022 02:46:17 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Sat, 22 Oct 2022 02:46:17 +0900
Received: from plum.e01.socionext.com (unknown [10.212.243.119])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id 9DB20B62A4;
        Sat, 22 Oct 2022 02:46:16 +0900 (JST)
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
Subject: [PATCH net] net: ethernet: ave: Remove duplicate suspend/resume calls for phy
Date:   Sat, 22 Oct 2022 02:45:52 +0900
Message-Id: <20221021174552.6828-1-hayashi.kunihiko@socionext.com>
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

Since AVE has its own suspend/resume functions, there is no need to call
mdio_bus suspend/resume functions. Set phydev->mac_managed_pm to true
to avoid the calls.

In addition, ave_open() executes __phy_resume() via phy_start() in
ave_resume(), so no need to call phy_resume() explicitly. Remove it.

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Fixes: 0ba78b4a4989 ("net: ethernet: ave: Add suspend/resume support")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 drivers/net/ethernet/socionext/sni_ave.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 14cdd2e8373c..b4e0c57af7c3 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1271,6 +1271,8 @@ static int ave_init(struct net_device *ndev)
 
 	phy_support_asym_pause(phydev);
 
+	phydev->mac_managed_pm = true;
+
 	phy_attached_info(phydev);
 
 	return 0;
@@ -1806,12 +1808,6 @@ static int ave_resume(struct device *dev)
 	wol.wolopts = priv->wolopts;
 	__ave_ethtool_set_wol(ndev, &wol);
 
-	if (ndev->phydev) {
-		ret = phy_resume(ndev->phydev);
-		if (ret)
-			return ret;
-	}
-
 	if (netif_running(ndev)) {
 		ret = ave_open(ndev);
 		netif_device_attach(ndev);
-- 
2.25.1

