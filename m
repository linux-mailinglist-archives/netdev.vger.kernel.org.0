Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EFA225873
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgGTH2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:28:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8332 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726015AbgGTH2Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 03:28:16 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 20A60DEDC90ADEE4CDF1;
        Mon, 20 Jul 2020 15:28:14 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 20 Jul 2020 15:28:12 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <opendmb@gmail.com>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <bcm-kernel-feedback-list@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: bcmgenet: fix error returns in bcmgenet_probe()
Date:   Mon, 20 Jul 2020 15:28:05 +0800
Message-ID: <1595230085-10035-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver forgets to call clk_disable_unprepare() in error path after
a success calling for clk_prepare_enable().

Fix to goto err_clk_disable if clk_prepare_enable() is successful.

Fixes: c80d36ff63a5 ("net: bcmgenet: Use devm_clk_get_optional() to get the clocks")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 368e05b..79d27be 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4000,14 +4000,14 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk_wol)) {
 		dev_dbg(&priv->pdev->dev, "failed to get enet-wol clock\n");
 		err = PTR_ERR(priv->clk_wol);
-		goto err;
+		goto err_clk_disable;
 	}
 
 	priv->clk_eee = devm_clk_get_optional(&priv->pdev->dev, "enet-eee");
 	if (IS_ERR(priv->clk_eee)) {
 		dev_dbg(&priv->pdev->dev, "failed to get enet-eee clock\n");
 		err = PTR_ERR(priv->clk_eee);
-		goto err;
+		goto err_clk_disable;
 	}
 
 	/* If this is an internal GPHY, power it on now, before UniMAC is
-- 
1.8.3.1

