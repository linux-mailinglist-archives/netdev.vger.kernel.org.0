Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99DE625217
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiKKECv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbiKKEC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:02:28 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B7C6AEF5
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 20:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668139253; x=1699675253;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=95cX7w1gc63nwBMd3jNoQHUixg9esxkQt5TmpWcRoZY=;
  b=RdgYyCiacrZFuDkTIkGt3fmthHJxuUei0g+4TTkBpi//IEQXFAXcpQpS
   gp7SPbrFYlHwd9h4fVfiTb/p+Xl+uK9XEvjtQOdLJgAc90U83B42KQH07
   TlY357alEVAYgR7O8c53Hy5FbTeCUyTZ8li2cS3gK8/QguZenao3UnS5z
   I=;
X-IronPort-AV: E=Sophos;i="5.96,155,1665446400"; 
   d="scan'208";a="149766677"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 04:00:51 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com (Postfix) with ESMTPS id 0DB0785814;
        Fri, 11 Nov 2022 04:00:48 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 11 Nov 2022 04:00:48 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 11 Nov 2022 04:00:45 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 0/6] udp: Introduce optional per-netns hash table.
Date:   Thu, 10 Nov 2022 20:00:28 -0800
Message-ID: <20221111040034.29736-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D21UWA003.ant.amazon.com (10.43.160.184) To
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

This series is the UDP version of the per-netns ehash series [0],
which were initially in the same patch set. [1]

The notable difference with TCP is the max table size is 64K.  This
is because the possible hash range by udp_hashfn() always fits in 64K
within the same netns.  Also, the UDP per-netns table isolates both
1-tuple and 2-tuple tables.

For details, please see the last patch.

  patch 1 - 4: prep for per-netns hash table
  patch     5: allocate bitmap beforehand for udp_lib_get_port() and smaller
               hash table
  patch     6: add per-netns hash table

[0]: https://lore.kernel.org/netdev/20220908011022.45342-1-kuniyu@amazon.com/
[1]: https://lore.kernel.org/netdev/20220826000445.46552-1-kuniyu@amazon.com/


Changes:
  v3:
    * Drop get_port() fix (posted separately later)
    * Patch 3
      * Fix CONFIG_PROC_FS=n build failure (kernel test robot)
    * Patch 5
      * Allocate bitmap when creating netns (Paolo Abeni)

  v2: https://lore.kernel.org/netdev/20221104190612.24206-1-kuniyu@amazon.com/

  v1: [1]


Kuniyuki Iwashima (6):
  udp: Clean up some functions.
  udp: Set NULL to sk->sk_prot->h.udp_table.
  udp: Set NULL to udp_seq_afinfo.udp_table.
  udp: Access &udp_table via net.
  udp: Add bitmap in udp_table.
  udp: Introduce optional per-netns hash table.

 Documentation/networking/ip-sysctl.rst |  27 ++++
 include/linux/udp.h                    |   2 +
 include/net/netns/ipv4.h               |   3 +
 include/net/udp.h                      |  20 +++
 net/core/filter.c                      |   4 +-
 net/ipv4/sysctl_net_ipv4.c             |  38 +++++
 net/ipv4/udp.c                         | 205 ++++++++++++++++++++-----
 net/ipv4/udp_diag.c                    |   6 +-
 net/ipv4/udp_offload.c                 |   5 +-
 net/ipv6/udp.c                         |  31 ++--
 net/ipv6/udp_offload.c                 |   5 +-
 11 files changed, 287 insertions(+), 59 deletions(-)

-- 
2.30.2

