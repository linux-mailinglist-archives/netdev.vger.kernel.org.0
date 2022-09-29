Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E635EED1D
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 07:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiI2FOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 01:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiI2FOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 01:14:06 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC5C11BCEA
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 22:14:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1F57120082;
        Thu, 29 Sep 2022 07:14:03 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id I5eUhqgSyzv9; Thu, 29 Sep 2022 07:14:02 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A24C7204B4;
        Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 93AD480004A;
        Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 07:14:01 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 29 Sep
 2022 07:14:01 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B804E3182ADC; Thu, 29 Sep 2022 07:14:00 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/3] xfrm: Reinject transport-mode packets through workqueue
Date:   Thu, 29 Sep 2022 07:13:57 +0200
Message-ID: <20220929051357.3497325-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929051357.3497325-1-steffen.klassert@secunet.com>
References: <20220929051357.3497325-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

The following warning is displayed when the tcp6-multi-diffip11 stress
test case of the LTP test suite is tested:

watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [ns-tcpserver:48198]
CPU: 0 PID: 48198 Comm: ns-tcpserver Kdump: loaded Not tainted 6.0.0-rc6+ #39
Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : des3_ede_encrypt+0x27c/0x460 [libdes]
lr : 0x3f
sp : ffff80000ceaa1b0
x29: ffff80000ceaa1b0 x28: ffff0000df056100 x27: ffff0000e51e5280
x26: ffff80004df75030 x25: ffff0000e51e4600 x24: 000000000000003b
x23: 0000000000802080 x22: 000000000000003d x21: 0000000000000038
x20: 0000000080000020 x19: 000000000000000a x18: 0000000000000033
x17: ffff0000e51e4780 x16: ffff80004e2d1448 x15: ffff80004e2d1248
x14: ffff0000e51e4680 x13: ffff80004e2d1348 x12: ffff80004e2d1548
x11: ffff80004e2d1848 x10: ffff80004e2d1648 x9 : ffff80004e2d1748
x8 : ffff80004e2d1948 x7 : 000000000bcaf83d x6 : 000000000000001b
x5 : ffff80004e2d1048 x4 : 00000000761bf3bf x3 : 000000007f1dd0a3
x2 : ffff0000e51e4780 x1 : ffff0000e3b9a2f8 x0 : 00000000db44e872
Call trace:
 des3_ede_encrypt+0x27c/0x460 [libdes]
 crypto_des3_ede_encrypt+0x1c/0x30 [des_generic]
 crypto_cbc_encrypt+0x148/0x190
 crypto_skcipher_encrypt+0x2c/0x40
 crypto_authenc_encrypt+0xc8/0xfc [authenc]
 crypto_aead_encrypt+0x2c/0x40
 echainiv_encrypt+0x144/0x1a0 [echainiv]
 crypto_aead_encrypt+0x2c/0x40
 esp6_output_tail+0x1c8/0x5d0 [esp6]
 esp6_output+0x120/0x278 [esp6]
 xfrm_output_one+0x458/0x4ec
 xfrm_output_resume+0x6c/0x1f0
 xfrm_output+0xac/0x4ac
 __xfrm6_output+0x130/0x270
 xfrm6_output+0x60/0xec
 ip6_xmit+0x2ec/0x5bc
 inet6_csk_xmit+0xbc/0x10c
 __tcp_transmit_skb+0x460/0x8c0
 tcp_write_xmit+0x348/0x890
 __tcp_push_pending_frames+0x44/0x110
 tcp_rcv_established+0x3c8/0x720
 tcp_v6_do_rcv+0xdc/0x4a0
 tcp_v6_rcv+0xc24/0xcb0
 ip6_protocol_deliver_rcu+0xf0/0x574
 ip6_input_finish+0x48/0x7c
 ip6_input+0x48/0xc0
 ip6_rcv_finish+0x80/0x9c
 xfrm_trans_reinject+0xb0/0xf4
 tasklet_action_common.constprop.0+0xf8/0x134
 tasklet_action+0x30/0x3c
 __do_softirq+0x128/0x368
 do_softirq+0xb4/0xc0
 __local_bh_enable_ip+0xb0/0xb4
 put_cpu_fpsimd_context+0x40/0x70
 kernel_neon_end+0x20/0x40
 sha1_base_do_update.constprop.0.isra.0+0x11c/0x140 [sha1_ce]
 sha1_ce_finup+0x94/0x110 [sha1_ce]
 crypto_shash_finup+0x34/0xc0
 hmac_finup+0x48/0xe0
 crypto_shash_finup+0x34/0xc0
 shash_digest_unaligned+0x74/0x90
 crypto_shash_digest+0x4c/0x9c
 shash_ahash_digest+0xc8/0xf0
 shash_async_digest+0x28/0x34
 crypto_ahash_digest+0x48/0xcc
 crypto_authenc_genicv+0x88/0xcc [authenc]
 crypto_authenc_encrypt+0xd8/0xfc [authenc]
 crypto_aead_encrypt+0x2c/0x40
 echainiv_encrypt+0x144/0x1a0 [echainiv]
 crypto_aead_encrypt+0x2c/0x40
 esp6_output_tail+0x1c8/0x5d0 [esp6]
 esp6_output+0x120/0x278 [esp6]
 xfrm_output_one+0x458/0x4ec
 xfrm_output_resume+0x6c/0x1f0
 xfrm_output+0xac/0x4ac
 __xfrm6_output+0x130/0x270
 xfrm6_output+0x60/0xec
 ip6_xmit+0x2ec/0x5bc
 inet6_csk_xmit+0xbc/0x10c
 __tcp_transmit_skb+0x460/0x8c0
 tcp_write_xmit+0x348/0x890
 __tcp_push_pending_frames+0x44/0x110
 tcp_push+0xb4/0x14c
 tcp_sendmsg_locked+0x71c/0xb64
 tcp_sendmsg+0x40/0x6c
 inet6_sendmsg+0x4c/0x80
 sock_sendmsg+0x5c/0x6c
 __sys_sendto+0x128/0x15c
 __arm64_sys_sendto+0x30/0x40
 invoke_syscall+0x50/0x120
 el0_svc_common.constprop.0+0x170/0x194
 do_el0_svc+0x38/0x4c
 el0_svc+0x28/0xe0
 el0t_64_sync_handler+0xbc/0x13c
 el0t_64_sync+0x180/0x184

