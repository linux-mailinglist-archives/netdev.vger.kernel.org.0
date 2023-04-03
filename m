Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BED6D3E24
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 09:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbjDCHeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 03:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjDCHeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 03:34:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18180902A;
        Mon,  3 Apr 2023 00:34:23 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PqjH20M4JzSq41;
        Mon,  3 Apr 2023 15:30:38 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 3 Apr 2023 15:34:20 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <dlstevens@us.ibm.com>
Subject: [PATCH net] ipv6: Fix an uninit variable access bug in __ip6_make_skb()
Date:   Mon, 3 Apr 2023 15:34:17 +0800
Message-ID: <20230403073417.2240575-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported a bug as following:

=====================================================
BUG: KMSAN: uninit-value in arch_atomic64_inc arch/x86/include/asm/atomic64_64.h:88 [inline]
BUG: KMSAN: uninit-value in arch_atomic_long_inc include/linux/atomic/atomic-long.h:161 [inline]
BUG: KMSAN: uninit-value in atomic_long_inc include/linux/atomic/atomic-instrumented.h:1429 [inline]
BUG: KMSAN: uninit-value in __ip6_make_skb+0x2f37/0x30f0 net/ipv6/ip6_output.c:1956
 arch_atomic64_inc arch/x86/include/asm/atomic64_64.h:88 [inline]
 arch_atomic_long_inc include/linux/atomic/atomic-long.h:161 [inline]
 atomic_long_inc include/linux/atomic/atomic-instrumented.h:1429 [inline]
 __ip6_make_skb+0x2f37/0x30f0 net/ipv6/ip6_output.c:1956
 ip6_finish_skb include/net/ipv6.h:1122 [inline]
 ip6_push_pending_frames+0x10e/0x550 net/ipv6/ip6_output.c:1987
 rawv6_push_pending_frames+0xb12/0xb90 net/ipv6/raw.c:579
 rawv6_sendmsg+0x297e/0x2e60 net/ipv6/raw.c:922
 inet_sendmsg+0x101/0x180 net/ipv4/af_inet.c:827
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xa8e/0xe70 net/socket.c:2476
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2530
 __sys_sendmsg net/socket.c:2559 [inline]
 __do_sys_sendmsg net/socket.c:2568 [inline]
 __se_sys_sendmsg net/socket.c:2566 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2566
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:766 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc_node_track_caller+0x114/0x3b0 mm/slab_common.c:988
 kmalloc_reserve net/core/skbuff.c:492 [inline]
 __alloc_skb+0x3af/0x8f0 net/core/skbuff.c:565
 alloc_skb include/linux/skbuff.h:1270 [inline]
 __ip6_append_data+0x51c1/0x6bb0 net/ipv6/ip6_output.c:1684
 ip6_append_data+0x411/0x580 net/ipv6/ip6_output.c:1854
 rawv6_sendmsg+0x2882/0x2e60 net/ipv6/raw.c:915
 inet_sendmsg+0x101/0x180 net/ipv4/af_inet.c:827
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xa8e/0xe70 net/socket.c:2476
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2530
 __sys_sendmsg net/socket.c:2559 [inline]
 __do_sys_sendmsg net/socket.c:2568 [inline]
 __se_sys_sendmsg net/socket.c:2566 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2566
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

It is because icmp6hdr does not in skb linear region under the scenario
of SOCK_RAW socket. Access icmp6_hdr(skb)->icmp6_type directly will
trigger the uninit variable access bug.

Use a local variable icmp6_type to carry the correct value in different
scenarios.

Fixes: 14878f75abd5 ("[IPV6]: Add ICMPMsgStats MIB (RFC 4293) [rev 2]")
Reported-by: syzbot+8257f4dcef79de670baf@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=3d605ec1d0a7f2a269a1a6936ac7f2b85975ee9c
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/ipv6/ip6_output.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c314fdde0097..95a55c6630ad 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1965,8 +1965,13 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 	IP6_UPD_PO_STATS(net, rt->rt6i_idev, IPSTATS_MIB_OUT, skb->len);
 	if (proto == IPPROTO_ICMPV6) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
+		u8 icmp6_type;
 
-		ICMP6MSGOUT_INC_STATS(net, idev, icmp6_hdr(skb)->icmp6_type);
+		if (sk->sk_socket->type == SOCK_RAW && !inet_sk(sk)->hdrincl)
+			icmp6_type = fl6->fl6_icmp_type;
+		else
+			icmp6_type = icmp6_hdr(skb)->icmp6_type;
+		ICMP6MSGOUT_INC_STATS(net, idev, icmp6_type);
 		ICMP6_INC_STATS(net, idev, ICMP6_MIB_OUTMSGS);
 	}
 
-- 
2.25.1

