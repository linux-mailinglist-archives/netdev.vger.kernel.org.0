Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A45303AE1
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 11:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404679AbhAZKzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 05:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392020AbhAZKzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 05:55:03 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C6BC061573;
        Tue, 26 Jan 2021 02:54:22 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l4LzE-00BsQd-2V; Tue, 26 Jan 2021 11:54:16 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ilan.peer@intel.com, Johannes Berg <johannes.berg@intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] staging: rtl8723bs: fix wireless regulatory API misuse
Date:   Tue, 26 Jan 2021 11:54:09 +0100
Message-Id: <20210126115409.d5fd6f8fe042.Ib5823a6feb2e2aa01ca1a565d2505367f38ad246@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This code ends up calling wiphy_apply_custom_regulatory(), for which
we document that it should be called before wiphy_register(). This
driver doesn't do that, but calls it from ndo_open() with the RTNL
held, which caused deadlocks.

Since the driver just registers static regdomain data and then the
notifier applies the channel changes if any, there's no reason for
it to call this in ndo_open(), move it earlier to fix the deadlock.

Reported-and-tested-by: Hans de Goede <hdegoede@redhat.com>
Fixes: 51d62f2f2c50 ("cfg80211: Save the regulatory domain with a lock")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Greg, can you take this for 5.11 please? Or if you prefer, since the
patch that exposed this and broke the driver went through my tree, I
can take it as well.
---
 drivers/staging/rtl8723bs/include/rtw_wifi_regd.h |  6 +++---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |  6 +++---
 drivers/staging/rtl8723bs/os_dep/wifi_regd.c      | 10 +++-------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8723bs/include/rtw_wifi_regd.h b/drivers/staging/rtl8723bs/include/rtw_wifi_regd.h
index ab5a8627d371..f798b0c744a4 100644
--- a/drivers/staging/rtl8723bs/include/rtw_wifi_regd.h
+++ b/drivers/staging/rtl8723bs/include/rtw_wifi_regd.h
@@ -20,9 +20,9 @@ enum country_code_type_t {
 	COUNTRY_CODE_MAX
 };
 
-int rtw_regd_init(struct adapter *padapter,
-	void (*reg_notifier)(struct wiphy *wiphy,
-		struct regulatory_request *request));
+void rtw_regd_init(struct wiphy *wiphy,
+		   void (*reg_notifier)(struct wiphy *wiphy,
+					struct regulatory_request *request));
 void rtw_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
 
 
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index bf1417236161..11032316c53d 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -3211,9 +3211,6 @@ void rtw_cfg80211_init_wiphy(struct adapter *padapter)
 			rtw_cfg80211_init_ht_capab(&bands->ht_cap, NL80211_BAND_2GHZ, rf_type);
 	}
 
-	/* init regulary domain */
-	rtw_regd_init(padapter, rtw_reg_notifier);
-
 	/* copy mac_addr to wiphy */
 	memcpy(wiphy->perm_addr, padapter->eeprompriv.mac_addr, ETH_ALEN);
 
@@ -3328,6 +3325,9 @@ int rtw_wdev_alloc(struct adapter *padapter, struct device *dev)
 	*((struct adapter **)wiphy_priv(wiphy)) = padapter;
 	rtw_cfg80211_preinit_wiphy(padapter, wiphy);
 
+	/* init regulary domain */
+	rtw_regd_init(wiphy, rtw_reg_notifier);
+
 	ret = wiphy_register(wiphy);
 	if (ret < 0) {
 		DBG_8192C("Couldn't register wiphy device\n");
diff --git a/drivers/staging/rtl8723bs/os_dep/wifi_regd.c b/drivers/staging/rtl8723bs/os_dep/wifi_regd.c
index 578b9f734231..2833fc6901e6 100644
--- a/drivers/staging/rtl8723bs/os_dep/wifi_regd.c
+++ b/drivers/staging/rtl8723bs/os_dep/wifi_regd.c
@@ -139,15 +139,11 @@ static void _rtw_regd_init_wiphy(struct rtw_regulatory *reg,
 	_rtw_reg_apply_flags(wiphy);
 }
 
-int rtw_regd_init(struct adapter *padapter,
-		  void (*reg_notifier)(struct wiphy *wiphy,
-				       struct regulatory_request *request))
+void rtw_regd_init(struct wiphy *wiphy,
+		   void (*reg_notifier)(struct wiphy *wiphy,
+					struct regulatory_request *request))
 {
-	struct wiphy *wiphy = padapter->rtw_wdev->wiphy;
-
 	_rtw_regd_init_wiphy(NULL, wiphy, reg_notifier);
-
-	return 0;
 }
 
 void rtw_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
-- 
2.26.2

