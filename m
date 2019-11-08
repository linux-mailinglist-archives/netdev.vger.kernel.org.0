Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E3AF4837
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387765AbfKHLp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:45:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391210AbfKHLp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:45:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6697121D82;
        Fri,  8 Nov 2019 11:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213556;
        bh=mhHN88vt379iosWB8gbGNyPhtscPz6r7O0iId8KiFuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9QL+syMOelHor+AFgDn5FiA45QgxP40otS0AVG7KuZnROi1dNOv1MVH9H3pr9qbN
         vowtciIeSa4brvvVUjrLLzkQ/sdbfuy9GVKHZbmcRaei64J6/+T75//Tp1Xfnu4CZW
         4wQQUR4ewtV63q0bnwhKnSoEtUGjxhPaZK8JchG8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajeev Kumar Sirasanagandla <rsirasan@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/64] cfg80211: Avoid regulatory restore when COUNTRY_IE_IGNORE is set
Date:   Fri,  8 Nov 2019 06:44:47 -0500
Message-Id: <20191108114545.15351-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rajeev Kumar Sirasanagandla <rsirasan@codeaurora.org>

[ Upstream commit 7417844b63d4b0dc8ab23f88259bf95de7d09b57 ]

When REGULATORY_COUNTRY_IE_IGNORE is set,  __reg_process_hint_country_ie()
ignores the country code change request from __cfg80211_connect_result()
via regulatory_hint_country_ie().

After Disconnect, similar to above, country code should not be reset to
world when country IE ignore is set. But this is violated and restore of
regulatory settings is invoked by cfg80211_disconnect_work via
regulatory_hint_disconnect().

To address this, avoid regulatory restore from regulatory_hint_disconnect()
when COUNTRY_IE_IGNORE is set.

Note: Currently, restore_regulatory_settings() takes care of clearing
beacon hints. But in the proposed change, regulatory restore is avoided.
Therefore, explicitly clear beacon hints when DISABLE_BEACON_HINTS
is not set.

Signed-off-by: Rajeev Kumar Sirasanagandla <rsirasan@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 44befe9f9ff08..dde741f298de7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2616,8 +2616,54 @@ static void restore_regulatory_settings(bool reset_user)
 	schedule_work(&reg_work);
 }
 
+static bool is_wiphy_all_set_reg_flag(enum ieee80211_regulatory_flags flag)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+			wdev_lock(wdev);
+			if (!(wdev->wiphy->regulatory_flags & flag)) {
+				wdev_unlock(wdev);
+				return false;
+			}
+			wdev_unlock(wdev);
+		}
+	}
+
+	return true;
+}
+
 void regulatory_hint_disconnect(void)
 {
+	/* Restore of regulatory settings is not required when wiphy(s)
+	 * ignore IE from connected access point but clearance of beacon hints
+	 * is required when wiphy(s) supports beacon hints.
+	 */
+	if (is_wiphy_all_set_reg_flag(REGULATORY_COUNTRY_IE_IGNORE)) {
+		struct reg_beacon *reg_beacon, *btmp;
+
+		if (is_wiphy_all_set_reg_flag(REGULATORY_DISABLE_BEACON_HINTS))
+			return;
+
+		spin_lock_bh(&reg_pending_beacons_lock);
+		list_for_each_entry_safe(reg_beacon, btmp,
+					 &reg_pending_beacons, list) {
+			list_del(&reg_beacon->list);
+			kfree(reg_beacon);
+		}
+		spin_unlock_bh(&reg_pending_beacons_lock);
+
+		list_for_each_entry_safe(reg_beacon, btmp,
+					 &reg_beacon_list, list) {
+			list_del(&reg_beacon->list);
+			kfree(reg_beacon);
+		}
+
+		return;
+	}
+
 	pr_debug("All devices are disconnected, going to restore regulatory settings\n");
 	restore_regulatory_settings(false);
 }
-- 
2.20.1

