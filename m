Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE9B3BD21E
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbhGFLlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237129AbhGFLf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A8F161396;
        Tue,  6 Jul 2021 11:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570742;
        bh=gfyQrmm1dVOTIuU+Zhlf4gBUzVj4BPQz7GTuUDGI3bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLCn4y4x4kx97/iHCFW5rBSlrMyaDuVLtUk8gk6a6Je6Hk9vOANvnrX8zrJuYg3WX
         4o0kwZumCYey0PWgx2Rp6sEjUjwrU1fjlJZif2pp3+XoC0hAjyjQnEfQipLkDMH7CY
         DFtKsteiZ4p6ivsWygMtiuWVfiJUAhEEeGa8scT01qCdEGEEZZa49Ktht40FAVwj8L
         +3iXmSsUS5A6XbC8H98Qff8YMyy2qt3nwZERiZ/ttj7KhXaEaIrijDQmFA+yvTZPqR
         3hQ/6DOxIWOk9Hhtz/RZzOtj//yjNp3mlL7E63qvJiPwvlSXr9/Ja/1nHsgUXcaaCy
         dYXxlnM6j9bog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 31/74] net: bcmgenet: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:24:19 -0400
Message-Id: <20210706112502.2064236-31-sashal@kernel.org>
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
index dbe18cdf6c1b..ce569b7d3b35 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -426,6 +426,10 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
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

