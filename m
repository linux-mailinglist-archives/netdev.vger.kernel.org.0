Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD4D5F0207
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 02:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiI3A5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 20:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiI3A5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 20:57:23 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E482145948
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 17:57:22 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1oe4Kt-0004si-0S;
        Fri, 30 Sep 2022 02:57:04 +0200
Date:   Fri, 30 Sep 2022 01:56:53 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sujuan Chen <sujuan.chen@mediatek.com>,
        Bo Jiao <Bo.Jiao@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chen Minqiang <ptpt52@gmail.com>,
        Thomas =?iso-8859-1?Q?H=FChn?= <thomas.huehn@hs-nordhausen.de>
Subject: [PATCH v2] net: ethernet: mtk_eth_soc: fix state in
 __mtk_foe_entry_clear
Message-ID: <YzY+1Yg0FBXcnrtc@makrotopia.org>
References: <20220928190939.3c43516f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928190939.3c43516f@kernel.org>
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
on older MTK_NETSYS_V1 SoCs, OpenWrt users have confirmed the bug on
MT7622 and MT7621 systems.
Felix Fietkau suggested to use MTK_FOE_STATE_INVALID instead which
works well on both, MTK_NETSYS_V1 and MTK_NETSYS_V2.

Tested on MT7622 (Linksys E8450) and MT7986 (BananaPi BPI-R3).

Suggested-by: Felix Fietkau <nbd@nbd.name>
Fixes: 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc: fix typo in __mtk_foe_entry_clear")
Fixes: 33fc42de33278b ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v2: rebased on top of netdev/net.git;main

 drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index cfe804bc8d2055..148ea636ef9794 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -412,7 +412,7 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 	if (entry->hash != 0xffff) {
 		ppe->foe_table[entry->hash].ib1 &= ~MTK_FOE_IB1_STATE;
 		ppe->foe_table[entry->hash].ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE,
-							      MTK_FOE_STATE_UNBIND);
+							      MTK_FOE_STATE_INVALID);
 		dma_wmb();
 	}
 	entry->hash = 0xffff;
-- 
2.37.3

