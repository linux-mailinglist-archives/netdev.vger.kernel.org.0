Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739FC2E1F9F
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 17:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgLWQxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 11:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgLWQxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 11:53:40 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD71C06179C
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 08:53:00 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id h186so10704713pfe.0
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 08:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=orFQMFz+YCqCTP0/OfqfsKyHfSekW5/NBNaaI2OEEZ8=;
        b=Nn6eBHMYnjLo0AK21LtPlA06yq5zG5eFLKxtTE0KyEXPvobpNC88P8M8/uIYwePc/Z
         hDlupqhm64aLXP6s4krBI/5DJT4JGpQ5P8UdQZdv+SQ7c0EHYU5STaY+zrjZp9IhhINN
         eFoyGtJtJZ/E13CwmusKGzmsM4GgbNJDTAaR7gPvrhXrjpxb+jShhU0nVWZUWD5sCIva
         0XE7q/ErS75qdS1YfhGv2Ox70Xh7BPWvkA6J6eUeUvM76VymFC3g31yM2lu+ImfNtKq0
         UAtuwd1+mJydvBGB1cv/HHrqUfBWJVQLX+2/Z1COOxafmkR4qJpuPW/aPFZhGsHyYFwq
         k9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=orFQMFz+YCqCTP0/OfqfsKyHfSekW5/NBNaaI2OEEZ8=;
        b=M+v3yQf3wQgeZ+u6Xt9EVSfXxu7kqyFPADs33SqBqrAgoqnlhQrHWkHqPmhYT3yti+
         67dEN9zgShD+ae8QZohAqKqZ5BwVMYM97QqwxLYa+F1jhsLEHvJ7HyrmP5eTUmQVaayR
         gtDTOIvo4w+0NAS2zXTLnTHNlI+pd/aEqIp0Pbgvi+Kwxqg0kz0b3/OhddDCjlbS0ZG/
         YoUNuUDbeBhkr5MwRAE+Nu4Xs9E4wDy0GytQi5QnD6UWDgBZjnO95O/4fCQZykP8/IDi
         SRUgtQWfP8K1GLJkf5Q8tUqQQbelJ2YeE1UDQIgJVe8vb2+OjEAFuzBjrpgaAczb0iKD
         YPWA==
X-Gm-Message-State: AOAM53370zbUMQh2nKzxFArtq3C8a4uVj4bUiLa62yJ1TdfuwPI1cyXH
        0NYywLhrMlKr8hYgP99GFdo=
X-Google-Smtp-Source: ABdhPJzpmc69JMvcNyvJqyJKBWWqs1ymCgI0Byfy0CM4Ha05vZQ0rzGgQAmrEfBIl8t6qllig4inYQ==
X-Received: by 2002:a62:3002:0:b029:1aa:d858:cdd7 with SMTP id w2-20020a6230020000b02901aad858cdd7mr25149855pfw.1.1608742380137;
        Wed, 23 Dec 2020 08:53:00 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id e5sm24164057pfc.76.2020.12.23.08.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 08:52:59 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, eric.dumazet@gmail.com
Subject: [PATCH net] mld: fix panic in mld_newpack()
Date:   Wed, 23 Dec 2020 16:52:50 +0000
Message-Id: <20201223165250.14505-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mld_newpack() doesn't allow to allocate high order page,
just order-0 allocation is allowed.
If headroom size is too large, a kernel panic could occur in skb_put().

Test commands:
    ip netns add A
    ip netns add B
    ip link add veth0 type veth peer name veth1
    ip link set veth0 netns A
    ip link set veth1 netns B

    ip netns exec A ip link set lo up
    ip netns exec A ip link set veth0 up
    ip netns exec A ip link add ip6tnl100 type ip6tnl local 2001:db8:99::1 \
	    remote 2001:db8:99::2
    ip netns exec A ip -6 a a 2001:db8:100::1/64 dev ip6tnl100
    ip netns exec A ip link set ip6tnl100 up
    for i in {99..1}
    do
            let A=$i-1
            ip netns exec A ip link add ip6tnl$i type ip6tnl local \
		    2001:db8:$A::1 remote 2001:db8:$A::2
            ip netns exec A ip -6 a a 2001:db8:$i::1/64 dev ip6tnl$i
            ip netns exec A ip link set ip6tnl$i up
    done
    ip netns exec A ip -6 a a 2001:db8:0::1/64 dev veth0

    ip netns exec B ip link set lo up
    ip netns exec B ip link set veth1 up
    ip netns exec B ip link add ip6tnl100 type ip6tnl local 2001:db8:99::2 \
	    remote 2001:db8:99::1
    ip netns exec B ip -6 a a 2001:db8:100::2/64 dev ip6tnl100
    ip netns exec B ip link set ip6tnl100 up
    for i in {99..1}
    do
            let B=$i-1
            ip netns exec B ip link add ip6tnl$i type ip6tnl local \
		    2001:db8:$B::2 remote 2001:db8:$B::1
            ip netns exec B ip -6 a a 2001:db8:$i::2/64 dev ip6tnl$i
            ip netns exec B ip link set ip6tnl$i up
    done
    ip netns exec B ip -6 a a 2001:db8:0::2/64 dev veth1

