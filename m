Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37F960331E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 21:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJRTMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 15:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiJRTMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 15:12:31 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B03A28724
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 12:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666120326; x=1697656326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yRF8vr4+1FAv4K28NUJ/10tSt90WrJmQygCXE6WojyM=;
  b=BqnhDPMu1YJ35l5T172gHBz68rcWV2yGhiqOYRfjRhhMrFy8z4SXsdD8
   vzDojGpZq5zPJWO8QWNxTgBCETaBnRLdM4qFGnCtzTmUPxaQ3gV0Fw4o/
   uUse8UsFre80BwigxlyVdlo9u4+dGs3ecs1QBDHN1BTTtAefo5yoxiTwA
   4=;
X-IronPort-AV: E=Sophos;i="5.95,194,1661817600"; 
   d="scan'208";a="1065226414"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 19:11:55 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id 5B4B41A2AD3;
        Tue, 18 Oct 2022 19:11:52 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 18 Oct 2022 19:11:43 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.214) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Tue, 18 Oct 2022 19:11:40 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH v1 net-next 3/5] sctp: Call inet6_destroy_sock() via sk->sk_destruct().
Date:   Tue, 18 Oct 2022 12:09:54 -0700
Message-ID: <20221018190956.1308-4-kuniyu@amazon.com>
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

SCTP sets its own sk->sk_destruct() in the sctp_init_sock(), and
SCTPv6 socket reuses it as the init function.

To call inet6_sock_destruct() from SCTPv6 sk->sk_destruct(), we
set sctp_v6_destruct_sock() in a new init function.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
---
 net/sctp/socket.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 171f1a35d205..feeae29e96ad 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5098,13 +5098,17 @@ static void sctp_destroy_sock(struct sock *sk)
 }
 
 /* Triggered when there are no references on the socket anymore */
-static void sctp_destruct_sock(struct sock *sk)
+static void sctp_destruct_common(struct sock *sk)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	/* Free up the HMAC transform. */
 	crypto_free_shash(sp->hmac);
+}
 
+static void sctp_destruct_sock(struct sock *sk)
+{
+	sctp_destruct_common(sk);
 	inet_sock_destruct(sk);
 }
 
@@ -9427,7 +9431,7 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 	sctp_sk(newsk)->reuse = sp->reuse;
 
 	newsk->sk_shutdown = sk->sk_shutdown;
-	newsk->sk_destruct = sctp_destruct_sock;
+	newsk->sk_destruct = sk->sk_destruct;
 	newsk->sk_family = sk->sk_family;
 	newsk->sk_protocol = IPPROTO_SCTP;
 	newsk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;
@@ -9662,11 +9666,20 @@ struct proto sctp_prot = {
 
 #if IS_ENABLED(CONFIG_IPV6)
 
-#include <net/transp_v6.h>
-static void sctp_v6_destroy_sock(struct sock *sk)
+static void sctp_v6_destruct_sock(struct sock *sk)
+{
+	sctp_destruct_common(sk);
+	inet6_sock_destruct(sk);
+}
+
+static int sctp_v6_init_sock(struct sock *sk)
 {
-	sctp_destroy_sock(sk);
-	inet6_destroy_sock(sk);
+	int ret = sctp_init_sock(sk);
+
+	if (!ret)
+		sk->sk_destruct = sctp_v6_destruct_sock;
+
+	return ret;
 }
 
 struct proto sctpv6_prot = {
@@ -9676,8 +9689,8 @@ struct proto sctpv6_prot = {
 	.disconnect	= sctp_disconnect,
 	.accept		= sctp_accept,
 	.ioctl		= sctp_ioctl,
-	.init		= sctp_init_sock,
-	.destroy	= sctp_v6_destroy_sock,
+	.init		= sctp_v6_init_sock,
+	.destroy	= sctp_destroy_sock,
 	.shutdown	= sctp_shutdown,
 	.setsockopt	= sctp_setsockopt,
 	.getsockopt	= sctp_getsockopt,
-- 
2.30.2

