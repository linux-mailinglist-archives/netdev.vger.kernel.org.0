Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2069C5A2D59
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 19:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344827AbiHZRUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 13:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344777AbiHZRUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 13:20:33 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546B78C02F;
        Fri, 26 Aug 2022 10:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661534430; x=1693070430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LYyN3rNPYVidS2dwkBHQ+A7BJpV1VL1Kgiy1QYutFCQ=;
  b=rk9Cwod8ZV03U9E7y+na0dtc/titK3YKYh3YDejabdTaHne2XDrWTlYs
   bGTNlKWirYZjnWXIOD6J73b54FoPnLnAMwnbfeWOFh5/dlJDDG66iaTx/
   YU13HMkP1MKAr3QwVyJSPrsRqKwTbd5j1v/KOEGZrJGAWu4GtSODyiVFr
   g=;
X-IronPort-AV: E=Sophos;i="5.93,265,1654560000"; 
   d="scan'208";a="123816822"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 17:20:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id DBF2C44F9C;
        Fri, 26 Aug 2022 17:20:10 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 17:20:10 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.160) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 17:20:06 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <chuck.lever@oracle.com>, <davem@davemloft.net>,
        <jlayton@kernel.org>, <keescook@chromium.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-fsdevel@vger.kernel.org>, <mcgrof@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <yzaikin@google.com>
