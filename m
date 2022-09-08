Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC8E5B11E1
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 03:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiIHBLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 21:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiIHBLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 21:11:02 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40722AC272
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 18:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662599460; x=1694135460;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0BOvLkWstnCBOKf/xbeBOMTmu437LOwXIwd3pUEQyBE=;
  b=SHY0GSuuK3LMgnMyKjAVSTO7xoGnOmkKyLCcR/ch1L8A6MUib7TYirM2
   dSshZrA8xNwqe3jlcSfh2fZCfnodX3ZZbHOBWDUmxUOeDmdWpRv6IlCgf
   Zv6NxrrbWULgPSzqgoAOe1xnSY88rSvJuz+UYN9hDSOyggwsJo/c2d80h
   g=;
X-IronPort-AV: E=Sophos;i="5.93,298,1654560000"; 
   d="scan'208";a="127861490"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 01:10:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com (Postfix) with ESMTPS id 7A90FE0966;
        Thu,  8 Sep 2022 01:10:44 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 8 Sep 2022 01:10:42 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 8 Sep 2022 01:10:40 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v6 net-next 0/6] tcp: Introduce optional per-netns ehash.
Date:   Wed, 7 Sep 2022 18:10:16 -0700
Message-ID: <20220908011022.45342-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D05UWC002.ant.amazon.com (10.43.162.92) To
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

The more sockets we have in the hash table, the longer we spend looking
up the socket.  While running a number of small workloads on the same
host, they penalise each other and cause performance degradation.

The root cause might be a single workload that consumes much more
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
per-netns hash table for TCP, but it's just ehash, and we still share
the global bhash, bhash2 and lhash2.

With a smaller ehash, we can look up non-listener sockets faster and
isolate such noisy neighbours.  Also, we can reduce lock contention.

For details, please see the last patch.

  patch 1 - 4: prep for per-netns ehash
  patch     5: small optimisation for netns dismantle without TIME_WAIT sockets
  patch     6: add per-netns ehash

Many thanks to Eric Dumazet for reviewing and advising.


Changes:
  v6:
    * Patch 6
      * Use vmalloc_huge() in inet_pernet_hashinfo_alloc() and
        update the changelog and doc about NUMA (Eric Dumazet)
      * Use kmemdup() in inet_pernet_hashinfo_alloc() (Eric Dumazet)
      * Use vfree() in inet_pernet_hashinfo_(alloc|free)()

  v5: https://lore.kernel.org/netdev/20220907005534.72876-1-kuniyu@amazon.com/
    * Patch 2
      * Keep the tw_refcount base value at 1 (Eric Dumazet)
      * Add WARN_ON_ONCE() for tw_refcount (Eric Dumazet)
    * Patch 5
      * Test tw_refcount against 1 in tcp_twsk_purge()

  v4: https://lore.kernel.org/netdev/20220906162423.44410-1-kuniyu@amazon.com/
    * Add Patch 2
    * Patch 1
      * Add cleanups in tcp_time_wait() and  tcp_v[46]_connect()
    * Patch 3
      * /tcp_death_row/s/->/./
    * Patch 4
      * Add mellanox and netronome driver changes back (Paolo Abeni, Jakub Kicinski)
      * /tcp_death_row/s/->/./
    * Patch 5
      * Simplify tcp_twsk_purge()
    * Patch 6
      * Move inet_pernet_hashinfo_free() into tcp_sk_exit_batch()

  v3: https://lore.kernel.org/netdev/20220830191518.77083-1-kuniyu@amazon.com/
    * Patch 3
      * Drop mellanox and netronome driver changes (Eric Dumazet)
    * Patch 4
      * Add test results in the changelog
    * Patch 5
      * Use roundup_pow_of_two() in tcp_set_hashinfo() (Eric Dumazet)
      * Remove proc_tcp_child_ehash_entries() and use proc_douintvec_minmax()

  v2: https://lore.kernel.org/netdev/20220829161920.99409-1-kuniyu@amazon.com/
    * Drop flock() and UDP stuff
    * Patch 2
      * Rename inet_get_hashinfo() to tcp_or_dccp_get_hashinfo() (Eric Dumazet)
    * Patch 4
      * Remove unnecessary inet_twsk_purge() calls for unshare()
      * Factorise inet_twsk_purge() calls (Eric Dumazet)
    * Patch 5
      * Change max buckets size as 16Mi
      * Use unsigned int for ehash size (Eric Dumazet)
      * Use GFP_KERNEL_ACCOUNT for the per-netns ehash allocation (Eric Dumazet)
      * Use current->nsproxy->net_ns for parent netns (Eric Dumazet)

  v1: https://lore.kernel.org/netdev/20220826000445.46552-1-kuniyu@amazon.com/


Kuniyuki Iwashima (6):
  tcp: Clean up some functions.
  tcp: Don't allocate tcp_death_row outside of struct netns_ipv4.
  tcp: Set NULL to sk->sk_prot->h.hashinfo.
  tcp: Access &tcp_hashinfo via net.
  tcp: Save unnecessary inet_twsk_purge() calls.
  tcp: Introduce optional per-netns ehash.

 Documentation/networking/ip-sysctl.rst        |  29 ++++
 .../chelsio/inline_crypto/chtls/chtls_cm.c    |   5 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |   5 +-
 .../net/ethernet/netronome/nfp/crypto/tls.c   |   5 +-
 include/net/inet_hashtables.h                 |  16 ++
 include/net/netns/ipv4.h                      |   4 +-
 include/net/tcp.h                             |   1 +
 net/core/filter.c                             |   5 +-
 net/dccp/proto.c                              |   2 +
 net/ipv4/af_inet.c                            |   2 +-
 net/ipv4/esp4.c                               |   3 +-
 net/ipv4/inet_connection_sock.c               |  22 ++-
 net/ipv4/inet_hashtables.c                    |  92 ++++++++---
 net/ipv4/inet_timewait_sock.c                 |   4 +-
 net/ipv4/netfilter/nf_socket_ipv4.c           |   4 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c           |  16 +-
 net/ipv4/proc.c                               |   2 +-
 net/ipv4/sysctl_net_ipv4.c                    |  47 +++++-
 net/ipv4/tcp.c                                |   1 +
 net/ipv4/tcp_diag.c                           |  18 ++-
 net/ipv4/tcp_ipv4.c                           | 143 +++++++++++-------
 net/ipv4/tcp_minisocks.c                      |  28 +++-
 net/ipv6/esp6.c                               |   3 +-
 net/ipv6/inet6_hashtables.c                   |   4 +-
 net/ipv6/netfilter/nf_socket_ipv6.c           |   4 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c           |   8 +-
 net/ipv6/tcp_ipv6.c                           |  42 ++---
 net/mptcp/mptcp_diag.c                        |   7 +-
 28 files changed, 361 insertions(+), 161 deletions(-)

-- 
2.30.2

