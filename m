Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574491C550F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgEEMJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728660AbgEEMJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 08:09:00 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39509C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 05:09:00 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jVwNe-0005dI-9E; Tue, 05 May 2020 14:08:58 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 8D6F21001F5; Tue,  5 May 2020 14:08:56 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>
Subject: [BUG] Inconsistent lock state in virtnet poll
Date:   Tue, 05 May 2020 14:08:56 +0200
Message-ID: <87lfm6oa7b.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The following lockdep splat happens reproducibly on 5.7-rc4

Thanks,

        tglx

================================
WARNING: inconsistent lock state
5.7.0-rc4+ #79 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
ip/356 [HC0[0]:SC1[1]:HE1:SE0] takes:
f3ee4cd8 (&syncp->seq#2){+.?.}-{0:0}, at: net_rx_action+0xfb/0x390
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x82/0x300
  try_fill_recv+0x39f/0x590
  virtnet_open+0xe0/0x180
  __dev_open+0xbe/0x160
  __dev_change_flags+0x152/0x1b0
  dev_change_flags+0x23/0x60
  do_setlink+0x814/0xa30
  __rtnl_newlink+0x583/0x8e0
  rtnl_newlink+0x36/0x60
  rtnetlink_rcv_msg+0x139/0x470
  netlink_rcv_skb+0x6a/0xe0
  rtnetlink_rcv+0xd/0x10
  netlink_unicast+0x175/0x250
  netlink_sendmsg+0x263/0x440
  sock_sendmsg+0x5c/0x60
  ____sys_sendmsg+0x182/0x1d0
  ___sys_sendmsg+0x59/0x90
  __sys_sendmsg+0x39/0x80
  __ia32_sys_socketcall+0x2d2/0x330
  do_fast_syscall_32+0x82/0x340
  entry_SYSENTER_32+0xaa/0x102
irq event stamp: 2276
hardirqs last  enabled at (2276): [<c18e419e>] net_rx_action+0x7e/0x390
hardirqs last disabled at (2275): [<c18e4178>] net_rx_action+0x58/0x390
softirqs last  enabled at (2272): [<c16f87ee>] virtnet_napi_enable+0xe/0x50
softirqs last disabled at (2273): [<c101fb10>] call_on_stack+0x40/0x50

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&syncp->seq#2);
  <Interrupt>
    lock(&syncp->seq#2);

 *** DEADLOCK ***

1 lock held by ip/356:
 #0: c20a4a38 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x118/0x470

stack backtrace:
CPU: 2 PID: 356 Comm: ip Not tainted 5.7.0-rc4+ #79
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Call Trace:
 <SOFTIRQ>
 dump_stack+0x6e/0x9e
 print_usage_bug.cold+0x15a/0x162
 mark_lock+0x58d/0x6e0
 ? check_usage_backwards+0x180/0x180
 __lock_acquire+0xdd7/0x24f0
 ? select_task_rq_fair+0xbb/0xfe0
 ? __lock_acquire+0x35f/0x24f0
 ? __lock_acquire+0x35f/0x24f0
 ? __lock_acquire+0x35f/0x24f0
 lock_acquire+0x82/0x300
 ? net_rx_action+0xfb/0x390
 ? find_held_lock+0x24/0x80
 ? lock_release+0x8a/0x260
 ? virtnet_poll+0xd0/0x3d9
 virtnet_poll+0x1d3/0x3d9
 ? net_rx_action+0xfb/0x390
 ? trace_hardirqs_on+0x4a/0xf0
 net_rx_action+0xfb/0x390
 ? __do_softirq+0x84/0x3ca
 ? virtnet_napi_enable+0xe/0x50
 __do_softirq+0xb1/0x3ca
 ? virtnet_napi_enable+0xe/0x50
 ? __irqentry_text_end+0x8/0x8
 call_on_stack+0x40/0x50
 </SOFTIRQ>
 ? do_softirq.part.0+0x4e/0x50
 ? __local_bh_enable_ip+0xd1/0xe0
 ? virtnet_napi_enable+0x41/0x50
 ? virtnet_open+0x7f/0x180
 ? __dev_open+0xbe/0x160
 ? __dev_change_flags+0x152/0x1b0
 ? dev_change_flags+0x23/0x60
 ? do_setlink+0x814/0xa30
 ? __lock_acquire+0x35f/0x24f0
 ? __nla_parse+0x1c/0x30
 ? __rtnl_newlink+0x583/0x8e0
 ? lock_acquire+0x82/0x300
 ? handle_mm_fault+0x6e6/0xa10
 ? find_held_lock+0x24/0x80
 ? __lock_acquire+0x35f/0x24f0
 ? lock_acquire+0x82/0x300
 ? __lock_acquire+0x35f/0x24f0
 ? rtnl_newlink+0x23/0x60
 ? rcu_read_lock_sched_held+0x3f/0x70
 ? kmem_cache_alloc_trace+0x235/0x260
 ? rtnl_newlink+0x36/0x60
 ? __rtnl_newlink+0x8e0/0x8e0
 ? rtnetlink_rcv_msg+0x139/0x470
 ? netlink_deliver_tap+0x81/0x3a0
 ? find_held_lock+0x24/0x80
 ? rtnl_bridge_getlink+0x240/0x240
 ? netlink_rcv_skb+0x6a/0xe0
 ? rtnl_bridge_getlink+0x240/0x240
 ? rtnetlink_rcv+0xd/0x10
 ? netlink_unicast+0x175/0x250
 ? netlink_sendmsg+0x263/0x440
 ? netlink_unicast+0x250/0x250
 ? sock_sendmsg+0x5c/0x60
 ? ____sys_sendmsg+0x182/0x1d0
 ? ___sys_sendmsg+0x59/0x90
 ? lock_acquire+0x82/0x300
 ? __might_fault+0x39/0x80
 ? __sys_sendmsg+0x39/0x80
 ? __ia32_sys_socketcall+0x2d2/0x330
 ? do_fast_syscall_32+0x82/0x340
 ? entry_SYSENTER_32+0xaa/0x102

