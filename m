Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7345F32F2
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 17:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiJCPy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 11:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJCPy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 11:54:57 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594A295B0;
        Mon,  3 Oct 2022 08:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664812495; x=1696348495;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JYNeyQRFj4W4/UHAdKZYi73ciakVUoIyk26IBToySv8=;
  b=KjQv5T0Ch+vmFP+7f2SAh/qpNsI0j+UpIyu5hwZ5TixdscJheLWphT1c
   NEX1tcnEXkS2OyEqJdtcw1hVOnnGzvlf6apfrVyhY3d2qfp/aUgX/900S
   nPSvwhGWkw81LinYPJvPuEB/+QrIH2e/e+un/cKtebjgALBV6oi4KXdDK
   4=;
X-IronPort-AV: E=Sophos;i="5.93,365,1654560000"; 
   d="scan'208";a="1060297196"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 15:44:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id 2A10C22237F;
        Mon,  3 Oct 2022 15:44:52 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 3 Oct 2022 15:44:52 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.69) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 3 Oct 2022 15:44:47 +0000
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
Subject: [PATCH RESEND v3 net 0/5] tcp/udp: Fix memory leaks and data races around IPV6_ADDRFORM.
Date:   Mon, 3 Oct 2022 08:44:20 -0700
Message-ID: <20221003154425.49458-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D11UWC001.ant.amazon.com (10.43.162.151) To
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

Note patch 1 and 5 conflict with these commits in net-next, respectively.

  * 24426654ed3a ("bpf: net: Avoid sk_setsockopt() taking sk lock when called from bpf")
  * 34704ef024ae ("bpf: net: Change do_tcp_getsockopt() to take the sockptr_t argument")


Changes:
  v3 (Resend):
    * Patch 2 & 3:
      * CC blamed commits' -EHOSTUNREACH authors to make patchwork happy

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
 net/core/sock.c          |  6 ++++--
 net/ipv4/af_inet.c       | 23 ++++++++++++++++-------
 net/ipv4/tcp.c           | 10 ++++++----
 net/ipv4/udp.c           |  8 ++++++--
 net/ipv6/af_inet6.c      | 15 ++++++++++++++-
 net/ipv6/ipv6_sockglue.c | 34 +++++++++++++++++++---------------
 net/ipv6/tcp_ipv6.c      |  6 ++++--
 net/ipv6/udp.c           | 15 ++++++++++++++-
 10 files changed, 86 insertions(+), 35 deletions(-)

-- 
2.30.2

