Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4F82E15E7
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbgLWCzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:55:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729171AbgLWCVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DBD922D57;
        Wed, 23 Dec 2020 02:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690045;
        bh=NiMmayQkoHgqfQDGrzyv/4hBRPYtGCJ+5TKG/Q9MXCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5nCJNqobQIYvVsEy245Y5nmGB+vln2SGEHsLWnFVpH5baJ6cGXy6xuhzA4cCKVNt
         AK831Ft5XCck0GRSqlqhTdv9UtSWDSmVU3Qb0R74ewXKgMWip8Cwmv3QUSDbXBOGP8
         ACoFRim5X+GcFr4QAtR/mEdKkdG5xrVRHtPpbEnlnWGbrxM5hjj3P5b5ZyOkI2eV3H
         yruvyUdqVy128gpWzrZecJF5TwV53/1ex5oJ/SeesKGGpMjpfuVypbBpnJPQ8Bhg9C
         cpp9Vl1kcEu8cDwzSIujWAv1nrjY1aX5YCrv4mCK5Ihv78FJvonFkN4KUqRciSiCtg
         r1UNF+lbHtAsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 117/130] nl80211: always accept scan request with the duration set
Date:   Tue, 22 Dec 2020 21:18:00 -0500
Message-Id: <20201223021813.2791612-117-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit c837cbad40d949feaff86734d637c7602ae0b56b ]

Accept a scan request with the duration set even if the driver
does not support setting the scan dwell. The duration can be used
as a hint to the driver, but the driver may use its internal logic
for setting the scan dwell.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201129172929.9491a12f9226.Ia9c5b24fcefc5ce5592537507243391633a27e5f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dbac5c0995a0f..881bc49a67e45 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7694,12 +7694,6 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_MEASUREMENT_DURATION]) {
-		if (!wiphy_ext_feature_isset(wiphy,
-					NL80211_EXT_FEATURE_SET_SCAN_DWELL)) {
-			err = -EOPNOTSUPP;
-			goto out_free;
-		}
-
 		request->duration =
 			nla_get_u16(info->attrs[NL80211_ATTR_MEASUREMENT_DURATION]);
 		request->duration_mandatory =
-- 
2.27.0

