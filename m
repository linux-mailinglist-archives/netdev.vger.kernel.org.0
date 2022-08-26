Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3E95A1D78
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243507AbiHZAFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiHZAFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:05:50 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FEFC3F7A;
        Thu, 25 Aug 2022 17:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661472350; x=1693008350;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qT15d4/7lkCIu717lT5uGwSWvWqLZZ3slaU+ViX8FjA=;
  b=vxT6BDcVUD3WCUSQIzTldHRgwCHPhe+iR4LcGzEaFsGJE+IWJC7S7SLH
   fhVE0k900X8dzg89uGFDDRqUI4sWnmzWfoXflDUwmMB5jODX/Kxq4DEDj
   g+ST4S836haNPiUBvNq5xOueuub9MLwVSJvHWGMPhCzlWL/GtdR+o6UTG
   g=;
X-IronPort-AV: E=Sophos;i="5.93,264,1654560000"; 
   d="scan'208";a="237588409"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 00:05:35 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com (Postfix) with ESMTPS id 2378D45260;
        Fri, 26 Aug 2022 00:05:33 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 00:05:32 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 00:05:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v1 net-next 00/13] tcp/udp: Introduce optional per-netns hash table.
Date:   Thu, 25 Aug 2022 17:04:32 -0700
Message-ID: <20220826000445.46552-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
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

The more sockets we have in the hash table, the more time we spend
looking up the socket.  While running a number of small workloads on
the same host, they penalise each other and cause performance degradation.

Also, the root cause might be a single workload that consumes much more
resources than the others.  It often happens on a cloud service where
different workloads share the same computing resource.

On EC2 c5.24xlarge instance (196 GiB memory and 524288 (1Mi / 2) ehash
entries), after running iperf3 in different netns, creating 24Mi sockets
without data transfer in the root netns causes about 10% performance
regression for the iperf3's connection.

 thash_entries		sockets		length		Gbps
	524288		      1		     1		50.7
			   24Mi		    48		45.1

It is basically related to the length of the list of each hash bucket.
For testing purposes to see how performance drops along the length,
I set 131072 (1Mi / 8) to thash_entries, and here's the result.

 thash_entries		sockets		length		Gbps
        131072		      1		     1		50.7
			    1Mi		     8		49.9
			    2Mi		    16		48.9
			    4Mi		    32		47.3
			    8Mi		    64		44.6
			   16Mi		   128		40.6
			   24Mi		   192		36.3
			   32Mi		   256		32.5
			   40Mi		   320		27.0
			   48Mi		   384		25.0

To resolve the socket lookup degradation, we introduce an optional
per-netns hash table for TCP and UDP.  With a smaller hash table, we
can look up sockets faster and isolate noisy neighbours.  Also, we can
reduce lock contention.

We can control and check the hash size via sysctl knobs.  It requires
some tuning based on workloads, so the per-netns hash table is disabled
by default.

  # dmesg | cut -d ' ' -f 5- | grep "established hash"
  TCP established hash table entries: 524288 (order: 10, 4194304 bytes, vmalloc hugepage)

  # sysctl net.ipv4.tcp_ehash_entries
  net.ipv4.tcp_ehash_entries = 524288  # can be changed by thash_entries

  # sysctl net.ipv4.tcp_child_ehash_entries
  net.ipv4.tcp_child_ehash_entries = 0  # disabled by default

  # ip netns add test1
  # ip netns exec test1 sysctl net.ipv4.tcp_ehash_entries
  net.ipv4.tcp_ehash_entries = -524288  # share the global ehash

  # sysctl -w net.ipv4.tcp_child_ehash_entries=100
  net.ipv4.tcp_child_ehash_entries = 100

  # sysctl net.ipv4.tcp_child_ehash_entries
  net.ipv4.tcp_child_ehash_entries = 128  # rounded up to 2^n

  # ip netns add test2
  # ip netns exec test2 sysctl net.ipv4.tcp_ehash_entries
  net.ipv4.tcp_ehash_entries = 128  # own per-netns ehash

  [ UDP has the same interface as udp_hash_entries and
    udp_child_hash_entries. ]

