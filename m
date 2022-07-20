Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554F057BBFD
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbiGTQxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGTQxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:53:04 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D8612AA0
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658335984; x=1689871984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M+WVNOTQm3Pq03bkKPiF2KUL3WWCca0UKDvX6OwPPHM=;
  b=J80VVOMmCWicVaQ5CRRi1X+QTcZ87Fl6MeEASc1/IXPgLZDsTEKk7Za1
   ZoXbHx97su4cqvY2Vz9QKm9zDxosWY4zEsVgSM81Thel7xEkDhPVRX6r5
   Yr+RLZ96WICeFOftLKDIXuO8z7vGXRpo7wHhKLyjqwNmYF3hYYpKM4Khy
   g=;
X-IronPort-AV: E=Sophos;i="5.92,286,1650931200"; 
   d="scan'208";a="240384706"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-8bf71a74.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 20 Jul 2022 16:53:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-8bf71a74.us-east-1.amazon.com (Postfix) with ESMTPS id D316EC17C7;
        Wed, 20 Jul 2022 16:53:00 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 20 Jul 2022 16:52:59 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 20 Jul 2022 16:52:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 09/15] tcp: Fix a data-race around sysctl_tcp_limit_output_bytes.
Date:   Wed, 20 Jul 2022 09:50:20 -0700
Message-ID: <20220720165026.59712-10-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720165026.59712-1-kuniyu@amazon.com>
References: <20220720165026.59712-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D10UWA004.ant.amazon.com (10.43.160.64) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_limit_output_bytes, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 46d3ceabd8d9 ("tcp: TCP Small Queues")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 88f7d51e6691..80c9bed73337 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2507,7 +2507,7 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift));
 	if (sk->sk_pacing_status == SK_PACING_NONE)
 		limit = min_t(unsigned long, limit,
-			      sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes);
+			      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes));
 	limit <<= factor;
 
 	if (static_branch_unlikely(&tcp_tx_delay_enabled) &&
-- 
2.30.2

