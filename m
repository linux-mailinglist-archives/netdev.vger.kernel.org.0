Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0773530C5
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 23:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbhDBVbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 17:31:11 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:46552 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235241AbhDBVbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 17:31:07 -0400
Received: from localhost.localdomain ([90.126.11.170])
        by mwinf5d36 with ME
        id nxX3240013g7mfN03xX31V; Fri, 02 Apr 2021 23:31:05 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 02 Apr 2021 23:31:05 +0200
X-ME-IP: 90.126.11.170
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     chunkeey@googlemail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] carl9170: remove get_tid_h
Date:   Fri,  2 Apr 2021 23:31:00 +0200
Message-Id: <68efad7a597159e22771d37fc8b4a8a613866d60.1617399010.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'get_tid_h()' is the same as 'ieee80211_get_tid()'.
So this function can be removed to save a few lines of code.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/ath/carl9170/carl9170.h | 7 +------
 drivers/net/wireless/ath/carl9170/tx.c       | 2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 0d38100d6e4f..84a8ce0784b1 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -631,14 +631,9 @@ static inline u16 carl9170_get_seq(struct sk_buff *skb)
 	return get_seq_h(carl9170_get_hdr(skb));
 }
 
-static inline u16 get_tid_h(struct ieee80211_hdr *hdr)
-{
-	return (ieee80211_get_qos_ctl(hdr))[0] & IEEE80211_QOS_CTL_TID_MASK;
-}
-
 static inline u16 carl9170_get_tid(struct sk_buff *skb)
 {
-	return get_tid_h(carl9170_get_hdr(skb));
+	return ieee80211_get_tid(carl9170_get_hdr(skb));
 }
 
 static inline struct ieee80211_vif *
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 6b8446ff48c8..88444fe6d1c6 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -394,7 +394,7 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
 	if (unlikely(!sta))
 		goto out_rcu;
 
-	tid = get_tid_h(hdr);
+	tid = ieee80211_get_tid(hdr);
 
 	sta_info = (void *) sta->drv_priv;
 	tid_info = rcu_dereference(sta_info->agg[tid]);
-- 
2.27.0

