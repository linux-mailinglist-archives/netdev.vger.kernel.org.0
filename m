Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC7D2E427B
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 16:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438148AbgL1PXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 10:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440813AbgL1PWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 10:22:35 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBC5C061795
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 07:21:54 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g3so5779689plp.2
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 07:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KxqkXXpiH9gbpda63RV+Fl689fW9Bh7P4x7g9cPeDLg=;
        b=Z5Qu5Xq39pVoVSpN7hgC2zCyGi8HgdqzWpPwegV64PHJc3fZ3++Iz2NCqYV3b4KKFK
         gJwZmuFJaTlMJMmcajCMKTvmU9fzj1D6tkFM0HSPKnuKabWT3YkZF030y/p3DyG0bmNE
         vLOX0bb4V9TF6zgfz1brBi2C2PSOsRwuxt1oCHCl2DdoTuvvCoiolPZ+jYo2aPC0pDpO
         f/fR0xFgbAiJKhoDFM8XXPBIYxJGzPh6iXgJVsqn24F+nnmRI3DLAHZrBS/TIWDMi4Lz
         K6Msi4vbYBsIDyarOqmQtofd8y9SaynQtkO73mxlmAK1LoQvmuICaFZ4XPeE9tmBckf2
         1reg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KxqkXXpiH9gbpda63RV+Fl689fW9Bh7P4x7g9cPeDLg=;
        b=iR1LlMcEgTzTcNfWZ1n6mP4SR0xuTZ7bWBagPrxZDA4IHPnuzY/LSK35JDwOS8nb9e
         +fkRt0F/KdNcewykZkM8R+c3YcZWCrHFye5z9SoUAoK/s+2Q0AZ19A42N1td+R/3ovkk
         wH7dOfvpnkerrPXTRrV19A1+GevFh8dQQxZjQQd0jLtxMGcsCxYv+6qmA2tX7jmgQyg3
         fif3INkz79EXjKvMucibFUwCtg97vA2b020fX6hkj6bWmhEX4Pdl4vAi4xfHV6BHx7hM
         4PEmm8wrQGEPC9l4T2f2u8jo/UBXVf/jhXQJXxqi0M8J8/NUZo6IvnlrZqxSp0R9IfGb
         HtTQ==
X-Gm-Message-State: AOAM533DGWTmRWmF7QfZseQBGo+dcHMjHQq24x6FddSjZr9qK5o+nQ6P
        3OgMFAxsgcVVxF4JUUQmqxY=
X-Google-Smtp-Source: ABdhPJxok/KfMHrlL/WNy/xoTKAdkUq+Cq4WNtonvjy4CcCw+gdPLMpUCREmoOvqMXkpIRe5d6XkZg==
X-Received: by 2002:a17:902:ee83:b029:da:3483:3957 with SMTP id a3-20020a170902ee83b02900da34833957mr20986961pld.38.1609168914059;
        Mon, 28 Dec 2020 07:21:54 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id b17sm14340690pjz.44.2020.12.28.07.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 07:21:53 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, gnault@redhat.com
Subject: [PATCH net v2 2/2] bareudp: Fix use of incorrect min_headroom size
Date:   Mon, 28 Dec 2020 15:21:46 +0000
Message-Id: <20201228152146.24270-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the bareudp6_xmit_skb(), it calculates min_headroom.
At that point, it uses struct iphdr, but it's not correct.
So panic could occur.
The struct ipv6hdr should be used.

Test commands:
    ip netns add A
    ip netns add B
    ip link add veth0 netns A type veth peer name veth1 netns B
    ip netns exec A ip link set veth0 up
    ip netns exec A ip a a 2001:db8:0::1/64 dev veth0
    ip netns exec B ip link set veth1 up
    ip netns exec B ip a a 2001:db8:0::2/64 dev veth1

    for i in {10..1}
    do
            let A=$i-1
            ip netns exec A ip link add bareudp$i type bareudp dstport $i \
		    ethertype 0x86dd
            ip netns exec A ip link set bareudp$i up
            ip netns exec A ip -6 a a 2001:db8:$i::1/64 dev bareudp$i
            ip netns exec A ip -6 r a 2001:db8:$i::2 encap ip6 src \
		    2001:db8:$A::1 dst 2001:db8:$A::2 via 2001:db8:$i::2 \
		    dev bareudp$i

            ip netns exec B ip link add bareudp$i type bareudp dstport $i \
		    ethertype 0x86dd
            ip netns exec B ip link set bareudp$i up
            ip netns exec B ip -6 a a 2001:db8:$i::2/64 dev bareudp$i
            ip netns exec B ip -6 r a 2001:db8:$i::1 encap ip6 src \
		    2001:db8:$A::2 dst 2001:db8:$A::1 via 2001:db8:$i::1 \
		    dev bareudp$i
    done
    ip netns exec A ping 2001:db8:7::2

