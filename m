Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450A935CBE9
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244419AbhDLQZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243779AbhDLQYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E30E961373;
        Mon, 12 Apr 2021 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244660;
        bh=QXEEnIMFb1usIywqSO4YVq+/fmvHo02LzcJsp6j+few=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRjck42w/zUQYVhLZmImAbFtCrNZBD1W1mj2ttF9+t7/vnMnkLbCwsO+0HPIbykly
         zVo6IeHcoJOyIWUmDku0ZUBsY9Yb73gtlCZ2rzK25yomZhsN2NsRumB1nECNibF6Zn
         KDkdIshlremVhmAHgD6F5APooSZVl+r8zImFREROAUEG2XysJ3HCZ259cuwkpjUXbA
         ArWIZ0MOgXIB7i3GolIb2GyqLuNBDtU8YN5N4kOeQ5SYKIfNbd6cx9I0umwncfNq7p
         QmwIZOWpmPcX3hBD2UB5sebVpX/wrq0xOGgiX1vnOkt6EwfJqZwfTYYu6O4sfg6VSr
         k+dxPtROnA54g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhu <zhutong@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/46] neighbour: Disregard DEAD dst in neigh_update
Date:   Mon, 12 Apr 2021 12:23:30 -0400
Message-Id: <20210412162401.314035-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
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
index 2fe4bbb6b80c..8339978d46ff 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1380,7 +1380,7 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
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

