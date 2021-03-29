Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8894934DB74
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhC2W2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhC2WZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:25:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D3CC61985;
        Mon, 29 Mar 2021 22:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056632;
        bh=UL7nbt1/t0iiy+yB/FV6yd1Zcnq7C9LkYG4zx/9nZXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwbrV16ADWoUcDUHxj/vyXXvCCXk78M4oCYHUV0uKB93/LfU8wkTm++Lx5ktZb+bM
         XSGaqIFNmRw33zTDCait/BRwZ7QVUx4lqHr/Fq/lifc3Z0m4toBKlviPrR+SYDWNNY
         LZjk8k5zOqvP7GUEM0igZb3LEAF3vicK28cFeoJWwlITPO/kA7uCJAHf5N8up5UZ42
         pnIZhGL1m78LeB2oWOXQFV10ohE01dM125kgtSmnYRu1Gc1k46Hr0lBpat6af1/qFY
         +PpMLaCZQ5Yodoe47bY/ajGox0YNsQ5ozmH1KcHvHdUjG50FfAoIZGSD2q8s8gZee8
         gOWkLJDg7oOng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karthikeyan Kathirvel <kathirve@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/12] mac80211: choose first enabled channel for monitor
Date:   Mon, 29 Mar 2021 18:23:38 -0400
Message-Id: <20210329222345.2383777-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222345.2383777-1-sashal@kernel.org>
References: <20210329222345.2383777-1-sashal@kernel.org>
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
index 8a51f94ec1ce..2136ce3b4489 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -913,8 +913,19 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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

