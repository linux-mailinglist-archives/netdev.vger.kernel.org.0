Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643D65A2B0D
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344529AbiHZPYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344532AbiHZPXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:23:52 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7DFEA17D
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:17:37 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-33da3a391d8so44081237b3.2
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1zkgmEo0TBCjGgvSN70EbsJnfEsCx7eLPwFPqNZmr98=;
        b=svyKOB+3y+kP6r6ZVJz6Cr7ZbYb4d83EFlhGlccb6y7O9jydD8olI4ydKoyeLCYJwG
         0EeI+PgyKfxF8NWlW2Rr0LCuSzpvDxHbQfUqEVqP5wmY0IGVX1ocOXKWNS24s0MmPGb2
         Go+jTbSbbHDbJbTRaZ0r8nQML07+rwsYDF+jiuZUOFTVqotuxZGc/F7+zc8zIo/IIzBK
         X9Rxl/ZUtuUuIZ9W0R2hUqLDo9M54hUlqYTj5jw6p07KoZJ6L4BDlhY6UYqT7l8XMUpP
         nG05iHp5/OeMv69nHLXa4upRqCCVTLJf6rp2INWIplO0UL5/0KxHqzrkK4n6+XRyzXvL
         qMLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1zkgmEo0TBCjGgvSN70EbsJnfEsCx7eLPwFPqNZmr98=;
        b=J43wsE4hPJLm4Q+31GDGaQeocLKwxJZ2FNwQ2NKt77OcxEJrOvkQhHxLEKSLQs16ef
         4RJC3ERF7i9kd5TR1XqIfpIe11NpNglI1C0ear4DKQ3qAE5l47zcGmjhzH4QMAgJ7MFk
         I5n+BJCVQcrudsHre6jyKBFqPc6TbxpApZUmSItZpLnlwJtkltXEYdYemeewEm/MjegT
         ph4rw7TjlUUz+Ypdexkfx4pkmLy4uCTKmNIqq0w/Oy/pLnWppDKkHdjGBlH7VEqqo3eR
         YKHQKgjjbFMU27qF61B8XVRMhXVlVU2S/5eGRxSr+0JnVIWiIO1gS3v46acK3koqgppw
         SDpg==
X-Gm-Message-State: ACgBeo3RdocKSM8AvAZckfTSVR2EeC1pNB262jPP4NeirK39+qZ3K/TZ
        9UQNCEA2GYnWj96h+xmuQslUXnYCfFw6o9PsQnNdGw==
X-Google-Smtp-Source: AA6agR4SproLxRDEsMChFtk9DRNESHOYrfkD8vsTdw166AFGRMGGhkuRpTeK4/6hj7E5HCcKFP3MbGD/kdMob9DBzO4=
X-Received: by 2002:a25:7cc6:0:b0:67a:6a2e:3d42 with SMTP id
 x189-20020a257cc6000000b0067a6a2e3d42mr126197ybc.231.1661527056790; Fri, 26
 Aug 2022 08:17:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220826000445.46552-1-kuniyu@amazon.com>
In-Reply-To: <20220826000445.46552-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Aug 2022 08:17:25 -0700
Message-ID: <CANn89i+pfVeH0Gs4tFPcZstnfxjz-Vp2D86H5AQsdsR_+p_3qQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 00/13] tcp/udp: Introduce optional per-netns
 hash table.
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

On Thu, Aug 25, 2022 at 5:05 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> The more sockets we have in the hash table, the more time we spend
> looking up the socket.  While running a number of small workloads on
> the same host, they penalise each other and cause performance degradation.
>
> Also, the root cause might be a single workload that consumes much more
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
> per-netns hash table for TCP and UDP.  With a smaller hash table, we
> can look up sockets faster and isolate noisy neighbours.  Also, we can
> reduce lock contention.
>
> We can control and check the hash size via sysctl knobs.  It requires
> some tuning based on workloads, so the per-netns hash table is disabled
> by default.
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
>   [ UDP has the same interface as udp_hash_entries and
>     udp_child_hash_entries. ]
>
> When creating per-netns concurrently with different sizes, we can
> guarantee the size by doing one of these ways.
>
>   1) Share the global hash table and create per-netns one
>
>   First, unshare() with tcp_child_ehash_entries==0.  It creates dedicated
>   netns sysctl knobs where we can safely change tcp_child_ehash_entries
>   and clone()/unshare() to create a per-netns hash table.
>
>   2) Lock the sysctl knob
>

