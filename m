Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247AA57BBEF
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiGTQvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiGTQvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:51:24 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC90A67591
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658335879; x=1689871879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oikQsVrRki3oJ7wLT6L/Cf9H5IEfJ9si9DIUGrH5rnw=;
  b=Bky8yRvXG8SJPN8FQ3sCPTyH2oUPliZikuBaxH5agL/SH1LkhNetVKig
   uMvxvKpwvCW2e58MpbpiWGuX6nBiM2EovXDv+RLnGUybElzUnTPFP06lF
   hvr/Kgal3y15jiKZrOShTAei2oILWcRuktMZcr89UrZFxfAesE814F2NY
   8=;
X-IronPort-AV: E=Sophos;i="5.92,286,1650931200"; 
   d="scan'208";a="211579014"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 20 Jul 2022 16:51:19 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com (Postfix) with ESMTPS id 406EAC094E;
        Wed, 20 Jul 2022 16:51:16 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 20 Jul 2022 16:51:15 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 20 Jul 2022 16:51:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 02/15] tcp: Fix a data-race around sysctl_tcp_app_win.
Date:   Wed, 20 Jul 2022 09:50:13 -0700
Message-ID: <20220720165026.59712-3-kuniyu@amazon.com>
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

While reading sysctl_tcp_app_win, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6fdad9505396..8cf4fbd349ab 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -534,7 +534,7 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
  */
 static void tcp_init_buffer_space(struct sock *sk)
 {
-	int tcp_app_win = sock_net(sk)->ipv4.sysctl_tcp_app_win;
+	int tcp_app_win = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_app_win);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int maxwin;
 
-- 
2.30.2

