Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C9E3BD601
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242405AbhGFM04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237792AbhGFLhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:37:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 041AF61F7A;
        Tue,  6 Jul 2021 11:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570990;
        bh=n2vsdjTx/lctda6weRG5p0tIWznoempiBW0ujVFOs84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ulLj7mO2Io92RAscssjQ99APuNLGjaJIch3R87hBKd9xVkAKSqa+5NgwFdSLGPVxI
         1zyg6BLCxIm7x9KfhqGqg1RlF7ea4SaDSkxPWKAPC3Dz7eAdV4HjjuiUOd/TeV3Gny
         Rz/RbKqQYlAnoCS150uTOh+Eyt2p62TjHCUXQI6ZUMuZ0rBzeVbL4d9HpFgWRXuOHu
         cMSHNdhqBqkf3608b9Wu1mt1v/M7CgmhAuIM9+o/0xRutdt33y7DTmHjJZ4K3mhRtq
         Gz6tkJyGcHOviN35AUKIWPvBcIm286c2Xm7ceISvY9xH3NybGnk4BLyjufy7osA/PU
         jXlozQhW20Czw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 15/31] net: micrel: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:29:15 -0400
Message-Id: <20210706112931.2066397-15-sashal@kernel.org>
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

