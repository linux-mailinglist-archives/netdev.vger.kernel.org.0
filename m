Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 467EE1A5CFE
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 08:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgDLGJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 02:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725263AbgDLGJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Apr 2020 02:09:04 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D455206B8;
        Sun, 12 Apr 2020 06:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586671744;
        bh=/3Ve7Aw+hXhl/NM1eK+r5k7vnHs9rrw66aUKA5c2sMU=;
        h=From:To:Cc:Subject:Date:From;
        b=eA9ldMzfnu4gH23+hKe57OxYIIqpz4O2ltPJc39c3WZOzGoaZW5CJfdes3/7x918S
         +5QWa78pXq9xbbBQc6wlTfOSWZ86Iu+uyUt6UvLHyUsfSWxlQZMDEFJuSzaXO03pmr
         sCYvWW9I7uzBif1/iE2eY4twwb2C810GY7QgomWw=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Subject: [PATCH net v1] net/sched: Don't print dump stack in event of transmission timeout
Date:   Sun, 12 Apr 2020 09:08:54 +0300
Message-Id: <20200412060854.334895-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

In event of transmission timeout, the drivers are given an opportunity
to recover and continue to work after some in-house cleanups.

Such event can be caused by HW bugs, wrong congestion configurations
and many more other scenarios. In such case, users are interested to
get a simple  "NETDEV WATCHDOG ... " print, which points to the relevant
netdevice in trouble.

The dump stack printed later was added in the commit b4192bbd85d2
("net: Add a WARN_ON_ONCE() to the transmit timeout function") to give
extra information, like list of the modules and which driver is involved.

While the latter is already printed in "NETDEV WATCHDOG ... ", the list
of modules rarely needed and can be collected later.

So let's remove the WARN_ONCE() and make dmesg look more user-friendly in
large cluster setups.

[  281.170584] ------------[ cut here ]------------
[  281.197120] NETDEV WATCHDOG: ib1 (mlx4_core): transmit queue 0 timed out
[  281.198521] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:442 dev_watchdog+0x232/0x240
[  281.200259] Modules linked in: bonding ipip tunnel4 geneve ip6_udp_tunnel udp_tunnel ip6_gre ip6_tunnel tunnel6 ip_gre gre ip_tunnel mlx4_en ptp pps_core mlx4_ib mlx4_core rdma_ucm ib_uverbs ib_ipoib ib_umad openvswitch nsh xt_MASQUERADE nf_conntrack_netlink nfnetlink iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter overlay ib_srp scsi_transport_srp rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_core [last unloaded: mlx4_core]
[  281.208290] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-J14907-G268960df60ee #1
[  281.209954] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[  281.212281] RIP: 0010:dev_watchdog+0x232/0x240
[  281.213260] Code: 85 c0 75 e8 eb a5 4c 89 ef c6 05 dd 9c c4 00 01 e8 d3 b6 fb ff 44 89 e1 4c 89 ee 48 c7 c7 40 54 0b 82 48 89 c2 e8 10 f1 a0 ff <0f> 0b eb 86 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 c7 47
[  281.217078] RSP: 0018:ffffc90000003e70 EFLAGS: 00010282
[  281.218210] RAX: 0000000000000000 RBX: ffff8884521c3ce8 RCX: 0000000000000007
[  281.219709] RDX: 0000000000000007 RSI: 0000000000000086 RDI: ffff88846fc18230
[  281.221206] RBP: ffff88846daad440 R08: 0000000000000000 R09: 0000000000000249
[  281.222697] R10: 0000000000000774 R11: ffffc90000003d25 R12: 0000000000000000
[  281.224202] R13: ffff88846daad000 R14: ffff88846daad440 R15: 0000000000000082
[  281.225733] FS:  0000000000000000(0000) GS:ffff88846fc00000(0000) knlGS:0000000000000000
[  281.227472] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  281.228713] CR2: 00007efd12565000 CR3: 000000043cd3a002 CR4: 0000000000160eb0
[  281.230241] Call Trace:
[  281.230900]  <IRQ>
[  281.231469]  ? qdisc_put_unlocked+0x30/0x30
[  281.232437]  call_timer_fn+0x30/0x130
[  281.233300]  run_timer_softirq+0x18b/0x490
[  281.234229]  ? timerqueue_add+0x96/0xb0
[  281.235119]  ? enqueue_hrtimer+0x3d/0x90
[  281.236029]  __do_softirq+0xdf/0x2e5
[  281.236864]  irq_exit+0xa0/0xb0
[  281.237621]  smp_apic_timer_interrupt+0x72/0x120
[  281.238652]  apic_timer_interrupt+0xf/0x20
[  281.239581]  </IRQ>
[  281.240147] RIP: 0010:default_idle+0x2d/0x150
[  281.241133] Code: 00 00 8b 05 3d 75 a7 00 41 54 55 65 8b 2d 6b e0 71 7e 53 85 c0 7f 29 8b 05 c8 97 f7 00 85 c0 7e 07 0f 00 2d 37 56 52 00 fb f4 <8b> 05 15 75 a7 00 65 8b 2d 46 e0 71 7e 85 c0 7f 7f 5b 5d 41 5c c3
[  281.244935] RSP: 0018:ffffffff82203ea0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[  281.246584] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
[  281.248082] RDX: 000000000010db42 RSI: ffffffff82203e40 RDI: 000000416d8a7440
[  281.249581] RBP: 0000000000000000 R08: 0000000000000001 R09: 00000041770da407
[  281.251069] R10: 0000000000000264 R11: 0000000000000000 R12: ffffffff82211840
[  281.252545] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff82211840
[  281.254036]  do_idle+0x1ee/0x210
[  281.254809]  cpu_startup_entry+0x19/0x20
[  281.255713]  start_kernel+0x490/0x4af
[  281.257577]  secondary_startup_64+0xa4/0xb0
[  281.259147] ---[ end trace 78f566c0214a2cb0 ]---
[  281.260866] ib1: transmit timeout: latency 1120 msecs
[  281.262730] ib1: queue stopped 1, tx_head 167838, tx_tail 167710

Fixes: b4192bbd85d2 ("net: Add a WARN_ON_ONCE() to the transmit timeout function")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
Hi Dave,

This is a new version of previously sent v0 [1] with change in print error
level as was suggested by Jakub and Cong. I'm asking you to reevaluate
your previous decision [2] given the fact that this is user triggered
bug and very similar scenario was committed by Linus "fs/filesystems.c:
downgrade user-reachable WARN_ONCE() to pr_warn_once()" a couple of days
ago [3].

[1] https://lore.kernel.org/netdev/20200402152336.538433-1-leon@kernel.org
[2] https://lore.kernel.org/netdev/20200402.180218.940555077368617365.davem@davemloft.net
[3] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=26c5d78c976ca298e59a56f6101a97b618ba3539
---
 net/sched/sch_generic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 6c9595f1048a..185f03db3d55 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -439,8 +439,9 @@ static void dev_watchdog(struct timer_list *t)

 			if (some_queue_timedout) {
 				trace_net_dev_xmit_timeout(dev, i);
-				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
-				       dev->name, netdev_drivername(dev), i);
+				pr_err_once("NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
+					    dev->name,
+					    netdev_drivername(dev), i);
 				dev->netdev_ops->ndo_tx_timeout(dev, i);
 			}
 			if (!mod_timer(&dev->watchdog_timer,
--
2.25.2

