Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554FB3BD34D
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238306AbhGFLjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237155AbhGFLf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B42FE61CB4;
        Tue,  6 Jul 2021 11:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570745;
        bh=LGzdI1v0S5Zx+cdVoMYUzOdVZTttiJ4l1Davo96KDtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PA+1n+HQvBmsJJ6jlMjRu+UybX/LodF53HMu7tBtpAc9nJv3ddDI3p1hbTS+zlO+G
         XKPzMsih6voFwNDtRhU1VguUnAmyPOlwglwcvvrR7v8A+C0MMu8h3gVf62qHLB0dqt
         d4GgITezEWJovPZHOP6D4xyxCXF8Z7cGU1CZaLo+loWI6CRg1JV1tJZb8COcxzLw7V
         v07muhlhsMCxUuSgb9Sf+j9Pz/SWklbumtYq/y8H2uwJgqOJ5rmCJbKeiLJH2ZGy+M
         GhzJbusvRKzOihZTXa95Ws7tVYYB9FoQpcfOgFKQpAYnjk0wo5ueGPwqjCyCC5OO6H
         YlF3TijhTh8Zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 34/74] net: moxa: Use devm_platform_get_and_ioremap_resource()
Date:   Tue,  6 Jul 2021 07:24:22 -0400
Message-Id: <20210706112502.2064236-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index f70bb81e1ed6..9f7eaae51335 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -480,14 +480,13 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	priv->ndev = ndev;
 	priv->pdev = pdev;
 
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

