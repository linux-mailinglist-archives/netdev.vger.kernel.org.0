Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52F9FF3C7
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbfKPQ1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:27:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbfKPPlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:35 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E1BD2075C;
        Sat, 16 Nov 2019 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918894;
        bh=/LdlDunYvEq9PMi5iXWMTlTTC/OHVe6NjuwqYWeQ3qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDyEJV8wtMMpx9qoWsVU+bdx5sDf7mqmdTn3IHZKfAEXaWEmltoeqf0ekSVZnxNdS
         NkHRKSeQtT0ZuU4POH9p64sWZq7deSFeXZL4aFREf3w+6IQtKQoBCHly81MkXLgbQh
         osnL8jeMOpvNqCbkELmjJfqPO32FVQzrYVLy1h/M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 019/237] ath10k: set probe request oui during driver start
Date:   Sat, 16 Nov 2019 10:37:34 -0500
Message-Id: <20191116154113.7417-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit f1157695c527d4ee949ac83f743f80107751a70c ]

Currently the wmi command for setting probe request
oui, needed for mac randomization, is sent during
the mac register. At this time, during the driver
init the wmi has already been detached. This can
cause unexpected behavior since the firmware is
already down and the wmi has been detached.

Send the wmi command for setting probe request
oui during the driver start. This will make sure
that the firmware is started and wmi is initialized
before we send this command.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Fixes: 60e1d0fb290197fe505dff6e4e3b7e4d258dbf60
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1419f9d1505fe..97e6911811176 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4685,6 +4685,14 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_core_stop;
 	}
 
+	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
+		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
+		if (ret) {
+			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
+			goto err_core_stop;
+		}
+	}
+
 	if (test_bit(WMI_SERVICE_ADAPTIVE_OCS, ar->wmi.svc_map)) {
 		ret = ath10k_wmi_adaptive_qcs(ar, true);
 		if (ret) {
@@ -8549,12 +8557,6 @@ int ath10k_mac_register(struct ath10k *ar)
 	}
 
 	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
-		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
-		if (ret) {
-			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
-			goto err_dfs_detector_exit;
-		}
-
 		ar->hw->wiphy->features |=
 			NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 	}
-- 
2.20.1

