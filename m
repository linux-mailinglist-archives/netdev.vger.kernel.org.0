Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2382E1781
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgLWCSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:18:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbgLWCSX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2A472222A;
        Wed, 23 Dec 2020 02:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689836;
        bh=55FbdZozjY9wsOB2yAn394jO2YjjJI+sp8UYjuYc7aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdHLz//Al/C241hU3rDkSn10rFYH9hiA4pdHL0GR3DtXbLpFxxqVDR4TTLZXubdEC
         xBA/C2lpN1fJLHh4TACxlrZTCQr4kqKXh/x+/aR0991oPjm5IrCboXGNC4GEOFqJVu
         cQ/82fCrwDXGR6e4TCu+8s5oV4QayAmLxoEJiAH6HYK+REaju0ZTJsSBbbJqsCczPa
         +4S2u1M5l5ByVsFxDer8Muug10uE2MvqRUrfoI5/I7+v0fAT4b4GTlfjS8N6sJQ1Ep
         SFyU5EeHAYS8/GgFq8tMWfs6HImCKR3M6yc2XJuJ1+fleiUNZjg9WMUh8cnE4nNRBd
         THWO3sbxPfF2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 037/217] mac80211: don't overwrite QoS TID of injected frames
Date:   Tue, 22 Dec 2020 21:13:26 -0500
Message-Id: <20201223021626.2790791-37-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
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
index 56a4d0d20a267..bedb9d85f3d65 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2279,10 +2279,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
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
index 2fb99325135a0..b74cd9bd5f95e 100644
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

