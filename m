Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41FB4915DA
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345744AbiARCb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:31:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44732 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343854AbiARC1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:27:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49C0C6093C;
        Tue, 18 Jan 2022 02:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED67AC36AE3;
        Tue, 18 Jan 2022 02:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472850;
        bh=ziNTfB6MFkrrpKUiqMSsH39v3XYf+3hqHdG+XYLv7Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jp7omHedPjHYkzqf0U/OfyOuRe4iYMJ13hc+tDjhIdktuQZB+9xTJPLYfQCNgrFqw
         zGsfJ6z5GVlaDiCMh7FuSwnuAPWtODay6H+x+KOH2IfAzlLw1rqM8ZjNkwLRyWQYc+
         q9ox+p09xBOlVKzyQfioUfLkRMJ+H6IG/xwExphuL9MXkCbyXEO8h0Nf/0aoSME4g2
         TIrY4c9RdY09s0qWPdaCAcwokGtuUoG/JvOiKbZ89dv62Oa9LwWTOp0r559nmSdjK8
         mmQFdD+o4QsWdgj4Yle2PlSGvlOlHY7yOeAqtEGUXJOlbXWoXNTcyPtm903D6WA4RT
         3a6R29QzXMl6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryder Lee <ryder.lee@mediatek.com>,
        Fang Zhao <fang.zhao@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo.bianconi83@gmail.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        shayne.chen@mediatek.com, Bo.Jiao@mediatek.com,
        meichia.chiu@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 153/217] mt76: mt7915: fix SMPS operation fail
Date:   Mon, 17 Jan 2022 21:18:36 -0500
Message-Id: <20220118021940.1942199-153-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 8f05835425ce3f669e4b6d7c2c39a9aa22e1506c ]

TGn fails sending SM power save mode action frame to the AP to switch
from dynamic SMPS mode to static mode.

Reported-by: Fang Zhao <fang.zhao@mediatek.com>
Signed-off-by: Fang Zhao <fang.zhao@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 81 ++++++++++++-------
 .../net/wireless/mediatek/mt76/mt7915/mcu.h   |  8 ++
 2 files changed, 61 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 852d5d97c70b1..8215b3d79bbdc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1752,33 +1752,6 @@ int mt7915_mcu_sta_update_hdr_trans(struct mt7915_dev *dev,
 				     true);
 }
 
-int mt7915_mcu_add_smps(struct mt7915_dev *dev, struct ieee80211_vif *vif,
-			struct ieee80211_sta *sta)
-{
-	struct mt7915_vif *mvif = (struct mt7915_vif *)vif->drv_priv;
-	struct mt7915_sta *msta = (struct mt7915_sta *)sta->drv_priv;
-	struct wtbl_req_hdr *wtbl_hdr;
-	struct tlv *sta_wtbl;
-	struct sk_buff *skb;
-
-	skb = mt7915_mcu_alloc_sta_req(dev, mvif, msta,
-				       MT7915_STA_UPDATE_MAX_SIZE);
-	if (IS_ERR(skb))
-		return PTR_ERR(skb);
-
-	sta_wtbl = mt7915_mcu_add_tlv(skb, STA_REC_WTBL, sizeof(struct tlv));
-
-	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_SET, sta_wtbl,
-					     &skb);
-	if (IS_ERR(wtbl_hdr))
-		return PTR_ERR(wtbl_hdr);
-
-	mt7915_mcu_wtbl_smps_tlv(skb, sta, sta_wtbl, wtbl_hdr);
-
-	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
-				     MCU_EXT_CMD(STA_REC_UPDATE), true);
-}
-
 static inline bool
 mt7915_is_ebf_supported(struct mt7915_phy *phy, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, bool bfee)
@@ -2049,6 +2022,21 @@ mt7915_mcu_sta_bfee_tlv(struct mt7915_dev *dev, struct sk_buff *skb,
 	bfee->fb_identity_matrix = (nrow == 1 && tx_ant == 2);
 }
 
