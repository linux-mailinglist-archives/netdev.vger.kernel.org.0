Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E61844A0A3
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241810AbhKIBEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:04:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241662AbhKIBDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:03:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B92A361390;
        Tue,  9 Nov 2021 01:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419661;
        bh=XufEztxeItGTehTrSkdJrWqgyzeYZCom6ctehxWgBGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxtjGfXzH2w1ouqVex0+QHG//ESnbZLAer7UrfcDDpvlwg4IaT3BryUwfM9NkzWyd
         zGXpNvpf9vxJjf6hSnQFBLNsoqoeQGM5pbwVR/yBiA9y8rkLpmomR+DMX8w9nEM4Hg
         1xmU1T0fWuxJWRqLptYtebSR4m31tvMrAz86zGdxx+kIVsxnnu9j49rft7+lXSJuW9
         4pZ2Wlal3rKq5S7Gd53Bsqd4Lj3nlOtKLKhM4p6sT573zABsshyO3NopDabreMVZdD
         j69NekDlV96f/am7Fvp5M0lNbA69NLilEBTTh0nWbW2G2b0oq5/SVETe7sqAq6878B
         6dKcmBmegZeAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alagu Sankar <alagusankar@silex-india.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Fabio Estevam <festevam@denx.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 036/146] ath10k: high latency fixes for beacon buffer
Date:   Mon,  8 Nov 2021 12:43:03 -0500
Message-Id: <20211108174453.1187052-36-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

[ Upstream commit e263bdab9c0e8025fb7f41f153709a9cda51f6b6 ]

Beacon buffer for high latency devices does not use DMA. other similar
buffer allocation methods in the driver have already been modified for
high latency path. Fix the beacon buffer allocation left out in the
earlier high latency changes.

Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
[fabio: adapt it to use ar->bus_param.dev_type ]
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210818232627.2040121-1-festevam@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 31 ++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c272b290fa73d..7ca68c81d9b61 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -993,8 +993,12 @@ static void ath10k_mac_vif_beacon_cleanup(struct ath10k_vif *arvif)
 	ath10k_mac_vif_beacon_free(arvif);
 
 	if (arvif->beacon_buf) {
-		dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
-				  arvif->beacon_buf, arvif->beacon_paddr);
+		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL)
+			kfree(arvif->beacon_buf);
+		else
+			dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
+					  arvif->beacon_buf,
+					  arvif->beacon_paddr);
 		arvif->beacon_buf = NULL;
 	}
 }
@@ -5576,10 +5580,17 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_ADHOC ||
 	    vif->type == NL80211_IFTYPE_MESH_POINT ||
 	    vif->type == NL80211_IFTYPE_AP) {
-		arvif->beacon_buf = dma_alloc_coherent(ar->dev,
-						       IEEE80211_MAX_FRAME_LEN,
-						       &arvif->beacon_paddr,
-						       GFP_ATOMIC);
+		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL) {
+			arvif->beacon_buf = kmalloc(IEEE80211_MAX_FRAME_LEN,
+						    GFP_KERNEL);
+			arvif->beacon_paddr = (dma_addr_t)arvif->beacon_buf;
+		} else {
+			arvif->beacon_buf =
+				dma_alloc_coherent(ar->dev,
+						   IEEE80211_MAX_FRAME_LEN,
+						   &arvif->beacon_paddr,
+						   GFP_ATOMIC);
+		}
 		if (!arvif->beacon_buf) {
 			ret = -ENOMEM;
 			ath10k_warn(ar, "failed to allocate beacon buffer: %d\n",
@@ -5794,8 +5805,12 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 err:
 	if (arvif->beacon_buf) {
-		dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
-				  arvif->beacon_buf, arvif->beacon_paddr);
+		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL)
+			kfree(arvif->beacon_buf);
+		else
+			dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
+					  arvif->beacon_buf,
+					  arvif->beacon_paddr);
 		arvif->beacon_buf = NULL;
 	}
 
-- 
2.33.0

