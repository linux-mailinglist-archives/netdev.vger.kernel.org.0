Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BD0318BC
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfFAAQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:16:36 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:23431 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726518AbfFAAQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:16:36 -0400
X-UUID: 5271996c16df40fba33bcdd53ac2b4a6-20190601
X-UUID: 5271996c16df40fba33bcdd53ac2b4a6-20190601
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 40283549; Sat, 01 Jun 2019 08:16:30 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 1 Jun 2019 08:16:28 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 1 Jun 2019 08:16:28 +0800
From:   <sean.wang@mediatek.com>
To:     <john@phrozen.org>, <davem@davemloft.net>
CC:     <nbd@openwrt.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <mark-mc.lee@mediatek.com>
Subject: [PATCH net v1 2/2] net: ethernet: mediatek: Use NET_IP_ALIGN to judge if HW RX_2BYTE_OFFSET is enabled
Date:   Sat, 1 Jun 2019 08:16:27 +0800
Message-ID: <1559348187-14941-2-git-send-email-sean.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1559348187-14941-1-git-send-email-sean.wang@mediatek.com>
References: <1559348187-14941-1-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: A0B3E15B67915A6D9E21AD7A1D9C947EE3F76452E73B813B3042EC22ACAB26252000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

Should only enable HW RX_2BYTE_OFFSET function in the case NET_IP_ALIGN
equals to 2.

Signed-off-by: Mark Lee <mark-mc.lee@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 0b88febbaf2a..765cd56ebcd2 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1778,6 +1778,7 @@ static void mtk_poll_controller(struct net_device *dev)
 
 static int mtk_start_dma(struct mtk_eth *eth)
 {
+	u32 rx_2b_offset = (NET_IP_ALIGN == 2) ? MTK_RX_2B_OFFSET : 0;
 	int err;
 
 	err = mtk_dma_init(eth);
@@ -1794,7 +1795,7 @@ static int mtk_start_dma(struct mtk_eth *eth)
 		MTK_QDMA_GLO_CFG);
 
 	mtk_w32(eth,
-		MTK_RX_DMA_EN | MTK_RX_2B_OFFSET |
+		MTK_RX_DMA_EN | rx_2b_offset |
 		MTK_RX_BT_32DWORDS | MTK_MULTI_EN,
 		MTK_PDMA_GLO_CFG);
 
-- 
2.17.1

