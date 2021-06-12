Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAF73A4EAA
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 14:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhFLMe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 08:34:56 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:8435 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLMev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 08:34:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623501171; x=1655037171;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jpvwUP8q9X5zwxF28XApwhM5FHi9/s7g+xfvG6V0LP0=;
  b=Hc9Vps4r7hz04MoIHS+rnHWFo5ld5jmVNmrpn54sxLudFCqBJJg5h7CA
   XOcQmvxXKFeXX7YACtAjr/fJbn5YkKcn9MiG6Bj2WiwHmK5YoiGZmlLk2
   0NxdqPeQUg9dPR+4zQzTZk4UrGLOf7siUA6RTjPV7rXpRujF5JKyBupve
   I=;
X-IronPort-AV: E=Sophos;i="5.83,268,1616457600"; 
   d="scan'208";a="113874358"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-28209b7b.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 12 Jun 2021 12:32:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-28209b7b.us-east-1.amazon.com (Postfix) with ESMTPS id 16251E10CF;
        Sat, 12 Jun 2021 12:32:50 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:32:49 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:32:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Sat, 12 Jun 2021 21:32:13 +0900
Message-ID: <20210612123224.12525-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SO_REUSEPORT option allows sockets to listen on the same port and to
accept connections evenly. However, there is a defect in the current
implementation [1]. When a SYN packet is received, the connection is tied
to a listening socket. Accordingly, when the listener is closed, in-flight
requests during the three-way handshake and child sockets in the accept
queue are dropped even if other listeners on the same port could accept
such connections.

This situation can happen when various server management tools restart
server (such as nginx) processes. For instance, when we change nginx
configurations and restart it, it spins up new workers that respect the new
configuration and closes all listeners on the old workers, resulting in the
in-flight ACK of 3WHS is responded by RST.

To avoid such a situation, users have to know deeply how the kernel handles
SYN packets and implement connection draining by eBPF [2]:

  1. Stop routing SYN packets to the listener by eBPF.
  2. Wait for all timers to expire to complete requests
  3. Accept connections until EAGAIN, then close the listener.

  or

  1. Start counting SYN packets and accept syscalls using the eBPF map.
  2. Stop routing SYN packets.
  3. Accept connections up to the count, then close the listener.

In either way, we cannot close a listener immediately. However, ideally,
the application need not drain the not yet accepted sockets because 3WHS
and tying a connection to a listener are just the kernel behaviour. The
root cause is within the kernel, so the issue should be addressed in kernel
space and should not be visible to user space. This patchset fixes it so
that users need not take care of kernel implementation and connection
draining. With this patchset, the kernel redistributes requests and
connections from a listener to the others in the same reuseport group
at/after close or shutdown syscalls.

Although some software does connection draining, there are still merits in
migration. For some security reasons, such as replacing TLS certificates,
we may want to apply new settings as soon as possible and/or we may not be
able to wait for connection draining. The sockets in the accept queue have
not started application sessions yet. So, if we do not drain such sockets,
they can be handled by the newer listeners and could have a longer
lifetime. It is difficult to drain all connections in every case, but we
can decrease such aborted connections by migration. In that sense,
migration is always better than draining. 

Moreover, auto-migration simplifies user space logic and also works well in
a case where we cannot modify and build a server program to implement the
workaround.

Note that the source and destination listeners MUST have the same settings
at the socket API level; otherwise, applications may face inconsistency and
cause errors. In such a case, we have to use the eBPF program to select a
specific listener or to cancel migration.

Special thanks to Martin KaFai Lau for bouncing ideas and exchanging code
snippets along the way.


Link:
 [1] The SO_REUSEPORT socket option
 https://lwn.net/Articles/542629/

 [2] Re: [PATCH 1/1] net: Add SO_REUSEPORT_LISTEN_OFF socket option as drain mode
 https://lore.kernel.org/netdev/1458828813.10868.65.camel@edumazet-glaptop3.roam.corp.google.com/


