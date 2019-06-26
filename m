Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129FA5662F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfFZKE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:04:56 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:50271 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFZKEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:04:55 -0400
Received: by mail-vs1-f74.google.com with SMTP id u17so322266vsq.17
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 03:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9/6L5vmVRCoJKBlk6gvNNtX7RoVVp4OfK4gx1mvFsTc=;
        b=OOowgs8MAse9sN57rhRQbiFHE/mbpRhQYHXi0sbz0EgtPsofj67j4LBDeqhjpPxpBS
         h4WrdEGrwVr0uTeakyldZ25LTIPDr+x2X7TV6u3RQz5r7JB+BMVTu2Wew73oFmSNin4E
         VyO3ufGrMNahbWG81+lCBomsZ7SW5jRMrxzxDzFrBkYHTQmUGUyaVysr8f9b5kPYg/v0
         GAc6n33XFmV5SpvJ8Pyh1d57VCRl1NMA7A7xrnelTjX/cUzzD/OFJttQqJTO8K2yeb9l
         YQukW8yLaPtmWESrO1xUUswV+dvIgE5XBOFB1viZe7jD+HJ2t/5H5c8NzLElhTQ7j1Zd
         V94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9/6L5vmVRCoJKBlk6gvNNtX7RoVVp4OfK4gx1mvFsTc=;
        b=ESn+NFtEVJOc400HaiuHjVbQsjvj4gXmB1NFk2TY/0GnH4byoOOPwDIvUFL54UOnQj
         eadnROvIyyx11vmxklrGoGQgPmve56wYFO9b8irYn4+BRfIuUVu6X32De0AY6GLA3ylJ
         ffCJJABG7uXJbE2ldsvxCzczw2rRTsEM7rodoyZJoirZQ+k5Wj5xppmJuhCKcsKn0Y+5
         jqH6z/xphUKp1LiuIWBwVa7+jscLMhC/B3gw9ni6yjVcYZRHA6gJDSEPHspv00qJAKsU
         1d/eENSPE+sNPmhp5fuXiqjCWcFblwCj4EXXG0E4Av+lskhjWE0LKx+KMCzwNLg2j1tG
         Mrsw==
X-Gm-Message-State: APjAAAXBtq8O7svadc9gsy5ohHwM++DDivQlnEDZeM409AekRKW4PlF/
        W+7t++ynHO+LPoC37xRTMvBUZfVIEjg+Bw==
X-Google-Smtp-Source: APXvYqzZmcsnjP3D4x1VyVQhbylaoz0h1vtNU9kf4Rxpk3ZYK11g8pV0VzeHs/QaW0Zcc5cxd+4N798wK1V9RQ==
X-Received: by 2002:a1f:8914:: with SMTP id l20mr828433vkd.78.1561543494396;
 Wed, 26 Jun 2019 03:04:54 -0700 (PDT)
Date:   Wed, 26 Jun 2019 03:04:50 -0700
Message-Id: <20190626100450.217106-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net] ipv4: fix suspicious RCU usage in fib_dump_info_fnhe()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sysbot reported that we lack appropriate rcu_read_lock()
protection in fib_dump_info_fnhe()

net/ipv4/route.c:2875 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor609/8966:
 #0: 00000000b7dbe288 (rtnl_mutex){+.+.}, at: netlink_dump+0xe7/0xfb0 net/netlink/af_netlink.c:2199

stack backtrace:
CPU: 0 PID: 8966 Comm: syz-executor609 Not tainted 5.2.0-rc5+ #43
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 lockdep_rcu_suspicious+0x153/0x15d kernel/locking/lockdep.c:5250
 fib_dump_info_fnhe+0x9d9/0x1080 net/ipv4/route.c:2875
 fn_trie_dump_leaf net/ipv4/fib_trie.c:2141 [inline]
 fib_table_dump+0x64a/0xd00 net/ipv4/fib_trie.c:2175
 inet_dump_fib+0x83c/0xa90 net/ipv4/fib_frontend.c:1004
 rtnl_dump_all+0x295/0x490 net/core/rtnetlink.c:3445
 netlink_dump+0x558/0xfb0 net/netlink/af_netlink.c:2244
 __netlink_dump_start+0x5b1/0x7d0 net/netlink/af_netlink.c:2352
 netlink_dump_start include/linux/netlink.h:226 [inline]
 rtnetlink_rcv_msg+0x73d/0xb00 net/core/rtnetlink.c:5182
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5237
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:646 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:665
 sock_write_iter+0x27c/0x3e0 net/socket.c:994
 call_write_iter include/linux/fs.h:1872 [inline]
 new_sync_write+0x4d3/0x770 fs/read_write.c:483
 __vfs_write+0xe1/0x110 fs/read_write.c:496
 vfs_write+0x20c/0x580 fs/read_write.c:558
 ksys_write+0x14f/0x290 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write fs/read_write.c:620 [inline]
 __x64_sys_write+0x73/0xb0 fs/read_write.c:620
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4401b9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc8e134978 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401b9
RDX: 000000000000001c RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000010 R11: 0000000000000246 R12: 0000000000401a40
R13: 0000000000401ad0 R14: 0000000000000000 R15: 0000000000000000

Fixes: ee28906fd7a1 ("ipv4: Dump route exceptions if requested")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stefano Brivio <sbrivio@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/route.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6aee412a68bdd3c24a6a0eb9883e04b7a83998e0..59670fafcd2612b94c237cbe30109adb196cf3f0 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2872,12 +2872,13 @@ int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
 		if (nhc->nhc_flags & RTNH_F_DEAD)
 			continue;
 
+		rcu_read_lock();
 		bucket = rcu_dereference(nhc->nhc_exceptions);
-		if (!bucket)
-			continue;
-
-		err = fnhe_dump_bucket(net, skb, cb, table_id, bucket, genid,
-				       fa_index, fa_start);
+		err = 0;
+		if (bucket)
+			err = fnhe_dump_bucket(net, skb, cb, table_id, bucket,
+					       genid, fa_index, fa_start);
+		rcu_read_unlock();
 		if (err)
 			return err;
 	}
-- 
2.22.0.410.gd8fdbe21b5-goog

