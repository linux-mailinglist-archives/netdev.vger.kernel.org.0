Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E6B2E1401
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731057AbgLWChN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730204AbgLWCYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E137022A99;
        Wed, 23 Dec 2020 02:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690249;
        bh=bCzcsyMz4N20rG43V7iM8T9PNE9isZ4UIkqwgddlBDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVttgaGNKbEOEu0ISP+bP9UeXFBmSI/Y/j4RdAfJ5tubDSRxRYBDBGRtHO61x1ADu
         eA3MgGiZyedr7hMgWesoli610Pgta4SlUL9H9kHR2xnzR5Bdh2v+HrwwBLJ+y6dPd3
         MR5CV6kAU78LGOisaM4sVBRpB6SBCTi7xSx28xtW1yrwOsMM1wX3ThiyFlrAEWFOzQ
         XFGh5T8CkcI3fFvWVesPNdw6Yb3WhjxhyOD8c5VSgB8v4kbdSAWY8iVObXs3pmkAjo
         LvWOtEjYkPg/nBiyYWotfseln0ZkTM7JOOnBfjaUkpdRZAHw6qQiWiqxNOrZYmQJ4d
         d+lbpATIJmJYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 61/66] mac80211: disallow band-switch during CSA
Date:   Tue, 22 Dec 2020 21:22:47 -0500
Message-Id: <20201223022253.2793452-61-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 3660944a37ce73890292571f44f04891834f9044 ]

If the AP advertises a band switch during CSA, we will not have
the right information to continue working with it, since it will
likely (have to) change its capabilities and we don't track any
capability changes at all. Additionally, we store e.g. supported
rates per band, and that information would become invalid.

Since this is a fringe scenario, just disconnect explicitly.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201129172929.0e2327107c06.I461adb07704e056b054a4a7c29b80c95a9f56637@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ab26b8b954719..c23364948f946 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1176,6 +1176,17 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (res)
 		return;
 
+	if (sdata->vif.bss_conf.chandef.chan->band !=
+	    csa_ie.chandef.chan->band) {
+		sdata_info(sdata,
+			   "AP %pM switches to different band (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
+			   ifmgd->associated->bssid,
+			   csa_ie.chandef.chan->center_freq,
+			   csa_ie.chandef.width, csa_ie.chandef.center_freq1,
+			   csa_ie.chandef.center_freq2);
+		goto lock_and_drop_connection;
+	}
+
 	if (!cfg80211_chandef_usable(local->hw.wiphy, &csa_ie.chandef,
 				     IEEE80211_CHAN_DISABLED)) {
 		sdata_info(sdata,
@@ -1184,9 +1195,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 			   csa_ie.chandef.chan->center_freq,
 			   csa_ie.chandef.width, csa_ie.chandef.center_freq1,
 			   csa_ie.chandef.center_freq2);
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		return;
+		goto lock_and_drop_connection;
 	}
 
 	if (cfg80211_chandef_identical(&csa_ie.chandef,
@@ -1276,6 +1285,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 			  TU_TO_EXP_TIME((csa_ie.count - 1) *
 					 cbss->beacon_interval));
 	return;
+ lock_and_drop_connection:
+	mutex_lock(&local->mtx);
+	mutex_lock(&local->chanctx_mtx);
  drop_connection:
 	/*
 	 * This is just so that the disconnect flow will know that
-- 
2.27.0

