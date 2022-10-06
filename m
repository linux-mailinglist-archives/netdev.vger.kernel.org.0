Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BBE5F6DBF
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 20:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiJFSyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 14:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiJFSya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 14:54:30 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471DDC6940;
        Thu,  6 Oct 2022 11:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665082470; x=1696618470;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O+rxa/5K9etOxsM0rDLKBB+YkC59TxU0x7Pj+sq5/H0=;
  b=C+GHVJdAmaCExcH9tioAod+WAsWe9JsHfqyf4yyyanBH2sA+0OtQByMQ
   f1lqXEhLwwLv4bMv/Lsc7wIvJFJ2gin4eN9w6WOGHgLuWmGTkHuaHXRL6
   J77YXB7aEJAufKAqTQjSkXtlHsPUyxJJiCMUa8OWAfaksEwiySYQ+UKil
   U=;
X-IronPort-AV: E=Sophos;i="5.95,164,1661817600"; 
   d="scan'208";a="231288507"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 18:54:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com (Postfix) with ESMTPS id B29CCC08DE;
        Thu,  6 Oct 2022 18:54:08 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 6 Oct 2022 18:54:07 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.176) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 6 Oct 2022 18:54:02 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 net 0/5] tcp/udp: Fix memory leaks and data races around IPV6_ADDRFORM.
Date:   Thu, 6 Oct 2022 11:53:44 -0700
Message-ID: <20221006185349.74777-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.176]
X-ClientProxiedBy: EX13D18UWA003.ant.amazon.com (10.43.160.238) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some memory leaks and data races caused in the
same scenario where one thread converts an IPv6 socket into IPv4
with IPV6_ADDRFORM and another accesses the socket concurrently.


Changes:
  v5:
    * Patch 1 & 5
      * Rebase and resolve conflicts with 24426654ed3a and 34704ef024ae

    * Patch 3:
      * Remove 'inline' from udplite_sk_init()
      * Remove EXPORT_SYMBOL_GPL(inet6_sock_destruct)

  v4: https://lore.kernel.org/netdev/20221004171802.40968-1-kuniyu@amazon.com/
    * Patch 3:
      * Change UDPv6 Lite's sk->sk_prot->init() and sk->destruct() as well.
      * Move udplite_sk_init() from udplite.h to udplite.c.

  v3 (Resend): https://lore.kernel.org/netdev/20221003154425.49458-1-kuniyu@amazon.com/
    * CC blamed commits' EHOSTUNREACH authors to make patchwork happy

  v3: https://lore.kernel.org/netdev/20220929012542.55424-1-kuniyu@amazon.com/
    * Patch 2:
      * Add comment for np->rxopt.all = 0
      * Add inet6_cleanup_sock()
    * Patch 3:
      * Call inet6_cleanup_sock() instead of inet6_destroy_sock()

  v2: https://lore.kernel.org/netdev/20220928002741.64237-1-kuniyu@amazon.com/
    * Patch 3:
      * Move inet6_destroy_sock() from sk_prot->destroy()
        to sk->sk_destruct() and fix CONFIG_IPV6=m build failure
    * Patch 5:
      * Add WRITE_ONCE()s in tcp_v6_connect()
      * Add Reported-by tags and KCSAN log in changelog

  v1: https://lore.kernel.org/netdev/20220927161209.32939-1-kuniyu@amazon.com/


Kuniyuki Iwashima (5):
  tcp/udp: Fix memory leak in ipv6_renew_options().
  udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
  tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
  ipv6: Fix data races around sk->sk_prot.
  tcp: Fix data races around icsk->icsk_af_ops.

 include/net/ipv6.h       |  2 ++
 include/net/udp.h        |  2 +-
 include/net/udplite.h    |  8 --------
 net/core/sock.c          |  6 ++++--
 net/ipv4/af_inet.c       | 23 ++++++++++++++++-------
 net/ipv4/tcp.c           | 10 ++++++----
 net/ipv4/udp.c           |  9 ++++++---
 net/ipv4/udplite.c       |  8 ++++++++
 net/ipv6/af_inet6.c      | 14 +++++++++++++-
 net/ipv6/ipv6_sockglue.c | 34 +++++++++++++++++++---------------
 net/ipv6/tcp_ipv6.c      |  6 ++++--
 net/ipv6/udp.c           | 15 ++++++++++++++-
 net/ipv6/udp_impl.h      |  1 +
 net/ipv6/udplite.c       |  9 ++++++++-
 14 files changed, 102 insertions(+), 45 deletions(-)

-- 
2.30.2

