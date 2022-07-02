Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CC4564131
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 17:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiGBPs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 11:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiGBPs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 11:48:57 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04419EE02
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 08:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656776935; x=1688312935;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CLx4RCyN+0bqefjYr8Eey9RmL+wE3D1XbvH6SIt9BRU=;
  b=eMJOj9KB9wsCXR8BSvBuC/liAHxgGf+aYoQB8fHiWS/zrndpFSvLkVMG
   Z/sFPXLXnaSqqUlbQBk+TaoQRv9q5pkZkxRl23CNYbGUY3sZyg+KeIDFv
   UCg385Fq10R56O0/Z3oq8Z9vQ6E7YWHADCs9Scd5pwrSw+Uw6BxRNHOv7
   4=;
X-IronPort-AV: E=Sophos;i="5.92,240,1650931200"; 
   d="scan'208";a="104222416"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 02 Jul 2022 15:48:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id 36D561A0051;
        Sat,  2 Jul 2022 15:48:39 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sat, 2 Jul 2022 15:48:38 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Sat, 2 Jul 2022 15:48:35 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Sachin Sant <sachinp@linux.ibm.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 0/2] af_unix: Fix regression by the per-netns hash table series.
Date:   Sat, 2 Jul 2022 08:48:16 -0700
Message-ID: <20220702154818.66761-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.39]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The series 6dd4142fb5a9 ("Merge branch 'af_unix-per-netns-socket-hash'")
replaced a global hash table with per-netns tables, which caused regression
reported in the links below. [0][1]

When a pathname socket is visible, any socket with the same type has to be
able to connect to it even in different netns.  The series puts all sockets
into each namespace's hash table, making it impossible to look up a visible
socket in different netns.

On the other hand, while dumping sockets, they are filtered by netns.  To
keep such code simple, let's add a new global hash table only for pathname
sockets and link them with sk_bind_node.  Then we can keep all sockets in
each per-netns table and look up pathname sockets via the global table.

[0]: https://lore.kernel.org/netdev/B2AA3091-796D-475E-9A11-0021996E1C00@linux.ibm.com/
[1]: https://lore.kernel.org/netdev/5fb8d86f-b633-7552-8ba9-41e42f07c02a@gmail.com/


Changes:
  v3:
    * 1st: Update changelog s/named/pathname/
    * 2nd: Fix checkpatch.pl CHECK by --strict option

  v2: https://lore.kernel.org/netdev/20220702014447.93746-1-kuniyu@amazon.com/
    * Add selftest

  v1: https://lore.kernel.org/netdev/20220701072519.96097-1-kuniyu@amazon.com/


Kuniyuki Iwashima (2):
  af_unix: Put pathname sockets in the global hash table.
  selftests: net: af_unix: Test connect() with different netns.

 net/unix/af_unix.c                            |  47 ++++--
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   3 +-
 .../selftests/net/af_unix/unix_connect.c      | 149 ++++++++++++++++++
 4 files changed, 189 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/net/af_unix/unix_connect.c

-- 
2.30.2

