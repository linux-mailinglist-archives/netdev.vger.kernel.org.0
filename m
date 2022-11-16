Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E6462B4A2
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238702AbiKPIJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238543AbiKPIIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:08:12 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74577B845;
        Wed, 16 Nov 2022 00:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QcTlWUKVC2/cQIdxmlzW6LcCIg0FG9Do0dcgy2oaaog=; b=FJlGLNJvPDJXA0gr5HSzexYVcc
        g09gP2L2hebhW9VIKAAAAA3/6Ce6MVt1XHAZxUg+2XUONIFHodVoSKN/fK5vTvERzeMi1lYXi6Cfo
        gsLyQ1oyLSZHxVpVMv2BPt5JcoQtjzgeOFN+K61OIB4Ottq3Tu6Qv2sZCsgndLER6RJU=;
Received: from p200300daa72ee10015f07c5633889601.dip0.t-ipconnect.de ([2003:da:a72e:e100:15f0:7c56:3388:9601] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1ovDSK-002Xoe-Vh; Wed, 16 Nov 2022 09:07:37 +0100
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
Subject: [PATCH net-next 3/6] net: ethernet: mtk_eth_soc: avoid port_mg assignment on MT7622 and newer
Date:   Wed, 16 Nov 2022 09:07:31 +0100
Message-Id: <20221116080734.44013-4-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116080734.44013-1-nbd@nbd.name>
References: <20221116080734.44013-1-nbd@nbd.name>
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

On newer chips, this field is unused and contains some bits related to queue
assignment. Initialize it to 0 in those cases.
Fix offload_version on MT7621 and MT7623, which still need the previous value.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++--
 drivers/net/ethernet/mediatek/mtk_ppe.c     | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index fbfc23923bf5..9e5545242216 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4312,7 +4312,7 @@ static const struct mtk_soc_data mt7621_data = {
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7621_CLKS_BITMAP,
 	.required_pctl = false,
-	.offload_version = 2,
+	.offload_version = 1,
 	.hash_offset = 2,
 	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
@@ -4351,7 +4351,7 @@ static const struct mtk_soc_data mt7623_data = {
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
-	.offload_version = 2,
+	.offload_version = 1,
 	.hash_offset = 2,
 	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 2d8ca99f2467..3ee2bf53f9e5 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -175,6 +175,8 @@ int mtk_foe_entry_prepare(struct mtk_eth *eth, struct mtk_foe_entry *entry,
 		val = FIELD_PREP(MTK_FOE_IB2_DEST_PORT_V2, pse_port) |
 		      FIELD_PREP(MTK_FOE_IB2_PORT_AG_V2, 0xf);
 	} else {
+		int port_mg = eth->soc->offload_version > 1 ? 0 : 0x3f;
+
 		val = FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_BIND) |
 		      FIELD_PREP(MTK_FOE_IB1_PACKET_TYPE, type) |
 		      FIELD_PREP(MTK_FOE_IB1_UDP, l4proto == IPPROTO_UDP) |
@@ -182,7 +184,7 @@ int mtk_foe_entry_prepare(struct mtk_eth *eth, struct mtk_foe_entry *entry,
 		entry->ib1 = val;
 
 		val = FIELD_PREP(MTK_FOE_IB2_DEST_PORT, pse_port) |
-		      FIELD_PREP(MTK_FOE_IB2_PORT_MG, 0x3f) |
+		      FIELD_PREP(MTK_FOE_IB2_PORT_MG, port_mg) |
 		      FIELD_PREP(MTK_FOE_IB2_PORT_AG, 0x1f);
 	}
 
-- 
2.38.1

