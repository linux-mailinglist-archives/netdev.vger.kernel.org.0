Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2E53741B4
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbhEEQkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235078AbhEEQjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA70261476;
        Wed,  5 May 2021 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232434;
        bh=UimeJS6hq2lUy+unWCGlr0f/LHC0pS+MIX4eyMbSJdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5PEkUlmH4WAukq9VHUT8lGwWqHFo2WVWCFcTPvG6OWj4DnDbITdcCLwcGC9p92ht
         RhyEznHMoPxWCd4wVIxc0vdE4EGjCciFiBfuwYEskADBxeuhrOOvfj2Z+FppYugzfU
         2xurSN+Or6dg3q1nHnua3feUADLp4z5gtLcvO6rjfx3rbBw2L3edpUnOED7LyMBfaJ
         MHorS8WKHefLGn1HhzkpGRx+8MTUl8uerjB9fLhOApcFeQdIq+jvMkYfWsl8v4w8wH
         q07wgYCTy/vmfIBJCEhAQJjj8wZdFZgsiiLvHF1UrFMEiT45OiprzX9QPAJe0VyzBI
         WI2ANKAuM6/qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 105/116] net: ethernet: mtk_eth_soc: fix RX VLAN offload
Date:   Wed,  5 May 2021 12:31:13 -0400
Message-Id: <20210505163125.3460440-105-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3f57d8c40fea9b20543cab4da12f4680d2ef182c ]

The VLAN ID in the rx descriptor is only valid if the RX_DMA_VTAG bit is
set. Fixes frames wrongly marked with VLAN tags.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
[Ilya: fix commit message]
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 01d3ee4b5829..bcd5e7ae8482 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1319,7 +1319,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb->protocol = eth_type_trans(skb, netdev);
 
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX &&
-		    RX_DMA_VID(trxd.rxd3))
+		    (trxd.rxd2 & RX_DMA_VTAG))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 					       RX_DMA_VID(trxd.rxd3));
 		skb_record_rx_queue(skb, 0);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index fd3cec8f06ba..c47272100615 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -296,6 +296,7 @@
 #define RX_DMA_LSO		BIT(30)
 #define RX_DMA_PLEN0(_x)	(((_x) & 0x3fff) << 16)
 #define RX_DMA_GET_PLEN0(_x)	(((_x) >> 16) & 0x3fff)
+#define RX_DMA_VTAG		BIT(15)
 
 /* QDMA descriptor rxd3 */
 #define RX_DMA_VID(_x)		((_x) & 0xfff)
-- 
2.30.2

