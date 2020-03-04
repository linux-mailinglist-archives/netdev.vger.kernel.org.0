Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B3A1796BB
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgCDRcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:32:22 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:47292 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgCDRcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 12:32:21 -0500
Received: by mail-pf1-f202.google.com with SMTP id e16so1862427pfh.14
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 09:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=bLAECYQ9Fn4OfzrV+jEzEY8zP1xs/+96tvqemIbypdw=;
        b=om55iK5ZvL5BwDUdnbA4Rh6I8HGA7R/f2LEaLbuNFVBRkG5q9nUR+1unj4maR8fVYE
         x173w32iIYeKmeRfX9USSLyc38ogQcX6uGSQCRzYEmewoVUYfxcYo4URbyBXUsvKWiS8
         fyZQUqeG6STJ6S9M9EdqjxOW3tlsj1ewGpCGyOl8T5xpd80CXzjB2BKI9pKTKx1hmFUy
         0dCsX2bbrrsE4jP1fQuyFB0uuRoQUuO/10HrfWGs6PcyghjdJl7XFItwSiTlU1KWuKSv
         rC2VQe4Z+kOPTkYBgM3lP+yXgZAZguD45VZ8zasE2VS3t9NuSDmGIViAZmt1WiFhQumR
         P+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=bLAECYQ9Fn4OfzrV+jEzEY8zP1xs/+96tvqemIbypdw=;
        b=acyHgKdBEdglnpKUTBwmbiqI8Obxm+RDm+kgxQtKWEC12QmE4E2k45DNxfZj0zgJ8e
         ppM+hvYacSSBX44bnaYC1uci1Gi48I0sEr7McBsVs76pqSXZkfOMPnptcQWi0Q9YtPb1
         8zjUZKYMOR9kjh18t7oXjg8IUtT2IGgvmYL/RQG81NzRPa4wTe995qtQNDHdbsUPvd+t
         jERq4GCcL0mN0+Y1LTCJeljxI8FoN/odnYwKj2fb/KJ0jTtYrUjvE49NFEIRqXAPhPGT
         49MQFM+HK2CytB1LGwngvvd5DnRebdInB3HRdO947LIuj5gu8HapSimMcoc1KiH95+0t
         qV2A==
X-Gm-Message-State: ANhLgQ3AQSMt5xLrLGjzB1Z18s+4+eUI8qADL/l2GhcVPXjqrLsZZbti
        aTUVNinX6c7G/eu0NGwXygf7+Y1cXwT8eQ==
X-Google-Smtp-Source: ADFU+vtKtxOCZEw0ry9ZavN67EyhRl2A7szxoQk24vSyCLEC4wXheImZAGslVWXp2O9xDzOk4CQ9e9jtDzu4pg==
X-Received: by 2002:a63:d40a:: with SMTP id a10mr3404395pgh.53.1583343139069;
 Wed, 04 Mar 2020 09:32:19 -0800 (PST)
