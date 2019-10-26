Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E42B0E5C7A
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfJZNTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728329AbfJZNTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:19:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E127E21871;
        Sat, 26 Oct 2019 13:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095971;
        bh=0P9BcpGTjiTlvWRIBGOW4ovug3EeLWVynQqJgcKYs6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHpRXCgK2ohLxyVq8mIStOCyW/Wd95Tw7bKSaVGA5hv0zPNaQbMN1sjBCHuMbE4nM
         D9z5r38hHZiJVqGAjIMrMfRiY4F1KMcBpox07Ly+euTDjtX8X/WuYnRO2DpNBtXjwT
         nstA/QCi26tqFARfwp5Pp4uO6ESbmce74iz+fmDo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Komisar <aaron.komisar@tandemg.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/59] mac80211: fix scan when operating on DFS channels in ETSI domains
Date:   Sat, 26 Oct 2019 09:18:27 -0400
Message-Id: <20191026131910.3435-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
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
index 468deae5d603e..e9e8ac4df36aa 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4842,6 +4842,14 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
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
index 5d2a11777718c..9121013cab9d5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -501,10 +501,33 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local,
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
@@ -610,7 +633,10 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 	lockdep_assert_held(&local->mtx);
 
-	if (local->scan_req || ieee80211_is_radar_required(local))
+	if (local->scan_req)
+		return -EBUSY;
+
+	if (!__ieee80211_can_leave_ch(sdata))
 		return -EBUSY;
 
 	if (!ieee80211_can_scan(local, sdata)) {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index cccbf845079c8..e83e40764b0ab 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3780,6 +3780,7 @@ bool regulatory_pre_cac_allowed(struct wiphy *wiphy)
 
 	return pre_cac_allowed;
 }
+EXPORT_SYMBOL(regulatory_pre_cac_allowed);
 
 void regulatory_propagate_dfs_state(struct wiphy *wiphy,
 				    struct cfg80211_chan_def *chandef,
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 9ceeb5f3a7cbc..af92612edd1e4 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -153,14 +153,6 @@ bool regulatory_indoor_allowed(void);
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

