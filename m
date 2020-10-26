Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1543299FD8
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442329AbgJ0AZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410102AbgJZXxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C77221F8;
        Mon, 26 Oct 2020 23:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756411;
        bh=soRfHpe2eqzX2Zr8jNq6pTo3NpiHw9ikAtqo9u3Nq4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tua1lQel6sjBW21rsCoiibQPeEbVhxQbRudLCgOulQ22iDCE9Fwj3a3CeSONesb5H
         LI8k+dzgywjHtbletjGKY3lOVuHWRoFYLNpPW8UIg+kkGotJ2TDE/P5W2HDZXX0w9k
         NaVHduqBJtMGkh2Fc3vF5ZMumCjh4NgMzS64UD8w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 069/132] mac80211: add missing queue/hash initialization to 802.3 xmit
Date:   Mon, 26 Oct 2020 19:51:01 -0400
Message-Id: <20201026235205.1023962-69-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5f8d69eaab1915df97f4f2aca89ea16abdd092d5 ]

Fixes AQL for encap-offloaded tx

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20200908123702.88454-2-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3529d13680682..28758a5b5e888 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4212,6 +4212,12 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	if (is_zero_ether_addr(ra))
 		goto out_free;
 
+	if (local->ops->wake_tx_queue) {
+		u16 queue = __ieee80211_select_queue(sdata, sta, skb);
+		skb_set_queue_mapping(skb, queue);
+		skb_get_hash(skb);
+	}
+
 	multicast = is_multicast_ether_addr(ra);
 
 	if (sta)
-- 
2.25.1

