Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B8B35CD88
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244509AbhDLQhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244992AbhDLQdk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:33:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD403613C5;
        Mon, 12 Apr 2021 16:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244796;
        bh=Yh13L35ZM6esCqrd244WMvkZU0q1hVTkp93i3JHN/mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFGNPWP7bbAnC1dtN6ia7iEXR9XdTBGkTvBIzf+kt228jJPY3vgu1HscZU4SkSQSj
         Tc8exncKAy3VEoxO+QDQ0gonqCxdNMMWmeQ5FhUyvjAoQlEKeLhGZ1RVasigC/jygc
         5tb9vmtnighAdi2ufKpcAFfmdCYPfu+8o8DB0BPZrrGvy9nMZlstAxS3++IzrjaUw8
         4CWz667UR4fNYR0FuL7zQg+Z4BMigdEI8lb5hNd8VbdgTR1qWoujvtkY0c1FRqbEPU
         MpV6w1bhpO71t3TVDG5dB44+u7RDVcNYiMeo0j4UeBsOx7+ApaF5Qlumnix5LISHbL
         AUSPc9QwqgKLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhu <zhutong@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/25] neighbour: Disregard DEAD dst in neigh_update
Date:   Mon, 12 Apr 2021 12:26:09 -0400
Message-Id: <20210412162630.315526-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162630.315526-1-sashal@kernel.org>
References: <20210412162630.315526-1-sashal@kernel.org>
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
index 20f6c634ad68..f9aa9912f940 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1266,7 +1266,7 @@ int neigh_update(struct neighbour *neigh, const u8 *lladdr, u8 new,
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

