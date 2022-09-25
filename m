Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339645E93BF
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 16:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiIYOrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 10:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiIYOre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 10:47:34 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C5927B19
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 07:47:32 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ocSuk-0002Tw-1a;
        Sun, 25 Sep 2022 16:47:26 +0200
Date:   Sun, 25 Sep 2022 15:47:20 +0100
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
        Chen Minqiang <ptpt52@gmail.com>
Subject: [PATCH 1/2] net: ethernet: mtk_eth_soc: fix wrong use of new helper
 function
Message-ID: <YzBp+Kk04CFDys4L@makrotopia.org>
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

In function mtk_foe_entry_set_vlan() the call to field accessor macro
FIELD_GET(MTK_FOE_IB1_BIND_VLAN_LAYER, entry->ib1)
has been wrongly replaced by
mtk_prep_ib1_vlan_layer(eth, entry->ib1)

Use correct helper function mtk_get_ib1_vlan_layer instead.

Reported-by: Chen Minqiang <ptpt52@gmail.com>
Fixes: 03a3180e5c09e1 ("net: ethernet: mtk_eth_soc: introduce flow offloading support for mt7986")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 25f8738a062bd0..4ea2b342f252ac 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -337,7 +337,7 @@ int mtk_foe_entry_set_vlan(struct mtk_eth *eth, struct mtk_foe_entry *entry,
 {
 	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(eth, entry);
 
-	switch (mtk_prep_ib1_vlan_layer(eth, entry->ib1)) {
+	switch (mtk_get_ib1_vlan_layer(eth, entry->ib1)) {
 	case 0:
 		entry->ib1 |= mtk_get_ib1_vlan_tag_mask(eth) |
 			      mtk_prep_ib1_vlan_layer(eth, 1);
-- 
2.37.3