Splat looks like:
[  104.047694][  T104] skbuff: skb_over_panic: text:ffffffffb0c31a92 len:56 put:8 head:ffff888009609000 data:ffff888009609e90 tail:0xec8 end:0xec0 dev:ip6gre4b
[  104.053431][  T104] ------------[ cut here ]------------
[  104.055733][  T104] kernel BUG at net/core/skbuff.c:109!
[  104.058014][  T104] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  104.060761][  T104] CPU: 4 PID: 104 Comm: kworker/4:1 Not tainted 5.10.0+ #811
[  104.064000][  T104] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[  104.068077][  T104] Workqueue: ipv6_addrconf addrconf_dad_work
[  104.070096][  T104] RIP: 0010:skb_panic+0x15d/0x15f
[  104.072335][  T104] Code: 98 fe 4c 8b 4c 24 10 53 8b 4d 70 45 89 e0 48 c7 c7 60 8b 78 b1 41 57 41 56 41 55 48 8b 54 24 20 48 8b 74 24 28 e8 b5 40 f9 ff <0f> 0b 48 8b 6c 24 20 89 34 24 e8 08 c9 98 fe 8b 34 24 48 c7 c1 80
[  104.079948][  T104] RSP: 0018:ffff888102557870 EFLAGS: 00010282
[  104.082361][  T104] RAX: 0000000000000088 RBX: ffff888101c7c000 RCX: 0000000000000000
[  104.085878][  T104] RDX: 0000000000000088 RSI: 0000000000000008 RDI: ffffed10204aaf05
[  104.088906][  T104] RBP: ffff8881165f60c0 R08: ffffed102338018d R09: ffffed102338018d
[  104.092111][  T104] R10: ffff888119c00c67 R11: ffffed102338018c R12: 0000000000000008
[  104.095291][  T104] R13: ffff888009609e90 R14: 0000000000000ec8 R15: 0000000000000ec0
[  104.098023][  T104] FS:  0000000000000000(0000) GS:ffff888119a00000(0000) knlGS:0000000000000000
[  104.101532][  T104] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  104.103972][  T104] CR2: 000055a06421b7cc CR3: 000000010d55a002 CR4: 00000000003706e0
[  104.107058][  T104] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  104.110048][  T104] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  104.113020][  T104] Call Trace:
[  104.114253][  T104]  ? mld_newpack+0x4d2/0x8f0
[  104.115875][  T104]  ? mld_newpack+0x4d2/0x8f0
[  104.117389][  T104]  skb_put.cold.104+0x22/0x22
[  104.118940][  T104]  mld_newpack+0x4d2/0x8f0
[  104.120389][  T104]  ? ip6_mc_hdr.isra.25.constprop.47+0x600/0x600
[  104.122466][  T104]  ? register_lock_class+0x1910/0x1910
[  104.124256][  T104]  ? mark_lock.part.46+0xef/0x1c20
[  104.125925][  T104]  add_grhead.isra.32+0x280/0x380
[  104.127574][  T104]  add_grec+0xb13/0xdc0
[  104.128952][  T104]  ? rcu_read_lock_bh_held+0xa0/0xa0
[ ... ]

Allowing high order page allocation could fix this problem.

Fixes: 72e09ad107e7 ("ipv6: avoid high order allocations")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv6/mcast.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 6c8604390266..2cab0c563214 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1601,10 +1601,7 @@ static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
 		     IPV6_TLV_PADN, 0 };
 
 	/* we assume size > sizeof(ra) here */
-	/* limit our allocations to order-0 page */
-	size = min_t(int, size, SKB_MAX_ORDER(0, 0));
 	skb = sock_alloc_send_skb(sk, size, 1, &err);
-
 	if (!skb)
 		return NULL;
 
-- 
2.17.1

