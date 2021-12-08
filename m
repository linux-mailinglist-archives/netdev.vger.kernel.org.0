Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87CF46D9A7
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbhLHRdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:33:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45920 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235021AbhLHRdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 12:33:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GyKXzU+ioUpaaquTQz+HSNJHsQz3tB90SXMUbBmqORo=; b=lgiT360CPAtB/ZP9FeaxO9TlEE
        5UKgeTX3hO9Svg1UjqRyfkLX6XAec/2TkiKLBijlWPqMajyuPN3hKrupHwxw136u561o/5k27ujUz
        gA0HEFOhlx+WUsc4CRo9Xv8fo/GDrU+gKyDvWR78pqVgp8P0Q1/DknhbFtXmd3FlueJE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mv0l6-00FuBc-Hr; Wed, 08 Dec 2021 18:29:36 +0100
Date:   Wed, 8 Dec 2021 18:29:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount
 tracking
Message-ID: <YbDrgEX99jnHlLYV@lunn.ch>
References: <Ya6bj2nplJ57JPml@lunn.ch>
 <CANn89iLPSianJ7TjzrpOw+a0PTgX_rpQmiNYbgxbn2K-PNouFg@mail.gmail.com>
 <Ya6kJhUtJt5c8tEk@lunn.ch>
 <CANn89iL4nVf+N1R=XV5VRSm4193CcU1N8XTNZzpBV9-mS3vxig@mail.gmail.com>
 <Ya6m1kIqVo52FkLV@lunn.ch>
 <CANn89i+b_6R820Om9ZjK-E5DyvnNUKXxYODpmt1B6UHM1q7eoQ@mail.gmail.com>
 <Ya6qewYtxoRn7BTo@lunn.ch>
 <CANn89iKbAr2aqiOLWuyYADW7b4fc3fy=DFRJ5dUG7F=BPiWKZQ@mail.gmail.com>
 <Ya+7YlIZgQ1Lz9SI@lunn.ch>
 <CANn89iKdh3SMT_OED10cBKek5OC6Y8ELPK1jOzmnu9tfBPYh1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKdh3SMT_OED10cBKek5OC6Y8ELPK1jOzmnu9tfBPYh1A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This all involves IPv6, and this might point to something I hinted
> about last week.
> 
> Can you try :
> 
> Note that I am about to travel, and will be unable to respond to
> emails for about 20 hours.

Hi Eric

Hope you had a good trip.

I tried your patch. No difference, it still reports leaks, and the
WARN_ON_ONCE did not fire.

I extended the tracker a little, adding timestamps into the struct
ref_tracker and printing the age of the leaked reference as part of
the dump. The patch is at the end.

There is possibly an interesting pattern here:

