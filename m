Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62213D48CC
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 19:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhGXQjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 12:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhGXQjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 12:39:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B58C061760
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 10:20:04 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m7LJi-0002Tp-Dr
        for netdev@vger.kernel.org; Sat, 24 Jul 2021 19:20:02 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 30AEC6569DA
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 17:19:57 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id F20AA6569AE;
        Sat, 24 Jul 2021 17:19:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id cbeff58f;
        Sat, 24 Jul 2021 17:19:53 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Ziyang Xuan <william.xuanziyang@huawei.com>,
        linux-stable <stable@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 2/6] can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF
Date:   Sat, 24 Jul 2021 19:19:43 +0200
Message-Id: <20210724171947.547867-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724171947.547867-1-mkl@pengutronix.de>
References: <20210724171947.547867-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

We get a bug during ltp can_filter test as following.

===========================================
[60919.264984] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[60919.265223] PGD 8000003dda726067 P4D 8000003dda726067 PUD 3dda727067 PMD 0
[60919.265443] Oops: 0000 [#1] SMP PTI
[60919.265550] CPU: 30 PID: 3638365 Comm: can_filter Kdump: loaded Tainted: G        W         4.19.90+ #1
[60919.266068] RIP: 0010:selinux_socket_sock_rcv_skb+0x3e/0x200
[60919.293289] RSP: 0018:ffff8d53bfc03cf8 EFLAGS: 00010246
[60919.307140] RAX: 0000000000000000 RBX: 000000000000001d RCX: 0000000000000007
[60919.320756] RDX: 0000000000000001 RSI: ffff8d5104a8ed00 RDI: ffff8d53bfc03d30
[60919.334319] RBP: ffff8d9338056800 R08: ffff8d53bfc29d80 R09: 0000000000000001
[60919.347969] R10: ffff8d53bfc03ec0 R11: ffffb8526ef47c98 R12: ffff8d53bfc03d30
[60919.350320] perf: interrupt took too long (3063 > 2500), lowering kernel.perf_event_max_sample_rate to 65000
[60919.361148] R13: 0000000000000001 R14: ffff8d53bcf90000 R15: 0000000000000000
[60919.361151] FS:  00007fb78b6b3600(0000) GS:ffff8d53bfc00000(0000) knlGS:0000000000000000
[60919.400812] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[60919.413730] CR2: 0000000000000010 CR3: 0000003e3f784006 CR4: 00000000007606e0
[60919.426479] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[60919.439339] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[60919.451608] PKRU: 55555554
[60919.463622] Call Trace:
[60919.475617]  <IRQ>
[60919.487122]  ? update_load_avg+0x89/0x5d0
[60919.498478]  ? update_load_avg+0x89/0x5d0
[60919.509822]  ? account_entity_enqueue+0xc5/0xf0
[60919.520709]  security_sock_rcv_skb+0x2a/0x40
[60919.531413]  sk_filter_trim_cap+0x47/0x1b0
[60919.542178]  ? kmem_cache_alloc+0x38/0x1b0
[60919.552444]  sock_queue_rcv_skb+0x17/0x30
[60919.562477]  raw_rcv+0x110/0x190 [can_raw]
[60919.572539]  can_rcv_filter+0xbc/0x1b0 [can]
[60919.582173]  can_receive+0x6b/0xb0 [can]
[60919.591595]  can_rcv+0x31/0x70 [can]
[60919.600783]  __netif_receive_skb_one_core+0x5a/0x80
[60919.609864]  process_backlog+0x9b/0x150
[60919.618691]  net_rx_action+0x156/0x400
[60919.627310]  ? sched_clock_cpu+0xc/0xa0
[60919.635714]  __do_softirq+0xe8/0x2e9
[60919.644161]  do_softirq_own_stack+0x2a/0x40
[60919.652154]  </IRQ>
[60919.659899]  do_softirq.part.17+0x4f/0x60
[60919.667475]  __local_bh_enable_ip+0x60/0x70
[60919.675089]  __dev_queue_xmit+0x539/0x920
[60919.682267]  ? finish_wait+0x80/0x80
[60919.689218]  ? finish_wait+0x80/0x80
[60919.695886]  ? sock_alloc_send_pskb+0x211/0x230
[60919.702395]  ? can_send+0xe5/0x1f0 [can]
[60919.708882]  can_send+0xe5/0x1f0 [can]
[60919.715037]  raw_sendmsg+0x16d/0x268 [can_raw]

It's because raw_setsockopt() concurrently with
unregister_netdevice_many(). Concurrent scenario as following.

	cpu0						cpu1
raw_bind
raw_setsockopt					unregister_netdevice_many
						unlist_netdevice
dev_get_by_index				raw_notifier
raw_enable_filters				......
can_rx_register
can_rcv_list_find(..., net->can.rx_alldev_list)

......

sock_close
raw_release(sock_a)

......

can_receive
can_rcv_filter(net->can.rx_alldev_list, ...)
raw_rcv(skb, sock_a)
BUG

After unlist_netdevice(), dev_get_by_index() return NULL in
raw_setsockopt(). Function raw_enable_filters() will add sock
and can_filter to net->can.rx_alldev_list. Then the sock is closed.
Followed by, we sock_sendmsg() to a new vcan device use the same
can_filter. Protocol stack match the old receiver whose sock has
been released on net->can.rx_alldev_list in can_rcv_filter().
Function raw_rcv() uses the freed sock. UAF BUG is triggered.

We can find that the key issue is that net_device has not been
protected in raw_setsockopt(). Use rtnl_lock to protect net_device
in raw_setsockopt().

Fixes: c18ce101f2e4 ("[CAN]: Add raw protocol")
Link: https://lore.kernel.org/r/20210722070819.1048263-1-william.xuanziyang@huawei.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/raw.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index ed4fcb7ab0c3..cd5a49380116 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -546,10 +546,18 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 				return -EFAULT;
 		}
 
+		rtnl_lock();
 		lock_sock(sk);
 
-		if (ro->bound && ro->ifindex)
+		if (ro->bound && ro->ifindex) {
 			dev = dev_get_by_index(sock_net(sk), ro->ifindex);
+			if (!dev) {
+				if (count > 1)
+					kfree(filter);
+				err = -ENODEV;
+				goto out_fil;
+			}
+		}
 
 		if (ro->bound) {
 			/* (try to) register the new filters */
@@ -588,6 +596,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 			dev_put(dev);
 
 		release_sock(sk);
+		rtnl_unlock();
 
 		break;
 
@@ -600,10 +609,16 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 
 		err_mask &= CAN_ERR_MASK;
 
+		rtnl_lock();
 		lock_sock(sk);
 
-		if (ro->bound && ro->ifindex)
+		if (ro->bound && ro->ifindex) {
 			dev = dev_get_by_index(sock_net(sk), ro->ifindex);
+			if (!dev) {
+				err = -ENODEV;
+				goto out_err;
+			}
+		}
 
 		/* remove current error mask */
 		if (ro->bound) {
@@ -627,6 +642,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 			dev_put(dev);
 
 		release_sock(sk);
+		rtnl_unlock();
 
 		break;
 
-- 
2.30.2


