Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9C22B8FAA
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 11:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgKSJ7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 04:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgKSJ7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 04:59:37 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B08BC0613CF;
        Thu, 19 Nov 2020 01:59:37 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i13so3757949pgm.9;
        Thu, 19 Nov 2020 01:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EZeWYckXUGDc32rbWu7rC1HoxdZfPXdnYexC2a7BeQg=;
        b=QHbRpFZkH9LqN/iMK9/NAg9Frpt2IiBeqZnbRN0By0IZ8LLTHZEd3nNGBgo8uRmh+p
         r1lti1CPPCe3c+rQxa8per7tHI7uvtu5LMDH9J+j1B09S5jaqF1PzjBRYYqg5+0Teeqt
         Vq25qHTAKlsx01C/j0aeDTvfAm8eWCz5oQUufej+ofozwwXL8XGwDDJPhQGrwlYBhIxy
         8wzbEJKD0UFn1gstz7dnMf/N+qCuFR2z+YMbVZvxOgl7vhurPbw00As9OgGC/xRJCF8E
         OFBzLF7wPvIgCrT4yMjbi1gr7n8Lb4gHVmc02ROko095V60fKzckm/OenWIPscGfrLDl
         2/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EZeWYckXUGDc32rbWu7rC1HoxdZfPXdnYexC2a7BeQg=;
        b=NC5oZEK8cGFvCqsSVYor/MAqjE8ZFO/slwEFJk6anw1ygJS0VEi187EK9KZk/1J1VI
         JZumYIuysJVp8e3bVB4PbMmlxBYVe9cpWVgHfKHO5RELRR1r13Fzw9IFmL1pe97M4lld
         grfbY6swJldF6uUxjAib0LnzNoVWkRMGDiovvcodmjEAQtPVBH4YkJbpae3jOfJoLK5M
         FzSbxINazIbzfTo8sUfK0eezf5paw+92ccWM0KFWX+Df6ro5XO7g5CvCvJU9ef8WBYgt
         u/SDXfP/kJHkGRehuqOQLNxluAGV/ljEtW+i+bTveaYXfT1+L57gz2YS400h4z29cGE1
         033A==
X-Gm-Message-State: AOAM532IitKg0+nHi9mA44lZCr5x8AMimSMsv8FZCZuI6kVo5oAHUZ9c
        K0gAxVe3GtvCM2MZZgiVJ/s=
X-Google-Smtp-Source: ABdhPJwKYXC2Mn7nsO/kyGOqmxrHuoZy4TCqYL826qILifA7ir3G0TSBPi9WGRF606CsI1i/mN+DCQ==
X-Received: by 2002:a65:60d8:: with SMTP id r24mr11969953pgv.152.1605779976958;
        Thu, 19 Nov 2020 01:59:36 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id f16sm25794098pgk.48.2020.11.19.01.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 01:59:36 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] netfilter: ipset: prevent uninit-value in hash_ip6_add
Date:   Thu, 19 Nov 2020 01:59:32 -0800
Message-Id: <20201119095932.1962839-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot found that we are not validating user input properly
before copying 16 bytes [1].

Using NLA_BINARY in ipaddr_policy[] for IPv6 address is not correct,
since it ensures at most 16 bytes were provided.

We should instead make sure user provided exactly 16 bytes.

In old kernels (before v4.20), fix would be to remove the NLA_BINARY,
since NLA_POLICY_EXACT_LEN() was not yet available.

