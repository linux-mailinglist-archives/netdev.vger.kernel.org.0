Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C598036D272
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 08:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhD1Gwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 02:52:30 -0400
Received: from relay.sw.ru ([185.231.240.75]:47978 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235862AbhD1Gw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 02:52:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=KTD35s/nHfCSk6/PgPqfKYIfKq0x8DQzazWEXJN1KRo=; b=rXUBgfHT8MgnGqt3WCc
        Kqvw4geSxc9qALHae2pUgRznRB3nXe7wQqNaZwYpMsKAseG55UbmdbSFV66vQDQB0Rd1b5PQceQJJ
        PNMHoQwWgB+Ao5ap32YKhH9RF+TR8iNDCK5dYTisrqfd8FWu1ohhen2OA9vd+k7yl46yt9XbqCU=
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lbe2l-001Vi5-VS; Wed, 28 Apr 2021 09:51:31 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v4 00/16] memcg accounting from OpenVZ
To:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jiri Slaby <jirislaby@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serge@hallyn.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zefan Li <lizefan.x@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
Message-ID: <919bd022-075e-98a7-cefb-89b5dee80ae8@virtuozzo.com>
Date:   Wed, 28 Apr 2021 09:51:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OpenVZ uses memory accounting 20+ years since v2.2.x linux kernels. 
Initially we used our own accounting subsystem, then partially committed
it to upstream, and a few years ago switched to cgroups v1.
Now we're rebasing again, revising our old patches and trying to push
them upstream.

We try to protect the host system from any misuse of kernel memory 
allocation triggered by untrusted users inside the containers.

Patch-set is addressed mostly to cgroups maintainers and cgroups@ mailing
list, though I would be very grateful for any comments from maintainersi
of affected subsystems or other people added in cc:

Compared to the upstream, we additionally account the following kernel objects:
- network devices and its Tx/Rx queues
- ipv4/v6 addresses and routing-related objects
- inet_bind_bucket cache objects
- VLAN group arrays
- ipv6/sit: ip_tunnel_prl
- scm_fp_list objects used by SCM_RIGHTS messages of Unix sockets 
- nsproxy and namespace objects itself
- IPC objects: semaphores, message queues and share memory segments
- mounts
- pollfd and select bits arrays
- signals and posix timers
- file lock
- fasync_struct used by the file lease code and driver's fasync queues 
- tty objects
- per-mm LDT

We have an incorrect/incomplete/obsoleted accounting for few other kernel
objects: sk_filter, af_packets, netlink and xt_counters for iptables.
They require rework and probably will be dropped at all.

Also we're going to add an accounting for nft, however it is not ready yet.

We have not tested performance on upstream, however, our performance team
compares our current RHEL7-based production kernel and reports that
they are at least not worse as the according original RHEL7 kernel.

v4:
- improved description for tty patch
- minor cleanup in LDT patch
- rebased to v5.12
- resent to lkml@

v3:
- added new patches for other kind of accounted objects
- combined patches for ip address/routing-related objects
- improved description
- re-ordered and rebased for linux 5.12-rc8

v2:
- squashed old patch 1 "accounting for allocations called with disabled BH"
   with old patch 2 "accounting for fib6_nodes cache" used such kind of memory allocation 
- improved patch description
- subsystem maintainers added to cc:

Vasily Averin (16):
  memcg: enable accounting for net_device and Tx/Rx queues
  memcg: enable accounting for IP address and routing-related objects
  memcg: enable accounting for inet_bin_bucket cache
  memcg: enable accounting for VLAN group array
  memcg: ipv6/sit: account and don't WARN on ip_tunnel_prl structs
    allocation
  memcg: enable accounting for scm_fp_list objects
  memcg: enable accounting for new namesapces and struct nsproxy
  memcg: enable accounting of ipc resources
  memcg: enable accounting for mnt_cache entries
  memcg: enable accounting for pollfd and select bits arrays
  memcg: enable accounting for signals
  memcg: enable accounting for posix_timers_cache slab
  memcg: enable accounting for file lock caches
  memcg: enable accounting for fasync_cache
  memcg: enable accounting for tty-related objects
  memcg: enable accounting for ldt_struct objects

 arch/x86/kernel/ldt.c      |  6 +++---
 drivers/tty/tty_io.c       |  4 ++--
 fs/fcntl.c                 |  3 ++-
 fs/locks.c                 |  6 ++++--
 fs/namespace.c             |  7 ++++---
 fs/select.c                |  4 ++--
 ipc/msg.c                  |  2 +-
 ipc/namespace.c            |  2 +-
 ipc/sem.c                  | 10 ++++++----
 ipc/shm.c                  |  2 +-
 kernel/cgroup/namespace.c  |  2 +-
 kernel/nsproxy.c           |  2 +-
 kernel/pid_namespace.c     |  2 +-
 kernel/signal.c            |  2 +-
 kernel/time/namespace.c    |  4 ++--
 kernel/time/posix-timers.c |  4 ++--
 kernel/user_namespace.c    |  2 +-
 mm/memcontrol.c            |  2 +-
 net/8021q/vlan.c           |  2 +-
 net/core/dev.c             |  6 +++---
 net/core/fib_rules.c       |  4 ++--
 net/core/scm.c             |  4 ++--
 net/dccp/proto.c           |  2 +-
 net/ipv4/devinet.c         |  2 +-
 net/ipv4/fib_trie.c        |  4 ++--
 net/ipv4/tcp.c             |  4 +++-
 net/ipv6/addrconf.c        |  2 +-
 net/ipv6/ip6_fib.c         |  4 ++--
 net/ipv6/route.c           |  2 +-
 net/ipv6/sit.c             |  5 +++--
 30 files changed, 58 insertions(+), 49 deletions(-)

-- 
1.8.3.1

