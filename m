Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396A2415672
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbhIWDlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239282AbhIWDk2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A825611C6;
        Thu, 23 Sep 2021 03:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368337;
        bh=J25ctM76naITlsfPLlVP+Zv7fKujgSS+sE8P8jBgn2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhYBnHaZI4EYeO+S6XtZYDHX/TMPrJbErzUfbPUB6fUOFW7P9nEmrZyKnNTIAOgzq
         RoEur9O3StyIf1UgIcDdHzaCVax7uifLPTj8sWpPwTkzpOqJViHle0Ig9oTOKOvpuT
         zWvgWT/oIVSxn2uPQcAiauN0g0mYwTAQuhTNF8XBx1OyFJJ9MLoYuuSfRlVFgPgE8X
         /cJR9kxnRJp6pV+LeZ4bQBGn/RtrZ1NZvthVzAorRwvmk5mHKGCkwjYye0yNY6JXYa
         qyzzqPr3MzbqMCJ/lgeisGwbzysaJ7FX6SErYkG7jMW6I9/2j/WbrULi+1eFZMeL7y
         rgagIn7Plp/TQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        Nicolas Ferre <Nicolas.Ferre@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, claudiu.beznea@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/19] net: macb: fix use after free on rmmod
Date:   Wed, 22 Sep 2021 23:38:36 -0400
Message-Id: <20210923033853.1421193-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033853.1421193-1-sashal@kernel.org>
References: <20210923033853.1421193-1-sashal@kernel.org>
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
index 617b3b728dd0..94f3babfad30 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -112,9 +112,9 @@ static void macb_remove(struct pci_dev *pdev)
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

