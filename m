Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0400F2E1392
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgLWCbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:31:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729312AbgLWCZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 694F1225AB;
        Wed, 23 Dec 2020 02:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690308;
        bh=K7RkqFsTeqiJvYHV1OKubzdFM09jowcGp4swt1CPFbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvx1WrKSndLZT1iCAcVmWNr94FJbr/Bq8Y2/6diD9dN7Oy4K463uRr78p3z42tRj2
         2gGT1KLEeI8DhykXphKQzYAoAzM69cWqOinp04HaUBWCBiVMLc7FnbigODG9qb3shs
         dDKP3V+MsWgdTz05Mva85+82dp2+nfVOXOH8Pzw194MtkHICTxFPvvdcB2LrA6ABuI
         k7S7RFXLX4wS0Y8d/0pfLO4+gHs0bZlRPVlqDlX17VKeVnjahPK4lnYTHbzWCFcU7B
         wJV+B0fi6RgYHEi7tJ+bpFzljlrvJg7zoLJryLZN6c951L1Q+Y5JVUwkO6eUZ97Npo
         BhWhFCqd3pcag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 42/48] cfg80211: Save the regulatory domain when setting custom regulatory
Date:   Tue, 22 Dec 2020 21:24:10 -0500
Message-Id: <20201223022417.2794032-42-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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
index 04da31c52d092..2e115c2a43e90 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1793,6 +1793,7 @@ static void handle_band_custom(struct wiphy *wiphy,
 void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 				   const struct ieee80211_regdomain *regd)
 {
+	const struct ieee80211_regdomain *new_regd, *tmp;
 	enum nl80211_band band;
 	unsigned int bands_set = 0;
 
@@ -1812,6 +1813,13 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
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

