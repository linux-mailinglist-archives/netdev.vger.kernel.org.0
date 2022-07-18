Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EEA578865
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiGRR3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbiGRR3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:29:04 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0502726
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658165343; x=1689701343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MwAbBmJpFboR3LpiDf8PwgL8l4xEkJFO5v+7NReY4KI=;
  b=HQYzz2+07P4l8i6YmHcJa0BOPc+knNK11ERwyjow2nenE0IYLtYpv1E7
   xg1kXR+YWLPuuR3XOPHVGiAXQpVhpBeZgHjzzSNvcZ5ni2CW+dnUQWmTW
   1wUqXeNRdG7GI9cQrCWZQCNrFpOMNIM3ovsA/6Tqbe6eV14lq+CG66ZrA
   Y=;
X-IronPort-AV: E=Sophos;i="5.92,281,1650931200"; 
   d="scan'208";a="1035321319"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 18 Jul 2022 17:29:02 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id B809543FE0;
        Mon, 18 Jul 2022 17:29:02 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 18 Jul 2022 17:29:02 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Mon, 18 Jul 2022 17:28:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH v1 net 08/15] tcp: Fix data-races around sysctl_tcp_recovery.
Date:   Mon, 18 Jul 2022 10:26:46 -0700
Message-ID: <20220718172653.22111-9-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718172653.22111-1-kuniyu@amazon.com>
References: <20220718172653.22111-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D04UWA004.ant.amazon.com (10.43.160.234) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_recovery, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 4f41b1c58a32 ("tcp: use RACK to detect losses")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Yuchung Cheng <ycheng@google.com>
---
 net/ipv4/tcp_input.c    | 3 ++-
 net/ipv4/tcp_recovery.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 92626e15115c..36eabd109e7c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2095,7 +2095,8 @@ static inline void tcp_init_undo(struct tcp_sock *tp)
 
 static bool tcp_is_rack(const struct sock *sk)
 {
-	return sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_LOSS_DETECTION;
+	return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+		TCP_RACK_LOSS_DETECTION;
 }
 
 /* If we detect SACK reneging, forget all SACK information
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index 48f30e7209f2..50abaa941387 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -14,7 +14,8 @@ static u32 tcp_rack_reo_wnd(const struct sock *sk)
 			return 0;
 
 		if (tp->sacked_out >= tp->reordering &&
-		    !(sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_NO_DUPTHRESH))
+		    !(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+		      TCP_RACK_NO_DUPTHRESH))
 			return 0;
 	}
 
@@ -187,7 +188,8 @@ void tcp_rack_update_reo_wnd(struct sock *sk, struct rate_sample *rs)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_STATIC_REO_WND ||
+	if ((READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+	     TCP_RACK_STATIC_REO_WND) ||
 	    !rs->prior_delivered)
 		return;
 
-- 
2.30.2

