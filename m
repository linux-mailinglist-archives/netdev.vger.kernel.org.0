Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232D74AE33E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359153AbiBHWVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387003AbiBHVly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 16:41:54 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB52C0612B8
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 13:41:52 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id e28so753097pfj.5
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 13:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uzbRgpq9pxLgf75/aSBhS6nL+DCP09o84VLABnK3AYQ=;
        b=MEPsdV6UILCUkciMme42b3w+nX5DS/8B5V1We9F6+kIyWfeziRqsP2xNOrthSlpA+A
         NpTlQ+GNtoiF8fsxBeCrvg34nkSaHnpKv7A5FI/ga1JUoCAtUveaDvawXjP/TWJnGzgM
         LD3C1XaI4gxL3LUoi1EJbvo2h/7Qt3UM+Nq43sSNAtqk4W5KZbk1ZvbjQ536KtupHOT+
         maeaQCY40MD/MLRB3wPm9AFefy1v6o0EeT4arYA6vsBQGx6Xgt7zOPGGW7IqRWDuKvjo
         m1JMhqWvC0GGNy8YFB46EbyugFOkjfgn0ji+5ORDWvL19A5WOmc7/o1pSjR1X2PSCcLL
         mOag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uzbRgpq9pxLgf75/aSBhS6nL+DCP09o84VLABnK3AYQ=;
        b=lZYzUOnDE/bwTtibd03b4gC7J70a+WnU/gJGen0toUaHjNn7U3Ddii5+vgfI4eKxqw
         SFmrbMxLi2pUf67uacgsgQCT7SymqHaOjBHwIHPwK2kX8AIO3rZSx9vQUSy5a5KpE1ey
         xC209PftEazmw5gxcTTHwJGxnbbVrw/IV89leykaMCS7l6DvvN5xtu4azHHRDUy9qwv7
         zhak/6S4XuClDifioMas55SZ9rGiFWqPgR9Jt5jIvBa/OgH0OeHSbsJVNKA9bABnxKKy
         tg/dAsJKXOQj1S+bPTC6AY8Xn7dOCuiMO0As7QBxMJezBwlZIW1PFH6SWwAppsAGav5k
         sCfA==
X-Gm-Message-State: AOAM533U5RGCM9CEjZdVnvuPOlnrigYrWHPGSpJUOjoFYqzSr5DTquBr
        fZoA8ui1hcihzpC6PxWaaJQ=
X-Google-Smtp-Source: ABdhPJxF4oD1gmemlR7LrlL6Z5FzQY1M5UlC1HLz9Cg5nK1aHbfi0xvgbXi1uK8tGtXO/ziDM1kfcQ==
X-Received: by 2002:a63:3804:: with SMTP id f4mr4998353pga.454.1644356512014;
        Tue, 08 Feb 2022 13:41:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:18f1:ac55:f426:b85d])
        by smtp.gmail.com with ESMTPSA id 142sm8162432pfy.11.2022.02.08.13.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 13:41:51 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Qing Deng <i@moy.cat>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] ip6_tunnel: fix possible NULL deref in ip6_tnl_xmit
Date:   Tue,  8 Feb 2022 13:41:48 -0800
Message-Id: <20220208214148.3282081-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Make sure to test that skb has a dst attached to it.

general protection fault, probably for non-canonical address 0xdffffc0000000011: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000088-0x000000000000008f]
CPU: 0 PID: 32650 Comm: syz-executor.4 Not tainted 5.17.0-rc2-next-20220204-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ip6_tnl_xmit+0x2140/0x35f0 net/ipv6/ip6_tunnel.c:1127
Code: 4d 85 f6 0f 85 c5 04 00 00 e8 9c b0 66 f9 48 83 e3 fe 48 b8 00 00 00 00 00 fc ff df 48 8d bb 88 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 07 7f 05 e8 11 25 b2 f9 44 0f b6 b3 88 00 00
RSP: 0018:ffffc900141b7310 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000c77a000
RDX: 0000000000000011 RSI: ffffffff8811f854 RDI: 0000000000000088
RBP: ffffc900141b7480 R08: 0000000000000000 R09: 0000000000000008
R10: ffffffff8811f846 R11: 0000000000000008 R12: ffffc900141b7548
R13: ffff8880297c6000 R14: 0000000000000000 R15: ffff8880351c8dc0
FS:  00007f9827ba2700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31322000 CR3: 0000000033a70000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ipxip6_tnl_xmit net/ipv6/ip6_tunnel.c:1386 [inline]
 ip6_tnl_start_xmit+0x71e/0x1830 net/ipv6/ip6_tunnel.c:1435
 __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
 netdev_start_xmit include/linux/netdevice.h:4697 [inline]
 xmit_one net/core/dev.c:3473 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3489
 __dev_queue_xmit+0x2a24/0x3760 net/core/dev.c:4116
 packet_snd net/packet/af_packet.c:3057 [inline]
 packet_sendmsg+0x2265/0x5460 net/packet/af_packet.c:3084
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 sock_write_iter+0x289/0x3c0 net/socket.c:1061
 call_write_iter include/linux/fs.h:2075 [inline]
 do_iter_readv_writev+0x47a/0x750 fs/read_write.c:726
 do_iter_write+0x188/0x710 fs/read_write.c:852
 vfs_writev+0x1aa/0x630 fs/read_write.c:925
 do_writev+0x27f/0x300 fs/read_write.c:968
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f9828c2d059

Fixes: c1f55c5e0482 ("ip6_tunnel: allow routing IPv4 traffic in NBMA mode")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Qing Deng <i@moy.cat>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/ip6_tunnel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index b47ffc81f9e51f152608c22c1c02d9ababf99137..53f632a560ec2019a73b35a61ea24a219a4a49c7 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1122,7 +1122,10 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 			memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));
 			neigh_release(neigh);
 		} else if (skb->protocol == htons(ETH_P_IP)) {
-			struct rtable *rt = skb_rtable(skb);
+			const struct rtable *rt = skb_rtable(skb);
+
+			if (!rt)
+				goto tx_err_link_failure;
 
 			if (rt->rt_gw_family == AF_INET6)
 				memcpy(&fl6->daddr, &rt->rt_gw6, sizeof(fl6->daddr));
-- 
2.35.0.263.gb82422642f-goog