Date:   Wed,  4 Mar 2020 09:32:16 -0800
Message-Id: <20200304173216.98819-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH net] bonding/alb: make sure arp header is pulled before
 accessing it
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to commit 38f88c454042 ("bonding/alb: properly access headers
in bond_alb_xmit()"), we need to make sure arp header was pulled
in skb->head before blindly accessing it in rlb_arp_xmit().

Remove arp_pkt() private helper, since it is more readable/obvious
to have the following construct back to back :

	if (!pskb_network_may_pull(skb, sizeof(*arp)))
		return NULL;
	arp = (struct arp_pkt *)skb_network_header(skb);

syzbot reported :

BUG: KMSAN: uninit-value in bond_slave_has_mac_rx include/net/bonding.h:704 [inline]
BUG: KMSAN: uninit-value in rlb_arp_xmit drivers/net/bonding/bond_alb.c:662 [inline]
BUG: KMSAN: uninit-value in bond_alb_xmit+0x575/0x25e0 drivers/net/bonding/bond_alb.c:1477
CPU: 0 PID: 12743 Comm: syz-executor.4 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 bond_slave_has_mac_rx include/net/bonding.h:704 [inline]
 rlb_arp_xmit drivers/net/bonding/bond_alb.c:662 [inline]
 bond_alb_xmit+0x575/0x25e0 drivers/net/bonding/bond_alb.c:1477
 __bond_start_xmit drivers/net/bonding/bond_main.c:4257 [inline]
 bond_start_xmit+0x85d/0x2f70 drivers/net/bonding/bond_main.c:4282
 __netdev_start_xmit include/linux/netdevice.h:4524 [inline]
 netdev_start_xmit include/linux/netdevice.h:4538 [inline]
 xmit_one net/core/dev.c:3470 [inline]
 dev_hard_start_xmit+0x531/0xab0 net/core/dev.c:3486
 __dev_queue_xmit+0x37de/0x4220 net/core/dev.c:4063
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4096
 packet_snd net/packet/af_packet.c:2967 [inline]
 packet_sendmsg+0x8347/0x93b0 net/packet/af_packet.c:2992
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 __sys_sendto+0xc1b/0xc50 net/socket.c:1998
 __do_sys_sendto net/socket.c:2010 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:2006
 __x64_sys_sendto+0x6e/0x90 net/socket.c:2006
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c479
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc77ffbbc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fc77ffbc6d4 RCX: 000000000045c479
RDX: 000000000000000e RSI: 00000000200004c0 RDI: 0000000000000003
RBP: 000000000076bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a04 R14: 00000000004cc7b0 R15: 000000000076bf2c

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
 slab_alloc_node mm/slub.c:2793 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4401
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1051 [inline]
 alloc_skb_with_frags+0x18c/0xa70 net/core/skbuff.c:5766
 sock_alloc_send_pskb+0xada/0xc60 net/core/sock.c:2242
 packet_alloc_skb net/packet/af_packet.c:2815 [inline]
 packet_snd net/packet/af_packet.c:2910 [inline]
 packet_sendmsg+0x66a0/0x93b0 net/packet/af_packet.c:2992
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 __sys_sendto+0xc1b/0xc50 net/socket.c:1998
 __do_sys_sendto net/socket.c:2010 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:2006
 __x64_sys_sendto+0x6e/0x90 net/socket.c:2006
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
---
 drivers/net/bonding/bond_alb.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 1cc2cd894f877c0f6d9117ce008b7ef3fdfbcbcc..c81698550e5a78b091a761638ee35f887aacba1d 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -50,11 +50,6 @@ struct arp_pkt {
 };
 #pragma pack()
 
-static inline struct arp_pkt *arp_pkt(const struct sk_buff *skb)
-{
-	return (struct arp_pkt *)skb_network_header(skb);
-}
-
 /* Forward declaration */
 static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[],
 				      bool strict_match);
@@ -553,10 +548,11 @@ static void rlb_req_update_subnet_clients(struct bonding *bond, __be32 src_ip)
 	spin_unlock(&bond->mode_lock);
 }
 
-static struct slave *rlb_choose_channel(struct sk_buff *skb, struct bonding *bond)
+static struct slave *rlb_choose_channel(struct sk_buff *skb,
+					struct bonding *bond,
+					const struct arp_pkt *arp)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
-	struct arp_pkt *arp = arp_pkt(skb);
 	struct slave *assigned_slave, *curr_active_slave;
 	struct rlb_client_info *client_info;
 	u32 hash_index = 0;
@@ -653,8 +649,12 @@ static struct slave *rlb_choose_channel(struct sk_buff *skb, struct bonding *bon
  */
 static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 {
-	struct arp_pkt *arp = arp_pkt(skb);
 	struct slave *tx_slave = NULL;
+	struct arp_pkt *arp;
+
+	if (!pskb_network_may_pull(skb, sizeof(*arp)))
+		return NULL;
+	arp = (struct arp_pkt *)skb_network_header(skb);
 
 	/* Don't modify or load balance ARPs that do not originate locally
 	 * (e.g.,arrive via a bridge).
@@ -664,7 +664,7 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 
 	if (arp->op_code == htons(ARPOP_REPLY)) {
 		/* the arp must be sent on the selected rx channel */
-		tx_slave = rlb_choose_channel(skb, bond);
+		tx_slave = rlb_choose_channel(skb, bond, arp);
 		if (tx_slave)
 			bond_hw_addr_copy(arp->mac_src, tx_slave->dev->dev_addr,
 					  tx_slave->dev->addr_len);
@@ -676,7 +676,7 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 		 * When the arp reply is received the entry will be updated
 		 * with the correct unicast address of the client.
 		 */
-		tx_slave = rlb_choose_channel(skb, bond);
+		tx_slave = rlb_choose_channel(skb, bond, arp);
 
 		/* The ARP reply packets must be delayed so that
 		 * they can cancel out the influence of the ARP request.
-- 
2.25.0.265.gbab2e86ba0-goog

