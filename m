Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E745FA139
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfKMBz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbfKMBz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC0CE2247D;
        Wed, 13 Nov 2019 01:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610155;
        bh=K4n3aYJXAo17CDZa0QtfmAmu1waj7vh3I8pX8B47fb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7gTlhbPwaOI+d8CwDcphQ9fa27w+4Zy5xdxor62BfuIF8+onnUShnouwL6DJqXeU
         0t9+Huvc5bFVyTr2XQTBL77FvVqXiQsp3eEKCvHbjYRedtCmwpEVjz1Y42uDqrx/sg
         bgQESEZcter7g3XKNcLQl0TaQjs29R9MZ5asF5Gs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 199/209] mac80211: minstrel: fix sampling/reporting of CCK rates in HT mode
Date:   Tue, 12 Nov 2019 20:50:15 -0500
Message-Id: <20191113015025.9685-199-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 972b66b86f85f4e8201db454f4c3e9d990cf9836 ]

Long/short preamble selection cannot be sampled separately, since it
depends on the BSS state. Because of that, sampling attempts to
currently not used preamble modes are not counted in the statistics,
which leads to CCK rates being sampled too often.

Fix statistics accounting for long/short preamble by increasing the
index where necessary.
Fix excessive CCK rate sampling by dropping unsupported sample attempts.

This improves throughput on 2.4 GHz channels

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2ecca10f6c24a..3d5520776655d 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -282,7 +282,8 @@ minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 				break;
 
 		/* short preamble */
-		if (!(mi->supported[group] & BIT(idx)))
+		if ((mi->supported[group] & BIT(idx + 4)) &&
+		    (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE))
 			idx += 4;
 	}
 	return &mi->groups[group].rates[idx];
@@ -1077,18 +1078,23 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		return;
 
 	sample_group = &minstrel_mcs_groups[sample_idx / MCS_GROUP_RATES];
+	sample_idx %= MCS_GROUP_RATES;
+
+	if (sample_group == &minstrel_mcs_groups[MINSTREL_CCK_GROUP] &&
+	    (sample_idx >= 4) != txrc->short_preamble)
+		return;
+
 	info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 	rate->count = 1;
 
-	if (sample_idx / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
+	if (sample_group == &minstrel_mcs_groups[MINSTREL_CCK_GROUP]) {
 		int idx = sample_idx % ARRAY_SIZE(mp->cck_rates);
 		rate->idx = mp->cck_rates[idx];
 	} else if (sample_group->flags & IEEE80211_TX_RC_VHT_MCS) {
 		ieee80211_rate_set_vht(rate, sample_idx % MCS_GROUP_RATES,
 				       sample_group->streams);
 	} else {
-		rate->idx = sample_idx % MCS_GROUP_RATES +
-			    (sample_group->streams - 1) * 8;
+		rate->idx = sample_idx + (sample_group->streams - 1) * 8;
 	}
 
 	rate->flags = sample_group->flags;
-- 
2.20.1

