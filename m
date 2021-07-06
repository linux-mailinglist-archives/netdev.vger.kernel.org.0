Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF20F3BCD5D
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhGFLV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233127AbhGFLUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:20:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEF1E61CD2;
        Tue,  6 Jul 2021 11:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570231;
        bh=zPynrgZnUW8h799GItUXt5kPDHnjShwvL0DdzVFIHdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTmqegFjk1BEMjFEykmDd9VRxIp/w50CNl11EWRnKVDc3BzyuqryXtNNEkvW2fQj6
         nHaN6k7cCPQDg27b58Wdu5VWX15kWycZTDUBLezuj7HlfRWvGmonXjvLoidOt5ChsB
         7ANbelK3D+Hd1s4rm6ntEX8/slCOLYRxBwo4mHuWyjf/EaeNEVVAlb+iQjLeb1Kc+v
         Vys7XWr4GrOmkuVsuZXm40il0cL7HWXGP4ewHM59iSW8+HEUVIvKiYzNU3Ub8bfYR7
         MIXSa3u3yU8iE0RlTQG2sJNMWsmT02Efsh0ZzRVx1+6qRsZSNOPx1hYnXOJw5xjG/1
         SOK5OpbaXo0Pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 135/189] mt76: connac: fix the maximum interval schedule scan can support
Date:   Tue,  6 Jul 2021 07:13:15 -0400
Message-Id: <20210706111409.2058071-135-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit abded041a07467c2f3dfe10afd9ea10572c63cc9 ]

Maximum interval (in seconds) for schedule scan plan supported by
the offload firmware can be U16_MAX.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h     | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c     | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index d20f05a7717d..0d01fd3c77b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -362,7 +362,7 @@ mt7615_init_wiphy(struct ieee80211_hw *hw)
 	wiphy->reg_notifier = mt7615_regd_notifier;
 
 	wiphy->max_sched_scan_plan_interval =
-		MT76_CONNAC_MAX_SCHED_SCAN_INTERVAL;
+		MT76_CONNAC_MAX_TIME_SCHED_SCAN_INTERVAL;
 	wiphy->max_sched_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 	wiphy->max_scan_ie_len = MT76_CONNAC_SCAN_IE_LEN;
 	wiphy->max_sched_scan_ssids = MT76_CONNAC_MAX_SCHED_SCAN_SSID;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac.h b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
index 6c889b90fd12..5b50d29c1cb6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
@@ -7,7 +7,8 @@
 #include "mt76.h"
 
 #define MT76_CONNAC_SCAN_IE_LEN			600
-#define MT76_CONNAC_MAX_SCHED_SCAN_INTERVAL	10
+#define MT76_CONNAC_MAX_NUM_SCHED_SCAN_INTERVAL	 10
+#define MT76_CONNAC_MAX_TIME_SCHED_SCAN_INTERVAL U16_MAX
 #define MT76_CONNAC_MAX_SCHED_SCAN_SSID		10
 #define MT76_CONNAC_MAX_SCAN_MATCH		16
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 61bed6e89427..6093f39ea1dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -762,7 +762,7 @@ struct mt76_connac_sched_scan_req {
 	u8 intervals_num;
 	u8 scan_func; /* MT7663: BIT(0) eable random mac address */
 	struct mt76_connac_mcu_scan_channel channels[64];
-	__le16 intervals[MT76_CONNAC_MAX_SCHED_SCAN_INTERVAL];
+	__le16 intervals[MT76_CONNAC_MAX_NUM_SCHED_SCAN_INTERVAL];
 	union {
 		struct {
 			u8 random_mac[ETH_ALEN];
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 1763ea0614ce..bd002b4247c7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -92,7 +92,7 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 	wiphy->max_scan_ie_len = MT76_CONNAC_SCAN_IE_LEN;
 	wiphy->max_scan_ssids = 4;
 	wiphy->max_sched_scan_plan_interval =
-		MT76_CONNAC_MAX_SCHED_SCAN_INTERVAL;
+		MT76_CONNAC_MAX_TIME_SCHED_SCAN_INTERVAL;
 	wiphy->max_sched_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 	wiphy->max_sched_scan_ssids = MT76_CONNAC_MAX_SCHED_SCAN_SSID;
 	wiphy->max_match_sets = MT76_CONNAC_MAX_SCAN_MATCH;
-- 
2.30.2

