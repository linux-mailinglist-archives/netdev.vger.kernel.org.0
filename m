Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0128B573E59
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbiGMU43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiGMU42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:56:28 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C168DCD9
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657745788; x=1689281788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bGme9bUKxCtbqxb1gsZE/LPmLJSqlbUWTJM2k9xlNiw=;
  b=tYbF44idVxcRIMJCqBbQ/jgPsuVZdQfRhsfUwNZ3NIMII/A4TUdOTjDa
   yIpkSSPwLuymiB4xdHz2ixzRfYk6lgt78CPCt/vpHgyLq6z6smA9C+7tD
   NIxmVPnOGfUMC3m3C6B7wFamHxG7dWHl3qYhSqXnlBXNbjyvpJJs2ii4g
   4=;
X-IronPort-AV: E=Sophos;i="5.92,269,1650931200"; 
   d="scan'208";a="237979915"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 13 Jul 2022 20:56:27 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com (Postfix) with ESMTPS id 98A8F9315F;
        Wed, 13 Jul 2022 20:56:24 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 20:56:23 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 20:56:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Fan Du <fan.du@intel.com>
Subject: [PATCH v1 net 15/15] tcp: Fix a data-race around sysctl_tcp_probe_interval.
Date:   Wed, 13 Jul 2022 13:52:05 -0700
Message-ID: <20220713205205.15735-16-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713205205.15735-1-kuniyu@amazon.com>
References: <20220713205205.15735-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_probe_interval, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 05cbc0db03e8 ("ipv4: Create probe timer for tcp PMTU as per RFC4821")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Fan Du <fan.du@intel.com>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index aa757c74dad4..02ab3a9c6657 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2283,7 +2283,7 @@ static inline void tcp_mtu_check_reprobe(struct sock *sk)
 	u32 interval;
 	s32 delta;
 
-	interval = net->ipv4.sysctl_tcp_probe_interval;
+	interval = READ_ONCE(net->ipv4.sysctl_tcp_probe_interval);
 	delta = tcp_jiffies32 - icsk->icsk_mtup.probe_timestamp;
 	if (unlikely(delta >= interval * HZ)) {
 		int mss = tcp_current_mss(sk);
-- 
2.30.2

