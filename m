Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BB337FFC9
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 23:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhEMV2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 17:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhEMV2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 17:28:36 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF9BC061574;
        Thu, 13 May 2021 14:27:25 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id y2so36369830ybq.13;
        Thu, 13 May 2021 14:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rbTldncIG1R7Fujzu+SrZXcoHjUsC/NtSFciWQKO7BU=;
        b=NUEQjdh05U8yZ4SNtyD3y+Nb2N7XtToF3/W/KQ7ALwYV4BZcjlfY59BXp9U4Fn4PNw
         E/hdKSMeheU+KT78XmXqzBGkVybnh04t89qT2Q+g3sB19zZEZ7wPujBSXxU03UZZsD+p
         CIrpBJjLZrAJpyHjLHZFFqQk4QIU6Z+trZ5rDnSjhiwXdhh4t0tU6p7ZxZCb8nKqlQQ3
         Q2fJGncSbsmS4MevhzvrWXFJKLp2xtnWHsx+5/FKTOo+zWjSTlJa8KqNvg7nE4s/TzDg
         zabx+S+ZDSGA++TKlS1CtN6bLY5JsOsKZv7Q8cA5zpumBCsNUP+5E5dvAfnolRnP8nmu
         GZ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rbTldncIG1R7Fujzu+SrZXcoHjUsC/NtSFciWQKO7BU=;
        b=GQiBaxLxUOpjRC/Lf7K9cLN7HNKsahDhu6XY7YAXWHZJwFZ7iGnz/MLqJ3DJH6Wjum
         y8xbC3oZvsRY1p8oMEJlove50ATKm5n9aRX27rhoom4+jPh/OxwKDXJd5zVYKr8woX0J
         dVJG9uuzWDpnoRMC+/gywKANCXRgWpSIJ9BoaiVCZWKZXZkaALR7/W2WvNOH7e7OGQcB
         2qug4L3oxfuReomG6u9ge/eDresvv2Gc+jP/7bDJ7jQqSQdR5KyPyBF/Kt5WnDa1nJFl
         rjETKkOs8BiUgc4k9d9nlxZIqqVDksgFsYWDO3qBzUXkLlJmZfKWT6NT16sJXe7iNOFW
         X28w==
X-Gm-Message-State: AOAM530lHMD7zXkrL20bUmmUgdHdeheA0JTKVMzFJYFVqMjeyH66zMSF
        iNcEcQw4UCs070JTbWhdUwphDt3SL0lVBlU3u70=
X-Google-Smtp-Source: ABdhPJyhRlEerJPn3ZOQRpk/XGvXBcphdUae+i+F5u6QR+BlZpCGx4TYshKrGAxFkMuCS2xjpdhIJhy1btqGl+CJGr0=
X-Received: by 2002:a5b:f05:: with SMTP id x5mr14770712ybr.425.1620941244645;
 Thu, 13 May 2021 14:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210510034433.52818-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210510034433.52818-1-kuniyu@amazon.co.jp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 May 2021 14:27:13 -0700
