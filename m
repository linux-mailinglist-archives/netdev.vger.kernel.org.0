Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1AC7E5D49
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfJZNQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbfJZNQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B3A0222C4;
        Sat, 26 Oct 2019 13:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095795;
        bh=D5MAHeyDcTYlwUrhihOy3TU+/cG5UlEbHY58W5ziSO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBxF0+760NuqAo8yDFeGf3FX+66Ngza80PryGU1Oxb5yh77J5q1299PbCPAWJrWUg
         MLjIvMfw6vJynhvuvg3Oi0G0rP7AczA1GYcFu1IgKp+egGe+u6CFvkDiYhGXyoLwbj
         hB3Whm4zHg8ZMjZ5hEvCsHS2NwgSvvnw7bWtf4m0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 22/99] cfg80211: fix a bunch of RCU issues in multi-bssid code
Date:   Sat, 26 Oct 2019 09:14:43 -0400
Message-Id: <20191026131600.2507-22-sashal@kernel.org>
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

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 461c4c2b4c0731d7452bad4e77c0cdbdcea1804c ]

cfg80211_update_notlisted_nontrans() leaves the RCU critical session
too early, while still using nontrans_ssid which is RCU protected. In
addition, it performs a bunch of RCU pointer update operations such
as rcu_access_pointer and rcu_assign_pointer.

The caller, cfg80211_inform_bss_frame_data(), also accesses the RCU
pointer without holding the lock.

Just wrap all of this with bss_lock.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/20191004123706.15768-3-luca@coelho.fi
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 27d76c4c5cea1..00f7a4630f45d 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1691,8 +1691,7 @@ cfg80211_parse_mbssid_frame_data(struct wiphy *wiphy,
 static void
 cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 				   struct cfg80211_bss *nontrans_bss,
-				   struct ieee80211_mgmt *mgmt, size_t len,
-				   gfp_t gfp)
+				   struct ieee80211_mgmt *mgmt, size_t len)
 {
 	u8 *ie, *new_ie, *pos;
 	const u8 *nontrans_ssid, *trans_ssid, *mbssid;
@@ -1703,6 +1702,8 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 	const struct cfg80211_bss_ies *old;
 	u8 cpy_len;
 
+	lockdep_assert_held(&wiphy_to_rdev(wiphy)->bss_lock);
+
 	ie = mgmt->u.probe_resp.variable;
 
 	new_ie_len = ielen;
@@ -1719,23 +1720,22 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 	if (!mbssid || mbssid < trans_ssid)
 		return;
 	new_ie_len -= mbssid[1];
-	rcu_read_lock();
+
 	nontrans_ssid = ieee80211_bss_get_ie(nontrans_bss, WLAN_EID_SSID);
-	if (!nontrans_ssid) {
-		rcu_read_unlock();
+	if (!nontrans_ssid)
 		return;
-	}
+
 	new_ie_len += nontrans_ssid[1];
-	rcu_read_unlock();
 
 	/* generate new ie for nontrans BSS
 	 * 1. replace SSID with nontrans BSS' SSID
 	 * 2. skip MBSSID IE
 	 */
-	new_ie = kzalloc(new_ie_len, gfp);
+	new_ie = kzalloc(new_ie_len, GFP_ATOMIC);
 	if (!new_ie)
 		return;
-	new_ies = kzalloc(sizeof(*new_ies) + new_ie_len, gfp);
+
+	new_ies = kzalloc(sizeof(*new_ies) + new_ie_len, GFP_ATOMIC);
 	if (!new_ies)
 		goto out_free;
 
@@ -1895,6 +1895,8 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	cfg80211_parse_mbssid_frame_data(wiphy, data, mgmt, len,
 					 &non_tx_data, gfp);
 
+	spin_lock_bh(&wiphy_to_rdev(wiphy)->bss_lock);
+
 	/* check if the res has other nontransmitting bss which is not
 	 * in MBSSID IE
 	 */
@@ -1909,8 +1911,9 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 		ies2 = rcu_access_pointer(tmp_bss->ies);
 		if (ies2->tsf < ies1->tsf)
 			cfg80211_update_notlisted_nontrans(wiphy, tmp_bss,
-							   mgmt, len, gfp);
+							   mgmt, len);
 	}
+	spin_unlock_bh(&wiphy_to_rdev(wiphy)->bss_lock);
 
 	return res;
 }
-- 
2.20.1

