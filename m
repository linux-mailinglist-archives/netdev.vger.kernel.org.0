Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEE43C73D1
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhGMQKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhGMQKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:10:42 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B774EC0613F0;
        Tue, 13 Jul 2021 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=osryDm8MY41tftsoKlAz3j0I5w5bStb1c+qiIRfmEwk=; b=L+70IKRfJxdlDf80TyXdwJB3m0
        YK1DvnqiPIvynpPkHxFJnFjwPxJkKA3pAkWaJL4M10AAKnPcTJ53MZX8EHApkWxQTay0vaOydG/7Z
        YcGaFFMhy2ZZrAyJVbO4CMswut3lgbL61NRL03+cIe3WwSVxqP2kijNMCo6OMfJh0H9Q=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m3Kwn-0008TX-F0; Tue, 13 Jul 2021 18:07:49 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, ryder.lee@mediatek.com
Subject: [RFC 5/7] mt76: make number of tokens configurable dynamically
Date:   Tue, 13 Jul 2021 18:07:43 +0200
Message-Id: <20210713160745.59707-6-nbd@nbd.name>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210713160745.59707-1-nbd@nbd.name>
References: <20210713160745.59707-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preparation for adding Wireless Ethernet Dispatch support

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 1 +
 drivers/net/wireless/mediatek/mt76/mt76.h     | 6 +++---
 drivers/net/wireless/mediatek/mt76/tx.c       | 7 +++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index d03aedc3286b..ba8b06acace3 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -459,6 +459,7 @@ mt76_alloc_device(struct device *pdev, unsigned int size,
 	idr_init(&dev->token);
 
 	INIT_LIST_HEAD(&dev->txwi_cache);
+	dev->token_size = dev->drv->token_size;
 
 	for (i = 0; i < ARRAY_SIZE(dev->q_rx); i++)
 		skb_queue_head_init(&dev->rx_skb[i]);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 25c5ceef5257..840778ffe8ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -680,7 +680,8 @@ struct mt76_dev {
 
 	spinlock_t token_lock;
 	struct idr token;
-	int token_count;
+	u16 token_count;
+	u16 token_size;
 
 	wait_queue_head_t tx_wait;
 	struct sk_buff_head status_list;
@@ -1274,8 +1275,7 @@ mt76_token_get(struct mt76_dev *dev, struct mt76_txwi_cache **ptxwi)
 	int token;
 
 	spin_lock_bh(&dev->token_lock);
-	token = idr_alloc(&dev->token, *ptxwi, 0, dev->drv->token_size,
-			  GFP_ATOMIC);
+	token = idr_alloc(&dev->token, *ptxwi, 0, dev->token_size, GFP_ATOMIC);
 	spin_unlock_bh(&dev->token_lock);
 
 	return token;
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index f0f7a913eaab..9c6d26f4c795 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -691,12 +691,11 @@ int mt76_token_consume(struct mt76_dev *dev, struct mt76_txwi_cache **ptxwi)
 
 	spin_lock_bh(&dev->token_lock);
 
-	token = idr_alloc(&dev->token, *ptxwi, 0, dev->drv->token_size,
-			  GFP_ATOMIC);
+	token = idr_alloc(&dev->token, *ptxwi, 0, dev->token_size, GFP_ATOMIC);
 	if (token >= 0)
 		dev->token_count++;
 
-	if (dev->token_count >= dev->drv->token_size - MT76_TOKEN_FREE_THR)
+	if (dev->token_count >= dev->token_size - MT76_TOKEN_FREE_THR)
 		__mt76_set_tx_blocked(dev, true);
 
 	spin_unlock_bh(&dev->token_lock);
@@ -716,7 +715,7 @@ mt76_token_release(struct mt76_dev *dev, int token, bool *wake)
 	if (txwi)
 		dev->token_count--;
 
-	if (dev->token_count < dev->drv->token_size - MT76_TOKEN_FREE_THR &&
+	if (dev->token_count < dev->token_size - MT76_TOKEN_FREE_THR &&
 	    dev->phy.q_tx[0]->blocked)
 		*wake = true;
 
-- 
2.30.1

