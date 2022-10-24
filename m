Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532EB609B39
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 09:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiJXHXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 03:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiJXHXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 03:23:19 -0400
Received: from mx.socionext.com (mx.socionext.com [202.248.49.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D276E5C9CE;
        Mon, 24 Oct 2022 00:23:17 -0700 (PDT)
Received: from unknown (HELO iyokan2-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 24 Oct 2022 16:23:17 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by iyokan2-ex.css.socionext.com (Postfix) with ESMTP id 09E2A20584CE;
        Mon, 24 Oct 2022 16:23:17 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Mon, 24 Oct 2022 16:23:17 +0900
Received: from plum.e01.socionext.com (unknown [10.212.243.119])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id B63E5B62A4;
        Mon, 24 Oct 2022 16:23:16 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller " <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net-next] net: ethernet: ave: Remove duplicate phy_resume() calls
Date:   Mon, 24 Oct 2022 16:23:14 +0900
Message-Id: <20221024072314.24969-1-hayashi.kunihiko@socionext.com>
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

ave_open() in ave_resume() executes __phy_resume() via phy_start(), so no
need to call phy_resume() explicitly. Remove it.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 drivers/net/ethernet/socionext/sni_ave.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index d2c6a5dfdc0e..c6a6c9ed5365 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1766,12 +1766,6 @@ static int ave_resume(struct device *dev)
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

