Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3E33BD27F
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhGFLmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237656AbhGFLgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D63FC61DD6;
        Tue,  6 Jul 2021 11:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570949;
        bh=Ob6FilYMBQHlK95h2wrDFDKED5trKUIx8qcft3Q/piQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4awvt6ib/WUKSovZA9xzYQQhAdmPBFd2Z3w2qO3ev4TiIdQ0sSCiJm5t2GMUcPdc
         qRtWWqNjuDshaWZmduOuNxQb75M9U2GOX2kP4yp5MmWMVv7QVzGa2Xyj9LFE6yWauT
         ucnD4ibiAtcTUT55noUjygKuS+DP3jcbH/y82k6TX1R3cTqnGrDRbGCQZ6B0LA4/Lr
         Qh7iUbPr8wXbLxRszqEwH362UuzAF8rGDubxYK0Z+6ABXQ0tqVLnL/fxTHG5hmZ1Og
         aoVwyrz0Drn8PtnGbPBJrqxvXaO1BRDLpfthVEFUDPLLSlZ4NzGx9eVW5YS6tPQ3/g
         Z74D1YSNj8MKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 17/35] net: moxa: Use devm_platform_get_and_ioremap_resource()
Date:   Tue,  6 Jul 2021 07:28:29 -0400
Message-Id: <20210706112848.2066036-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
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
index 6fe61d9343cb..9673fbe16774 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -487,14 +487,13 @@ static int moxart_mac_probe(struct platform_device *pdev)
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

