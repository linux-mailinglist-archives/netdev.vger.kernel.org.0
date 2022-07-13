Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E9A573E56
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbiGMUzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiGMUzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:55:42 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA868CD9
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657745742; x=1689281742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JnoZMpHX8KeNOJBEIxy39r9GDxWfGqEfOAwd/q2kkPs=;
  b=ZZ1Ipyu2sgri0caZHpo5RUdIDs/ybWGClrJYXP2rwkEnR+3Y6Uslcilz
   wIGpDQj1GBM4YQiZEBqWqtQhoW6NtAgdjOTm/wGnlTF0R1c88znmuvDeR
   A+gaPPlt938wlXBFQxstpxc+OsCBcsQn3EPhCOXeQ6bJz6xEMXf53VMQ6
   M=;
X-IronPort-AV: E=Sophos;i="5.92,269,1650931200"; 
   d="scan'208";a="217997742"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 13 Jul 2022 20:55:41 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com (Postfix) with ESMTPS id 48DAB200FE9;
        Wed, 13 Jul 2022 20:55:39 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 20:55:38 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 20:55:36 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 12/15] tcp: Fix data-races around sysctl_tcp_min_snd_mss.
Date:   Wed, 13 Jul 2022 13:52:02 -0700
Message-ID: <20220713205205.15735-13-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713205205.15735-1-kuniyu@amazon.com>
References: <20220713205205.15735-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_min_snd_mss, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 5f3e2bf008c2 ("tcp: add tcp_min_snd_mss sysctl")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/tcp_output.c | 3 ++-
 net/ipv4/tcp_timer.c  | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 9450d8469871..7130b405da21 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1719,7 +1719,8 @@ static inline int __tcp_mtu_to_mss(struct sock *sk, int pmtu)
 	mss_now -= icsk->icsk_ext_hdr_len;
 
 	/* Then reserve room for full set of TCP options and 8 bytes of data */
-	mss_now = max(mss_now, sock_net(sk)->ipv4.sysctl_tcp_min_snd_mss);
+	mss_now = max(mss_now,
+		      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_snd_mss));
 	return mss_now;
 }
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 04063c7e33ba..39107bb730b0 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -173,7 +173,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 		mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
 		mss = min(READ_ONCE(net->ipv4.sysctl_tcp_base_mss), mss);
 		mss = max(mss, net->ipv4.sysctl_tcp_mtu_probe_floor);
-		mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
+		mss = max(mss, READ_ONCE(net->ipv4.sysctl_tcp_min_snd_mss));
 		icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
 	}
 	tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
-- 
2.30.2

