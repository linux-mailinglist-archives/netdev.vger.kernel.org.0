Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD68BF2585
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732931AbfKGCpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:45:15 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:51825 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGCpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 21:45:14 -0500
Received: by mail-pg1-f202.google.com with SMTP id w22so599022pgj.18
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 18:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8eP7AtOpuvyIaEw38M0m2PJkZdPXAW0s9vv1F1nADmg=;
        b=L/GbZn58L1+X+l1q0MQpVw89rcxYjSAG4LKnBeeTYXYfV/fxqZmx0Hzo0TDMISRMD5
         /RxJHHk5iOZN1QyYl+NHAsvbN8qrO8eKbZgCCEkuAUwhbMrMccV3bqwEp9k4Y+IlN4XB
         cW/OZdND3795GtKSycR1CXUPjPy982c8EBBkQReXV9K/S/sowXyRFY1hb5+adGImLJ75
         wUMTu/wp5fcb3CCtDjhUZLEnGKO/DF2TEymJ2XZ6GSZblJsjfv8B2tfn2CCNy9PXjMLb
         7f3RDlzGibVm9AivrB2+A4+cLFVnn/ZKEyIWg9TFbf9FVRjY7tssTdrNg2ICXYVDKfxP
         f6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8eP7AtOpuvyIaEw38M0m2PJkZdPXAW0s9vv1F1nADmg=;
        b=XaSvwovNEeT2bMJ/uHRIIUk3jydnIv3hV3hEhAoURwEEnNh+qCTyccOM/ZvkZz22Ur
         q0+H5E/3v038ywJlp6uB7AkZS7jw2W5CKBB1PSbTFjpWUr546a4NB25pg6sCag7E4LbJ
         dlQ+WLMMLn9vorFVsYp0qoOOIuGJ9DidJVevAcbK2oNTxsXOt3vcWl8SXA6Yh1Q8jf7T
         RRy82whc301Rh7W6LldBlNrCqf0f3L1U2h8NFEtM96q92Z8tRRXJwLOUA2e73hp1ZKoa
         EqyyVRse3ufpjtioh+/dlOqp8SYpuRKIbjtXWGuxNdjoasaeF4v/MYL8jZ237QSG7Kf0
         WB9Q==
X-Gm-Message-State: APjAAAVDNbWS2uAPxKEqwLY50+zWeQEqqgMzdsSdsEv0LrLp/kZj9iEH
        Nehr0ARVO8RN67v26Ss8ZhC0tqyJloCGrA==
X-Google-Smtp-Source: APXvYqwQ7Q3UvaXO1aNT12eB+2/iEeEshQpARkl/4ed0GQIN4JX70QadoTQ9dCXGD60F19n9bAq/RNHpOo8VkA==
X-Received: by 2002:a63:541e:: with SMTP id i30mr1521594pgb.130.1573094713326;
 Wed, 06 Nov 2019 18:45:13 -0800 (PST)
Date:   Wed,  6 Nov 2019 18:45:09 -0800
Message-Id: <20191107024509.87121-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net] ipv6: fixes rt6_probe() and fib6_nh->last_probe init
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While looking at a syzbot KCSAN report [1], I found multiple
issues in this code :

1) fib6_nh->last_probe has an initial value of 0.

   While probably okay on 64bit kernels, this causes an issue
   on 32bit kernels since the time_after(jiffies, 0 + interval)
   might be false ~24 days after boot (for HZ=1000)

2) The data-race found by KCSAN
   I could use READ_ONCE() and WRITE_ONCE(), but we also can
   take the opportunity of not piling-up too many rt6_probe_deferred()
   works by using instead cmpxchg() so that only one cpu wins the race.

[1]
BUG: KCSAN: data-race in find_match / find_match

