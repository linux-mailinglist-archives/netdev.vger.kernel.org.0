Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C563248F
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 20:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfFBSYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 14:24:24 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:46559 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFBSYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 14:24:23 -0400
Received: by mail-pl1-f202.google.com with SMTP id y1so10128346plr.13
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 11:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nKULuHiRd1THRkIXpU+sKzfN2lU+9ZUbSawUhFGyoSM=;
        b=l6kkDda9uqyXNeRJLUXppoE0UuU+eLPjkq91zlmCni5uCnhopOw78JKlONpTJtqLJg
         nC5nFZrT1fYqBN463qGOoB/5dy9li8inZOfC049c33TH45XWPlFG23CKxtzIHHLjLJdo
         JwUFVLoW8aLyRMDnHae9jmXyc9GeyL2ZH3XiEqWwb2hpO8DGQMjqY7xVqCKARTPEZTtC
         BuUxbHXwNxkKGChuK8wZx42NQ+1Ys8u68LkvTMWtDf0ioxss7vkSeMhHJ5+MQz3UAIFK
         efMzAPYgB4E/Ss3Mfc8D0ZfWOtVd5p3jVHV9W3PQzB7TEdA7+CKlGEWKENI6Y0jHHbIM
         dYVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nKULuHiRd1THRkIXpU+sKzfN2lU+9ZUbSawUhFGyoSM=;
        b=f44/BepEKNiYWQwsv5kMcZ7DBMq6SJVa3v8bofqaPA3pcV6JawEzJrwXu4vzBT82++
         DJMAavGimCaGKJypQMJvPzEVBh+pLgXx+OU3g7LgX3Atusa1rSPXqRlIw/WQ8uyPOjSv
         uFfGnhH0aUi4s9U1sakxb5uvu3drIPLoxM0WZasAMO+tno9GgcpuDDz8w8SbNSj7oQ8m
         IQtOXPcUmj1c1tEQlFgLZYPZDerKD0erh20BKlt92hZOozVcXngheVXxC1L9BN92qDpx
         hhNPrVz39pbweEZKRRBmdWjf++ybqqsDOzpBAfmGV/x826QFxnWZ80UjD6deb3kt28F6
         PHlw==
X-Gm-Message-State: APjAAAWdArfrFIcFn+gzO764vmfhwoWQeX6L7rRjeyu/b7UOi9f0VMLm
        PxvspyWpvTtuWa866r21AjLFgXKXbpWdug==
X-Google-Smtp-Source: APXvYqzSdto1GJkZLjBHu9P0hOMIDqqRGazn8hcDsBNU/t7Yr0psojn6qdebrxHujylmldy4jCH3KQhP3i3HrQ==
X-Received: by 2002:a63:f509:: with SMTP id w9mr24153885pgh.134.1559499862344;
 Sun, 02 Jun 2019 11:24:22 -0700 (PDT)
Date:   Sun,  2 Jun 2019 11:24:18 -0700
Message-Id: <20190602182418.117629-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next] net: fix use-after-free in kfree_skb_list
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported nasty use-after-free [1]

Lets remove frag_list field from structs ip_fraglist_iter
and ip6_fraglist_iter. This seens not needed anyway.

[1] :
BUG: KASAN: use-after-free in kfree_skb_list+0x5d/0x60 net/core/skbuff.c:706
Read of size 8 at addr ffff888085a3cbc0 by task syz-executor303/8947

