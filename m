Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1C91B23F9
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgDUKiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:38:12 -0400
Received: from correo.us.es ([193.147.175.20]:51084 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbgDUKiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 06:38:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8B575FB459
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:38:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F54210078C
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:38:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 74D08FF6FE; Tue, 21 Apr 2020 12:38:08 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6BF82FC54C;
        Tue, 21 Apr 2020 12:38:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Apr 2020 12:38:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 45C3942EF42A;
        Tue, 21 Apr 2020 12:38:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/2] netfilter: nat: fix error handling upon registering inet hook
Date:   Tue, 21 Apr 2020 12:37:59 +0200
Message-Id: <20200421103759.959074-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200421103759.959074-1-pablo@netfilter.org>
References: <20200421103759.959074-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

A case of warning was reported by syzbot.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 19934 at net/netfilter/nf_nat_core.c:1106
nf_nat_unregister_fn+0x532/0x5c0 net/netfilter/nf_nat_core.c:1106
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 19934 Comm: syz-executor.5 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:nf_nat_unregister_fn+0x532/0x5c0 net/netfilter/nf_nat_core.c:1106
Code: ff df 48 c1 ea 03 80 3c 02 00 75 75 48 8b 44 24 10 4c 89 ef 48 c7 00 00 00 00 00 e8 e8 f8 53 fb e9 4d fe ff ff e8 ee 9c 16 fb <0f> 0b e9 41 fe ff ff e8 e2 45 54 fb e9 b5 fd ff ff 48 8b 7c 24 20
RSP: 0018:ffffc90005487208 EFLAGS: 00010246
RAX: 0000000000040000 RBX: 0000000000000004 RCX: ffffc9001444a000
RDX: 0000000000040000 RSI: ffffffff865c94a2 RDI: 0000000000000005
RBP: ffff88808b5cf000 R08: ffff8880a2620140 R09: fffffbfff14bcd79
R10: ffffc90005487208 R11: fffffbfff14bcd78 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
 nf_nat_ipv6_unregister_fn net/netfilter/nf_nat_proto.c:1017 [inline]
 nf_nat_inet_register_fn net/netfilter/nf_nat_proto.c:1038 [inline]
 nf_nat_inet_register_fn+0xfc/0x140 net/netfilter/nf_nat_proto.c:1023
 nf_tables_register_hook net/netfilter/nf_tables_api.c:224 [inline]
 nf_tables_addchain.constprop.0+0x82e/0x13c0 net/netfilter/nf_tables_api.c:1981
 nf_tables_newchain+0xf68/0x16a0 net/netfilter/nf_tables_api.c:2235
 nfnetlink_rcv_batch+0x83a/0x1610 net/netfilter/nfnetlink.c:433
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

and to quiesce it, unregister NFPROTO_IPV6 hook instead of NFPROTO_INET
in case of failing to register NFPROTO_IPV4 hook.

Reported-by: syzbot <syzbot+33e06702fd6cffc24c40@syzkaller.appspotmail.com>
Fixes: d164385ec572 ("netfilter: nat: add inet family nat support")
Cc: Florian Westphal <fw@strlen.de>
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_proto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 64eedc17037a..3d816a1e5442 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -1035,8 +1035,8 @@ int nf_nat_inet_register_fn(struct net *net, const struct nf_hook_ops *ops)
 	ret = nf_nat_register_fn(net, NFPROTO_IPV4, ops, nf_nat_ipv4_ops,
 				 ARRAY_SIZE(nf_nat_ipv4_ops));
 	if (ret)
-		nf_nat_ipv6_unregister_fn(net, ops);
-
+		nf_nat_unregister_fn(net, NFPROTO_IPV6, ops,
+					ARRAY_SIZE(nf_nat_ipv6_ops));
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_nat_inet_register_fn);
-- 
2.11.0

