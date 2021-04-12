Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F7A35CE0D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245689AbhDLQlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344018AbhDLQge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB14561364;
        Mon, 12 Apr 2021 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244862;
        bh=9H8SH642Tv0t3TrlVYrw0+U2J0GZT5kXkFw7TJAp/TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKe9/om1VlOM+A7jd5LzrpByF/f6ii3U6lpEXop211T+rwZS+iskx7wH1jbS9cn+O
         a64b3FaKJ+RveLqk2UjIVOqxdLhY/3/+sq8UE+Zuahqea5l/eSSnjKy4aJ2gGs733O
         lSvkaUWTIyu3j2oaftlwfSwrwCV3+FOUVMGSRdhuGtxi0iY6fLu5tRVlgoFrXJ3owX
         PMzVY3xB5I3ULT5iba4xia6pkblHnx8S8AVHVtqAXhk6rnKiU39ng+n7NWfDm6L7cy
         rvkx5wavjDzMqcixk+sDZ8386xs27HcacFE8oKr8RDdj5lmfZGqa5ggeblu4IawgpB
         8P0oQPmlvKhyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhu <zhutong@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/23] neighbour: Disregard DEAD dst in neigh_update
Date:   Mon, 12 Apr 2021 12:27:17 -0400
Message-Id: <20210412162736.316026-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tong Zhu <zhutong@amazon.com>

[ Upstream commit d47ec7a0a7271dda08932d6208e4ab65ab0c987c ]

After a short network outage, the dst_entry is timed out and put
in DST_OBSOLETE_DEAD. We are in this code because arp reply comes
from this neighbour after network recovers. There is a potential
race condition that dst_entry is still in DST_OBSOLETE_DEAD.
With that, another neighbour lookup causes more harm than good.

In best case all packets in arp_queue are lost. This is
counterproductive to the original goal of finding a better path
for those packets.

I observed a worst case with 4.x kernel where a dst_entry in
DST_OBSOLETE_DEAD state is associated with loopback net_device.
It leads to an ethernet header with all zero addresses.
A packet with all zero source MAC address is quite deadly with
mac80211, ath9k and 802.11 block ack.  It fails
ieee80211_find_sta_by_ifaddr in ath9k (xmit.c). Ath9k flushes tx
queue (ath_tx_complete_aggr). BAW (block ack window) is not
updated. BAW logic is damaged and ath9k transmission is disabled.

Signed-off-by: Tong Zhu <zhutong@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 40d33431bc58..17997902d316 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1234,7 +1234,7 @@ int neigh_update(struct neighbour *neigh, const u8 *lladdr, u8 new,
 			 * we can reinject the packet there.
 			 */
 			n2 = NULL;
-			if (dst) {
+			if (dst && dst->obsolete != DST_OBSOLETE_DEAD) {
 				n2 = dst_neigh_lookup_skb(dst, skb);
 				if (n2)
 					n1 = n2;
-- 
2.30.2

