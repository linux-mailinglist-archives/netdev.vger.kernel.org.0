Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711EF2B5BE6
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgKQJlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:41:00 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:15068 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgKQJlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:41:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605606060; x=1637142060;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=Wca108g4Nk6XHkCSVKvOkGkT5Gv3I3upAbNqX3Q6J+c=;
  b=duJqciKhr8hB+ry3uZOtEeg1nffLpHd7sP5hK0voFblPXJEZoDQs3mnZ
   9zT5VTo5q9DJN1dUNbzESEFDDTPTlBaZhqN2dYLIl46wx6tz05hIWKe4P
   PSGM2IMzQ/L3qn5kGu2UGRc49v1F5yCiM9fLqxsaH6z5Ali74FxKkrdFI
   Q=;
X-IronPort-AV: E=Sophos;i="5.77,485,1596499200"; 
   d="scan'208";a="94821401"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 17 Nov 2020 09:40:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 13F03A1830;
        Tue, 17 Nov 2020 09:40:55 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:40:55 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.237) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:40:51 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH bpf-next 0/8] Socket migration for SO_REUSEPORT.
Date:   Tue, 17 Nov 2020 18:40:15 +0900
Message-ID: <20201117094023.3685-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SO_REUSEPORT option allows sockets to listen on the same port and to
accept connections evenly. However, there is a defect in the current
implementation. When a SYN packet is received, the connection is tied to a
listening socket. Accordingly, when the listener is closed, in-flight
requests during the three-way handshake and child sockets in the accept
queue are dropped even if other listeners could accept such connections.

This situation can happen when various server management tools restart
server (such as nginx) processes. For instance, when we change nginx
configurations and restart it, it spins up new workers that respect the new
configuration and closes all listeners on the old workers, resulting in
in-flight ACK of 3WHS is responded by RST.

As a workaround for this issue, we can do connection draining by eBPF:

  1. Before closing a listener, stop routing SYN packets to it.
  2. Wait enough time for requests to complete 3WHS.
  3. Accept connections until EAGAIN, then close the listener.

Although this approach seems to work well, EAGAIN has nothing to do with
how many requests are still during 3WHS. Thus, we have to know the number
of such requests by counting SYN packets by eBPF to complete connection
draining.

  1. Start counting SYN packets and accept syscalls using eBPF map.
  2. Stop routing SYN packets.
  3. Accept connections up to the count, then close the listener.

In cases that eBPF is used only for connection draining, it seems a bit
expensive. Moreover, there is some situation that we cannot modify and
build a server program to implement the workaround. This patchset
introduces a new sysctl option to free userland programs from the kernel
issue. If we enable net.ipv4.tcp_migrate_req before creating a reuseport
group, we can redistribute requests and connections from a listener to
others in the same reuseport group at close() or shutdown() syscalls.

Note that the source and destination listeners MUST have the same settings
at the socket API level; otherwise, applications may face inconsistency and
cause errors. In such a case, we have to use eBPF program to select a
specific listener or to cancel migration.

Kuniyuki Iwashima (8):
  net: Introduce net.ipv4.tcp_migrate_req.
  tcp: Keep TCP_CLOSE sockets in the reuseport group.
  tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
  tcp: Migrate TFO requests causing RST during TCP_SYN_RECV.
  tcp: Migrate TCP_NEW_SYN_RECV requests.
  bpf: Add cookie in sk_reuseport_md.
  bpf: Call bpf_run_sk_reuseport() for socket migration.
  bpf: Test BPF_PROG_TYPE_SK_REUSEPORT for socket migration.

 Documentation/networking/ip-sysctl.rst        |  15 ++
 include/linux/bpf.h                           |   1 +
 include/net/inet_connection_sock.h            |  13 ++
 include/net/netns/ipv4.h                      |   1 +
 include/net/request_sock.h                    |  13 ++
 include/net/sock_reuseport.h                  |   8 +-
 include/uapi/linux/bpf.h                      |   1 +
 net/core/filter.c                             |  34 +++-
 net/core/sock_reuseport.c                     | 110 +++++++++--
 net/ipv4/inet_connection_sock.c               |  84 ++++++++-
 net/ipv4/inet_hashtables.c                    |   9 +-
 net/ipv4/sysctl_net_ipv4.c                    |   9 +
 net/ipv4/tcp_ipv4.c                           |   9 +-
 net/ipv6/tcp_ipv6.c                           |   9 +-
 tools/include/uapi/linux/bpf.h                |   1 +
 .../bpf/prog_tests/migrate_reuseport.c        | 175 ++++++++++++++++++
 .../bpf/progs/test_migrate_reuseport_kern.c   |  53 ++++++
 17 files changed, 511 insertions(+), 34 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c

-- 
2.17.2 (Apple Git-113)

