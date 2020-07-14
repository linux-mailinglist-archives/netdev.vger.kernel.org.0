Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD07021E54B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 03:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGNBoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 21:44:38 -0400
Received: from mail5.windriver.com ([192.103.53.11]:40604 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgGNBoh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 21:44:37 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id 06E1gcr9004332
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Mon, 13 Jul 2020 18:42:48 -0700
Received: from pek-lpg-core1-vm1.wrs.com (128.224.156.106) by
 ALA-HCB.corp.ad.wrs.com (147.11.189.41) with Microsoft SMTP Server id
 14.3.487.0; Mon, 13 Jul 2020 18:42:15 -0700
From:   <qiang.zhang@windriver.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <tuong.t.lien@dektech.com.au>
CC:     <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] tipc: Don't using smp_processor_id() in preemptible code
Date:   Tue, 14 Jul 2020 09:53:41 +0800
Message-ID: <20200714015341.27446-1-qiang.zhang@windriver.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Qiang <qiang.zhang@windriver.com>

CPU: 0 PID: 6801 Comm: syz-executor201 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 check_preemption_disabled+0x128/0x130 lib/smp_processor_id.c:48
 tipc_aead_tfm_next net/tipc/crypto.c:402 [inline]
 tipc_aead_encrypt net/tipc/crypto.c:639 [inline]
 tipc_crypto_xmit+0x80a/0x2790 net/tipc/crypto.c:1605
 tipc_bearer_xmit_skb+0x180/0x3f0 net/tipc/bearer.c:523
 tipc_enable_bearer+0xb1d/0xdc0 net/tipc/bearer.c:331
 __tipc_nl_bearer_enable+0x2bf/0x390 net/tipc/bearer.c:995
 __tipc_nl_compat_doit net/tipc/netlink_compat.c:361 [inline]
 tipc_nl_compat_doit+0x440/0x640 net/tipc/netlink_compat.c:383
 tipc_nl_compat_handle net/tipc/netlink_compat.c:1268 [inline]
 tipc_nl_compat_recv+0x4ef/0xb40 net/tipc/netlink_compat.c:1311
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4476a9
Code: Bad RIP value.
RSP: 002b:00007fff2b6d5168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000000

Reported-by: syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com
Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>
---
 net/tipc/crypto.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 8c47ded2edb6..520af0afe1b3 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -399,9 +399,10 @@ static void tipc_aead_users_set(struct tipc_aead __rcu *aead, int val)
  */
 static struct crypto_aead *tipc_aead_tfm_next(struct tipc_aead *aead)
 {
-	struct tipc_tfm **tfm_entry = this_cpu_ptr(aead->tfm_entry);
+	struct tipc_tfm **tfm_entry = get_cpu_ptr(aead->tfm_entry);
 
 	*tfm_entry = list_next_entry(*tfm_entry, list);
+	put_cpu_ptr(tfm_entry);
 	return (*tfm_entry)->tfm;
 }
 
-- 
2.24.1

