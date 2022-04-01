Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B219E4EF660
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350423AbiDAPd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350281AbiDAO7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:59:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3D25A17E;
        Fri,  1 Apr 2022 07:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBAC260AC0;
        Fri,  1 Apr 2022 14:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9CFC34113;
        Fri,  1 Apr 2022 14:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824414;
        bh=B+1uOT2uRHCUb8oqAAcfNONXvthXbzl6xzeuzEvPZUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMAMxSPu9wiEtSOfXQLCXu24x/0Z7GrC61+12Xq29ffa5jNzK0qgPUiRykvrCdclF
         p8/SnDfttlee12OXMtz/y3NsS4Jup3ShyPkVH2NXKihXWUCsD8cpmIMOj/523BkIKz
         wbKcRqsKUlt6RohuvvkbGTsmE+vObiZRoqTjuPJoG/rRgr4gc1DXu5Y/MBTlW7NlwK
         gHxYYMc3Hd9VmNZ34PNT1hyGvhtyU+w3Ktob7rDyc7mpVZprP29RJ53Xf3ohMvq7cZ
         ogX6xNL5Ygj0YHfEZ+B6l5Fm21Wax1bdDmprWsvi1O0S4LARUKIldzqWO2n1x36xZ1
         SyAzVWrYO6QPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, Wang Hai <wanghai38@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/29] ipv4: Invalidate neighbour for broadcast address upon address addition
Date:   Fri,  1 Apr 2022 10:45:57 -0400
Message-Id: <20220401144612.1955177-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144612.1955177-1-sashal@kernel.org>
References: <20220401144612.1955177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 0c51e12e218f20b7d976158fdc18019627326f7a ]

In case user space sends a packet destined to a broadcast address when a
matching broadcast route is not configured, the kernel will create a
unicast neighbour entry that will never be resolved [1].

When the broadcast route is configured, the unicast neighbour entry will
not be invalidated and continue to linger, resulting in packets being
dropped.

Solve this by invalidating unresolved neighbour entries for broadcast
addresses after routes for these addresses are internally configured by
the kernel. This allows the kernel to create a broadcast neighbour entry
following the next route lookup.

Another possible solution that is more generic but also more complex is
to have the ARP code register a listener to the FIB notification chain
and invalidate matching neighbour entries upon the addition of broadcast
routes.

It is also possible to wave off the issue as a user space problem, but
it seems a bit excessive to expect user space to be that intimately
familiar with the inner workings of the FIB/neighbour kernel code.

[1] https://lore.kernel.org/netdev/55a04a8f-56f3-f73c-2aea-2195923f09d1@huawei.com/

Reported-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/arp.h       | 1 +
 net/ipv4/arp.c          | 9 +++++++--
 net/ipv4/fib_frontend.c | 5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index c8f580a0e6b1..dc6e9dd3e1e6 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -71,6 +71,7 @@ void arp_send(int type, int ptype, __be32 dest_ip,
 	      const unsigned char *src_hw, const unsigned char *th);
 int arp_mc_map(__be32 addr, u8 *haddr, struct net_device *dev, int dir);
 void arp_ifdown(struct net_device *dev);
+int arp_invalidate(struct net_device *dev, __be32 ip, bool force);
 
 struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
 			   struct net_device *dev, __be32 src_ip,
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index e90c89ef8c08..b18b2a3c54ad 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1114,13 +1114,18 @@ static int arp_req_get(struct arpreq *r, struct net_device *dev)
 	return err;
 }
 
-static int arp_invalidate(struct net_device *dev, __be32 ip)
+int arp_invalidate(struct net_device *dev, __be32 ip, bool force)
 {
 	struct neighbour *neigh = neigh_lookup(&arp_tbl, &ip, dev);
 	int err = -ENXIO;
 	struct neigh_table *tbl = &arp_tbl;
 
 	if (neigh) {
+		if ((neigh->nud_state & NUD_VALID) && !force) {
+			neigh_release(neigh);
+			return 0;
+		}
+
 		if (neigh->nud_state & ~NUD_NOARP)
 			err = neigh_update(neigh, NULL, NUD_FAILED,
 					   NEIGH_UPDATE_F_OVERRIDE|
@@ -1167,7 +1172,7 @@ static int arp_req_delete(struct net *net, struct arpreq *r,
 		if (!dev)
 			return -EINVAL;
 	}
-	return arp_invalidate(dev, ip);
+	return arp_invalidate(dev, ip, true);
 }
 
 /*
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 70e5e9e5d835..1885a2fbad86 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -917,9 +917,11 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 		return;
 
 	/* Add broadcast address, if it is explicitly assigned. */
-	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF))
+	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF)) {
 		fib_magic(RTM_NEWROUTE, RTN_BROADCAST, ifa->ifa_broadcast, 32,
 			  prim, 0);
+		arp_invalidate(dev, ifa->ifa_broadcast, false);
+	}
 
 	if (!ipv4_is_zeronet(prefix) && !(ifa->ifa_flags & IFA_F_SECONDARY) &&
 	    (prefix != addr || ifa->ifa_prefixlen < 32)) {
@@ -935,6 +937,7 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 				  prim, 0);
 			fib_magic(RTM_NEWROUTE, RTN_BROADCAST, prefix | ~mask,
 				  32, prim, 0);
+			arp_invalidate(dev, prefix | ~mask, false);
 		}
 	}
 }
-- 
2.34.1

