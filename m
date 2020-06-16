Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A3E1FB978
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732421AbgFPQEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731339AbgFPQEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 12:04:08 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEACCC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:04:07 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id h95so1808848pje.4
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yT6Z1OTi5mHwVMpenyr+HFOUuNQrNEy8iLf8X7i7M8c=;
        b=qqQ4ztXk83H2k0an5Xc+bGtBCu/dCmq14YDs7VBXo8uel5uEm1wEnTa8Q+7ii1f0oN
         aYqHzKsdL4pAHq2RRWZG7ACai30Q5UxzXBboh1AxEfiDUshM25EiF1oYE/MAKiHGRW/a
         jwwgXrsuhpd47EdgEpVCnKBScuAGCbAuBYO8w3SV+TOA2a4TBCy9SnO20gfgaHbXKCkt
         j/U5bGeQ9qd1O3qpWt91d8mhOxq2D3zJT/mV0YSpQrkMUDqMiDcKJhlFWUaE2Z8o0w72
         K59qIe0tbDaTdRcyjMeOLutjU3o8g0YRKoNRpTKnPm59IEWOqc4Y8+MjTE4XvLZGuP5r
         A3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yT6Z1OTi5mHwVMpenyr+HFOUuNQrNEy8iLf8X7i7M8c=;
        b=N7vzn9iUwwMMDWpBJ/6eKKadKCpLiSlFcQQuJqhjHCeWe0eCz5SH8Obhfc9jF/LbDw
         +8XCp8/3YPBkuyPr4Ci3qLU4PRTEEki6JMOp5x5TQELTPiBbekbR/NHx5crgpUMZ8MOG
         0gws7HYrwF0iu7k4Pq3THVXEX0YiBkrWuBUmv3+XjPeCTSes7zWaNHrQBgEAML17KYZE
         zCBr19O8OpiLnT81hHQDT9OIRWqvr/FeaPKrHpxSPdDkJfAm97lM2FE0VOHeGlrtTiV0
         SFG8DMAPIQaroWijGDZ3znHjim+nvPoALpHWs1kFJtVOHUgpUjp8TL2Wh1EIdLSZaFwP
         +eTA==
X-Gm-Message-State: AOAM530rd04gre0gJksBcoOr0bxrITtyNhFbcBTrWr38b+TfPYsUU+4v
        /uhovo2P2ZtpKuffvPHbos2V1z7aNgE=
X-Google-Smtp-Source: ABdhPJxaRClZeSsqwK2Da8qbrG6QvanDAFyfnCvkLY3n+JEr2B+fFTwH52VyqFV4AhtCR1zJH4gK2Q==
X-Received: by 2002:a17:902:988e:: with SMTP id s14mr2577903plp.142.1592323447212;
        Tue, 16 Jun 2020 09:04:07 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id r4sm4270410pgp.60.2020.06.16.09.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 09:04:06 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, xeb@mail.ru, eric.dumazet@gmail.com
Subject: [PATCH net v2] ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
Date:   Tue, 16 Jun 2020 16:04:00 +0000
Message-Id: <20200616160400.8579-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the datapath, the ip6gre_tunnel_lookup() is used and it internally uses
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
    ip netns exec A ip link add ip6gre1 type ip6gre local fc:0::1 \
	    remote fc:0::2
    ip netns exec A ip -6 a a fc:100::1/64 dev ip6gre1
    ip netns exec A ip link set ip6gre1 up
    ip netns exec A ip -6 a a fc:0::1/64 dev eth0
    ip netns exec A ip link set ip6gre0 up

    ip netns exec B ip link set lo up
    ip netns exec B ip link set eth1 up
    ip netns exec B ip link add ip6gre1 type ip6gre local fc:0::2 \
	    remote fc:0::1
    ip netns exec B ip -6 a a fc:100::2/64 dev ip6gre1
    ip netns exec B ip link set ip6gre1 up
    ip netns exec B ip -6 a a fc:0::2/64 dev eth1
    ip netns exec B ip link set ip6gre0 up
    ip netns exec A ping fc:100::2 -s 60000 &
    ip netns del B

Splat looks like:
[   73.087285][    C1] BUG: KASAN: use-after-free in ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.088361][    C1] Read of size 4 at addr ffff888040559218 by task ping/1429
[   73.089317][    C1]
[   73.089638][    C1] CPU: 1 PID: 1429 Comm: ping Not tainted 5.7.0+ #602
[   73.090531][    C1] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   73.091725][    C1] Call Trace:
[   73.092160][    C1]  <IRQ>
[   73.092556][    C1]  dump_stack+0x96/0xdb
[   73.093122][    C1]  print_address_description.constprop.6+0x2cc/0x450
[   73.094016][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.094894][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.095767][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.096619][    C1]  kasan_report+0x154/0x190
[   73.097209][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.097989][    C1]  ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.098750][    C1]  ? gre_del_protocol+0x60/0x60 [gre]
[   73.099500][    C1]  gre_rcv+0x1c5/0x1450 [ip6_gre]
[   73.100199][    C1]  ? ip6gre_header+0xf00/0xf00 [ip6_gre]
[   73.100985][    C1]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   73.101830][    C1]  ? ip6_input_finish+0x5/0xf0
[   73.102483][    C1]  ip6_protocol_deliver_rcu+0xcbb/0x1510
[   73.103296][    C1]  ip6_input_finish+0x5b/0xf0
[   73.103920][    C1]  ip6_input+0xcd/0x2c0
[   73.104473][    C1]  ? ip6_input_finish+0xf0/0xf0
[   73.105115][    C1]  ? rcu_read_lock_held+0x90/0xa0
[   73.105783][    C1]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   73.106548][    C1]  ipv6_rcv+0x1f1/0x300
[ ... ]

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Do not add a new variable

 net/ipv6/ip6_gre.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 781ca8c07a0d..6532bde82b40 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -127,6 +127,7 @@ static struct ip6_tnl *ip6gre_tunnel_lookup(struct net_device *dev,
 			gre_proto == htons(ETH_P_ERSPAN2)) ?
 		       ARPHRD_ETHER : ARPHRD_IP6GRE;
 	int score, cand_score = 4;
+	struct net_device *ndev;
 
 	for_each_ip_tunnel_rcu(t, ign->tunnels_r_l[h0 ^ h1]) {
 		if (!ipv6_addr_equal(local, &t->parms.laddr) ||
@@ -238,9 +239,9 @@ static struct ip6_tnl *ip6gre_tunnel_lookup(struct net_device *dev,
 	if (t && t->dev->flags & IFF_UP)
 		return t;
 
-	dev = ign->fb_tunnel_dev;
-	if (dev && dev->flags & IFF_UP)
-		return netdev_priv(dev);
+	ndev = READ_ONCE(ign->fb_tunnel_dev);
+	if (ndev && ndev->flags & IFF_UP)
+		return netdev_priv(ndev);
 
 	return NULL;
 }
@@ -413,6 +414,8 @@ static void ip6gre_tunnel_uninit(struct net_device *dev)
 
 	ip6gre_tunnel_unlink_md(ign, t);
 	ip6gre_tunnel_unlink(ign, t);
+	if (ign->fb_tunnel_dev == dev)
+		WRITE_ONCE(ign->fb_tunnel_dev, NULL);
 	dst_cache_reset(&t->dst_cache);
 	dev_put(dev);
 }
-- 
2.17.1

