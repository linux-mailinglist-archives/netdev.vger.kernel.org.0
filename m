Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E0F603317
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 21:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJRTLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 15:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJRTLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 15:11:23 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB78F13F34
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 12:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666120283; x=1697656283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2OEgZY1PDQSTzNnhxTwAbkCWpxCmvYOrygE796B1aJ8=;
  b=pjs/u3JQ0thgRq5T8fdd8lmJm6iScUKULIsZ6Ha7Xz2eJIpBdIlONoh7
   HqWlgrHrMgbG4ptOQI/PZ2HPIDcVvbzdyZQlCSpUHhgePgS5LkxOIMmIH
   HKuGznaPrvlPp5mtrdcN9XBcb61qX28Yp+WqZqp21htvBYgcnYV3Rj+I6
   0=;
X-IronPort-AV: E=Sophos;i="5.95,194,1661817600"; 
   d="scan'208";a="256851889"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 19:11:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id 03D38C0B25;
        Tue, 18 Oct 2022 19:11:18 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 18 Oct 2022 19:11:18 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.214) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Tue, 18 Oct 2022 19:11:15 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 2/5] dccp: Call inet6_destroy_sock() via sk->sk_destruct().
Date:   Tue, 18 Oct 2022 12:09:53 -0700
Message-ID: <20221018190956.1308-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221018190956.1308-1-kuniyu@amazon.com>
References: <20221018190956.1308-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.214]
X-ClientProxiedBy: EX13D10UWB004.ant.amazon.com (10.43.161.121) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit d38afeec26ed ("tcp/udp: Call inet6_destroy_sock()
in IPv6 sk->sk_destruct()."), we call inet6_destroy_sock() in
sk->sk_destruct() by setting inet6_sock_destruct() to it to make
sure we do not leak inet6-specific resources.

DCCP sets its own sk->sk_destruct() in the dccp_init_sock(), and
DCCPv6 socket shares it by calling the same init function via
dccp_v6_init_sock().

To call inet6_sock_destruct() from DCCPv6 sk->sk_destruct(), we
export it and set dccp_v6_sk_destruct() in the init function.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/dccp/dccp.h     |  1 +
 net/dccp/ipv6.c     | 15 ++++++++-------
 net/dccp/proto.c    |  8 +++++++-
 net/ipv6/af_inet6.c |  1 +
 4 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 7dfc00c9fb32..9ddc3a9e89e4 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -278,6 +278,7 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 int dccp_rcv_established(struct sock *sk, struct sk_buff *skb,
 			 const struct dccp_hdr *dh, const unsigned int len);
 
+void dccp_destruct_common(struct sock *sk);
 int dccp_init_sock(struct sock *sk, const __u8 ctl_sock_initialized);
 void dccp_destroy_sock(struct sock *sk);
 
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index e57b43006074..ae62b1591dea 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -1021,6 +1021,12 @@ static const struct inet_connection_sock_af_ops dccp_ipv6_mapped = {
 	.sockaddr_len	   = sizeof(struct sockaddr_in6),
 };
 
+static void dccp_v6_sk_destruct(struct sock *sk)
+{
+	dccp_destruct_common(sk);
+	inet6_sock_destruct(sk);
+}
+
 /* NOTE: A lot of things set to zero explicitly by call to
  *       sk_alloc() so need not be done here.
  */
@@ -1033,17 +1039,12 @@ static int dccp_v6_init_sock(struct sock *sk)
 		if (unlikely(!dccp_v6_ctl_sock_initialized))
 			dccp_v6_ctl_sock_initialized = 1;
 		inet_csk(sk)->icsk_af_ops = &dccp_ipv6_af_ops;
+		sk->sk_destruct = dccp_v6_sk_destruct;
 	}
 
 	return err;
 }
 
-static void dccp_v6_destroy_sock(struct sock *sk)
-{
-	dccp_destroy_sock(sk);
-	inet6_destroy_sock(sk);
-}
-
 static struct timewait_sock_ops dccp6_timewait_sock_ops = {
 	.twsk_obj_size	= sizeof(struct dccp6_timewait_sock),
 };
@@ -1066,7 +1067,7 @@ static struct proto dccp_v6_prot = {
 	.accept		   = inet_csk_accept,
 	.get_port	   = inet_csk_get_port,
 	.shutdown	   = dccp_shutdown,
-	.destroy	   = dccp_v6_destroy_sock,
+	.destroy	   = dccp_destroy_sock,
 	.orphan_count	   = &dccp_orphan_count,
 	.max_header	   = MAX_DCCP_HEADER,
 	.obj_size	   = sizeof(struct dccp6_sock),
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index c548ca3e9b0e..9494b0d224f9 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -171,12 +171,18 @@ const char *dccp_packet_name(const int type)
 
 EXPORT_SYMBOL_GPL(dccp_packet_name);
 
-static void dccp_sk_destruct(struct sock *sk)
+void dccp_destruct_common(struct sock *sk)
 {
 	struct dccp_sock *dp = dccp_sk(sk);
 
 	ccid_hc_tx_delete(dp->dccps_hc_tx_ccid, sk);
 	dp->dccps_hc_tx_ccid = NULL;
+}
+EXPORT_SYMBOL_GPL(dccp_destruct_common);
+
+static void dccp_sk_destruct(struct sock *sk)
+{
+	dccp_destruct_common(sk);
 	inet_sock_destruct(sk);
 }
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 024191004982..6540551ea7ec 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -114,6 +114,7 @@ void inet6_sock_destruct(struct sock *sk)
 	inet6_cleanup_sock(sk);
 	inet_sock_destruct(sk);
 }
+EXPORT_SYMBOL_GPL(inet6_sock_destruct);
 
 static int inet6_create(struct net *net, struct socket *sock, int protocol,
 			int kern)
-- 
2.30.2

