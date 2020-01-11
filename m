Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA0E137C8A
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 10:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgAKJIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 04:08:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47168 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728558AbgAKJId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 04:08:33 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iqCkq-0008P9-Ea; Sat, 11 Jan 2020 09:08:24 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        John Crispin <john@phrozen.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath11k: avoid null pointer dereference when pointer band is null
Date:   Sat, 11 Jan 2020 09:08:24 +0000
Message-Id: <20200111090824.9999-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the unlikely event that cap->supported_bands has neither
WMI_HOST_WLAN_2G_CAP set or WMI_HOST_WLAN_5G_CAP set then pointer
band is null and a null dereference occurs when assigning
band->n_iftype_data.  Move the assignment to the if blocks to
avoid this.  Cleans up static analysis warnings.

Addresses-Coverity: ("Explicit null dereference")
Fixes: 9f056ed8ee01 ("ath11k: add HE support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 556eef9881a7..4a364cfe37ed 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3520,8 +3520,8 @@ static int ath11k_mac_copy_he_cap(struct ath11k *ar,
 static void ath11k_mac_setup_he_cap(struct ath11k *ar,
 				    struct ath11k_pdev_cap *cap)
 {
-	struct ieee80211_supported_band *band = NULL;
-	int count = 0;
+	struct ieee80211_supported_band *band;
+	int count;
 
 	if (cap->supported_bands & WMI_HOST_WLAN_2G_CAP) {
 		count = ath11k_mac_copy_he_cap(ar, cap,
@@ -3529,6 +3529,7 @@ static void ath11k_mac_setup_he_cap(struct ath11k *ar,
 					       NL80211_BAND_2GHZ);
 		band = &ar->mac.sbands[NL80211_BAND_2GHZ];
 		band->iftype_data = ar->mac.iftype[NL80211_BAND_2GHZ];
+		band->n_iftype_data = count;
 	}
 
 	if (cap->supported_bands & WMI_HOST_WLAN_5G_CAP) {
@@ -3537,9 +3538,8 @@ static void ath11k_mac_setup_he_cap(struct ath11k *ar,
 					       NL80211_BAND_5GHZ);
 		band = &ar->mac.sbands[NL80211_BAND_5GHZ];
 		band->iftype_data = ar->mac.iftype[NL80211_BAND_5GHZ];
+		band->n_iftype_data = count;
 	}
-
-	band->n_iftype_data = count;
 }
 
 static int __ath11k_set_antenna(struct ath11k *ar, u32 tx_ant, u32 rx_ant)
-- 
2.24.0

