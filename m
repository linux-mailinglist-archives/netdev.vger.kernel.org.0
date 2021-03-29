Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D1734DA57
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhC2WW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231933AbhC2WVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE1B361989;
        Mon, 29 Mar 2021 22:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056512;
        bh=9dZ7igudTV9weAVtKaJoWZF1q0M8xiZt7lrw3zitF9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIjWJttfezpwJlQsOkTjo7mnWw7k7Xc8MT2WAzeARj6hp4jT1Ww4s2M1qc4wh1IFV
         UXUZ8U+abIvUsbbw6w1OLQUMFeEHqjM6dpl+ti/wPUbguzR3uZl+FJBlIB1vdRlHIZ
         5K4Hg2RQCxpURGeVhvXKhlO8jSZDjWj7v23derlklQRW4Vb6Brimg8sRfjzz8t0do8
         SUdb901zcx3VxzFNu3OnSjf2h0N1NsyUy8uZDOkdl1ZJlRHPr4+Ha8rtjaLX/jIBaI
         DLbRlUdzijEuTWArWfmuX1GP4gMHhk7EcdEvaKDJ/OhQoqUIoHxju/Yzjx2Gte8FoT
         GqVPmt96FNkAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karthikeyan Kathirvel <kathirve@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 15/38] mac80211: choose first enabled channel for monitor
Date:   Mon, 29 Mar 2021 18:21:10 -0400
Message-Id: <20210329222133.2382393-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karthikeyan Kathirvel <kathirve@codeaurora.org>

[ Upstream commit 041c881a0ba8a75f71118bd9766b78f04beed469 ]

Even if the first channel from sband channel list is invalid
or disabled mac80211 ends up choosing it as the default channel
for monitor interfaces, making them not usable.

Fix this by assigning the first available valid or enabled
channel instead.

Signed-off-by: Karthikeyan Kathirvel <kathirve@codeaurora.org>
Link: https://lore.kernel.org/r/1615440547-7661-1-git-send-email-kathirve@codeaurora.org
[reword commit message, comment, code cleanups]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index dee88ec566ad..d1023188ef37 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -970,8 +970,19 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			continue;
 
 		if (!dflt_chandef.chan) {
+			/*
+			 * Assign the first enabled channel to dflt_chandef
+			 * from the list of channels
+			 */
+			for (i = 0; i < sband->n_channels; i++)
+				if (!(sband->channels[i].flags &
+						IEEE80211_CHAN_DISABLED))
+					break;
+			/* if none found then use the first anyway */
+			if (i == sband->n_channels)
+				i = 0;
 			cfg80211_chandef_create(&dflt_chandef,
-						&sband->channels[0],
+						&sband->channels[i],
 						NL80211_CHAN_NO_HT);
 			/* init channel we're on */
 			if (!local->use_chanctx && !local->_oper_chandef.chan) {
-- 
2.30.1

