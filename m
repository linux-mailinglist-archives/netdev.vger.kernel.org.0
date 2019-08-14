Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6DE8C613
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfHNCMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727890AbfHNCMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B78CD2085A;
        Wed, 14 Aug 2019 02:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748750;
        bh=IrEUGAr88LfF3a3ZzDjfIOiDjKCzLnV9v1Ei76PBG1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCb6UVqZMwS2mLyKmJzLlIgzEdri+1HqkYe2T7XSiVQOdhx7kR2xzPwRVjUezXVNd
         uULhxBL91IplQwl6n6yqJpizmgjTSRZ6h/8AB8x5Y9Z0zc7bjeHtZBEVp6r/LSAZMK
         P/IgfAoqHZnk2zrxZ34Syl0wCY50G/0c7/V/61Pg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 045/123] {nl,mac}80211: fix interface combinations on crypto controlled devices
Date:   Tue, 13 Aug 2019 22:09:29 -0400
Message-Id: <20190814021047.14828-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manikanta Pubbisetty <mpubbise@codeaurora.org>

[ Upstream commit e6f4051123fd33901e9655a675b22aefcdc5d277 ]

Commit 33d915d9e8ce ("{nl,mac}80211: allow 4addr AP operation on
crypto controlled devices") has introduced a change which allows
4addr operation on crypto controlled devices (ex: ath10k). This
change has inadvertently impacted the interface combinations logic
on such devices.

General rule is that software interfaces like AP/VLAN should not be
listed under supported interface combinations and should not be
considered during validation of these combinations; because of the
aforementioned change, AP/VLAN interfaces(if present) will be checked
against interfaces supported by the device and blocks valid interface
combinations.

Consider a case where an AP and AP/VLAN are up and running; when a
second AP device is brought up on the same physical device, this AP
will be checked against the AP/VLAN interface (which will not be
part of supported interface combinations of the device) and blocks
second AP to come up.

Add a new API cfg80211_iftype_allowed() to fix the problem, this
API works for all devices with/without SW crypto control.

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Fixes: 33d915d9e8ce ("{nl,mac}80211: allow 4addr AP operation on crypto controlled devices")
Link: https://lore.kernel.org/r/1563779690-9716-1-git-send-email-mpubbise@codeaurora.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 15 +++++++++++++++
 net/mac80211/util.c    |  7 +++----
 net/wireless/core.c    |  6 ++----
 net/wireless/nl80211.c |  4 +---
 net/wireless/util.c    | 27 +++++++++++++++++++++++++--
 5 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8fb5be3ca0ca8..8b13bd05befac 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7254,6 +7254,21 @@ void cfg80211_pmsr_complete(struct wireless_dev *wdev,
 			    struct cfg80211_pmsr_request *req,
 			    gfp_t gfp);
 
+/**
+ * cfg80211_iftype_allowed - check whether the interface can be allowed
+ * @wiphy: the wiphy
+ * @iftype: interface type
+ * @is_4addr: use_4addr flag, must be '0' when check_swif is '1'
+ * @check_swif: check iftype against software interfaces
+ *
+ * Check whether the interface is allowed to operate; additionally, this API
+ * can be used to check iftype against the software interfaces when
+ * check_swif is '1'.
+ */
+bool cfg80211_iftype_allowed(struct wiphy *wiphy, enum nl80211_iftype iftype,
+			     bool is_4addr, u8 check_swif);
+
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1b224fa27367f..ad1e58184c4e4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3796,9 +3796,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* Always allow software iftypes */
-	if (local->hw.wiphy->software_iftypes & BIT(iftype) ||
-	    (iftype == NL80211_IFTYPE_AP_VLAN &&
-	     local->hw.wiphy->flags & WIPHY_FLAG_4ADDR_AP)) {
+	if (cfg80211_iftype_allowed(local->hw.wiphy, iftype, 0, 1)) {
 		if (radar_detect)
 			return -EINVAL;
 		return 0;
@@ -3833,7 +3831,8 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 
 		if (sdata_iter == sdata ||
 		    !ieee80211_sdata_running(sdata_iter) ||
-		    local->hw.wiphy->software_iftypes & BIT(wdev_iter->iftype))
+		    cfg80211_iftype_allowed(local->hw.wiphy,
+					    wdev_iter->iftype, 0, 1))
 			continue;
 
 		params.iftype_num[wdev_iter->iftype]++;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 53ad3dbb76fe5..ed24a0b071c33 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1397,10 +1397,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		}
 		break;
 	case NETDEV_PRE_UP:
-		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)) &&
-		    !(wdev->iftype == NL80211_IFTYPE_AP_VLAN &&
-		      rdev->wiphy.flags & WIPHY_FLAG_4ADDR_AP &&
-		      wdev->use_4addr))
+		if (!cfg80211_iftype_allowed(wdev->wiphy, wdev->iftype,
+					     wdev->use_4addr, 0))
 			return notifier_from_errno(-EOPNOTSUPP);
 
 		if (rfkill_blocked(rdev->rfkill))
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 520d437aa8d15..88a1de9def115 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3481,9 +3481,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	}
 
-	if (!(rdev->wiphy.interface_modes & (1 << type)) &&
-	    !(type == NL80211_IFTYPE_AP_VLAN && params.use_4addr &&
-	      rdev->wiphy.flags & WIPHY_FLAG_4ADDR_AP))
+	if (!cfg80211_iftype_allowed(&rdev->wiphy, type, params.use_4addr, 0))
 		return -EOPNOTSUPP;
 
 	err = nl80211_parse_mon_options(rdev, type, info, &params);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 1c39d6a2e8501..d0e35b7b9e350 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1697,7 +1697,7 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 	for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
 		num_interfaces += params->iftype_num[iftype];
 		if (params->iftype_num[iftype] > 0 &&
-		    !(wiphy->software_iftypes & BIT(iftype)))
+		    !cfg80211_iftype_allowed(wiphy, iftype, 0, 1))
 			used_iftypes |= BIT(iftype);
 	}
 
@@ -1719,7 +1719,7 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 			return -ENOMEM;
 
 		for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
-			if (wiphy->software_iftypes & BIT(iftype))
+			if (cfg80211_iftype_allowed(wiphy, iftype, 0, 1))
 				continue;
 			for (j = 0; j < c->n_limits; j++) {
 				all_iftypes |= limits[j].types;
@@ -2072,3 +2072,26 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
 	return max_vht_nss;
 }
 EXPORT_SYMBOL(ieee80211_get_vht_max_nss);
+
+bool cfg80211_iftype_allowed(struct wiphy *wiphy, enum nl80211_iftype iftype,
+			     bool is_4addr, u8 check_swif)
+
+{
+	bool is_vlan = iftype == NL80211_IFTYPE_AP_VLAN;
+
+	switch (check_swif) {
+	case 0:
+		if (is_vlan && is_4addr)
+			return wiphy->flags & WIPHY_FLAG_4ADDR_AP;
+		return wiphy->interface_modes & BIT(iftype);
+	case 1:
+		if (!(wiphy->software_iftypes & BIT(iftype)) && is_vlan)
+			return wiphy->flags & WIPHY_FLAG_4ADDR_AP;
+		return wiphy->software_iftypes & BIT(iftype);
+	default:
+		break;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(cfg80211_iftype_allowed);
-- 
2.20.1

