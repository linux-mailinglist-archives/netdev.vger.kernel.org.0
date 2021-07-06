Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411413BCD19
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhGFLUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232949AbhGFLTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0819261C82;
        Tue,  6 Jul 2021 11:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570214;
        bh=dZoRcGT2l2N1ojgVouYDpVeg3f2oqSndGIb4YvlkbrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDNvzlNgFzYS5YBkvp8sMLKI6oI7OA7xCpyXImDhVRakzhD/0VVwfLuCwb/IAJ9WI
         XCM4mamwfv6ltenNHTd+lWM0K6vu2ibEyDoJLS4TTDaZRqugz2DEm3gZ+q+b8YgCll
         QjZtOpLR7tKRIoR8msTb7EN/POlA5fBMv2kC1IE5aGgCxMOASe2PBv12s0OC8nI4rf
         e3PURRXvzmn6ZXfctoJl/IzHBnMIUKXcSDndsw86arOsC9hsNwmORC/p9t0TD9VvEA
         4liES/FpJqKH5ciByT8eMVt12zB1teaQWasT49WEG9wm6mXW/j2nBJmUxhqMTpekDp
         uWyPW+Q8praqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 123/189] mt76: dma: use ieee80211_tx_status_ext to free packets when tx fails
Date:   Tue,  6 Jul 2021 07:13:03 -0400
Message-Id: <20210706111409.2058071-123-sashal@kernel.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 94e4f5794627a80ce036c35b32a9900daeb31be3 ]

Fixes AQL issues on full queues, especially with 802.3 encap offload

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 72b1cc0ecfda..e5c324dd24f9 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -349,6 +349,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		      struct sk_buff *skb, struct mt76_wcid *wcid,
 		      struct ieee80211_sta *sta)
 {
+	struct ieee80211_tx_status status = {
+		.sta = sta,
+	};
 	struct mt76_tx_info tx_info = {
 		.skb = skb,
 	};
@@ -360,11 +363,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	u8 *txwi;
 
 	t = mt76_get_txwi(dev);
-	if (!t) {
-		hw = mt76_tx_status_get_hw(dev, skb);
-		ieee80211_free_txskb(hw, skb);
-		return -ENOMEM;
-	}
+	if (!t)
+		goto free_skb;
+
 	txwi = mt76_get_txwi_ptr(dev, t);
 
 	skb->prev = skb->next = NULL;
@@ -427,8 +428,13 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	}
 #endif
 
-	dev_kfree_skb(tx_info.skb);
 	mt76_put_txwi(dev, t);
+
+free_skb:
+	status.skb = tx_info.skb;
+	hw = mt76_tx_status_get_hw(dev, tx_info.skb);
+	ieee80211_tx_status_ext(hw, &status);
+
 	return ret;
 }
 
-- 
2.30.2