Message-ID: <CAEf4BzYumt7BO1BgN8kLXZmbYXuJweH0bWiT-CiDRQfvaRg0kQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 9, 2021 at 8:45 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> The SO_REUSEPORT option allows sockets to listen on the same port and to
> accept connections evenly. However, there is a defect in the current
> implementation [1]. When a SYN packet is received, the connection is tied
> to a listening socket. Accordingly, when the listener is closed, in-flight
> requests during the three-way handshake and child sockets in the accept
> queue are dropped even if other listeners on the same port could accept
> such connections.
>
> This situation can happen when various server management tools restart
> server (such as nginx) processes. For instance, when we change nginx
> configurations and restart it, it spins up new workers that respect the new
> configuration and closes all listeners on the old workers, resulting in the
> in-flight ACK of 3WHS is responded by RST.
>
> To avoid such a situation, users have to know deeply how the kernel handles
> SYN packets and implement connection draining by eBPF [2]:
>
>   1. Stop routing SYN packets to the listener by eBPF.
>   2. Wait for all timers to expire to complete requests
>   3. Accept connections until EAGAIN, then close the listener.
>
>   or
>
>   1. Start counting SYN packets and accept syscalls using the eBPF map.
>   2. Stop routing SYN packets.
>   3. Accept connections up to the count, then close the listener.
>
> In either way, we cannot close a listener immediately. However, ideally,
> the application need not drain the not yet accepted sockets because 3WHS
> and tying a connection to a listener are just the kernel behaviour. The
> root cause is within the kernel, so the issue should be addressed in kernel
> space and should not be visible to user space. This patchset fixes it so
> that users need not take care of kernel implementation and connection
> draining. With this patchset, the kernel redistributes requests and
> connections from a listener to the others in the same reuseport group
> at/after close or shutdown syscalls.
>
> Although some software does connection draining, there are still merits in
> migration. For some security reasons, such as replacing TLS certificates,
> we may want to apply new settings as soon as possible and/or we may not be
> able to wait for connection draining. The sockets in the accept queue have
> not started application sessions yet. So, if we do not drain such sockets,
> they can be handled by the newer listeners and could have a longer
> lifetime. It is difficult to drain all connections in every case, but we
> can decrease such aborted connections by migration. In that sense,
> migration is always better than draining.
>
> Moreover, auto-migration simplifies user space logic and also works well in
> a case where we cannot modify and build a server program to implement the
> workaround.
>
> Note that the source and destination listeners MUST have the same settings
> at the socket API level; otherwise, applications may face inconsistency and
> cause errors. In such a case, we have to use the eBPF program to select a
> specific listener or to cancel migration.
>
> Special thanks to Martin KaFai Lau for bouncing ideas and exchanging code
> snippets along the way.
>
>
> Link:
>  [1] The SO_REUSEPORT socket option
>  https://lwn.net/Articles/542629/
>
>  [2] Re: [PATCH 1/1] net: Add SO_REUSEPORT_LISTEN_OFF socket option as drain mode
>  https://lore.kernel.org/netdev/1458828813.10868.65.camel@edumazet-glaptop3.roam.corp.google.com/
>
>
> Changelog:
>  v5:
>   * Move initializtion of sk_node from 6th to 5th patch
>   * Initialize sk_refcnt in reqsk_clone()
>   * Modify some definitions in reqsk_timer_handler()
>   * Validate in which path/state migration happens in selftest
>
>  v4:
>  https://lore.kernel.org/bpf/20210427034623.46528-1-kuniyu@amazon.co.jp/
>   * Make some functions and variables 'static' in selftest
>   * Remove 'scalability' from the cover letter
>
>  v3:
>  https://lore.kernel.org/bpf/20210420154140.80034-1-kuniyu@amazon.co.jp/
>   * Add sysctl back for reuseport_grow()
>   * Add helper functions to manage socks[]
>   * Separate migration related logic into functions: reuseport_resurrect(),
>     reuseport_stop_listen_sock(), reuseport_migrate_sock()
>   * Clone request_sock to be migrated
>   * Migrate request one by one
>   * Pass child socket to eBPF prog
>
>  v2:
>  https://lore.kernel.org/netdev/20201207132456.65472-1-kuniyu@amazon.co.jp/
>   * Do not save closed sockets in socks[]
>   * Revert 607904c357c61adf20b8fd18af765e501d61a385
>   * Extract inet_csk_reqsk_queue_migrate() into a single patch
>   * Change the spin_lock order to avoid lockdep warning
>   * Add static to __reuseport_select_sock
>   * Use refcount_inc_not_zero() in reuseport_select_migrated_sock()
>   * Set the default attach type in bpf_prog_load_check_attach()
>   * Define new proto of BPF_FUNC_get_socket_cookie
>   * Fix test to be compiled successfully
>   * Update commit messages
>
>  v1:
>  https://lore.kernel.org/netdev/20201201144418.35045-1-kuniyu@amazon.co.jp/
>   * Remove the sysctl option
>   * Enable migration if eBPF progam is not attached
>   * Add expected_attach_type to check if eBPF program can migrate sockets
>   * Add a field to tell migration type to eBPF program
>   * Support BPF_FUNC_get_socket_cookie to get the cookie of sk
>   * Allocate an empty skb if skb is NULL
>   * Pass req_to_sk(req)->sk_hash because listener's hash is zero
>   * Update commit messages and coverletter
>
>  RFC:
>  https://lore.kernel.org/netdev/20201117094023.3685-1-kuniyu@amazon.co.jp/
>
>
> Kuniyuki Iwashima (11):
>   net: Introduce net.ipv4.tcp_migrate_req.
>   tcp: Add num_closed_socks to struct sock_reuseport.
>   tcp: Keep TCP_CLOSE sockets in the reuseport group.
>   tcp: Add reuseport_migrate_sock() to select a new listener.
>   tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
>   tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.
>   tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.
>   bpf: Support BPF_FUNC_get_socket_cookie() for
>     BPF_PROG_TYPE_SK_REUSEPORT.
>   bpf: Support socket migration by eBPF.
>   libbpf: Set expected_attach_type for BPF_PROG_TYPE_SK_REUSEPORT.
>   bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
>
>  Documentation/networking/ip-sysctl.rst        |  20 +
>  include/linux/bpf.h                           |   1 +
>  include/linux/filter.h                        |   2 +
>  include/net/netns/ipv4.h                      |   1 +
>  include/net/request_sock.h                    |   2 +
>  include/net/sock_reuseport.h                  |   9 +-
>  include/uapi/linux/bpf.h                      |  16 +
>  kernel/bpf/syscall.c                          |  13 +
>  net/core/filter.c                             |  23 +-
>  net/core/request_sock.c                       |  39 ++
>  net/core/sock_reuseport.c                     | 337 +++++++++--
>  net/ipv4/inet_connection_sock.c               | 146 ++++-
>  net/ipv4/inet_hashtables.c                    |   2 +-
>  net/ipv4/sysctl_net_ipv4.c                    |   9 +
>  net/ipv4/tcp_ipv4.c                           |  20 +-
>  net/ipv6/tcp_ipv6.c                           |  14 +-
>  tools/include/uapi/linux/bpf.h                |  16 +
>  tools/lib/bpf/libbpf.c                        |   5 +-
>  tools/testing/selftests/bpf/network_helpers.c |   2 +-
>  tools/testing/selftests/bpf/network_helpers.h |   1 +
>  .../bpf/prog_tests/migrate_reuseport.c        | 532 ++++++++++++++++++
>  .../bpf/progs/test_migrate_reuseport.c        |  67 +++
>  22 files changed, 1217 insertions(+), 60 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
>
> --
> 2.30.2
>

One test is failing in CI ([0]), please take a look.

  [0] https://travis-ci.com/github/kernel-patches/bpf/builds/225784969
