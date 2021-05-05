Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92933374262
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbhEEQqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235485AbhEEQoH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:44:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15F57617C9;
        Wed,  5 May 2021 16:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232520;
        bh=BVWlPA/KL4xZMewJbjfvM8i8Zx/VWdWhlC9t6J9uyzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naA0mf822zF0jt+BmfxGO3CQlnvSKkUC+yMexZ7BHu1jy6v0XfmaEBwwEfQ/EG/w0
         DgigfkPPnx6wt8DxPHS655QLit2SomhbKbjvgA7yWrTSFx3ou9/iNeLTUD+rTYBLrw
         iBZhvTVQsM2wfeB37PW7eZ/rnLknaD9h1APsY5Kgf1IqV3gh2ZXPlY7fxKh6ZnmJ7/
         rT2snT9qikwYM3CdhfNiJBBKngbhJYhdR3qwu1qZL4od3R6DxQ4isTvcA7eVWJC0C2
         ZxWM2xvBP9i+ala8vTJ3TEk6CR2ux5oV11dOW/0Vic/VGPfgD8uKqji/u6BYYM7Z7d
         mvwWBvCeZR67w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 046/104] mac80211: Set priority and queue mapping for injected frames
Date:   Wed,  5 May 2021 12:33:15 -0400
Message-Id: <20210505163413.3461611-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 96a7109a16665255b65d021e24141c2edae0e202 ]

Some drivers, for example mt76, use the skb priority field, and
expects that to be consistent with the skb queue mapping. On some
frame injection code paths that was not true, and it broke frame
injection. Now the skb queue mapping is set according to the skb
priority value when the frame is injected. The skb priority value
is also derived from the frame data for all frame types, as it
was done prior to commit dbd50a851c50 (only allocate one queue
when using iTXQs). Fixes frame injection with the mt76 driver on
MT7610E chipset.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Link: https://lore.kernel.org/r/20210401164455.978245-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 64fae4f645f5..f6bfa0ce262c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2269,17 +2269,6 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 						    payload[7]);
 	}
 
-	/* Initialize skb->priority for QoS frames. If the DONT_REORDER flag
-	 * is set, stick to the default value for skb->priority to assure
-	 * frames injected with this flag are not reordered relative to each
-	 * other.
-	 */
-	if (ieee80211_is_data_qos(hdr->frame_control) &&
-	    !(info->control.flags & IEEE80211_TX_CTRL_DONT_REORDER)) {
-		u8 *p = ieee80211_get_qos_ctl(hdr);
-		skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
-	}
-
 	rcu_read_lock();
 
 	/*
@@ -2343,6 +2332,15 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 
 	info->band = chandef->chan->band;
 
+	/* Initialize skb->priority according to frame type and TID class,
+	 * with respect to the sub interface that the frame will actually
+	 * be transmitted on. If the DONT_REORDER flag is set, the original
+	 * skb-priority is preserved to assure frames injected with this
+	 * flag are not reordered relative to each other.
+	 */
+	ieee80211_select_queue_80211(sdata, skb, hdr);
+	skb_set_queue_mapping(skb, ieee80211_ac_from_tid(skb->priority));
+
 	/* remove the injection radiotap header */
 	skb_pull(skb, len_rthdr);
 
-- 
2.30.2

