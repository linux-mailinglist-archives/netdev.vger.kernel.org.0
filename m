Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419572DB29E
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbgLORbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:31:09 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:12901 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgLORbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:31:09 -0500
Received: from ironmsg07-lv.qualcomm.com (HELO ironmsg07-lv.qulacomm.com) ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 15 Dec 2020 09:30:29 -0800
X-QCInternal: smtphost
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg07-lv.qulacomm.com with ESMTP/TLS/AES256-SHA; 15 Dec 2020 09:30:27 -0800
X-QCInternal: smtphost
Received: from youghand-linux.qualcomm.com ([10.206.66.115])
  by ironmsg02-blr.qualcomm.com with ESMTP; 15 Dec 2020 23:00:24 +0530
Received: by youghand-linux.qualcomm.com (Postfix, from userid 2370257)
        id C911E20F17; Tue, 15 Dec 2020 23:00:23 +0530 (IST)
From:   Youghandhar Chintala <youghand@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        pillair@codeaurora.org,
        Youghandhar Chintala <youghand@codeaurora.org>
Subject: [PATCH 1/3] cfg80211: Add wiphy flag to trigger STA disconnect after hardware restart
Date:   Tue, 15 Dec 2020 23:00:21 +0530
Message-Id: <20201215173021.5884-1-youghand@codeaurora.org>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many wifi drivers (e.g. ath10k using qualcomm wifi chipsets)
support silent target hardware restart/recovery. Out of these
drivers which support target hw restart, certain chipsets
have the wifi mac sequence number addition for transmitted
frames done by the firmware. For such chipsets, a silent
target hardware restart breaks the continuity of the wifi
mac sequence number, since the wifi mac sequence number
restarts from 0 after the restart, which in-turn leads
to the peer access point dropping all the frames from device
until it receives the frame with the mac sequence which was
expected by the AP.

Add a wiphy flag for the driver to indicate that it needs a
trigger for STA disconnect after hardware restart.

Tested on ath10k using WCN3990, QCA6174.

Signed-off-by: Youghandhar Chintala <youghand@codeaurora.org>
---
 include/net/cfg80211.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ab249ca..7fba6f6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4311,6 +4311,9 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_HAS_STATIC_WEP: The device supports static WEP key installation
  *	before connection.
  * @WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK: The device supports bigger kek and kck keys
+ * @WIPHY_FLAG_STA_DISCONNECT_ON_HW_RESTART: The device needs a trigger to
+ *	disconnect STA after target hardware restart. This flag should be
+ *	exposed by drivers which support target recovery.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK		= BIT(0),
@@ -4337,6 +4340,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
 	WIPHY_FLAG_HAS_STATIC_WEP		= BIT(24),
+	WIPHY_FLAG_STA_DISCONNECT_ON_HW_RESTART	= BIT(25),
 };
 
 /**
-- 
2.7.4