Subject: Re: [PATCH v1 net-next 08/13] tcp: Introduce optional per-netns ehash.
Date:   Fri, 26 Aug 2022 10:19:58 -0700
Message-ID: <20220826171958.97407-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89i+L9vhzGVdz=3eGa+euk_QgH0Cuc8zmaODUumnphEnd6A@mail.gmail.com>
References: <CANn89i+L9vhzGVdz=3eGa+euk_QgH0Cuc8zmaODUumnphEnd6A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.160]
X-ClientProxiedBy: EX13D39UWB002.ant.amazon.com (10.43.161.116) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Aug 2022 08:24:54 -0700
> On Thu, Aug 25, 2022 at 5:07 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > The more sockets we have in the hash table, the more time we spend
> > looking up the socket.  While running a number of small workloads on
> > the same host, they penalise each other and cause performance degradation.
> >
> > Also, the root cause might be a single workload that consumes much more
> > resources than the others.  It often happens on a cloud service where
> > different workloads share the same computing resource.
> >
> > To resolve the issue, we introduce an optional per-netns hash table for
> > TCP, but it's just ehash, and we still share the global bhash and lhash2.
> >
> > With a smaller ehash, we can look up non-listener sockets faster and
> > isolate such noisy neighbours.  Also, we can reduce lock contention.
> >
> > We can control the ehash size by a new sysctl knob.  However, depending
> > on workloads, it will require very sensitive tuning, so we disable the
> > feature by default (net.ipv4.tcp_child_ehash_entries == 0).  Moreover,
> > we can fall back to using the global ehash in case we fail to allocate
> > enough memory for a new ehash.
> >
> > We can check the current ehash size by another read-only sysctl knob,
> > net.ipv4.tcp_ehash_entries.  A negative value means the netns shares
> > the global ehash (per-netns ehash is disabled or failed to allocate
> > memory).
> >
> >   # dmesg | cut -d ' ' -f 5- | grep "established hash"
> >   TCP established hash table entries: 524288 (order: 10, 4194304 bytes, vmalloc hugepage)
> >
> >   # sysctl net.ipv4.tcp_ehash_entries
> >   net.ipv4.tcp_ehash_entries = 524288  # can be changed by thash_entries
> >
> >   # sysctl net.ipv4.tcp_child_ehash_entries
> >   net.ipv4.tcp_child_ehash_entries = 0  # disabled by default
> >
> >   # ip netns add test1
> >   # ip netns exec test1 sysctl net.ipv4.tcp_ehash_entries
> >   net.ipv4.tcp_ehash_entries = -524288  # share the global ehash
> >
> >   # sysctl -w net.ipv4.tcp_child_ehash_entries=100
> >   net.ipv4.tcp_child_ehash_entries = 100
> >
> >   # sysctl net.ipv4.tcp_child_ehash_entries
> >   net.ipv4.tcp_child_ehash_entries = 128  # rounded up to 2^n
> >
> >   # ip netns add test2
> >   # ip netns exec test2 sysctl net.ipv4.tcp_ehash_entries
> >   net.ipv4.tcp_ehash_entries = 128  # own per-netns ehash
> >
> > When more than two processes in the same netns create per-netns ehash
> > concurrently with different sizes, we need to guarantee the size in
> > one of the following ways:
> >
> >   1) Share the global ehash and create per-netns ehash
> >
> >   First, unshare() with tcp_child_ehash_entries==0.  It creates dedicated
> >   netns sysctl knobs where we can safely change tcp_child_ehash_entries
> >   and clone()/unshare() to create a per-netns ehash.
> >
> >   2) Lock the sysctl knob
> >
> >   We can use flock(LOCK_MAND) or BPF_PROG_TYPE_CGROUP_SYSCTL to allow/deny
> >   read/write on sysctl knobs.
> >
> > Note the default values of two sysctl knobs depend on the ehash size and
> > should be tuned carefully:
> >
> >   tcp_max_tw_buckets  : tcp_child_ehash_entries / 2
> >   tcp_max_syn_backlog : max(128, tcp_child_ehash_entries / 128)
> >
> > Also, we could optimise ehash lookup/iteration further by removing netns
> > comparison for the per-netns ehash in the future.
> >
> > As a bonus, we can dismantle netns faster.  Currently, while destroying
> > netns, we call inet_twsk_purge(), which walks through the global ehash.
> > It can be potentially big because it can have many sockets other than
> > TIME_WAIT in all netns.  Splitting ehash changes that situation, where
> > it's only necessary for inet_twsk_purge() to clean up TIME_WAIT sockets
> > in each netns.
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  Documentation/networking/ip-sysctl.rst | 20 +++++++++
> >  include/net/inet_hashtables.h          |  6 +++
> >  include/net/netns/ipv4.h               |  1 +
> >  net/dccp/proto.c                       |  2 +
> >  net/ipv4/inet_hashtables.c             | 57 ++++++++++++++++++++++++++
> >  net/ipv4/inet_timewait_sock.c          |  4 +-
> >  net/ipv4/sysctl_net_ipv4.c             | 57 ++++++++++++++++++++++++++
> >  net/ipv4/tcp.c                         |  1 +
> >  net/ipv4/tcp_ipv4.c                    | 53 ++++++++++++++++++++----
> >  net/ipv6/tcp_ipv6.c                    | 12 +++++-
> >  10 files changed, 202 insertions(+), 11 deletions(-)
> >
> > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> > index 56cd4ea059b2..97a0952b11e3 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -1037,6 +1037,26 @@ tcp_challenge_ack_limit - INTEGER
> >         in RFC 5961 (Improving TCP's Robustness to Blind In-Window Attacks)
> >         Default: 1000
> >
> > +tcp_ehash_entries - INTEGER
> > +       Read-only number of hash buckets for TCP sockets in the current
> > +       networking namespace.
> > +
> > +       A negative value means the networking namespace does not own its
> > +       hash buckets and shares the initial networking namespace's one.
> > +
> > +tcp_child_ehash_entries - INTEGER
> > +       Control the number of hash buckets for TCP sockets in the child
> > +       networking namespace, which must be set before clone() or unshare().
> > +
> > +       The written value except for 0 is rounded up to 2^n.  0 is a special
> > +       value, meaning the child networking namespace will share the initial
> > +       networking namespace's hash buckets.
> > +
> > +       Note that the child will use the global one in case the kernel
> > +       fails to allocate enough memory.
> > +
> > +       Default: 0
> > +
> >  UDP variables
> >  =============
> >
> > diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> > index 2c866112433e..039440936ab2 100644
> > --- a/include/net/inet_hashtables.h
> > +++ b/include/net/inet_hashtables.h
> > @@ -168,6 +168,8 @@ struct inet_hashinfo {
> >         /* The 2nd listener table hashed by local port and address */
> >         unsigned int                    lhash2_mask;
> >         struct inet_listen_hashbucket   *lhash2;
> > +
> > +       bool                            pernet;
> >  };
> >
> >  static inline struct inet_hashinfo *inet_get_hashinfo(const struct sock *sk)
> > @@ -214,6 +216,10 @@ static inline void inet_ehash_locks_free(struct inet_hashinfo *hashinfo)
> >         hashinfo->ehash_locks = NULL;
> >  }
> >
> > +struct inet_hashinfo *inet_pernet_hashinfo_alloc(struct inet_hashinfo *hashinfo,
> > +                                                unsigned int ehash_entries);
> > +void inet_pernet_hashinfo_free(struct inet_hashinfo *hashinfo);
> > +
> >  struct inet_bind_bucket *
> >  inet_bind_bucket_create(struct kmem_cache *cachep, struct net *net,
> >                         struct inet_bind_hashbucket *head,
> > diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> > index c7320ef356d9..6d9c01879027 100644
> > --- a/include/net/netns/ipv4.h
> > +++ b/include/net/netns/ipv4.h
> > @@ -170,6 +170,7 @@ struct netns_ipv4 {
> >         int sysctl_tcp_pacing_ca_ratio;
> >         int sysctl_tcp_wmem[3];
> >         int sysctl_tcp_rmem[3];
> > +       unsigned int sysctl_tcp_child_ehash_entries;
> >         unsigned long sysctl_tcp_comp_sack_delay_ns;
> >         unsigned long sysctl_tcp_comp_sack_slack_ns;
> >         int sysctl_max_syn_backlog;
> > diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> > index 7cd4a6cc99fc..c548ca3e9b0e 100644
> > --- a/net/dccp/proto.c
> > +++ b/net/dccp/proto.c
> > @@ -1197,6 +1197,8 @@ static int __init dccp_init(void)
> >                 INIT_HLIST_HEAD(&dccp_hashinfo.bhash2[i].chain);
> >         }
> >
> > +       dccp_hashinfo.pernet = false;
> > +
> >         rc = dccp_mib_init();
> >         if (rc)
> >                 goto out_free_dccp_bhash2;
> > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > index 5eb21a95179b..a57932b14bc6 100644
> > --- a/net/ipv4/inet_hashtables.c
> > +++ b/net/ipv4/inet_hashtables.c
> > @@ -1145,3 +1145,60 @@ int inet_ehash_locks_alloc(struct inet_hashinfo *hashinfo)
> >         return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(inet_ehash_locks_alloc);
> > +
> > +struct inet_hashinfo *inet_pernet_hashinfo_alloc(struct inet_hashinfo *hashinfo,
> > +                                                unsigned int ehash_entries)
> > +{
> > +       struct inet_hashinfo *new_hashinfo;
> > +       int i;
> > +
> > +       new_hashinfo = kmalloc(sizeof(*new_hashinfo), GFP_KERNEL);
> > +       if (!new_hashinfo)
> > +               goto err;
> > +
> > +       new_hashinfo->ehash = kvmalloc_array(ehash_entries,
> > +                                            sizeof(struct inet_ehash_bucket),
> > +                                            GFP_KERNEL);
> 
> GFP_KERNEL_ACCOUNT ?

Right, we should account the use.
Will use it in v2.


> 
> > +       if (!new_hashinfo->ehash)
> > +               goto free_hashinfo;
> > +
> > +       new_hashinfo->ehash_mask = ehash_entries - 1;
> > +
> > +       if (inet_ehash_locks_alloc(new_hashinfo))
> > +               goto free_ehash;
> > +
> > +       for (i = 0; i < ehash_entries; i++)
> > +               INIT_HLIST_NULLS_HEAD(&new_hashinfo->ehash[i].chain, i);
> > +
> > +       new_hashinfo->bind_bucket_cachep = hashinfo->bind_bucket_cachep;
> > +       new_hashinfo->bhash = hashinfo->bhash;
> > +       new_hashinfo->bind2_bucket_cachep = hashinfo->bind2_bucket_cachep;
> > +       new_hashinfo->bhash2 = hashinfo->bhash2;
> > +       new_hashinfo->bhash_size = hashinfo->bhash_size;
> > +
> > +       new_hashinfo->lhash2_mask = hashinfo->lhash2_mask;
> > +       new_hashinfo->lhash2 = hashinfo->lhash2;
> > +
> > +       new_hashinfo->pernet = true;
> > +
> > +       return new_hashinfo;
> > +
> > +free_ehash:
> > +       kvfree(new_hashinfo->ehash);
> > +free_hashinfo:
> > +       kfree(new_hashinfo);
> > +err:
> > +       return NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(inet_pernet_hashinfo_alloc);
> > +
> > +void inet_pernet_hashinfo_free(struct inet_hashinfo *hashinfo)
> > +{
> > +       if (!hashinfo->pernet)
> > +               return;
> > +
> > +       inet_ehash_locks_free(hashinfo);
> > +       kvfree(hashinfo->ehash);
> > +       kfree(hashinfo);
> > +}
> > +EXPORT_SYMBOL_GPL(inet_pernet_hashinfo_free);
> > diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> > index 47ccc343c9fb..a5d40acde9d6 100644
> > --- a/net/ipv4/inet_timewait_sock.c
> > +++ b/net/ipv4/inet_timewait_sock.c
> > @@ -59,8 +59,10 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
> >         inet_twsk_bind_unhash(tw, hashinfo);
> >         spin_unlock(&bhead->lock);
> >
> > -       if (refcount_dec_and_test(&tw->tw_dr->tw_refcount))
> > +       if (refcount_dec_and_test(&tw->tw_dr->tw_refcount)) {
> > +               inet_pernet_hashinfo_free(hashinfo);
> >                 kfree(tw->tw_dr);
> > +       }
> >
> >         inet_twsk_put(tw);
> >  }
> > diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> > index 5490c285668b..03a3187c4705 100644
> > --- a/net/ipv4/sysctl_net_ipv4.c
> > +++ b/net/ipv4/sysctl_net_ipv4.c
> > @@ -382,6 +382,48 @@ static int proc_tcp_available_ulp(struct ctl_table *ctl,
> >         return ret;
> >  }
> >
> > +static int proc_tcp_ehash_entries(struct ctl_table *table, int write,
> > +                                 void *buffer, size_t *lenp, loff_t *ppos)
> > +{
> > +       struct net *net = container_of(table->data, struct net,
> > +                                      ipv4.sysctl_tcp_child_ehash_entries);
> > +       struct inet_hashinfo *hinfo = net->ipv4.tcp_death_row->hashinfo;
> > +       int tcp_ehash_entries;
> > +       struct ctl_table tbl;
> > +
> > +       tcp_ehash_entries = hinfo->ehash_mask + 1;
> > +
> > +       /* A negative number indicates that the child netns
> > +        * shares the global ehash.
> > +        */
> > +       if (!net_eq(net, &init_net) && !hinfo->pernet)
> > +               tcp_ehash_entries *= -1;
> > +
> > +       tbl.data = &tcp_ehash_entries;
> > +       tbl.maxlen = sizeof(int);
> > +
> > +       return proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > +}
> > +
> > +static int proc_tcp_child_ehash_entries(struct ctl_table *table, int write,
> > +                                       void *buffer, size_t *lenp, loff_t *ppos)
> > +{
> > +       unsigned int tcp_child_ehash_entries;
> > +       int ret;
> > +
> > +       ret = proc_douintvec(table, write, buffer, lenp, ppos);
> > +       if (!write || ret)
> > +               return ret;
> > +
> > +       tcp_child_ehash_entries = READ_ONCE(*(unsigned int *)table->data);
> > +       if (tcp_child_ehash_entries)
> > +               tcp_child_ehash_entries = roundup_pow_of_two(tcp_child_ehash_entries);
> > +
> > +       WRITE_ONCE(*(unsigned int *)table->data, tcp_child_ehash_entries);
> > +
> > +       return 0;
> > +}
> > +
> >  #ifdef CONFIG_IP_ROUTE_MULTIPATH
> >  static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
> >                                           void *buffer, size_t *lenp,
> > @@ -1321,6 +1363,21 @@ static struct ctl_table ipv4_net_table[] = {
> >                 .extra1         = SYSCTL_ZERO,
> >                 .extra2         = SYSCTL_ONE,
> >         },
> > +       {
> > +               .procname       = "tcp_ehash_entries",
> > +               .data           = &init_net.ipv4.sysctl_tcp_child_ehash_entries,
> > +               .mode           = 0444,
> > +               .proc_handler   = proc_tcp_ehash_entries,
> > +       },
> > +       {
> > +               .procname       = "tcp_child_ehash_entries",
> > +               .data           = &init_net.ipv4.sysctl_tcp_child_ehash_entries,
> > +               .maxlen         = sizeof(unsigned int),
> > +               .mode           = 0644,
> > +               .proc_handler   = proc_tcp_child_ehash_entries,
> > +               .extra1         = SYSCTL_ZERO,
> > +               .extra2         = SYSCTL_INT_MAX,
> 
> Have you really tested what happens if you set the sysctl to max value
> 0x7fffffff
> 
> I would assume some kernel allocations will fail, or some loops will
> trigger some kind of soft lockups.

Yes, I saw vmalloc() error splat and fallback to the global ehash.
I think 4Mi or 8Mi should be enough for most workloads.
What do you think?

---8<---
[   46.525863] ------------[ cut here ]------------
[   46.526095] WARNING: CPU: 0 PID: 240 at mm/util.c:624 kvmalloc_node+0xbb/0xc0
[   46.526534] Modules linked in:
[   46.526901] CPU: 0 PID: 240 Comm: ip Not tainted 6.0.0-rc1-per-netns-hash-tcpudp-15620-gd02cde62bac1 #121
[   46.527241] Hardware name: Red Hat KVM, BIOS 1.11.0-2.amzn2 04/01/2014
[   46.527568] RIP: 0010:kvmalloc_node+0xbb/0xc0
[   46.527870] Code: 55 48 89 ef 68 00 04 00 00 48 8d 4c 0a ff e8 7c 74 03 00 48 83 c4 18 5d 41 5c 41 5d c3 cc cc cc cc 41 81 e4 00 20 00 00 75 ed <0f> 0b eb e9 90 55 48 89 fd e8 57 1d 03 00 48 89 ef 84 c0 74 06 5d
[   46.528493] RSP: 0018:ffffc9000022fd80 EFLAGS: 00000246
[   46.528801] RAX: 0000000000000000 RBX: 0000000080000000 RCX: 0000000000000000
[   46.529107] RDX: 0000000000000015 RSI: ffffffff81220571 RDI: 0000000000052cc0
[   46.529390] RBP: 0000000400000000 R08: ffffffff830ee280 R09: 0000000000000060
[   46.529730] R10: ffff888005305a00 R11: 0000000000001788 R12: 0000000000000000
[   46.529989] R13: 00000000ffffffff R14: ffffffff8389db80 R15: ffff88800550e300
[   46.530351] FS:  00007f1ca8200740(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
[   46.530731] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   46.530931] CR2: 00007f1ca82e9150 CR3: 00000000054ca000 CR4: 00000000000006f0
[   46.531386] Call Trace:
[   46.531966]  <TASK>
[   46.532277]  inet_pernet_hashinfo_alloc+0x40/0xe0
[   46.532530]  tcp_sk_init_pernet_hashinfo+0x26/0x80
[   46.532806]  ops_init+0x7a/0x150
[   46.532965]  setup_net+0x145/0x2b0
[   46.533116]  copy_net_ns+0xf8/0x1c0
[   46.533310]  create_new_namespaces+0x10e/0x2e0
[   46.533478]  unshare_nsproxy_namespaces+0x57/0x90
[   46.533731]  ksys_unshare+0x183/0x320
[   46.533863]  __x64_sys_unshare+0x9/0x10
[   46.534029]  do_syscall_64+0x3b/0x90
[   46.534192]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   46.534506] RIP: 0033:0x7f1ca82f86c7
[   46.534906] Code: 73 01 c3 48 8b 0d a9 07 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 79 07 0c 00 f7 d8 64 89 01 48
[   46.535581] RSP: 002b:00007ffd394c2298 EFLAGS: 00000206 ORIG_RAX: 0000000000000110
[   46.535860] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f1ca82f86c7
[   46.536118] RDX: 0000000000080000 RSI: 0000560877451812 RDI: 0000000040000000
[   46.536425] RBP: 0000000000000005 R08: 0000000000000000 R09: 00007ffd394c2140
[   46.536826] R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
[   46.537094] R13: 00007ffd394c22b8 R14: 00007ffd394c4490 R15: 00007f1ca82006c8
[   46.537437]  </TASK>
[   46.537558] ---[ end trace 0000000000000000 ]---
[   46.538077] TCP: Failed to allocate TCP ehash (entries: 2147483648) for a netns, fallback to use the global one
---8<---


> 
> > +       },
> >         {
> >                 .procname       = "udp_rmem_min",
> >                 .data           = &init_net.ipv4.sysctl_udp_rmem_min,
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index baf6adb723ad..f8ce673e32cb 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4788,6 +4788,7 @@ void __init tcp_init(void)
> >                 INIT_HLIST_HEAD(&tcp_hashinfo.bhash2[i].chain);
> >         }
> >
> > +       tcp_hashinfo.pernet = false;
> >
> >         cnt = tcp_hashinfo.ehash_mask + 1;
> >         sysctl_tcp_max_orphans = cnt / 2;
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index b07930643b11..604119f46b52 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -3109,14 +3109,23 @@ static void __net_exit tcp_sk_exit(struct net *net)
> >         if (net->ipv4.tcp_congestion_control)
> >                 bpf_module_put(net->ipv4.tcp_congestion_control,
> >                                net->ipv4.tcp_congestion_control->owner);
> > -       if (refcount_dec_and_test(&tcp_death_row->tw_refcount))
> > +       if (refcount_dec_and_test(&tcp_death_row->tw_refcount)) {
> > +               inet_pernet_hashinfo_free(tcp_death_row->hashinfo);
> >                 kfree(tcp_death_row);
> > +       }
> >  }
> >
> > -static int __net_init tcp_sk_init(struct net *net)
> > +static void __net_init tcp_set_hashinfo(struct net *net, struct inet_hashinfo *hinfo)
> >  {
> > -       int cnt;
> > +       int ehash_entries = hinfo->ehash_mask + 1;
> 
> 0x7fffffff + 1 -> integer overflow
> 

Nice catch!
I'll change it to unsigned int.


> >
> > +       net->ipv4.tcp_death_row->hashinfo = hinfo;
> > +       net->ipv4.tcp_death_row->sysctl_max_tw_buckets = ehash_entries / 2;
> > +       net->ipv4.sysctl_max_syn_backlog = max(128, ehash_entries / 128);
> > +}
> > +
> > +static int __net_init tcp_sk_init(struct net *net)
> > +{
> >         net->ipv4.sysctl_tcp_ecn = 2;
> >         net->ipv4.sysctl_tcp_ecn_fallback = 1;
> >
> > @@ -3145,12 +3154,10 @@ static int __net_init tcp_sk_init(struct net *net)
> >         net->ipv4.tcp_death_row = kzalloc(sizeof(struct inet_timewait_death_row), GFP_KERNEL);
> >         if (!net->ipv4.tcp_death_row)
> >                 return -ENOMEM;
> > +
> >         refcount_set(&net->ipv4.tcp_death_row->tw_refcount, 1);
> > -       cnt = tcp_hashinfo.ehash_mask + 1;
> > -       net->ipv4.tcp_death_row->sysctl_max_tw_buckets = cnt / 2;
> > -       net->ipv4.tcp_death_row->hashinfo = &tcp_hashinfo;
> > +       tcp_set_hashinfo(net, &tcp_hashinfo);
> >
> > -       net->ipv4.sysctl_max_syn_backlog = max(128, cnt / 128);
> >         net->ipv4.sysctl_tcp_sack = 1;
> >         net->ipv4.sysctl_tcp_window_scaling = 1;
> >         net->ipv4.sysctl_tcp_timestamps = 1;
> > @@ -3206,18 +3213,46 @@ static int __net_init tcp_sk_init(struct net *net)
> >         return 0;
> >  }
> >
> > +static int __net_init tcp_sk_init_pernet_hashinfo(struct net *net, struct net *old_net)
> > +{
> > +       struct inet_hashinfo *child_hinfo;
> > +       int ehash_entries;
> > +
> > +       ehash_entries = READ_ONCE(old_net->ipv4.sysctl_tcp_child_ehash_entries);
> > +       if (!ehash_entries)
> > +               goto out;
> > +
> > +       child_hinfo = inet_pernet_hashinfo_alloc(&tcp_hashinfo, ehash_entries);
> > +       if (child_hinfo)
> > +               tcp_set_hashinfo(net, child_hinfo);
> > +       else
> > +               pr_warn("Failed to allocate TCP ehash (entries: %u) "
> > +                       "for a netns, fallback to use the global one\n",
> > +                       ehash_entries);
> > +out:
> > +       return 0;
> > +}
> > +
> >  static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
> >  {
> > +       bool purge_once = true;
> >         struct net *net;
> >
> > -       inet_twsk_purge(&tcp_hashinfo, AF_INET);
> > +       list_for_each_entry(net, net_exit_list, exit_list) {
> > +               if (net->ipv4.tcp_death_row->hashinfo->pernet) {
> > +                       inet_twsk_purge(net->ipv4.tcp_death_row->hashinfo, AF_INET);
> > +               } else if (purge_once) {
> > +                       inet_twsk_purge(&tcp_hashinfo, AF_INET);
> > +                       purge_once = false;
> > +               }
> >
> > -       list_for_each_entry(net, net_exit_list, exit_list)
> >                 tcp_fastopen_ctx_destroy(net);
> > +       }
> >  }
> >
> >  static struct pernet_operations __net_initdata tcp_sk_ops = {
> >         .init      = tcp_sk_init,
> > +       .init2     = tcp_sk_init_pernet_hashinfo,
> >         .exit      = tcp_sk_exit,
> >         .exit_batch = tcp_sk_exit_batch,
> >  };
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index 27b2fd98a2c4..19f730428720 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -2229,7 +2229,17 @@ static void __net_exit tcpv6_net_exit(struct net *net)
> >
> >  static void __net_exit tcpv6_net_exit_batch(struct list_head *net_exit_list)
> >  {
> > -       inet_twsk_purge(&tcp_hashinfo, AF_INET6);
> > +       bool purge_once = true;
> > +       struct net *net;
> > +
> 
> This looks like a duplicate of ipv4 function. Opportunity of factorization ?

Exactly.
I'll factorise it in v2.


> 
> > +       list_for_each_entry(net, net_exit_list, exit_list) {
> > +               if (net->ipv4.tcp_death_row->hashinfo->pernet) {
> > +                       inet_twsk_purge(net->ipv4.tcp_death_row->hashinfo, AF_INET6);
> > +               } else if (purge_once) {
> > +                       inet_twsk_purge(&tcp_hashinfo, AF_INET6);
> > +                       purge_once = false;
> > +               }
> > +       }
> >  }
> >
> >  static struct pernet_operations tcpv6_net_ops = {
> > --
> > 2.30.2
> >
