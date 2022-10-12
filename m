Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9C95FC9E1
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 19:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiJLR2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 13:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJLR2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 13:28:36 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FE48E0E1
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 10:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665595715; x=1697131715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MtflLHwyzkDFJ2AvH3uSMxyMy4azMZU/MGR9m62/RF8=;
  b=rOamMwKb+E4CLn6nsIuAHMJLZUN+yYdOa9dyk/d82iawmo4bVY2eLVX9
   fPZvFplEkoAVQ5qn5H7xzl+WWmygGoATsd1X5xNpCqz+XBfwrlNjV/B6v
   biUQ7eYFJMkLUja+uRVzaTCjO4D96VGoZuIcMFw2YzlYyUXvo366afo1V
   8=;
X-IronPort-AV: E=Sophos;i="5.95,179,1661817600"; 
   d="scan'208";a="1063412402"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-718d0906.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 17:28:19 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-718d0906.us-west-2.amazon.com (Postfix) with ESMTPS id 435A63E002D;
        Wed, 12 Oct 2022 17:28:19 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 12 Oct 2022 17:28:16 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.77) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 12 Oct 2022 17:28:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller@googlegroups.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v1 net] tcp: Clean up kernel listener's reqsk in inet_twsk_purge()
Date:   Wed, 12 Oct 2022 10:28:01 -0700
Message-ID: <20221012172801.83774-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJYF6S3XcfnxNcsPMjhFXz1naokJ+tLM1jSjjR6uco9bw@mail.gmail.com>
References: <CANn89iJYF6S3XcfnxNcsPMjhFXz1naokJ+tLM1jSjjR6uco9bw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.77]
X-ClientProxiedBy: EX13d09UWA001.ant.amazon.com (10.43.160.247) To
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
Date:   Wed, 12 Oct 2022 09:31:44 -0700
> On Wed, Oct 12, 2022 at 7:51 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > Eric Dumazet reported a use-after-free related to the per-netns ehash
> > series. [0]
> >
> > When we create a TCP socket from userspace, the socket always holds a
> > refcnt of the netns.  This guarantees that a reqsk timer is always fired
> > before netns dismantle.  Each reqsk has a refcnt of its listener, so the
> > listener is not freed before the reqsk, and the net is not freed before
> > the listener as well.
> >
> > OTOH, when in-kernel users create a TCP socket, it might not hold a refcnt
> > of its netns.  Thus, a reqsk timer can be fired after the netns dismantle
> > and access freed per-netns ehash.
> 
> Patch seems good, but changelog is incorrect.
> 
> 1) we have a TCP listener (or more) on a netns
> 2) We receive SYN packets, creating SYN_RECV request sockets, added in
> ehash table.
> 3) job is killed, TCP listener closed.
> 4) When a TCP listener is closed, we do not purge all SYN_RECV
> requests sockets, because we rely
>    on normal per-request timer firing, then finding the listener is no
> longer in LISTEN state -> drop the request socket.
>    (We do not maintain a per-listener list of request sockets, and
> going through ehash would be quite expensive on busy servers)
> 5) netns is deleted (and optional TCP ehashinfo freed)
> 6) request socket timer fire, and wecrash while trying to unlink the
> request socket from the freed ehash table.
> 
> In short, I think the case could happen with normal TCP sockets,
> allocated from user space.

Hmm.. I think 5) always happens after reqsk_timer for TCP socket
allocated from user space because reqsk has a refcnt for its netns
indirectly via the listener.

reqsk has its listener's sk_refcnt, so when reqsk timer is fired
the last reqsk_put() in inet_csk_reqsk_queue_drop_and_put() calls
sock_put() for the listener, and then listener release the last
refcnt for the net, and finally net is queued up to the free-list.

---8<---
static void __sk_destruct(struct rcu_head *head)
{
...
	if (likely(sk->sk_net_refcnt))
		put_net(sock_net(sk));
	sk_prot_free(sk->sk_prot_creator, sk);
}
---8<---


I did some tests with this script, but KASAN did not detect UAF
and I checked the timer is always executed before netns dismantle
for userspace listener.

---8<---
set -e

sysctl -w net.ipv4.tcp_child_ehash_entries=128
sysctl -w net.ipv4.tcp_max_orphans=0

cat <<EOF>test.py
from socket import *
from subprocess import run

s = socket()
s.bind(('localhost', 80))
s.listen()

c = socket()
c.connect(('localhost', 80))
run('netstat -tan'.split())
EOF

cat <<EOF>test_net.sh
set -e

sysctl net.ipv4.tcp_child_ehash_entries

ip link set lo up

iptables -A OUTPUT -o lo -p tcp --dport 80 --tcp-flags ACK ACK -j DROP

python3 test.py

netstat -tan

EOF

unshare -n bash test_net.sh
---8<---



