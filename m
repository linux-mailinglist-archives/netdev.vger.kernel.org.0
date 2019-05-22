Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD64326EFF
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388014AbfEVTxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731727AbfEVTZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:25:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA84206BA;
        Wed, 22 May 2019 19:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553145;
        bh=OaeEuKz2a8CPYvmFlIpHhe1xs9EfNbJprQqroeeBK9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8gDKpBeGdCezHKBzwtxXlhVwu7scHiEFEKKPpzh8fufoRWDEmSKQN4u8FgHsFIao
         j3Ku9baO31EH0/4t7X97DIQj4BtzzgNsIsxqa9l1WjEVbnBymnkEBwQ89RwPswN/wP
         /r0a6vJoqIcuUgb4rQ/ORKO8zS9nbvWQ6NQsGwLg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 075/317] rsi: Fix NULL pointer dereference in kmalloc
Date:   Wed, 22 May 2019 15:19:36 -0400
Message-Id: <20190522192338.23715-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit d5414c2355b20ea8201156d2e874265f1cb0d775 ]

kmalloc can fail in rsi_register_rates_channels but memcpy still attempts
to write to channels. The patch replaces these calls with kmemdup and
passes the error upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 30 ++++++++++++---------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index e56fc83faf0ef..2f604e8bc991b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -188,27 +188,27 @@ bool rsi_is_cipher_wep(struct rsi_common *common)
  * @adapter: Pointer to the adapter structure.
  * @band: Operating band to be set.
  *
- * Return: None.
+ * Return: int - 0 on success, negative error on failure.
  */
-static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
+static int rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 {
 	struct ieee80211_supported_band *sbands = &adapter->sbands[band];
 	void *channels = NULL;
 
 	if (band == NL80211_BAND_2GHZ) {
-		channels = kmalloc(sizeof(rsi_2ghz_channels), GFP_KERNEL);
-		memcpy(channels,
-		       rsi_2ghz_channels,
-		       sizeof(rsi_2ghz_channels));
+		channels = kmemdup(rsi_2ghz_channels, sizeof(rsi_2ghz_channels),
+				   GFP_KERNEL);
+		if (!channels)
+			return -ENOMEM;
 		sbands->band = NL80211_BAND_2GHZ;
 		sbands->n_channels = ARRAY_SIZE(rsi_2ghz_channels);
 		sbands->bitrates = rsi_rates;
 		sbands->n_bitrates = ARRAY_SIZE(rsi_rates);
 	} else {
-		channels = kmalloc(sizeof(rsi_5ghz_channels), GFP_KERNEL);
-		memcpy(channels,
-		       rsi_5ghz_channels,
-		       sizeof(rsi_5ghz_channels));
+		channels = kmemdup(rsi_5ghz_channels, sizeof(rsi_5ghz_channels),
+				   GFP_KERNEL);
+		if (!channels)
+			return -ENOMEM;
 		sbands->band = NL80211_BAND_5GHZ;
 		sbands->n_channels = ARRAY_SIZE(rsi_5ghz_channels);
 		sbands->bitrates = &rsi_rates[4];
@@ -227,6 +227,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 	sbands->ht_cap.mcs.rx_mask[0] = 0xff;
 	sbands->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 	/* sbands->ht_cap.mcs.rx_highest = 0x82; */
+	return 0;
 }
 
 /**
@@ -1985,11 +1986,16 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	wiphy->available_antennas_rx = 1;
 	wiphy->available_antennas_tx = 1;
 
-	rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);
+	status = rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);
+	if (status)
+		return status;
 	wiphy->bands[NL80211_BAND_2GHZ] =
 		&adapter->sbands[NL80211_BAND_2GHZ];
 	if (common->num_supp_bands > 1) {
-		rsi_register_rates_channels(adapter, NL80211_BAND_5GHZ);
+		status = rsi_register_rates_channels(adapter,
+						     NL80211_BAND_5GHZ);
+		if (status)
+			return status;
 		wiphy->bands[NL80211_BAND_5GHZ] =
 			&adapter->sbands[NL80211_BAND_5GHZ];
 	}
-- 
2.20.1

