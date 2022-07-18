Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2E8578866
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbiGRR3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbiGRR3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:29:02 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9EB95
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658165343; x=1689701343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9cKiWCdAxZ8fEF2yVL7CQ0boCLkt3+SBbIIQ0ZkP6HQ=;
  b=VDuCtZW/L/lH4MDKr+DZv43fYYqqKOOCoNkV86364BzNmD2I9RTuF8we
   BkXu5pMBauaDAVRH6WTe1ahv514+gs/iBUI3YUnfz9C1DW7h0OY+Qp67W
   yymOqliik0MGMXMHZ4yDIdNx5qkRiFAJX8eCqOdtiP6fUPZUe7w9CwaJX
   U=;
X-IronPort-AV: E=Sophos;i="5.92,281,1650931200"; 
   d="scan'208";a="219631273"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 18 Jul 2022 17:28:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id 4C58B44581;
        Mon, 18 Jul 2022 17:28:48 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 18 Jul 2022 17:28:47 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Mon, 18 Jul 2022 17:28:45 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH v1 net 07/15] tcp: Fix a data-race around sysctl_tcp_early_retrans.
Date:   Mon, 18 Jul 2022 10:26:45 -0700
Message-ID: <20220718172653.22111-8-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_early_retrans, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: eed530b6c676 ("tcp: early retransmit")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Yuchung Cheng <ycheng@google.com>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 38a71e711edc..898fcdcb7989 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2741,7 +2741,7 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
 	if (rcu_access_pointer(tp->fastopen_rsk))
 		return false;
 
-	early_retrans = sock_net(sk)->ipv4.sysctl_tcp_early_retrans;
+	early_retrans = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_early_retrans);
 	/* Schedule a loss probe in 2*RTT for SACK capable connections
 	 * not in loss recovery, that are either limited by cwnd or application.
 	 */
-- 
2.30.2

