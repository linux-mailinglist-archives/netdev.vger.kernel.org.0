Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1F0E5AA2
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfJZNQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbfJZNQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E67521E6F;
        Sat, 26 Oct 2019 13:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095797;
        bh=1z8sPM2iMelBgO7dSl9hmqwAIU8J4e69MNI8IY+DL3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qa4oZQTQbBW3foGP9IT9K5I9xRphkuQDlSF8h6ibWFdc60pOztc3qdClX299m3r29
         pYyeNuKuAGRHG5FmyVWECDSLiQGbMtOITbistMdvoaQXmo3wDBoGscdomnRZM0Y8gu
         v+LgwhqZhmRBJvfOpMR4hiymirp0wIFgf298cVGk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Komisar <aaron.komisar@tandemg.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 24/99] mac80211: fix scan when operating on DFS channels in ETSI domains
Date:   Sat, 26 Oct 2019 09:14:45 -0400
Message-Id: <20191026131600.2507-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aaron Komisar <aaron.komisar@tandemg.com>

[ Upstream commit dc0c18ed229cdcca283dd78fefa38273ec37a42c ]

In non-ETSI regulatory domains scan is blocked when operating channel
is a DFS channel. For ETSI, however, once DFS channel is marked as
available after the CAC, this channel will remain available (for some
time) even after leaving this channel.

Therefore a scan can be done without any impact on the availability
of the DFS channel as no new CAC is required after the scan.

Enable scan in mac80211 in these cases.

Signed-off-by: Aaron Komisar <aaron.komisar@tandemg.com>
Link: https://lore.kernel.org/r/1570024728-17284-1-git-send-email-aaron.komisar@tandemg.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h |  8 ++++++++
 net/mac80211/scan.c    | 30 ++++++++++++++++++++++++++++--
 net/wireless/reg.c     |  1 +
 net/wireless/reg.h     |  8 --------
 4 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26e2ad2c70278..ce2659988a233 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5446,6 +5446,14 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
  */
 const char *reg_initiator_name(enum nl80211_reg_initiator initiator);
 
+/**
+ * regulatory_pre_cac_allowed - check if pre-CAC allowed in the current regdom
+ * @wiphy: wiphy for which pre-CAC capability is checked.
+ *
+ * Pre-CAC is allowed only in some regdomains (notable ETSI).
+ */
+bool regulatory_pre_cac_allowed(struct wiphy *wiphy);
+
 /**
  * DOC: Internal regulatory db functions
  *
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index adf94ba1ed77a..4d31d9688dc23 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -520,10 +520,33 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local,
 	return 0;
 }
 
+static bool __ieee80211_can_leave_ch(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *sdata_iter;
+
+	if (!ieee80211_is_radar_required(local))
+		return true;
+
+	if (!regulatory_pre_cac_allowed(local->hw.wiphy))
+		return false;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata_iter, &local->interfaces, list) {
+		if (sdata_iter->wdev.cac_started) {
+			mutex_unlock(&local->iflist_mtx);
+			return false;
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	return true;
+}
+
 static bool ieee80211_can_scan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata)
 {
-	if (ieee80211_is_radar_required(local))
+	if (!__ieee80211_can_leave_ch(sdata))
 		return false;
 
 	if (!list_empty(&local->roc_list))
@@ -630,7 +653,10 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 	lockdep_assert_held(&local->mtx);
 
-	if (local->scan_req || ieee80211_is_radar_required(local))
+	if (local->scan_req)
+		return -EBUSY;
+
+	if (!__ieee80211_can_leave_ch(sdata))
 		return -EBUSY;
 
 	if (!ieee80211_can_scan(local, sdata)) {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 36eba5804efe8..796b7b75acdd1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3866,6 +3866,7 @@ bool regulatory_pre_cac_allowed(struct wiphy *wiphy)
 
 	return pre_cac_allowed;
 }
+EXPORT_SYMBOL(regulatory_pre_cac_allowed);
 
 void regulatory_propagate_dfs_state(struct wiphy *wiphy,
 				    struct cfg80211_chan_def *chandef,
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 504133d76de4d..dc8f689bd4690 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -155,14 +155,6 @@ bool regulatory_indoor_allowed(void);
  */
 #define REG_PRE_CAC_EXPIRY_GRACE_MS 2000
 
-/**
- * regulatory_pre_cac_allowed - if pre-CAC allowed in the current dfs domain
- * @wiphy: wiphy for which pre-CAC capability is checked.
-
- * Pre-CAC is allowed only in ETSI domain.
- */
-bool regulatory_pre_cac_allowed(struct wiphy *wiphy);
-
 /**
  * regulatory_propagate_dfs_state - Propagate DFS channel state to other wiphys
  * @wiphy - wiphy on which radar is detected and the event will be propagated
-- 
2.20.1