[1]
BUG: KMSAN: uninit-value in hash_ip6_add+0x1cba/0x3a50 net/netfilter/ipset/ip_set_hash_gen.h:892
CPU: 1 PID: 11611 Comm: syz-executor.0 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hash_ip6_add+0x1cba/0x3a50 net/netfilter/ipset/ip_set_hash_gen.h:892
 hash_ip6_uadt+0x976/0xbd0 net/netfilter/ipset/ip_set_hash_ip.c:267
 call_ad+0x329/0xd00 net/netfilter/ipset/ip_set_core.c:1720
 ip_set_ad+0x111f/0x1440 net/netfilter/ipset/ip_set_core.c:1808
 ip_set_uadd+0xf6/0x110 net/netfilter/ipset/ip_set_core.c:1833
 nfnetlink_rcv_msg+0xc7d/0xdf0 net/netfilter/nfnetlink.c:252
 netlink_rcv_skb+0x70a/0x820 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x4f0/0x4380 net/netfilter/nfnetlink.c:600
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11da/0x14b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173c/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x6d5/0x830 net/socket.c:2440
 __do_sys_sendmsg net/socket.c:2449 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe2e503fc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000029ec0 RCX: 000000000045deb9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 000000000169fb7f R14: 00007fe2e50409c0 R15: 000000000118bf2c

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 __msan_chain_origin+0x57/0xa0 mm/kmsan/kmsan_instr.c:147
 ip6_netmask include/linux/netfilter/ipset/pfxlen.h:49 [inline]
 hash_ip6_netmask net/netfilter/ipset/ip_set_hash_ip.c:185 [inline]
 hash_ip6_uadt+0xb1c/0xbd0 net/netfilter/ipset/ip_set_hash_ip.c:263
 call_ad+0x329/0xd00 net/netfilter/ipset/ip_set_core.c:1720
 ip_set_ad+0x111f/0x1440 net/netfilter/ipset/ip_set_core.c:1808
 ip_set_uadd+0xf6/0x110 net/netfilter/ipset/ip_set_core.c:1833
 nfnetlink_rcv_msg+0xc7d/0xdf0 net/netfilter/nfnetlink.c:252
 netlink_rcv_skb+0x70a/0x820 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x4f0/0x4380 net/netfilter/nfnetlink.c:600
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11da/0x14b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173c/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x6d5/0x830 net/socket.c:2440
 __do_sys_sendmsg net/socket.c:2449 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 kmsan_memcpy_memmove_metadata+0x25e/0x2d0 mm/kmsan/kmsan.c:226
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:246
 __msan_memcpy+0x46/0x60 mm/kmsan/kmsan_instr.c:110
 ip_set_get_ipaddr6+0x2cb/0x370 net/netfilter/ipset/ip_set_core.c:310
 hash_ip6_uadt+0x439/0xbd0 net/netfilter/ipset/ip_set_hash_ip.c:255
 call_ad+0x329/0xd00 net/netfilter/ipset/ip_set_core.c:1720
 ip_set_ad+0x111f/0x1440 net/netfilter/ipset/ip_set_core.c:1808
 ip_set_uadd+0xf6/0x110 net/netfilter/ipset/ip_set_core.c:1833
 nfnetlink_rcv_msg+0xc7d/0xdf0 net/netfilter/nfnetlink.c:252
 netlink_rcv_skb+0x70a/0x820 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x4f0/0x4380 net/netfilter/nfnetlink.c:600
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11da/0x14b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173c/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x6d5/0x830 net/socket.c:2440
 __do_sys_sendmsg net/socket.c:2449 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2906 [inline]
 __kmalloc_node_track_caller+0xc61/0x15f0 mm/slub.c:4512
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x309/0xae0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1094 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1176 [inline]
 netlink_sendmsg+0xdb8/0x1840 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x6d5/0x830 net/socket.c:2440
 __do_sys_sendmsg net/socket.c:2449 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netfilter/ipset/ip_set_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index c7eaa3776238d6d1da28dee0da21306d418ee9fd..89009c82a6b2408f637a2716e73b54eea3bafd0f 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -271,8 +271,7 @@ flag_nested(const struct nlattr *nla)
 
 static const struct nla_policy ipaddr_policy[IPSET_ATTR_IPADDR_MAX + 1] = {
 	[IPSET_ATTR_IPADDR_IPV4]	= { .type = NLA_U32 },
-	[IPSET_ATTR_IPADDR_IPV6]	= { .type = NLA_BINARY,
-					    .len = sizeof(struct in6_addr) },
+	[IPSET_ATTR_IPADDR_IPV6]	= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
 };
 
 int
-- 
2.29.2.299.gdc1121823c-goog

