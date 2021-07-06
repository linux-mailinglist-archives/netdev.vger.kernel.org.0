Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357383BCF9C
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhGFLau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234740AbhGFL2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:28:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F107B61D87;
        Tue,  6 Jul 2021 11:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570418;
        bh=Urdi0RMyDw7osxiomLrzAYzglhIWs81NXDgqg0/pm+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnW7TtHspkrgtFJmaszBH6rtSByhV1DR1HRgL8VS5cgKlTOwQmsvP48eVck8mNL65
         Kue14lMInfjT8ol9pjD6/NUS6vxEKylyA5ts3l4jKCdt1lox9baF429zvjJJiLd0oM
         oOYs8jyjUk7AjEsOvnVhseuhHYRXas+z+jG/GmABwn5FGN1nESPPTEiYN0kcr2sMFp
         hCE8Om5NvyQA2x2sNyu9GELw+9P+pll8lq4Afy6g5aUgwa6bWejJeqckh6h2RnwJGB
         1ek+zTmT4IHQ9AgibV2qnbw1Azj3QL8Y6jfjpRDMhvkuZ0KZk+K+WN+u935hrWNET5
         d7+nkeQTELihg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 083/160] net: sgi: ioc3-eth: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:17:09 -0400
Message-Id: <20210706111827.2060499-83-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit db8f7be1e1d64fbf113a456ef94534fbf5e9a9af ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 6eef0f45b133..2b29fd4cbdf4 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -835,6 +835,10 @@ static int ioc3eth_probe(struct platform_device *pdev)
 	int err;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_err(&pdev->dev, "Invalid resource\n");
+		return -EINVAL;
+	}
 	/* get mac addr from one wire prom */
 	if (ioc3eth_get_mac_addr(regs, mac_addr))
 		return -EPROBE_DEFER; /* not available yet */
-- 
2.30.2

