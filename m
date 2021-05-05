Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9A7374241
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhEEQqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:46:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235757AbhEEQo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:44:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54D806191E;
        Wed,  5 May 2021 16:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232532;
        bh=QJ+YkKBhnjMB154wdrYAXSTMHCG8sjOU2BZsUExpeco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNxOK18PZdz2niZXbLKtJqDuSZobOfksc5LnP/d3jWdJZQk9S5XewdCyjtQ2twfV7
         +99apIRTyfmzD6f1Mk0+mlSrI6Y1S9cGx/Gh0ufTiylBOOw8gjr87nfjXCWHKgccRs
         /HdCvpO8jDAqEGWg0BN5GgjevkKvSRBJ8QK1tNFq1yRSqXPMq05i+QGgtW90K1x35J
         P4MXL0HRMe0cQaTzDZLRycueJf+Ike5jHoGSiZLgk8j8SptyNoxuiK9vcLAh/6D7Cc
         i9gllcpusMNMTt0azEcoqrc3rWTwDQuon5/+1REO9dFi7DA7QDuSV/BZPi8/5ykVTu
         76FrflM8PFJ/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 054/104] mt76: mt7915: always check return value from mt7915_mcu_alloc_wtbl_req
Date:   Wed,  5 May 2021 12:33:23 -0400
Message-Id: <20210505163413.3461611-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 45f93e368211fbbd247e1ece254ffb121e20fa10 ]

As done for mt76_connac_mcu_alloc_wtbl_req, even if this is not a real
bug since mt7915_mcu_alloc_wtbl_req routine can fails just if nskb is NULL,
always check return value from mt7915_mcu_alloc_wtbl_req in order to avoid
possible future mistake.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index e211a2bd4d3c..1cbae0eacfe9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1170,6 +1170,9 @@ mt7915_mcu_sta_ba(struct mt7915_dev *dev,
 
 	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_SET, sta_wtbl,
 					     &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	mt7915_mcu_wtbl_ba_tlv(skb, params, enable, tx, sta_wtbl, wtbl_hdr);
 
 	ret = mt76_mcu_skb_send_msg(&dev->mt76, skb,
@@ -1686,6 +1689,9 @@ int mt7915_mcu_sta_update_hdr_trans(struct mt7915_dev *dev,
 		return -ENOMEM;
 
 	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_SET, NULL, &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	mt7915_mcu_wtbl_hdr_trans_tlv(skb, vif, sta, NULL, wtbl_hdr);
 
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb, MCU_EXT_CMD_WTBL_UPDATE,
@@ -1710,6 +1716,9 @@ int mt7915_mcu_add_smps(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 
 	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_SET, sta_wtbl,
 					     &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	mt7915_mcu_wtbl_smps_tlv(skb, sta, sta_wtbl, wtbl_hdr);
 
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
@@ -2279,6 +2288,9 @@ int mt7915_mcu_add_sta(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 
 	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_RESET_AND_SET,
 					     sta_wtbl, &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	if (enable) {
 		mt7915_mcu_wtbl_generic_tlv(skb, vif, sta, sta_wtbl, wtbl_hdr);
 		mt7915_mcu_wtbl_hdr_trans_tlv(skb, vif, sta, sta_wtbl, wtbl_hdr);
-- 
2.30.2

