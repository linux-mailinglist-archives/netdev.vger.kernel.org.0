Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE8927BA44
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgI2Baf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgI2Bac (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1749D20678;
        Tue, 29 Sep 2020 01:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343032;
        bh=41COe5x7JjD1OwT5Ov3l1HjeqLrAse49svUyDHzocaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLhgSvA4xq02Lz8Ei0c/KN2TB6mD3QSsLkPiJJ3ZrL9SCZfGKFb/xstXxaNamrpGH
         rSJPbmA+504RfW2sSE5sXbzWZ1vJZWJrp8IvE+1yLZ8iV0ax1BaHzCUJBJszvW7ZJF
         KAxUJw4L3M5WhjBK3LvXSA7pq8COtzOmIZ2TUvmc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 03/29] mt76: mt7915: use ieee80211_free_txskb to free tx skbs
Date:   Mon, 28 Sep 2020 21:30:00 -0400
Message-Id: <20200929013027.2406344-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit b4be5a53ebf478ffcfb4c98c0ccc4a8d922b9a02 ]

Using dev_kfree_skb for tx skbs breaks AQL. This worked until now only
by accident, because a mac80211 issue breaks AQL on drivers with firmware
rate control that report the rate via ieee80211_tx_status_ext as struct
rate_info.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200812144943.91974-1-nbd@nbd.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 8 ++++++--
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c  | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index aadf56e80bae8..d7a3b05ab50c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -691,8 +691,12 @@ void mt7915_unregister_device(struct mt7915_dev *dev)
 	spin_lock_bh(&dev->token_lock);
 	idr_for_each_entry(&dev->token, txwi, id) {
 		mt7915_txp_skb_unmap(&dev->mt76, txwi);
-		if (txwi->skb)
-			dev_kfree_skb_any(txwi->skb);
+		if (txwi->skb) {
+			struct ieee80211_hw *hw;
+
+			hw = mt76_tx_status_get_hw(&dev->mt76, txwi->skb);
+			ieee80211_free_txskb(hw, txwi->skb);
+		}
 		mt76_put_txwi(&dev->mt76, txwi);
 	}
 	spin_unlock_bh(&dev->token_lock);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index a264e304a3dfb..5800b2d1fb233 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -844,7 +844,7 @@ mt7915_tx_complete_status(struct mt76_dev *mdev, struct sk_buff *skb,
 	if (sta || !(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mt7915_tx_status(sta, hw, info, NULL);
 
-	dev_kfree_skb(skb);
+	ieee80211_free_txskb(hw, skb);
 }
 
 void mt7915_txp_skb_unmap(struct mt76_dev *dev,
-- 
2.25.1

