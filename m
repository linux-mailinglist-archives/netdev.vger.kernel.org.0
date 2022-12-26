Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D406562D9
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 14:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiLZN2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 08:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLZN2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 08:28:22 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C775A108E
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 05:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1672061302; x=1703597302;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hS3wPq9mlS8fuiHF5TkOXMu+FEMq+7S5G21B+iG91i4=;
  b=Y9rieSdtHeVcUbBw3klbIlueuQGB3rnHHE0HPPW5G8mbiFdU/HtMC1VJ
   BrWBWRpFUl/NQeZFHjO1k7Tlq4EGwUF557Od6+S7sxEYxXJ68F1M+iDPT
   nWSeOyjAKLwb4eMZFTkYtLFlO1+XDYARW2nepnq2zJSVEDYlbfdRw5UZD
   4=;
X-IronPort-AV: E=Sophos;i="5.96,275,1665446400"; 
   d="scan'208";a="280917566"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2022 13:28:19 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com (Postfix) with ESMTPS id 0C83341708;
        Mon, 26 Dec 2022 13:28:16 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 26 Dec 2022 13:28:16 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.221) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Mon, 26 Dec 2022 13:28:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Slaby <jirislaby@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 0/2] tcp: Fix bhash2 and TIME_WAIT regression.
Date:   Mon, 26 Dec 2022 22:27:51 +0900
Message-ID: <20221226132753.44175-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.221]
X-ClientProxiedBy: EX13D37UWA002.ant.amazon.com (10.43.160.211) To
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

We forgot to add twsk to bhash2.  Therefore TIME_WAIT sockets cannot
prevent bind() to the same local address and port.


Changes:
  v1:
    * Patch 1:
      * Add tw_bind2_node in inet_timewait_sock instead of
        moving sk_bind2_node from struct sock to struct
	sock_common.

  RFC: https://lore.kernel.org/netdev/20221221151258.25748-1-kuniyu@amazon.com/


Kuniyuki Iwashima (2):
  tcp: Add TIME_WAIT sockets in bhash2.
  tcp: Add selftest for bind() and TIME_WAIT.

 include/net/inet_hashtables.h               |  4 +
 include/net/inet_timewait_sock.h            |  5 ++
 net/ipv4/inet_connection_sock.c             | 26 +++++-
 net/ipv4/inet_hashtables.c                  |  8 +-
 net/ipv4/inet_timewait_sock.c               | 31 ++++++-
 tools/testing/selftests/net/.gitignore      |  1 +
 tools/testing/selftests/net/bind_timewait.c | 92 +++++++++++++++++++++
 7 files changed, 158 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/net/bind_timewait.c

-- 
2.30.2

