Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E188D37413F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhEEQgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234353AbhEEQet (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:34:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E281A61431;
        Wed,  5 May 2021 16:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232369;
        bh=7U3Eu1nbACgWo40+zxsXj+FE03qpmbDIZzfbifnV4Xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNQ+PrhRh1gtrOaFBY4p6l2AEwwS6lVdSnWxseSfd3rk/RzyRZaIZeblww9wL1pSg
         wr6OSR9CJR/QzxYkQdTDI87ieyePYGR2h/J8anx1HAmI65OkfhYzb063DjTRb9mU2L
         7+svtO3+3DxOUfCgc5/Qg84eDSWe4E8bs4AAZphp+1BQKNM+HU8tD7n5rKVns/T7HQ
         64KKmb+Ej37rAkOHEgiXe1sVkFJMO+hDPUQ++dAN3iNf6YS2x3ronq0CSYAnd6IJSr
         gDSZmt6H5UxT8jG8qNr01YmBm07GdZ0iQgYlKb98I/G9mNXHZMOZps5kUQHGPSzrkU
         Pjish/QM/Izmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 060/116] mt76: mt7915: always check return value from mt7915_mcu_alloc_wtbl_req
Date:   Wed,  5 May 2021 12:30:28 -0400
Message-Id: <20210505163125.3460440-60-sashal@kernel.org>
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
index 195929242b72..12281e4cf817 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1188,6 +1188,9 @@ mt7915_mcu_sta_ba(struct mt7915_dev *dev,
 
 	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_SET, sta_wtbl,
 					     &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	mt7915_mcu_wtbl_ba_tlv(skb, params, enable, tx, sta_wtbl, wtbl_hdr);
 
 	ret = mt76_mcu_skb_send_msg(&dev->mt76, skb,
@@ -1704,6 +1707,9 @@ int mt7915_mcu_sta_update_hdr_trans(struct mt7915_dev *dev,
 		return -ENOMEM;
 
 	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_SET, NULL, &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	mt7915_mcu_wtbl_hdr_trans_tlv(skb, vif, sta, NULL, wtbl_hdr);
 
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb, MCU_EXT_CMD(WTBL_UPDATE),
@@ -1728,6 +1734,9 @@ int mt7915_mcu_add_smps(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 
 	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_SET, sta_wtbl,
 					     &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	mt7915_mcu_wtbl_smps_tlv(skb, sta, sta_wtbl, wtbl_hdr);
 
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
@@ -2253,6 +2262,9 @@ int mt7915_mcu_add_sta(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 
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

