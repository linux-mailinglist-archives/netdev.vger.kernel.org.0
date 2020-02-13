Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F2915B8C3
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 05:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgBME6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 23:58:31 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:57709 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgBME6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 23:58:31 -0500
Received: by mail-pj1-f73.google.com with SMTP id x16so2771822pjq.7
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 20:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fSV/FqSg75JfPnlfnxC+fbF+I4zDVQ0vwwWQAkPjV9k=;
        b=bqFbsFTbSj6H/d1bOFNOEmcvp7SSbi+Tr8J9EreH/Ve65fMHHYIWo/lMaodi4eabG5
         2QiDwrk0R5a8syFlP4IqJpOyvgdIdxez0cHxSM5RqgHCErfeWruqI3Av9BkHw+PO+Slg
         qmnw40jeRveSNLH0oKw6ZYKQe0LIW71p/5hrurOfquh3tj1uZK5cGrRP1IIeTm2Zsny2
         mHtAius8ugN4gU7RP18pvMW7egDw1RMii/CqQRqrf1FTBOPa4w54jfDY0/+AfUHAVFxo
         iSh/k7xqSxJPcNi87zUGTTZqee/QS4/kpzuuKM/dvV/Hbc6RMcYDITgXGiO2HSjR67VI
         Qr4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fSV/FqSg75JfPnlfnxC+fbF+I4zDVQ0vwwWQAkPjV9k=;
        b=hclzW+iBe/Dcsp5BCSGIqTxXSUNifU61ntN/Kn0IgjgU1cmK7gW/8cADMGTq26HerR
         NxAdxRbmTNFuV0Lmq50S/WU3mFLmmP8yM8OSbpttKyvgN/kHfkWRWmVhJl3QnzMfz10t
         OwUYJeEpJIsS2n6W07jW3SA0Gx/+7wEkD+lV4/70wP1s6zGR/43a61np0Zs7EDkVn4Ra
         2luOY5ViykV9+embfpzaDFZIYUe+d1Bd6F9n6tUH8cI7UM8XUMODzEbSe+djR80HOELT
         Qr8wVix0LEw9HQIv5I+3Dvb/U/kWn/GVqFoWjFRmhrctZ4in8yo6sw8rkzDTibJIvKrx
         J/pQ==
X-Gm-Message-State: APjAAAWv0TxJkDdXLxzi9iLaxevLxvK5pgsh/fkfucn6iliodKDeNKsV
        7nVoSHs4GBYYwNBvIuF+EZt1lDrrTA8onQ==
X-Google-Smtp-Source: APXvYqxeM8WeNxWcqdplbkX8JXiAMLDrzxHdpAmvoDeIolnFW+wtjF2sPDh9mEaBtzRlgwWhNbryEcqaDdH/8A==
X-Received: by 2002:a63:4305:: with SMTP id q5mr16930541pga.64.1581569909111;
 Wed, 12 Feb 2020 20:58:29 -0800 (PST)
Date:   Wed, 12 Feb 2020 20:58:26 -0800
Message-Id: <20200213045826.181478-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.225.g125e21ebc7-goog
Subject: [PATCH net] net: rtnetlink: fix bugs in rtnl_alt_ifname()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since IFLA_ALT_IFNAME is an NLA_STRING, we have no
guarantee it is nul terminated.

We should use nla_strdup() instead of kstrdup(), since this
helper will make sure not accessing out-of-bounds data.

BUG: KMSAN: uninit-value in strlen+0x5e/0xa0 lib/string.c:535
CPU: 1 PID: 19157 Comm: syz-executor.5 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 strlen+0x5e/0xa0 lib/string.c:535
 kstrdup+0x7f/0x1a0 mm/util.c:59
 rtnl_alt_ifname net/core/rtnetlink.c:3495 [inline]
 rtnl_linkprop+0x85d/0xc00 net/core/rtnetlink.c:3553
 rtnl_newlinkprop+0x9d/0xb0 net/core/rtnetlink.c:3568
 rtnetlink_rcv_msg+0x1153/0x1570 net/core/rtnetlink.c:5424
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5442
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x1248/0x14d0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45b3b9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff1c7b1ac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff1c7b1b6d4 RCX: 000000000045b3b9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009cb R14: 00000000004cb3dd R15: 000000000075bf2c

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
 slab_alloc_node mm/slub.c:2774 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4382
 __kmalloc_reserve net/core/skbuff.c:141 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:209
 alloc_skb include/linux/skbuff.h:1049 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1174 [inline]
 netlink_sendmsg+0x7d3/0x14d0 net/netlink/af_netlink.c:1892
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/rtnetlink.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 09c44bf2e1d28842d77b4ed442ef2c051a25ad21..e1152f4ffe33efb0a69f17a1f5940baa04942e5b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3504,27 +3504,25 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
 	if (err)
 		return err;
 
-	alt_ifname = nla_data(attr);
+	alt_ifname = nla_strdup(attr, GFP_KERNEL);
+	if (!alt_ifname)
+		return -ENOMEM;
+
 	if (cmd == RTM_NEWLINKPROP) {
-		alt_ifname = kstrdup(alt_ifname, GFP_KERNEL);
-		if (!alt_ifname)
-			return -ENOMEM;
 		err = netdev_name_node_alt_create(dev, alt_ifname);
-		if (err) {
-			kfree(alt_ifname);
-			return err;
-		}
+		if (!err)
+			alt_ifname = NULL;
 	} else if (cmd == RTM_DELLINKPROP) {
 		err = netdev_name_node_alt_destroy(dev, alt_ifname);
-		if (err)
-			return err;
 	} else {
-		WARN_ON(1);
-		return 0;
+		WARN_ON_ONCE(1);
+		err = -EINVAL;
 	}
 
-	*changed = true;
-	return 0;
+	kfree(alt_ifname);
+	if (!err)
+		*changed = true;
+	return err;
 }
 
 static int rtnl_linkprop(int cmd, struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.25.0.225.g125e21ebc7-goog

