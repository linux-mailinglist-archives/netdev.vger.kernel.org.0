Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3E3FF078
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfKPQFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:05:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729798AbfKPPvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:51:14 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F63C20885;
        Sat, 16 Nov 2019 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919473;
        bh=wucw8pbi4C/AdKmqf6xlB6tbRdCrEUwkZjVsOm3WrJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2i+VbaT+071ViIGv9VfsqR7tSohYebtGJ17GQjofH9DBogOuCkzVhJk584wswVFlP
         BKS2F3dKbkUJlP4BsQNMBNlPpwZgp1ar1N9vJfpaUfHvXrV1LEsaUbuo+YupNgbn/t
         uQoNBDtludabH4iwphkZuJsGbAfENv4A+wyzdFcg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 07/99] brcmsmac: AP mode: update beacon when TIM changes
Date:   Sat, 16 Nov 2019 10:49:30 -0500
Message-Id: <20191116155103.10971-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>

[ Upstream commit 2258ee58baa554609a3cc3996276e4276f537b6d ]

Beacons are not updated to reflect TIM changes. This is not compliant with
power-saving client stations as the beacons do not have valid TIM and can
cause the network to stall at random occasions and to have highly variable
latencies.
Fix it by updating beacon templates on mac80211 set_tim callback.

Addresses an issue described in:
https://marc.info/?i=20180911163534.21312d08%20()%20manjaro

Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c | 26 +++++++++++++++++++
 .../broadcom/brcm80211/brcmsmac/main.h        |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index 7c2a9a9bc372c..a620b2f6c7c4c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -502,6 +502,7 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_bh(&wl->lock);
+	wl->wlc->vif = vif;
 	wl->mute_tx = false;
 	brcms_c_mute(wl->wlc, false);
 	if (vif->type == NL80211_IFTYPE_STATION)
@@ -519,6 +520,11 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 static void
 brcms_ops_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
+	struct brcms_info *wl = hw->priv;
+
+	spin_lock_bh(&wl->lock);
+	wl->wlc->vif = NULL;
+	spin_unlock_bh(&wl->lock);
 }
 
 static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
@@ -937,6 +943,25 @@ static void brcms_ops_set_tsf(struct ieee80211_hw *hw,
 	spin_unlock_bh(&wl->lock);
 }
 
+static int brcms_ops_beacon_set_tim(struct ieee80211_hw *hw,
+				 struct ieee80211_sta *sta, bool set)
+{
+	struct brcms_info *wl = hw->priv;
+	struct sk_buff *beacon = NULL;
+	u16 tim_offset = 0;
+
+	spin_lock_bh(&wl->lock);
+	if (wl->wlc->vif)
+		beacon = ieee80211_beacon_get_tim(hw, wl->wlc->vif,
+						  &tim_offset, NULL);
+	if (beacon)
+		brcms_c_set_new_beacon(wl->wlc, beacon, tim_offset,
+				       wl->wlc->vif->bss_conf.dtim_period);
+	spin_unlock_bh(&wl->lock);
+
+	return 0;
+}
+
 static const struct ieee80211_ops brcms_ops = {
 	.tx = brcms_ops_tx,
 	.start = brcms_ops_start,
@@ -955,6 +980,7 @@ static const struct ieee80211_ops brcms_ops = {
 	.flush = brcms_ops_flush,
 	.get_tsf = brcms_ops_get_tsf,
 	.set_tsf = brcms_ops_set_tsf,
+	.set_tim = brcms_ops_beacon_set_tim,
 };
 
 void brcms_dpc(unsigned long data)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
index c4d135cff04ad..9f76b880814e8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
@@ -563,6 +563,7 @@ struct brcms_c_info {
 
 	struct wiphy *wiphy;
 	struct scb pri_scb;
+	struct ieee80211_vif *vif;
 
 	struct sk_buff *beacon;
 	u16 beacon_tim_offset;
-- 
2.20.1

