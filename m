Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DA2F4833
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391508AbfKHLzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:55:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391228AbfKHLqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C05322084D;
        Fri,  8 Nov 2019 11:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213559;
        bh=51B5i7ZSZGGTkvJ7fYCTtynCDM1daTOX1raD80Vc/BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UV+/iMU291xBx1fh4yaWwIsFY0fYPd7Y3S9gPccuX6NRqMxc/GcFi8g6pCgVq2cCK
         nNgNODhDbq7XkIQL30yaWhlkZG7US7Bv4zmPSVhDL7+02E/SWNoAGqstHsysZxlvwj
         kLK/lEmFFgVHBqr245zZPaVgJ5HVa8D3XrXEUk7o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/64] ath9k: fix tx99 with monitor mode interface
Date:   Fri,  8 Nov 2019 06:44:49 -0500
Message-Id: <20191108114545.15351-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d9c52fd17cb483bd8a470398afcb79f86c1b77c8 ]

Tx99 is typically configured via a monitor mode interface, which does
not get added to the driver as a vif. Since the code currently expects
a configured virtual interface for tx99, enabling tx99 via debugfs fails.
Since the vif is not needed anyway, remove all checks for it.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
[kvalo@codeaurora.org: s/CPTCFG/CONFIG/]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 -
 drivers/net/wireless/ath/ath9k/main.c  | 12 +++---------
 drivers/net/wireless/ath/ath9k/tx99.c  |  9 ---------
 drivers/net/wireless/ath/ath9k/xmit.c  |  2 +-
 4 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7bda18c61eb6e..51e878a9d5211 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1033,7 +1033,6 @@ struct ath_softc {
 
 	struct ath_spec_scan_priv spec_priv;
 
-	struct ieee80211_vif *tx99_vif;
 	struct sk_buff *tx99_skb;
 	bool tx99_state;
 	s16 tx99_power;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b868f02ced893..fbc34beee1580 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1249,15 +1249,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_node *an = &avp->mcast_node;
 
-	mutex_lock(&sc->mutex);
+	if (IS_ENABLED(CONFIG_ATH9K_TX99))
+		return -EOPNOTSUPP;
 
-	if (IS_ENABLED(CONFIG_ATH9K_TX99)) {
-		if (sc->cur_chan->nvifs >= 1) {
-			mutex_unlock(&sc->mutex);
-			return -EOPNOTSUPP;
-		}
-		sc->tx99_vif = vif;
-	}
+	mutex_lock(&sc->mutex);
 
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
 	sc->cur_chan->nvifs++;
@@ -1340,7 +1335,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath9k_p2p_remove_vif(sc, vif);
 
 	sc->cur_chan->nvifs--;
-	sc->tx99_vif = NULL;
 	if (!ath9k_is_chanctx_enabled())
 		list_del(&avp->list);
 
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index 8e9480cc33e15..0cb5b2a873be8 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -54,12 +54,6 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info;
 	struct sk_buff *skb;
-	struct ath_vif *avp;
-
-	if (!sc->tx99_vif)
-		return NULL;
-
-	avp = (struct ath_vif *)sc->tx99_vif->drv_priv;
 
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb)
@@ -77,14 +71,11 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
 	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
 
-	hdr->seq_ctrl |= cpu_to_le16(avp->seq_no);
-
 	tx_info = IEEE80211_SKB_CB(skb);
 	memset(tx_info, 0, sizeof(*tx_info));
 	rate = &tx_info->control.rates[0];
 	tx_info->band = sc->cur_chan->chandef.chan->band;
 	tx_info->flags = IEEE80211_TX_CTL_NO_ACK;
-	tx_info->control.vif = sc->tx99_vif;
 	rate->count = 1;
 	if (ah->curchan && IS_CHAN_HT(ah->curchan)) {
 		rate->flags |= IEEE80211_TX_RC_MCS;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 0ef27d99bef33..2c35819f65426 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2970,7 +2970,7 @@ int ath9k_tx99_send(struct ath_softc *sc, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	ath_set_rates(sc->tx99_vif, NULL, bf);
+	ath_set_rates(NULL, NULL, bf);
 
 	ath9k_hw_set_desc_link(sc->sc_ah, bf->bf_desc, bf->bf_daddr);
 	ath9k_hw_tx99_start(sc->sc_ah, txctl->txq->axq_qnum);
-- 
2.20.1

