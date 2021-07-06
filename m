Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9773BCC7C
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhGFLTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232438AbhGFLSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BDEE61C50;
        Tue,  6 Jul 2021 11:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570167;
        bh=3J42CBELgmoeC8IW0L8kt4ewMtWxXKYKwnqbF9mZGDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9oZOEonh1xa06X4fK4JEiQzCXqp3XbV939m9xmJvU7BwdZSpYj/18em8U8SD0IIP
         6r3Ibewn4pTRcIt7QQx/oLXfRF2BTtYhNLAJWTyUBAcSAeucDeiw2uxk+4m/zDFYt7
         v4mJvtvLP7eu8Bg/PqkjFeq3VgD6ZEthMtplzAYhrDhy4O3Pf4YpQP0tJqGnBpI9l3
         0ZLMLsysKTnQi/a6eSqZUKsw40+uI5rbPw+eqSBPF0WtiS0gd6vkUQcFILJQx1g/20
         WLQuklFBgZT2irsSz/EKZRESVdv8z7CLjfcjLeixpSmm06Bc1ZZRTsrqvQVCSlPPPy
         CtoOBXsr3HbYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 087/189] net: moxa: Use devm_platform_get_and_ioremap_resource()
Date:   Tue,  6 Jul 2021 07:12:27 -0400
Message-Id: <20210706111409.2058071-87-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index b85733942053..5249b64f4fc5 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -481,13 +481,12 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	priv->ndev = ndev;
 	priv->pdev = pdev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ndev->base_addr = res->start;
-	priv->base = devm_ioremap_resource(p_dev, res);
+	priv->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(priv->base)) {
 		ret = PTR_ERR(priv->base);
 		goto init_fail;
 	}
+	ndev->base_addr = res->start;
 
 	spin_lock_init(&priv->txlock);
 
-- 
2.30.2

