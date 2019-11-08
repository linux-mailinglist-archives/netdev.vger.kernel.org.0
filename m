Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5702F4B09
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390875AbfKHMN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:13:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732549AbfKHLiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EB1821D7E;
        Fri,  8 Nov 2019 11:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213103;
        bh=dD/bHB9IMDtRfXZwt5TsNRbb32hxDd5JIvgnXY4MEV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8QydOALOmVmevHXYH7osadr9Ddvwt5gkC7vrJze9B2jkuteA7BFDEauISGEI32nN
         rPK80C32Zum/DzPDMsMOn5KpnSrood0lVlB11HriqDQ+XLFP4PbvQjQsiNVGwip/UT
         Q0pg/pM1RVx8PulBIY6cUsJZZqw1Di+PuRRbWMYA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 027/205] wil6210: prevent usage of tx ring 0 for eDMA
Date:   Fri,  8 Nov 2019 06:34:54 -0500
Message-Id: <20191108113752.12502-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maya Erez <merez@codeaurora.org>

[ Upstream commit df2b53884a5a454bf441ca78e5b57307262c73f4 ]

In enhanced DMA ring 0 is used for RX ring, hence TX ring 0
is an unused element in ring_tx and ring2cid_tid arrays.
Initialize ring2cid_tid CID to WIL6210_MAX_CID to prevent a false
match of CID 0.
Go over the ring_tx and ring2cid_tid from wil_get_min_tx_ring_id
and on to prevent access to index 0 in eDMA.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 7 +++++--
 drivers/net/wireless/ath/wil6210/txrx.c | 6 ++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index d186b6886c6bf..920cb233f4db7 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -223,6 +223,7 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 	struct net_device *ndev = vif_to_ndev(vif);
 	struct wireless_dev *wdev = vif_to_wdev(vif);
 	struct wil_sta_info *sta = &wil->sta[cid];
+	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
 	might_sleep();
 	wil_dbg_misc(wil, "disconnect_cid: CID %d, MID %d, status %d\n",
@@ -273,7 +274,7 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 	memset(sta->tid_crypto_rx, 0, sizeof(sta->tid_crypto_rx));
 	memset(&sta->group_crypto_rx, 0, sizeof(sta->group_crypto_rx));
 	/* release vrings */
-	for (i = 0; i < ARRAY_SIZE(wil->ring_tx); i++) {
+	for (i = min_ring_id; i < ARRAY_SIZE(wil->ring_tx); i++) {
 		if (wil->ring2cid_tid[i][0] == cid)
 			wil_ring_fini_tx(wil, i);
 	}
@@ -604,8 +605,10 @@ int wil_priv_init(struct wil6210_priv *wil)
 		wil->sta[i].mid = U8_MAX;
 	}
 
-	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++)
+	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
 		spin_lock_init(&wil->ring_tx_data[i].lock);
+		wil->ring2cid_tid[i][0] = WIL6210_MAX_CID;
+	}
 
 	mutex_init(&wil->mutex);
 	mutex_init(&wil->vif_mutex);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 25a65ca424c84..73cdf54521f9b 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -77,8 +77,9 @@ bool wil_is_tx_idle(struct wil6210_priv *wil)
 {
 	int i;
 	unsigned long data_comp_to;
+	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
-	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+	for (i = min_ring_id; i < WIL6210_MAX_TX_RINGS; i++) {
 		struct wil_ring *vring = &wil->ring_tx[i];
 		int vring_index = vring - wil->ring_tx;
 		struct wil_ring_tx_data *txdata =
@@ -1945,6 +1946,7 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 					   bool check_stop)
 {
 	int i;
+	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
 	if (unlikely(!vif))
 		return;
@@ -1977,7 +1979,7 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 		return;
 
 	/* check wake */
-	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+	for (i = min_ring_id; i < WIL6210_MAX_TX_RINGS; i++) {
 		struct wil_ring *cur_ring = &wil->ring_tx[i];
 		struct wil_ring_tx_data  *txdata = &wil->ring_tx_data[i];
 
-- 
2.20.1

