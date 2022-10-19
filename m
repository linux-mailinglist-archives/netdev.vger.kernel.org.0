Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AB860533D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiJSWhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiJSWhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:37:11 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3F817D876;
        Wed, 19 Oct 2022 15:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666219030; x=1697755030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BMeLSvu1DpmYi8IuBXOW7jiOZ4bH0NkBYhuA5wTQDsU=;
  b=UeeiYgYvGcnwHli7j5R4n/2Gtsw6lJdeEA1foVECdNb7DZEWGrBq8+Yp
   DFPF8HoPfDmy9SUkVhuimVzscy30sykUK0PgFvT203Rzo8+bRnYBfYLeS
   XNUeq4jB41srA/esFiv7wvW0laMFcbGl1eM4SmQO9ucBqyNMS3UkwQVFf
   A=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 22:37:07 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com (Postfix) with ESMTPS id 0231F6111B;
        Wed, 19 Oct 2022 22:37:05 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 19 Oct 2022 22:37:05 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.213) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 19 Oct 2022 22:37:02 +0000
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
        Neil Horman <nhorman@tuxdriver.com>,
        <linux-sctp@vger.kernel.org>
Subject: [PATCH v2 net-next 3/5] sctp: Call inet6_destroy_sock() via sk->sk_destruct().
Date:   Wed, 19 Oct 2022 15:36:01 -0700
Message-ID: <20221019223603.22991-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221019223603.22991-1-kuniyu@amazon.com>
References: <20221019223603.22991-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.213]
X-ClientProxiedBy: EX13D41UWC002.ant.amazon.com (10.43.162.127) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Cc: linux-sctp@vger.kernel.org
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

