Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586363BD5E1
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242144AbhGFMZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237151AbhGFLf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACFC361EAF;
        Tue,  6 Jul 2021 11:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570744;
        bh=iQuNtrz8wjlsTe62AYtmmRArf0A0Q00ObZJPInEUwrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rH7t9/3yxuqjjMukjOdL6CevPGnkifOnvjnWNxoz/HeoBjqwAkNtvyGlo9BpsqLWM
         4bcgzZWrmI6IJVqxoDrTIAQV1LoomAnuvpmPWeooA0cUnajJoMdkiNkaHSPtvzeNfC
         aKxLfb6snHR2e4GmlR9TpKxa8yxgmhNN/+3ZQCiOBFOD2PECVAl+QodM/tp8gIHsZp
         hiuoVrEO14eR8WnYHse4teDfyv/Y1GYGLKrxXph+duZc3LR33xkTPq51GNxMIYNznF
         6H3e1V/6Nd367frJuRlU5Ni/HF7vQVbXWBakQFjClhjF3V8/BEyguV2q+z50VHaZn+
         EoZG8qIVJ+n8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 33/74] net: micrel: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:24:21 -0400
Message-Id: <20210706112502.2064236-33-sashal@kernel.org>
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
index da329ca115cc..fb838e29d52d 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -1136,6 +1136,10 @@ static int ks8842_probe(struct platform_device *pdev)
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

