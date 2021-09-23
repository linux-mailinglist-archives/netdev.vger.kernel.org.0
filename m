Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB47415645
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbhIWDk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239094AbhIWDkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3415061152;
        Thu, 23 Sep 2021 03:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368308;
        bh=9LBkSccJ1Bg0JXhObUI8yEtdPpanY34zmAGKvQ838Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmkNpPhn9lck9JRFSZn39LP76+cY8EO0I7gCaPfdwynQMVJfbzkHkhsRef3vlcTLd
         P+VQ0CSYlAOK9ox1m5O4AGxB5F0Nr74ZI8oDKxst02hGVT4iReqzigrlr/AXAeMmji
         9YKveF8l6zmJ7lv91j38a6r6otmfDJQgPmHXNdAaWsSJXId292Qr7i1dMunPJIhFbe
         ryDlHxpuDD8N4sH9vxS1OqZsZNvEe+ZvSVEFUEGj/8/F00N8gR5gYzGcMYGUgLrJyQ
         jN6Fawz2E7F5TZrQ3euu30M1SB0CBIlodvTTMG4l/9j7eOH/ND1Oy1V54ayrmoZhIp
         TZDaCnO6WnQqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        Nicolas Ferre <Nicolas.Ferre@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, claudiu.beznea@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 03/34] net: macb: fix use after free on rmmod
Date:   Wed, 22 Sep 2021 23:37:51 -0400
Message-Id: <20210923033823.1420814-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033823.1420814-1-sashal@kernel.org>
References: <20210923033823.1420814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit d82d5303c4c539db86588ffb5dc5b26c3f1513e8 ]

plat_dev->dev->platform_data is released by platform_device_unregister(),
use of pclk and hclk is a use-after-free. Since device unregister won't
need a clk device we adjust the function call sequence to fix this issue.

[   31.261225] BUG: KASAN: use-after-free in macb_remove+0x77/0xc6 [macb_pci]
[   31.275563] Freed by task 306:
[   30.276782]  platform_device_release+0x25/0x80

Suggested-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 8b7b59908a1a..f66d22de5168 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -111,9 +111,9 @@ static void macb_remove(struct pci_dev *pdev)
 	struct platform_device *plat_dev = pci_get_drvdata(pdev);
 	struct macb_platform_data *plat_data = dev_get_platdata(&plat_dev->dev);
 
-	platform_device_unregister(plat_dev);
 	clk_unregister(plat_data->pclk);
 	clk_unregister(plat_data->hclk);
+	platform_device_unregister(plat_dev);
 }
 
 static const struct pci_device_id dev_id_table[] = {
-- 
2.30.2

