Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDAF4FCAE8
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245060AbiDLBCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344567AbiDLA6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:58:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE126286EF;
        Mon, 11 Apr 2022 17:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 272E761841;
        Tue, 12 Apr 2022 00:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7863C385A9;
        Tue, 12 Apr 2022 00:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724602;
        bh=yPzZImCeywqgb6Hi35+BrRKl0GUG10be3drdyior0oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdqGJEMM87RgMV62qiEaJQ8pJ7gO5vqRIu0P8Uv/Zb+vHLZwlJl3sz1x4q33VL2sX
         hc0Rx9BRlqC6IXNUlzhMe/4p8qZf5axPFTHImoGlvVisTKYDTrENnap4Lk0cyAP042
         34STeLTORW3T0zCbGA58TqVX9xUEgLX6DNkFQZ61LWX0nlITqkIJFKOswIE1ru+PvT
         oLBhrNbsbgGiJD4RnKGqUdWxZn4Wih+ePpNnZRS5W4H8aIA5tOQhZQE7w9dnKh+FO9
         dski6ZwxPzm5pumwLJTGpFgHNTVb39KjslmsICI7BoAWR9szQT/6CIBaMt5rjcM4LQ
         D7XUJ+Gfd3J/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 20/30] net: axienet: setup mdio unconditionally
Date:   Mon, 11 Apr 2022 20:48:54 -0400
Message-Id: <20220412004906.350678-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004906.350678-1-sashal@kernel.org>
References: <20220412004906.350678-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Chiu <andy.chiu@sifive.com>

[ Upstream commit d1c4f93e3f0a023024a6f022a61528c06cf1daa9 ]

The call to axienet_mdio_setup should not depend on whether "phy-node"
pressents on the DT. Besides, since `lp->phy_node` is used if PHY is in
SGMII or 100Base-X modes, move it into the if statement. And the next patch
will remove `lp->phy_node` from driver's private structure and do an
of_node_put on it right away after use since it is not used elsewhere.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index bbdcba88c021..3d91baf2e55a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2060,15 +2060,14 @@ static int axienet_probe(struct platform_device *pdev)
 	if (ret)
 		goto cleanup_clk;
 
-	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
-	if (lp->phy_node) {
-		ret = axienet_mdio_setup(lp);
-		if (ret)
-			dev_warn(&pdev->dev,
-				 "error registering MDIO bus: %d\n", ret);
-	}
+	ret = axienet_mdio_setup(lp);
+	if (ret)
+		dev_warn(&pdev->dev,
+			 "error registering MDIO bus: %d\n", ret);
+
 	if (lp->phy_mode == PHY_INTERFACE_MODE_SGMII ||
 	    lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX) {
+		lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 		if (!lp->phy_node) {
 			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
 			ret = -EINVAL;
-- 
2.35.1

