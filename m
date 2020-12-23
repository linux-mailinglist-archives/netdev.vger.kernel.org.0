Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAAC2E13EA
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbgLWCY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:24:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730206AbgLWCYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F4502256F;
        Wed, 23 Dec 2020 02:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690248;
        bh=Xb9UiOoz9QZNo0gkwj9ETOXmWzNA3u4mUMOABkWgRG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zny1IW/j0UDYv0fjzXJFCZvpzP5uSW18OtfNDT9MM6KFtOKFn1mxiY9izkhEn9jLW
         XXgom+RdFIIOyPMk5rdqQX468lxxkSxURkxfMIMa46WOgDsnoKvuHZY4Oszt5I7ziy
         m3hSQlxgvw4isqZKyymY8Wb1hXpdejtL44Msb7QecptxU21yqiNRzvDjnFQofQ2N5d
         RQP6zkPwbi4eapnS937mQuDy8k/BKFYtwrA51VVYLr1McRBvZM+Es8eEzy4mlLtbbN
         yqkEFbgFN8kWuUy9TQ6QYut201rwmlnTNUnoJOsItOiRa8oAR/TW/dOBZM1ZZ46tt2
         3e1NZRYBc8/rQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 60/66] cfg80211: Save the regulatory domain when setting custom regulatory
Date:   Tue, 22 Dec 2020 21:22:46 -0500
Message-Id: <20201223022253.2793452-60-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit beee246951571cc5452176f3dbfe9aa5a10ba2b9 ]

When custom regulatory was set, only the channels setting was updated, but
the regulatory domain was not saved. Fix it by saving it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201129172929.290fa5c5568a.Ic5732aa64de6ee97ae3578bd5779fc723ba489d1@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index db8cc505caf76..ed4c6ad53c683 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1796,6 +1796,7 @@ static void handle_band_custom(struct wiphy *wiphy,
 void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 				   const struct ieee80211_regdomain *regd)
 {
+	const struct ieee80211_regdomain *new_regd, *tmp;
 	enum nl80211_band band;
 	unsigned int bands_set = 0;
 
@@ -1815,6 +1816,13 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 	 * on your device's supported bands.
 	 */
 	WARN_ON(!bands_set);
+	new_regd = reg_copy_regd(regd);
+	if (IS_ERR(new_regd))
+		return;
+
+	tmp = get_wiphy_regdom(wiphy);
+	rcu_assign_pointer(wiphy->regd, new_regd);
+	rcu_free_regdom(tmp);
 }
 EXPORT_SYMBOL(wiphy_apply_custom_regulatory);
 
-- 
2.27.0