This is orthogonal.

Your series should have been split in three really.

I do not want to discuss the merit of re-instating LOCK_MAND :/



>   We can use flock(LOCK_MAND) or BPF_PROG_TYPE_CGROUP_SYSCTL to allow/deny
>   read/write on sysctl knobs.
>
> For details, please see each patch.
>
>   patch  1 -  3: mandatory lock support for sysctl (fs stuff)
>   patch  4 -  7: prep patch for per-netns TCP ehash
>   patch       8: add per-netns TCP ehash
>   patch  9 - 12: prep patch for per-netns UDP hash table
>   patch      13: add per-netns UDP hash table
>
>
> Kuniyuki Iwashima (13):
>   fs/lock: Revive LOCK_MAND.
>   sysctl: Support LOCK_MAND for read/write.
>   selftest: sysctl: Add test for flock(LOCK_MAND).
>   net: Introduce init2() for pernet_operations.
>   tcp: Clean up some functions.
>   tcp: Set NULL to sk->sk_prot->h.hashinfo.
>   tcp: Access &tcp_hashinfo via net.
>   tcp: Introduce optional per-netns ehash.
>   udp: Clean up some functions.
>   udp: Set NULL to sk->sk_prot->h.udp_table.
>   udp: Set NULL to udp_seq_afinfo.udp_table.
>   udp: Access &udp_table via net.
>   udp: Introduce optional per-netns hash table.
>
>  Documentation/networking/ip-sysctl.rst        |  40 +++++
>  .../chelsio/inline_crypto/chtls/chtls_cm.c    |   5 +-
>  .../mellanox/mlx5/core/en_accel/ktls_rx.c     |   5 +-
>  .../net/ethernet/netronome/nfp/crypto/tls.c   |   5 +-
>  fs/locks.c                                    |  83 ++++++---
>  fs/proc/proc_sysctl.c                         |  25 ++-
>  include/linux/fs.h                            |   1 +
>  include/net/inet_hashtables.h                 |  16 ++
>  include/net/net_namespace.h                   |   3 +
>  include/net/netns/ipv4.h                      |   4 +
>  include/uapi/asm-generic/fcntl.h              |   5 -
>  net/core/filter.c                             |   9 +-
>  net/core/net_namespace.c                      |  18 +-
>  net/dccp/proto.c                              |   2 +
>  net/ipv4/af_inet.c                            |   2 +-
>  net/ipv4/esp4.c                               |   3 +-
>  net/ipv4/inet_connection_sock.c               |  25 ++-
>  net/ipv4/inet_hashtables.c                    | 102 ++++++++---
>  net/ipv4/inet_timewait_sock.c                 |   4 +-
>  net/ipv4/netfilter/nf_socket_ipv4.c           |   2 +-
>  net/ipv4/netfilter/nf_tproxy_ipv4.c           |  17 +-
>  net/ipv4/sysctl_net_ipv4.c                    | 113 ++++++++++++
>  net/ipv4/tcp.c                                |   1 +
>  net/ipv4/tcp_diag.c                           |  18 +-
>  net/ipv4/tcp_ipv4.c                           | 122 +++++++++----
>  net/ipv4/tcp_minisocks.c                      |   2 +-
>  net/ipv4/udp.c                                | 164 ++++++++++++++----
>  net/ipv4/udp_diag.c                           |   6 +-
>  net/ipv4/udp_offload.c                        |   5 +-
>  net/ipv6/esp6.c                               |   3 +-
>  net/ipv6/inet6_hashtables.c                   |   4 +-
>  net/ipv6/netfilter/nf_socket_ipv6.c           |   2 +-
>  net/ipv6/netfilter/nf_tproxy_ipv6.c           |   5 +-
>  net/ipv6/tcp_ipv6.c                           |  30 +++-
>  net/ipv6/udp.c                                |  31 ++--
>  net/ipv6/udp_offload.c                        |   5 +-
>  net/mptcp/mptcp_diag.c                        |   7 +-
>  tools/testing/selftests/sysctl/.gitignore     |   2 +
>  tools/testing/selftests/sysctl/Makefile       |   9 +-
>  tools/testing/selftests/sysctl/sysctl_flock.c | 157 +++++++++++++++++
>  40 files changed, 854 insertions(+), 208 deletions(-)
>  create mode 100644 tools/testing/selftests/sysctl/.gitignore
>  create mode 100644 tools/testing/selftests/sysctl/sysctl_flock.c
>
> --
> 2.30.2
>
