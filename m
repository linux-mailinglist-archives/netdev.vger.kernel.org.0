Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44016308FA
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiKSB6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbiKSB54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:57:56 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CDA5FD5;
        Fri, 18 Nov 2022 17:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668822572; x=1700358572;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zYSw94x9N37XgykhyM/xO3LSAk9NRTKCC/uGQLTMHOQ=;
  b=fvUBjFUylDV6LWHPVrJod9y+BnpSSTNfiPcyH6LkLHiqX5Qr91nTOQxz
   VS1UCnhjfV8HsU/Sg2qOpwj8P8PpFSbfMkoVf76op++dYzhW7yKNfJQzo
   kFHzE8QNYtQUDeodPWg+/rCPHIfa1J6lgAs/SrQjzTI0wOqDpwxkgqdn9
   Y=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2022 01:49:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id A1A59C2FD7;
        Sat, 19 Nov 2022 01:49:28 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sat, 19 Nov 2022 01:49:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Sat, 19 Nov 2022 01:49:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Arnaldo Carvalho de Melo <acme@mandriva.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "Mat Martineau" <mathew.j.martineau@linux.intel.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <dccp@vger.kernel.org>
Subject: [PATCH v4 net 0/4] dccp/tcp: Fix bhash2 issues related to WARN_ON() in inet_csk_get_port().
Date:   Fri, 18 Nov 2022 17:49:10 -0800
Message-ID: <20221119014914.31792-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D46UWB004.ant.amazon.com (10.43.161.204) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller was hitting a WARN_ON() in inet_csk_get_port() in the 4th patch,
which was because we forgot to fix up bhash2 bucket when connect() for a
socket bound to a wildcard address fails in __inet_stream_connect().

There was a similar report [0], but its repro does not fire the WARN_ON() due
to inconsistent error handling.

When connect() for a socket bound to a wildcard address fails, saddr may or
may not be reset depending on where the failure happens.  When we fail in
__inet_stream_connect(), sk->sk_prot->disconnect() resets saddr.  OTOH, in
(dccp|tcp)_v[46]_connect(), if we fail after inet_hash6?_connect(), we
forget to reset saddr.

We fix this inconsistent error handling in the 1st patch, and then we'll
fix the bhash2 WARN_ON() issue.

Note that there is still an issue in that we reset saddr without checking
if there are conflicting sockets in bhash and bhash2, but this should be
another series.

See [1][2] for the previous discussion.

[0]: https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.com/
[1]: https://lore.kernel.org/netdev/20221029001249.86337-1-kuniyu@amazon.com/
[2]: https://lore.kernel.org/netdev/20221103172419.20977-1-kuniyu@amazon.com/
[3]: https://lore.kernel.org/netdev/20221118081906.053d5231@kernel.org/T/#m00aafedb29ff0b55d5e67aef0252ef1baaf4b6ee


Changes:
  v4:
    * Patch 3
      * Narrow down the bhash lock section (Joanne Koong)

  v3: https://lore.kernel.org/netdev/20221118205839.14312-1-kuniyu@amazon.com/
    * Patch 3
      * Update saddr under the bhash's lock
      * Correct Fixes tag
      * Change #ifdef in inet_update_saddr() along the recent
        discussion [3]

  v2: https://lore.kernel.org/netdev/20221116222805.64734-1-kuniyu@amazon.com/
    * Add patch 2-4

  v1: [2]


Kuniyuki Iwashima (4):
  dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
  dccp/tcp: Remove NULL check for prev_saddr in
    inet_bhash2_update_saddr().
  dccp/tcp: Update saddr under bhash's lock.
  dccp/tcp: Fixup bhash2 bucket when connect() fails.

 include/net/inet_hashtables.h |  3 +-
 net/dccp/ipv4.c               | 23 +++-------
 net/dccp/ipv6.c               | 24 +++-------
 net/dccp/proto.c              |  3 +-
 net/ipv4/af_inet.c            | 11 +----
 net/ipv4/inet_hashtables.c    | 84 ++++++++++++++++++++++++++++++-----
 net/ipv4/tcp.c                |  3 +-
 net/ipv4/tcp_ipv4.c           | 21 +++------
 net/ipv6/tcp_ipv6.c           | 20 ++-------
 9 files changed, 96 insertions(+), 96 deletions(-)

-- 
2.30.2

