Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697AC3D9F74
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 10:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbhG2IZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 04:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbhG2IZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 04:25:06 -0400
X-Greylist: delayed 2445 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 29 Jul 2021 01:25:04 PDT
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DABC061757
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 01:25:04 -0700 (PDT)
Received: from dslb-178-004-206-097.178.004.pools.vodafone-ip.de ([178.4.206.97] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1m90iE-0000O4-Dp; Thu, 29 Jul 2021 09:44:14 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH] niu: read property length only if we use it
Date:   Thu, 29 Jul 2021 09:43:54 +0200
Message-Id: <20210729074354.557-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In three places, the driver calls of_get_property and reads the property
length although the length is not used. Update the calls to not request
the length.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/net/ethernet/sun/niu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 860644d182ab..f37c235d9634 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9208,7 +9208,7 @@ static int niu_get_of_props(struct niu *np)
 	else
 		dp = pci_device_to_OF_node(np->pdev);
 
-	phy_type = of_get_property(dp, "phy-type", &prop_len);
+	phy_type = of_get_property(dp, "phy-type", NULL);
 	if (!phy_type) {
 		netdev_err(dev, "%pOF: OF node lacks phy-type property\n", dp);
 		return -EINVAL;
@@ -9242,12 +9242,12 @@ static int niu_get_of_props(struct niu *np)
 		return -EINVAL;
 	}
 
-	model = of_get_property(dp, "model", &prop_len);
+	model = of_get_property(dp, "model", NULL);
 
 	if (model)
 		strcpy(np->vpd.model, model);
 
-	if (of_find_property(dp, "hot-swappable-phy", &prop_len)) {
+	if (of_find_property(dp, "hot-swappable-phy", NULL)) {
 		np->flags |= (NIU_FLAGS_10G | NIU_FLAGS_FIBER |
 			NIU_FLAGS_HOTPLUG_PHY);
 	}
-- 
2.20.1

