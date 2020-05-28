Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75261E5FED
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388869AbgE1L44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388844AbgE1L4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:56:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19EAE207D3;
        Thu, 28 May 2020 11:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667010;
        bh=mJ93CnXc9YSI6aOXXURM2kusgG8AVDTiDJs40asWSXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLO+AGUk5CbQRxpLv4uy/vEiv+OifPojL5eOHd6cxR0uWnd+jwY2zxuT3Zqu7DZjp
         DAqIjGoFphjq8C7OoDVp+C0HUxAU2TZF2h+mzt2w1wtteVM1FDlapRBZMqzTRm71kf
         uoCMtKlJFHAoDK7BnpJvpMDOO7Uk6dHUQWcBXVS4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 44/47] net: Fix return value about devm_platform_ioremap_resource()
Date:   Thu, 28 May 2020 07:55:57 -0400
Message-Id: <20200528115600.1405808-44-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit ef24d6c3d6965158dfe23ae961d87e9a343e18a2 ]

When call function devm_platform_ioremap_resource(), we should use IS_ERR()
to check the return value and return PTR_ERR() if failed.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/ifi_canfd/ifi_canfd.c     | 5 ++++-
 drivers/net/can/sun4i_can.c               | 2 +-
 drivers/net/dsa/b53/b53_srab.c            | 2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c | 2 +-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index 04d59bede5ea..74503cacf594 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -947,8 +947,11 @@ static int ifi_canfd_plat_probe(struct platform_device *pdev)
 	u32 id, rev;
 
 	addr = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
+
 	irq = platform_get_irq(pdev, 0);
-	if (IS_ERR(addr) || irq < 0)
+	if (irq < 0)
 		return -EINVAL;
 
 	id = readl(addr + IFI_CANFD_IP_ID);
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index e3ba8ab0cbf4..e2c6cf4b2228 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -792,7 +792,7 @@ static int sun4ican_probe(struct platform_device *pdev)
 
 	addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(addr)) {
-		err = -EBUSY;
+		err = PTR_ERR(addr);
 		goto exit;
 	}
 
diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index 0a1be5259be0..38cd8285ac67 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -609,7 +609,7 @@ static int b53_srab_probe(struct platform_device *pdev)
 
 	priv->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->regs))
-		return -ENOMEM;
+		return PTR_ERR(priv->regs);
 
 	dev = b53_switch_alloc(&pdev->dev, &b53_srab_ops, priv);
 	if (!dev)
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 7a0d785b826c..17243bb5ba91 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1418,7 +1418,7 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
 	pep->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pep->base)) {
-		err = -ENOMEM;
+		err = PTR_ERR(pep->base);
 		goto err_netdev;
 	}
 
-- 
2.25.1