CPU: 0 PID: 8947 Comm: syz-executor303 Not tainted 5.2.0-rc2+ #12
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
 __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
 kasan_report+0x12/0x20 mm/kasan/common.c:614
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
 kfree_skb_list+0x5d/0x60 net/core/skbuff.c:706
 ip6_fragment+0x1ef4/0x2680 net/ipv6/ip6_output.c:882
 __ip6_finish_output+0x577/0xaa0 net/ipv6/ip6_output.c:144
 ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:156
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0x235/0x7f0 net/ipv6/ip6_output.c:179
 dst_output include/net/dst.h:433 [inline]
 ip6_local_out+0xbb/0x1b0 net/ipv6/output_core.c:179
 ip6_send_skb+0xbb/0x350 net/ipv6/ip6_output.c:1796
 ip6_push_pending_frames+0xc8/0xf0 net/ipv6/ip6_output.c:1816
 rawv6_push_pending_frames net/ipv6/raw.c:617 [inline]
 rawv6_sendmsg+0x2993/0x35e0 net/ipv6/raw.c:947
 inet_sendmsg+0x141/0x5d0 net/ipv4/af_inet.c:802
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:671
 ___sys_sendmsg+0x803/0x920 net/socket.c:2292
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
 __do_sys_sendmsg net/socket.c:2339 [inline]
 __se_sys_sendmsg net/socket.c:2337 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x44add9
Code: e8 7c e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 05 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f826f33bce8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006e7a18 RCX: 000000000044add9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000005
RBP: 00000000006e7a10 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e7a1c
R13: 00007ffcec4f7ebf R14: 00007f826f33c9c0 R15: 20c49ba5e353f7cf

Allocated by task 8947:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_kmalloc mm/kasan/common.c:489 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
 kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:497
 slab_post_alloc_hook mm/slab.h:437 [inline]
 slab_alloc_node mm/slab.c:3269 [inline]
 kmem_cache_alloc_node+0x131/0x710 mm/slab.c:3579
 __alloc_skb+0xd5/0x5e0 net/core/skbuff.c:199
 alloc_skb include/linux/skbuff.h:1058 [inline]
 __ip6_append_data.isra.0+0x2a24/0x3640 net/ipv6/ip6_output.c:1519
 ip6_append_data+0x1e5/0x320 net/ipv6/ip6_output.c:1688
 rawv6_sendmsg+0x1467/0x35e0 net/ipv6/raw.c:940
 inet_sendmsg+0x141/0x5d0 net/ipv4/af_inet.c:802
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:671
 ___sys_sendmsg+0x803/0x920 net/socket.c:2292
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
 __do_sys_sendmsg net/socket.c:2339 [inline]
 __se_sys_sendmsg net/socket.c:2337 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8947:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
 __cache_free mm/slab.c:3432 [inline]
 kmem_cache_free+0x86/0x260 mm/slab.c:3698
 kfree_skbmem net/core/skbuff.c:625 [inline]
 kfree_skbmem+0xc5/0x150 net/core/skbuff.c:619
 __kfree_skb net/core/skbuff.c:682 [inline]
 kfree_skb net/core/skbuff.c:699 [inline]
 kfree_skb+0xf0/0x390 net/core/skbuff.c:693
 kfree_skb_list+0x44/0x60 net/core/skbuff.c:708
 __dev_xmit_skb net/core/dev.c:3551 [inline]
 __dev_queue_xmit+0x3034/0x36b0 net/core/dev.c:3850
 dev_queue_xmit+0x18/0x20 net/core/dev.c:3914
 neigh_direct_output+0x16/0x20 net/core/neighbour.c:1532
 neigh_output include/net/neighbour.h:511 [inline]
 ip6_finish_output2+0x1034/0x2550 net/ipv6/ip6_output.c:120
 ip6_fragment+0x1ebb/0x2680 net/ipv6/ip6_output.c:863
 __ip6_finish_output+0x577/0xaa0 net/ipv6/ip6_output.c:144
 ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:156
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0x235/0x7f0 net/ipv6/ip6_output.c:179
 dst_output include/net/dst.h:433 [inline]
 ip6_local_out+0xbb/0x1b0 net/ipv6/output_core.c:179
 ip6_send_skb+0xbb/0x350 net/ipv6/ip6_output.c:1796
 ip6_push_pending_frames+0xc8/0xf0 net/ipv6/ip6_output.c:1816
 rawv6_push_pending_frames net/ipv6/raw.c:617 [inline]
 rawv6_sendmsg+0x2993/0x35e0 net/ipv6/raw.c:947
 inet_sendmsg+0x141/0x5d0 net/ipv4/af_inet.c:802
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:671
 ___sys_sendmsg+0x803/0x920 net/socket.c:2292
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
 __do_sys_sendmsg net/socket.c:2339 [inline]
 __se_sys_sendmsg net/socket.c:2337 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888085a3cbc0
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 0 bytes inside of
 224-byte region [ffff888085a3cbc0, ffff888085a3cca0)
