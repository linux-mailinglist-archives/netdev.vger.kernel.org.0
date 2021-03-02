Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332E932A42A
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382764AbhCBKNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 05:13:41 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45504 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1349531AbhCBKEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 05:04:40 -0500
X-UUID: 16e25da9c9184a91ab13600ee2c71c55-20210302
X-UUID: 16e25da9c9184a91ab13600ee2c71c55-20210302
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1400073638; Tue, 02 Mar 2021 18:03:50 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 2 Mar 2021 18:03:50 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 18:03:49 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <biao.huang@mediatek.com>,
        <srv_heupstream@mediatek.com>
Subject: [v2 PATCH] net: ethernet: mtk-star-emac: fix wrong unmap in RX handling
Date:   Tue, 2 Mar 2021 18:03:45 +0800
Message-ID: <20210302100345.27982-2-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210302100345.27982-1-biao.huang@mediatek.com>
References: <20210302100345.27982-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mtk_star_dma_unmap_rx() should unmap the dma_addr of old skb rather than
that of new skb.
Assign new_dma_addr to desc_data.dma_addr after all handling of old skb
ends to avoid unexpected receive side error.

Fixes: f96e9641e92b ("net: ethernet: mtk-star-emac: fix error path in RX handling")
Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index a8641a407c06..84b3f56a9965 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1225,9 +1225,7 @@ static int mtk_star_receive_packet(struct mtk_star_priv *priv)
 		goto push_new_skb;
 	}
 
-	desc_data.dma_addr = new_dma_addr;
-
-	/* We can't fail anymore at this point: it's safe to unmap the skb. */
+	/* We can't fail anymore at this point: it's safe to unmap the old skb. */
 	mtk_star_dma_unmap_rx(priv, &desc_data);
 
 	skb_put(desc_data.skb, desc_data.len);
@@ -1236,6 +1234,9 @@ static int mtk_star_receive_packet(struct mtk_star_priv *priv)
 	desc_data.skb->dev = ndev;
 	netif_receive_skb(desc_data.skb);
 
+	/* update dma_addr for new skb */
+	desc_data.dma_addr = new_dma_addr;
+
 push_new_skb:
 	desc_data.len = skb_tailroom(new_skb);
 	desc_data.skb = new_skb;
-- 
2.18.0

