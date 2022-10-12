Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68105FCBA2
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 21:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiJLThI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 15:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLThH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 15:37:07 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADF625C3
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 12:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665603426; x=1697139426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YTXdljyARpQ3PRNVqI8Zv25DQ86OGfpwvCfDwZ/MtNg=;
  b=lqUec4DhFiSh9gCqXj5q7lQVwHs3hKNu6K8rBGJUy8OGFQkxGHcI/Kks
   HLUgPCAvMP9l34LE1VLwvjO3xdP+v2/u3poOpBH8eOz8aJT/mwU0My6rn
   Yq4ilpa/mj5eadf3wH3I3ZV6RdLLs0OgXQ+FM6U82WmnZRoQcnO/QuAZd
   Q=;
X-IronPort-AV: E=Sophos;i="5.95,180,1661817600"; 
   d="scan'208";a="232755768"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 19:36:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com (Postfix) with ESMTPS id 484908ED87;
        Wed, 12 Oct 2022 19:36:46 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 12 Oct 2022 19:36:45 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.230) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 12 Oct 2022 19:36:40 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller@googlegroups.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v1 net] tcp: Clean up kernel listener's reqsk in inet_twsk_purge()
Date:   Wed, 12 Oct 2022 12:36:30 -0700
Message-ID: <20221012193630.92200-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJ=G5N+bp2HE+W5nvMsXFF0gO3-7Aui_3p2ufAwkY2=5g@mail.gmail.com>
References: <CANn89iJ=G5N+bp2HE+W5nvMsXFF0gO3-7Aui_3p2ufAwkY2=5g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.230]
X-ClientProxiedBy: EX13d09UWA004.ant.amazon.com (10.43.160.158) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Oct 2022 11:54:42 -0700
> On Wed, Oct 12, 2022 at 10:28 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Wed, 12 Oct 2022 09:31:44 -0700
> > > On Wed, Oct 12, 2022 at 7:51 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > Eric Dumazet reported a use-after-free related to the per-netns ehash
> > > > series. [0]
> > > >
> > > > When we create a TCP socket from userspace, the socket always holds a
> > > > refcnt of the netns.  This guarantees that a reqsk timer is always fired
> > > > before netns dismantle.  Each reqsk has a refcnt of its listener, so the
> > > > listener is not freed before the reqsk, and the net is not freed before
> > > > the listener as well.
> > > >
> > > > OTOH, when in-kernel users create a TCP socket, it might not hold a refcnt
> > > > of its netns.  Thus, a reqsk timer can be fired after the netns dismantle
> > > > and access freed per-netns ehash.
> > >
> > > Patch seems good, but changelog is incorrect.
> > >
> > > 1) we have a TCP listener (or more) on a netns
> > > 2) We receive SYN packets, creating SYN_RECV request sockets, added in
> > > ehash table.
> > > 3) job is killed, TCP listener closed.
> > > 4) When a TCP listener is closed, we do not purge all SYN_RECV
> > > requests sockets, because we rely
> > >    on normal per-request timer firing, then finding the listener is no
> > > longer in LISTEN state -> drop the request socket.
> > >    (We do not maintain a per-listener list of request sockets, and
> > > going through ehash would be quite expensive on busy servers)
> > > 5) netns is deleted (and optional TCP ehashinfo freed)
> > > 6) request socket timer fire, and wecrash while trying to unlink the
> > > request socket from the freed ehash table.
> > >
> > > In short, I think the case could happen with normal TCP sockets,
> > > allocated from user space.
> >
> > Hmm.. I think 5) always happens after reqsk_timer for TCP socket
> > allocated from user space because reqsk has a refcnt for its netns
> > indirectly via the listener.
> >
> > reqsk has its listener's sk_refcnt, so when reqsk timer is fired
> > the last reqsk_put() in inet_csk_reqsk_queue_drop_and_put() calls
> > sock_put() for the listener, and then listener release the last
> > refcnt for the net, and finally net is queued up to the free-list.
> >
> > ---8<---
> > static void __sk_destruct(struct rcu_head *head)
> > {
> > ...
> >         if (likely(sk->sk_net_refcnt))
> >                 put_net(sock_net(sk));
> >         sk_prot_free(sk->sk_prot_creator, sk);
> > }
> > ---8<---
> >
> >
> > I did some tests with this script, but KASAN did not detect UAF
> > and I checked the timer is always executed before netns dismantle
> > for userspace listener.
> >
> > ---8<---
> > set -e
> >
> > sysctl -w net.ipv4.tcp_child_ehash_entries=128
> > sysctl -w net.ipv4.tcp_max_orphans=0
> >
> > cat <<EOF>test.py
> > from socket import *
> > from subprocess import run
> >
> > s = socket()
> > s.bind(('localhost', 80))
> > s.listen()
> >
> > c = socket()
> > c.connect(('localhost', 80))
> > run('netstat -tan'.split())
> > EOF
> >
> > cat <<EOF>test_net.sh
> > set -e
> >
> > sysctl net.ipv4.tcp_child_ehash_entries
> >
> > ip link set lo up
> >
> > iptables -A OUTPUT -o lo -p tcp --dport 80 --tcp-flags ACK ACK -j DROP
> >
> > python3 test.py
> >
> > netstat -tan
> >
> > EOF
> >
> > unshare -n bash test_net.sh
> > ---8<---
> >
> 
> Hmm... maybe , but I have other syzbot reports that suggest the netns
> refcounting is wrong...
> 
> Maybe this is time I add a ref tracker dir for 'kernel sockets',
> making sure this tracker is empty right before netns is destroyed.

