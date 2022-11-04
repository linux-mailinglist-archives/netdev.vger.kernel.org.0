Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACA961A081
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiKDTGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKDTGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:06:33 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D667943AF7
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667588793; x=1699124793;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RuKDrYBRNLkaJPF/ckyujCfjhjvKLQynFZXNrGFVAys=;
  b=aDjyTt+Fpp1E8aZxUJWaaCOYABDl6aEpC9mmmQ0TDA1mm26VXsYmXnbm
   xKOiDiuMad1zLy43+uTOL3uBXUk5S9wqOXK5DcRl/dDc2ehUhHVf5SEWy
   6CeMns5nbbMlUp73ASZDALrrNgupqTqcARbv8dKvMU4MSkC23jScow4+R
   s=;
X-IronPort-AV: E=Sophos;i="5.96,138,1665446400"; 
   d="scan'208";a="147623000"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 19:06:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id BFE9CC3357;
        Fri,  4 Nov 2022 19:06:28 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 4 Nov 2022 19:06:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Fri, 4 Nov 2022 19:06:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 0/6] udp: Introduce optional per-netns hash table.
Date:   Fri, 4 Nov 2022 12:06:06 -0700
Message-ID: <20221104190612.24206-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D48UWB002.ant.amazon.com (10.43.163.125) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is the UDP version of the per-netns ehash series [0],
which were initially in the same patch set. [1]

The notable difference with TCP is the max table size is 64K.  This
is because the possible hash range by udp_hashfn() always fits in 64K
within the same netns.  Also, the UDP per-netns table isolates both
1-tuple and 2-tuple tables.

For details, please see the last patch.

  patch 1 - 4: prep for per-netns hash table
  patch     5: prep for dynamically allocating bitmap in udp_lib_get_port()
  patch     6: add per-netns hash table

[0]: https://lore.kernel.org/netdev/20220908011022.45342-1-kuniyu@amazon.com/
[1]: https://lore.kernel.org/netdev/20220826000445.46552-1-kuniyu@amazon.com/


Kuniyuki Iwashima (6):
  udp: Clean up some functions.
  udp: Set NULL to sk->sk_prot->h.udp_table.
  udp: Set NULL to udp_seq_afinfo.udp_table.
  udp: Access &udp_table via net.
  net: Do not ignore the error by sk->sk_prot->get_port().
  udp: Introduce optional per-netns hash table.

 Documentation/networking/ip-sysctl.rst |  27 ++++
 include/linux/udp.h                    |   2 +
 include/net/netns/ipv4.h               |   3 +
 net/core/filter.c                      |   4 +-
 net/ipv4/af_inet.c                     |   4 +-
 net/ipv4/inet_connection_sock.c        |   7 +-
 net/ipv4/ping.c                        |   2 +-
 net/ipv4/sysctl_net_ipv4.c             |  38 +++++
 net/ipv4/udp.c                         | 212 ++++++++++++++++++++-----
 net/ipv4/udp_diag.c                    |   6 +-
 net/ipv4/udp_offload.c                 |   5 +-
 net/ipv6/af_inet6.c                    |   4 +-
 net/ipv6/udp.c                         |  31 ++--
 net/ipv6/udp_offload.c                 |   5 +-
 14 files changed, 281 insertions(+), 69 deletions(-)

-- 
2.30.2