+static enum mcu_mmps_mode
+mt7915_mcu_get_mmps_mode(enum ieee80211_smps_mode smps)
+{
+	switch (smps) {
+	case IEEE80211_SMPS_OFF:
+		return MCU_MMPS_DISABLE;
+	case IEEE80211_SMPS_STATIC:
+		return MCU_MMPS_STATIC;
+	case IEEE80211_SMPS_DYNAMIC:
+		return MCU_MMPS_DYNAMIC;
+	default:
+		return MCU_MMPS_DISABLE;
+	}
+}
+
 int mt7915_mcu_set_fixed_rate_ctrl(struct mt7915_dev *dev,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_sta *sta,
@@ -2076,7 +2064,11 @@ int mt7915_mcu_set_fixed_rate_ctrl(struct mt7915_dev *dev,
 	case RATE_PARAM_FIXED_MCS:
 	case RATE_PARAM_FIXED_GI:
 	case RATE_PARAM_FIXED_HE_LTF:
-		ra->phy = *phy;
+		if (phy)
+			ra->phy = *phy;
+		break;
+	case RATE_PARAM_MMPS_UPDATE:
+		ra->mmps_mode = mt7915_mcu_get_mmps_mode(sta->smps_mode);
 		break;
 	default:
 		break;
@@ -2087,6 +2079,39 @@ int mt7915_mcu_set_fixed_rate_ctrl(struct mt7915_dev *dev,
 				     MCU_EXT_CMD(STA_REC_UPDATE), true);
 }
 
+int mt7915_mcu_add_smps(struct mt7915_dev *dev, struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta)
+{
+	struct mt7915_vif *mvif = (struct mt7915_vif *)vif->drv_priv;
+	struct mt7915_sta *msta = (struct mt7915_sta *)sta->drv_priv;
+	struct wtbl_req_hdr *wtbl_hdr;
+	struct tlv *sta_wtbl;
+	struct sk_buff *skb;
+	int ret;
+
+	skb = mt7915_mcu_alloc_sta_req(dev, mvif, msta,
+				       MT7915_STA_UPDATE_MAX_SIZE);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	sta_wtbl = mt7915_mcu_add_tlv(skb, STA_REC_WTBL, sizeof(struct tlv));
+
+	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_SET, sta_wtbl,
+					     &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
+	mt7915_mcu_wtbl_smps_tlv(skb, sta, sta_wtbl, wtbl_hdr);
+
+	ret = mt76_mcu_skb_send_msg(&dev->mt76, skb,
+				    MCU_EXT_CMD(STA_REC_UPDATE), true);
+	if (ret)
+		return ret;
+
+	return mt7915_mcu_set_fixed_rate_ctrl(dev, vif, sta, NULL,
+					      RATE_PARAM_MMPS_UPDATE);
+}
+
 static int
 mt7915_mcu_add_rate_ctrl_fixed(struct mt7915_dev *dev,
 			       struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
index 1f5a64ba9b59d..628e90d0c394e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
@@ -365,6 +365,13 @@ enum {
 	MCU_PHY_STATE_OFDMLQ_CNINFO,
 };
 
+enum mcu_mmps_mode {
+	MCU_MMPS_STATIC,
+	MCU_MMPS_DYNAMIC,
+	MCU_MMPS_RSV,
+	MCU_MMPS_DISABLE,
+};
+
 #define STA_TYPE_STA			BIT(0)
 #define STA_TYPE_AP			BIT(1)
 #define STA_TYPE_ADHOC			BIT(2)
@@ -960,6 +967,7 @@ struct sta_rec_ra_fixed {
 
 enum {
 	RATE_PARAM_FIXED = 3,
+	RATE_PARAM_MMPS_UPDATE = 5,
 	RATE_PARAM_FIXED_HE_LTF = 7,
 	RATE_PARAM_FIXED_MCS,
 	RATE_PARAM_FIXED_GI = 11,
-- 
2.34.1

