Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0DE42F725
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 17:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbhJOPrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 11:47:39 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:55796
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241000AbhJOPri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 11:47:38 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 04C033FFE2;
        Fri, 15 Oct 2021 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634312731;
        bh=q+4cmHqckaQN4b4ZCrwGPFRF8idW9plChE4guiMleiU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=u6Lau5Vyk4CpnT8Xo+XbOROx3DyLrgYdbZ46qMf4VCTG3qrYt4Gvl/sPTxpRxsfS7
         XIu0GCz7ff4u8ctbgDlJNIXpaKhPW0IYlMNUdyL0Kb2qqnP+5Y+JYuqJh4GDT1KcMi
         cNFZLmJt8BpybXDSF7CEDZQmpgkC5c0FA48tLLJG7O1GlQrBwJgpzLjdE6qY5vPy8J
         r7ix4AQqzLzYVH9VN+r2cRiCrvpBxZFVVjSuTVCBtsbLkHdqy8eJytuucWm1QkMa2n
         hMRmTrj0f9ZBbxvchSklN202vkiBrPH64mEbq8yi8jTSrgCWbeUzpwFepxm5Cv2VVN
         3Sgo8V9JXajnA==
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] rtw89: Fix potential dereference of the null pointer sta
Date:   Fri, 15 Oct 2021 16:45:30 +0100
Message-Id: <20211015154530.34356-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer rtwsta is dereferencing pointer sta before sta is
being null checked, so there is a potential null pointer deference
issue that may occur. Fix this by only assigning rtwsta after sta
has been null checked. Add in a null pointer check on rtwsta before
dereferencing it too.

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Addresses-Coverity: ("Dereference before null check")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtw89/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 06fb6e5b1b37..26f52a25f545 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1534,9 +1534,14 @@ static bool rtw89_core_txq_agg_wait(struct rtw89_dev *rtwdev,
 {
 	struct rtw89_txq *rtwtxq = (struct rtw89_txq *)txq->drv_priv;
 	struct ieee80211_sta *sta = txq->sta;
-	struct rtw89_sta *rtwsta = (struct rtw89_sta *)sta->drv_priv;
+	struct rtw89_sta *rtwsta;
 
-	if (!sta || rtwsta->max_agg_wait <= 0)
+	if (!sta)
+		return false;
+	rtwsta = (struct rtw89_sta *)sta->drv_priv;
+	if (!rtwsta)
+		return false;
+	if (rtwsta->max_agg_wait <= 0)
 		return false;
 
 	if (rtwdev->stats.tx_tfc_lv <= RTW89_TFC_MID)
-- 
2.32.0

