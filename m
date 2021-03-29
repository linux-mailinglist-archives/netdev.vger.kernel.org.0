Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96F234DB96
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhC2W3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:29:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232619AbhC2W0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:26:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 504C3619CE;
        Mon, 29 Mar 2021 22:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056647;
        bh=a1uXK/+GlABlmfBCQvKMA0C/8sWssEIwuCem40Wi1hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0pMPI0wU46czHtlPTQPNOhRrT9NRUgpvl6sa+8LBNuPryGqj1v9g8OL7ELzAeQ92
         bypLzDJ28saKhaZ2vRN+oFJFCFge1yodyJgfCHnZb7w+rdRKMEu1QUDj4iA0zHNAuL
         PE8GWsHLhircQClKRC9xXjWHrQp0hPWIbAMtqSl5j+ErM05nn12h1iuYRJSJxr6zNf
         odd3tEQDdJuUbFUghJE4EsHpL/QxxpwRePVtmiN6CcH2fESnL/tVQ09hZWMTJWjM3J
         KAUP9Fegg3ejXOgYiu6grG2xyGE5vVdFHnZGCGnXAFvOUwqoSJEEGdzchw38b6D7al
         Y/WMz6ndL2aMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karthikeyan Kathirvel <kathirve@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/10] mac80211: choose first enabled channel for monitor
Date:   Mon, 29 Mar 2021 18:23:55 -0400
Message-Id: <20210329222401.2383930-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222401.2383930-1-sashal@kernel.org>
References: <20210329222401.2383930-1-sashal@kernel.org>
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
index e3bbfb20ae82..f31fd21d59ba 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -906,8 +906,19 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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

