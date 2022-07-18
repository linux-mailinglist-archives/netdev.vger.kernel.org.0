Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE3E57886C
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbiGRR3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbiGRR3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:29:37 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C0295A9
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658165378; x=1689701378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M7+BLt2bZsZp9DGcBnCGLvAqgBgFOCj82ERS9PZSDMw=;
  b=kq4SCp6QgFkMmBcaO8I/C+BDldqiT2smWY0h60Ctm/u91gDn0Wq7PWok
   S6d60egocVg7bJTY2bbYRIWBHtPXkq4PlRTCp+qszfZ6OjgMm93OOSAAj
   XxjecOQ93FkLvCcT+C8uTVKG/aSTxWrQsiwTyMRHn1klt3V+78TDMKT59
   8=;
X-IronPort-AV: E=Sophos;i="5.92,281,1650931200"; 
   d="scan'208";a="239554964"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 18 Jul 2022 17:29:35 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id A4CC543FD9;
        Mon, 18 Jul 2022 17:29:33 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 18 Jul 2022 17:29:32 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Mon, 18 Jul 2022 17:29:30 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 10/15] tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.
Date:   Mon, 18 Jul 2022 10:26:48 -0700
Message-ID: <20220718172653.22111-11-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718172653.22111-1-kuniyu@amazon.com>
References: <20220718172653.22111-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D04UWA004.ant.amazon.com (10.43.160.234) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_slow_start_after_idle, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 35089bb203f4 ("[TCP]: Add tcp_slow_start_after_idle sysctl.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/tcp.h     | 4 ++--
 net/ipv4/tcp_output.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 6ee1fb4fb292..071735e10872 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1403,8 +1403,8 @@ static inline void tcp_slow_start_after_idle_check(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	s32 delta;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle || tp->packets_out ||
-	    ca_ops->cong_control)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle) ||
+	    tp->packets_out || ca_ops->cong_control)
 		return;
 	delta = tcp_jiffies32 - tp->lsndtime;
 	if (delta > inet_csk(sk)->icsk_rto)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 898fcdcb7989..51120407c570 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1898,7 +1898,7 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
 		if (tp->packets_out > tp->snd_cwnd_used)
 			tp->snd_cwnd_used = tp->packets_out;
 
-		if (sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle &&
+		if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle) &&
 		    (s32)(tcp_jiffies32 - tp->snd_cwnd_stamp) >= inet_csk(sk)->icsk_rto &&
 		    !ca_ops->cong_control)
 			tcp_cwnd_application_limited(sk);
-- 
2.30.2

