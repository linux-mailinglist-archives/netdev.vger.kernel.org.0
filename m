Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F300357E66C
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbiGVSXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235605AbiGVSXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:23:37 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACF39B186
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658514217; x=1690050217;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/RgBrDKz9VJ+CBIfsKEtlZyNDwTCUANHfREiywqY8a8=;
  b=JdUefkySogtemvynwEQtYi5lLqpKiO9egdeym1hPsWtFvitMbiJfv4xf
   RVD1rSfQhAfVJIBGoRrRaMU+3nINGoifgi17mDtOmRs1lwyR9CZ8UrFjY
   LEkhdXzc7ZazSJkqKPTEoRsdFqZJV9rQPAP//w/CdumjXPHIgkA6P8pDB
   c=;
X-IronPort-AV: E=Sophos;i="5.93,186,1654560000"; 
   d="scan'208";a="221500617"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 22 Jul 2022 18:23:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id 0603C4447B;
        Fri, 22 Jul 2022 18:23:24 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 22 Jul 2022 18:23:23 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 22 Jul 2022 18:23:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 3/7] tcp: Fix a data-race around sysctl_tcp_comp_sack_delay_ns.
Date:   Fri, 22 Jul 2022 11:22:01 -0700
Message-ID: <20220722182205.96838-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220722182205.96838-1-kuniyu@amazon.com>
References: <20220722182205.96838-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D13UWB004.ant.amazon.com (10.43.161.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_comp_sack_delay_ns, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 6d82aa242092 ("tcp: add tcp_comp_sack_delay_ns sysctl")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ff2e0d87aee4..813744180d87 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5542,7 +5542,8 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	if (tp->srtt_us && tp->srtt_us < rtt)
 		rtt = tp->srtt_us;
 
-	delay = min_t(unsigned long, sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns,
+	delay = min_t(unsigned long,
+		      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns),
 		      rtt * (NSEC_PER_USEC >> 3)/20);
 	sock_hold(sk);
 	hrtimer_start_range_ns(&tp->compressed_ack_timer, ns_to_ktime(delay),
-- 
2.30.2

