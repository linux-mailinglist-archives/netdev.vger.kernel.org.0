Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281A31F9B78
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 17:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbgFOPGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 11:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730948AbgFOPGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 11:06:21 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0042C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 08:06:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u5so7727171pgn.5
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 08:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+fhlIkYbpaaYB4j9iL3ichkte9+iEISysEhJBZHu/JE=;
        b=Q3CI4WuCmsgnxLL3+2JXAL4OG+9EJIT9w91lu8Rf/hIYFvmxi5eou4977bidrpBelP
         f+j2M7qS21SXuljwLCpOfthYW2k3AZc0dHFg3EzPIlWEY29KG8NqfKFOX11vM4z6aP4M
         wVUZX/8GB+5KsRclp0w2p6U6CHRltH1x4KBTW5175n0lbExnN0X2e0HcndZ8z8lBxTzO
         kr7kRUwrQ6V2KIFZEi4/3S04IYzTAit/g4TBnC9uydfgWnjeFBxg7MIb9PnvVj18RKxy
         vNyokysXvBfdbAFIJy/99qJh4jPbiduTaWFB45VWLUhFSmyZlyYv9YFqbRy2D2sBf7qF
         oMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+fhlIkYbpaaYB4j9iL3ichkte9+iEISysEhJBZHu/JE=;
        b=m2Voy3ESg3ey3kDomD5tcmzS45rF5n5nYuPxzne+t+He/uQpyMqtnR8Gc/T6hdp+yF
         lQvx+FMa7O0x+gq8WjL5bLCFy3+kVQuBXTolz0tEIcVf3aBJ3eUkcxIhLjg5U+BcP1yz
         oQtzjEYUzFzOYH8NhfhfMaDA4nrHAKfOYUz5UCfFB8PPrUapjVRDxU2d/nAxzlDuIhsW
         xDljQ6/yzdqjtvbLYZE5dHCgEb7XcwT/14tXQMOM0N+PZ9p84VzKegC00w/irzRBE7jg
         dJ4teCa/TZmgUHtah1gTKZ404AJML0dMyP6aGJri7cYQ4+6MZOCEWKDRRd1kpwIA5Qzu
         x33Q==
X-Gm-Message-State: AOAM531+p+sDQJVs1JeV0GijvofC0Qivzj/b1WNat/Ps05zPSvxtVPs0
        VkrdmN0+0SkDtp/OMtUCm7DD5PPedH8=
X-Google-Smtp-Source: ABdhPJzSEXfhivSWyGcc5v++w0Fa0SWiyefcFOYVqyToCdTKJSAabpbMGerf3pml9JLQH7prLfREdA==
X-Received: by 2002:a63:ef03:: with SMTP id u3mr21319843pgh.254.1592233580451;
        Mon, 15 Jun 2020 08:06:20 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id h5sm14823523pfb.120.2020.06.15.08.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 08:06:19 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, pshelar@nicira.com
Subject: [PATCH net] ip_tunnel: fix use-after-free in ip_tunnel_lookup()
Date:   Mon, 15 Jun 2020 15:06:13 +0000
Message-Id: <20200615150613.21698-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the datapath, the ip_tunnel_lookup() is used and it internally uses
fallback tunnel device pointer, which is fb_tunnel_dev.
This pointer is protected by RTNL. It's not enough to be used
in the datapath.
So, this pointer would be used after an interface is deleted.
It eventually results in the use-after-free problem.

In order to avoid the problem, the new tunnel pointer variable is added,
which indicates a fallback tunnel device's tunnel pointer.
This is protected by both RTNL and RCU.
So, it's safe to be used in the datapath.

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
[  133.319668][    C3] BUG: KASAN: use-after-free in ip_tunnel_lookup+0x9d6/0xde0
[  133.343852][    C3] Read of size 4 at addr ffff8880b1701c84 by task hping3/1222
[  133.344724][    C3]
[  133.345002][    C3] CPU: 3 PID: 1222 Comm: hping3 Not tainted 5.7.0+ #591
[  133.345814][    C3] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  133.373336][    C3] Call Trace:
[  133.374792][    C3]  <IRQ>
[  133.375205][    C3]  dump_stack+0x96/0xdb
[  133.375789][    C3]  print_address_description.constprop.6+0x2cc/0x450
[  133.376720][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
[  133.377431][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
[  133.378130][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
[  133.378851][    C3]  kasan_report+0x154/0x190
[  133.379494][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
[  133.380200][    C3]  ip_tunnel_lookup+0x9d6/0xde0
[  133.380894][    C3]  __ipgre_rcv+0x1ab/0xaa0 [ip_gre]
[  133.381630][    C3]  ? rcu_read_lock_sched_held+0xc0/0xc0
[  133.382429][    C3]  gre_rcv+0x304/0x1910 [ip_gre]
[ ... ]

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/ip_tunnels.h |  1 +
 net/ipv4/ip_tunnel.c     | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 076e5d7db7d3..7442c517bb75 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -164,6 +164,7 @@ struct ip_tunnel_net {
 	struct rtnl_link_ops *rtnl_link_ops;
 	struct hlist_head tunnels[IP_TNL_HASH_SIZE];
 	struct ip_tunnel __rcu *collect_md_tun;
+	struct ip_tunnel __rcu *fb_tun;
 	int type;
 };
 
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index f4f1d11eab50..285b863e2fcc 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -162,8 +162,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 	if (t && t->dev->flags & IFF_UP)
 		return t;
 
-	if (itn->fb_tunnel_dev && itn->fb_tunnel_dev->flags & IFF_UP)
-		return netdev_priv(itn->fb_tunnel_dev);
+	t = rcu_dereference(itn->fb_tun);
+	if (t && t->dev->flags & IFF_UP)
+		return t;
 
 	return NULL;
 }
@@ -1059,6 +1060,7 @@ int ip_tunnel_init_net(struct net *net, unsigned int ip_tnl_net_id,
 		it_init_net = net_generic(&init_net, ip_tnl_net_id);
 		itn->type = it_init_net->type;
 		itn->fb_tunnel_dev = NULL;
+		RCU_INIT_POINTER(itn->fb_tun, NULL);
 		return 0;
 	}
 
@@ -1074,8 +1076,9 @@ int ip_tunnel_init_net(struct net *net, unsigned int ip_tnl_net_id,
 	if (!IS_ERR(itn->fb_tunnel_dev)) {
 		itn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
 		itn->fb_tunnel_dev->mtu = ip_tunnel_bind_dev(itn->fb_tunnel_dev);
-		ip_tunnel_add(itn, netdev_priv(itn->fb_tunnel_dev));
 		itn->type = itn->fb_tunnel_dev->type;
+		rcu_assign_pointer(itn->fb_tun,
+				   netdev_priv(itn->fb_tunnel_dev));
 	}
 	rtnl_unlock();
 
@@ -1262,6 +1265,8 @@ void ip_tunnel_uninit(struct net_device *dev)
 	/* fb_tunnel_dev will be unregisted in net-exit call. */
 	if (itn->fb_tunnel_dev != dev)
 		ip_tunnel_del(itn, netdev_priv(dev));
+	else
+		rcu_assign_pointer(itn->fb_tun, NULL);
 
 	dst_cache_reset(&tunnel->dst_cache);
 }
-- 
2.17.1

