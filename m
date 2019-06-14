Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402FF46A45
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfFNUg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbfFNU3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:40 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 252DA21841;
        Fri, 14 Jun 2019 20:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544180;
        bh=0KGfh2rQXrEjt+TNQSgp0VVaKm9lO9tUAte7C6QH5bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YXLdLCLnVv6aeQP/6gPQxo5qw/MluZe5dIeCAGGtra6WHhOOAfk9M5y4adzA79Pwm
         fWWhblPaK1tLnighPhKhwa76NwrQcZBf2+eiI5IpOganua513hOVKtYrUjcSopVcyn
         xrQAnyscgP2EHsH9SUyrfLgcCixQpA6Cy0TfjaiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <mark-mc.lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 39/59] net: ethernet: mediatek: Use NET_IP_ALIGN to judge if HW RX_2BYTE_OFFSET is enabled
Date:   Fri, 14 Jun 2019 16:28:23 -0400
Message-Id: <20190614202843.26941-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 880c2d4b2fdfd580ebcd6bb7240a8027a1d34751 ]

Should only enable HW RX_2BYTE_OFFSET function in the case NET_IP_ALIGN
equals to 2.

Signed-off-by: Mark Lee <mark-mc.lee@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 59601cb5aeee..f3f7551162a9 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1777,6 +1777,7 @@ static void mtk_poll_controller(struct net_device *dev)
 
 static int mtk_start_dma(struct mtk_eth *eth)
 {
+	u32 rx_2b_offset = (NET_IP_ALIGN == 2) ? MTK_RX_2B_OFFSET : 0;
 	int err;
 
 	err = mtk_dma_init(eth);
@@ -1793,7 +1794,7 @@ static int mtk_start_dma(struct mtk_eth *eth)
 		MTK_QDMA_GLO_CFG);
 
 	mtk_w32(eth,
-		MTK_RX_DMA_EN | MTK_RX_2B_OFFSET |
+		MTK_RX_DMA_EN | rx_2b_offset |
 		MTK_RX_BT_32DWORDS | MTK_MULTI_EN,
 		MTK_PDMA_GLO_CFG);
 
-- 
2.20.1

