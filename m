Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A773BD602
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242452AbhGFM06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237799AbhGFLhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:37:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F61161F6B;
        Tue,  6 Jul 2021 11:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570991;
        bh=+giL84Jd9W6WhqHZlbX4xgV/DqoLayukqLnCQPCIoRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GrN0RaqJ2BYvwXVMCorB3nl7u9TA4kBJTxZ7vKYW7n59RkONdwJ8WRBOKiRPdCeFS
         87uwwuoyJ9v8UO3UkPsvvk3GcwIp94mqDTnxgPRUjg4l5VsIpu29b6t7iT2Mf4sYaG
         DQ5gCrPQkirqUwiBFEH0uI8dhCO0TXG29X0eeQ2wGX54qG2eVFQMT0R3oxhEx6LX03
         5xEfqhPSouwCcFTI6PkS7lEJBDFsq4wifJQ4eLiyqDTgq+WhKtbZYkSEhm6E4sWDO9
         8YYA1G9NprCMnTel6BzLhr5JwsEUobmNGqR+jF09yRMgWyANnlZEgKyTXS2BVCdn/Z
         ZXwaAqlGm+1xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 16/31] net: moxa: Use devm_platform_get_and_ioremap_resource()
Date:   Tue,  6 Jul 2021 07:29:16 -0400
Message-Id: <20210706112931.2066397-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112931.2066397-1-sashal@kernel.org>
References: <20210706112931.2066397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 35cba15a504bf4f585bb9d78f47b22b28a1a06b2 ]

Use devm_platform_get_and_ioremap_resource() to simplify
code and avoid a null-ptr-deref by checking 'res' in it.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 374e691b11da..ed3c5d2d7e0e 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -457,14 +457,13 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	priv = netdev_priv(ndev);
 	priv->ndev = ndev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ndev->base_addr = res->start;
-	priv->base = devm_ioremap_resource(p_dev, res);
+	priv->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(priv->base)) {
 		dev_err(p_dev, "devm_ioremap_resource failed\n");
 		ret = PTR_ERR(priv->base);
 		goto init_fail;
 	}
+	ndev->base_addr = res->start;
 
 	spin_lock_init(&priv->txlock);
 
-- 
2.30.2