[  454.787491] unregister_netdevice: waiting for eth0 to become free. Usage count = 9
[  454.787696] leaked reference. Age    15.138884
[  454.787699]  dst_alloc+0x7a/0x180
[  454.787706]  ip6_dst_alloc+0x27/0x90
[  454.787709]  ip6_pol_route+0x257/0x430
[  454.787711]  ip6_pol_route_output+0x19/0x20
[  454.787713]  fib6_rule_lookup+0x18b/0x270
[  454.787717]  ip6_route_output_flags_noref+0xaa/0x110
[  454.787719]  ip6_route_output_flags+0x32/0xa0
[  454.787720]  ip6_dst_lookup_tail.constprop.0+0x181/0x240
[  454.787724]  ip6_dst_lookup_flow+0x43/0xa0
[  454.787725]  inet6_csk_route_socket+0x166/0x200
[  454.787729]  inet6_csk_xmit+0x56/0x130
[  454.787731]  __tcp_transmit_skb+0x53b/0xc30
[  454.787734]  __tcp_send_ack.part.0+0xc6/0x1a0
[  454.787735]  tcp_send_ack+0x1c/0x20
[  454.787737]  __tcp_ack_snd_check+0x42/0x200
[  454.787739]  tcp_rcv_established+0x27a/0x6f0
[  454.787740] leaked reference. Age    30.240300
[  454.787741]  dst_alloc+0x7a/0x180
[  454.787743]  ip6_dst_alloc+0x27/0x90
[  454.787744]  ip6_pol_route+0x257/0x430
[  454.787746]  ip6_pol_route_output+0x19/0x20
[  454.787748]  fib6_rule_lookup+0x18b/0x270
[  454.787750]  ip6_route_output_flags_noref+0xaa/0x110
[  454.787751]  ip6_route_output_flags+0x32/0xa0
[  454.787752]  seg6_output_core+0x28d/0x320
[  454.787755]  seg6_output+0x33/0x120
[  454.787757]  lwtunnel_output+0x72/0xc0
[  454.787760]  ip6_local_out+0x61/0x70
[  454.787762]  ip6_send_skb+0x23/0x70
[  454.787764]  udp_v6_send_skb+0x207/0x460
[  454.787767]  udpv6_sendmsg+0xb13/0xdb0
[  454.787768]  inet6_sendmsg+0x65/0x70
[  454.787769]  sock_sendmsg+0x48/0x70
[  454.787772] leaked reference. Age    31.594229
[  454.787773]  dst_alloc+0x7a/0x180
[  454.787775]  ip6_dst_alloc+0x27/0x90
[  454.787776]  ip6_pol_route+0x257/0x430
[  454.787778]  ip6_pol_route_output+0x19/0x20
[  454.787780]  fib6_rule_lookup+0x18b/0x270
[  454.787782]  ip6_route_output_flags_noref+0xaa/0x110
[  454.787783]  ip6_route_output_flags+0x32/0xa0
[  454.787784]  seg6_output_core+0x28d/0x320
[  454.787786]  seg6_output+0x33/0x120
[  454.787789]  lwtunnel_output+0x72/0xc0
[  454.787790]  ip6_local_out+0x61/0x70
[  454.787792]  ip6_send_skb+0x23/0x70
[  454.787793]  udp_v6_send_skb+0x207/0x460
[  454.787796]  udpv6_sendmsg+0xb13/0xdb0
[  454.787797]  inet6_sendmsg+0x65/0x70
[  454.787798]  sock_sendmsg+0x48/0x70
[  454.787800] leaked reference. Age    35.147534
[  454.787800]  dst_alloc+0x7a/0x180
[  454.787802]  ip6_dst_alloc+0x27/0x90
[  454.787803]  ip6_pol_route+0x257/0x430
[  454.787805]  ip6_pol_route_output+0x19/0x20
[  454.787806]  fib6_rule_lookup+0x18b/0x270
[  454.787808]  ip6_route_output_flags_noref+0xaa/0x110
[  454.787810]  ip6_route_output_flags+0x32/0xa0
[  454.787811]  ip6_dst_lookup_tail.constprop.0+0x181/0x240
[  454.787813]  ip6_dst_lookup_flow+0x43/0xa0
[  454.787814]  inet6_csk_route_socket+0x166/0x200
[  454.787817]  inet6_csk_xmit+0x56/0x130
[  454.787818]  __tcp_transmit_skb+0x53b/0xc30
[  454.787819]  __tcp_send_ack.part.0+0xc6/0x1a0
[  454.787821]  tcp_send_ack+0x1c/0x20
[  454.787823]  __tcp_ack_snd_check+0x42/0x200
[  454.787824]  tcp_rcv_established+0x27a/0x6f0
[  454.787826] leaked reference. Age    37.269626
[  454.787826]  dst_alloc+0x7a/0x180
[  454.787828]  ip6_dst_alloc+0x27/0x90
[  454.787829]  ip6_pol_route+0x257/0x430
[  454.787831]  ip6_pol_route_output+0x19/0x20
[  454.787833]  fib6_rule_lookup+0x18b/0x270
[  454.787835]  ip6_route_output_flags_noref+0xaa/0x110
[  454.787836]  ip6_route_output_flags+0x32/0xa0
[  454.787837]  ip6_dst_lookup_tail.constprop.0+0xde/0x240
[  454.787839]  ip6_dst_lookup_flow+0x43/0xa0
[  454.787841]  tcp_v6_connect+0x2a7/0x670
[  454.787843]  __inet_stream_connect+0xd1/0x3b0
[  454.787845]  inet_stream_connect+0x3b/0x60
[  454.787846]  __sys_connect_file+0x5f/0x70
[  454.787848]  __sys_connect+0xa2/0xd0
[  454.787849]  __x64_sys_connect+0x18/0x20
[  454.787850]  do_syscall_64+0x3b/0xc0

Ages of 15 to 37 seconds. So these leaks look related to applications
using tcpv6.

