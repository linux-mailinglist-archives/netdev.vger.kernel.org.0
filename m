Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7AB4AE004
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 22:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfIIUoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 16:44:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56300 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbfIIUoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 16:44:18 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 686D53172D8B;
        Mon,  9 Sep 2019 20:44:17 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B917F5D6B7;
        Mon,  9 Sep 2019 20:44:13 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Guillaume Nault <gnault@redhat.com>, Julian Anastasov <ja@ssi.bg>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] ipv6: Don't use dst gateway directly in ip6_confirm_neigh()
Date:   Mon,  9 Sep 2019 22:44:06 +0200
Message-Id: <938b711c35ce3fa2b6f057cc23919e897a1e5c2b.1568061608.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 09 Sep 2019 20:44:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the equivalent of commit 2c6b55f45d53 ("ipv6: fix neighbour
resolution with raw socket") for ip6_confirm_neigh(): we can send a
packet with MSG_CONFIRM on a raw socket for a connected route, so the
gateway would be :: here, and we should pick the next hop using
rt6_nexthop() instead.

This was found by code review and, to the best of my knowledge, doesn't
actually fix a practical issue: the destination address from the packet
is not considered while confirming a neighbour, as ip6_confirm_neigh()
calls choose_neigh_daddr() without passing the packet, so there are no
similar issues as the one fixed by said commit.

A possible source of issues with the existing implementation might come
from the fact that, if we have a cached dst, we won't consider it,
while rt6_nexthop() takes care of that. I might just not be creative
enough to find a practical problem here: the only way to affect this
with cached routes is to have one coming from an ICMPv6 redirect, but
if the next hop is a directly connected host, there should be no
topology for which a redirect applies here, and tests with redirected
routes show no differences for MSG_CONFIRM (and MSG_PROBE) packets on
raw sockets destined to a directly connected host.

However, directly using the dst gateway here is not consistent anymore
with neighbour resolution, and, in general, as we want the next hop,
using rt6_nexthop() looks like the only sane way to fetch it.

Reported-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7a5d331cdefa..874641d4d2a1 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -227,7 +227,7 @@ static void ip6_confirm_neigh(const struct dst_entry *dst, const void *daddr)
 	struct net_device *dev = dst->dev;
 	struct rt6_info *rt = (struct rt6_info *)dst;
 
-	daddr = choose_neigh_daddr(&rt->rt6i_gateway, NULL, daddr);
+	daddr = choose_neigh_daddr(rt6_nexthop(rt, &in6addr_any), NULL, daddr);
 	if (!daddr)
 		return;
 	if (dev->flags & (IFF_NOARP | IFF_LOOPBACK))
-- 
2.20.1

