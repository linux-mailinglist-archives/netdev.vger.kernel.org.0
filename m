Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E36C656B87
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 15:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiL0OI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 09:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiL0OIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 09:08:22 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082CD634A;
        Tue, 27 Dec 2022 06:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NhkhKuz1T8rY3m+BTG+T8ROPfsy5F+fsbAj5AjslqQI=; b=bHRRVkl6OIg31PWjSg1UuCP0XI
        uFWEUyviKbGEiVg7WZg8K+xAq7B7Vqs0z067i3HUfUzQ8woB7ZoMh7v2xxf/k7LB5iMpGGEkomW+4
        1ELdEvlxY2VYilCRYjKkxAB7w4AXf2SyLOTxdhyAwIW6Zfta4NRremPVSZ6a84a87BAc=;
Received: from p200300daa720fc040c81ba64b0a9b1e5.dip0.t-ipconnect.de ([2003:da:a720:fc04:c81:ba64:b0a9:b1e5] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pAAcl-00C3RB-A3; Tue, 27 Dec 2022 15:08:11 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 5/5] net: ethernet: mtk_eth_soc: ppe: fix L2 offloading with DSA untagging offload enabled
Date:   Tue, 27 Dec 2022 15:08:07 +0100
Message-Id: <20221227140807.48413-5-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221227140807.48413-1-nbd@nbd.name>
References: <20221227140807.48413-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check for skb metadata in order to detect the case where the DSA header is not
present.

Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 6 +++---
 drivers/net/ethernet/mediatek/mtk_ppe.c     | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 214cd80a19a0..b54248bce501 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2039,9 +2039,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			skb_checksum_none_assert(skb);
 		skb->protocol = eth_type_trans(skb, netdev);
 
-		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
-			mtk_ppe_check_skb(eth->ppe[0], skb, hash);
-
 		/* When using VLAN untagging in combination with DSA, the
 		 * hardware treats the MTK special tag as a VLAN and untags it.
 		 */
@@ -2054,6 +2051,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 				skb_dst_set_noref(skb, &eth->dsa_meta[port]->dst);
 		}
 
+		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
+			mtk_ppe_check_skb(eth->ppe[0], skb, hash);
+
 		skb_record_rx_queue(skb, 0);
 		napi_gro_receive(napi, skb);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 269208a841c7..e366a83cf516 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -8,6 +8,7 @@
 #include <linux/platform_device.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
+#include <net/dst_metadata.h>
 #include <net/dsa.h>
 #include "mtk_eth_soc.h"
 #include "mtk_ppe.h"
@@ -700,7 +701,9 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 		    skb->dev->dsa_ptr->tag_ops->proto != DSA_TAG_PROTO_MTK)
 			goto out;
 
-		tag += 4;
+		if (!skb_metadata_dst(skb))
+			tag += 4;
+
 		if (get_unaligned_be16(tag) != ETH_P_8021Q)
 			break;
 
-- 
2.38.1

