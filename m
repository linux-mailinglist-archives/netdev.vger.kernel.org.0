Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881EB61FDFF
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbiKGSz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbiKGSzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:55:43 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B1B24953;
        Mon,  7 Nov 2022 10:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R2N+jSfSlY43TnrF1h50zfC2H3h4TDeeUUxvXDObycg=; b=C7Bjul4L+uZ5OTJN4pEVSnqlbL
        qxyo4As8AlXPlDIoxFGL6JtZIC9DUnL/tZB6t9okWkqhDmncnwapQ626TBPm0Dz0MUDeEqhd6hBbb
        EU5heDXhPmbjEPt2KSK7tCs5w0nEpSdt9f0WnPmiV/Vd4yssvCnNedGvHg5vdVYP+9OI=;
Received: from p200300daa72ee1007849d74f78949f6c.dip0.t-ipconnect.de ([2003:da:a72e:e100:7849:d74f:7894:9f6c] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1os7HA-000LCc-5E; Mon, 07 Nov 2022 19:55:16 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] net: ethernet: mtk_eth_soc: avoid port_mg assignment on MT7622 and newer
Date:   Mon,  7 Nov 2022 19:54:41 +0100
Message-Id: <20221107185452.90711-3-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221107185452.90711-1-nbd@nbd.name>
References: <20221107185452.90711-1-nbd@nbd.name>
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
index 02a57729db28..9f607c80f49c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4243,7 +4243,7 @@ static const struct mtk_soc_data mt7621_data = {
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7621_CLKS_BITMAP,
 	.required_pctl = false,
-	.offload_version = 2,
+	.offload_version = 1,
 	.hash_offset = 2,
 	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
@@ -4282,7 +4282,7 @@ static const struct mtk_soc_data mt7623_data = {
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