> > To avoid the use-after-free, we need to clean up TCP_NEW_SYN_RECV sockets
> > in inet_twsk_purge() if the netns uses a per-netns ehash.
> >
> > [0]: https://lore.kernel.org/netdev/CANn89iLXMup0dRD_Ov79Xt8N9FM0XdhCHEN05sf3eLwxKweM6w@mail.gmail.com/
> >
> > BUG: KASAN: use-after-free in tcp_or_dccp_get_hashinfo
> > include/net/inet_hashtables.h:181 [inline]
> > BUG: KASAN: use-after-free in reqsk_queue_unlink+0x320/0x350
> > net/ipv4/inet_connection_sock.c:913
> > Read of size 8 at addr ffff88807545bd80 by task syz-executor.2/8301
> >
> > CPU: 1 PID: 8301 Comm: syz-executor.2 Not tainted
> > 6.0.0-syzkaller-02757-gaf7d23f9d96a #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine,
> > BIOS Google 09/22/2022
> > Call Trace:
> > <IRQ>
> > __dump_stack lib/dump_stack.c:88 [inline]
> > dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> > print_address_description mm/kasan/report.c:317 [inline]
> > print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
> > kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
> > tcp_or_dccp_get_hashinfo include/net/inet_hashtables.h:181 [inline]
> > reqsk_queue_unlink+0x320/0x350 net/ipv4/inet_connection_sock.c:913
> > inet_csk_reqsk_queue_drop net/ipv4/inet_connection_sock.c:927 [inline]
> > inet_csk_reqsk_queue_drop_and_put net/ipv4/inet_connection_sock.c:939 [inline]
> > reqsk_timer_handler+0x724/0x1160 net/ipv4/inet_connection_sock.c:1053
> > call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
> > expire_timers kernel/time/timer.c:1519 [inline]
> > __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
> > __run_timers kernel/time/timer.c:1768 [inline]
> > run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
> > __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
> > invoke_softirq kernel/softirq.c:445 [inline]
> > __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> > irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> > sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1107
> > </IRQ>
> >
> > Fixes: d1e5e6408b30 ("tcp: Introduce optional per-netns ehash.")
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Reported-by: Eric Dumazet <edumazet@google.com>
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  net/ipv4/inet_timewait_sock.c | 15 ++++++++++++++-
> >  net/ipv4/tcp_minisocks.c      |  9 +++++----
> >  2 files changed, 19 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> > index 71d3bb0abf6c..66fc940f9521 100644
> > --- a/net/ipv4/inet_timewait_sock.c
> > +++ b/net/ipv4/inet_timewait_sock.c
> > @@ -268,8 +268,21 @@ void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family)
> >                 rcu_read_lock();
> >  restart:
> >                 sk_nulls_for_each_rcu(sk, node, &head->chain) {
> > -                       if (sk->sk_state != TCP_TIME_WAIT)
> > +                       if (sk->sk_state != TCP_TIME_WAIT) {
> > +                               /* A kernel listener socket might not hold refcnt for net,
> > +                                * so reqsk_timer_handler() could be fired after net is
> > +                                * freed.  Userspace listener and reqsk never exist here.
> > +                                */
> > +                               if (unlikely(sk->sk_state == TCP_NEW_SYN_RECV &&
> > +                                            hashinfo->pernet)) {
> > +                                       struct request_sock *req = inet_reqsk(sk);
> > +
> > +                                       inet_csk_reqsk_queue_drop_and_put(req->rsk_listener, req);
> > +                               }
> > +
> >                                 continue;
> > +                       }
> > +
> >                         tw = inet_twsk(sk);
> >                         if ((tw->tw_family != family) ||
> >                                 refcount_read(&twsk_net(tw)->ns.count))
> > diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> > index 79f30f026d89..c375f603a16c 100644
> > --- a/net/ipv4/tcp_minisocks.c
> > +++ b/net/ipv4/tcp_minisocks.c
> > @@ -353,13 +353,14 @@ void tcp_twsk_purge(struct list_head *net_exit_list, int family)
> >         struct net *net;
> >
> >         list_for_each_entry(net, net_exit_list, exit_list) {
> > -               /* The last refcount is decremented in tcp_sk_exit_batch() */
> > -               if (refcount_read(&net->ipv4.tcp_death_row.tw_refcount) == 1)
> > -                       continue;
> > -
> >                 if (net->ipv4.tcp_death_row.hashinfo->pernet) {
> > +                       /* Even if tw_refcount == 1, we must clean up kernel reqsk */
> >                         inet_twsk_purge(net->ipv4.tcp_death_row.hashinfo, family);
> >                 } else if (!purged_once) {
> > +                       /* The last refcount is decremented in tcp_sk_exit_batch() */
> > +                       if (refcount_read(&net->ipv4.tcp_death_row.tw_refcount) == 1)
> > +                               continue;
> > +
> >                         inet_twsk_purge(&tcp_hashinfo, family);
> >                         purged_once = true;
> >                 }
> > --
> > 2.30.2
