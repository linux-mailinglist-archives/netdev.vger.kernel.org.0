Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72BA1FBC20
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgFPQwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbgFPQwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 12:52:01 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EA5C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:52:01 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d4so2443929pgk.4
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EK+49izKt+QWisZrJi0mBVOntfdoMSIU9HUT2aSmqcU=;
        b=rQqTkLRFW5589+Hg2b5SWWq0zEwgQqTiEXsi6lFug7eBUOLzwcwDF1PUMchm+soqqZ
         HYeUHBPPEf9xHcPBGmlfMHtsCQtesdbowtp9FMJdcBHxr39u9r5GreGbBkm5tVhzfXo7
         20wiGbgafUQIrhyBL2RXLbghoCULCbC/0FII0DkYZC6UOm4kwJTlvOLwhu7e4Df5rQps
         mC/WcliwqR5/wxOIX2nlUES8Am63Klt/hSMNtVY1ta6kRQDF+6oZ6E6gmWzD5N7q6LY0
         rb6+kC22qsvdkBBimpXo3nbouPdVbpGWvCiPkkrwaFJnpuHo/l64G4E7aPAe7oLpbZ9M
         ZLLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EK+49izKt+QWisZrJi0mBVOntfdoMSIU9HUT2aSmqcU=;
        b=dCfKDQa8+JHqxfIW0pYRBKNFPhfdcBi2JFp5NQHU5vp7+E3G8L55PYOeQ3wzn2LB+t
         a1XYrLiRjpPLQ4kUcnQu2S6Ng+QvHorb4Av6S8GRiM8Q9vUwaUVgT3GBN+gYLj1/izVg
         Ec1XnGxQ1h0JynrZo5npeM3LBCSHUdQDO7iN+jI84GoEnuoEDp9T+prNLyCbhQUgL9Dq
         mLmU9FHteZklkCzEaOWcqkxjE1FHrZN7BZRLt4lMhlv/LOs8AOC34in2Y3QDaMU7wcyv
         RM30L6FXVLKQhH6FzR7Qv9xAyMs7WXSkdQMbQHjEGf3hRpGIxiy65di6nGcLMibaGNaE
         6GRA==
X-Gm-Message-State: AOAM532mLzSkQmz7HT5GRCYBwXPct4GK5nB7oR+oS8snlU9D0y28JavB
        i32YtLdO7K3XVg/vk9U/JMO0ijlHkxQ=
X-Google-Smtp-Source: ABdhPJzb933pAOIzUoVVjRwiWPlDeyHgRKuQGMbQ/pkyv/It/fG/cYMWUwoBFKrRZcbFZc9de+kL5Q==
X-Received: by 2002:a62:dd97:: with SMTP id w145mr2772762pff.23.1592326320460;
        Tue, 16 Jun 2020 09:52:00 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id n189sm17950711pfn.108.2020.06.16.09.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 09:51:59 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, pshelar@nicira.com, eric.dumazet@gmail.com
Subject: [PATCH net v3] ip_tunnel: fix use-after-free in ip_tunnel_lookup()
Date:   Tue, 16 Jun 2020 16:51:51 +0000
Message-Id: <20200616165151.19540-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the datapath, the ip_tunnel_lookup() is used and it internally uses
fallback tunnel device pointer, which is fb_tunnel_dev.
This pointer variable should be set to NULL when a fb interface is deleted.
But there is no routine to set fb_tunnel_dev pointer to NULL.
So, this pointer will be still used after interface is deleted and
it eventually results in the use-after-free problem.

Test commands:
    ip netns add A
    ip netns add B
    ip link add eth0 type veth peer name eth1
    ip link set eth0 netns A
    ip link set eth1 netns B

    ip netns exec A ip link set lo up
    ip netns exec A ip link set eth0 up
    ip netns exec A ip link add gre1 type gre local 10.0.0.1 \
	    remote 10.0.0.2
    ip netns exec A ip link set gre1 up
    ip netns exec A ip a a 10.0.100.1/24 dev gre1
    ip netns exec A ip a a 10.0.0.1/24 dev eth0

    ip netns exec B ip link set lo up
    ip netns exec B ip link set eth1 up
    ip netns exec B ip link add gre1 type gre local 10.0.0.2 \
	    remote 10.0.0.1
    ip netns exec B ip link set gre1 up
    ip netns exec B ip a a 10.0.100.2/24 dev gre1
    ip netns exec B ip a a 10.0.0.2/24 dev eth1
    ip netns exec A hping3 10.0.100.2 -2 --flood -d 60000 &
    ip netns del B

