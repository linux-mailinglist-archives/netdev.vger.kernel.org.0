Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0836A353F10
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 12:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbhDEJKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 05:10:03 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:51885 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S239053AbhDEJJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 05:09:26 -0400
Received: from localhost.localdomain ([90.126.11.170])
        by mwinf5d73 with ME
        id ox9G2400A3g7mfN03x9HB9; Mon, 05 Apr 2021 11:09:18 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 05 Apr 2021 11:09:18 +0200
X-ME-IP: 90.126.11.170
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] rtl8xxxu: Simplify locking of a skb list accesses
Date:   Mon,  5 Apr 2021 11:09:14 +0200
Message-Id: <8bcec6429615aeb498482dc7e1955ce09b456585.1617613700.git.christophe.jaillet@wanadoo.fr>
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
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      |  1 -
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 11 ++---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index d6d1be4169e5..d1a566cc0c9e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1391,7 +1391,6 @@ struct rtl8xxxu_priv {
 	struct delayed_work ra_watchdog;
 	struct work_struct c2hcmd_work;
 	struct sk_buff_head c2hcmd_queue;
-	spinlock_t c2hcmd_lock;
 	struct rtl8xxxu_btcoex bt_coex;
 	struct rtl8xxxu_ra_report ra_report;
 };
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 5cd7ef3625c5..0eba42f2a66c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5423,7 +5423,6 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 	struct rtl8xxxu_priv *priv;
 	struct rtl8723bu_c2h *c2h;
 	struct sk_buff *skb = NULL;
-	unsigned long flags;
 	u8 bt_info = 0;
 	struct rtl8xxxu_btcoex *btcoex;
 	struct rtl8xxxu_ra_report *rarpt;
@@ -5439,9 +5438,7 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 		goto out;
 
 	while (!skb_queue_empty(&priv->c2hcmd_queue)) {
-		spin_lock_irqsave(&priv->c2hcmd_lock, flags);
-		skb = __skb_dequeue(&priv->c2hcmd_queue);
-		spin_unlock_irqrestore(&priv->c2hcmd_lock, flags);
+		skb = skb_dequeue(&priv->c2hcmd_queue);
 
 		c2h = (struct rtl8723bu_c2h *)skb->data;
 
@@ -5499,7 +5496,6 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 	struct rtl8723bu_c2h *c2h = (struct rtl8723bu_c2h *)skb->data;
 	struct device *dev = &priv->udev->dev;
 	int len;
-	unsigned long flags;
 
 	len = skb->len - 2;
 
@@ -5538,9 +5534,7 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 		break;
 	}
 
-	spin_lock_irqsave(&priv->c2hcmd_lock, flags);
-	__skb_queue_tail(&priv->c2hcmd_queue, skb);
-	spin_unlock_irqrestore(&priv->c2hcmd_lock, flags);
+	skb_queue_tail(&priv->c2hcmd_queue, skb);
 
 	schedule_work(&priv->c2hcmd_work);
 }
@@ -6606,7 +6600,6 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	spin_lock_init(&priv->rx_urb_lock);
 	INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
 	INIT_DELAYED_WORK(&priv->ra_watchdog, rtl8xxxu_watchdog_callback);
-	spin_lock_init(&priv->c2hcmd_lock);
 	INIT_WORK(&priv->c2hcmd_work, rtl8xxxu_c2hcmd_callback);
 	skb_queue_head_init(&priv->c2hcmd_queue);
 
-- 
2.27.0

