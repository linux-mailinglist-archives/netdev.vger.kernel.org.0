Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C80C3BD27C
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbhGFLml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237651AbhGFLgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA4D61DF2;
        Tue,  6 Jul 2021 11:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570948;
        bh=n2vsdjTx/lctda6weRG5p0tIWznoempiBW0ujVFOs84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l86Lc+aNWQFiqgxxp0kqjLj260/IynvQwHk1WGNeTbg5YNA1dWYkl0kvams6LM6rk
         lhhaVqMLakekAi/ZcTzrYKvVRoACCAIYOCiJGwL/bK4oFP1+r4qkKJnEYWObdci0oB
         fiFruFLyjXhxdacvjeTnC2Qa1Oxxa1SoCEeNjgMeFyl8cV38InCqjYpy83IekfFqMl
         uPjv786NtrtWo4+6N4OvhF+U86oPeFZvZM0Uf8u35FD+35gWTv0W2rYMT/LTxhczVA
         ZezK7JiMSA5VIX17vRzpidipatSG9a0Gd777kuDJOaHZLzfLWrYQJ47YVjL0uez1D2
         cZirIG/lWI1HQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/35] net: micrel: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:28:28 -0400
Message-Id: <20210706112848.2066036-16-sashal@kernel.org>
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

[ Upstream commit 20f1932e2282c58cb5ac59517585206cf5b385ae ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8842.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index cb0102dd7f70..d691c33dffc6 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -1150,6 +1150,10 @@ static int ks8842_probe(struct platform_device *pdev)
 	unsigned i;
 
 	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iomem) {
+		dev_err(&pdev->dev, "Invalid resource\n");
+		return -EINVAL;
+	}
 	if (!request_mem_region(iomem->start, resource_size(iomem), DRV_NAME))
 		goto err_mem_region;
 
-- 
2.30.2

