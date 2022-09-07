Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC015B0EA6
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 22:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiIGUzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 16:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIGUzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 16:55:22 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62BF17ABE
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 13:55:20 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3450a7358baso113572917b3.13
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 13:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Oyb0Y0q2T8Ry3otGX/Tp/0jHn8x4Brkv0iPhDpt9OpI=;
        b=lmEpIyWGtyakbKw9BvPvgXyBKasAwZZMyquW2BSR/Nx0hWHFfYU2lanv6MP4V7E+f3
         syDetwiYJduDAAQeEl3S0u2sZ6tSvriG4mRkusE9vHKLDxUGf/A2Ld+nYULsgHYEy0No
         Oqhl19HksEqSBmt8B4jLWJT/gvw/6WAWNCS+GihIS5/pXkYM93XLPJupyVaGL5Hv+adQ
         WFZYkvvoSWpX2gOQtBHXZnk2lWI40u4jneuBq1O3oo7ZhSH+ner6gtZ5maJI+Q4I7yf9
         And7kRi2c41h++lJuANz4M2lNG3k7XjJcrYdVhGyTKQ2KiZd/YtE13jzxb0fimW1ksxf
         7Hiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Oyb0Y0q2T8Ry3otGX/Tp/0jHn8x4Brkv0iPhDpt9OpI=;
        b=bb+tj+O7+Q9IidleJMHzfhEiAmS+YaH7OGg8Iy3iUqEr2/8Lt+EsPB4v7QpzDHdGPi
         qw4pAr9ZnnUkFdoZFTX8EzGEZiV0mrXElmInw+GK5BD1MEhfaBORAszcFJw1BHd7b7Kz
         hat5H2/Q2tvhCq8FY+Gfchm01iI0t03YcJahtJ6CT7zUqsyvONhmr3ElzvpM/aFYVbxc
         JNIO23hyw3smO5SEcYsv3PPIqlyM9Dg9/7ivmHRM2qQGplGW9eDy9ddhbiwQiYFhrfoz
         P2ooS0fhEFAU/rWpKLVQQj4KiuYh2j1UPWit2MBd9SYaHdr3PkLhvu+2Q3kyXfqJs3LM
         WYOw==
X-Gm-Message-State: ACgBeo3TxNCuupjznhfJJA12q8zRijeQ+iorFmrNdum07Tl7+X95OG5c
        Q2AN1fFCZ44+zvDAb06STIph+lyMyrp+qly3XDYBBQ==
X-Google-Smtp-Source: AA6agR49L/nHBPkgqZNgn2VRthG1xocvnYYs0MrG9wEB7fQpvb+q8IkwhxM6q4OV8bodCv85s7phmGQSwYY2uTFrKI8=
X-Received: by 2002:a0d:f045:0:b0:324:55ec:6595 with SMTP id
 z66-20020a0df045000000b0032455ec6595mr4960129ywe.255.1662584119702; Wed, 07
 Sep 2022 13:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220907005534.72876-1-kuniyu@amazon.com> <20220907005534.72876-7-kuniyu@amazon.com>
In-Reply-To: <20220907005534.72876-7-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Sep 2022 13:55:08 -0700
Message-ID: <CANn89i+mJdBZB3ecGa6-N3FdOAHv0Of=XYus389TiMMH5PYeug@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 6/6] tcp: Introduce optional per-netns ehash.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>
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

