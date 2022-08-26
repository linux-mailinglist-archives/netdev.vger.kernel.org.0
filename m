Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DDC5A2B39
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344637AbiHZP2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343602AbiHZP1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:27:06 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D631276F
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:25:07 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-33dba2693d0so43842167b3.12
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=EbqHJu2gPFgPhC2BBZCVegc+OgXK/NCk0YrfOaf6tco=;
        b=ae1fTUDj1/kdbevAapbHOMTSy6nxxe6rQGA+En3wlxyc/9txNIicxsckAzaYkdkD6/
         9nYQErkecn5tbGI+/fifOnbtL/mPjQo22VduOD0QI+x7xMRDVEaKZEVOvhPZVuxgOY/3
         cOtK/c8zoYWfjrh3wAazeFAS9h8nyHEGcuPDMuWat9f9/PI1A2344Q6C3bRWv3VUKWjL
         PFxRCz+e5NVVdEKNeNeSBhKps+W9cPl0x4C5+sJdwmjGM7ysh8reae4AsT5aUvAguECr
         84cSNJqpFMCEVyUCGdO4f7RpNp9TL/pvBB8yaz8ElFCFKxUp72Y7XWZ055z2xZj4JP+r
         wNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=EbqHJu2gPFgPhC2BBZCVegc+OgXK/NCk0YrfOaf6tco=;
        b=vR54u+9xTorduIDXqZIjK1ydCeNmzim+YWeFNUmJkBCMQ5JWCP+2B1SS4HgEiFxCSQ
         ySHHkPAfEJEUYZAUvV/TZDO9TbRPCeSE/OtUzeFIziUO6IhLv9ZUARKVkAjVntG73fWq
         KEdinEtRqX/LshcVpOuV3O0kgpP7RyWkcmztr40r+FAGvf0WDFqQIdYw/HkQCKgtWFMN
         lY3KzpGKffN4I51ir9sRjPW5Z3ZYyIVXAOKwl0jdC184pwyJU4U7PR4qdYTuRSu3rwX1
         bITURjER7ypeTQyginvKzMdV+dU4toon8yzE6SphJjSKO+Qi08VtKiaEnu+MJnDwF/EB
         FqWQ==
X-Gm-Message-State: ACgBeo2KlBjR7Ln7z1m2P5NIGR1G1Ty2rhYDoieVr70/xxax7sSVXHbQ
        zN6YhPR0zDLB2YOCb0RxErnDPfoX5YneHGZ34WUJZw==
X-Google-Smtp-Source: AA6agR5iMB3qVythr/pM+uVx+NYb3RYhay7yIbTKGbwa4WitRUq3Y7bC/+tQ+l/36YndVnq4qmoFbxgOEIQp0tAubWY=
X-Received: by 2002:a0d:c681:0:b0:33c:2e21:4756 with SMTP id
 i123-20020a0dc681000000b0033c2e214756mr147338ywd.467.1661527506194; Fri, 26
 Aug 2022 08:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220826000445.46552-1-kuniyu@amazon.com> <20220826000445.46552-9-kuniyu@amazon.com>
