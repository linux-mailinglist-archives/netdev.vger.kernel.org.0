Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CA43424BB
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhCSSeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:34:06 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:34715 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhCSSdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 14:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1616178834; x=1647714834;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=MFCVtENjBI3XFTYruH+r3sdrMzrerZrdEDh6dTMmGfU=;
  b=Owgj/AGX8LAonSVhXrxbTNyNnpNJ1U4bRYhsFvDfZfbtgvEGL70ZDriz
   PBs5mJWV4UejFIXMiiIBc3xhvaYChPjJdfI6xMwlELTtS4ikLQkeCzhhB
   35guWMK6FkLiaqfazZXrb6C8N5OD/l0YKz7SjjrmbQ8CzZOlVmSo0MaYF
   w=;
X-IronPort-AV: E=Sophos;i="5.81,262,1610409600"; 
   d="scan'208";a="94599431"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 19 Mar 2021 18:33:44 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id 5426D100AB0;
        Fri, 19 Mar 2021 18:33:43 +0000 (UTC)
Received: from EX13D06UEA002.ant.amazon.com (10.43.61.198) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 19 Mar 2021 18:33:42 +0000
Received: from ucf43ac461c9a53.ant.amazon.com (10.43.161.86) by
 EX13D06UEA002.ant.amazon.com (10.43.61.198) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 19 Mar 2021 18:33:40 +0000
Date:   Fri, 19 Mar 2021 14:33:37 -0400
From:   Tong Zhu <zhutong@amazon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <zhutong@amazon.com>
Subject: [PATCH] neighbour: Disregard DEAD dst in neigh_update
Message-ID: <20210319183327.GA25778@ucf43ac461c9a53.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.86]
X-ClientProxiedBy: EX13D41UWB002.ant.amazon.com (10.43.161.109) To
 EX13D06UEA002.ant.amazon.com (10.43.61.198)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index e2982b3970b8..8379719d1dce 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1379,7 +1379,7 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
 			 * we can reinject the packet there.
 			 */
 			n2 = NULL;
-			if (dst) {
+			if (dst && dst->obsolete != DST_OBSOLETE_DEAD) {
 				n2 = dst_neigh_lookup_skb(dst, skb);
 				if (n2)
 					n1 = n2;
-- 
2.17.1

