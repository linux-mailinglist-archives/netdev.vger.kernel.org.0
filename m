Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDADC110D9
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 03:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfEBBRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 21:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbfEBBRe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 21:17:34 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B4522085A;
        Thu,  2 May 2019 01:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556759853;
        bh=MI4GiHRyFuoxJ7qSu+5vOU4uQv7NttY1eeOtpJKf3K0=;
        h=From:To:Cc:Subject:Date:From;
        b=T4mWd3x7ozohFe6C/yKDr5masxKrvmGhKzjIirOwQ5Xal4kshiI3uHukORWHBkw6r
         6HZ1EW76Wn3y5w8pQZg7CFO9/zaQUHvoM9SYUpAIX6mekjEU9c+TyZXsQmVBar66Wm
         0b1nAFVdotcF3b1Xo7p+ZLE57cWw4xAhYM4XOBrQ=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, alan.maguire@oracle.com,
        jwestfall@surrealistic.net, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit
Date:   Wed,  1 May 2019 18:18:42 -0700
Message-Id: <20190502011842.1645-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Commit cd9ff4de0107 changed the key for IFF_POINTOPOINT devices to
INADDR_ANY but neigh_xmit which is used for MPLS encapsulations was not
updated to use the altered key. The result is that every packet Tx does
a lookup on the gateway address which does not find an entry, a new one
is created only to find the existing one in the table right before the
insert since arp_constructor was updated to reset the primary key. This
is seen in the allocs and destroys counters:
    ip -s -4 ntable show | head -10 | grep alloc

which increase for each packet showing the unnecessary overhread.

Fix by having neigh_xmit use __ipv4_neigh_lookup_noref for NEIGH_ARP_TABLE.

Fixes: cd9ff4de0107 ("ipv4: Make neigh lookup keys for loopback/point-to-point devices be INADDR_ANY")
Reported-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/core/neighbour.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index aff051e5521d..9b9da5142613 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -31,6 +31,7 @@
 #include <linux/times.h>
 #include <net/net_namespace.h>
 #include <net/neighbour.h>
+#include <net/arp.h>
 #include <net/dst.h>
 #include <net/sock.h>
 #include <net/netevent.h>
@@ -2984,7 +2985,13 @@ int neigh_xmit(int index, struct net_device *dev,
 		if (!tbl)
 			goto out;
 		rcu_read_lock_bh();
-		neigh = __neigh_lookup_noref(tbl, addr, dev);
+		if (index == NEIGH_ARP_TABLE) {
+			u32 key = *((u32 *)addr);
+
+			neigh = __ipv4_neigh_lookup_noref(dev, key);
+		} else {
+			neigh = __neigh_lookup_noref(tbl, addr, dev);
+		}
 		if (!neigh)
 			neigh = __neigh_create(tbl, addr, dev, false);
 		err = PTR_ERR(neigh);
-- 
2.11.0