[  454.787854] leaked reference. Age   385.273596
[  454.787855]  dst_alloc+0x7a/0x180
[  454.787857]  ip6_dst_alloc+0x27/0x90
[  454.787858]  ip6_pol_route+0x257/0x430
[  454.787859]  ip6_pol_route_output+0x19/0x20
[  454.787861]  fib6_rule_lookup+0x18b/0x270
[  454.787863]  ip6_route_output_flags_noref+0xaa/0x110
[  454.787864]  ip6_route_output_flags+0x32/0xa0
[  454.787866]  ip6_dst_lookup_tail.constprop.0+0x181/0x240
[  454.787867]  ip6_dst_lookup_flow+0x43/0xa0
[  454.787869]  inet6_csk_route_req+0x11b/0x150
[  454.787871]  tcp_v6_route_req+0xa8/0x140
[  454.787873]  tcp_conn_request+0x349/0xcd0
[  454.787875]  tcp_v6_conn_request+0x64/0xd0
[  454.787877]  tcp_rcv_state_process+0x25b/0x1070
[  454.787878]  tcp_v6_do_rcv+0x1c4/0x4a0
[  454.787881]  tcp_v6_rcv+0xea3/0xee0
[  454.787883] leaked reference. Age   389.378759
[  454.787884]  fib6_nh_init+0x30d/0x9c0
[  454.787885]  rtm_new_nexthop+0x68a/0x13a0
[  454.787888]  rtnetlink_rcv_msg+0x14f/0x380
[  454.787891]  netlink_rcv_skb+0x55/0x100
[  454.787893]  rtnetlink_rcv+0x15/0x20
[  454.787895]  netlink_unicast+0x230/0x340
[  454.787897]  netlink_sendmsg+0x252/0x4b0
[  454.787899]  sock_sendmsg+0x65/0x70
[  454.787900]  ____sys_sendmsg+0x24e/0x290
[  454.787902]  ___sys_sendmsg+0x81/0xc0
[  454.787903]  __sys_sendmsg+0x62/0xb0
[  454.787905]  __x64_sys_sendmsg+0x1d/0x20
[  454.787907]  do_syscall_64+0x3b/0xc0
[  454.787908]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  454.787911] leaked reference. Age   402.739110
[  454.787911]  ipv6_add_dev+0x13e/0x4f0
[  454.787914]  addrconf_notify+0x2ca/0x950
[  454.787917]  raw_notifier_call_chain+0x49/0x60
[  454.787920]  call_netdevice_notifiers_info+0x50/0x90
[  454.787923]  __dev_change_net_namespace+0x30d/0x6c0
[  454.787926]  do_setlink+0xdc/0x10b0
[  454.787928]  __rtnl_newlink+0x608/0xa10
[  454.787931]  rtnl_newlink+0x49/0x70
[  454.787933]  rtnetlink_rcv_msg+0x14f/0x380
[  454.787935]  netlink_rcv_skb+0x55/0x100
[  454.787937]  rtnetlink_rcv+0x15/0x20
[  454.787939]  netlink_unicast+0x230/0x340
[  454.787941]  netlink_sendmsg+0x252/0x4b0
[  454.787942]  sock_sendmsg+0x65/0x70
[  454.787944]  ____sys_sendmsg+0x24e/0x290
[  454.787945]  ___sys_sendmsg+0x81/0xc0

Here the age is much longer, more like the age of the container and
early setup of the container. I took a quick look at this last trace,
and it is the netdev being moved from one namespace to another.

So it could be there are two leaks here?

   Andrew

rom d3a3149c4e8f5020942ac00fe3bce6a1303f10b7 Mon Sep 17 00:00:00 2001
From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 8 Dec 2021 10:25:05 -0600
Subject: [PATCH] lib: ref_tracker: Add timestamp for reference

It can be useful to know if the leaked reference is old, or recent.
Is the bug in interface create and release, or more dynamic like a
connection.

Add a timestamp to each reference record, and print the age when
dumping the records.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 lib/ref_tracker.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index 0ae2e66dcf0f..82a1c3681969 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -12,6 +12,7 @@ struct ref_tracker {
        bool                    dead;
        depot_stack_handle_t    alloc_stack_handle;
        depot_stack_handle_t    free_stack_handle;
+       ktime_t                 alloc_ktime;
 };
 
 void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
@@ -44,13 +45,17 @@ void ref_tracker_dir_print(struct ref_tracker_dir *dir,
                           unsigned int display_limit)
 {
        struct ref_tracker *tracker;
+       ktime_t now = ktime_get();
        unsigned long flags;
        unsigned int i = 0;
-
        spin_lock_irqsave(&dir->lock, flags);
+
        list_for_each_entry(tracker, &dir->list, head) {
                if (i < display_limit) {
-                       pr_err("leaked reference.\n");
+                       ktime_t age = ktime_sub(now, tracker->alloc_ktime);
+                       unsigned long rem_nsec = do_div(age, 1000000000);
+                       pr_err("leaked reference. Age %5lu.%06lu\n",
+                              (unsigned long)age, rem_nsec / 1000);
                        if (tracker->alloc_stack_handle)
                                stack_depot_print(tracker->alloc_stack_handle);
                        i++;
@@ -80,6 +85,7 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
        nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
        nr_entries = filter_irq_stacks(entries, nr_entries);
        tracker->alloc_stack_handle = stack_depot_save(entries, nr_entries, gfp);
+       tracker->alloc_ktime = ktime_get();
 
        spin_lock_irqsave(&dir->lock, flags);
        list_add(&tracker->head, &dir->list);
-- 
2.33.1


