Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686BA41A443
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 02:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbhI1Aoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 20:44:30 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:30339 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238236AbhI1Ao3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 20:44:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1632789771; x=1664325771;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5tv2Jrm2pOn/W9HYgUZaSRmXjgz2T2NfhUyxiIvx8h8=;
  b=oH9qb5DW+ftKlnDtxYETWpHLXjuucVCDk8HE7yIaThbzpzDYH+tPE/ef
   v8O+X8M1sbKkyAN9KQ2cw+Xsju7HjxHwrL50OL2PCjmOmW2QWb/VH1eWZ
   NPGh4lNbXNNpQ2jmD7rA22o23kp49XnWj/PVOKhq7OKXdm6EowL3qb0ZX
   M=;
X-IronPort-AV: E=Sophos;i="5.85,328,1624320000"; 
   d="scan'208";a="140484686"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-5a6d5c37.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 28 Sep 2021 00:42:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-5a6d5c37.us-east-1.amazon.com (Postfix) with ESMTPS id E87D2C1C20;
        Tue, 28 Sep 2021 00:42:49 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 28 Sep 2021 00:42:49 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.137) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 28 Sep 2021 00:42:46 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net] af_unix: Return errno instead of NULL in unix_create1().
Date:   Tue, 28 Sep 2021 09:42:27 +0900
Message-ID: <20210928004227.9440-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D19UWC003.ant.amazon.com (10.43.162.184) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unix_create1() returns NULL on error, and the callers assume that it never
fails for reasons other than out of memory.  So, the callers always return
-ENOMEM when unix_create1() fails.

However, it also returns NULL when the number of af_unix sockets exceeds
twice the limit controlled by sysctl: fs.file-max.  In this case, the
callers should return -ENFILE like alloc_empty_file().

This patch changes unix_create1() to return the correct error value instead
of NULL on error.

Out of curiosity, the assumption has been wrong since 1999 due to this
change introduced in 2.2.4 [0].

  diff -u --recursive --new-file v2.2.3/linux/net/unix/af_unix.c linux/net/unix/af_unix.c
  --- v2.2.3/linux/net/unix/af_unix.c	Tue Jan 19 11:32:53 1999
  +++ linux/net/unix/af_unix.c	Sun Mar 21 07:22:00 1999
  @@ -388,6 +413,9 @@
   {
   	struct sock *sk;

  +	if (atomic_read(&unix_nr_socks) >= 2*max_files)
  +		return NULL;
  +
   	MOD_INC_USE_COUNT;
   	sk = sk_alloc(PF_UNIX, GFP_KERNEL, 1);
   	if (!sk) {

[0]: https://cdn.kernel.org/pub/linux/kernel/v2.2/patch-2.2.4.gz

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 49 ++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 92345c9bb60c..f505b89bda6a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -828,20 +828,25 @@ struct proto unix_stream_proto = {
 
 static struct sock *unix_create1(struct net *net, struct socket *sock, int kern, int type)
 {
-	struct sock *sk = NULL;
 	struct unix_sock *u;
+	struct sock *sk;
+	int err;
 
 	atomic_long_inc(&unix_nr_socks);
-	if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files())
-		goto out;
+	if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files()) {
+		err = -ENFILE;
+		goto err;
+	}
 
 	if (type == SOCK_STREAM)
 		sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_stream_proto, kern);
 	else /*dgram and  seqpacket */
 		sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_dgram_proto, kern);
 
-	if (!sk)
-		goto out;
+	if (!sk) {
+		err = -ENOMEM;
+		goto err;
+	}
 
 	sock_init_data(sock, sk);
 
@@ -861,20 +866,23 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	init_waitqueue_func_entry(&u->peer_wake, unix_dgram_peer_wake_relay);
 	memset(&u->scm_stat, 0, sizeof(struct scm_stat));
 	unix_insert_socket(unix_sockets_unbound(sk), sk);
-out:
-	if (sk == NULL)
-		atomic_long_dec(&unix_nr_socks);
-	else {
-		local_bh_disable();
-		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
-		local_bh_enable();
-	}
+
+	local_bh_disable();
+	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
+	local_bh_enable();
+
 	return sk;
+
+err:
+	atomic_long_dec(&unix_nr_socks);
+	return ERR_PTR(err);
 }
 
 static int unix_create(struct net *net, struct socket *sock, int protocol,
 		       int kern)
 {
+	struct sock *sk;
+
 	if (protocol && protocol != PF_UNIX)
 		return -EPROTONOSUPPORT;
 
@@ -901,7 +909,11 @@ static int unix_create(struct net *net, struct socket *sock, int protocol,
 		return -ESOCKTNOSUPPORT;
 	}
 
-	return unix_create1(net, sock, kern, sock->type) ? 0 : -ENOMEM;
+	sk = unix_create1(net, sock, kern, sock->type);
+	if (IS_ERR(sk))
+		return PTR_ERR(sk);
+
+	return 0;
 }
 
 static int unix_release(struct socket *sock)
@@ -1314,12 +1326,15 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	   we will have to recheck all again in any case.
 	 */
 
-	err = -ENOMEM;
-
 	/* create new sock for complete connection */
 	newsk = unix_create1(sock_net(sk), NULL, 0, sock->type);
-	if (newsk == NULL)
+	if (IS_ERR(newsk)) {
+		err = PTR_ERR(newsk);
+		newsk = NULL;
 		goto out;
+	}
+
+	err = -ENOMEM;
 
 	/* Allocate skb for sending to listening sock */
 	skb = sock_wmalloc(newsk, 1, 0, GFP_KERNEL);
-- 
2.30.2

