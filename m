Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0C9628BAC
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 22:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbiKNV6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 16:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237136AbiKNV6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 16:58:15 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E5910FDF
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 13:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668463095; x=1699999095;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xRrZeQTmBJY514l4y3abnIK+xmfPwAHUS5NfWC6NdgY=;
  b=tE3vTKqWiaJxICGedfJPA0kNiCTxHwA9vRbODIJXHbmQLXaspuxyPSOP
   ShDaASf7mPo69s/q+lT1flF1J95wAy9QUkNGDiG3S2wsEVlFdJmf0sAZQ
   Ins4fHbht+4PIHNLsqw+llBVPreS5jXgr8zmAX2q7G3EUCkSG4SlR+Q6s
   4=;
X-IronPort-AV: E=Sophos;i="5.96,164,1665446400"; 
   d="scan'208";a="266537651"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 21:58:13 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com (Postfix) with ESMTPS id 1E5F242133;
        Mon, 14 Nov 2022 21:58:12 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 14 Nov 2022 21:58:11 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Mon, 14 Nov 2022 21:58:09 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 net-next 0/5] udp: Introduce optional per-netns hash table.
Date:   Mon, 14 Nov 2022 13:57:52 -0800
Message-ID: <20221114215757.37455-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D34UWC002.ant.amazon.com (10.43.162.137) To
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

The notable difference with TCP is the max table size is 64K and the min
size is 128.  This is because the possible hash range by udp_hashfn()
always fits in 64K within the same netns and because we want to keep a
bitmap in udp_lib_get_port() on the stack.  Also, the UDP per-netns table
isolates both 1-tuple and 2-tuple tables.

For details, please see the last patch.

  patch 1 - 4: prep for per-netns hash table
  patch     5: add per-netns hash table

[0]: https://lore.kernel.org/netdev/20220908011022.45342-1-kuniyu@amazon.com/
[1]: https://lore.kernel.org/netdev/20220826000445.46552-1-kuniyu@amazon.com/


Changes:
  v4:
    * Drop a change to allcate bitmaps dynamically
    * Patch 5
      * Set the min size to 128 and keep the bitmap on stack (Paolo Abeni)
      * Add memset() in the proc handler (Paolo Abeni)

  v3: https://lore.kernel.org/netdev/20221111040034.29736-1-kuniyu@amazon.com/
    * Drop get_port() fix (posted separately later)
    * Patch 3
      * Fix CONFIG_PROC_FS=n build failure
    * Patch 5
      * Allocate bitmap when creating netns (Paolo Abeni)

  v2: https://lore.kernel.org/netdev/20221104190612.24206-1-kuniyu@amazon.com/

  v1: [1]


Kuniyuki Iwashima (5):
  udp: Clean up some functions.
  udp: Set NULL to sk->sk_prot->h.udp_table.
  udp: Set NULL to udp_seq_afinfo.udp_table.
  udp: Access &udp_table via net.
  udp: Introduce optional per-netns hash table.

 Documentation/networking/ip-sysctl.rst |  27 ++++
 include/linux/udp.h                    |   2 +
 include/net/netns/ipv4.h               |   3 +
 net/core/filter.c                      |   4 +-
 net/ipv4/sysctl_net_ipv4.c             |  40 +++++
 net/ipv4/udp.c                         | 196 ++++++++++++++++++++-----
 net/ipv4/udp_diag.c                    |   6 +-
 net/ipv4/udp_offload.c                 |   5 +-
 net/ipv6/udp.c                         |  31 ++--
 net/ipv6/udp_offload.c                 |   5 +-
 10 files changed, 261 insertions(+), 58 deletions(-)

-- 
2.30.2

