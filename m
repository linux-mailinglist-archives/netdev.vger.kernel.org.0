Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8FAF499B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389839AbfKHLmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:42:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389788AbfKHLmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8872521D7B;
        Fri,  8 Nov 2019 11:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213332;
        bh=FReMmvb5mhGVKmc7T3QgYVpv0ScYqZMSvTTubSLgang=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzWpkg6LnACP5D9D1IEmSd3xybTvZQDCUgMQ4uCbth5IU+P47/umtN2R6ougtyfeI
         S++XBPf4U7HebNsNcoOoW9pvaJYTTdEJVnHSJShJDYv7ikXNS9W/IDGZdvLZxISDEQ
         ZW1YuReiaRw0WUCJGEw8TV49PPUnsAxUu63/Mjq0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        Paul Burton <paul.burton@mips.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 171/205] MIPS: lantiq: Do not enable IRQs in dma open
Date:   Fri,  8 Nov 2019 06:37:18 -0500
Message-Id: <20191108113752.12502-171-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit cc973aecf0b0541918c5ecabe6c90d1f709b5f89 ]

When a DMA channel is opened the IRQ should not get activated
automatically, this allows it to pull data out manually without the help
of interrupts. This is needed for a workaround in the vrx200 Ethernet
driver.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Acked-by: Paul Burton <paul.burton@mips.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/xway/dma.c        | 1 -
 drivers/net/ethernet/lantiq_etop.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
index 664f2f7f55c1c..982859f2b2a38 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -106,7 +106,6 @@ ltq_dma_open(struct ltq_dma_channel *ch)
 	spin_lock_irqsave(&ltq_dma_lock, flag);
 	ltq_dma_w32(ch->nr, LTQ_DMA_CS);
 	ltq_dma_w32_mask(0, DMA_CHAN_ON, LTQ_DMA_CCTRL);
-	ltq_dma_w32_mask(0, 1 << ch->nr, LTQ_DMA_IRNEN);
 	spin_unlock_irqrestore(&ltq_dma_lock, flag);
 }
 EXPORT_SYMBOL_GPL(ltq_dma_open);
diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index e08301d833e2e..379db19a303c8 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -439,6 +439,7 @@ ltq_etop_open(struct net_device *dev)
 		if (!IS_TX(i) && (!IS_RX(i)))
 			continue;
 		ltq_dma_open(&ch->dma);
+		ltq_dma_enable_irq(&ch->dma);
 		napi_enable(&ch->napi);
 	}
 	phy_start(dev->phydev);
-- 
2.20.1

