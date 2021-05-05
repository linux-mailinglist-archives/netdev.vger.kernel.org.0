Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ED537414A
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhEEQhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234313AbhEEQe4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:34:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE9D56141B;
        Wed,  5 May 2021 16:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232371;
        bh=k1/+NZWdIyxXM4YAwQQG+VyV9Eo3Vmzg3To1cnf+uRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQossZIIp5pnhyCbNLsY3eQdHV1cTJBiA/vcbx/KrY8UWt74Er7za80DDLX4ewB/n
         PM3eYdZCKVMRiBgTuvmHwrH36vtAvvJp7gFBZcJ8MJnfEn4ERxoadBM2SelYvJbXXY
         qdWFOTJAa/J7JAskVaAh5GpqHhV7Yk8mBtTc/YAPsy7S/C4h833xdMqOceHzrhKZkO
         IFUy3m1AnGKXfne7WNhgNWCafQbKEas5HR0sd0hlR/UizKganIQa5TTQLLcovqkzYK
         Qja4gLlE5yVaB1uw15ofyOdaC8XgJExIa070QigevRzV1CoJ/INM7CYI/2yx7BCdUq
         amu4zNmLOwRjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 062/116] mt76: mt7915: fix txpower init for TSSI off chips
Date:   Wed,  5 May 2021 12:30:30 -0400
Message-Id: <20210505163125.3460440-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index 660398ac53c2..738ecf8f4fa2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -124,7 +124,7 @@ int mt7915_eeprom_get_target_power(struct mt7915_dev *dev,
 				   struct ieee80211_channel *chan,
 				   u8 chain_idx)
 {
-	int index;
+	int index, target_power;
 	bool tssi_on;
 
 	if (chain_idx > 3)
@@ -133,15 +133,22 @@ int mt7915_eeprom_get_target_power(struct mt7915_dev *dev,
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

