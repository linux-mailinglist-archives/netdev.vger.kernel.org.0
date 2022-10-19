Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3CA60533B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiJSWhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiJSWg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:36:59 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78A5180266
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 15:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666219018; x=1697755018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2OEgZY1PDQSTzNnhxTwAbkCWpxCmvYOrygE796B1aJ8=;
  b=emXdJzQDmy9ls7zdZqH7VMq0joJXQlMP+SAejEZIMBM3EYcFHe3JhJ9p
   Q5GrToFmDMrzRlJbafJ5JFy593x1j5Iw96K897GidIEzpnhTiqk4yu8GG
   4+tw2a5z2oCR0uEEm1/VXa6IfQkMpXPC69dzFf1qvlUNKaIxNT5ZtnVDa
   4=;
X-IronPort-AV: E=Sophos;i="5.95,196,1661817600"; 
   d="scan'208";a="271336991"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 22:36:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id DA71981BC2;
        Wed, 19 Oct 2022 22:36:50 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 19 Oct 2022 22:36:50 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.213) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 19 Oct 2022 22:36:47 +0000
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
Subject: [PATCH v2 net-next 2/5] dccp: Call inet6_destroy_sock() via sk->sk_destruct().
Date:   Wed, 19 Oct 2022 15:36:00 -0700
Message-ID: <20221019223603.22991-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221019223603.22991-1-kuniyu@amazon.com>
References: <20221019223603.22991-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.213]
X-ClientProxiedBy: EX13D41UWC002.ant.amazon.com (10.43.162.127) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
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

