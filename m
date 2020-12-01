Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460C12CA619
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391716AbgLAOpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:45:38 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:50785 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387462AbgLAOpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:45:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1606833937; x=1638369937;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ZNe33Ka7aH3VQjyzTKNc4gbH6nne2/ZozUBDYkDr+yU=;
  b=JrZUlqcedSBEN0v17KAFjs4dJDfUUedI3dvAn7tiODJ4K3t3Q8AyRVdQ
   nDLge5g/PMOzKDuVzIx+0jdzMN7RnAVIc2P0xAORDi58yPqg0fNwa+svm
   5Ka4bc4FJba1X9yjRkQweowq4AEK/pw5VVrnun2EfUaXXGbSl0/qLVFNB
   Q=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="92541785"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Dec 2020 14:44:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id CD9ADA1D7A;
        Tue,  1 Dec 2020 14:44:47 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:44:47 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:44:42 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Tue, 1 Dec 2020 23:44:07 +0900
Message-ID: <20201201144418.35045-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D36UWA004.ant.amazon.com (10.43.160.175) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SO_REUSEPORT option allows sockets to listen on the same port and to
accept connections evenly. However, there is a defect in the current
implementation[1]. When a SYN packet is received, the connection is tied to
a listening socket. Accordingly, when the listener is closed, in-flight
requests during the three-way handshake and child sockets in the accept
queue are dropped even if other listeners on the same port could accept
such connections.

This situation can happen when various server management tools restart
server (such as nginx) processes. For instance, when we change nginx
configurations and restart it, it spins up new workers that respect the new
configuration and closes all listeners on the old workers, resulting in the
in-flight ACK of 3WHS is responded by RST.

The SO_REUSEPORT option is excellent to improve scalability. On the other
hand, as a trade-off, users have to know deeply how the kernel handles SYN
packets and implement connection draining by eBPF[2]:

  1. Stop routing SYN packets to the listener by eBPF.
  2. Wait for all timers to expire to complete requests
  3. Accept connections until EAGAIN, then close the listener.
  
or

  1. Start counting SYN packets and accept syscalls using eBPF map.
  2. Stop routing SYN packets.
  3. Accept connections up to the count, then close the listener.

In either way, we cannot close a listener immediately. However, ideally,
the application need not drain the not yet accepted sockets because 3WHS
and tying a connection to a listener are just the kernel behaviour. The
root cause is within the kernel, so the issue should be addressed in kernel
space and should not be visible to user space. This patchset fixes it so
that users need not take care of kernel implementation and connection
draining. With this patchset, the kernel redistributes requests and
connections from a listener to others in the same reuseport group at/after
close() or shutdown() syscalls.

Although some software does connection draining, there are still merits in
migration. For some security reasons such as replacing TLS certificates, we
may want to apply new settings as soon as possible and/or we may not be
able to wait for connection draining. The sockets in the accept queue have
not started application sessions yet. So, if we do not drain such sockets,
they can be handled by the newer listeners and could have a longer
lifetime. It is difficult to drain all connections in every case, but we
can decrease such aborted connections by migration. In that sense,
migration is always better than draining. 

Moreover, auto-migration simplifies userspace logic and also works well in
a case where we cannot modify and build a server program to implement the
workaround.

Note that the source and destination listeners MUST have the same settings
at the socket API level; otherwise, applications may face inconsistency and
cause errors. In such a case, we have to use eBPF program to select a
specific listener or to cancel migration.


Link:

 [1] The SO_REUSEPORT socket option
 https://lwn.net/Articles/542629/

 [2] Re: [PATCH 1/1] net: Add SO_REUSEPORT_LISTEN_OFF socket option as drain mode
 https://lore.kernel.org/netdev/1458828813.10868.65.camel@edumazet-glaptop3.roam.corp.google.com/


Changelog:

 v1:
  * Remove the sysctl option
  * Enable migration if eBPF progam is not attached
  * Add expected_attach_type to check if eBPF program can migrate sockets
  * Add a field to tell migration type to eBPF program
  * Support BPF_FUNC_get_socket_cookie to get the cookie of sk
  * Allocate an empty skb if skb is NULL
  * Pass req_to_sk(req)->sk_hash because listener's hash is zero
  * Update commit messages and coverletter

 RFC v0:
 https://lore.kernel.org/netdev/20201117094023.3685-1-kuniyu@amazon.co.jp/


Kuniyuki Iwashima (11):
  tcp: Keep TCP_CLOSE sockets in the reuseport group.
  bpf: Define migration types for SO_REUSEPORT.
  tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
  tcp: Migrate TFO requests causing RST during TCP_SYN_RECV.
  tcp: Migrate TCP_NEW_SYN_RECV requests.
  bpf: Introduce two attach types for BPF_PROG_TYPE_SK_REUSEPORT.
  libbpf: Set expected_attach_type for BPF_PROG_TYPE_SK_REUSEPORT.
  bpf: Add migration to sk_reuseport_(kern|md).
  bpf: Support bpf_get_socket_cookie_sock() for
    BPF_PROG_TYPE_SK_REUSEPORT.
  bpf: Call bpf_run_sk_reuseport() for socket migration.
  bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.

 include/linux/bpf.h                           |   1 +
 include/linux/filter.h                        |   4 +-
 include/net/inet_connection_sock.h            |  13 ++
 include/net/request_sock.h                    |  13 ++
 include/net/sock_reuseport.h                  |  15 +-
 include/uapi/linux/bpf.h                      |  25 +++
 kernel/bpf/syscall.c                          |   8 +
 net/core/filter.c                             |  46 ++++-
 net/core/sock_reuseport.c                     | 128 +++++++++++---
 net/ipv4/inet_connection_sock.c               |  85 ++++++++-
 net/ipv4/inet_hashtables.c                    |   9 +-
 net/ipv4/tcp_ipv4.c                           |   9 +-
 net/ipv6/tcp_ipv6.c                           |   9 +-
 tools/include/uapi/linux/bpf.h                |  25 +++
 tools/lib/bpf/libbpf.c                        |   5 +-
 .../bpf/prog_tests/migrate_reuseport.c        | 164 ++++++++++++++++++
 .../bpf/progs/test_migrate_reuseport_kern.c   |  54 ++++++
 17 files changed, 565 insertions(+), 48 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c

-- 
2.17.2 (Apple Git-113)

