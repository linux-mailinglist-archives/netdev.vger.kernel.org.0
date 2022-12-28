Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704FC657449
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 09:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiL1Isd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 03:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbiL1IsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 03:48:09 -0500
X-Greylist: delayed 1808 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Dec 2022 00:45:22 PST
Received: from mail1.wrs.com (mail1.windriver.com [147.11.146.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9DB396;
        Wed, 28 Dec 2022 00:45:22 -0800 (PST)
Received: from mail.windriver.com (mail.wrs.com [147.11.1.11])
        by mail1.wrs.com (8.15.2/8.15.2) with ESMTPS id 2BS8Ep4n001781
        (version=TLSv1.1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Wed, 28 Dec 2022 00:14:51 -0800
Received: from pek-lpd-ccm4.wrs.com (pek-lpd-ccm4.wrs.com [128.224.153.194])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTP id 2BS8ElXl025145;
        Wed, 28 Dec 2022 00:14:48 -0800 (PST)
From:   jiguang.xiao@windriver.com
To:     thomas.lendacky@amd.com, Shyam-sundar.S-k@amd.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Prashant.Chikhalkar@windriver.com,
        zhaolong.zhang@windriver.com, Rick.Ilowite@windriver.com,
        Jiguang.Xiao@windriver.com
Subject: [PATCH] net: amd-xgbe: add missed tasklet_kill
Date:   Wed, 28 Dec 2022 16:14:47 +0800
Message-Id: <20221228081447.3400369-1-jiguang.xiao@windriver.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiguang Xiao <jiguang.xiao@windriver.com>

The driver does not call tasklet_kill in several places.
Add the calls to fix it.

Fixes: 85b85c853401 (amd-xgbe: Re-issue interrupt if interrupt status
not cleared)
Signed-off-by: Jiguang Xiao <jiguang.xiao@windriver.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 3 +++
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c  | 4 +++-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 4 +++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 7b666106feee..614c0278419b 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1064,6 +1064,9 @@ static void xgbe_free_irqs(struct xgbe_prv_data *pdata)
 
 	devm_free_irq(pdata->dev, pdata->dev_irq, pdata);
 
+	tasklet_kill(&pdata->tasklet_dev);
+	tasklet_kill(&pdata->tasklet_ecc);
+
 	if (pdata->vdata->ecc_support && (pdata->dev_irq != pdata->ecc_irq))
 		devm_free_irq(pdata->dev, pdata->ecc_irq, pdata);
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
index 22d4fc547a0a..a9ccc4258ee5 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
@@ -447,8 +447,10 @@ static void xgbe_i2c_stop(struct xgbe_prv_data *pdata)
 	xgbe_i2c_disable(pdata);
 	xgbe_i2c_clear_all_interrupts(pdata);
 
-	if (pdata->dev_irq != pdata->i2c_irq)
+	if (pdata->dev_irq != pdata->i2c_irq) {
 		devm_free_irq(pdata->dev, pdata->i2c_irq, pdata);
+		tasklet_kill(&pdata->tasklet_i2c);
+	}
 }
 
 static int xgbe_i2c_start(struct xgbe_prv_data *pdata)
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 4e97b4869522..0c5c1b155683 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1390,8 +1390,10 @@ static void xgbe_phy_stop(struct xgbe_prv_data *pdata)
 	/* Disable auto-negotiation */
 	xgbe_an_disable_all(pdata);
 
-	if (pdata->dev_irq != pdata->an_irq)
+	if (pdata->dev_irq != pdata->an_irq) {
 		devm_free_irq(pdata->dev, pdata->an_irq, pdata);
+		tasklet_kill(&pdata->tasklet_an);
+	}
 
 	pdata->phy_if.phy_impl.stop(pdata);
 
-- 
2.37.3

