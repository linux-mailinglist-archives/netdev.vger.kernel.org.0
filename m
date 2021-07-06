Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B461F3BCFB7
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbhGFLbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234484AbhGFL1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:27:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 457ED61C43;
        Tue,  6 Jul 2021 11:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570404;
        bh=oaC2icxJ1FzLUjUeegnixedcm9xmDZEyvww90mFno2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYkB5Yt8I/6jMYyodunAmUeb9HufHoJMgL98tWN4PEcefYUWMyweC3Z6VYMwt97SO
         5AJWgxJ9C0WFv+ietUvf03wBQMGwgt/K7n0xdExiqcCHqc2Z1bQZOcspg4Ss/ldGp/
         HUBi8Qaq2untbAdpSyWB4kbWSgcN2hMPRokmBlGl49B17Mo2Jj1XBjfqir8Uk0p0Ov
         GbzFwSqbdfAQnlL3dL34fCWbtR+tPfr9u0H3b6wQQiUDMwSGTbReLl7XRNh6/rj+MJ
         yz3i0fj0+KdmRvDc1p+YhmOhBa26bXeg3+Xc5RlU0Vy4Kw9cmlrLqqhLa2Dd22JqbU
         c+SXPLr1HWbiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 074/160] net: moxa: Use devm_platform_get_and_ioremap_resource()
Date:   Tue,  6 Jul 2021 07:17:00 -0400
Message-Id: <20210706111827.2060499-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 49fd843c4c8a..a4380c45f668 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -481,14 +481,13 @@ static int moxart_mac_probe(struct platform_device *pdev)
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

