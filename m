Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532275ED29F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 03:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiI1BZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 21:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiI1BZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 21:25:35 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD07E62C9
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 18:25:33 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1odLpE-0001wU-0j;
        Wed, 28 Sep 2022 03:25:24 +0200
Date:   Wed, 28 Sep 2022 02:25:15 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Sujuan Chen <sujuan.chen@mediatek.com>,
        Bo Jiao <Bo.Jiao@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chen Minqiang <ptpt52@gmail.com>,
        Thomas =?iso-8859-1?Q?H=FChn?= <thomas.huehn@hs-nordhausen.de>
Subject: [PATCH] net: ethernet: mtk_eth_soc: fix state in
 __mtk_foe_entry_clear
Message-ID: <YzOie0dkiQ43EPnu@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting ib1 state to MTK_FOE_STATE_UNBIND in __mtk_foe_entry_clear
routine as done by commit 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc:
fix typo in __mtk_foe_entry_clear") breaks flow offloading, at least
on older MTK_NETSYS_V1 SoCs; OpenWrt users have confirmed the bug on
MT7622 and MT7621 systems.
Felix Fietkau suggested to use MTK_FOE_STATE_INVALID instead which
works well on both, MTK_NETSYS_V1 and MTK_NETSYS_V2.

Tested on MT7622 (Linksys E8450) and MT7986 (BananaPi BPI-R3).

Suggested-by: Felix Fietkau <nbd@nbd.name>
Fixes: 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc: fix typo in __mtk_foe_entry_clear")
Fixes: 33fc42de33278 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 887f430734f747..ae00e572390d7b 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -442,7 +442,7 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 		struct mtk_foe_entry *hwe = mtk_foe_get_entry(ppe, entry->hash);
 
 		hwe->ib1 &= ~MTK_FOE_IB1_STATE;
-		hwe->ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_UNBIND);
+		hwe->ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_INVALID);
 		dma_wmb();
 	}
 	entry->hash = 0xffff;
-- 
2.37.3