Splat looks like:
[   66.436679][    C2] skbuff: skb_under_panic: text:ffffffff928614c8 len:454 put:14 head:ffff88810abb4000 data:ffff88810abb3ffa tail:0x1c0 end:0x3ec0 dev:veth0
[   66.441626][    C2] ------------[ cut here ]------------
[   66.443458][    C2] kernel BUG at net/core/skbuff.c:109!
[   66.445313][    C2] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[   66.447606][    C2] CPU: 2 PID: 913 Comm: ping Not tainted 5.10.0+ #819
[   66.450251][    C2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   66.453713][    C2] RIP: 0010:skb_panic+0x15d/0x15f
[   66.455345][    C2] Code: 98 fe 4c 8b 4c 24 10 53 8b 4d 70 45 89 e0 48 c7 c7 60 8b 78 93 41 57 41 56 41 55 48 8b 54 24 20 48 8b 74 24 28 e8 b5 40 f9 ff <0f> 0b 48 8b 6c 24 20 89 34 24 e8 08 c9 98 fe 8b 34 24 48 c7 c1 80
[   66.462314][    C2] RSP: 0018:ffff888119209648 EFLAGS: 00010286
[   66.464281][    C2] RAX: 0000000000000089 RBX: ffff888003159000 RCX: 0000000000000000
[   66.467216][    C2] RDX: 0000000000000089 RSI: 0000000000000008 RDI: ffffed10232412c0
[   66.469768][    C2] RBP: ffff88810a53d440 R08: ffffed102328018d R09: ffffed102328018d
[   66.472297][    C2] R10: ffff888119400c67 R11: ffffed102328018c R12: 000000000000000e
[   66.474833][    C2] R13: ffff88810abb3ffa R14: 00000000000001c0 R15: 0000000000003ec0
[   66.477361][    C2] FS:  00007f37c0c72f00(0000) GS:ffff888119200000(0000) knlGS:0000000000000000
[   66.480214][    C2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.482296][    C2] CR2: 000055a058808570 CR3: 000000011039e002 CR4: 00000000003706e0
[   66.484811][    C2] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   66.487793][    C2] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   66.490424][    C2] Call Trace:
[   66.491469][    C2]  <IRQ>
[   66.492374][    C2]  ? eth_header+0x28/0x190
[   66.494054][    C2]  ? eth_header+0x28/0x190
[   66.495401][    C2]  skb_push.cold.99+0x22/0x22
[   66.496700][    C2]  eth_header+0x28/0x190
[   66.497867][    C2]  neigh_resolve_output+0x3de/0x720
[   66.499615][    C2]  ? __neigh_update+0x7e8/0x20a0
[   66.501176][    C2]  __neigh_update+0x8bd/0x20a0
[   66.502749][    C2]  ndisc_update+0x34/0xc0
[   66.504010][    C2]  ndisc_recv_na+0x8da/0xb80
[   66.505041][    C2]  ? pndisc_redo+0x20/0x20
[   66.505888][    C2]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   66.506965][    C2]  ndisc_rcv+0x3a0/0x470
[   66.507797][    C2]  icmpv6_rcv+0xad9/0x1b00
[   66.508645][    C2]  ip6_protocol_deliver_rcu+0xcd6/0x1560
[   66.509719][    C2]  ip6_input_finish+0x5b/0xf0
[   66.510615][    C2]  ip6_input+0xcd/0x2d0
[   66.511406][    C2]  ? ip6_input_finish+0xf0/0xf0
[   66.512327][    C2]  ? rcu_read_lock_held+0x91/0xa0
[   66.513279][    C2]  ? ip6_protocol_deliver_rcu+0x1560/0x1560
[   66.514414][    C2]  ipv6_rcv+0xe8/0x300
[ ... ]

Acked-by: Guillaume Nault <gnault@redhat.com>
Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Fix reproducer script

 drivers/net/bareudp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index aea10196c222..708171c0d628 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -380,7 +380,7 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		goto free_dst;
 
 	min_headroom = LL_RESERVED_SPACE(dst->dev) + dst->header_len +
-		BAREUDP_BASE_HLEN + info->options_len + sizeof(struct iphdr);
+		BAREUDP_BASE_HLEN + info->options_len + sizeof(struct ipv6hdr);
 
 	err = skb_cow_head(skb, min_headroom);
 	if (unlikely(err))
-- 
2.17.1

