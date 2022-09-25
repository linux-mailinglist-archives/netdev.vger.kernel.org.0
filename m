Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1635E93C2
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 16:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiIYOsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 10:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiIYOsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 10:48:53 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6386F275CF
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 07:48:52 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ocSw5-0002Ul-3B;
        Sun, 25 Sep 2022 16:48:50 +0200
Date:   Sun, 25 Sep 2022 15:48:43 +0100
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
Subject: [PATCH 2/2] net: ethernet: mtk_eth_soc: fix usage of foe_entry_size
Message-ID: <YzBqPIgQR2gLrPoK@makrotopia.org>
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

As sizeof(hwe->data) can now longer be used as the actual size depends
on foe_entry_size, in commit 9d8cb4c096ab02
("net: ethernet: mtk_eth_soc: add foe_entry_size to mtk_eth_soc") the
use of sizeof(hwe->data) is hence replaced.

However, replacing it with ppe->eth->soc->foe_entry_size is wrong as
foe_entry_size represents the size of the whole descriptor and not just
the 'data' field.

Fix this by subtracing the size of the only other field in the struct
'ib1', so we actually end up with the correct size to be copied to the
data field.

Reported-by: Chen Minqiang <ptpt52@gmail.com>
Fixes: 9d8cb4c096ab02 ("net: ethernet: mtk_eth_soc: add foe_entry_size to mtk_eth_soc")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 4ea2b342f252ac..887f430734f747 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -547,7 +547,7 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 	}
 
 	hwe = mtk_foe_get_entry(ppe, hash);
-	memcpy(&hwe->data, &entry->data, eth->soc->foe_entry_size);
+	memcpy(&hwe->data, &entry->data, eth->soc->foe_entry_size - sizeof(hwe->ib1));
 	wmb();
 	hwe->ib1 = entry->ib1;
 
-- 
2.37.3

