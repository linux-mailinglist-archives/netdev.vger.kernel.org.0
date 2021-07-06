Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642763BCC8F
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhGFLT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232744AbhGFLTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0560061C75;
        Tue,  6 Jul 2021 11:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570184;
        bh=OUttnZfZ2XueT8ypLeni7GSulhpsz4hmA/8lKqb26xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aj7s3hcbifFEJmkxIWvsS6fEOkBcpitNx3KuLHx7oGq7tqxPd0AsNRplZ1CcKQonB
         ySFhLDUH6VNTClMgLKtujCr480HJeHTdidNY5RfZf/KrQMzOOqfxjqiEVFp1lZBFFZ
         F2tpGsFo2D2PJyynmhywU9/NSxgN5lVYbNhobXMd7qe5jD7FcIV5AeyBKY361OI9hJ
         KRg4d1RnaYbJUGsR9w7Gb15L8jRMmRSUnq4US6r7gk+NJ9X9N6rfwFhjyqcje/ih2s
         DXYAgdS33qr6xon/NY+5U7Gvs5P0kmhidOk4vDccgVJ+l9Uu1NE4yyiM9vaU6kETYX
         b7ngvdY2ZaOeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 100/189] net: mido: mdio-mux-bcm-iproc: Use devm_platform_get_and_ioremap_resource()
Date:   Tue,  6 Jul 2021 07:12:40 -0400
Message-Id: <20210706111409.2058071-100-sashal@kernel.org>
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

[ Upstream commit 8a55a73433e763c8aec4a3e8df5c28c821fc44b9 ]

Use devm_platform_get_and_ioremap_resource() to simplify
code and avoid a null-ptr-deref by checking 'res' in it.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-mux-bcm-iproc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux-bcm-iproc.c b/drivers/net/mdio/mdio-mux-bcm-iproc.c
index 03261e6b9ceb..aa29d6bdbdf2 100644
--- a/drivers/net/mdio/mdio-mux-bcm-iproc.c
+++ b/drivers/net/mdio/mdio-mux-bcm-iproc.c
@@ -187,7 +187,9 @@ static int mdio_mux_iproc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	md->dev = &pdev->dev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	md->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(md->base))
+		return PTR_ERR(md->base);
 	if (res->start & 0xfff) {
 		/* For backward compatibility in case the
 		 * base address is specified with an offset.
@@ -196,9 +198,6 @@ static int mdio_mux_iproc_probe(struct platform_device *pdev)
 		res->start &= ~0xfff;
 		res->end = res->start + MDIO_REG_ADDR_SPACE_SIZE - 1;
 	}
-	md->base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(md->base))
-		return PTR_ERR(md->base);
 
 	md->mii_bus = devm_mdiobus_alloc(&pdev->dev);
 	if (!md->mii_bus) {
-- 
2.30.2

