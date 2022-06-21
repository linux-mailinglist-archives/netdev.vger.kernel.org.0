Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B351D5538C4
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 19:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353204AbiFURUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 13:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbiFURUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 13:20:06 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C1C24F00
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 10:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655832005; x=1687368005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bbsoaTkErfZYqhCXfb/FH4xhJEo1JYSAL1s+JkiyIgw=;
  b=dBGQdXuL0eMx0Mbeo2Ceu5ovMhwT9e468JN4jNKZ5K7BR6XnKYhJoCf0
   fHRZuSBR6tYl40MEiMuvoc0PiBv7e7QUB1xh4G92Aj/wiryR1nhwf9uIo
   PXKH/QjsXOwnoMum5sZm+MVMKQ8fhBmyd7sggx0eYOpCA7QEWiqQF++yI
   4=;
X-IronPort-AV: E=Sophos;i="5.92,209,1650931200"; 
   d="scan'208";a="210320181"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-1c3c2014.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 21 Jun 2022 17:19:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-1c3c2014.us-east-1.amazon.com (Postfix) with ESMTPS id 72993C85F1;
        Tue, 21 Jun 2022 17:19:51 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 21 Jun 2022 17:19:50 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.29) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 21 Jun 2022 17:19:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Amit Shah <aams@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 1/6] af_unix: Clean up some sock_net() uses.
Date:   Tue, 21 Jun 2022 10:19:08 -0700
Message-ID: <20220621171913.73401-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220621171913.73401-1-kuniyu@amazon.com>
References: <20220621171913.73401-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.29]
X-ClientProxiedBy: EX13D12UWC002.ant.amazon.com (10.43.162.253) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some functions define a net pointer only for one-shot use.  Others call
sock_net() redundantly even when a net pointer is available.  Let's fix
these and make the code simpler.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/unix/af_unix.c | 33 ++++++++++++++-------------------
 net/unix/diag.c    |  3 +--
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3453e0053f76..990257f02e7c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -932,7 +932,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	memset(&u->scm_stat, 0, sizeof(struct scm_stat));
 	unix_insert_unbound_socket(sk);
 
-	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
+	sock_prot_inuse_add(net, sk->sk_prot, 1);
 
 	return sk;
 
@@ -1293,9 +1293,8 @@ static void unix_state_double_unlock(struct sock *sk1, struct sock *sk2)
 static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 			      int alen, int flags)
 {
-	struct sock *sk = sock->sk;
-	struct net *net = sock_net(sk);
 	struct sockaddr_un *sunaddr = (struct sockaddr_un *)addr;
+	struct sock *sk = sock->sk;
 	struct sock *other;
 	int err;
 
@@ -1316,7 +1315,7 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		}
 
 restart:
-		other = unix_find_other(net, sunaddr, alen, sock->type);
+		other = unix_find_other(sock_net(sk), sunaddr, alen, sock->type);
 		if (IS_ERR(other)) {
 			err = PTR_ERR(other);
 			goto out;
@@ -1404,15 +1403,13 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 			       int addr_len, int flags)
 {
 	struct sockaddr_un *sunaddr = (struct sockaddr_un *)uaddr;
-	struct sock *sk = sock->sk;
-	struct net *net = sock_net(sk);
+	struct sock *sk = sock->sk, *newsk = NULL, *other = NULL;
 	struct unix_sock *u = unix_sk(sk), *newu, *otheru;
-	struct sock *newsk = NULL;
-	struct sock *other = NULL;
+	struct net *net = sock_net(sk);
 	struct sk_buff *skb = NULL;
-	int st;
-	int err;
 	long timeo;
+	int err;
+	int st;
 
 	err = unix_validate_addr(sunaddr, addr_len);
 	if (err)
@@ -1432,7 +1429,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	 */
 
 	/* create new sock for complete connection */
-	newsk = unix_create1(sock_net(sk), NULL, 0, sock->type);
+	newsk = unix_create1(net, NULL, 0, sock->type);
 	if (IS_ERR(newsk)) {
 		err = PTR_ERR(newsk);
 		newsk = NULL;
@@ -1840,17 +1837,15 @@ static void scm_stat_del(struct sock *sk, struct sk_buff *skb)
 static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			      size_t len)
 {
-	struct sock *sk = sock->sk;
-	struct net *net = sock_net(sk);
-	struct unix_sock *u = unix_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_un *, sunaddr, msg->msg_name);
-	struct sock *other = NULL;
-	int err;
-	struct sk_buff *skb;
-	long timeo;
+	struct sock *sk = sock->sk, *other = NULL;
+	struct unix_sock *u = unix_sk(sk);
 	struct scm_cookie scm;
+	struct sk_buff *skb;
 	int data_len = 0;
 	int sk_locked;
+	long timeo;
+	int err;
 
 	wait_for_unix_gc();
 	err = scm_send(sock, msg, &scm, false);
@@ -1917,7 +1912,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		if (sunaddr == NULL)
 			goto out_free;
 
-		other = unix_find_other(net, sunaddr, msg->msg_namelen,
+		other = unix_find_other(sock_net(sk), sunaddr, msg->msg_namelen,
 					sk->sk_type);
 		if (IS_ERR(other)) {
 			err = PTR_ERR(other);
diff --git a/net/unix/diag.c b/net/unix/diag.c
index bb0b5ea1655f..4e3dc8179fa4 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -308,7 +308,6 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 static int unix_diag_handler_dump(struct sk_buff *skb, struct nlmsghdr *h)
 {
 	int hdrlen = sizeof(struct unix_diag_req);
-	struct net *net = sock_net(skb->sk);
 
 	if (nlmsg_len(h) < hdrlen)
 		return -EINVAL;
@@ -317,7 +316,7 @@ static int unix_diag_handler_dump(struct sk_buff *skb, struct nlmsghdr *h)
 		struct netlink_dump_control c = {
 			.dump = unix_diag_dump,
 		};
-		return netlink_dump_start(net->diag_nlsk, skb, h, &c);
+		return netlink_dump_start(sock_net(skb->sk)->diag_nlsk, skb, h, &c);
 	} else
 		return unix_diag_get_exact(skb, h, nlmsg_data(h));
 }
-- 
2.30.2