Changelog:
 v8:
  * Make reuse const in reuseport_sock_index()
  * Don't use __reuseport_add_sock() in reuseport_alloc()
  * Change the arg of the second memcpy() in reuseport_grow()
  * Fix coding style to use goto in reuseport_alloc()
  * Keep sk_refcnt uninitialized in inet_reqsk_clone()
  * Initialize ireq_opt and ipv6_opt separately in reqsk_migrate_reset()

  [ This series does not include a stats patch suggested by Yuchung Cheng
    not to drop Acked-by/Reviewed-by tags and save reviewer's time. I will
    post the patch as a follow up after this series is merged. ]

 v7:
 https://lore.kernel.org/bpf/20210521182104.18273-1-kuniyu@amazon.co.jp/
  * Prevent attaching/detaching a bpf prog via shutdowned socket
  * Fix typo in commit messages
  * Split selftest into subtests

 v6:
 https://lore.kernel.org/bpf/20210517002258.75019-1-kuniyu@amazon.co.jp/
  * Change description in ip-sysctl.rst
  * Test IPPROTO_TCP before reading tfo_listener
  * Move reqsk_clone() to inet_connection_sock.c and rename to
    inet_reqsk_clone()
  * Pass req->rsk_listener to inet_csk_reqsk_queue_drop() and
    reqsk_queue_removed() in the migration path of receiving ACK
  * s/ARG_PTR_TO_SOCKET/PTR_TO_SOCKET/ in sk_reuseport_is_valid_access()
  * In selftest, use atomic ops to increment global vars, drop ACK by XDP,
    enable force fastopen, use "skel->bss" instead of "skel->data"

 v5:
 https://lore.kernel.org/bpf/20210510034433.52818-1-kuniyu@amazon.co.jp/
  * Move initializtion of sk_node from 6th to 5th patch
  * Initialize sk_refcnt in reqsk_clone()
  * Modify some definitions in reqsk_timer_handler()
  * Validate in which path/state migration happens in selftest

 v4:
 https://lore.kernel.org/bpf/20210427034623.46528-1-kuniyu@amazon.co.jp/
  * Make some functions and variables 'static' in selftest
  * Remove 'scalability' from the cover letter

 v3:
 https://lore.kernel.org/bpf/20210420154140.80034-1-kuniyu@amazon.co.jp/
  * Add sysctl back for reuseport_grow()
  * Add helper functions to manage socks[]
  * Separate migration related logic into functions: reuseport_resurrect(),
    reuseport_stop_listen_sock(), reuseport_migrate_sock()
  * Clone request_sock to be migrated
  * Migrate request one by one
  * Pass child socket to eBPF prog

 v2:
 https://lore.kernel.org/netdev/20201207132456.65472-1-kuniyu@amazon.co.jp/
  * Do not save closed sockets in socks[]
  * Revert 607904c357c61adf20b8fd18af765e501d61a385
  * Extract inet_csk_reqsk_queue_migrate() into a single patch
  * Change the spin_lock order to avoid lockdep warning
  * Add static to __reuseport_select_sock
  * Use refcount_inc_not_zero() in reuseport_select_migrated_sock()
  * Set the default attach type in bpf_prog_load_check_attach()
  * Define new proto of BPF_FUNC_get_socket_cookie
  * Fix test to be compiled successfully
  * Update commit messages

 v1:
 https://lore.kernel.org/netdev/20201201144418.35045-1-kuniyu@amazon.co.jp/
  * Remove the sysctl option
  * Enable migration if eBPF progam is not attached
  * Add expected_attach_type to check if eBPF program can migrate sockets
  * Add a field to tell migration type to eBPF program
  * Support BPF_FUNC_get_socket_cookie to get the cookie of sk
  * Allocate an empty skb if skb is NULL
  * Pass req_to_sk(req)->sk_hash because listener's hash is zero
  * Update commit messages and coverletter

 RFC:
 https://lore.kernel.org/netdev/20201117094023.3685-1-kuniyu@amazon.co.jp/


Kuniyuki Iwashima (11):
  net: Introduce net.ipv4.tcp_migrate_req.
  tcp: Add num_closed_socks to struct sock_reuseport.
  tcp: Keep TCP_CLOSE sockets in the reuseport group.
  tcp: Add reuseport_migrate_sock() to select a new listener.
  tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
  tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.
  tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.
  bpf: Support BPF_FUNC_get_socket_cookie() for
    BPF_PROG_TYPE_SK_REUSEPORT.
  bpf: Support socket migration by eBPF.
  libbpf: Set expected_attach_type for BPF_PROG_TYPE_SK_REUSEPORT.
  bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.

 Documentation/networking/ip-sysctl.rst        |  25 +
 include/linux/bpf.h                           |   1 +
 include/linux/filter.h                        |   2 +
 include/net/netns/ipv4.h                      |   1 +
 include/net/sock_reuseport.h                  |   9 +-
 include/uapi/linux/bpf.h                      |  16 +
 kernel/bpf/syscall.c                          |  13 +
 net/core/filter.c                             |  23 +-
 net/core/sock_reuseport.c                     | 359 +++++++++--
 net/ipv4/inet_connection_sock.c               | 191 +++++-
 net/ipv4/inet_hashtables.c                    |   2 +-
 net/ipv4/sysctl_net_ipv4.c                    |   9 +
 net/ipv4/tcp_ipv4.c                           |  20 +-
 net/ipv4/tcp_minisocks.c                      |   4 +-
 net/ipv6/tcp_ipv6.c                           |  14 +-
 tools/include/uapi/linux/bpf.h                |  16 +
 tools/lib/bpf/libbpf.c                        |   5 +-
 tools/testing/selftests/bpf/network_helpers.c |   2 +-
 tools/testing/selftests/bpf/network_helpers.h |   1 +
 .../bpf/prog_tests/migrate_reuseport.c        | 555 ++++++++++++++++++
 .../bpf/progs/test_migrate_reuseport.c        | 135 +++++
 21 files changed, 1335 insertions(+), 68 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport.c

-- 
2.30.2

