Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6858C3BD0F4
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbhGFLhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236344AbhGFLfH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C25E61E23;
        Tue,  6 Jul 2021 11:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570606;
        bh=lxynscbsCQDk1myZDrdth+KqETVGa5AjuevgsM1C6+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHFMOflziMlAJG6w+3+IBG5qSh0bXj0SN27pTMCnoKKCImuxSxwNYYXOILF62k1oM
         QFdnPRNID64NbhtlIZvpRjUg5342WKOZwHNZHCylVa8F+fhXNkhoVttZFKB/bIR+pi
         8Ly7y+N7G/dn08UfiMMJPT42sCBuAiOchM2bkN3Ww3Yhd9aNEMRE4pVM2m5cpCICiJ
         rKuiljwMbmsCsWxafwQchsVQHCWMfhfP7HsmhApGs7CxToKbPhU4EtK6Bx7SBcxbVg
         +35EDgXNpDYsMm685xMSvC4qfss06duGTcTtgTYKA/i1LbOKjF9oFEuCboAg/9TFPS
         jQlT5HKhCK5VQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 065/137] net: micrel: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:20:51 -0400
Message-Id: <20210706112203.2062605-65-sashal@kernel.org>
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

