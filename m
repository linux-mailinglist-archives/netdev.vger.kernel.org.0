Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55384353C43
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 09:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhDEH52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 03:57:28 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:45174 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbhDEH50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 03:57:26 -0400
Received: from localhost.localdomain ([90.126.11.170])
        by mwinf5d68 with ME
        id ovxG240053g7mfN03vxGo5; Mon, 05 Apr 2021 09:57:18 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 05 Apr 2021 09:57:18 +0200
X-ME-IP: 90.126.11.170
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] rtlwifi: Simplify locking of a skb list accesses
Date:   Mon,  5 Apr 2021 09:57:14 +0200
Message-Id: <99cf8894fd52202cb7ce2ec6e3200eef400bc071.1617609346.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'c2hcmd_lock' spinlock is only used to protect some __skb_queue_tail()
and __skb_dequeue() calls.
Use the lock provided in the skb itself and call skb_queue_tail() and
skb_dequeue(). These functions already include the correct locking.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 15 ++-------------
 drivers/net/wireless/realtek/rtlwifi/wifi.h |  1 -
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 6e8bd99e8911..2a7ee90a3f54 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -551,7 +551,6 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	spin_lock_init(&rtlpriv->locks.rf_lock);
 	spin_lock_init(&rtlpriv->locks.waitq_lock);
 	spin_lock_init(&rtlpriv->locks.entry_list_lock);
-	spin_lock_init(&rtlpriv->locks.c2hcmd_lock);
 	spin_lock_init(&rtlpriv->locks.scan_list_lock);
 	spin_lock_init(&rtlpriv->locks.cck_and_rw_pagea_lock);
 	spin_lock_init(&rtlpriv->locks.fw_ps_lock);
@@ -2269,7 +2268,6 @@ static bool rtl_c2h_fast_cmd(struct ieee80211_hw *hw, struct sk_buff *skb)
 void rtl_c2hcmd_enqueue(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	unsigned long flags;
 
 	if (rtl_c2h_fast_cmd(hw, skb)) {
 		rtl_c2h_content_parsing(hw, skb);
@@ -2278,11 +2276,7 @@ void rtl_c2hcmd_enqueue(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	/* enqueue */
-	spin_lock_irqsave(&rtlpriv->locks.c2hcmd_lock, flags);
-
-	__skb_queue_tail(&rtlpriv->c2hcmd_queue, skb);
-
-	spin_unlock_irqrestore(&rtlpriv->locks.c2hcmd_lock, flags);
+	skb_queue_tail(&rtlpriv->c2hcmd_queue, skb);
 
 	/* wake up wq */
 	queue_delayed_work(rtlpriv->works.rtl_wq, &rtlpriv->works.c2hcmd_wq, 0);
@@ -2340,16 +2334,11 @@ void rtl_c2hcmd_launcher(struct ieee80211_hw *hw, int exec)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct sk_buff *skb;
-	unsigned long flags;
 	int i;
 
 	for (i = 0; i < 200; i++) {
 		/* dequeue a task */
-		spin_lock_irqsave(&rtlpriv->locks.c2hcmd_lock, flags);
-
-		skb = __skb_dequeue(&rtlpriv->c2hcmd_queue);
-
-		spin_unlock_irqrestore(&rtlpriv->locks.c2hcmd_lock, flags);
+		skb = skb_dequeue(&rtlpriv->c2hcmd_queue);
 
 		/* do it */
 		if (!skb)
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 9119144bb5a3..877ed6a1589f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2450,7 +2450,6 @@ struct rtl_locks {
 	spinlock_t waitq_lock;
 	spinlock_t entry_list_lock;
 	spinlock_t usb_lock;
-	spinlock_t c2hcmd_lock;
 	spinlock_t scan_list_lock; /* lock for the scan list */
 
 	/*FW clock change */
-- 
2.27.0

