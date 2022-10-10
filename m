Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195215FA2D4
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 19:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJJRoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 13:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiJJRoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 13:44:34 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494AE76767;
        Mon, 10 Oct 2022 10:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665423872; x=1696959872;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aOVqe8qY0CLYp+T5y2hQD02VItYHe5ZY1yOFJrIXF48=;
  b=KC/Uk/6DXVGfEM9ufD6EpN5ExqXy/RIWV9Iku+F2Hxr7jJmizBqJ0Pkk
   v5INsgsOECTmPWMXWNdvwIKRAY4x7F9QIinU5YBjSgUfFHxLjupqnhnXs
   9+3wn6dDsj52GeKRzqsuR8hvnKA8L/zf5Q46tcpO9dWlMHEEkv0892Lab
   g=;
X-IronPort-AV: E=Sophos;i="5.95,173,1661817600"; 
   d="scan'208";a="253833678"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 17:44:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id 17631C0433;
        Mon, 10 Oct 2022 17:44:20 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 10 Oct 2022 17:44:19 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 10 Oct 2022 17:44:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>
CC:     Craig Gallek <kraig@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 net 0/3] soreuseport: Fix issues related to the faster selection algorithm.
Date:   Mon, 10 Oct 2022 10:43:48 -0700
Message-ID: <20221010174351.11024-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.124]
X-ClientProxiedBy: EX13D22UWC002.ant.amazon.com (10.43.162.29) To
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
selection with connected sockets"), but it introduced a rare race,
which the first patch fixes.  The second patch fixes the latter, and
the third adds a test for SO_INCOMING_CPU.


Kuniyuki Iwashima (3):
  udp: Update reuse->has_conns under reuseport_lock.
  soreuseport: Fix socket selection for SO_INCOMING_CPU.
  selftest: Add test for SO_INCOMING_CPU.

 include/net/sock_reuseport.h                  |  25 ++-
 net/core/sock.c                               |   5 +-
 net/core/sock_reuseport.c                     |  88 ++++++++++-
 net/ipv4/datagram.c                           |   2 +-
 net/ipv4/udp.c                                |   2 +-
 net/ipv6/datagram.c                           |   2 +-
 net/ipv6/udp.c                                |   2 +-
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   1 +
 tools/testing/selftests/net/so_incoming_cpu.c | 148 ++++++++++++++++++
 10 files changed, 260 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/net/so_incoming_cpu.c

-- 
2.30.2

