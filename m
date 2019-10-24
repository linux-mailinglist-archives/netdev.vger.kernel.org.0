Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573FCE2A0F
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437567AbfJXFpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:45:07 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:39016 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407031AbfJXFpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:45:06 -0400
Received: by mail-pg1-f201.google.com with SMTP id m20so16942179pgv.6
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 22:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=w+VRCv+biaGWl2paYVrz70wAhDsq7SW8AsIKcT79FBA=;
        b=tER1zHU1aJYWqiXoWl6ME3uO05GUgX2S+iZWhON+srg0qHJnCQ8zmMvju9whCC1mVP
         /cKuQu2paSJQewQc6UykSeqER2X2szfjjKywgrOnTfohvQjWeRFBJhsGAv8T3skAr5Ri
         aN7oQlex8We9B3yrxIiV4pI3IvA9wfFwZrspnJ93oVuvrVb2aQ89abfRMwPz9SV1hAG2
         MRDLEE5vMWS2X+ueqL1UFPo0pgjrWLELW5+K0COJlqIbTBOw09EHOmjcKplPxciLhGCY
         qWDKJuBrdzABT82q8Bw4bS04BBYiE3j44sKNZc6BxcwE/GWvLg3TRp/Zq4F8WCv/7Dzd
         GDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=w+VRCv+biaGWl2paYVrz70wAhDsq7SW8AsIKcT79FBA=;
        b=cWelMCh5a32wnF1QZNzdffKDSVsd0qCjbXjtedyPoxwfy5qJUqQG1ndEepASv1R/P9
         NrK6LjmvCW5OfX41qnlkfC7Z9y0q4eIz7tF3r3+9RUviuSZsCsWa4D1rebHrY3jg4PRF
         hSYuV2iSY3ouaXqW1GXkiaCYSCcDsc6t/cUaxG36V3Pml5t+Qracz+xDta8+PAbeBKr2
         f7j6jo0rNGyMskAKamJmmj3ssXoHAze0e2XlzHLYqfE2wd71mDBK5GVpIN9NYCjrrmw3
         XFkE6p0nqL0HQhFT3jxYfqUd8HrK2Yvluk+VIVZs+mpRi6ycBvf7h9i66pf7cMxzgSQw
         49YA==
X-Gm-Message-State: APjAAAXdrBSqTbHbplKM3DLUZdVDCWv/KS4Ui7x8DCQiFO0VX4481K6T
        T2mlchFiGqiKG+xxvoPAcE1vep6QixfFkw==
X-Google-Smtp-Source: APXvYqxYl6uTgd/KjQFJ9hKAL3GWeSMDNZ/1I7eaB3rP9XxIC0Ul9/Ucva57QUlfqU0tYb2QBzRgaml3yW9wQQ==
X-Received: by 2002:a65:498c:: with SMTP id r12mr12344120pgs.280.1571895904927;
 Wed, 23 Oct 2019 22:45:04 -0700 (PDT)
Date:   Wed, 23 Oct 2019 22:44:50 -0700
In-Reply-To: <20191024054452.81661-1-edumazet@google.com>
Message-Id: <20191024054452.81661-4-edumazet@google.com>
Mime-Version: 1.0
References: <20191024054452.81661-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH net 3/5] net: use skb_queue_empty_lockless() in poll() handlers
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many poll() handlers are lockless. Using skb_queue_empty_lockless()
instead of skb_queue_empty() is more appropriate.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/isdn/capi/capi.c     | 2 +-
 net/atm/common.c             | 2 +-
 net/bluetooth/af_bluetooth.c | 4 ++--
 net/caif/caif_socket.c       | 2 +-
 net/core/datagram.c          | 4 ++--
 net/decnet/af_decnet.c       | 2 +-
 net/ipv4/tcp.c               | 2 +-
 net/ipv4/udp.c               | 2 +-
 net/nfc/llcp_sock.c          | 4 ++--
 net/phonet/socket.c          | 4 ++--
 net/sctp/socket.c            | 4 ++--
 net/tipc/socket.c            | 4 ++--
 net/unix/af_unix.c           | 6 +++---
 net/vmw_vsock/af_vsock.c     | 2 +-
 14 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index c92b405b7646cfbceaed3b6544fb71d145c9bb42..ba8619524231ccde29093076e6196652d17dd69b 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -744,7 +744,7 @@ capi_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &(cdev->recvwait), wait);
 	mask = EPOLLOUT | EPOLLWRNORM;
