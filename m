Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3377C2181
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 15:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbfI3NK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 09:10:29 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33568 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfI3NK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 09:10:29 -0400
Received: by mail-pg1-f196.google.com with SMTP id i30so7411535pgl.0;
        Mon, 30 Sep 2019 06:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=N+1RGFIRqicLhfN6/0DcU78v/um0zgUjklOT6WDb6Hk=;
        b=KK5WrwxnH8c7rhvN5gZQJOHme8GNEzf82fAtl4yMKft63iW9Afzzacji+WZC7CzV4K
         sLCr53HnJymaxpoGv/NiyGmhvzssJfO2K2ld+SLFEx4VYCZV+iH/RIfo3MqTyO0XeGjQ
         WXDhl+jZIlOzJaEUNJw4S3ET2jl8RC7n9hwP+RMFkAgOncGU2ECx15RsQdOtPr+ttsd1
         3x0TcwfJHofP7A3AaHNskZg+cUMVTIq5x2pwvUVfpt0/nJaSAwzCdrLs5uJUMMz18Z9M
         WF6cmartR+XNx+oJIFxZT+LELmct14fk+Ngv6F+guq2VQuw+JSxP/Y4fl82pIvRuWVZE
         moTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=N+1RGFIRqicLhfN6/0DcU78v/um0zgUjklOT6WDb6Hk=;
        b=lL9dp/TwRH5GADXfwXgCvyqOeVI86EF7wcZUFWgcEHjEQbzchhvlksRC+Y6/ZcFFUk
         XFrhOtpL4ZMlIBjJtNs6bafK1yTltYo/6b+gv/taNR87YyLA21gKm2e5nsEQM+ZlaFQP
         E7ZAoZcO+10qV7DPLfDvn9PFtjxGhNtnkD5fiqOTIM1ips+dk8mvw2vwJsXNijTh39y2
         ARZ8l0vbHffMf+QIPtE5k6SHn41m26bJiyTZZuR65uR6H1tgsc8ekEIyfFCQrvzcGhbq
         Xok7qBda/sAUpgjENocEoTPz7VzvRZ4K2cQpaPXtyXzy38Duk2oLFH8jrmClZmKvn8Ik
         B3yQ==
X-Gm-Message-State: APjAAAW/UWWtOdGYs2uvH8kteikRS06F0q4Nh3zHakhwziwQzTigV6N0
        RgEjZwy3qwBhFPYeGx3GeXjq5dZn
X-Google-Smtp-Source: APXvYqwrz4ztUM2bP6vGnEa6yyOiyxEknlwdrSb95UkRZAlw9QmcOFWveg3S7ezMsrzl+DCALFc87g==
X-Received: by 2002:a63:115c:: with SMTP id 28mr23969766pgr.69.1569849026393;
        Mon, 30 Sep 2019 06:10:26 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f128sm17669480pfg.143.2019.09.30.06.10.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 06:10:25 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: set newsk sk_socket before processing listening sk backlog
