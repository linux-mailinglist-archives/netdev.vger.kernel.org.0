Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C55130059
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 04:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgADDCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 22:02:45 -0500
Received: from mail1.windriver.com ([147.11.146.13]:54411 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbgADDCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 22:02:45 -0500
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail1.windriver.com (8.15.2/8.15.2) with ESMTPS id 00432SUt012056
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 3 Jan 2020 19:02:28 -0800 (PST)
Received: from pek-yxue-d1.wrs.com (128.224.155.99) by ALA-HCB.corp.ad.wrs.com
 (147.11.189.41) with Microsoft SMTP Server id 14.3.468.0; Fri, 3 Jan 2020
 19:02:09 -0800
From:   Ying Xue <ying.xue@windriver.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <maloy@donjonn.com>, <tipc-discussion@lists.sourceforge.net>
Subject: [PATCH net] tipc: eliminate KMSAN: uninit-value in __tipc_nl_compat_dumpit error
Date:   Sat, 4 Jan 2020 10:48:36 +0800
Message-ID: <1578106116-22543-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found the following crash on:
=====================================================
BUG: KMSAN: uninit-value in __nlmsg_parse include/net/netlink.h:661 [inline]
BUG: KMSAN: uninit-value in nlmsg_parse_deprecated
include/net/netlink.h:706 [inline]
BUG: KMSAN: uninit-value in __tipc_nl_compat_dumpit+0x553/0x11e0
net/tipc/netlink_compat.c:215
CPU: 0 PID: 12425 Comm: syz-executor062 Not tainted 5.5.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x220 lib/dump_stack.c:118
  kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
  __msan_warning+0x57/0xa0 mm/kmsan/kmsan_instr.c:245
  __nlmsg_parse include/net/netlink.h:661 [inline]
  nlmsg_parse_deprecated include/net/netlink.h:706 [inline]
  __tipc_nl_compat_dumpit+0x553/0x11e0 net/tipc/netlink_compat.c:215
  tipc_nl_compat_dumpit+0x761/0x910 net/tipc/netlink_compat.c:308
  tipc_nl_compat_handle net/tipc/netlink_compat.c:1252 [inline]
  tipc_nl_compat_recv+0x12e9/0x2870 net/tipc/netlink_compat.c:1311
  genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
  genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
  genl_rcv_msg+0x1dd0/0x23a0 net/netlink/genetlink.c:734
  netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
  genl_rcv+0x63/0x80 net/netlink/genetlink.c:745
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0xfa0/0x1100 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x11f0/0x1480 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg net/socket.c:659 [inline]
  ____sys_sendmsg+0x1362/0x13f0 net/socket.c:2330
  ___sys_sendmsg net/socket.c:2384 [inline]
  __sys_sendmsg+0x4f0/0x5e0 net/socket.c:2417
  __do_sys_sendmsg net/socket.c:2426 [inline]
  __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:295
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x444179
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
ff 0f 83 1b d8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd2d6409c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002e0 RCX: 0000000000444179
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00000000006ce018 R08: 0000000000000000 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401e20
R13: 0000000000401eb0 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:149 [inline]
  kmsan_internal_poison_shadow+0x5c/0x110 mm/kmsan/kmsan.c:132
  kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:86
  slab_alloc_node mm/slub.c:2774 [inline]
  __kmalloc_node_track_caller+0xe47/0x11f0 mm/slub.c:4382
  __kmalloc_reserve net/core/skbuff.c:141 [inline]
  __alloc_skb+0x309/0xa50 net/core/skbuff.c:209
  alloc_skb include/linux/skbuff.h:1049 [inline]
  nlmsg_new include/net/netlink.h:888 [inline]
  tipc_nl_compat_dumpit+0x6e4/0x910 net/tipc/netlink_compat.c:301
  tipc_nl_compat_handle net/tipc/netlink_compat.c:1252 [inline]
  tipc_nl_compat_recv+0x12e9/0x2870 net/tipc/netlink_compat.c:1311
  genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
  genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
  genl_rcv_msg+0x1dd0/0x23a0 net/netlink/genetlink.c:734
  netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
  genl_rcv+0x63/0x80 net/netlink/genetlink.c:745
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0xfa0/0x1100 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x11f0/0x1480 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg net/socket.c:659 [inline]
  ____sys_sendmsg+0x1362/0x13f0 net/socket.c:2330
  ___sys_sendmsg net/socket.c:2384 [inline]
  __sys_sendmsg+0x4f0/0x5e0 net/socket.c:2417
  __do_sys_sendmsg net/socket.c:2426 [inline]
  __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
  do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:295
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================

The complaint above occurred because the memory region pointed by attrbuf
variable was not initialized. To eliminate this warning, we use kcalloc()
rather than kmalloc_array() to allocate memory for attrbuf.

Reported-by: syzbot+b1fd2bf2c89d8407e15f@syzkaller.appspotmail.com
Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 net/tipc/netlink_compat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 0254bb7..2175163 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -204,8 +204,8 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 		return -ENOMEM;
 	}
 
-	attrbuf = kmalloc_array(tipc_genl_family.maxattr + 1,
-				sizeof(struct nlattr *), GFP_KERNEL);
+	attrbuf = kcalloc(tipc_genl_family.maxattr + 1,
+			  sizeof(struct nlattr *), GFP_KERNEL);
 	if (!attrbuf) {
 		err = -ENOMEM;
 		goto err_out;
-- 
2.7.4

