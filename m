Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3310F35AB
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbfKGR01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:26:27 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:44661 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730696AbfKGR00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:26:26 -0500
Received: by mail-pl1-f202.google.com with SMTP id h11so2106607plt.11
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 09:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aq15zjSCvMA8N1Qyl6ofsFQTaxp1nO50kYXcGtR0n/4=;
        b=TcV9b0OScvSx0v8SEbcvShXwj5++fPOR165cm0+ogTZ0VOGlp/TFBggvhxhHYfbzo+
         nAKIPBeVmFv0yj3pLxZWTIXzKqWqjMNh4DPQacx3PGN+ceqiRLBvQIFE5ty7hp/0txmf
         1LQmqXtRMq6GIK24ay9wzpBQuyFoDf4oK8GvUopDbNzjS41lO5BHAMVv8V834lLGK4h7
         UOlnK6+lAJvHHvz6zBhUTbknS1duMFrCPJwAinx13lWopZEs4oGCoJItw2AilJ0smLye
         iKoPig/NCmGPKbm5jieHfmNS4ZG6M3txK7mx3zFE7NXmPOIxWONdlFDJSquhmSFUCm62
         yAGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aq15zjSCvMA8N1Qyl6ofsFQTaxp1nO50kYXcGtR0n/4=;
        b=m3m/mERiZF1OSnSG8cQQMacI4dUbHcVyTycWlTFTfeYT0mEaOwImzmfcXz8Bs/yhUQ
         E+R8j6330Gy4Ycppv1DGfBF0RRQbHJe/eEwNcFi3vY5sRzMg1j6N6FR6mgzMK2nGOIRT
         yAz0/cABNfLZqOsiZQB35fAc6X4ILUte9r8NPPKHTbog3hZFdy6Ur1jQBAfiIrFfhlYU
         7fgOktGdfHJ3DAQz04i6SVHU9cTnCWFo8UXdBdJA0Nj3DlS5wiIOPAKMzwi1wp+rqwfD
         1fqfnxqvysJdvvpCelXlVGO/eeSs6rt3kLBgiSE0dKSCdd1y8dMfOeSX8FbzzPRViQKg
         aKTw==
X-Gm-Message-State: APjAAAXoFRSrj/6ZGjCAJsdIeXxBtxi+bIuGAaoYLTq+5yBIJ/Q8ounc
        /dvB/EKLRQg1HJRRNYJMYpdkESx+LckO8w==
X-Google-Smtp-Source: APXvYqw8g6cwkVdUSr8YE8g9B/WTcfdNRjBkQwHIqsQ9ckeXKZIzGzygU6SBAIBqV9U4Q2c2vqc5jIEcfgHcRQ==
X-Received: by 2002:a63:c40e:: with SMTP id h14mr5825621pgd.254.1573147583741;
 Thu, 07 Nov 2019 09:26:23 -0800 (PST)
Date:   Thu,  7 Nov 2019 09:26:19 -0800
Message-Id: <20191107172619.109818-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v2 net] ipv6: fixes rt6_probe() and fib6_nh->last_probe init
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
Fixes: f547fac624be ("ipv6: rate-limit probes for neighbourless routes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
v2: Added a 2nd Fixes: tag to help stable backports and Reviewed-by: from David Ahern

 net/ipv6/route.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index bf2dac4629423c6828932df5cdc7676d818a293a..edcb5254351837723800a2a85f55a99acd19dea3 100644
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
@@ -3380,6 +3384,9 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	int err;
 
 	fib6_nh->fib_nh_family = AF_INET6;
+#ifdef CONFIG_IPV6_ROUTER_PREF
+	fib6_nh->last_probe = jiffies;
+#endif
 
 	err = -ENODEV;
 	if (cfg->fc_ifindex) {
-- 
2.24.0.432.g9d3f5f5b63-goog

