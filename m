Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2601126F40B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbgIRDL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbgIRCC3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D04A821D40;
        Fri, 18 Sep 2020 02:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394541;
        bh=sqlLud8CEaAaBFbB3Brfhi39Fv7Pc8MrM/ur4dg+zwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrAyOagF5rjmo7wqbC76FUFEPObc84DFE2g1BJ9gz1RKVe49bGVkAtcvsUYM29tYO
         TdRA7aoN36hPqI6QxWEKQ0v9Jm8D/UsVgtkRDyGIomskqYmx/Ctv+Kn3JTkc/ZZWre
         D/Ybk1o9Y9gQTGaHHs43f6KiNM/A5B2VWJ2Ku1ZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 059/330] mt76: add missing locking around ampdu action
Date:   Thu, 17 Sep 2020 21:56:39 -0400
Message-Id: <20200918020110.2063155-59-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 1a817fa73c3b27a593aadf0029de24db1bbc1a3e ]

This is needed primarily to avoid races in dealing with rx aggregation
related data structures

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c  | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7615/main.c  | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 25d5b1608bc91..0a5695c3d9241 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -561,6 +561,7 @@ mt7603_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mtxq = (struct mt76_txq *)txq->drv_priv;
 
+	mutex_lock(&dev->mt76.mutex);
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid, ssn,
@@ -590,6 +591,7 @@ mt7603_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	}
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 87c748715b5d7..38183aef0eb92 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -455,6 +455,7 @@ mt7615_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mtxq = (struct mt76_txq *)txq->drv_priv;
 
+	mutex_lock(&dev->mt76.mutex);
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid, ssn,
@@ -485,6 +486,7 @@ mt7615_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	}
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index aec73a0295e86..de0d6f21c621c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -371,6 +371,7 @@ int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mtxq = (struct mt76_txq *)txq->drv_priv;
 
+	mutex_lock(&dev->mt76.mutex);
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid,
@@ -400,6 +401,7 @@ int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	}
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
-- 
2.25.1