In-Reply-To: <20220826000445.46552-9-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Aug 2022 08:24:54 -0700
Message-ID: <CANn89i+L9vhzGVdz=3eGa+euk_QgH0Cuc8zmaODUumnphEnd6A@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 08/13] tcp: Introduce optional per-netns ehash.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 5:07 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> The more sockets we have in the hash table, the more time we spend
> looking up the socket.  While running a number of small workloads on
> the same host, they penalise each other and cause performance degradation.
>
> Also, the root cause might be a single workload that consumes much more
> resources than the others.  It often happens on a cloud service where
> different workloads share the same computing resource.
>
> To resolve the issue, we introduce an optional per-netns hash table for
> TCP, but it's just ehash, and we still share the global bhash and lhash2.
>
> With a smaller ehash, we can look up non-listener sockets faster and
> isolate such noisy neighbours.  Also, we can reduce lock contention.
>
> We can control the ehash size by a new sysctl knob.  However, depending
> on workloads, it will require very sensitive tuning, so we disable the
> feature by default (net.ipv4.tcp_child_ehash_entries == 0).  Moreover,
> we can fall back to using the global ehash in case we fail to allocate
> enough memory for a new ehash.
>
> We can check the current ehash size by another read-only sysctl knob,
> net.ipv4.tcp_ehash_entries.  A negative value means the netns shares
> the global ehash (per-netns ehash is disabled or failed to allocate
> memory).
>
>   # dmesg | cut -d ' ' -f 5- | grep "established hash"
>   TCP established hash table entries: 524288 (order: 10, 4194304 bytes, vmalloc hugepage)
>
>   # sysctl net.ipv4.tcp_ehash_entries
>   net.ipv4.tcp_ehash_entries = 524288  # can be changed by thash_entries
>
>   # sysctl net.ipv4.tcp_child_ehash_entries
>   net.ipv4.tcp_child_ehash_entries = 0  # disabled by default
>
>   # ip netns add test1
>   # ip netns exec test1 sysctl net.ipv4.tcp_ehash_entries
>   net.ipv4.tcp_ehash_entries = -524288  # share the global ehash
>
>   # sysctl -w net.ipv4.tcp_child_ehash_entries=100
>   net.ipv4.tcp_child_ehash_entries = 100
>
>   # sysctl net.ipv4.tcp_child_ehash_entries
>   net.ipv4.tcp_child_ehash_entries = 128  # rounded up to 2^n
>
>   # ip netns add test2
>   # ip netns exec test2 sysctl net.ipv4.tcp_ehash_entries
>   net.ipv4.tcp_ehash_entries = 128  # own per-netns ehash
>
> When more than two processes in the same netns create per-netns ehash
> concurrently with different sizes, we need to guarantee the size in
> one of the following ways:
>
>   1) Share the global ehash and create per-netns ehash
>
>   First, unshare() with tcp_child_ehash_entries==0.  It creates dedicated
>   netns sysctl knobs where we can safely change tcp_child_ehash_entries
>   and clone()/unshare() to create a per-netns ehash.
>
>   2) Lock the sysctl knob
>
>   We can use flock(LOCK_MAND) or BPF_PROG_TYPE_CGROUP_SYSCTL to allow/deny
>   read/write on sysctl knobs.
>
> Note the default values of two sysctl knobs depend on the ehash size and
> should be tuned carefully:
>
>   tcp_max_tw_buckets  : tcp_child_ehash_entries / 2
>   tcp_max_syn_backlog : max(128, tcp_child_ehash_entries / 128)
>
> Also, we could optimise ehash lookup/iteration further by removing netns
> comparison for the per-netns ehash in the future.
>
> As a bonus, we can dismantle netns faster.  Currently, while destroying
> netns, we call inet_twsk_purge(), which walks through the global ehash.
> It can be potentially big because it can have many sockets other than
> TIME_WAIT in all netns.  Splitting ehash changes that situation, where
> it's only necessary for inet_twsk_purge() to clean up TIME_WAIT sockets
> in each netns.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 20 +++++++++
>  include/net/inet_hashtables.h          |  6 +++
>  include/net/netns/ipv4.h               |  1 +
>  net/dccp/proto.c                       |  2 +
>  net/ipv4/inet_hashtables.c             | 57 ++++++++++++++++++++++++++
>  net/ipv4/inet_timewait_sock.c          |  4 +-
>  net/ipv4/sysctl_net_ipv4.c             | 57 ++++++++++++++++++++++++++
>  net/ipv4/tcp.c                         |  1 +
>  net/ipv4/tcp_ipv4.c                    | 53 ++++++++++++++++++++----
>  net/ipv6/tcp_ipv6.c                    | 12 +++++-
>  10 files changed, 202 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 56cd4ea059b2..97a0952b11e3 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1037,6 +1037,26 @@ tcp_challenge_ack_limit - INTEGER
>         in RFC 5961 (Improving TCP's Robustness to Blind In-Window Attacks)
>         Default: 1000
>
> +tcp_ehash_entries - INTEGER
> +       Read-only number of hash buckets for TCP sockets in the current
> +       networking namespace.
> +
> +       A negative value means the networking namespace does not own its
> +       hash buckets and shares the initial networking namespace's one.
> +
> +tcp_child_ehash_entries - INTEGER
> +       Control the number of hash buckets for TCP sockets in the child
> +       networking namespace, which must be set before clone() or unshare().
> +
> +       The written value except for 0 is rounded up to 2^n.  0 is a special
> +       value, meaning the child networking namespace will share the initial
> +       networking namespace's hash buckets.
> +
> +       Note that the child will use the global one in case the kernel
> +       fails to allocate enough memory.
> +
> +       Default: 0
> +
>  UDP variables
>  =============
>
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index 2c866112433e..039440936ab2 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -168,6 +168,8 @@ struct inet_hashinfo {
>         /* The 2nd listener table hashed by local port and address */
>         unsigned int                    lhash2_mask;
>         struct inet_listen_hashbucket   *lhash2;
> +
> +       bool                            pernet;
>  };
>
>  static inline struct inet_hashinfo *inet_get_hashinfo(const struct sock *sk)
> @@ -214,6 +216,10 @@ static inline void inet_ehash_locks_free(struct inet_hashinfo *hashinfo)
>         hashinfo->ehash_locks = NULL;
>  }
>
> +struct inet_hashinfo *inet_pernet_hashinfo_alloc(struct inet_hashinfo *hashinfo,
> +                                                unsigned int ehash_entries);
> +void inet_pernet_hashinfo_free(struct inet_hashinfo *hashinfo);
> +
>  struct inet_bind_bucket *
>  inet_bind_bucket_create(struct kmem_cache *cachep, struct net *net,
>                         struct inet_bind_hashbucket *head,
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index c7320ef356d9..6d9c01879027 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -170,6 +170,7 @@ struct netns_ipv4 {
>         int sysctl_tcp_pacing_ca_ratio;
>         int sysctl_tcp_wmem[3];
>         int sysctl_tcp_rmem[3];
> +       unsigned int sysctl_tcp_child_ehash_entries;
>         unsigned long sysctl_tcp_comp_sack_delay_ns;
>         unsigned long sysctl_tcp_comp_sack_slack_ns;
>         int sysctl_max_syn_backlog;
> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> index 7cd4a6cc99fc..c548ca3e9b0e 100644
> --- a/net/dccp/proto.c
> +++ b/net/dccp/proto.c
> @@ -1197,6 +1197,8 @@ static int __init dccp_init(void)
>                 INIT_HLIST_HEAD(&dccp_hashinfo.bhash2[i].chain);
>         }
>
> +       dccp_hashinfo.pernet = false;
> +
>         rc = dccp_mib_init();
>         if (rc)
>                 goto out_free_dccp_bhash2;
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 5eb21a95179b..a57932b14bc6 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -1145,3 +1145,60 @@ int inet_ehash_locks_alloc(struct inet_hashinfo *hashinfo)
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(inet_ehash_locks_alloc);
> +
> +struct inet_hashinfo *inet_pernet_hashinfo_alloc(struct inet_hashinfo *hashinfo,
> +                                                unsigned int ehash_entries)
> +{
> +       struct inet_hashinfo *new_hashinfo;
> +       int i;
> +
> +       new_hashinfo = kmalloc(sizeof(*new_hashinfo), GFP_KERNEL);
> +       if (!new_hashinfo)
> +               goto err;
> +
> +       new_hashinfo->ehash = kvmalloc_array(ehash_entries,
> +                                            sizeof(struct inet_ehash_bucket),
> +                                            GFP_KERNEL);

GFP_KERNEL_ACCOUNT ?

> +       if (!new_hashinfo->ehash)
> +               goto free_hashinfo;
> +
> +       new_hashinfo->ehash_mask = ehash_entries - 1;
> +
> +       if (inet_ehash_locks_alloc(new_hashinfo))
> +               goto free_ehash;
> +
> +       for (i = 0; i < ehash_entries; i++)
> +               INIT_HLIST_NULLS_HEAD(&new_hashinfo->ehash[i].chain, i);
> +
> +       new_hashinfo->bind_bucket_cachep = hashinfo->bind_bucket_cachep;
> +       new_hashinfo->bhash = hashinfo->bhash;
> +       new_hashinfo->bind2_bucket_cachep = hashinfo->bind2_bucket_cachep;
> +       new_hashinfo->bhash2 = hashinfo->bhash2;
> +       new_hashinfo->bhash_size = hashinfo->bhash_size;
> +
> +       new_hashinfo->lhash2_mask = hashinfo->lhash2_mask;
> +       new_hashinfo->lhash2 = hashinfo->lhash2;
> +
> +       new_hashinfo->pernet = true;
> +
> +       return new_hashinfo;
> +
> +free_ehash:
> +       kvfree(new_hashinfo->ehash);
> +free_hashinfo:
> +       kfree(new_hashinfo);
> +err:
> +       return NULL;
> +}
> +EXPORT_SYMBOL_GPL(inet_pernet_hashinfo_alloc);
> +
> +void inet_pernet_hashinfo_free(struct inet_hashinfo *hashinfo)
> +{
> +       if (!hashinfo->pernet)
> +               return;
> +
> +       inet_ehash_locks_free(hashinfo);
> +       kvfree(hashinfo->ehash);
> +       kfree(hashinfo);
> +}
> +EXPORT_SYMBOL_GPL(inet_pernet_hashinfo_free);
> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> index 47ccc343c9fb..a5d40acde9d6 100644
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -59,8 +59,10 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
>         inet_twsk_bind_unhash(tw, hashinfo);
>         spin_unlock(&bhead->lock);
>
> -       if (refcount_dec_and_test(&tw->tw_dr->tw_refcount))
> +       if (refcount_dec_and_test(&tw->tw_dr->tw_refcount)) {
> +               inet_pernet_hashinfo_free(hashinfo);
>                 kfree(tw->tw_dr);
> +       }
>
>         inet_twsk_put(tw);
>  }
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 5490c285668b..03a3187c4705 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -382,6 +382,48 @@ static int proc_tcp_available_ulp(struct ctl_table *ctl,
>         return ret;
>  }
>
> +static int proc_tcp_ehash_entries(struct ctl_table *table, int write,
> +                                 void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +       struct net *net = container_of(table->data, struct net,
> +                                      ipv4.sysctl_tcp_child_ehash_entries);
> +       struct inet_hashinfo *hinfo = net->ipv4.tcp_death_row->hashinfo;
> +       int tcp_ehash_entries;
> +       struct ctl_table tbl;
> +
> +       tcp_ehash_entries = hinfo->ehash_mask + 1;
> +
> +       /* A negative number indicates that the child netns
> +        * shares the global ehash.
> +        */
> +       if (!net_eq(net, &init_net) && !hinfo->pernet)
> +               tcp_ehash_entries *= -1;
> +
> +       tbl.data = &tcp_ehash_entries;
> +       tbl.maxlen = sizeof(int);
> +
> +       return proc_dointvec(&tbl, write, buffer, lenp, ppos);
> +}
> +
> +static int proc_tcp_child_ehash_entries(struct ctl_table *table, int write,
> +                                       void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +       unsigned int tcp_child_ehash_entries;
> +       int ret;
> +
> +       ret = proc_douintvec(table, write, buffer, lenp, ppos);
> +       if (!write || ret)
> +               return ret;
> +
> +       tcp_child_ehash_entries = READ_ONCE(*(unsigned int *)table->data);
> +       if (tcp_child_ehash_entries)
> +               tcp_child_ehash_entries = roundup_pow_of_two(tcp_child_ehash_entries);
> +
> +       WRITE_ONCE(*(unsigned int *)table->data, tcp_child_ehash_entries);
> +
> +       return 0;
> +}
> +
>  #ifdef CONFIG_IP_ROUTE_MULTIPATH
>  static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
>                                           void *buffer, size_t *lenp,
> @@ -1321,6 +1363,21 @@ static struct ctl_table ipv4_net_table[] = {
>                 .extra1         = SYSCTL_ZERO,
>                 .extra2         = SYSCTL_ONE,
>         },
> +       {
> +               .procname       = "tcp_ehash_entries",
> +               .data           = &init_net.ipv4.sysctl_tcp_child_ehash_entries,
> +               .mode           = 0444,
> +               .proc_handler   = proc_tcp_ehash_entries,
> +       },
> +       {
> +               .procname       = "tcp_child_ehash_entries",
> +               .data           = &init_net.ipv4.sysctl_tcp_child_ehash_entries,
> +               .maxlen         = sizeof(unsigned int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_tcp_child_ehash_entries,
> +               .extra1         = SYSCTL_ZERO,
> +               .extra2         = SYSCTL_INT_MAX,

Have you really tested what happens if you set the sysctl to max value
0x7fffffff

I would assume some kernel allocations will fail, or some loops will
trigger some kind of soft lockups.

> +       },
>         {
>                 .procname       = "udp_rmem_min",
>                 .data           = &init_net.ipv4.sysctl_udp_rmem_min,
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index baf6adb723ad..f8ce673e32cb 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4788,6 +4788,7 @@ void __init tcp_init(void)
>                 INIT_HLIST_HEAD(&tcp_hashinfo.bhash2[i].chain);
>         }
>
> +       tcp_hashinfo.pernet = false;
>
>         cnt = tcp_hashinfo.ehash_mask + 1;
>         sysctl_tcp_max_orphans = cnt / 2;
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index b07930643b11..604119f46b52 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -3109,14 +3109,23 @@ static void __net_exit tcp_sk_exit(struct net *net)
>         if (net->ipv4.tcp_congestion_control)
>                 bpf_module_put(net->ipv4.tcp_congestion_control,
>                                net->ipv4.tcp_congestion_control->owner);
> -       if (refcount_dec_and_test(&tcp_death_row->tw_refcount))
> +       if (refcount_dec_and_test(&tcp_death_row->tw_refcount)) {
> +               inet_pernet_hashinfo_free(tcp_death_row->hashinfo);
>                 kfree(tcp_death_row);
> +       }
>  }
>
> -static int __net_init tcp_sk_init(struct net *net)
> +static void __net_init tcp_set_hashinfo(struct net *net, struct inet_hashinfo *hinfo)
>  {
> -       int cnt;
> +       int ehash_entries = hinfo->ehash_mask + 1;

0x7fffffff + 1 -> integer overflow

>
> +       net->ipv4.tcp_death_row->hashinfo = hinfo;
> +       net->ipv4.tcp_death_row->sysctl_max_tw_buckets = ehash_entries / 2;
> +       net->ipv4.sysctl_max_syn_backlog = max(128, ehash_entries / 128);
> +}
> +
> +static int __net_init tcp_sk_init(struct net *net)
> +{
>         net->ipv4.sysctl_tcp_ecn = 2;
>         net->ipv4.sysctl_tcp_ecn_fallback = 1;
>
> @@ -3145,12 +3154,10 @@ static int __net_init tcp_sk_init(struct net *net)
>         net->ipv4.tcp_death_row = kzalloc(sizeof(struct inet_timewait_death_row), GFP_KERNEL);
>         if (!net->ipv4.tcp_death_row)
>                 return -ENOMEM;
> +
>         refcount_set(&net->ipv4.tcp_death_row->tw_refcount, 1);
> -       cnt = tcp_hashinfo.ehash_mask + 1;
> -       net->ipv4.tcp_death_row->sysctl_max_tw_buckets = cnt / 2;
> -       net->ipv4.tcp_death_row->hashinfo = &tcp_hashinfo;
> +       tcp_set_hashinfo(net, &tcp_hashinfo);
>
> -       net->ipv4.sysctl_max_syn_backlog = max(128, cnt / 128);
>         net->ipv4.sysctl_tcp_sack = 1;
>         net->ipv4.sysctl_tcp_window_scaling = 1;
>         net->ipv4.sysctl_tcp_timestamps = 1;
> @@ -3206,18 +3213,46 @@ static int __net_init tcp_sk_init(struct net *net)
>         return 0;
>  }
>
> +static int __net_init tcp_sk_init_pernet_hashinfo(struct net *net, struct net *old_net)
> +{
> +       struct inet_hashinfo *child_hinfo;
> +       int ehash_entries;
> +
> +       ehash_entries = READ_ONCE(old_net->ipv4.sysctl_tcp_child_ehash_entries);
> +       if (!ehash_entries)
> +               goto out;
> +
> +       child_hinfo = inet_pernet_hashinfo_alloc(&tcp_hashinfo, ehash_entries);
> +       if (child_hinfo)
> +               tcp_set_hashinfo(net, child_hinfo);
> +       else
> +               pr_warn("Failed to allocate TCP ehash (entries: %u) "
> +                       "for a netns, fallback to use the global one\n",
> +                       ehash_entries);
> +out:
> +       return 0;
> +}
> +
>  static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
>  {
> +       bool purge_once = true;
>         struct net *net;
>
> -       inet_twsk_purge(&tcp_hashinfo, AF_INET);
> +       list_for_each_entry(net, net_exit_list, exit_list) {
> +               if (net->ipv4.tcp_death_row->hashinfo->pernet) {
> +                       inet_twsk_purge(net->ipv4.tcp_death_row->hashinfo, AF_INET);
> +               } else if (purge_once) {
> +                       inet_twsk_purge(&tcp_hashinfo, AF_INET);
> +                       purge_once = false;
> +               }
>
> -       list_for_each_entry(net, net_exit_list, exit_list)
>                 tcp_fastopen_ctx_destroy(net);
> +       }
>  }
>
>  static struct pernet_operations __net_initdata tcp_sk_ops = {
>         .init      = tcp_sk_init,
> +       .init2     = tcp_sk_init_pernet_hashinfo,
>         .exit      = tcp_sk_exit,
>         .exit_batch = tcp_sk_exit_batch,
>  };
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 27b2fd98a2c4..19f730428720 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -2229,7 +2229,17 @@ static void __net_exit tcpv6_net_exit(struct net *net)
>
>  static void __net_exit tcpv6_net_exit_batch(struct list_head *net_exit_list)
>  {
> -       inet_twsk_purge(&tcp_hashinfo, AF_INET6);
> +       bool purge_once = true;
> +       struct net *net;
> +

This looks like a duplicate of ipv4 function. Opportunity of factorization ?

> +       list_for_each_entry(net, net_exit_list, exit_list) {
> +               if (net->ipv4.tcp_death_row->hashinfo->pernet) {
> +                       inet_twsk_purge(net->ipv4.tcp_death_row->hashinfo, AF_INET6);
> +               } else if (purge_once) {
> +                       inet_twsk_purge(&tcp_hashinfo, AF_INET6);
> +                       purge_once = false;
> +               }
> +       }
>  }
>
>  static struct pernet_operations tcpv6_net_ops = {
> --
> 2.30.2
>