The buggy address belongs to the page:
page:ffffea0002168f00 refcount:1 mapcount:0 mapping:ffff88821b6f63c0 index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00027bbf88 ffffea0002105b88 ffff88821b6f63c0
raw: 0000000000000000 ffff888085a3c080 000000010000000c 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888085a3ca80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888085a3cb00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>ffff888085a3cb80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                           ^
 ffff888085a3cc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888085a3cc80: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc

Fixes: 0feca6190f88 ("net: ipv6: add skbuff fraglist splitter")
Fixes: c8b17be0b7a4 ("net: ipv4: add skbuff fraglist splitter")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip.h      | 1 -
 include/net/ipv6.h    | 1 -
 net/ipv4/ip_output.c  | 5 ++---
 net/ipv6/ip6_output.c | 5 ++---
 net/ipv6/netfilter.c  | 2 +-
 5 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 029cc3fd26bd7bfb1324100e068346700d0ed494..cd5cde5532d50ffd112f9ceee879e93d30fae22a 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -167,7 +167,6 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		   int (*output)(struct net *, struct sock *, struct sk_buff *));
 
 struct ip_fraglist_iter {
-	struct sk_buff	*frag_list;
 	struct sk_buff	*frag;
 	struct iphdr	*iph;
 	int		offset;
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 21bb830e9679b19fafb245b4a7f6a1f874811bd9..0d34f6ed968140fe46574c5ce47a5e1918d44885 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -156,7 +156,6 @@ struct frag_hdr {
 
 struct ip6_fraglist_iter {
 	struct ipv6hdr	*tmp_hdr;
-	struct sk_buff	*frag_list;
 	struct sk_buff	*frag;
 	int		offset;
 	unsigned int	hlen;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index ceca5285d9b457b00a5d3b069a43a643c838d67d..f5636ab0b9c32fa47eaa5417fec7cdc47e4dabc2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -575,8 +575,7 @@ void ip_fraglist_init(struct sk_buff *skb, struct iphdr *iph,
 {
 	unsigned int first_len = skb_pagelen(skb);
 
-	iter->frag_list = skb_shinfo(skb)->frag_list;
-	iter->frag = iter->frag_list;
+	iter->frag = skb_shinfo(skb)->frag_list;
 	skb_frag_list_init(skb);
 
 	iter->offset = 0;
@@ -845,7 +844,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			return 0;
 		}
 
-		kfree_skb_list(iter.frag_list);
+		kfree_skb_list(iter.frag);
 
 		IP_INC_STATS(net, IPSTATS_MIB_FRAGFAILS);
 		return err;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8fa83b78f81ad4b8f0e7c64583b84a228a621494..1f430cd49d8a64b7fb5ae829c7e8261a375e1053 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -613,8 +613,7 @@ int ip6_fraglist_init(struct sk_buff *skb, unsigned int hlen, u8 *prevhdr,
 	if (!iter->tmp_hdr)
 		return -ENOMEM;
 
-	iter->frag_list = skb_shinfo(skb)->frag_list;
-	iter->frag = iter->frag_list;
+	iter->frag = skb_shinfo(skb)->frag_list;
 	skb_frag_list_init(skb);
 
 	iter->offset = 0;
@@ -879,7 +878,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			return 0;
 		}
 
-		kfree_skb_list(iter.frag_list);
+		kfree_skb_list(iter.frag);
 
 		IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
 			      IPSTATS_MIB_FRAGFAILS);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 9530cc2809530af59823f4f2868767338ffb39b3..d9673e10c60cc73364d3d193dbf4a04352282dc9 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -194,7 +194,7 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		if (!err)
 			return 0;
 
-		kfree_skb_list(iter.frag_list);
+		kfree_skb_list(iter.frag);
 		return err;
 	}
 slow_path:
-- 
2.22.0.rc1.257.g3120a18244-goog

