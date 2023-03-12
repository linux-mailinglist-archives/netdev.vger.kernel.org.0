Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45736B6304
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 04:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjCLDTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 22:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCLDTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 22:19:41 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0ED2A15B
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 19:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678591181; x=1710127181;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6wqNQBaRAWtnD861rALL2SI9m1GbTkuSxRnKs0YTFMY=;
  b=S4N38kWWzkiiVclCAjmQhCQ8nNmoJ7IUlD3tpmk3baaytVz81PE2UK7G
   uEjtLNek2CzJ5c/+cInc9Nfr9qckg5itOkvOkOS5+VZik7l5gwQXvgEVu
   L6HxrXKwjzUdcJpAlXJPI7FdW6Ap9ovz00eS8xIcYkxK/UVob3JsI6+cA
   U=;
X-IronPort-AV: E=Sophos;i="5.98,253,1673913600"; 
   d="scan'208";a="302050791"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 03:19:38 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id 99D8C811F9;
        Sun, 12 Mar 2023 03:19:36 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Sun, 12 Mar 2023 03:19:33 +0000
Received: from 88665a182662.ant.amazon.com (10.119.80.90) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Sun, 12 Mar 2023 03:19:31 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 0/2] tcp: Fix bind() regression for dual-stack wildcard address.
Date:   Sat, 11 Mar 2023 19:19:02 -0800
Message-ID: <20230312031904.4674-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.80.90]
X-ClientProxiedBy: EX19D039UWB003.ant.amazon.com (10.13.138.93) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch fixes the regression reported in [0], and the second
patch adds a test for similar cases to catch future regression.

[0]: https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com/


Kuniyuki Iwashima (2):
  tcp: Fix bind() conflict check for dual-stack wildcard address.
  selftest: Add test for bind() conflicts.

 net/ipv4/inet_hashtables.c                  |   8 +-
 tools/testing/selftests/net/.gitignore      |   1 +
 tools/testing/selftests/net/Makefile        |   1 +
 tools/testing/selftests/net/bind_wildcard.c | 114 ++++++++++++++++++++
 4 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/bind_wildcard.c

-- 
2.30.2

