Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B145765EF
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiGORSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiGORSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:18:32 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7934F65597
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657905512; x=1689441512;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1yUBuBpeAczsd9qm0NY1ZtblYY5nDJmLSulZ3f29ZVo=;
  b=b3BcwLx7NIgpW2Xjp3pXf3ZrFxTuCHcgQaGCvZqDsc0Vm+pYGueQZNoR
   ZOqDmFoCMImcrKXH096wA5drRxoJ4UBOOqKulU/I/sbEg/FVgTH1V7z48
   LDmhY784tZJyNJFTD0YYCL50UOXezCcKBfd3Zu9qsa9NE6M3g8zNyTPn9
   s=;
X-IronPort-AV: E=Sophos;i="5.92,274,1650931200"; 
   d="scan'208";a="238838911"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 15 Jul 2022 17:18:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com (Postfix) with ESMTPS id 7E8FB4C00D2;
        Fri, 15 Jul 2022 17:18:17 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 15 Jul 2022 17:18:17 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 15 Jul 2022 17:18:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 00/15] sysctl: Fix data-races around ipv4_net_table (Round 3).
Date:   Fri, 15 Jul 2022 10:17:40 -0700
Message-ID: <20220715171755.38497-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.124]
X-ClientProxiedBy: EX13D31UWA003.ant.amazon.com (10.43.160.130) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes data-races around 21 knobs after
igmp_link_local_mcast_reports in ipv4_net_table.

These 4 knobs are skipped because they are safe.

  - tcp_congestion_control: Safe with RCU and xchg().
  - tcp_available_congestion_control: Read only.
  - tcp_allowed_congestion_control: Safe with RCU and spinlock().
  - tcp_fastopen_key: Safe with RCU and xchg()

So, round 4 will start with fib_multipath_use_neigh.


Kuniyuki Iwashima (15):
  igmp: Fix data-races around sysctl_igmp_llm_reports.
  igmp: Fix a data-race around sysctl_igmp_max_memberships.
  igmp: Fix data-races around sysctl_igmp_max_msf.
  igmp: Fix data-races around sysctl_igmp_qrv.
  tcp: Fix data-races around keepalive sysctl knobs.
  tcp: Fix data-races around sysctl_tcp_syn(ack)?_retries.
  tcp: Fix data-races around sysctl_tcp_syncookies.
  tcp: Fix data-races around sysctl_tcp_migrate_req.
  tcp: Fix data-races around sysctl_tcp_reordering.
  tcp: Fix data-races around some timeout sysctl knobs.
  tcp: Fix a data-race around sysctl_tcp_notsent_lowat.
  tcp: Fix a data-race around sysctl_tcp_tw_reuse.
  tcp: Fix data-races around sysctl_max_syn_backlog.
  tcp: Fix data-races around sysctl_tcp_fastopen.
  tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.

 drivers/net/amt.c               |  4 +--
 include/net/tcp.h               | 14 ++++++----
 net/core/filter.c               |  4 +--
 net/core/sock_reuseport.c       |  4 +--
 net/ipv4/af_inet.c              |  2 +-
 net/ipv4/igmp.c                 | 49 +++++++++++++++++++--------------
 net/ipv4/inet_connection_sock.c |  3 +-
 net/ipv4/ip_sockglue.c          |  6 ++--
 net/ipv4/syncookies.c           |  3 +-
 net/ipv4/tcp.c                  | 13 +++++----
 net/ipv4/tcp_fastopen.c         |  9 +++---
 net/ipv4/tcp_input.c            | 36 +++++++++++++++---------
 net/ipv4/tcp_ipv4.c             |  2 +-
 net/ipv4/tcp_metrics.c          |  3 +-
 net/ipv4/tcp_output.c           |  2 +-
 net/ipv4/tcp_timer.c            | 20 ++++++++------
 net/ipv6/syncookies.c           |  3 +-
 net/smc/smc_llc.c               |  2 +-
 18 files changed, 106 insertions(+), 73 deletions(-)

-- 
2.30.2

