Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C49C1FB93A
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733170AbgFPQCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732840AbgFPQCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 12:02:03 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7D7C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:02:03 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ga6so1646564pjb.1
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yvH4tKpCIZN3i9yS1tqHno2lbmWIQ0tG2BKc67c2Fi0=;
        b=dkh2FvfwAgAG9DVEIzRDHxXwG1ZCmSDYbOG1wYoka7DYG4jS9aBNnoY4Uy3fqBvaNb
         d1yd1l6fnoNpMQvfWThWeVxDa6LAp7LkXXbmOGPNNpKy84OnJ68uCOrV4VVe/MWnsT6C
         3OjOvuYAuI3JNz6kYSe5G3IYUe6gedzOcg7o2JhTi7wbeKPSjuNhNc1EoyKmApLWs7Ll
         iIOziINQyo8wWGfirntAhsZVHtEd4IL+Nvz33/PDftgogv9AhJK3UBm0NdV3ERJ07Ng7
         xQ+Nb8n3niLB1NPB2/eDZmmgzF/Bx77rQGOGpANW1H28H6ktnBr7HMOjNpj1zL57yDRD
         2BVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yvH4tKpCIZN3i9yS1tqHno2lbmWIQ0tG2BKc67c2Fi0=;
        b=H++K8x+qAR5Rv2XIHbX6uvdjl740QQqf362XUXGELd4bdV/oydORKFEl3Ieqlc1TTx
         zzaj8+hRcoInDj3lgosssGKPmq9QIKT1dpOLWOHlde3F1ZiiXifbEDSVBwNPmQkdSfqT
         O34ibhEotkZa8WEUVGNVLB3XXRBa81/+lfMwOQ2Kzrn/ljJvVPas/G1oaLKrBY1O7beU
         F9TZKe/7Xo/EmdMHKolHI8lMug/nLIVh1w+Oi0EJVLT0TrDkNC2SrAMhP3o5Fq1fC9Db
         N1eX1rsVlzoyOQ4xkujVNzaU5vsfa6MaDumFazIbjc9gVUBK1vOgdmRSWZBbu9zcakEa
         /elg==
X-Gm-Message-State: AOAM5326N/05nUTBZdBc5ESm7nNHXFg5NrbOTttqXJuLE07xxmvdcH1D
        /5XvlrokRBNzeqozq6lKVxM=
X-Google-Smtp-Source: ABdhPJw/tis8qkh8fsnZQ3cu5zw37knAm1uXa8hUzSxpwXpf5Z//UASeYhVSsl7CXY85lridcYIgfQ==
X-Received: by 2002:a17:90a:1781:: with SMTP id q1mr3912636pja.8.1592323321549;
        Tue, 16 Jun 2020 09:02:01 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id ds11sm2928309pjb.0.2020.06.16.09.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 09:02:00 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, pshelar@nicira.com, eric.dumazet@gmail.com
Subject: [PATCH net v2] ip_tunnel: fix use-after-free in ip_tunnel_lookup()
Date:   Tue, 16 Jun 2020 16:01:53 +0000
Message-Id: <20200616160153.8479-1-ap420073@gmail.com>
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

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Do not add a new variable.

 net/ipv4/ip_tunnel.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index f4f1d11eab50..701f150f11e1 100644
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
@@ -1260,8 +1262,9 @@ void ip_tunnel_uninit(struct net_device *dev)
 
 	itn = net_generic(net, tunnel->ip_tnl_net_id);
 	/* fb_tunnel_dev will be unregisted in net-exit call. */
-	if (itn->fb_tunnel_dev != dev)
-		ip_tunnel_del(itn, netdev_priv(dev));
+	ip_tunnel_del(itn, netdev_priv(dev));
+	if (itn->fb_tunnel_dev == dev)
+		WRITE_ONCE(itn->fb_tunnel_dev, NULL);
 
 	dst_cache_reset(&tunnel->dst_cache);
 }
-- 
2.17.1

