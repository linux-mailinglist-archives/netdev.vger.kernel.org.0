Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFA7570EC9
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiGLAR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiGLARl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:17:41 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144798BA8D;
        Mon, 11 Jul 2022 17:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657584980; x=1689120980;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S3ejaRnW01VNLQ/1XovIQoxZMXojlYmfQp9xaPV993w=;
  b=PnDvPDYqchUiX/qL7o3lmtpjLl/FHf33R+WKZTSdCaMjm8Dk7HubA2p8
   nBQfzmzJ9IXFzxLcJZfxQMgp06f29DqYXwUxvDiQd9Wyr+0ORpEa5r/X3
   v52uMbnBoO7tEqLq55YMJdRnCXq2NtoM8utVhd3jPQC+rLwLuA/m7xWcX
   Y=;
X-IronPort-AV: E=Sophos;i="5.92,264,1650931200"; 
   d="scan'208";a="107193599"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-7d84505d.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 12 Jul 2022 00:16:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-7d84505d.us-west-2.amazon.com (Postfix) with ESMTPS id 855D695C24;
        Tue, 12 Jul 2022 00:16:03 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 00:16:02 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.185) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 00:15:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 net 00/15] sysctl: Fix data-races around ipv4_net_table (Round 1).
Date:   Mon, 11 Jul 2022 17:15:18 -0700
Message-ID: <20220712001533.89927-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.161.185]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes data-races around the first 13 knobs and
nexthop_compat_mode in ipv4_net_table.

I will post another patch for three early_demux knobs later,
so the next round will start from ip_default_ttl.


Kuniyuki Iwashima (15):
  sysctl: Fix data-races in proc_dou8vec_minmax().
  sysctl: Fix data-races in proc_dointvec_ms_jiffies().
  tcp: Fix a data-race around sysctl_max_tw_buckets.
  icmp: Fix a data-race around sysctl_icmp_echo_ignore_all.
  icmp: Fix data-races around sysctl_icmp_echo_enable_probe.
  icmp: Fix a data-race around sysctl_icmp_echo_ignore_broadcasts.
  icmp: Fix a data-race around sysctl_icmp_ignore_bogus_error_responses.
  icmp: Fix a data-race around sysctl_icmp_errors_use_inbound_ifaddr.
  icmp: Fix a data-race around sysctl_icmp_ratelimit.
  icmp: Fix a data-race around sysctl_icmp_ratemask.
  raw: Fix a data-race around sysctl_raw_l3mdev_accept.
  tcp: Fix data-races around sysctl_tcp_ecn.
  tcp: Fix a data-race around sysctl_tcp_ecn_fallback.
  ipv4: Fix data-races around sysctl_ip_dynaddr.
  nexthop: Fix data-races around nexthop_compat_mode.

 Documentation/networking/ip-sysctl.rst            |  2 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c        |  2 +-
 include/net/raw.h                                 |  2 +-
 kernel/sysctl.c                                   | 12 ++++++------
 net/ipv4/af_inet.c                                |  4 ++--
 net/ipv4/fib_semantics.c                          |  2 +-
 net/ipv4/icmp.c                                   | 15 ++++++++-------
 net/ipv4/inet_timewait_sock.c                     |  3 ++-
 net/ipv4/nexthop.c                                |  5 +++--
 net/ipv4/syncookies.c                             |  2 +-
 net/ipv4/sysctl_net_ipv4.c                        | 12 ++++++++++++
 net/ipv4/tcp_input.c                              |  2 +-
 net/ipv4/tcp_output.c                             |  4 ++--
 net/ipv6/icmp.c                                   |  2 +-
 net/ipv6/route.c                                  |  2 +-
 15 files changed, 43 insertions(+), 28 deletions(-)

-- 
2.30.2

