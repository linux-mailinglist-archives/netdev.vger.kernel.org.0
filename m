Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAE659E58E
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbiHWPBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242860AbiHWPAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:00:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4511311117
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:25:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DE97B81CFF
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 12:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4CBC433C1;
        Tue, 23 Aug 2022 12:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661257457;
        bh=8nD764F8pk/bCJr7lH8SB9JebDWs0dWq+LVCVleKEiI=;
        h=From:To:Cc:Subject:Date:From;
        b=qRh+zTLYUJb9bh9KwhEOVH/OjwKNBKYlERoRNLd3SKo+qp2g0O7CfTl7/7IgHZGVL
         FGM94eri6TQsT//VHJhQApYvRCciF0vQLmPET7xsVeVhrVijUNkAQU4u+bY3prvyLe
         cMey5NnS2VVT1NSMhHFPPucRhwgEAk4JFIzI6fADLwyLdYB0HKCmlEMeBqqfnBsEqy
         welYKh8JG+SjRmaxtSUDpVML46NxDPkmkxQGWA+qBjKlGRYqQ2I4FiuTWtu9w+Qzzk
         y+MRcsOAY5VTtvpHPPZUXw2ltwBn+xf5c5IHcJfxLCsampxhCFfZ3bvzSwoz/Rkdqx
         viHFt/ZpwXDRg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net] net: ethernet: mtk_eth_soc: fix hw hash reporting for MTK_NETSYS_V2
Date:   Tue, 23 Aug 2022 14:24:07 +0200
Message-Id: <091394ea4e705fbb35f828011d98d0ba33808f69.1661257293.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Properly report hw rx hash for mt7986 chipset accroding to the new dma
descriptor layout.

Fixes: 197c9e9b17b11 ("net: ethernet: mtk_eth_soc: introduce support for mt7986 chipset")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- fix typo in a comment
- target net tree instead of net-next
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 22 +++++++++++----------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  5 +++++
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 8aff4c0c28bd..5ace4609de47 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1891,10 +1891,19 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb->dev = netdev;
 		bytes += skb->len;
 
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+			hash = trxd.rxd5 & MTK_RXD5_FOE_ENTRY;
+			if (hash != MTK_RXD5_FOE_ENTRY)
+				skb_set_hash(skb, jhash_1word(hash, 0),
+					     PKT_HASH_TYPE_L4);
 			rxdcsum = &trxd.rxd3;
-		else
+		} else {
+			hash = trxd.rxd4 & MTK_RXD4_FOE_ENTRY;
+			if (hash != MTK_RXD4_FOE_ENTRY)
+				skb_set_hash(skb, jhash_1word(hash, 0),
+					     PKT_HASH_TYPE_L4);
 			rxdcsum = &trxd.rxd4;
+		}
 
 		if (*rxdcsum & eth->soc->txrx.rx_dma_l4_valid)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -1902,16 +1911,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			skb_checksum_none_assert(skb);
 		skb->protocol = eth_type_trans(skb, netdev);
 
-		hash = trxd.rxd4 & MTK_RXD4_FOE_ENTRY;
-		if (hash != MTK_RXD4_FOE_ENTRY) {
-			hash = jhash_1word(hash, 0);
-			skb_set_hash(skb, hash, PKT_HASH_TYPE_L4);
-		}
-
 		reason = FIELD_GET(MTK_RXD4_PPE_CPU_REASON, trxd.rxd4);
 		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
-			mtk_ppe_check_skb(eth->ppe, skb,
-					  trxd.rxd4 & MTK_RXD4_FOE_ENTRY);
+			mtk_ppe_check_skb(eth->ppe, skb, hash);
 
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
 			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 7405c97cda66..ecf85e9ed824 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -314,6 +314,11 @@
 #define RX_DMA_L4_VALID_PDMA	BIT(30)		/* when PDMA is used */
 #define RX_DMA_SPECIAL_TAG	BIT(22)
 
+/* PDMA descriptor rxd5 */
+#define MTK_RXD5_FOE_ENTRY	GENMASK(14, 0)
+#define MTK_RXD5_PPE_CPU_REASON	GENMASK(22, 18)
+#define MTK_RXD5_SRC_PORT	GENMASK(29, 26)
+
 #define RX_DMA_GET_SPORT(x)	(((x) >> 19) & 0xf)
 #define RX_DMA_GET_SPORT_V2(x)	(((x) >> 26) & 0x7)
 
-- 
2.37.2

