Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0293137455E
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238176AbhEERE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237371AbhEERAB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:00:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1BDA61997;
        Wed,  5 May 2021 16:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232801;
        bh=uhJonWH3UFMxyXpuKpf7hxkAMmIAbWNq6vh6ZFFOgA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyBVi+Cki16QxDFO40k9D0aUEfIAwyeoyF+SkOL/gh69+6kJoyW/RLH9dKNUOY98r
         BhnSRPl9XIWHhQWwod9JzWR21HpzzWwntvyOHIYqyFMB/jjMTDXPRp8CtlKUwOzkuS
         wyCILNR0JYLg4ULT0S5XC9UNg7GZiB4bIh53N77pXQzL5C9s8JLOfu394IbDx0WE80
         YPnBJ9KMmZPAFIbfCYHV06a0FYR7Fqbfy3ANwy/6f9rVJxXn02YdEdCpZ532jwWYyI
         x6wT0KQBlpHoBPm+/4+xPl9R4s/os5XeMqIqbHV+LepKR/G0d3y2mZFArVEgdXq4pX
         LOMqUGWzVy2ZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 44/46] net: ethernet: mtk_eth_soc: fix RX VLAN offload
Date:   Wed,  5 May 2021 12:38:54 -0400
Message-Id: <20210505163856.3463279-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
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
index d01b3a1b40f4..7e3806fd70b2 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1315,7 +1315,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb->protocol = eth_type_trans(skb, netdev);
 
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX &&
-		    RX_DMA_VID(trxd.rxd3))
+		    (trxd.rxd2 & RX_DMA_VTAG))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 					       RX_DMA_VID(trxd.rxd3));
 		skb_record_rx_queue(skb, 0);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 1e787f3577aa..1e9202b34d35 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -293,6 +293,7 @@
 #define RX_DMA_LSO		BIT(30)
 #define RX_DMA_PLEN0(_x)	(((_x) & 0x3fff) << 16)
 #define RX_DMA_GET_PLEN0(_x)	(((_x) >> 16) & 0x3fff)
+#define RX_DMA_VTAG		BIT(15)
 
 /* QDMA descriptor rxd3 */
 #define RX_DMA_VID(_x)		((_x) & 0xfff)
-- 
2.30.2

