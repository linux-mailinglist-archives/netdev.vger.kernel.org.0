Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276DA57E669
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiGVSXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiGVSXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:23:00 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C1D528BF
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658514180; x=1690050180;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n+EbwSy/WcKpJwlkw0Pqij54EYFwmja2iFPdXnQOkrE=;
  b=XJCV8uMxdHu2ef2hx9RhhXBoaEUd0mUhkYpZB2Gxp3QRCAfYnwyGddG4
   LUAjQgrHPqULJj9Lxuf8/m77PjjfDgQcAfo6QJOInSpmWhjpf3ExKFVpl
   SQKnEK3463vHtQ3k8mb/1ZMALXbATDN6DZZjGMY2TQzcTHMfmNAtLWZbF
   c=;
X-IronPort-AV: E=Sophos;i="5.93,186,1654560000"; 
   d="scan'208";a="212296951"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 22 Jul 2022 18:22:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com (Postfix) with ESMTPS id 297E2441D7;
        Fri, 22 Jul 2022 18:22:43 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 22 Jul 2022 18:22:42 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 22 Jul 2022 18:22:40 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 0/7] sysctl: Fix data-races around ipv4_net_table (Round 6, Final).
Date:   Fri, 22 Jul 2022 11:21:58 -0700
Message-ID: <20220722182205.96838-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D13UWB004.ant.amazon.com (10.43.161.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes data-races around 11 knobs after tcp_pacing_ss_ratio
ipv4_net_table, and this is the final round for ipv4_net_table.

While at it, other data-races around these related knobs are fixed.

  - decnet_mem
  - decnet_rmem
  - tipc_rmem

There are still 58 tables possibly missing some fixes under net/.

  $ grep -rnE "struct ctl_table.*?\[\] =" net/ | wc -l
  60


Kuniyuki Iwashima (7):
  tcp: Fix data-races around sk_pacing_rate.
  net: Fix data-races around sysctl_[rw]mem(_offset)?.
  tcp: Fix a data-race around sysctl_tcp_comp_sack_delay_ns.
  tcp: Fix a data-race around sysctl_tcp_comp_sack_slack_ns.
  tcp: Fix a data-race around sysctl_tcp_comp_sack_nr.
  tcp: Fix data-races around sysctl_tcp_reflect_tos.
  ipv4: Fix data-races around sysctl_fib_notify_on_flag_change.

 include/net/sock.h     |  8 ++++----
 net/decnet/af_decnet.c |  4 ++--
 net/ipv4/fib_trie.c    |  7 +++++--
 net/ipv4/tcp.c         |  6 +++---
 net/ipv4/tcp_input.c   | 24 +++++++++++++-----------
 net/ipv4/tcp_ipv4.c    |  4 ++--
 net/ipv4/tcp_output.c  |  2 +-
 net/ipv6/tcp_ipv6.c    |  4 ++--
 net/mptcp/protocol.c   |  6 +++---
 net/tipc/socket.c      |  2 +-
 10 files changed, 36 insertions(+), 31 deletions(-)

-- 
2.30.2

