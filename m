Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA82E4E75
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440445AbfJYOHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505063AbfJYNz3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95462222CB;
        Fri, 25 Oct 2019 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011728;
        bh=9Lw0EJcXdnsqEQSTs6tupYCgekSutiDucheLmdlMFDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3V0p5RbodURsIF5p4pTu6QXwhpoOwKIvplDXVvvVWbS39euu8Lgk3xzZpg8YtOMx
         B7jDhw4rRevxK3ybE5PBDMtWiHkoHZY+f7Q9HtToSYGHk0UF9diRB9vPq8MnQZgg67
         cFrGAxwL3d7cISZ7AoNWj+MnBL9PxrhRspXtzZOM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mahesh Bandewar <maheshb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 12/33] blackhole_netdev: fix syzkaller reported issue
Date:   Fri, 25 Oct 2019 09:54:44 -0400
Message-Id: <20191025135505.24762-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135505.24762-1-sashal@kernel.org>
References: <20191025135505.24762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>

[ Upstream commit b0818f80c8c1bc215bba276bd61c216014fab23b ]

While invalidating the dst, we assign backhole_netdev instead of
loopback device. However, this device does not have idev pointer
and hence no ip6_ptr even if IPv6 is enabled. Possibly this has
triggered the syzbot reported crash.

The syzbot report does not have reproducer, however, this is the
only device that doesn't have matching idev created.

Crash instruction is :

static inline bool ip6_ignore_linkdown(const struct net_device *dev)
{
        const struct inet6_dev *idev = __in6_dev_get(dev);

        return !!idev->cnf.ignore_routes_with_linkdown; <= crash
}

Also ipv6 always assumes presence of idev and never checks for it
being NULL (as does the above referenced code). So adding a idev
for the blackhole_netdev to avoid this class of crashes in the future.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c |  7 ++++++-
 net/ipv6/route.c    | 15 ++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 34ccef18b40e6..4c87594d1389d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6996,7 +6996,7 @@ static struct rtnl_af_ops inet6_ops __read_mostly = {
 
 int __init addrconf_init(void)
 {
-	struct inet6_dev *idev;
+	struct inet6_dev *idev, *bdev;
 	int i, err;
 
 	err = ipv6_addr_label_init();
@@ -7036,10 +7036,14 @@ int __init addrconf_init(void)
 	 */
 	rtnl_lock();
 	idev = ipv6_add_dev(init_net.loopback_dev);
+	bdev = ipv6_add_dev(blackhole_netdev);
 	rtnl_unlock();
 	if (IS_ERR(idev)) {
 		err = PTR_ERR(idev);
 		goto errlo;
+	} else if (IS_ERR(bdev)) {
+		err = PTR_ERR(bdev);
+		goto errlo;
 	}
 
 	ip6_route_init_special_entries();
@@ -7124,6 +7128,7 @@ void addrconf_cleanup(void)
 		addrconf_ifdown(dev, 1);
 	}
 	addrconf_ifdown(init_net.loopback_dev, 2);
+	addrconf_ifdown(blackhole_netdev, 2);
 
 	/*
 	 *	Check hash table.
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 546088e508151..23164ac42826e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -155,10 +155,9 @@ void rt6_uncached_list_del(struct rt6_info *rt)
 
 static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
 {
-	struct net_device *loopback_dev = net->loopback_dev;
 	int cpu;
 
-	if (dev == loopback_dev)
+	if (dev == net->loopback_dev)
 		return;
 
 	for_each_possible_cpu(cpu) {
@@ -171,7 +170,7 @@ static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
 			struct net_device *rt_dev = rt->dst.dev;
 
 			if (rt_idev->dev == dev) {
-				rt->rt6i_idev = in6_dev_get(loopback_dev);
+				rt->rt6i_idev = in6_dev_get(blackhole_netdev);
 				in6_dev_put(rt_idev);
 			}
 
@@ -386,13 +385,11 @@ static void ip6_dst_ifdown(struct dst_entry *dst, struct net_device *dev,
 {
 	struct rt6_info *rt = (struct rt6_info *)dst;
 	struct inet6_dev *idev = rt->rt6i_idev;
-	struct net_device *loopback_dev =
-		dev_net(dev)->loopback_dev;
 
-	if (idev && idev->dev != loopback_dev) {
-		struct inet6_dev *loopback_idev = in6_dev_get(loopback_dev);
-		if (loopback_idev) {
-			rt->rt6i_idev = loopback_idev;
+	if (idev && idev->dev != dev_net(dev)->loopback_dev) {
+		struct inet6_dev *ibdev = in6_dev_get(blackhole_netdev);
+		if (ibdev) {
+			rt->rt6i_idev = ibdev;
 			in6_dev_put(idev);
 		}
 	}
-- 
2.20.1

