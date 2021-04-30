Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FF636F584
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 07:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhD3Fxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 01:53:33 -0400
Received: from m12-17.163.com ([220.181.12.17]:49162 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3Fxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 01:53:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=tAjei
        uOegu6t+sqXw5JR/PYKFtyjzyHRC3Mt7aLIno4=; b=hfZl3uLMlFeFhPVRs+mbj
        ccAIYovMPc8yPRnULbL/Am5EBXLNYDTv+iIP5vFfdwJqZkW3Uooj0r2nH3IIBurp
        kOivgFx3toeMxno19H22oXEKbP0gEkDAKe/lEsGxPFGot90GCFhsFIiEail9AQRB
        DjhFv2/0/Uv7mNJWFVaB0s=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp13 (Coremail) with SMTP id EcCowADX2pIhm4tgQoB2yQ--.22723S2;
        Fri, 30 Apr 2021 13:52:34 +0800 (CST)
From:   dingsenjie@163.com
To:     vkoul@kernel.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] ethernet/stmicro: Use devm_platform_ioremap_resource_byname
Date:   Fri, 30 Apr 2021 13:51:39 +0800
Message-Id: <20210430055139.15480-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowADX2pIhm4tgQoB2yQ--.22723S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Wry3ZF13tw4fWFW8GFW3KFg_yoW8XrW7pF
        Z7Gayxu3yxtr4UKa1DJrn5ZF95u347t3y7Gr4xJ39ayay5trWUtw4rKFW8Ar1ftrWkJw1a
        qF4q9w18ZasxZrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j0eHDUUUUU=
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiTgKEyFUDJJcpHwAAsT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

Use the devm_platform_ioremap_resource_byname() helper instead of
calling platform_get_resource_byname() and devm_ioremap_resource()
separately.

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index bfc4a92..ffeccbe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -454,7 +454,6 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	struct stmmac_resources stmmac_res;
 	const struct ethqos_emac_driver_data *data;
 	struct qcom_ethqos *ethqos;
-	struct resource *res;
 	int ret;
 
 	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
@@ -474,8 +473,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	}
 
 	ethqos->pdev = pdev;
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rgmii");
-	ethqos->rgmii_base = devm_ioremap_resource(&pdev->dev, res);
+	ethqos->rgmii_base = devm_platform_ioremap_resource_byname(pdev, "rgmii");
 	if (IS_ERR(ethqos->rgmii_base)) {
 		dev_err(&pdev->dev, "Can't get rgmii base\n");
 		ret = PTR_ERR(ethqos->rgmii_base);
-- 
1.9.1