-	if (!skb_queue_empty(&cdev->recvqueue))
+	if (!skb_queue_empty_lockless(&cdev->recvqueue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 	return mask;
 }
diff --git a/net/atm/common.c b/net/atm/common.c
index b7528e77997c88b7cf15f0b48412e3abef0620e3..0ce530af534ddfed26a32b1b24f202ee7c582198 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -668,7 +668,7 @@ __poll_t vcc_poll(struct file *file, struct socket *sock, poll_table *wait)
 		mask |= EPOLLHUP;
 
 	/* readable? */
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* writable? */
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 94ddf19998c7ee7098b52c9ef37f3e0296089fab..5f508c50649d0abc317ed83cc0768f6b7a64de96 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -460,7 +460,7 @@ __poll_t bt_sock_poll(struct file *file, struct socket *sock,
 	if (sk->sk_state == BT_LISTEN)
 		return bt_accept_poll(sk);
 
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
@@ -470,7 +470,7 @@ __poll_t bt_sock_poll(struct file *file, struct socket *sock,
 	if (sk->sk_shutdown == SHUTDOWN_MASK)
 		mask |= EPOLLHUP;
 
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	if (sk->sk_state == BT_CLOSED)
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 13ea920600aeb66af017134cbe5fcfd5ccc6020e..ef14da50a9819183c538f14b97b5e4986adafb45 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -953,7 +953,7 @@ static __poll_t caif_poll(struct file *file,
 		mask |= EPOLLRDHUP;
 
 	/* readable? */
-	if (!skb_queue_empty(&sk->sk_receive_queue) ||
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue) ||
 		(sk->sk_shutdown & RCV_SHUTDOWN))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
diff --git a/net/core/datagram.c b/net/core/datagram.c
index c210fc116103d9915a2a4abc5225e0eb75825b0b..5b685e110affab8f6d7cd3050ce88dfddb1357f5 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -767,7 +767,7 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 	mask = 0;
 
 	/* exceptional events? */
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
@@ -777,7 +777,7 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 		mask |= EPOLLHUP;
 
 	/* readable? */
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 0ea75286abf46ad9da2e6c58d4facc91f731b8bf..3349ea81f9016fb785ec888fadf86faa4d859ed7 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -1205,7 +1205,7 @@ static __poll_t dn_poll(struct file *file, struct socket *sock, poll_table  *wai
 	struct dn_scp *scp = DN_SK(sk);
 	__poll_t mask = datagram_poll(file, sock, wait);
 
-	if (!skb_queue_empty(&scp->other_receive_queue))
+	if (!skb_queue_empty_lockless(&scp->other_receive_queue))
 		mask |= EPOLLRDBAND;
 
 	return mask;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 42187a3b82f4f6280d831c34d9ca6b7bcffc191f..ffef502f52920170478d9fd000a507659e17de15 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -584,7 +584,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	}
 	/* This barrier is coupled with smp_wmb() in tcp_reset() */
 	smp_rmb();
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR;
 
 	return mask;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2cc259736c2e0d10f16dcd5333925e2a369843b9..345a3d43f5a655e009e99c16bb19e047cdf003c6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2712,7 +2712,7 @@ __poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	__poll_t mask = datagram_poll(file, sock, wait);
 	struct sock *sk = sock->sk;
 
-	if (!skb_queue_empty(&udp_sk(sk)->reader_queue))
+	if (!skb_queue_empty_lockless(&udp_sk(sk)->reader_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Check for false positives due to checksum errors */
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index ccdd790e163a81d0be5c69842fb3d25a57c743c4..28604414dec1b7d03f0d175cc87c10e0922c7043 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -554,11 +554,11 @@ static __poll_t llcp_sock_poll(struct file *file, struct socket *sock,
 	if (sk->sk_state == LLCP_LISTEN)
 		return llcp_accept_poll(sk);
 
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	if (sk->sk_state == LLCP_CLOSED)
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 96ea9f254ae90ae957f800566b05a7f75d13948f..76d499f6af9ab32aa17422ef911497585b6649b7 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -338,9 +338,9 @@ static __poll_t pn_socket_poll(struct file *file, struct socket *sock,
 
 	if (sk->sk_state == TCP_CLOSE)
 		return EPOLLERR;
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
-	if (!skb_queue_empty(&pn->ctrlreq_queue))
+	if (!skb_queue_empty_lockless(&pn->ctrlreq_queue))
 		mask |= EPOLLPRI;
 	if (!mask && sk->sk_state == TCP_CLOSE_WAIT)
 		return EPOLLHUP;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5ca0ec0e823c4a7c62e794a05129fbd80ff29331..cfb25391b8b0fb66b77db995933103007113aa32 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8476,7 +8476,7 @@ __poll_t sctp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	mask = 0;
 
 	/* Is there any exceptional events?  */
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
@@ -8485,7 +8485,7 @@ __poll_t sctp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		mask |= EPOLLHUP;
 
 	/* Is it readable?  Reconsider this code with TCP-style support.  */
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* The association is either gone or not ready.  */
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index f8bbc4aab21397ecb184a6b869327a5b124cb7e4..4b92b196cfa668c9ee59b9dae4e83bb7b5b5ba3d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -740,7 +740,7 @@ static __poll_t tipc_poll(struct file *file, struct socket *sock,
 		/* fall through */
 	case TIPC_LISTEN:
 	case TIPC_CONNECTING:
-		if (!skb_queue_empty(&sk->sk_receive_queue))
+		if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 			revents |= EPOLLIN | EPOLLRDNORM;
 		break;
 	case TIPC_OPEN:
@@ -748,7 +748,7 @@ static __poll_t tipc_poll(struct file *file, struct socket *sock,
 			revents |= EPOLLOUT;
 		if (!tipc_sk_type_connectionless(sk))
 			break;
-		if (skb_queue_empty(&sk->sk_receive_queue))
+		if (skb_queue_empty_lockless(&sk->sk_receive_queue))
 			break;
 		revents |= EPOLLIN | EPOLLRDNORM;
 		break;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 67e87db5877f1132b52b0c93d349983873fec38f..0d8da809bea2e6053c6bd5687ae19ab3f3ca617a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2599,7 +2599,7 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 		mask |= EPOLLRDHUP | EPOLLIN | EPOLLRDNORM;
 
 	/* readable? */
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
@@ -2628,7 +2628,7 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 	mask = 0;
 
 	/* exceptional events? */
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
@@ -2638,7 +2638,7 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 		mask |= EPOLLHUP;
 
 	/* readable? */
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 2ab43b2bba31bca91de7fe7840c487e07683a922..582a3e4dfce295fa67100468335bc8dbf8dc1095 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -870,7 +870,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 		 * the queue and write as long as the socket isn't shutdown for
 		 * sending.
 		 */
-		if (!skb_queue_empty(&sk->sk_receive_queue) ||
+		if (!skb_queue_empty_lockless(&sk->sk_receive_queue) ||
 		    (sk->sk_shutdown & RCV_SHUTDOWN)) {
 			mask |= EPOLLIN | EPOLLRDNORM;
 		}
-- 
2.23.0.866.gb869b98d4c-goog

