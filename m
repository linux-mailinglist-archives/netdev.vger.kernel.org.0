Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF83569667
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiGFXk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbiGFXk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:40:56 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD3C2CDE8;
        Wed,  6 Jul 2022 16:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657150855; x=1688686855;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=554TZ1STLEPnvqv57mOIpMzRQSEDSmhbcUbukQH3HDM=;
  b=XHrITN6//nZY+F2CaNYw9/jEwFWaR1aMCRwugK75T6sUpZliPaK8Tc7w
   fzLtfMMxoG7daoO96ywqaKBdX6jKK0+x993RU+gHO9d47O5XhsxPaTIbl
   3/HPd4K0KmS183vl6i7fg2XraWQG+U3oF4J3oDP4u15moRiDDetLLm8Ja
   A=;
X-IronPort-AV: E=Sophos;i="5.92,251,1650931200"; 
   d="scan'208";a="215524095"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 06 Jul 2022 23:40:43 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id 26C49220157;
        Wed,  6 Jul 2022 23:40:40 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 23:40:40 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.106) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 23:40:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net 00/12] sysctl: Fix data-races around ipv4_table.
Date:   Wed, 6 Jul 2022 16:39:51 -0700
Message-ID: <20220706234003.66760-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.106]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

The first half of this series changes some proc handlers used in ipv4_table
to use READ_ONCE() and WRITE_ONCE() internally to fix data-races on the
sysctl side.  Then, the second half adds READ_ONCE() to the other readers
of ipv4_table.


Changes:
  v2:
    * Drop some changes that makes backporting difficult
      * First cleanup patch
      * Lockless helpers and .proc_handler changes
    * Drop the tracing part for .sysctl_mem
      * Steve already posted a fix
    * Drop int-to-bool change for cipso
      * Should be posted to net-next later
    * Drop proc_dobool() change
      * Can be included in another series

  v1: https://lore.kernel.org/netdev/20220706052130.16368-1-kuniyu@amazon.com/


Kuniyuki Iwashima (12):
  sysctl: Fix data races in proc_dointvec().
  sysctl: Fix data races in proc_douintvec().
  sysctl: Fix data races in proc_dointvec_minmax().
  sysctl: Fix data races in proc_douintvec_minmax().
  sysctl: Fix data races in proc_doulongvec_minmax().
  sysctl: Fix data races in proc_dointvec_jiffies().
  tcp: Fix a data-race around sysctl_tcp_max_orphans.
  inetpeer: Fix data-races around sysctl.
  net: Fix data-races around sysctl_mem.
  cipso: Fix data-races around sysctl.
  icmp: Fix data-races around sysctl.
  ipv4: Fix a data-race around sysctl_fib_sync_mem.

 Documentation/networking/ip-sysctl.rst |  2 +-
 include/net/sock.h                     |  2 +-
 kernel/sysctl.c                        | 25 ++++++++++++++-----------
 net/ipv4/cipso_ipv4.c                  | 12 +++++++-----
 net/ipv4/fib_trie.c                    |  2 +-
 net/ipv4/icmp.c                        |  5 +++--
 net/ipv4/inetpeer.c                    | 12 ++++++++----
 net/ipv4/tcp.c                         |  3 ++-
 8 files changed, 37 insertions(+), 26 deletions(-)

-- 
2.30.2