Yes, that makes sense.
It seems a similar issue (kernel sk vs TCP full sk timer) happend before.
https://lore.kernel.org/all/00000000000045dc96059f4d7b02@google.com/

Actually I was thinking of adding a kernel reqsk counter like
tw_refcount to short-circuit inet_twsk_purge(), but considering
per-netns ehash size is usually small, it might not be worth adding.


> BUG: KASAN: use-after-free in tcp_probe_timer net/ipv4/tcp_timer.c:378 [inline]
> BUG: KASAN: use-after-free in tcp_write_timer_handler+0x7e2/0x920
> net/ipv4/tcp_timer.c:624
> Read of size 1 at addr ffff88807d6ba385 by task syz-executor.2/3638
> 
> CPU: 0 PID: 3638 Comm: syz-executor.2 Not tainted
> 6.0.0-syzkaller-09589-g55be6084c8e0 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 09/22/2022
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
>  print_address_description+0x65/0x4b0 mm/kasan/report.c:317
>  print_report+0x108/0x220 mm/kasan/report.c:433
>  kasan_report+0xfb/0x130 mm/kasan/report.c:495
>  tcp_probe_timer net/ipv4/tcp_timer.c:378 [inline]
>  tcp_write_timer_handler+0x7e2/0x920 net/ipv4/tcp_timer.c:624
>  tcp_write_timer+0x176/0x280 net/ipv4/tcp_timer.c:637
>  call_timer_fn+0xf5/0x210 kernel/time/timer.c:1474
>  expire_timers kernel/time/timer.c:1519 [inline]
>  __run_timers+0x76a/0x980 kernel/time/timer.c:1790
>  run_timer_softirq+0x63/0xf0 kernel/time/timer.c:1803
>  __do_softirq+0x277/0x75b kernel/softirq.c:571
>  __irq_exit_rcu+0xec/0x170 kernel/softirq.c:650
>  irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
>  sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1107
> 
> 
> 
> 
> >
> >
> > > > To avoid the use-after-free, we need to clean up TCP_NEW_SYN_RECV sockets
> > > > in inet_twsk_purge() if the netns uses a per-netns ehash.
> > > >
> > > > [0]: https://lore.kernel.org/netdev/CANn89iLXMup0dRD_Ov79Xt8N9FM0XdhCHEN05sf3eLwxKweM6w@mail.gmail.com/
> > > >
> > > > BUG: KASAN: use-after-free in tcp_or_dccp_get_hashinfo
> > > > include/net/inet_hashtables.h:181 [inline]
> > > > BUG: KASAN: use-after-free in reqsk_queue_unlink+0x320/0x350
> > > > net/ipv4/inet_connection_sock.c:913
> > > > Read of size 8 at addr ffff88807545bd80 by task syz-executor.2/8301
> > > >
> > > > CPU: 1 PID: 8301 Comm: syz-executor.2 Not tainted
> > > > 6.0.0-syzkaller-02757-gaf7d23f9d96a #0
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine,
> > > > BIOS Google 09/22/2022
> > > > Call Trace:
> > > > <IRQ>
> > > > __dump_stack lib/dump_stack.c:88 [inline]
> > > > dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> > > > print_address_description mm/kasan/report.c:317 [inline]
> > > > print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
> > > > kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
> > > > tcp_or_dccp_get_hashinfo include/net/inet_hashtables.h:181 [inline]
> > > > reqsk_queue_unlink+0x320/0x350 net/ipv4/inet_connection_sock.c:913
> > > > inet_csk_reqsk_queue_drop net/ipv4/inet_connection_sock.c:927 [inline]
> > > > inet_csk_reqsk_queue_drop_and_put net/ipv4/inet_connection_sock.c:939 [inline]
> > > > reqsk_timer_handler+0x724/0x1160 net/ipv4/inet_connection_sock.c:1053
> > > > call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
> > > > expire_timers kernel/time/timer.c:1519 [inline]
> > > > __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
> > > > __run_timers kernel/time/timer.c:1768 [inline]
> > > > run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
> > > > __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
> > > > invoke_softirq kernel/softirq.c:445 [inline]
> > > > __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> > > > irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> > > > sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1107
> > > > </IRQ>
> > > >
> > > > Fixes: d1e5e6408b30 ("tcp: Introduce optional per-netns ehash.")
> > > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > > Reported-by: Eric Dumazet <edumazet@google.com>
> > > > Suggested-by: Eric Dumazet <edumazet@google.com>
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > ---
> > > >  net/ipv4/inet_timewait_sock.c | 15 ++++++++++++++-
> > > >  net/ipv4/tcp_minisocks.c      |  9 +++++----
> > > >  2 files changed, 19 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> > > > index 71d3bb0abf6c..66fc940f9521 100644
> > > > --- a/net/ipv4/inet_timewait_sock.c
> > > > +++ b/net/ipv4/inet_timewait_sock.c
> > > > @@ -268,8 +268,21 @@ void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family)
> > > >                 rcu_read_lock();
> > > >  restart:
> > > >                 sk_nulls_for_each_rcu(sk, node, &head->chain) {
> > > > -                       if (sk->sk_state != TCP_TIME_WAIT)
> > > > +                       if (sk->sk_state != TCP_TIME_WAIT) {
> > > > +                               /* A kernel listener socket might not hold refcnt for net,
> > > > +                                * so reqsk_timer_handler() could be fired after net is
> > > > +                                * freed.  Userspace listener and reqsk never exist here.
> > > > +                                */
> > > > +                               if (unlikely(sk->sk_state == TCP_NEW_SYN_RECV &&
> > > > +                                            hashinfo->pernet)) {
> > > > +                                       struct request_sock *req = inet_reqsk(sk);
> > > > +
> > > > +                                       inet_csk_reqsk_queue_drop_and_put(req->rsk_listener, req);
> > > > +                               }
> > > > +
> > > >                                 continue;
> > > > +                       }
> > > > +
> > > >                         tw = inet_twsk(sk);
> > > >                         if ((tw->tw_family != family) ||
> > > >                                 refcount_read(&twsk_net(tw)->ns.count))
> > > > diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> > > > index 79f30f026d89..c375f603a16c 100644
> > > > --- a/net/ipv4/tcp_minisocks.c
> > > > +++ b/net/ipv4/tcp_minisocks.c
> > > > @@ -353,13 +353,14 @@ void tcp_twsk_purge(struct list_head *net_exit_list, int family)
> > > >         struct net *net;
> > > >
> > > >         list_for_each_entry(net, net_exit_list, exit_list) {
> > > > -               /* The last refcount is decremented in tcp_sk_exit_batch() */
> > > > -               if (refcount_read(&net->ipv4.tcp_death_row.tw_refcount) == 1)
> > > > -                       continue;
> > > > -
> > > >                 if (net->ipv4.tcp_death_row.hashinfo->pernet) {
> > > > +                       /* Even if tw_refcount == 1, we must clean up kernel reqsk */
> > > >                         inet_twsk_purge(net->ipv4.tcp_death_row.hashinfo, family);
> > > >                 } else if (!purged_once) {
> > > > +                       /* The last refcount is decremented in tcp_sk_exit_batch() */
> > > > +                       if (refcount_read(&net->ipv4.tcp_death_row.tw_refcount) == 1)
> > > > +                               continue;
> > > > +
> > > >                         inet_twsk_purge(&tcp_hashinfo, family);
> > > >                         purged_once = true;
> > > >                 }
> > > > --
> > > > 2.30.2
