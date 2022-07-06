Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8B4567DAD
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiGFFWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGFFWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:22:03 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3E11FCE9;
        Tue,  5 Jul 2022 22:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657084923; x=1688620923;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KgcHvSeQk9A90T8EU++IcwoBPEAYtDf422cDivH4wbA=;
  b=LN98yqdy3XDZkw+4hrcILGG/4CSHN7ix8dJVTaLcpBxHi9LqEvt4KAIT
   ei5/7z/LH4vhxQSwPLO+sBnHawsDqcfxFF9O/ChH6O1Gz5AiRbxK/otiR
   rv0ofiUmlWVwvtN/37/DWEEobRIhEXD4WnMMOuyz62Ihy1c1hPvu9Kg5E
   w=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="207627117"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 06 Jul 2022 05:21:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com (Postfix) with ESMTPS id 59701816CF;
        Wed,  6 Jul 2022 05:21:45 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:21:44 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:21:42 +0000
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
Subject: [PATCH v1 net 00/16] sysctl: Fix data-races around ipv4_table.
Date:   Tue, 5 Jul 2022 22:21:14 -0700
Message-ID: <20220706052130.16368-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D18UWA004.ant.amazon.com (10.43.160.45) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This series changes some proc handlers to use READ_ONCE()/WRITE_ONCE()
internally and tries to fix a data-race on the sysctl side.  However, we
still need a fix for readers/writers in other subsystems.

Not to miss the fix, we convert such handlers to a wrapper function of one
with the "_lockless" suffix.  When we add a fix on other subsystems, we set
the lockless handler as .proc_handler to mark the sysctl knob safe.

After this series, if a proc handler does not have the lockless suffix, it
means we need fixes in other subsystems.  Finally, when there is no user of
proc handlers without the lockless suffix, we can remove them and get free
from sysctl data-races.

This series starts fixing from ipv4_table.


Kuniyuki Iwashima (16):
  sysctl: Clean up proc_handler definitions.
  sysctl: Add proc_dobool_lockless().
  sysctl: Add proc_dointvec_lockless().
  sysctl: Add proc_douintvec_lockless().
  sysctl: Add proc_dointvec_minmax_lockless().
  sysctl: Add proc_douintvec_minmax_lockless().
  sysctl: Add proc_doulongvec_minmax_lockless().
  sysctl: Add proc_dointvec_jiffies_lockless().
  tcp: Fix a data-race around sysctl_tcp_max_orphans.
  inetpeer: Fix data-races around sysctl.
  net: Fix a data-race around sysctl_mem.
  tcp: Mark sysctl_tcp_low_latency obsolete.
  cipso: Fix a data-race around cipso_v4_cache_bucketsize.
  cipso: Fix data-races around boolean sysctl.
  icmp: Fix data-races around sysctl.
  ipv4: Fix a data-race around sysctl_fib_sync_mem.

 Documentation/networking/ip-sysctl.rst |   2 +-
 include/linux/sysctl.h                 |  51 ++---
 include/net/sock.h                     |   2 +-
 include/trace/events/sock.h            |   6 +-
 kernel/sysctl.c                        | 258 ++++++++++++++-----------
 net/decnet/sysctl_net_decnet.c         |   2 +-
 net/ipv4/cipso_ipv4.c                  |  19 +-
 net/ipv4/fib_trie.c                    |   2 +-
 net/ipv4/icmp.c                        |   5 +-
 net/ipv4/inetpeer.c                    |  13 +-
 net/ipv4/sysctl_net_ipv4.c             |  29 +--
 net/ipv4/tcp.c                         |   3 +-
 net/sctp/sysctl.c                      |   2 +-
 13 files changed, 214 insertions(+), 180 deletions(-)

-- 
2.30.2

