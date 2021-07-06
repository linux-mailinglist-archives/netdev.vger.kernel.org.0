Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FCE3BCC74
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhGFLTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232605AbhGFLSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 611F261C72;
        Tue,  6 Jul 2021 11:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570166;
        bh=lxynscbsCQDk1myZDrdth+KqETVGa5AjuevgsM1C6+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZPiurQ+8bLFiRkRDuskqIolzA/tmHir/J/LwY/d7IfQdwRDXOM8MhO7rzkLtM0pv
         ApIRLRk0eaLnjaYSVkJZYm25NkDdRCK641z4ahe8S69snoLTRV9mou+GiBdEjCp1k8
         jXTLdr0jU7LmBrsSJAc6pIxgtGQI7HnOVoNhJ/agqxldDGuN8oEnTeAQliTMi8Z/iV
         DL780PfOaIqH9rywSmOUPv++hYCF4KbgcMPt9kMdGgMcxaffTtljRSazoSjdVThLTQ
         J8j2/z30H7bdXjGfW8drWGCUbBvTGia2VYkDiC2haAlcXdAeiC90tIoLjE1AyEUVQW
         nXAh0VfKR27lA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 086/189] net: micrel: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:12:26 -0400
Message-Id: <20210706111409.2058071-86-sashal@kernel.org>
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
index caa251d0e381..b27713906d3a 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -1135,6 +1135,10 @@ static int ks8842_probe(struct platform_device *pdev)
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

