Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5A6374426
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbhEEQzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235606AbhEEQvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:51:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 986F261965;
        Wed,  5 May 2021 16:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232672;
        bh=/SzXmTGqbDyxVH+gy01NWuzrI1L3UAsKsg/UFD0dWOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjjLlf6eUONizUuDudcCwHilobyElcqdbgyGXllTZGVC73s2hlhTQnTpaF4AcGF6j
         aUUDVZr+rkHW5l7hBztqhY34EGqoKfhoR1b5PC42/InzDP2+vMiJWpuBMe5fVWSXG7
         jGE5q8uMOGiVV4O90LupATwYWvtFIPQ5Au8BOTbVypaEjEUJ/7UiZ01BDer47ORmTi
         iSw3pkHKJUn+cwZEBvvTnJnR+ghchFcbf9nLWfMVRD1XiiJlE5/TTCIv5lxQrionAM
         AFvNPQPHvDl/16ohucSvJ6giNo9MoRi2R/92z4h26ULiBQsK3l1EpteYiH+TaiD1N3
         toRNVN8h6FjyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 43/85] mt76: mt7915: fix txpower init for TSSI off chips
Date:   Wed,  5 May 2021 12:36:06 -0400
Message-Id: <20210505163648.3462507-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit a226ccd04c479ccd23d6927c64bad1b441707f70 ]

Fix incorrect txpower init value for TSSI off chips which causes
too small txpower.

Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7915/eeprom.c    | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 7deba7ebd68a..e4c5f968f706 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -104,7 +104,7 @@ int mt7915_eeprom_get_target_power(struct mt7915_dev *dev,
 				   struct ieee80211_channel *chan,
 				   u8 chain_idx)
 {
-	int index;
+	int index, target_power;
 	bool tssi_on;
 
 	if (chain_idx > 3)
@@ -113,15 +113,22 @@ int mt7915_eeprom_get_target_power(struct mt7915_dev *dev,
 	tssi_on = mt7915_tssi_enabled(dev, chan->band);
 
 	if (chan->band == NL80211_BAND_2GHZ) {
-		index = MT_EE_TX0_POWER_2G + chain_idx * 3 + !tssi_on;
+		index = MT_EE_TX0_POWER_2G + chain_idx * 3;
+		target_power = mt7915_eeprom_read(dev, index);
+
+		if (!tssi_on)
+			target_power += mt7915_eeprom_read(dev, index + 1);
 	} else {
-		int group = tssi_on ?
-			    mt7915_get_channel_group(chan->hw_value) : 8;
+		int group = mt7915_get_channel_group(chan->hw_value);
+
+		index = MT_EE_TX0_POWER_5G + chain_idx * 12;
+		target_power = mt7915_eeprom_read(dev, index + group);
 
-		index = MT_EE_TX0_POWER_5G + chain_idx * 12 + group;
+		if (!tssi_on)
+			target_power += mt7915_eeprom_read(dev, index + 8);
 	}
 
-	return mt7915_eeprom_read(dev, index);
+	return target_power;
 }
 
 static const u8 sku_cck_delta_map[] = {
-- 
2.30.2

