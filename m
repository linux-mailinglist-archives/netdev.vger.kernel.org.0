Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDAD11175B9
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfLIT1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:27:08 -0500
Received: from correo.us.es ([193.147.175.20]:58482 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbfLIT06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 14:26:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7614812083A
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66506DA70D
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5C234DA707; Mon,  9 Dec 2019 20:26:56 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37261DA703;
        Mon,  9 Dec 2019 20:26:54 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 20:26:54 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 06DE84265A5A;
        Mon,  9 Dec 2019 20:26:53 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 16/17] netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()
Date:   Mon,  9 Dec 2019 20:26:37 +0100
Message-Id: <20191209192638.71184-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191209192638.71184-1-pablo@netfilter.org>
References: <20191209192638.71184-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot is kind enough to remind us we need to call skb_may_pull()

BUG: KMSAN: uninit-value in br_nf_forward_arp+0xe61/0x1230 net/bridge/br_netfilter_hooks.c:665
CPU: 1 PID: 11631 Comm: syz-executor.1 Not tainted 5.4.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
 __msan_warning+0x64/0xc0 mm/kmsan/kmsan_instr.c:245
 br_nf_forward_arp+0xe61/0x1230 net/bridge/br_netfilter_hooks.c:665
 nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
 nf_hook_slow+0x18b/0x3f0 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:260 [inline]
 NF_HOOK include/linux/netfilter.h:303 [inline]
 __br_forward+0x78f/0xe30 net/bridge/br_forward.c:109
 br_flood+0xef0/0xfe0 net/bridge/br_forward.c:234
 br_handle_frame_finish+0x1a77/0x1c20 net/bridge/br_input.c:162
 nf_hook_bridge_pre net/bridge/br_input.c:245 [inline]
 br_handle_frame+0xfb6/0x1eb0 net/bridge/br_input.c:348
 __netif_receive_skb_core+0x20b9/0x51a0 net/core/dev.c:4830
 __netif_receive_skb_one_core net/core/dev.c:4927 [inline]
 __netif_receive_skb net/core/dev.c:5043 [inline]
 process_backlog+0x610/0x13c0 net/core/dev.c:5874
 napi_poll net/core/dev.c:6311 [inline]
 net_rx_action+0x7a6/0x1aa0 net/core/dev.c:6379
 __do_softirq+0x4a1/0x83a kernel/softirq.c:293
 do_softirq_own_stack+0x49/0x80 arch/x86/entry/entry_64.S:1091
 </IRQ>
 do_softirq kernel/softirq.c:338 [inline]
 __local_bh_enable_ip+0x184/0x1d0 kernel/softirq.c:190
 local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
 rcu_read_unlock_bh include/linux/rcupdate.h:688 [inline]
 __dev_queue_xmit+0x38e8/0x4200 net/core/dev.c:3819
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:3825
 packet_snd net/packet/af_packet.c:2959 [inline]
 packet_sendmsg+0x8234/0x9100 net/packet/af_packet.c:2984
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg net/socket.c:657 [inline]
 __sys_sendto+0xc44/0xc70 net/socket.c:1952
 __do_sys_sendto net/socket.c:1964 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:1960
 __x64_sys_sendto+0x6e/0x90 net/socket.c:1960
 do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45a679
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f0a3c9e5c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 000000000045a679
RDX: 000000000000000e RSI: 0000000020000200 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 00000000200000c0 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0a3c9e66d4
R13: 00000000004c8ec1 R14: 00000000004dfe28 R15: 00000000ffffffff

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:149 [inline]
 kmsan_internal_poison_shadow+0x5c/0x110 mm/kmsan/kmsan.c:132
 kmsan_slab_alloc+0x97/0x100 mm/kmsan/kmsan_hooks.c:86
 slab_alloc_node mm/slub.c:2773 [inline]
 __kmalloc_node_track_caller+0xe27/0x11a0 mm/slub.c:4381
 __kmalloc_reserve net/core/skbuff.c:141 [inline]
 __alloc_skb+0x306/0xa10 net/core/skbuff.c:209
 alloc_skb include/linux/skbuff.h:1049 [inline]
 alloc_skb_with_frags+0x18c/0xa80 net/core/skbuff.c:5662
 sock_alloc_send_pskb+0xafd/0x10a0 net/core/sock.c:2244
 packet_alloc_skb net/packet/af_packet.c:2807 [inline]
 packet_snd net/packet/af_packet.c:2902 [inline]
 packet_sendmsg+0x63a6/0x9100 net/packet/af_packet.c:2984
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg net/socket.c:657 [inline]
 __sys_sendto+0xc44/0xc70 net/socket.c:1952
 __do_sys_sendto net/socket.c:1964 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:1960
 __x64_sys_sendto+0x6e/0x90 net/socket.c:1960
 do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: c4e70a87d975 ("netfilter: bridge: rename br_netfilter.c to br_netfilter_hooks.c")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter_hooks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index af7800103e51..59980ecfc962 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -662,6 +662,9 @@ static unsigned int br_nf_forward_arp(void *priv,
 		nf_bridge_pull_encap_header(skb);
 	}
 
+	if (unlikely(!pskb_may_pull(skb, sizeof(struct arphdr))))
+		return NF_DROP;
+
 	if (arp_hdr(skb)->ar_pln != 4) {
 		if (is_vlan_arp(skb, state->net))
 			nf_bridge_push_encap_header(skb);
-- 
2.11.0