When creating per-netns concurrently with different sizes, we can
guarantee the size by doing one of these ways.

  1) Share the global hash table and create per-netns one

  First, unshare() with tcp_child_ehash_entries==0.  It creates dedicated
  netns sysctl knobs where we can safely change tcp_child_ehash_entries
  and clone()/unshare() to create a per-netns hash table.

  2) Lock the sysctl knob

  We can use flock(LOCK_MAND) or BPF_PROG_TYPE_CGROUP_SYSCTL to allow/deny
  read/write on sysctl knobs.

For details, please see each patch.

  patch  1 -  3: mandatory lock support for sysctl (fs stuff)
  patch  4 -  7: prep patch for per-netns TCP ehash
  patch       8: add per-netns TCP ehash
  patch  9 - 12: prep patch for per-netns UDP hash table
  patch      13: add per-netns UDP hash table


Kuniyuki Iwashima (13):
  fs/lock: Revive LOCK_MAND.
  sysctl: Support LOCK_MAND for read/write.
  selftest: sysctl: Add test for flock(LOCK_MAND).
  net: Introduce init2() for pernet_operations.
  tcp: Clean up some functions.
  tcp: Set NULL to sk->sk_prot->h.hashinfo.
  tcp: Access &tcp_hashinfo via net.
  tcp: Introduce optional per-netns ehash.
  udp: Clean up some functions.
  udp: Set NULL to sk->sk_prot->h.udp_table.
  udp: Set NULL to udp_seq_afinfo.udp_table.
  udp: Access &udp_table via net.
  udp: Introduce optional per-netns hash table.

 Documentation/networking/ip-sysctl.rst        |  40 +++++
 .../chelsio/inline_crypto/chtls/chtls_cm.c    |   5 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |   5 +-
 .../net/ethernet/netronome/nfp/crypto/tls.c   |   5 +-
 fs/locks.c                                    |  83 ++++++---
 fs/proc/proc_sysctl.c                         |  25 ++-
 include/linux/fs.h                            |   1 +
 include/net/inet_hashtables.h                 |  16 ++
 include/net/net_namespace.h                   |   3 +
 include/net/netns/ipv4.h                      |   4 +
 include/uapi/asm-generic/fcntl.h              |   5 -
 net/core/filter.c                             |   9 +-
 net/core/net_namespace.c                      |  18 +-
 net/dccp/proto.c                              |   2 +
 net/ipv4/af_inet.c                            |   2 +-
 net/ipv4/esp4.c                               |   3 +-
 net/ipv4/inet_connection_sock.c               |  25 ++-
 net/ipv4/inet_hashtables.c                    | 102 ++++++++---
 net/ipv4/inet_timewait_sock.c                 |   4 +-
 net/ipv4/netfilter/nf_socket_ipv4.c           |   2 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c           |  17 +-
 net/ipv4/sysctl_net_ipv4.c                    | 113 ++++++++++++
 net/ipv4/tcp.c                                |   1 +
 net/ipv4/tcp_diag.c                           |  18 +-
 net/ipv4/tcp_ipv4.c                           | 122 +++++++++----
 net/ipv4/tcp_minisocks.c                      |   2 +-
 net/ipv4/udp.c                                | 164 ++++++++++++++----
 net/ipv4/udp_diag.c                           |   6 +-
 net/ipv4/udp_offload.c                        |   5 +-
 net/ipv6/esp6.c                               |   3 +-
 net/ipv6/inet6_hashtables.c                   |   4 +-
 net/ipv6/netfilter/nf_socket_ipv6.c           |   2 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c           |   5 +-
 net/ipv6/tcp_ipv6.c                           |  30 +++-
 net/ipv6/udp.c                                |  31 ++--
 net/ipv6/udp_offload.c                        |   5 +-
 net/mptcp/mptcp_diag.c                        |   7 +-
 tools/testing/selftests/sysctl/.gitignore     |   2 +
 tools/testing/selftests/sysctl/Makefile       |   9 +-
 tools/testing/selftests/sysctl/sysctl_flock.c | 157 +++++++++++++++++
 40 files changed, 854 insertions(+), 208 deletions(-)
 create mode 100644 tools/testing/selftests/sysctl/.gitignore
 create mode 100644 tools/testing/selftests/sysctl/sysctl_flock.c

-- 
2.30.2

