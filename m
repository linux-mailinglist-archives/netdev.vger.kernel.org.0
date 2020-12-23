Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE9F2E15EF
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731355AbgLWCze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:55:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729157AbgLWCVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E526022A83;
        Wed, 23 Dec 2020 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690019;
        bh=QYRAE2X+HHZqjjCwgB3WBYTMKTi+/y4nGivXKqzuziE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXK0Akfmg084XlbK6qFzXmVqLk/fwiz8K7qAl76mSCR9fOIY+QSg3UV5zWJWXyOmA
         gbFOAx0I7HxI281mHnG6efsDCBdpKZdcvZT+WcNEXuUZPSQzZ5dnNp2eVOQ8ctf0ea
         rZmY4nTh7TxjgmtR8yV6I4zHjaKcqoG2kQhGtm+ApWy/sLsmloqDZOpM1z4Zu6+6g3
         1vvRhbAif1mAJV8Uo1Y1VMuwZGbZb62N3UFRXRuUavX6yPfMEKsrNhkFwQCs4hXIdX
         HZmSzX+XRxwnPtHaLnkE00+o6hWUmvrqr0hh94hGi+pbYeR7tq2eXxYFakU83q8w3Y
         ZYcpFfes7Py8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 097/130] rtlwifi: rtl8192de: fix ofdm power compensation
Date:   Tue, 22 Dec 2020 21:17:40 -0500
Message-Id: <20201223021813.2791612-97-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 3f79e541593fecc2a90687eb7162e15a499caa33 ]

ofdm_index[] is used to indicate how many power compensation is needed to
current thermal value. For internal PA module or 2.4G band, the min_index
is different from other cases.

This issue originally is reported by Dan. He found the size of ofdm_index[]
is 2, but access index 'i' may be equal to 2 if 'rf' is 2 in case of
'is2t'.

In fact, the chunk of code is added to wrong place, so move it back to
proper place, and then power compensation and buffer overflow are fixed.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201207031903.7599-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c
index 71f3b6b5d7bd9..5baa1b127fff0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c
@@ -986,18 +986,19 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 			 rtlpriv->dm.cck_index);
 	}
 	for (i = 0; i < rf; i++) {
-		if (ofdm_index[i] > OFDM_TABLE_SIZE_92D - 1)
+		if (ofdm_index[i] > OFDM_TABLE_SIZE_92D - 1) {
 			ofdm_index[i] = OFDM_TABLE_SIZE_92D - 1;
-		else if (ofdm_index[i] < ofdm_min_index)
+		} else if (internal_pa ||
+			   rtlhal->current_bandtype == BAND_ON_2_4G) {
+			if (ofdm_index[i] < ofdm_min_index_internal_pa)
+				ofdm_index[i] = ofdm_min_index_internal_pa;
+		} else if (ofdm_index[i] < ofdm_min_index) {
 			ofdm_index[i] = ofdm_min_index;
+		}
 	}
 	if (rtlhal->current_bandtype == BAND_ON_2_4G) {
 		if (cck_index > CCK_TABLE_SIZE - 1) {
 			cck_index = CCK_TABLE_SIZE - 1;
-		} else if (internal_pa ||
-			   rtlhal->current_bandtype == BAND_ON_2_4G) {
-			if (ofdm_index[i] < ofdm_min_index_internal_pa)
-				ofdm_index[i] = ofdm_min_index_internal_pa;
 		} else if (cck_index < 0) {
 			cck_index = 0;
 		}
-- 
2.27.0

