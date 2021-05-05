Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A123742E0
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhEEQsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235482AbhEEQqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:46:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9911261944;
        Wed,  5 May 2021 16:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232592;
        bh=zIWO+613aa93ZZ/vIAzAca28AJUUZ1Qux+x+xGm+ZvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8y57ETQMhrnQB7oxFLUm2bqkHGj/Xh+mkMAWAnCJ/6FIUhAVJj1DcM48Cr7GZcXg
         h6IVqwKLoXA4V7AzxPqgxhCVA8gEPk9azLBG2kt2+cZ5tPs7lmA6/FqlIuZLR+9gJx
         BJAgjXJDJsHX8A6p20KJJHM20o1ac3l3cLllt4AESZm6gStBRnM5AsVnt3j/XH4g99
         91ZFbpaKiF+324BWTs/KeUQKgQCEB/r1dq3TOVtXoJnQJ4+ALiHqWN0GKka6C0WLjd
         pi3Ed+UCaWwJmNO1NQTzXjPrDV204Ie2KRNVzk/HVJLpzXLQCJoyr4c7BcKQkf+Gh7
         mMTaEi1qSlQ4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 095/104] net: ethernet: mtk_eth_soc: fix RX VLAN offload
Date:   Wed,  5 May 2021 12:34:04 -0400
Message-Id: <20210505163413.3461611-95-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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
index 6d2d60675ffd..d930fcda9c3b 100644
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
index 454cfcd465fd..73ce1f0f307a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -295,6 +295,7 @@
 #define RX_DMA_LSO		BIT(30)
 #define RX_DMA_PLEN0(_x)	(((_x) & 0x3fff) << 16)
 #define RX_DMA_GET_PLEN0(_x)	(((_x) >> 16) & 0x3fff)
+#define RX_DMA_VTAG		BIT(15)
 
 /* QDMA descriptor rxd3 */
 #define RX_DMA_VID(_x)		((_x) & 0xfff)
-- 
2.30.2

