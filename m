Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DCE2FCA4F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 06:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbhATFKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 00:10:49 -0500
Received: from m12-16.163.com ([220.181.12.16]:51737 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729396AbhATFDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 00:03:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=r+ZDksZRf1MnJf0++J
        5ggqDLC2RfPDG8F/RK8F0p+qU=; b=N98wc9KUA0zgJHiMd2HJYjoA2ZIY+MQc35
        QZw/BQBGZmZkn5IZAPNuWhLpoIi5maYBzB/KY+MB4XxJxWHrP2lGWfF7vYZl8Fza
        6a5RIqm85B5fkwkVyzBe4PC/Ts/6Jys/1jfuf/qRfmfzHdRo7fpo266zdVeBZHst
        YxZirmlhs=
Received: from localhost.localdomain (unknown [119.3.119.20])
        by smtp12 (Coremail) with SMTP id EMCowAAXXI0stQdg9B3iXw--.40190S4;
        Wed, 20 Jan 2021 12:44:31 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH] net: systemport: free dev before on error path
Date:   Tue, 19 Jan 2021 20:44:23 -0800
Message-Id: <20210120044423.1704-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EMCowAAXXI0stQdg9B3iXw--.40190S4
X-Coremail-Antispam: 1Uf129KBjvdXoWruw1UXFy8Wr4fCr4xXrWUurg_yoWDZFcE9a
        17ZrW5Xr4ruF90van8Ar43uFyIkF4q9r1ruF9xKrW3tasrJr10y3ykZryfur47WrWxuFyx
        GFnIvFWxC3yfKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbdWrtUUUUU==
X-Originating-IP: [119.3.119.20]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBzw0fclaD9yCOBgABsk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the error path, it should goto the error handling label to free
allocated memory rather than directly return.

Fixes: 6328a126896e ("net: systemport: Manage Wake-on-LAN clock")
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index b1ae9eb8f247..0404aafd5ce5 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2503,8 +2503,10 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	priv = netdev_priv(dev);
 
 	priv->clk = devm_clk_get_optional(&pdev->dev, "sw_sysport");
-	if (IS_ERR(priv->clk))
-		return PTR_ERR(priv->clk);
+	if (IS_ERR(priv->clk)) {
+		ret = PTR_ERR(priv->clk);
+		goto err_free_netdev;
+	}
 
 	/* Allocate number of TX rings */
 	priv->tx_rings = devm_kcalloc(&pdev->dev, txq,
-- 
2.17.1


