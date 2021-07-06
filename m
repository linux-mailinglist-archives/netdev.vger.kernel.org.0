Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9232D3BD1B5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbhGFLkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237530AbhGFLgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6627761F0E;
        Tue,  6 Jul 2021 11:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570899;
        bh=WtqPB5MKbb9f4Znuqs7cgBs3WXwdAkg9h1wOf5Br/vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0XBMB42QMvV3Gu15G60V4iTwRUEmxH8Lm6aE6SK0hyXHlAYy6BbD+lkoa1CBySlU
         jITSEihuR0WbfQI348/QToJFQT4g0cEtbQylbuE6yZOKzEgjSLNGlEi+9lkYoC8Hj9
         uofSDppYnEt4ihhTK/0OwGylCYS76AbEOMd260FRibhLMyJbVh37z5e1O0HFyN+o/E
         mtba1HTtq553WWfXgm59EjYngOSyKyibe+xEOzlddSqXJ+d/iHn9t6UJN9wUn7VNWk
         N+o26LZMu5sB+MCWG27nQGuT2Pr0VLzWyfsQ8iYZh5is3JQfaYi1acxovWpYYXUPbj
         MyD7WGrchfGHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 23/45] net: micrel: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:27:27 -0400
Message-Id: <20210706112749.2065541-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112749.2065541-1-sashal@kernel.org>
References: <20210706112749.2065541-1-sashal@kernel.org>
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

