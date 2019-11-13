Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7574CFA0DA
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfKMBxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbfKMBxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27F1A222D3;
        Wed, 13 Nov 2019 01:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609983;
        bh=2KUh2tDx0koScgjBuyBrWUfhSOsfanBbT7qewGFoA70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3pI4iHJ1sGwb7pDZx2UdsHzJ4ifmeHdgpOkrGnxKGNzC3RW/1DYCqBVqyKI5oXsf
         wG69r4iA6WaKBjlvxI5OrRsDkxHSA27d0iNCFJ2fRXr3XYvdV4AE9+mgTMoatQ2Ziw
         2qzUMLJ14882hDA18OplJLNF4dHXLoznm31LE9nk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 102/209] qtnfmac: request userspace to do OBSS scanning if FW can not
Date:   Tue, 12 Nov 2019 20:48:38 -0500
Message-Id: <20191113015025.9685-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

[ Upstream commit 92246b126ebf66ab1fec9d631df78d7c675b66db ]

In case firmware reports that it can not do OBSS scanning for 40MHz
2.4GHz channels itself, tell userpsace to do that instead by setting
NL80211_FEATURE_NEED_OBSS_SCAN flag.

Signed-off-by: Igor mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 3 +++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 4aa332f4646b1..1519d986b74a4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1109,6 +1109,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR)
 		wiphy->features |= NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 
+	if (!(hw_info->hw_capab & QLINK_HW_CAPAB_OBSS_SCAN))
+		wiphy->features |= NL80211_FEATURE_NEED_OBSS_SCAN;
+
 #ifdef CONFIG_PM
 	if (macinfo->wowlan)
 		wiphy->wowlan = macinfo->wowlan;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 99d37e3efba63..c5ae4ea9a47a9 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -71,6 +71,7 @@ struct qlink_msg_header {
  * @QLINK_HW_CAPAB_DFS_OFFLOAD: device implements DFS offload functionality
  * @QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR: device supports MAC Address
  *	Randomization in probe requests.
+ * @QLINK_HW_CAPAB_OBSS_SCAN: device can perform OBSS scanning.
  */
 enum qlink_hw_capab {
 	QLINK_HW_CAPAB_REG_UPDATE		= BIT(0),
@@ -78,6 +79,7 @@ enum qlink_hw_capab {
 	QLINK_HW_CAPAB_DFS_OFFLOAD		= BIT(2),
 	QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR	= BIT(3),
 	QLINK_HW_CAPAB_PWR_MGMT			= BIT(4),
+	QLINK_HW_CAPAB_OBSS_SCAN		= BIT(5),
 };
 
 enum qlink_iface_type {
-- 
2.20.1

