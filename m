Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEA3168B6D
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 02:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgBVBIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 20:08:11 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:56637 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgBVBIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 20:08:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582333690; x=1613869690;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=AB9M3YZXR45kOb+qaq+RFaPxYuiLA5eJqCK+xMy5j8A=;
  b=UU1/xHQ1qkrswPAOiDNhmPnXtEYJW/9MRpba8U2A/glt5PPtrFEMZBF8
   2xWVfjg0ai93Nal8KRrgysgT2bEp6BzkLS8YjmouNU9lcxCV40Rx7W3/i
   qX/6G5Q2zaSzFoBNKi9/vqlfJvfUJEH8N4CEUKDk552g10TXJxuTx71Qp
   I=;
IronPort-SDR: Hfjg+Z72ONNEOFE1/kRRpVpwzKIwDEbUKlJu95JK81bP0XiTvnexQnZSj3215QRji+iKH8mCKK
 Nsn7zsoskpvA==
X-IronPort-AV: E=Sophos;i="5.70,470,1574121600"; 
   d="scan'208";a="18116381"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 22 Feb 2020 01:08:09 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 0E202C122E;
        Sat, 22 Feb 2020 01:08:06 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 22 Feb 2020 01:08:06 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.160.108) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 22 Feb 2020 01:07:54 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuznet@ms2.inr.ac.ru>, <netdev@vger.kernel.org>,
        <osa-contribution-log@amazon.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 0/3] Improve bind(addr, 0) behaviour.
Date:   Sat, 22 Feb 2020 10:07:49 +0900
Message-ID: <20200222010749.75690-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200221203522.25716-1-kuniyu@amazon.co.jp>
References: <20200221203522.25716-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.108]
X-ClientProxiedBy: EX13D39UWB003.ant.amazon.com (10.43.161.215) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date:   Sat, 22 Feb 2020 05:35:22 +0900

> I wrote a program below and run without patches and with patches.
> Without patches, we cannot reuse ports in any pattern. With patches, we can
> reuse ports if all of the socket have SO_REUSEADDR enabled and the first
> socket is not in TCP_LISTEN.
> 
> So, I am sorry that the description of my third patch is wrong.
> 
> >     In this case, we should be able to bind sockets to the same port only if
> >     the user has the first listening socket on the port
> 
> Also, I succeeded to reuse ports if both sockets are in TCP_CLOSE and have
> SO_REUSEADDR and SO_REUSEPORT enabled, and I succeeded to call listen for
> both sockets. I think only this case is not safe, so let me check the
> condition.

I changed the condition and it works safely. (I made a mistake when
converting the condition following De Morgan's law.)

```
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index a6d9ee19baeb..d27ed5fe7147 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -152,8 +152,8 @@ static int inet_csk_bind_conflict(const struct sock *sk,
                                     (!reuseport_ok &&
                                      reuseport && sk2->sk_reuseport &&
                                      !rcu_access_pointer(sk->sk_reuseport_cb) &&
-                                     (sk2->sk_state != TCP_TIME_WAIT &&
-                                      !uid_eq(uid, sock_i_uid(sk2))))) &&
+                                     (sk2->sk_state == TCP_TIME_WAIT ||
+                                      uid_eq(uid, sock_i_uid(sk2))))) &&
                                    inet_rcv_saddr_equal(sk, sk2, true))
                                        break;
                        } else if (!reuseport_ok ||
```

===result of test===
both		none		none	10.0.2.15:32768		10.0.2.15:32768		o
both		none		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		none		sk2	10.0.2.15:32768		10.0.2.15:32768		o
both		none		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk2		none	10.0.2.15:32768		10.0.2.15:32768		o
both		sk2		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk2		sk2	10.0.2.15:32768		10.0.2.15:32768		o
both		sk2		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk1		none	10.0.2.15:32768		10.0.2.15:32768		o
both		sk1		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk1		sk2	10.0.2.15:32768		10.0.2.15:32768		o
both		sk1		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		both		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		both		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		both		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		both		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
====================


I also tested with two users. I am sorry about having tested in python,
I will rewrite it in C later.

Both of user-a and user-b can get the same port, but one of them failed to
call listen().

So, I think this patch is safe.

===user-a gets a port===
# su user-a
# whoami
user-a
# python3
...
>>> import socket
>>> sk1 = socket.socket()
>>> sk1.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
>>> sk1.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
>>> sk1.bind(('10.0.2.15', 0))
>>> sk1
<socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('10.0.2.15', 32768)>
========================

===user-b gets a port===
# su user-b
# whoami
user-b
# python3
...
>>> import socket
>>> sk2 = socket.socket()
>>> sk2.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
>>> sk2.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
>>> sk2.bind(('10.0.2.15', 0))
>>> sk2
<socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('10.0.2.15', 32768)>
========================


===user-a listen()===
>>> sk1.listen(5)
>>> sk1
<socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('10.0.2.15', 32768)>
=====================


===user-b listen() (failure)===
>>> sk2.listen(5)    
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
OSError: [Errno 98] Address already in use
===============================
