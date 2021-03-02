Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7248332A321
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381926AbhCBIr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:47:29 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:58385 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1574445AbhCBDhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 22:37:37 -0500
X-UUID: 6b60a1727ea7474a98c3eb43c446b254-20210302
X-UUID: 6b60a1727ea7474a98c3eb43c446b254-20210302
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1007115575; Tue, 02 Mar 2021 11:33:31 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 2 Mar 2021 11:33:30 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 11:33:28 +0800
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
Subject: [PATCH] net: ethernet: mtk-star-emac: fix wrong unmap in RX handling
Date:   Tue, 2 Mar 2021 11:33:23 +0800
Message-ID: <20210302033323.25830-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.18.0
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
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index a8641a407c06..96d2891f1675 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1225,8 +1225,6 @@ static int mtk_star_receive_packet(struct mtk_star_priv *priv)
 		goto push_new_skb;
 	}
 
-	desc_data.dma_addr = new_dma_addr;
-
 	/* We can't fail anymore at this point: it's safe to unmap the skb. */
 	mtk_star_dma_unmap_rx(priv, &desc_data);
 
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