Date:   Mon, 30 Sep 2019 21:10:18 +0800
Message-Id: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to fix a NULL-ptr deref crash in selinux_sctp_bind_connect:

  [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
  [...] RIP: 0010:selinux_sctp_bind_connect+0x16a/0x230
  [...] Call Trace:
  [...]  security_sctp_bind_connect+0x58/0x90
  [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
  [...]  sctp_sf_do_asconf+0x782/0x980 [sctp]
  [...]  sctp_do_sm+0x139/0x520 [sctp]
  [...]  sctp_assoc_bh_rcv+0x284/0x5c0 [sctp]
  [...]  sctp_backlog_rcv+0x45f/0x880 [sctp]
  [...]  __release_sock+0x120/0x370
  [...]  release_sock+0x4f/0x180
  [...]  sctp_accept+0x3f9/0x5a0 [sctp]
  [...]  inet_accept+0xe7/0x6f0

It was caused by that the 'newsk' sk_socket was not set before going to
security sctp hook when doing accept() on a tcp-type socket:

  inet_accept()->
    sctp_accept():
      lock_sock():
          lock listening 'sk'
                                          do_softirq():
                                            sctp_rcv():  <-- [1]
                                                asconf chunk arrived and
                                                enqueued in 'sk' backlog
      sctp_sock_migrate():
          set asoc's sk to 'newsk'
      release_sock():
          sctp_backlog_rcv():
            lock 'newsk'
            sctp_process_asconf()  <-- [2]
            unlock 'newsk'
    sock_graft():
        set sk_socket  <-- [3]

As it shows, at [1] the asconf chunk would be put into the listening 'sk'
backlog, as accept() was holding its sock lock. Then at [2] asconf would
get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
would deref it, then kernel crashed.

Here to fix it by adding a new function sctp_inet_accept() for .accept(),
where it calls release_sock() on listening sk after sock_graft() in which
'newsk' sk_socket is set.

Note that TCPF_SYN_RECV flag check is removed in sctp_inet_accept(), as
sctp doesn't really use it.

Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h |  2 ++
 net/sctp/ipv6.c         |  2 +-
 net/sctp/protocol.c     |  2 +-
 net/sctp/socket.c       | 31 ++++++++++++++++++++++++++-----
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 5d60f13..be411a2 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -90,6 +90,8 @@ void sctp_addr_wq_mgmt(struct net *, struct sctp_sockaddr_entry *, int);
  */
 int sctp_inet_connect(struct socket *sock, struct sockaddr *uaddr,
 		      int addr_len, int flags);
+int sctp_inet_accept(struct socket *sock, struct socket *newsock,
+		     int flags, bool kern);
 int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb);
 int sctp_inet_listen(struct socket *sock, int backlog);
 void sctp_write_space(struct sock *sk);
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index e5f2fc7..529b930 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1011,7 +1011,7 @@ static const struct proto_ops inet6_seqpacket_ops = {
 	.bind		   = inet6_bind,
 	.connect	   = sctp_inet_connect,
 	.socketpair	   = sock_no_socketpair,
-	.accept		   = inet_accept,
+	.accept		   = sctp_inet_accept,
 	.getname	   = sctp_getname,
 	.poll		   = sctp_poll,
 	.ioctl		   = inet6_ioctl,
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 08d14d8..d796ba1 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1007,7 +1007,7 @@ static const struct proto_ops inet_seqpacket_ops = {
 	.bind		   = inet_bind,
 	.connect	   = sctp_inet_connect,
 	.socketpair	   = sock_no_socketpair,
-	.accept		   = inet_accept,
+	.accept		   = sctp_inet_accept,
 	.getname	   = inet_getname,	/* Semantics are different.  */
 	.poll		   = sctp_poll,
 	.ioctl		   = inet_ioctl,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 939b8d2..d7d93e8 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4878,8 +4878,6 @@ static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
 	long timeo;
 	int error = 0;
 
-	lock_sock(sk);
-
 	sp = sctp_sk(sk);
 	ep = sp->ep;
 
@@ -4920,11 +4918,36 @@ static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
 	}
 
 out:
-	release_sock(sk);
 	*err = error;
 	return newsk;
 }
 
+int sctp_inet_accept(struct socket *sock, struct socket *newsock,
+		     int flags, bool kern)
+{
+	struct sock *sk = sock->sk;
+	struct sock *newsk;
+	int err = 0;
+
+	lock_sock(sk);
+	newsk = sctp_accept(sk, flags, &err, kern);
+	if (!newsk)
+		goto do_err;
+
+	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
+	sock_rps_record_flow(newsk);
+	WARN_ON(!((1 << newsk->sk_state) &
+		  (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT | TCPF_CLOSE)));
+
+	sock_graft(newsk, newsock);
+	newsock->state = SS_CONNECTED;
+	release_sock(newsk);
+
+do_err:
+	release_sock(sk);
+	return err;
+}
+
 /* The SCTP ioctl handler. */
 static int sctp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
@@ -9487,7 +9510,6 @@ struct proto sctp_prot = {
 	.owner       =	THIS_MODULE,
 	.close       =	sctp_close,
 	.disconnect  =	sctp_disconnect,
-	.accept      =	sctp_accept,
 	.ioctl       =	sctp_ioctl,
 	.init        =	sctp_init_sock,
 	.destroy     =	sctp_destroy_sock,
@@ -9529,7 +9551,6 @@ struct proto sctpv6_prot = {
 	.owner		= THIS_MODULE,
 	.close		= sctp_close,
 	.disconnect	= sctp_disconnect,
-	.accept		= sctp_accept,
 	.ioctl		= sctp_ioctl,
 	.init		= sctp_init_sock,
 	.destroy	= sctp_v6_destroy_sock,
-- 
2.1.0

