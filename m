Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B8D605339
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiJSWg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJSWgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:36:25 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B3414EC7C
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 15:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666218984; x=1697754984;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sPqn8LwSI1ene/KWkETO7uuJpFiKStqi77tVQKOgFa8=;
  b=Te4tjawaZHzJMwtBYloSkAD6OYwTxLiz1gwx87v7KEiWnO5LPYiNpOAU
   le5t+5lJFX4HCXUQw0EJ8MZsseUCqJE5ztIvDObvrMwxl5ayYIA4jdaDq
   iwiN2bATFjX9KtWGq6vKpy2huxthKj0JqvxMpQXNWQ08xAwi4r8mUjgVb
   Y=;
X-IronPort-AV: E=Sophos;i="5.95,196,1661817600"; 
   d="scan'208";a="253918343"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 22:36:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id 9618681A6F;
        Wed, 19 Oct 2022 22:36:19 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 19 Oct 2022 22:36:19 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.213) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 19 Oct 2022 22:36:16 +0000
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
Subject: [PATCH v2 net-next 0/5] inet6: Remove inet6_destroy_sock() calls.
Date:   Wed, 19 Oct 2022 15:35:58 -0700
Message-ID: <20221019223603.22991-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.213]
X-ClientProxiedBy: EX13D41UWC002.ant.amazon.com (10.43.162.127) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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


Changes:
  v2:
    * patch 1
      * Fix build failure for CONFIG_MPTCP_IPV6=y

  v1: https://lore.kernel.org/netdev/20221018190956.1308-1-kuniyu@amazon.com/


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
 net/mptcp/protocol.c     |  7 -------
 net/sctp/socket.c        | 29 +++++++++++++++++++++--------
 13 files changed, 42 insertions(+), 55 deletions(-)

-- 
2.30.2

