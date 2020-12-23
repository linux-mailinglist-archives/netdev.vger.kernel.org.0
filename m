Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE57F2E1702
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbgLWDEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728543AbgLWCTO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9217A2312E;
        Wed, 23 Dec 2020 02:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689914;
        bh=RdtcM6zViuzlK2Nkml3KLpxbfyMc0DyP2XN/pSqi9Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRX5gJNg4nHXjBAYzkc7vqiiWRCGI5ztss5klPlveW8mE2UHP7R4iqDnes49BpFqh
         wvj2Z/ZoOik0laJVP2qsrR7/UnImFnM9MB5lFwCK3w8l5BHDJZTP3qs6TeGLlxHGxd
         7dRIbqArTZQQ3W3KOJ4bTQPCx3rifAVsjkFhlb/ptF1A8FZOdV+t1uY5HcQSUr9qO9
         zSMhkeK26aixkRlTDdUYWDhJ1679xcm6/Hn/hgPO2Hl299OrhWvbkrfQWemJcY/hHs
         WG60upA51w/ofTYauBzOvx5+BkLnfv/M8w5n3vZAhl4ttQph2h6upyL9j/wqrrv9rg
         Qf7YS3py7h6KA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 015/130] mac80211: don't overwrite QoS TID of injected frames
Date:   Tue, 22 Dec 2020 21:16:18 -0500
Message-Id: <20201223021813.2791612-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>

[ Upstream commit 527d675969a1dff17baa270d4447ac1c87058299 ]

Currently ieee80211_set_qos_hdr sets the QoS TID of all frames based
on the value assigned to skb->priority. This means it will also
overwrite the QoS TID of injected frames. The commit 753ffad3d624
("mac80211: fix TID field in monitor mode transmit") prevented
injected frames from being modified because of this by setting
skb->priority to the TID of the injected frame, which assured the
QoS TID will not be changed to a different value. Unfortunately,
this workaround complicates the handling of injected frames because
we can't set skb->priority without affecting the TID value in the
QoS field of injected frames.

To avoid this, and to simplify the next patch, detect if a frame is
injected in ieee80211_set_qos_hdr and if so do not change its QoS
field.

Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Link: https://lore.kernel.org/r/20201104061823.197407-4-Mathy.Vanhoef@kuleuven.be
[fix typos in commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c  | 5 +----
 net/mac80211/wme.c | 8 ++++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 30a0c7c6224b3..11085a4b5ee3a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2280,10 +2280,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 						    payload[7]);
 	}
 
-	/*
-	 * Initialize skb->priority for QoS frames. This is put in the TID field
-	 * of the frame before passing it to the driver.
-	 */
+	/* Initialize skb->priority for QoS frames */
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		u8 *p = ieee80211_get_qos_ctl(hdr);
 		skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 72920d82928c4..8cd157e67fc77 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -249,6 +249,14 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 
 	p = ieee80211_get_qos_ctl(hdr);
 
+	/* don't overwrite the QoS field of injected frames */
+	if (info->flags & IEEE80211_TX_CTL_INJECTED) {
+		/* do take into account Ack policy of injected frames */
+		if (*p & IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
+			info->flags |= IEEE80211_TX_CTL_NO_ACK;
+		return;
+	}
+
 	/* set up the first byte */
 
 	/*
-- 
2.27.0

