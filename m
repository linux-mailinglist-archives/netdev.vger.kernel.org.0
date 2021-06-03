Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E68839A089
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 14:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhFCMId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 08:08:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36231 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhFCMIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 08:08:32 -0400
Received: from 1.general.mschiu77.us.vpn ([10.172.65.162] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <chris.chiu@canonical.com>)
        id 1lom7Y-0007iL-6k; Thu, 03 Jun 2021 12:06:45 +0000
From:   chris.chiu@canonical.com
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>
Subject: [PATCH v2 1/2] rtl8xxxu: unset the hw capability HAS_RATE_CONTROL
Date:   Thu,  3 Jun 2021 20:06:08 +0800
Message-Id: <20210603120609.58932-2-chris.chiu@canonical.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210603120609.58932-1-chris.chiu@canonical.com>
References: <20210603120609.58932-1-chris.chiu@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Chiu <chris.chiu@canonical.com>

Since AMPDU_AGGREGATION is set so packets will be handed to the
driver with a flag indicating A-MPDU aggregation and device should
be responsible for setting up and starting the TX aggregation with
the AMPDU_TX_START action. The TX aggregation is usually started by
the rate control algorithm so the HAS_RATE_CONTROL has to be unset
for the mac80211 to start BA session by ieee80211_start_tx_ba_session.

The realtek chips tx rate will still be handled by the rate adaptive
mechanism in the underlying firmware which is controlled by the
rate mask H2C command in the driver. Unset HAS_RATE_CONTROL cause
no change for the tx rate control and the TX BA session can be started
by the mac80211 default rate control mechanism.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
---

Changelog:
  v2:
   - Revise the commit message to desribe the purpose of the change
     in detail.

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 9ff09cf7eb62..4cf13d2f86b1 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6678,7 +6678,6 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	/*
 	 * The firmware handles rate control
 	 */
-	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
-- 
2.20.1

