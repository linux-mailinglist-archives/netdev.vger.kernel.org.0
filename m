Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3BF34DBBC
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhC2Waf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232636AbhC2W1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:27:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78B3A619E4;
        Mon, 29 Mar 2021 22:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056660;
        bh=93WRCoQXNfJcy/6OKMEw6h4XEaAxLRwx9CF2+OTunBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJbuRMTCnqU75gCyDApCWbnSPt3a4sghgggB7Ta86mlSlm8RAHas/++3N0tjzCDYt
         FGK3ekVTPNgH0EOFFLidWQkj0I/kjFGTE4LDjJgpIy0o9TeQE0FYOTApPAJPRvm9Tw
         MQQl4xByrb+hqG07Wet82Qi8Hpp42LnJR9ImgduwMxnR5lz1vvay6gimsGQy2MXN1v
         nc7dMNutVMK5XJnfbUY7RCKd84vjcGmINe5a5tsO/9V7uf100s90KACI8y4b0hRXSo
         jtFvlb2Ak2ZcpSlPxORoN9U4dVU2K7y1L0IzxWQ3PVpQUXepvamZE4+9alzI8q9WGA
         y+zKAtx5XWwEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karthikeyan Kathirvel <kathirve@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/8] mac80211: choose first enabled channel for monitor
Date:   Mon, 29 Mar 2021 18:24:10 -0400
Message-Id: <20210329222415.2384075-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222415.2384075-1-sashal@kernel.org>
References: <20210329222415.2384075-1-sashal@kernel.org>
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
index 15d23aeea634..2357b17254e7 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -889,8 +889,19 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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