Get softirq info by bcc tool:
./softirqs -NT 10
Tracing soft irq event time... Hit Ctrl-C to end.

15:34:34
SOFTIRQ          TOTAL_nsecs
block                 158990
timer               20030920
sched               46577080
net_rx             676746820
tasklet           9906067650

15:34:45
SOFTIRQ          TOTAL_nsecs
block                  86100
sched               38849790
net_rx             676532470
timer             1163848790
tasklet           9409019620

15:34:55
SOFTIRQ          TOTAL_nsecs
sched               58078450
net_rx             475156720
timer              533832410
tasklet           9431333300

The tasklet software interrupt takes too much time. Therefore, the
xfrm_trans_reinject executor is changed from tasklet to workqueue. Add add
spin lock to protect the queue. This reduces the processing flow of the
tcp_sendmsg function in this scenario.

Fixes: acf568ee859f0 ("xfrm: Reinject transport-mode packets through tasklet")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_input.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index b2f4ec9c537f..aa5220565763 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -24,7 +24,8 @@
 #include "xfrm_inout.h"
 
 struct xfrm_trans_tasklet {
-	struct tasklet_struct tasklet;
+	struct work_struct work;
+	spinlock_t queue_lock;
 	struct sk_buff_head queue;
 };
 
@@ -760,18 +761,22 @@ int xfrm_input_resume(struct sk_buff *skb, int nexthdr)
 }
 EXPORT_SYMBOL(xfrm_input_resume);
 
-static void xfrm_trans_reinject(struct tasklet_struct *t)
+static void xfrm_trans_reinject(struct work_struct *work)
 {
-	struct xfrm_trans_tasklet *trans = from_tasklet(trans, t, tasklet);
+	struct xfrm_trans_tasklet *trans = container_of(work, struct xfrm_trans_tasklet, work);
 	struct sk_buff_head queue;
 	struct sk_buff *skb;
 
 	__skb_queue_head_init(&queue);
+	spin_lock_bh(&trans->queue_lock);
 	skb_queue_splice_init(&trans->queue, &queue);
+	spin_unlock_bh(&trans->queue_lock);
 
+	local_bh_disable();
 	while ((skb = __skb_dequeue(&queue)))
 		XFRM_TRANS_SKB_CB(skb)->finish(XFRM_TRANS_SKB_CB(skb)->net,
 					       NULL, skb);
+	local_bh_enable();
 }
 
 int xfrm_trans_queue_net(struct net *net, struct sk_buff *skb,
@@ -789,8 +794,10 @@ int xfrm_trans_queue_net(struct net *net, struct sk_buff *skb,
 
 	XFRM_TRANS_SKB_CB(skb)->finish = finish;
 	XFRM_TRANS_SKB_CB(skb)->net = net;
+	spin_lock_bh(&trans->queue_lock);
 	__skb_queue_tail(&trans->queue, skb);
-	tasklet_schedule(&trans->tasklet);
+	spin_unlock_bh(&trans->queue_lock);
+	schedule_work(&trans->work);
 	return 0;
 }
 EXPORT_SYMBOL(xfrm_trans_queue_net);
@@ -817,7 +824,8 @@ void __init xfrm_input_init(void)
 		struct xfrm_trans_tasklet *trans;
 
 		trans = &per_cpu(xfrm_trans_tasklet, i);
+		spin_lock_init(&trans->queue_lock);
 		__skb_queue_head_init(&trans->queue);
-		tasklet_setup(&trans->tasklet, xfrm_trans_reinject);
+		INIT_WORK(&trans->work, xfrm_trans_reinject);
 	}
 }
-- 
2.25.1