write to 0xffff8880bb7aabe8 of 8 bytes by interrupt on cpu 1:
 rt6_probe net/ipv6/route.c:663 [inline]
 find_match net/ipv6/route.c:757 [inline]
 find_match+0x5bd/0x790 net/ipv6/route.c:733
 __find_rr_leaf+0xe3/0x780 net/ipv6/route.c:831
 find_rr_leaf net/ipv6/route.c:852 [inline]
 rt6_select net/ipv6/route.c:896 [inline]
 fib6_table_lookup+0x383/0x650 net/ipv6/route.c:2164
 ip6_pol_route+0xee/0x5c0 net/ipv6/route.c:2200
 ip6_pol_route_output+0x48/0x60 net/ipv6/route.c:2452
 fib6_rule_lookup+0x3d6/0x470 net/ipv6/fib6_rules.c:117
 ip6_route_output_flags_noref+0x16b/0x230 net/ipv6/route.c:2484
 ip6_route_output_flags+0x50/0x1a0 net/ipv6/route.c:2497
 ip6_dst_lookup_tail+0x25d/0xc30 net/ipv6/ip6_output.c:1049
 ip6_dst_lookup_flow+0x68/0x120 net/ipv6/ip6_output.c:1150
 inet6_csk_route_socket+0x2f7/0x420 net/ipv6/inet6_connection_sock.c:106
 inet6_csk_xmit+0x91/0x1f0 net/ipv6/inet6_connection_sock.c:121
 __tcp_transmit_skb+0xe81/0x1d60 net/ipv4/tcp_output.c:1169
 tcp_transmit_skb net/ipv4/tcp_output.c:1185 [inline]
 tcp_xmit_probe_skb+0x19b/0x1d0 net/ipv4/tcp_output.c:3735

read to 0xffff8880bb7aabe8 of 8 bytes by interrupt on cpu 0:
 rt6_probe net/ipv6/route.c:657 [inline]
 find_match net/ipv6/route.c:757 [inline]
 find_match+0x521/0x790 net/ipv6/route.c:733
 __find_rr_leaf+0xe3/0x780 net/ipv6/route.c:831
 find_rr_leaf net/ipv6/route.c:852 [inline]
 rt6_select net/ipv6/route.c:896 [inline]
 fib6_table_lookup+0x383/0x650 net/ipv6/route.c:2164
 ip6_pol_route+0xee/0x5c0 net/ipv6/route.c:2200
 ip6_pol_route_output+0x48/0x60 net/ipv6/route.c:2452
 fib6_rule_lookup+0x3d6/0x470 net/ipv6/fib6_rules.c:117
 ip6_route_output_flags_noref+0x16b/0x230 net/ipv6/route.c:2484
 ip6_route_output_flags+0x50/0x1a0 net/ipv6/route.c:2497
 ip6_dst_lookup_tail+0x25d/0xc30 net/ipv6/ip6_output.c:1049
 ip6_dst_lookup_flow+0x68/0x120 net/ipv6/ip6_output.c:1150
 inet6_csk_route_socket+0x2f7/0x420 net/ipv6/inet6_connection_sock.c:106
 inet6_csk_xmit+0x91/0x1f0 net/ipv6/inet6_connection_sock.c:121
 __tcp_transmit_skb+0xe81/0x1d60 net/ipv4/tcp_output.c:1169

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 18894 Comm: udevd Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: cc3a86c802f0 ("ipv6: Change rt6_probe to take a fib6_nh")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a63ff85fe14198fc23a5cbc7abcd107df5df00c8..e60bf8e7dd1aa8dafe8981ecef633e16e1a52d8d 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -621,6 +621,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 {
 	struct __rt6_probe_work *work = NULL;
 	const struct in6_addr *nh_gw;
+	unsigned long last_probe;
 	struct neighbour *neigh;
 	struct net_device *dev;
 	struct inet6_dev *idev;
@@ -639,6 +640,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 	nh_gw = &fib6_nh->fib_nh_gw6;
 	dev = fib6_nh->fib_nh_dev;
 	rcu_read_lock_bh();
+	last_probe = READ_ONCE(fib6_nh->last_probe);
 	idev = __in6_dev_get(dev);
 	neigh = __ipv6_neigh_lookup_noref(dev, nh_gw);
 	if (neigh) {
@@ -654,13 +656,15 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 				__neigh_set_probe_once(neigh);
 		}
 		write_unlock(&neigh->lock);
-	} else if (time_after(jiffies, fib6_nh->last_probe +
+	} else if (time_after(jiffies, last_probe +
 				       idev->cnf.rtr_probe_interval)) {
 		work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	}
 
-	if (work) {
-		fib6_nh->last_probe = jiffies;
+	if (!work || cmpxchg(&fib6_nh->last_probe,
+			     last_probe, jiffies) != last_probe) {
+		kfree(work);
+	} else {
 		INIT_WORK(&work->work, rt6_probe_deferred);
 		work->target = *nh_gw;
 		dev_hold(dev);
@@ -3383,6 +3387,9 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	int err;
 
 	fib6_nh->fib_nh_family = AF_INET6;
+#ifdef CONFIG_IPV6_ROUTER_PREF
+	fib6_nh->last_probe = jiffies;
+#endif
 
 	err = -ENODEV;
 	if (cfg->fc_ifindex) {
-- 
2.24.0.432.g9d3f5f5b63-goog

