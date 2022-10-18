Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871AB603314
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 21:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiJRTLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 15:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiJRTLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 15:11:05 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA54813F34
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 12:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666120265; x=1697656265;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DXDlH/t1kq8mKB5yIqvnxgLXg5QtE82q3uU4OFRjGnQ=;
  b=i2tsyvWWx3yIgPXoV+dwwKb8bV+a6p0SMNeLoXC9t0u2jW9e3YV/Szfd
   IMjiLkpu+MBbKdNvRO4XSk03Vk1ZpU7tMPoxKmLnvuPrWBYx06UmB+N6D
   txJr34ERIQ8tBuRB8CgsjaWoLYhdG0ARt4Y3bChPgSIQ2rjPKPbJ8bPKu
   I=;
X-IronPort-AV: E=Sophos;i="5.95,194,1661817600"; 
   d="scan'208";a="270806736"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-54c9d11f.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 19:11:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-54c9d11f.us-east-1.amazon.com (Postfix) with ESMTPS id 3953DC0F73;
        Tue, 18 Oct 2022 19:10:56 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 18 Oct 2022 19:10:56 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.214) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Tue, 18 Oct 2022 19:10:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 0/5] inet6: Remove inet6_destroy_sock() calls.
Date:   Tue, 18 Oct 2022 12:09:51 -0700
Message-ID: <20221018190956.1308-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.214]
X-ClientProxiedBy: EX13D10UWB004.ant.amazon.com (10.43.161.121) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up series for commit d38afeec26ed ("tcp/udp: Call
inet6_destroy_sock() in IPv6 sk->sk_destruct().").

This series cleans up unnecessary inet6_destory_sock() calls in
sk->sk_prot->destroy() and call it from sk->sk_destruct() to make
sure we do not leak memory related to IPv6 specific-resources.


Kuniyuki Iwashima (5):
  inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
  dccp: Call inet6_destroy_sock() via sk->sk_destruct().
  sctp: Call inet6_destroy_sock() via sk->sk_destruct().
  inet6: Remove inet6_destroy_sock().
  inet6: Clean up failure path in do_ipv6_setsockopt().

 include/net/transp_v6.h  |  2 --
 net/dccp/dccp.h          |  1 +
 net/dccp/ipv6.c          | 15 ++++++++-------
 net/dccp/proto.c         |  8 +++++++-
 net/ipv6/af_inet6.c      |  9 ++-------
 net/ipv6/ipv6_sockglue.c |  6 ++----
 net/ipv6/ping.c          |  6 ------
 net/ipv6/raw.c           |  2 --
 net/ipv6/tcp_ipv6.c      |  8 +-------
 net/ipv6/udp.c           |  2 --
 net/l2tp/l2tp_ip6.c      |  2 --
 net/mptcp/protocol.c     | 10 ----------
 net/sctp/socket.c        | 29 +++++++++++++++++++++--------
 13 files changed, 42 insertions(+), 58 deletions(-)

-- 
2.30.2

