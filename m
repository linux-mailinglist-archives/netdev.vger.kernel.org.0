Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69A3653302
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiLUPNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiLUPNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:13:19 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7CE1F2
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1671635599; x=1703171599;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lZV0v3fkCwxA92MwlM0/OSFTWKdndEhP476HkUjq2Qc=;
  b=vUIBsn3PqWWvOW64Ksvc+DAXWnkWS/Hlv9RT0UTW5Sil2y0wh1c2GcMX
   rV8pLTgQpXCOtRvgZPnkux+3OVyz7mwQ2BXZVF1sCvsPVdEV9SLE+20o0
   PIVlTm9pVujKCxRyTynoPL5VM4GqvjK5forwfpdUeCDBZ6jjRyC8qXZ8e
   s=;
X-IronPort-AV: E=Sophos;i="5.96,262,1665446400"; 
   d="scan'208";a="281431275"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 15:13:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com (Postfix) with ESMTPS id 0D673342653;
        Wed, 21 Dec 2022 15:13:12 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 21 Dec 2022 15:13:12 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.114) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Wed, 21 Dec 2022 15:13:08 +0000
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
Subject: [PATCH RFC net 0/2] tcp: Fix bhash2 and TIME_WAIT regression.
Date:   Thu, 22 Dec 2022 00:12:56 +0900
Message-ID: <20221221151258.25748-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.114]
X-ClientProxiedBy: EX13D27UWA003.ant.amazon.com (10.43.160.56) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We forgot to add TIME_WAIT sockets to bhash2.  Therefore twsk cannot
prevent bind() to the same local address and port.

The first patch fixes the issue, but the layout change in struct
sock could have a negative impact.  So, this series is RFC.


Kuniyuki Iwashima (2):
  tcp: Add TIME_WAIT sockets in bhash2.
  tcp: Add selftest for bind() and TIME_WAIT.

 include/net/inet_timewait_sock.h            |  2 +
 include/net/sock.h                          |  5 +-
 net/ipv4/inet_hashtables.c                  |  5 +-
 net/ipv4/inet_timewait_sock.c               | 31 ++++++-
 tools/testing/selftests/net/.gitignore      |  1 +
 tools/testing/selftests/net/bind_timewait.c | 93 +++++++++++++++++++++
 6 files changed, 131 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/net/bind_timewait.c

-- 
2.30.2

