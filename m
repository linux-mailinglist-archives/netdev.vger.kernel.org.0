Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795F557BBFC
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiGTQws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGTQwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:52:47 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51BA67CAB
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658335967; x=1689871967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g+Cz3OII+iwg8+Vu4fr9hg99eu2QF7tQiVpTJCogep8=;
  b=e4b9YvU8b+5rbVYw+KKDx77cSANbUeWTKxiSKwyzOz9dmGztRD4888wH
   dkzBqv0cHHOm7ufCaED71KpWgS9Fh5TOQQknKOiht2pv8pmZxpA9enGke
   VmU1P2awo3CXPDNN33DnAqtjv4G6Gs0PNTR1nni2uT80hsdfKPsvecwx1
   4=;
X-IronPort-AV: E=Sophos;i="5.92,286,1650931200"; 
   d="scan'208";a="240384625"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 20 Jul 2022 16:52:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com (Postfix) with ESMTPS id 585883602BC;
        Wed, 20 Jul 2022 16:52:45 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 20 Jul 2022 16:52:44 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 20 Jul 2022 16:52:42 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Rick Jones <rick.jones2@hp.com>
Subject: [PATCH v1 net 08/15] tcp: Fix data-races around sysctl_tcp_workaround_signed_windows.
Date:   Wed, 20 Jul 2022 09:50:19 -0700
Message-ID: <20220720165026.59712-9-kuniyu@amazon.com>
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

While reading sysctl_tcp_workaround_signed_windows, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 15d99e02baba ("[TCP]: sysctl to allow TCP window > 32767 sans wscale")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Rick Jones <rick.jones2@hp.com>
---
 net/ipv4/tcp_output.c | 4 ++--
 net/mptcp/options.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c38e07b50639..88f7d51e6691 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -230,7 +230,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	 * which we interpret as a sign the remote TCP is not
 	 * misinterpreting the window field as a signed quantity.
 	 */
-	if (sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows))
 		(*rcv_wnd) = min(space, MAX_TCP_WINDOW);
 	else
 		(*rcv_wnd) = min_t(u32, space, U16_MAX);
@@ -285,7 +285,7 @@ static u16 tcp_select_window(struct sock *sk)
 	 * scaled window.
 	 */
 	if (!tp->rx_opt.rcv_wscale &&
-	    sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows)
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows))
 		new_win = min(new_win, MAX_TCP_WINDOW);
 	else
 		new_win = min(new_win, (65535U << tp->rx_opt.rcv_wscale));
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index bd8f0f425be4..30d289044e71 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1271,7 +1271,7 @@ static void mptcp_set_rwin(struct tcp_sock *tp, struct tcphdr *th)
 		if (unlikely(th->syn))
 			new_win = min(new_win, 65535U) << tp->rx_opt.rcv_wscale;
 		if (!tp->rx_opt.rcv_wscale &&
-		    sock_net(ssk)->ipv4.sysctl_tcp_workaround_signed_windows)
+		    READ_ONCE(sock_net(ssk)->ipv4.sysctl_tcp_workaround_signed_windows))
 			new_win = min(new_win, MAX_TCP_WINDOW);
 		else
 			new_win = min(new_win, (65535U << tp->rx_opt.rcv_wscale));
-- 
2.30.2

