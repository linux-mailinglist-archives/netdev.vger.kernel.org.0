Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FF83BD2A1
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhGFLoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:44:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237375AbhGFLgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C18AD61D5E;
        Tue,  6 Jul 2021 11:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570833;
        bh=WtqPB5MKbb9f4Znuqs7cgBs3WXwdAkg9h1wOf5Br/vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqPBUp1I0Vq2r2e6y9btWwB4unXm3zn6n8POQ6b7mclxYQ4VdZpN3vDqReIIxY99Y
         ZVMhrAZIrejxjeS2Vl0UGHq1lK9pxCCK7hxyac7j1QkqlQokejLQaQJ2FbTncJfCyP
         svTcY5Nz21mhXNCfYRzaSE8Y34gflLYWtKF6bkVXC3i1pb24WorEEw5O5ImbNny79G
         TK3rajxNQGIEJ7RzVBAViPKtWozeHnwTuVLxVnndKPm+13myci0ArJIchMinp7HVDD
         xNVoDNBZIevm8N4/PNMrLLWHNFb8vVC3ejDhOxFCMO5+Qmy/9mw1kcUecn2j6lcoiP
         h+c+eA3Qng37Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 27/55] net: micrel: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:26:10 -0400
Message-Id: <20210706112638.2065023-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112638.2065023-1-sashal@kernel.org>
References: <20210706112638.2065023-1-sashal@kernel.org>
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
index e3d7c74d47bb..5282c5754ac1 100644
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

