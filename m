Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFA015C0D
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbfEGFgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbfEGFgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:36:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A133620B7C;
        Tue,  7 May 2019 05:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207372;
        bh=Cky+mAxpRThh75WYi0Ey42ZgD+2VmcouYKl/3nh/3dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etIgIJmBznxiPoq2nPhpcZhpOINuV16icMNridxwCvdQDQa4kMT2VvNPEe2m0Uk/P
         94oMjd/ml74t9802R5cnbXDqpzzMNN4HaBgYDgaH3vLdxcVLTdyE0IzDgTd1NBSAm1
         r6iwSJ0H3iLHxbKz6S+UgzAIQuc/u7FsH+sr+IWc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/81] cfg80211: Handle WMM rules in regulatory domain intersection
Date:   Tue,  7 May 2019 01:34:44 -0400
Message-Id: <20190507053554.30848-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 08a75a887ee46828b54600f4bb7068d872a5edd5 ]

The support added for regulatory WMM rules did not handle
the case of regulatory domain intersections. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Fixes: 230ebaa189af ("cfg80211: read wmm rules from regulatory database")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8002ace7c9f6..8a47297ff206 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1287,6 +1287,16 @@ reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
 	return dfs_region1;
 }
 
+static void reg_wmm_rules_intersect(const struct ieee80211_wmm_ac *wmm_ac1,
+				    const struct ieee80211_wmm_ac *wmm_ac2,
+				    struct ieee80211_wmm_ac *intersect)
+{
+	intersect->cw_min = max_t(u16, wmm_ac1->cw_min, wmm_ac2->cw_min);
+	intersect->cw_max = max_t(u16, wmm_ac1->cw_max, wmm_ac2->cw_max);
+	intersect->cot = min_t(u16, wmm_ac1->cot, wmm_ac2->cot);
+	intersect->aifsn = max_t(u8, wmm_ac1->aifsn, wmm_ac2->aifsn);
+}
+
 /*
  * Helper for regdom_intersect(), this does the real
  * mathematical intersection fun
@@ -1301,6 +1311,8 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	struct ieee80211_freq_range *freq_range;
 	const struct ieee80211_power_rule *power_rule1, *power_rule2;
 	struct ieee80211_power_rule *power_rule;
+	const struct ieee80211_wmm_rule *wmm_rule1, *wmm_rule2;
+	struct ieee80211_wmm_rule *wmm_rule;
 	u32 freq_diff, max_bandwidth1, max_bandwidth2;
 
 	freq_range1 = &rule1->freq_range;
@@ -1311,6 +1323,10 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	power_rule2 = &rule2->power_rule;
 	power_rule = &intersected_rule->power_rule;
 
+	wmm_rule1 = &rule1->wmm_rule;
+	wmm_rule2 = &rule2->wmm_rule;
+	wmm_rule = &intersected_rule->wmm_rule;
+
 	freq_range->start_freq_khz = max(freq_range1->start_freq_khz,
 					 freq_range2->start_freq_khz);
 	freq_range->end_freq_khz = min(freq_range1->end_freq_khz,
@@ -1354,6 +1370,29 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	intersected_rule->dfs_cac_ms = max(rule1->dfs_cac_ms,
 					   rule2->dfs_cac_ms);
 
+	if (rule1->has_wmm && rule2->has_wmm) {
+		u8 ac;
+
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+			reg_wmm_rules_intersect(&wmm_rule1->client[ac],
+						&wmm_rule2->client[ac],
+						&wmm_rule->client[ac]);
+			reg_wmm_rules_intersect(&wmm_rule1->ap[ac],
+						&wmm_rule2->ap[ac],
+						&wmm_rule->ap[ac]);
+		}
+
+		intersected_rule->has_wmm = true;
+	} else if (rule1->has_wmm) {
+		*wmm_rule = *wmm_rule1;
+		intersected_rule->has_wmm = true;
+	} else if (rule2->has_wmm) {
+		*wmm_rule = *wmm_rule2;
+		intersected_rule->has_wmm = true;
+	} else {
+		intersected_rule->has_wmm = false;
+	}
+
 	if (!is_valid_reg_rule(intersected_rule))
 		return -EINVAL;
 
-- 
2.20.1

