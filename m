Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC05252DED
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 14:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgHZMC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 08:02:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10324 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729283AbgHZMCs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 08:02:48 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3735976B739DBCCF4DD5;
        Wed, 26 Aug 2020 20:02:45 +0800 (CST)
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Wed, 26 Aug 2020 20:02:37 +0800
From:   zhudi <zhudi21@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <ast@kernel.org>, <yhs@fb.com>, <netdev@vger.kernel.org>,
        <zhudi21@huawei.com>, <rose.chen@huawei.com>
Subject: [PATCH] netlink: fix a data race in netlink_rcv_wake()
Date:   Wed, 26 Aug 2020 20:01:13 +0800
Message-ID: <20200826120113.3244-1-zhudi21@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.114.155]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The data races were reported by KCSAN:
BUG: KCSAN: data-race in netlink_recvmsg / skb_queue_tail

write (marked) to 0xffff8c0986e5a8c8 of 8 bytes by interrupt on cpu 3:
 skb_queue_tail+0xcc/0x120
 __netlink_sendskb+0x55/0x80
 netlink_broadcast_filtered+0x465/0x7e0
 nlmsg_notify+0x8f/0x120
 rtnl_notify+0x8e/0xb0
 __neigh_notify+0xf2/0x120
 neigh_update+0x927/0xde0
 arp_process+0x8a3/0xf50
 arp_rcv+0x27c/0x3b0
 __netif_receive_skb_core+0x181c/0x1840
 __netif_receive_skb+0x38/0xf0
 netif_receive_skb_internal+0x77/0x1c0
 napi_gro_receive+0x1bd/0x1f0
 e1000_clean_rx_irq+0x538/0xb20 [e1000]
 e1000_clean+0x5e4/0x1340 [e1000]
 net_rx_action+0x310/0x9d0
 __do_softirq+0xe8/0x308
 irq_exit+0x109/0x110
 do_IRQ+0x7f/0xe0
 ret_from_intr+0x0/0x1d
 0xffffffffffffffff

read to 0xffff8c0986e5a8c8 of 8 bytes by task 1463 on cpu 0:
 netlink_recvmsg+0x40b/0x820
 sock_recvmsg+0xc9/0xd0
 ___sys_recvmsg+0x1a4/0x3b0
 __sys_recvmsg+0x86/0x120
 __x64_sys_recvmsg+0x52/0x70
 do_syscall_64+0xb5/0x360
 entry_SYSCALL_64_after_hwframe+0x65/0xca
 0xffffffffffffffff

Since the write is under sk_receive_queue->lock but the read
is done as lockless. so fix it by using skb_queue_empty_lockless()
instead of skb_queue_empty() for the read in netlink_rcv_wake()

Signed-off-by: zhudi <zhudi21@huawei.com>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index b5f30d7d30d0..d2d1448274f5 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -353,7 +353,7 @@ static void netlink_rcv_wake(struct sock *sk)
 {
 	struct netlink_sock *nlk = nlk_sk(sk);
 
-	if (skb_queue_empty(&sk->sk_receive_queue))
+	if (skb_queue_empty_lockless(&sk->sk_receive_queue))
 		clear_bit(NETLINK_S_CONGESTED, &nlk->state);
 	if (!test_bit(NETLINK_S_CONGESTED, &nlk->state))
 		wake_up_interruptible(&nlk->wait);
-- 
2.23.0

