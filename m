Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507D35EC929
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiI0QM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiI0QMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:12:55 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA72F5A814;
        Tue, 27 Sep 2022 09:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664295175; x=1695831175;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lVbdRi5tzGJSVZaxAc/Kc7H+biNtsjmn4bTYdb8Fp6A=;
  b=IjAojPRW5BIeNBA38x8DAR0pSeavRLfJbrYxOWzvJOysTneEL/cnpAJF
   AsHHsKUQdAirIK854v7gEMHk6Pgk7Xb9M9A+4UegrIYmahxsaSHmUYZ7Q
   EFqjkbkMUuavvH+bzOpf/6sCCdaXECG2Ve97rEpyMKNeoutZAh5zoV6dh
   o=;
X-IronPort-AV: E=Sophos;i="5.93,349,1654560000"; 
   d="scan'208";a="249236619"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 16:12:43 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com (Postfix) with ESMTPS id ED050C08DC;
        Tue, 27 Sep 2022 16:12:39 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 27 Sep 2022 16:12:34 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.214) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 27 Sep 2022 16:12:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 net 0/5] tcp/udp: Fix memory leaks and data races around IPV6_ADDRFORM.
Date:   Tue, 27 Sep 2022 09:12:04 -0700
Message-ID: <20220927161209.32939-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.214]
X-ClientProxiedBy: EX13D13UWA002.ant.amazon.com (10.43.160.172) To
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


Kuniyuki Iwashima (5):
  tcp/udp: Fix memory leak in ipv6_renew_options().
  udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
  tcp/udp: Call inet6_destroy_sock() in IPv4 sk_prot->destroy().
  ipv6: Fix data races around sk->sk_prot.
  tcp: Fix data races around icsk->icsk_af_ops.

 net/core/sock.c          |  6 ++++--
 net/ipv4/af_inet.c       | 23 ++++++++++++++++-------
 net/ipv4/tcp.c           | 10 ++++++----
 net/ipv4/tcp_ipv4.c      |  5 +++++
 net/ipv4/udp.c           |  6 ++++++
 net/ipv6/ipv6_sockglue.c | 29 ++++++++++++++---------------
 net/ipv6/tcp_ipv6.c      |  1 -
 7 files changed, 51 insertions(+), 29 deletions(-)

-- 
2.30.2

