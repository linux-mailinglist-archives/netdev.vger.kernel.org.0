Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F87257BC01
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbiGTQxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbiGTQxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:53:19 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC48A68DDE
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658335998; x=1689871998;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z0ec3b2AXZTvY4943LKhmO/wRh/cB4eXUD//3PNvk1Y=;
  b=vP90fFwtjcRTVhP2rNP09siBWehyim1SOL0VodHug69uQEgsLX8bpDDV
   HoC9mE5xzpd/8iMedFxjRTV/wotv/QZC9/IRJVc+FXKoQRBQyJ1gzL7DR
   dauXZ5g+bToaCK74oV8S4cstAqOY5QMxqDJD5MA9ZeaLkot3xtH26SwVQ
   0=;
X-IronPort-AV: E=Sophos;i="5.92,286,1650931200"; 
   d="scan'208";a="211579520"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-f771ae83.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 20 Jul 2022 16:53:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-f771ae83.us-east-1.amazon.com (Postfix) with ESMTPS id 42F45121708;
        Wed, 20 Jul 2022 16:53:16 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 20 Jul 2022 16:53:15 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 20 Jul 2022 16:53:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 10/15] tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.
Date:   Wed, 20 Jul 2022 09:50:21 -0700
Message-ID: <20220720165026.59712-11-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720165026.59712-1-kuniyu@amazon.com>
References: <20220720165026.59712-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D10UWA004.ant.amazon.com (10.43.160.64) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_challenge_ack_limit, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 282f23c6ee34 ("tcp: implement RFC 5961 3.2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index debfff94f3af..d386a69b1c05 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3629,7 +3629,7 @@ static void tcp_send_challenge_ack(struct sock *sk)
 	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
 	if (now != challenge_timestamp) {
-		u32 ack_limit = net->ipv4.sysctl_tcp_challenge_ack_limit;
+		u32 ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
 		u32 half = (ack_limit + 1) >> 1;
 
 		challenge_timestamp = now;
-- 
2.30.2

