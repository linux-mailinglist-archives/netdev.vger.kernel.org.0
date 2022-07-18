Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4316578853
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbiGRR1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235607AbiGRR1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:27:32 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DA92C665
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658165248; x=1689701248;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V8atTHNSGkmWCupz/QC8ll1fRjg2XD18ckTAYeE5G1E=;
  b=kykYqKEytdvN+O1VXefW7HDTWaTS4vKDHkWr1q6uBjEVUaHjBjwzPlrM
   P4DVXf2ylioGv0RTVww0cl2Efn9nQ/dNEtSKgmgXxgf1YRxgkCaU7StbB
   DcCqGnbn0g+bkubQ9Xq/rrlTVUWFiIuSakz9CH2jx2DGGd1Fo0EBoc/z2
   U=;
X-IronPort-AV: E=Sophos;i="5.92,281,1650931200"; 
   d="scan'208";a="1035320505"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 18 Jul 2022 17:27:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com (Postfix) with ESMTPS id 28685A284B;
        Mon, 18 Jul 2022 17:27:08 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 18 Jul 2022 17:27:07 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Mon, 18 Jul 2022 17:27:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 00/15] sysctl: Fix data-races around ipv4_net_table (Round 4).
Date:   Mon, 18 Jul 2022 10:26:38 -0700
Message-ID: <20220718172653.22111-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D04UWA004.ant.amazon.com (10.43.160.234) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes data-races around 17 knobs after fib_multipath_use_neigh
in ipv4_net_table.

tcp_fack was skipped because it's obsolete and there's no readers.

So, round 5 will start with tcp_dsack, 2 rounds left for 27 knobs.


Kuniyuki Iwashima (15):
  ipv4: Fix a data-race around sysctl_fib_multipath_use_neigh.
  ipv4: Fix data-races around sysctl_fib_multipath_hash_policy.
  ipv4: Fix data-races around sysctl_fib_multipath_hash_fields.
  ip: Fix data-races around sysctl_ip_prot_sock.
  udp: Fix a data-race around sysctl_udp_l3mdev_accept.
  tcp: Fix data-races around sysctl knobs related to SYN option.
  tcp: Fix a data-race around sysctl_tcp_early_retrans.
  tcp: Fix data-races around sysctl_tcp_recovery.
  tcp: Fix a data-race around sysctl_tcp_thin_linear_timeouts.
  tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.
  tcp: Fix a data-race around sysctl_tcp_retrans_collapse.
  tcp: Fix a data-race around sysctl_tcp_stdurg.
  tcp: Fix a data-race around sysctl_tcp_rfc1337.
  tcp: Fix a data-race around sysctl_tcp_abort_on_overflow.
  tcp: Fix data-races around sysctl_tcp_max_reordering.

 .../chelsio/inline_crypto/chtls/chtls_cm.c       |  6 +++---
 .../ethernet/mellanox/mlxsw/spectrum_router.c    |  4 ++--
 include/net/ip.h                                 |  2 +-
 include/net/tcp.h                                |  4 ++--
 include/net/udp.h                                |  2 +-
 net/core/secure_seq.c                            |  4 ++--
 net/ipv4/fib_semantics.c                         |  2 +-
 net/ipv4/route.c                                 |  8 ++++----
 net/ipv4/syncookies.c                            |  6 +++---
 net/ipv4/sysctl_net_ipv4.c                       |  6 +++---
 net/ipv4/tcp_input.c                             | 15 ++++++++-------
 net/ipv4/tcp_minisocks.c                         |  4 ++--
 net/ipv4/tcp_output.c                            | 16 ++++++++--------
 net/ipv4/tcp_recovery.c                          |  6 ++++--
 net/ipv4/tcp_timer.c                             |  2 +-
 15 files changed, 45 insertions(+), 42 deletions(-)

-- 
2.30.2

