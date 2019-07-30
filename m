Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4E07B1A2
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfG3STN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:19:13 -0400
Received: from sesbmg22.ericsson.net ([193.180.251.48]:58890 "EHLO
        sesbmg22.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfG3STM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 14:19:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=ericsson.com; s=mailgw201801; c=relaxed/relaxed;
        q=dns/txt; i=@ericsson.com; t=1564510750; x=1567102750;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+8EYEm8m1UUM7pXFO3r+NVlqvpnr94TuqJghz7Kg3CY=;
        b=dBkoLc8iGXpJXG7AerZMygTp5RDxPPZVpjz8X4L5O/yTXD46H9TqhRrff6YbtJXG
        5W9HZHndDhajjl6bQnqQPc55//cQMVOs4rSrPyXI2DM/OHTygQBmZpJM5zojuJST
        0DCvb3CYnKpweQDTLDNpZzBdlWESzQ/zkL9BoiUjfRg=;
X-AuditID: c1b4fb30-6ddff70000001814-3b-5d408a1e26ba
Received: from ESESSMB501.ericsson.se (Unknown_Domain [153.88.183.119])
        by sesbmg22.ericsson.net (Symantec Mail Security) with SMTP id 40.3E.06164.E1A804D5; Tue, 30 Jul 2019 20:19:10 +0200 (CEST)
Received: from ESESBMB503.ericsson.se (153.88.183.170) by
 ESESSMB501.ericsson.se (153.88.183.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 30 Jul 2019 20:19:10 +0200
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.186) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 30 Jul 2019 20:19:10 +0200
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <tung.q.nguyen@dektech.com.au>, <hoang.h.le@dektech.com.au>,
        <jon.maloy@ericsson.com>, <lxin@redhat.com>, <shuali@redhat.com>,
        <ying.xue@windriver.com>, <tipc-discussion@lists.sourceforge.net>
Subject: [net  1/1] tipc: fix unitilized skb list crash
Date:   Tue, 30 Jul 2019 20:19:10 +0200
Message-ID: <1564510750-19531-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsUyM2J7ua5cl0OswYQvehZzzrewWLx9NYvd
        YvmVNywWxxaIWUxdt5LZYsv5LIsr7WfZLR5fv87swOGxZeVNJo93V9g8di/4zOTxft9VNo/P
        m+Q81m/ZyhTAFsVlk5Kak1mWWqRvl8CVsf3jIraCyeoVp546NzCuVuxi5OSQEDCR2HC9k72L
        kYtDSOAoo8SsFYvYIJxvjBJXLi5ggnAuMErsOfmfBaSFTUBD4uW0DkYQW0TAWOLVyk6wImaB
        E4wSG8+uAisSFjCXeN7+mQnEZhFQlTg2ewEbiM0r4Cbx8eolJojdchLnj/9kBrGFBJQl5n6Y
        xgRRIyhxcuYTsDnMAhISB1+8YJ7AyDcLSWoWktQCRqZVjKLFqcVJuelGRnqpRZnJxcX5eXp5
        qSWbGIHhenDLb4MdjC+fOx5iFOBgVOLhfbtFPFaINbGsuDL3EKMEB7OSCK/kOZFYId6UxMqq
        1KL8+KLSnNTiQ4zSHCxK4rzrvf/FCAmkJ5akZqemFqQWwWSZODilGhgFp9StUHjP7vltYm/3
        1XtOF53Wf9Fa8+3VRrdSpTI229InZ9d4nLi97O4R2+jPBmfb5/q9t+zeHVR3QjoufVtsUtOC
        z74tHh8XrmDSjVsm2BA1dbe/tNH6HAYPjznLnI8UdjL5PalYK7HGTyhvnyZjXf0al87amzGq
        TwI+9jK4Pmn56Che/1WJpTgj0VCLuag4EQAIvBTgUwIAAA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our test suite somtimes provokes the following crash:

Description of problem:
[ 1092.597234] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e8
[ 1092.605072] PGD 0 P4D 0
[ 1092.607620] Oops: 0000 [#1] SMP PTI
[ 1092.611118] CPU: 37 PID: 0 Comm: swapper/37 Kdump: loaded Not tainted 4.18.0-122.el8.x86_64 #1
[ 1092.619724] Hardware name: Dell Inc. PowerEdge R740/08D89F, BIOS 1.3.7 02/08/2018
[ 1092.627215] RIP: 0010:tipc_mcast_filter_msg+0x93/0x2d0 [tipc]
[ 1092.632955] Code: 0f 84 aa 01 00 00 89 cf 4d 01 ca 4c 8b 26 c1 ef 19 83 e7 0f 83 ff 0c 4d 0f 45 d1 41 8b 6a 10 0f cd 4c 39 e6 0f 84 81 01 00 00 <4d> 8b 9c 24 e8 00 00 00 45 8b 13 41 0f ca 44 89 d7 c1 ef 13 83 e7
[ 1092.651703] RSP: 0018:ffff929e5fa83a18 EFLAGS: 00010282
[ 1092.656927] RAX: ffff929e3fb38100 RBX: 00000000069f29ee RCX: 00000000416c0045
[ 1092.664058] RDX: ffff929e5fa83a88 RSI: ffff929e31a28420 RDI: 0000000000000000
[ 1092.671209] RBP: 0000000029b11821 R08: 0000000000000000 R09: ffff929e39b4407a
[ 1092.678343] R10: ffff929e39b4407a R11: 0000000000000007 R12: 0000000000000000
[ 1092.685475] R13: 0000000000000001 R14: ffff929e3fb38100 R15: ffff929e39b4407a
[ 1092.692614] FS:  0000000000000000(0000) GS:ffff929e5fa80000(0000) knlGS:0000000000000000
[ 1092.700702] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1092.706447] CR2: 00000000000000e8 CR3: 000000031300a004 CR4: 00000000007606e0
[ 1092.713579] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1092.720712] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1092.727843] PKRU: 55555554
[ 1092.730556] Call Trace:
[ 1092.733010]  <IRQ>
[ 1092.735034]  tipc_sk_filter_rcv+0x7ca/0xb80 [tipc]
[ 1092.739828]  ? __kmalloc_node_track_caller+0x1cb/0x290
[ 1092.744974]  ? dev_hard_start_xmit+0xa5/0x210
[ 1092.749332]  tipc_sk_rcv+0x389/0x640 [tipc]
[ 1092.753519]  tipc_sk_mcast_rcv+0x23c/0x3a0 [tipc]
[ 1092.758224]  tipc_rcv+0x57a/0xf20 [tipc]
[ 1092.762154]  ? ktime_get_real_ts64+0x40/0xe0
[ 1092.766432]  ? tpacket_rcv+0x50/0x9f0
[ 1092.770098]  tipc_l2_rcv_msg+0x4a/0x70 [tipc]
[ 1092.774452]  __netif_receive_skb_core+0xb62/0xbd0
[ 1092.779164]  ? enqueue_entity+0xf6/0x630
[ 1092.783084]  ? kmem_cache_alloc+0x158/0x1c0
[ 1092.787272]  ? __build_skb+0x25/0xd0
[ 1092.790849]  netif_receive_skb_internal+0x42/0xf0
[ 1092.795557]  napi_gro_receive+0xba/0xe0
[ 1092.799417]  mlx5e_handle_rx_cqe+0x83/0xd0 [mlx5_core]
[ 1092.804564]  mlx5e_poll_rx_cq+0xd5/0x920 [mlx5_core]
[ 1092.809536]  mlx5e_napi_poll+0xb2/0xce0 [mlx5_core]
[ 1092.814415]  ? __wake_up_common_lock+0x89/0xc0
[ 1092.818861]  net_rx_action+0x149/0x3b0
[ 1092.822616]  __do_softirq+0xe3/0x30a
[ 1092.826193]  irq_exit+0x100/0x110
[ 1092.829512]  do_IRQ+0x85/0xd0
[ 1092.832483]  common_interrupt+0xf/0xf
[ 1092.836147]  </IRQ>
[ 1092.838255] RIP: 0010:cpuidle_enter_state+0xb7/0x2a0
[ 1092.843221] Code: e8 3e 79 a5 ff 80 7c 24 03 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 d7 01 00 00 31 ff e8 a0 6b ab ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 4c 29 f3 ba ff ff ff 7f 48 39 c3 7f
[ 1092.861967] RSP: 0018:ffffaa5ec6533e98 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdd
[ 1092.869530] RAX: ffff929e5faa3100 RBX: 000000fe63dd2092 RCX: 000000000000001f
[ 1092.876665] RDX: 000000fe63dd2092 RSI: 000000003a518aaa RDI: 0000000000000000
[ 1092.883795] RBP: 0000000000000003 R08: 0000000000000004 R09: 0000000000022940
[ 1092.890929] R10: 0000040cb0666b56 R11: ffff929e5faa20a8 R12: ffff929e5faade78
[ 1092.898060] R13: ffffffffb59258f8 R14: 000000fe60f3228d R15: 0000000000000000
[ 1092.905196]  ? cpuidle_enter_state+0x92/0x2a0
[ 1092.909555]  do_idle+0x236/0x280
[ 1092.912785]  cpu_startup_entry+0x6f/0x80
[ 1092.916715]  start_secondary+0x1a7/0x200
[ 1092.920642]  secondary_startup_64+0xb7/0xc0
[...]

The reason is that the skb list tipc_socket::mc_method.deferredq only
is initialized for connectionless sockets, while nothing stops arriving
multicast messages from being filtered by connection oriented sockets,
with subsequent access to the said list.

We fix this by initializing the list unconditionally at socket creation.
This eliminates the crash, while the message still is dropped further
down in tipc_sk_filter_rcv() as it should be.

Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/socket.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index dd8537f..83ae41d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -485,9 +485,8 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 		tsk_set_unreturnable(tsk, true);
 		if (sock->type == SOCK_DGRAM)
 			tsk_set_unreliable(tsk, true);
-		__skb_queue_head_init(&tsk->mc_method.deferredq);
 	}
-
+	__skb_queue_head_init(&tsk->mc_method.deferredq);
 	trace_tipc_sk_create(sk, NULL, TIPC_DUMP_NONE, " ");
 	return 0;
 }
-- 
2.1.4

