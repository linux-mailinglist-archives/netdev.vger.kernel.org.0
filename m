Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 254DC6181F
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 00:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfGGWxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 18:53:35 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:56232 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbfGGWxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 18:53:35 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 14904891A9;
        Mon,  8 Jul 2019 10:53:32 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1562540012;
        bh=Kjsk6rV8pnwA4FIwlwGK2H50lU2Gv4bblD7wJpSOkBA=;
        h=From:To:Cc:Subject:Date;
        b=UIfuh56h3xXRfyXqZsmmij7AKbMGHp6GBr2PzMScA/IIjhjqFTAotxI1a24II06XW
         4YRBKC0XMWv7lGmMVh+bWFj48TOBaqxLfl7QXUDQnVAlBYHE7E0zUgZsGHKLJYN43Q
         Sn9JlsghIcgaoubgh3itlZnauuqF/Sb3LFyLW3QMHUvkbEO+MdAsgyle6sRQxrJ2FI
         e0uXlJcIEOob+77WotosHDZAC2fZ/ReEvzCVl6rOd4uOhn2enaAkGHVORw5VG5TvQl
         h9Gh5PsEhp4uazaEJQ+P3xoeooP15NlbwAbmhgUnFRhQJkDSulS9CNuB9oEQD4Kw+3
         HhtaJzbrszr1g==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d2277e90000>; Mon, 08 Jul 2019 10:53:29 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by smtp (Postfix) with ESMTP id 7842C13EECF;
        Mon,  8 Jul 2019 10:53:33 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id C6F8D1E0BBE; Mon,  8 Jul 2019 10:53:31 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     jon.maloy@ericsson.com, ying.xue@windriver.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH] tipc: ensure skb->lock is initialised
Date:   Mon,  8 Jul 2019 10:53:28 +1200
Message-Id: <20190707225328.15852-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tipc_named_node_up() creates a skb list. It passes the list to
tipc_node_xmit() which has some code paths that can call
skb_queue_purge() which relies on the list->lock being initialised.
Ensure tipc_named_node_up() uses skb_queue_head_init() so that the lock
is explicitly initialised.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

I'm updating our products to use the latest kernel. One change that we ha=
ve that
doesn't appear to have been upstreamed is related to the following soft l=
ockup.

NMI watchdog: BUG: soft lockup - CPU#3 stuck for 23s! [swapper/3:0]
Modules linked in: tipc jitterentropy_rng echainiv drbg platform_driver(O=
) ipifwd(PO)
CPU: 3 PID: 0 Comm: swapper/3 Tainted: P           O    4.4.6-at1 #1
task: a3054e00 ti: ac6b4000 task.ti: a307a000
NIP: 806891c4 LR: 804f5060 CTR: 804f50d0
REGS: ac6b59b0 TRAP: 0901   Tainted: P           O     (4.4.6-at1)
MSR: 00029002 <CE,EE,ME>  CR: 84002088  XER: 20000000

GPR00: 804f50fc ac6b5a60 a3054e00 00029002 00000101 01001011 00000000 000=
00001
GPR08: 00021002 c1502d1c ac6b5ae4 00000000 804f50d0
NIP [806891c4] _raw_spin_lock_irqsave+0x44/0x80
LR [804f5060] skb_dequeue+0x20/0x90
Call Trace:
[ac6b5a80] [804f50fc] skb_queue_purge+0x2c/0x50
[ac6b5a90] [c1511058] tipc_node_xmit+0x138/0x170 [tipc]
[ac6b5ad0] [c1509e58] tipc_named_node_up+0x88/0xa0 [tipc]
[ac6b5b00] [c150fc1c] tipc_netlink_compat_stop+0x9bc/0xf50 [tipc]
[ac6b5b20] [c1511638] tipc_rcv+0x418/0x9b0 [tipc]
[ac6b5bc0] [c150218c] tipc_bcast_stop+0xfc/0x7b0 [tipc]
[ac6b5bd0] [80504e38] __netif_receive_skb_core+0x468/0xa10
[ac6b5c70] [805082fc] netif_receive_skb_internal+0x3c/0xe0
[ac6b5ca0] [80642a48] br_handle_frame_finish+0x1d8/0x4d0
[ac6b5d10] [80642f30] br_handle_frame+0x1f0/0x330
[ac6b5d60] [80504ec8] __netif_receive_skb_core+0x4f8/0xa10
[ac6b5e00] [805082fc] netif_receive_skb_internal+0x3c/0xe0
[ac6b5e30] [8044c868] _dpa_rx+0x148/0x5c0
[ac6b5ea0] [8044b0c8] priv_rx_default_dqrr+0x98/0x170
[ac6b5ed0] [804d1338] qman_p_poll_dqrr+0x1b8/0x240
[ac6b5f00] [8044b1c0] dpaa_eth_poll+0x20/0x60
[ac6b5f20] [805087cc] net_rx_action+0x15c/0x320
[ac6b5f80] [8002594c] __do_softirq+0x13c/0x250
[ac6b5fe0] [80025c34] irq_exit+0xb4/0xf0
[ac6b5ff0] [8000d81c] call_do_irq+0x24/0x3c
[a307be60] [80004acc] do_IRQ+0x8c/0x120
[a307be80] [8000f450] ret_from_except+0x0/0x18
--- interrupt: 501 at arch_cpu_idle+0x24/0x70

Eyeballing the code I think it can still happen since tipc_named_node_up
allocates struct sk_buff_head head on the stack so it could have arbitary
content.

 net/tipc/name_distr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 61219f0b9677..44abc8e9c990 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -190,7 +190,7 @@ void tipc_named_node_up(struct net *net, u32 dnode)
 	struct name_table *nt =3D tipc_name_table(net);
 	struct sk_buff_head head;
=20
-	__skb_queue_head_init(&head);
+	skb_queue_head_init(&head);
=20
 	read_lock_bh(&nt->cluster_scope_lock);
 	named_distribute(net, &head, dnode, &nt->cluster_scope);
--=20
2.22.0

