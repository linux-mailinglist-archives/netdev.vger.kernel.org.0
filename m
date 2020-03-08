Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84D317D570
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 19:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCHSRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 14:17:05 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:53508 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgCHSRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 14:17:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583691424; x=1615227424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=PhAn8Cftvli3LnbLzEEJWnBuBdexWvvymecj3+nlTh0=;
  b=rTJXFMhjpbw7QWBY9UZPcbR7K+pjIRdYAX9WS+8p7DIYFjKpEsh3fT1Q
   L+qfz/BoxSBFhdbpuc26cwHm387U4DlW7M/oxPE5EAco5sWdCfT63gqJ6
   tptjhhPPCYFENyzEU+nEhLmAkMcowAat6HuOXJHhJQXGqy6Gd3HGKV53k
   Y=;
IronPort-SDR: BiDr9v+MMhYOSMya3TDRYoOChM73+ug1bQObbe6/faf/WdcOLc1BBKnG3Tyfs/E7O+GffMLaSf
 eA9zWNP6hSZQ==
X-IronPort-AV: E=Sophos;i="5.70,530,1574121600"; 
   d="scan'208";a="20529942"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 08 Mar 2020 18:17:03 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 9A863A2316;
        Sun,  8 Mar 2020 18:17:01 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 8 Mar 2020 18:17:00 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.100) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 8 Mar 2020 18:16:56 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v4 net-next 3/5] tcp: Forbid to bind more than one sockets haveing SO_REUSEADDR and SO_REUSEPORT per EUID.
Date:   Mon, 9 Mar 2020 03:16:13 +0900
Message-ID: <20200308181615.90135-4-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200308181615.90135-1-kuniyu@amazon.co.jp>
References: <20200308181615.90135-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D22UWC001.ant.amazon.com (10.43.162.192) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is no TCP_LISTEN socket on a ephemeral port, we can bind multiple
sockets having SO_REUSEADDR to the same port. Then if all sockets bound to
the port have also SO_REUSEPORT enabled and have the same EUID, all of them
can be listened. This is not safe.

Let's say, an application has root privilege and binds sockets to an
ephemeral port with both of SO_REUSEADDR and SO_REUSEPORT. When none of
sockets is not listened yet, a malicious user can use sudo, exhaust
ephemeral ports, and bind sockets to the same ephemeral port, so he or she
can call listen and steal the port.

To prevent this issue, we must not bind more than one sockets that have the
same EUID and both of SO_REUSEADDR and SO_REUSEPORT.

On the other hand, if the sockets have different EUIDs, the issue above does
not occur. After sockets with different EUIDs are bound to the same port and
one of them is listened, no more socket can be listened. This is because the
condition below is evaluated true and listen() for the second socket fails.

			} else if (!reuseport_ok ||
				   !reuseport || !sk2->sk_reuseport ||
				   rcu_access_pointer(sk->sk_reuseport_cb) ||
				   (sk2->sk_state != TCP_TIME_WAIT &&
				    !uid_eq(uid, sock_i_uid(sk2)))) {
				if (inet_rcv_saddr_equal(sk, sk2, true))
					break;
			}

Therefore, on the same port, we cannot do listen() for multiple sockets with
different EUIDs and any other listen syscalls fail, so the problem does not
happen. In this case, we can still call connect() for other sockets that
cannot be listened, so we have to succeed to call bind() in order to fully
utilize 4-tuples.

Summarizing the above, we should be able to bind only one socket having
SO_REUSEADDR and SO_REUSEPORT per EUID.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/ipv4/inet_connection_sock.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index cddeab240ea6..d27ed5fe7147 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -131,7 +131,7 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 {
 	struct sock *sk2;
 	bool reuse = sk->sk_reuse;
-	bool reuseport = !!sk->sk_reuseport && reuseport_ok;
+	bool reuseport = !!sk->sk_reuseport;
 	kuid_t uid = sock_i_uid((struct sock *)sk);
 
 	/*
@@ -148,10 +148,16 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 		     sk->sk_bound_dev_if == sk2->sk_bound_dev_if)) {
 			if (reuse && sk2->sk_reuse &&
 			    sk2->sk_state != TCP_LISTEN) {
-				if (!relax &&
+				if ((!relax ||
+				     (!reuseport_ok &&
+				      reuseport && sk2->sk_reuseport &&
+				      !rcu_access_pointer(sk->sk_reuseport_cb) &&
+				      (sk2->sk_state == TCP_TIME_WAIT ||
+				       uid_eq(uid, sock_i_uid(sk2))))) &&
 				    inet_rcv_saddr_equal(sk, sk2, true))
 					break;
-			} else if (!reuseport || !sk2->sk_reuseport ||
+			} else if (!reuseport_ok ||
+				   !reuseport || !sk2->sk_reuseport ||
 				   rcu_access_pointer(sk->sk_reuseport_cb) ||
 				   (sk2->sk_state != TCP_TIME_WAIT &&
 				    !uid_eq(uid, sock_i_uid(sk2)))) {
-- 
2.17.2 (Apple Git-113)

