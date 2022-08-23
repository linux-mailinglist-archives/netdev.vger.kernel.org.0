Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886F159EC0B
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiHWTRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiHWTQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:16:39 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E2B6747B
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661277234; x=1692813234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QkBT3InCcPgr3TJ/MADQsKpY17JGgMcbWCggup6nInk=;
  b=vtoSGTs3MuyI856v7/iCBRt5NXEy4PpvQk28AIyiqybCllBx3J/CjaMx
   IS7P8akPYGh8AZfxFDLfKloYw5vwBZSyQdZI5OUFtRulrsMr4k5J/QYxD
   zJ+ayDx7cUUqu92OycW/ON9oxmgqViA0xW6AcMJ2O8z8ZNGvI6noDx2Mo
   I=;
X-IronPort-AV: E=Sophos;i="5.93,258,1654560000"; 
   d="scan'208";a="1047381559"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:50:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com (Postfix) with ESMTPS id CEC3444DD6;
        Tue, 23 Aug 2022 17:50:32 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 17:50:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.160) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 17:50:28 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v4 net 09/17] net: Fix a data-race around sysctl_net_busy_read.
Date:   Tue, 23 Aug 2022 10:46:52 -0700
Message-ID: <20220823174700.88411-10-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220823174700.88411-1-kuniyu@amazon.com>
References: <20220823174700.88411-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.160]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_net_busy_read, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 2d48d67fa8cd ("net: poll/select low latency socket support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Eliezer Tamir <eliezer.tamir@linux.intel.com>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 95abf4604d88..788c1372663c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3367,7 +3367,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	sk->sk_napi_id		=	0;
-	sk->sk_ll_usec		=	sysctl_net_busy_read;
+	sk->sk_ll_usec		=	READ_ONCE(sysctl_net_busy_read);
 #endif
 
 	sk->sk_max_pacing_rate = ~0UL;
-- 
2.30.2

