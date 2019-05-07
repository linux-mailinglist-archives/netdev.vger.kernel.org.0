Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C4415B96
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbfEGFzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbfEGFiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:38:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 532FD216F4;
        Tue,  7 May 2019 05:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207489;
        bh=X+Td5GnClZk7jhagbMANLkJXafEsuhdlrC4IbZEKbGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsczW7A/iwjISG3zoW1GTdA1rDIDoXvj0Z62ccZD9tinvPj2t45WHnmz4FSWouECJ
         YhZLU61N3Lu0YxvzvGUuMjAz5tta9anIco791IClCw4EL27S8uMydBcgTJ2Nq/ktuq
         Km7YQYUswLnmEcyb3Dv0e/1okY6SoI/sTL3Jo9qQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 72/81] net: fec: manage ahb clock in runtime pm
Date:   Tue,  7 May 2019 01:35:43 -0400
Message-Id: <20190507053554.30848-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Duan <fugang.duan@nxp.com>

[ Upstream commit d7c3a206e6338e4ccdf030719dec028e26a521d5 ]

Some SOC like i.MX6SX clock have some limits:
- ahb clock should be disabled before ipg.
- ahb and ipg clocks are required for MAC MII bus.
So, move the ahb clock to runtime management together with
ipg clock.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 30 ++++++++++++++++-------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 7b98bb75ba8a..ad41ace0a27a 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1850,13 +1850,9 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 	int ret;
 
 	if (enable) {
-		ret = clk_prepare_enable(fep->clk_ahb);
-		if (ret)
-			return ret;
-
 		ret = clk_prepare_enable(fep->clk_enet_out);
 		if (ret)
-			goto failed_clk_enet_out;
+			return ret;
 
 		if (fep->clk_ptp) {
 			mutex_lock(&fep->ptp_clk_mutex);
@@ -1876,7 +1872,6 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 
 		phy_reset_after_clk_enable(ndev->phydev);
 	} else {
-		clk_disable_unprepare(fep->clk_ahb);
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
 			mutex_lock(&fep->ptp_clk_mutex);
@@ -1895,8 +1890,6 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 failed_clk_ptp:
 	if (fep->clk_enet_out)
 		clk_disable_unprepare(fep->clk_enet_out);
-failed_clk_enet_out:
-		clk_disable_unprepare(fep->clk_ahb);
 
 	return ret;
 }
@@ -3485,6 +3478,9 @@ fec_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(fep->clk_ipg);
 	if (ret)
 		goto failed_clk_ipg;
+	ret = clk_prepare_enable(fep->clk_ahb);
+	if (ret)
+		goto failed_clk_ahb;
 
 	fep->reg_phy = devm_regulator_get(&pdev->dev, "phy");
 	if (!IS_ERR(fep->reg_phy)) {
@@ -3578,6 +3574,9 @@ fec_probe(struct platform_device *pdev)
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 failed_regulator:
+	clk_disable_unprepare(fep->clk_ahb);
+failed_clk_ahb:
+	clk_disable_unprepare(fep->clk_ipg);
 failed_clk_ipg:
 	fec_enet_clk_enable(ndev, false);
 failed_clk:
@@ -3701,6 +3700,7 @@ static int __maybe_unused fec_runtime_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
+	clk_disable_unprepare(fep->clk_ahb);
 	clk_disable_unprepare(fep->clk_ipg);
 
 	return 0;
@@ -3710,8 +3710,20 @@ static int __maybe_unused fec_runtime_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
+	int ret;
 
-	return clk_prepare_enable(fep->clk_ipg);
+	ret = clk_prepare_enable(fep->clk_ahb);
+	if (ret)
+		return ret;
+	ret = clk_prepare_enable(fep->clk_ipg);
+	if (ret)
+		goto failed_clk_ipg;
+
+	return 0;
+
+failed_clk_ipg:
+	clk_disable_unprepare(fep->clk_ahb);
+	return ret;
 }
 
 static const struct dev_pm_ops fec_pm_ops = {
-- 
2.20.1

