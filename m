Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750733BD0F7
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237925AbhGFLht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236341AbhGFLfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1447661D31;
        Tue,  6 Jul 2021 11:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570604;
        bh=30GOSRscCV+LcBccfoLXd0HpdRXX0qYf3JIRJoragvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugb8OLn4diBD4PCwdd9xgnWVL6+9JaM6zkN59mDfUgCsEjxwavdGvvSKrEPoT/dw1
         IHUxwmzfdYAdvqccEvs0+nj/P64CX409x4G3lLPnZ4UKG3Ml9FjQoTi2u+s8gP4YMo
         kqrZoMtR+fXQRCqkwWtiPlBBJ9IbRPQldUhB56BRqmes19M/p1fujsY+nAWu+WbUal
         Ai4RaH6Z2qbetyj8HeaZ1QgQzaOzcyOTdG8hVUxB3ktHyYz19SckyQ4xgx6ZlbtrKs
         XLvwk3pPuLxw1PVVEbqs6Yj3oIDY8RPyf3voJst9YEJw8aQfPDBuDmQ5QgTeb4NVVh
         icEOXpXnbLV5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 063/137] net: bcmgenet: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:20:49 -0400
Message-Id: <20210706112203.2062605-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 74325bf0104573c6dfce42837139aeef3f34be76 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 6fb6c3556285..f9e91304d232 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -423,6 +423,10 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
 	int id, ret;
 
 	pres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!pres) {
+		dev_err(&pdev->dev, "Invalid resource\n");
+		return -EINVAL;
+	}
 	memset(&res, 0, sizeof(res));
 	memset(&ppd, 0, sizeof(ppd));
 
-- 
2.30.2

