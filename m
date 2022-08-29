Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2015A5174
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiH2QUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiH2QUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:20:12 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D429E13E0E
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 09:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661790004; x=1693326004;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JxBsmF3NfZ6ka+3LX+vyu7re0q5Yhx77CfbMk0kxX9o=;
  b=fL3J3UT64HIVe4WtxopBi2jKqULXA8U9LbWzaGSOF7FNM6XTRaaYL3Ow
   O6EjBHKoKhP91FmQoe/FviOWmLez3DJB0vgjGFR7y8pAF4+VKoqbOEeo9
   wuX1gsHtt3tLox5M2te6J+932QjwdtgRgeHZiJCR9mKq+TOGgBTBmpvJk
   g=;
X-IronPort-AV: E=Sophos;i="5.93,272,1654560000"; 
   d="scan'208";a="1049130367"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 16:19:41 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id 6887045043;
        Mon, 29 Aug 2022 16:19:41 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 29 Aug 2022 16:19:40 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.158) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 29 Aug 2022 16:19:38 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 0/5] tcp: Introduce optional per-netns ehash.
Date:   Mon, 29 Aug 2022 09:19:15 -0700
Message-ID: <20220829161920.99409-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.158]
X-ClientProxiedBy: EX13D02UWB002.ant.amazon.com (10.43.161.160) To
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

  patch 1 - 3: prep for per-netns ehash
  patch     4: small optimisation for netns dismantle without TIME_WAIT sockets
  patch     5: add per-netns ehash


Changes:
  v2:
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


Kuniyuki Iwashima (5):
  tcp: Clean up some functions.
  tcp: Set NULL to sk->sk_prot->h.hashinfo.
  tcp: Access &tcp_hashinfo via net.
  tcp: Save unnecessary inet_twsk_purge() calls.
  tcp: Introduce optional per-netns ehash.

 Documentation/networking/ip-sysctl.rst        |  22 ++++
 .../chelsio/inline_crypto/chtls/chtls_cm.c    |   5 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |   5 +-
 .../net/ethernet/netronome/nfp/crypto/tls.c   |   5 +-
 include/net/inet_hashtables.h                 |  16 +++
 include/net/netns/ipv4.h                      |   1 +
 include/net/tcp.h                             |   1 +
 net/core/filter.c                             |   5 +-
 net/dccp/proto.c                              |   2 +
 net/ipv4/af_inet.c                            |   2 +-
 net/ipv4/esp4.c                               |   3 +-
 net/ipv4/inet_connection_sock.c               |  22 ++--
 net/ipv4/inet_hashtables.c                    | 102 ++++++++++++----
 net/ipv4/inet_timewait_sock.c                 |   4 +-
 net/ipv4/netfilter/nf_socket_ipv4.c           |   2 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c           |  17 ++-
 net/ipv4/sysctl_net_ipv4.c                    |  58 +++++++++
 net/ipv4/tcp.c                                |   1 +
 net/ipv4/tcp_diag.c                           |  18 ++-
 net/ipv4/tcp_ipv4.c                           | 113 ++++++++++++------
 net/ipv4/tcp_minisocks.c                      |  31 ++++-
 net/ipv6/esp6.c                               |   3 +-
 net/ipv6/inet6_hashtables.c                   |   4 +-
 net/ipv6/netfilter/nf_socket_ipv6.c           |   2 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c           |   5 +-
 net/ipv6/tcp_ipv6.c                           |  20 ++--
 net/mptcp/mptcp_diag.c                        |   7 +-
 27 files changed, 362 insertions(+), 114 deletions(-)

-- 
2.30.2