On Tue, Sep 6, 2022 at 5:57 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> The more sockets we have in the hash table, the longer we spend looking
> up the socket.  While running a number of small workloads on the same
> host, they penalise each other and cause performance degradation.
>
> The root cause might be a single workload that consumes much more
> resources than the others.  It often happens on a cloud service where
> different workloads share the same computing resource.
>
> On EC2 c5.24xlarge instance (196 GiB memory and 524288 (1Mi / 2) ehash
> entries), after running iperf3 in different netns, creating 24Mi sockets
> without data transfer in the root netns causes about 10% performance
> regression for the iperf3's connection.
>
>  thash_entries          sockets         length          Gbps
>         524288                1              1          50.7
>                            24Mi             48          45.1
>
> It is basically related to the length of the list of each hash bucket.
> For testing purposes to see how performance drops along the length,
> I set 131072 (1Mi / 8) to thash_entries, and here's the result.
>
>  thash_entries          sockets         length          Gbps
>         131072                1              1          50.7
>                             1Mi              8          49.9
>                             2Mi             16          48.9
>                             4Mi             32          47.3
>                             8Mi             64          44.6
>                            16Mi            128          40.6
>                            24Mi            192          36.3
>                            32Mi            256          32.5
>                            40Mi            320          27.0
>                            48Mi            384          25.0
>
> To resolve the socket lookup degradation, we introduce an optional
> per-netns hash table for TCP, but it's just ehash, and we still share
> the global bhash, bhash2 and lhash2.
>
> With a smaller ehash, we can look up non-listener sockets faster and
> isolate such noisy neighbours.  In addition, we can reduce lock contention.
>
> We can control the ehash size by a new sysctl knob.  However, depending
> on workloads, it will require very sensitive tuning, so we disable the
> feature by default (net.ipv4.tcp_child_ehash_entries == 0).  Moreover,
> we can fall back to using the global ehash in case we fail to allocate
> enough memory for a new ehash.  The maximum size is 16Mi, which is large
> enough that even if we have 48Mi sockets, the average list length is 3,
> and regression would be less than 1%.
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
>   # ip netns add test2
>   # ip netns exec test2 sysctl net.ipv4.tcp_ehash_entries
>   net.ipv4.tcp_ehash_entries = 128  # own a per-netns ehash with 2^n buckets
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
>   2) Control write on sysctl by BPF
>
>   We can use BPF_PROG_TYPE_CGROUP_SYSCTL to allow/deny read/write on
>   sysctl knobs.
>
> Note the default values of two sysctl knobs depend on the ehash size and
> should be tuned carefully:
>
>   tcp_max_tw_buckets  : tcp_child_ehash_entries / 2
>   tcp_max_syn_backlog : max(128, tcp_child_ehash_entries / 128)
>
> As a bonus, we can dismantle netns faster.  Currently, while destroying
> netns, we call inet_twsk_purge(), which walks through the global ehash.
> It can be potentially big because it can have many sockets other than
> TIME_WAIT in all netns.  Splitting ehash changes that situation, where
> it's only necessary for inet_twsk_purge() to clean up TIME_WAIT sockets
> in each netns.
>
> With regard to this, we do not free the per-netns ehash in inet_twsk_kill()
> to avoid UAF while iterating the per-netns ehash in inet_twsk_purge().
> Instead, we do it in tcp_sk_exit_batch() after calling tcp_twsk_purge() to
> keep it protocol-family-independent.
>
> In the future, we could optimise ehash lookup/iteration further by removing
> netns comparison for the per-netns ehash.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

...

> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index c440de998910..e94e1316fcc3 100644
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
> +                                            GFP_KERNEL_ACCOUNT);

Note that in current kernel,  init_net ehash table is using hugepages:

# dmesg | grep "TCP established hash table"
[   17.512756] TCP established hash table entries: 524288 (order: 10,
4194304 bytes, vmalloc hugepage)

As this is very desirable, I would suggest using the following to
avoid possible performance regression,
especially for workload wanting a big ehash, as hinted by your changelog.

new_hashinfo->ehash = vmalloc_huge(ehash_entries * sizeof(struct
inet_ehash_bucket), GFP_KERNEL_ACCOUNT);

(No overflow can happen in the multiply, as ehash_entries < 16M)

Another point is that on NUMA, init_net ehash table is spread over
available NUMA nodes.

While net_pernet_hashinfo_alloc() will allocate pages depending on
current process NUMA policy.

Maybe worth noting this in the changelog, because it is very possible
that new nets
is created with default NUMA policy, and depending on which cpu
current thread is
running, hash table will fully reside on a 'random' node, with very
different performance
results for highly optimized networking applications.


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
