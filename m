Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC3E608011
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 22:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiJUUqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 16:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiJUUp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 16:45:58 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C4717EF28
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 13:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666385130; x=1697921130;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YxY2VO5oxdv/PM3noYTWSerJcwaznVKOGUo8Xf3ATlA=;
  b=kxURdQ9RnDI5N4uBnG4+jdgup9u3+SJcsVj4zMUGikUxe5iOtxXuBWKB
   pS500hO9vH75H48O7am8nS85DbX0CLtEaiSFJS1dehaBXmy+zzhNuTjhv
   xM1tLP1I6PVAfkIUBKMLm/MIXPvvovI4aY3MlmUJqHD3SQYqXYdmS0Syy
   I=;
X-IronPort-AV: E=Sophos;i="5.95,203,1661817600"; 
   d="scan'208";a="143062420"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 20:44:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com (Postfix) with ESMTPS id 5D92D611D4;
        Fri, 21 Oct 2022 20:44:53 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 21 Oct 2022 20:44:52 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.203) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Fri, 21 Oct 2022 20:44:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Martin KaFai Lau <martin.lau@kernel.org>,
        Craig Gallek <kraig@google.com>,
        Kazuho Oku <kazuhooku@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 0/2] soreuseport: Fix broken SO_INCOMING_CPU.
Date:   Fri, 21 Oct 2022 13:44:33 -0700
Message-ID: <20221021204435.4259-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.203]
X-ClientProxiedBy: EX13D39UWB001.ant.amazon.com (10.43.161.5) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

setsockopt(SO_INCOMING_CPU) for UDP/TCP is broken since 4.5/4.6 due to
these commits:

  * e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
  * c125e80b8868 ("soreuseport: fast reuseport TCP socket selection")

These commits introduced the O(1) socket selection algorithm and removed
O(n) iteration over the list, but it ignores the score calculated by
compute_score().  As a result, it caused two misbehaviours:

  * Unconnected sockets receive packets sent to connected sockets
  * SO_INCOMING_CPU does not work

The former is fixed by commit acdcecc61285 ("udp: correct reuseport
selection with connected sockets").  This series fixes the latter and
adds some tests for SO_INCOMING_CPU.


Changes:
  v3:
    * Rebase and resolve conflicts

  v2: https://lore.kernel.org/netdev/20221020163954.93618-1-kuniyu@amazon.com/
    * patch 1
      * Rename helper functions
      * Remove unnecessary arg sk from '__' helpers
      * Fix reuseport_update_incoming_cpu() logic
    * patch 2
      * Add test cases
        * Change when to set SO_INCOMING_CPU
        * Add/Remove non-SO_INCOMING_CPU socket

  v1: https://lore.kernel.org/netdev/20221010174351.11024-1-kuniyu@amazon.com/


Kuniyuki Iwashima (2):
  soreuseport: Fix socket selection for SO_INCOMING_CPU.
  selftest: Add test for SO_INCOMING_CPU.

 include/net/sock_reuseport.h                  |   2 +
 net/core/sock.c                               |   2 +-
 net/core/sock_reuseport.c                     |  94 ++++++-
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   1 +
 tools/testing/selftests/net/so_incoming_cpu.c | 242 ++++++++++++++++++
 6 files changed, 336 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/net/so_incoming_cpu.c

-- 
2.30.2

