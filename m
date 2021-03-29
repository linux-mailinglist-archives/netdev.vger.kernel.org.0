Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DA534DB41
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhC2W04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232743AbhC2WYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:24:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A80B9619BB;
        Mon, 29 Mar 2021 22:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056615;
        bh=ESaG5xY99YlSyH/jJMtYspYTLm0ub+JFq0HjG/Ioor0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQLfA5spiUC/2dkDDenxHKQLIweZk8RKNx56h1UsdynKyjy1giBI46fJkKa6C4b1e
         OfB7w+9g1zQq1uG7AmXb0JzS0L54rQVF/JSY1zjrTLV9HbrssuKSfXKNhB2S7quTcc
         tcuTZvukERNigWcs9qcPlyif15iVU8OkpJ1KlFJ+4WfC/SC/NKoFHB0Jf2u1G24gfX
         tF/Jz11BS6AR/9EMdWLFmGUbCMIUsOejR4jdh2Pkl5m2crTxusq3i1zwYe0/+b3J9P
         1nyZwDeHKrIkKdBxYySjW2XeTTslekr1taAz49Xudg6LLeur9P/Tz2CgWWLwkMIJwY
         K9VC9Hh8IqT+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karthikeyan Kathirvel <kathirve@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/15] mac80211: choose first enabled channel for monitor
Date:   Mon, 29 Mar 2021 18:23:18 -0400
Message-Id: <20210329222327.2383533-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222327.2383533-1-sashal@kernel.org>
References: <20210329222327.2383533-1-sashal@kernel.org>
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
index 68db2a356443..f44d00f35fe7 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -931,8 +931,19 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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

