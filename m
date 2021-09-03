Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098AD40042B
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 19:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350225AbhICRbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 13:31:48 -0400
Received: from s2.neomailbox.net ([5.148.176.60]:12265 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235684AbhICRbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 13:31:47 -0400
X-Greylist: delayed 1919 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2021 13:31:47 EDT
From:   Antonio Quartulli <a@unstable.cc>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, chopps@chopps.org,
        donaldsharp72@gmail.com, Antonio Quartulli <a@unstable.cc>
Subject: [PATCH net] ip/ip6_gre: use the same logic as SIT interfaces when computing v6LL address
Date:   Fri,  3 Sep 2021 18:58:42 +0200
Message-Id: <20210903165842.6149-1-a@unstable.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GRE interfaces are not Ether-like and therefore it is not
possible to generate the v6LL address the same way as (for example)
GRETAP devices.

With default settings, a GRE interface will attempt generating its v6LL
address using the EUI64 approach, but this will fail when the local
endpoint of the GRE tunnel is set to "any". In this case the GRE
interface will end up with no v6LL address, thus violating RFC4291.

SIT interfaces already implement a different logic to ensure that a v6LL
address is always computed.

Change the GRE v6LL generation logic to follow the same approach as SIT.
This way GRE interfaces will always have a v6LL address as well.

Behaviour of GRETAP interfaces has not been changed as they behave like
classic Ether-like interfaces.

To avoid code duplication sit_add_v4_addrs() has been renamed to
add_v4_addrs() and adapted to handle also the IP6GRE/GRE cases.

Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 net/ipv6/addrconf.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 17756f3ed33b..c6a90b7bbb70 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3092,19 +3092,22 @@ static void add_addr(struct inet6_dev *idev, const struct in6_addr *addr,
 	}
 }
 
-#if IS_ENABLED(CONFIG_IPV6_SIT)
-static void sit_add_v4_addrs(struct inet6_dev *idev)
+#if IS_ENABLED(CONFIG_IPV6_SIT) || IS_ENABLED(CONFIG_NET_IPGRE) || IS_ENABLED(CONFIG_IPV6_GRE)
+static void add_v4_addrs(struct inet6_dev *idev)
 {
 	struct in6_addr addr;
 	struct net_device *dev;
 	struct net *net = dev_net(idev->dev);
-	int scope, plen;
+	int scope, plen, offset = 0;
 	u32 pflags = 0;
 
 	ASSERT_RTNL();
 
 	memset(&addr, 0, sizeof(struct in6_addr));
-	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr, 4);
+	/* in case of IP6GRE the dev_addr is an IPv6 and therefore we use only the last 4 bytes */
+	if (idev->dev->addr_len == sizeof(struct in6_addr))
+		offset = sizeof(struct in6_addr) - 4;
+	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr + offset, 4);
 
 	if (idev->dev->flags&IFF_POINTOPOINT) {
 		addr.s6_addr32[0] = htonl(0xfe800000);
@@ -3342,8 +3345,6 @@ static void addrconf_dev_config(struct net_device *dev)
 	    (dev->type != ARPHRD_IEEE1394) &&
 	    (dev->type != ARPHRD_TUNNEL6) &&
 	    (dev->type != ARPHRD_6LOWPAN) &&
-	    (dev->type != ARPHRD_IP6GRE) &&
-	    (dev->type != ARPHRD_IPGRE) &&
 	    (dev->type != ARPHRD_TUNNEL) &&
 	    (dev->type != ARPHRD_NONE) &&
 	    (dev->type != ARPHRD_RAWIP)) {
@@ -3391,14 +3392,14 @@ static void addrconf_sit_config(struct net_device *dev)
 		return;
 	}
 
-	sit_add_v4_addrs(idev);
+	add_v4_addrs(idev);
 
 	if (dev->flags&IFF_POINTOPOINT)
 		addrconf_add_mroute(dev);
 }
 #endif
 
-#if IS_ENABLED(CONFIG_NET_IPGRE)
+#if IS_ENABLED(CONFIG_NET_IPGRE) || IS_ENABLED(CONFIG_IPV6_GRE)
 static void addrconf_gre_config(struct net_device *dev)
 {
 	struct inet6_dev *idev;
@@ -3411,7 +3412,13 @@ static void addrconf_gre_config(struct net_device *dev)
 		return;
 	}
 
-	addrconf_addr_gen(idev, true);
+	if (dev->type == ARPHRD_ETHER) {
+		addrconf_addr_gen(idev, true);
+		return;
+	}
+
+	add_v4_addrs(idev);
+
 	if (dev->flags & IFF_POINTOPOINT)
 		addrconf_add_mroute(dev);
 }
@@ -3587,7 +3594,8 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 			addrconf_sit_config(dev);
 			break;
 #endif
-#if IS_ENABLED(CONFIG_NET_IPGRE)
+#if IS_ENABLED(CONFIG_NET_IPGRE) || IS_ENABLED(CONFIG_IPV6_GRE)
+		case ARPHRD_IP6GRE:
 		case ARPHRD_IPGRE:
 			addrconf_gre_config(dev);
 			break;
-- 
2.32.0