Splat looks like:
[   77.793450][    C3] ==================================================================
[   77.794702][    C3] BUG: KASAN: use-after-free in ip_tunnel_lookup+0xcc4/0xf30
[   77.795573][    C3] Read of size 4 at addr ffff888060bd9c84 by task hping3/2905
[   77.796398][    C3]
[   77.796664][    C3] CPU: 3 PID: 2905 Comm: hping3 Not tainted 5.8.0-rc1+ #616
[   77.797474][    C3] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   77.798453][    C3] Call Trace:
[   77.798815][    C3]  <IRQ>
[   77.799142][    C3]  dump_stack+0x9d/0xdb
[   77.799605][    C3]  print_address_description.constprop.7+0x2cc/0x450
[   77.800365][    C3]  ? ip_tunnel_lookup+0xcc4/0xf30
[   77.800908][    C3]  ? ip_tunnel_lookup+0xcc4/0xf30
[   77.801517][    C3]  ? ip_tunnel_lookup+0xcc4/0xf30
[   77.802145][    C3]  kasan_report+0x154/0x190
[   77.802821][    C3]  ? ip_tunnel_lookup+0xcc4/0xf30
[   77.803503][    C3]  ip_tunnel_lookup+0xcc4/0xf30
[   77.804165][    C3]  __ipgre_rcv+0x1ab/0xaa0 [ip_gre]
[   77.804862][    C3]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   77.805621][    C3]  gre_rcv+0x304/0x1910 [ip_gre]
[   77.806293][    C3]  ? lock_acquire+0x1a9/0x870
[   77.806925][    C3]  ? gre_rcv+0xfe/0x354 [gre]
[   77.807559][    C3]  ? erspan_xmit+0x2e60/0x2e60 [ip_gre]
[   77.808305][    C3]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   77.809032][    C3]  ? rcu_read_lock_held+0x90/0xa0
[   77.809713][    C3]  gre_rcv+0x1b8/0x354 [gre]
[ ... ]

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3:
 - Remove invalid comment.
 - Update commit message.

v1 -> v2:
 - Do not add a new variable.

 net/ipv4/ip_tunnel.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index f4f1d11eab50..0c1f36404471 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -85,9 +85,10 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 				   __be32 remote, __be32 local,
 				   __be32 key)
 {
-	unsigned int hash;
 	struct ip_tunnel *t, *cand = NULL;
 	struct hlist_head *head;
+	struct net_device *ndev;
+	unsigned int hash;
 
 	hash = ip_tunnel_hash(key, remote);
 	head = &itn->tunnels[hash];
@@ -162,8 +163,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 	if (t && t->dev->flags & IFF_UP)
 		return t;
 
-	if (itn->fb_tunnel_dev && itn->fb_tunnel_dev->flags & IFF_UP)
-		return netdev_priv(itn->fb_tunnel_dev);
+	ndev = READ_ONCE(itn->fb_tunnel_dev);
+	if (ndev && ndev->flags & IFF_UP)
+		return netdev_priv(ndev);
 
 	return NULL;
 }
@@ -1259,9 +1261,9 @@ void ip_tunnel_uninit(struct net_device *dev)
 	struct ip_tunnel_net *itn;
 
 	itn = net_generic(net, tunnel->ip_tnl_net_id);
-	/* fb_tunnel_dev will be unregisted in net-exit call. */
-	if (itn->fb_tunnel_dev != dev)
-		ip_tunnel_del(itn, netdev_priv(dev));
+	ip_tunnel_del(itn, netdev_priv(dev));
+	if (itn->fb_tunnel_dev == dev)
+		WRITE_ONCE(itn->fb_tunnel_dev, NULL);
 
 	dst_cache_reset(&tunnel->dst_cache);
 }
-- 
2.17.1

