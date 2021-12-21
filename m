Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BCC47B70A
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 02:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhLUB6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 20:58:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52840 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhLUB57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:57:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECD7D61357;
        Tue, 21 Dec 2021 01:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FA6C36AE8;
        Tue, 21 Dec 2021 01:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051878;
        bh=aRUHdHSWaXffdISJhdg9J3a6d/P90K9Yf16lmAoJoMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JK7OOK6j0Q78VfpH3GSWb6J1UOS1+4qjIFfFp9z/I1Szcmyw8gRjZqjTqmAuf73uS
         iidysibF/XXiu8iwx/TzRvDQtatGJVYFI4hJqPIiK6yZRprhrczk67Ae3QbD4SxG9i
         W5wB2g58/GypPUyhomNljHsg52olEPHKNMUypU1ARLQqPyxeeHShhJ6LRYRRjBMI3c
         HOWxid8XerVk4whhJZO4wlfV2jYOX4zQiFuSQt73g4jDWtn9LYcxxaw4OJ1EMrn0f+
         vpPwbmpaX/RkYNjEOaUioV1VoVgBrlVNz5pHFIdRnSohd3o6BPDpNbXbiSlo7uqWLt
         twL0CVaQrCGzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Bizon <mbizon@freebox.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/29] mac80211: fix TCP performance on mesh interface
Date:   Mon, 20 Dec 2021 20:57:25 -0500
Message-Id: <20211221015751.116328-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

[ Upstream commit 48c06708e63e71b4395e4159797366aa03be10ff ]

sta is NULL for mesh point (resolved later), so sk pacing parameters
were not applied.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Link: https://lore.kernel.org/r/66f51659416ac35d6b11a313bd3ffe8b8a43dd55.camel@freebox.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0527bf41a32c7..0613b3ab523a5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4190,11 +4190,11 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	ieee80211_aggr_check(sdata, sta, skb);
 
+	sk_pacing_shift_update(skb->sk, sdata->local->hw.tx_sk_pacing_shift);
+
 	if (sta) {
 		struct ieee80211_fast_tx *fast_tx;
 
-		sk_pacing_shift_update(skb->sk, sdata->local->hw.tx_sk_pacing_shift);
-
 		fast_tx = rcu_dereference(sta->fast_tx);
 
 		if (fast_tx &&
-- 
2.34.1

