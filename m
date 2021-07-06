Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257DD3BD033
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhGFLci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235201AbhGFL3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85C9E61D9E;
        Tue,  6 Jul 2021 11:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570443;
        bh=2jATZ63rO3C43mSyubCECRk6B6rF9AcE4slxIXNEiWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvjHEY+KLUznkvGm6NfRTnuh7X1jxePBNbIuXFBNG4KXfhjSrnS48Y7jRxw2q/Ogf
         YNkVnLoMoEE/eIJ5/AGGdD5176RtqdqHRuGlt+YtyxK/RmKqk2owXv4UyoI3ffHXzQ
         RVQkNkHFWdM4EqNFrXYa5kl72g+pdTA8c/BtbdbjvZnWKssuiASdUgxB9ht3MLRh5y
         z+S5huHAjIF2O/zD3x1Br67xLo9+HiZ79GdnIdM7WjpvorGyzGuoDdLUVn3hdtL6Uf
         2TGji/e1eBzh8Qvf+0/gcpbrSgMFYmCs6vG4tjyGyCbiQdhwzCl0I1J+bdK1FTiSTx
         QRNWEFdkZd1UA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 102/160] mt76: dma: use ieee80211_tx_status_ext to free packets when tx fails
Date:   Tue,  6 Jul 2021 07:17:28 -0400
Message-Id: <20210706111827.2060499-102-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 7196fa9047e6..87ee1b305a93 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -340,6 +340,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		      struct sk_buff *skb, struct mt76_wcid *wcid,
 		      struct ieee80211_sta *sta)
 {
+	struct ieee80211_tx_status status = {
+		.sta = sta,
+	};
 	struct mt76_tx_info tx_info = {
 		.skb = skb,
 	};
@@ -351,11 +354,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
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
@@ -418,8 +419,13 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
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

