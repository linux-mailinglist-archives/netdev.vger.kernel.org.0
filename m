Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9253BD29F
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbhGFLoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237366AbhGFLgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7548361D76;
        Tue,  6 Jul 2021 11:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570831;
        bh=OL9rfOiKRWJSA82b/JX3hAoWKFX5BaIrY0X3ziJ21aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K26RXOjEIiOXLqt1DXOIrq+4Z7ijan04DS4x/vCsov2WmYlw23QWCJTTBXmv3tmK5
         0UrZeA//q+WkYYXdEsQwthOBq59zBD5ht5gkZbgXDg+Qiyq/3g6AIun0RmB8ofV5pf
         eNHWpMQBSPNk39HUun1Xc+k8ecMA+psCaVo57EllCaU+6UJsaqsnrzO2WUgIJ/X/5h
         UpuvqvpVhttBrm0uYawDKzbRyhu96XodcItVA3nAZ7G1wNhRV//k/3SNP+0/6ozXZt
         P564dd1t+6cYuCkj0p7FpucRIaccssUuqWF9PqKrRf/S7tSBc6TVl5bOmiXVbITaAQ
         vwZ/9zp/cdmzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 25/55] net: bcmgenet: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:26:08 -0400
Message-Id: <20210706112638.2065023-25-sashal@kernel.org>
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
index a5049d637791..494601c39b84 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -428,6 +428,10 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
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

