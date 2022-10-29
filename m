Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19DF611E9F
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 02:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJ2ANJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 20:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJ2ANH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 20:13:07 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DEE10FCA
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 17:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667002386; x=1698538386;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1UogShvU+awvhIVy3LtxUuyyjc+1Haj6IYHuiJxceb8=;
  b=K4yaVpL9wX48s7Zh2SygBl3AuO4B586doGAvnsESCUEdHlBPgBcARXiv
   5HNpe2W9pm8xs8aXmWaRJUr31lmWVXT6Ky+cfx8FtAqF9uJR8b5P6D4z7
   Bvu/0GJ8LpwKrQniVFT2O1lf7nxF5u4jYjW58PMMXamtkTXr0tQu+EzJ4
   Y=;
X-IronPort-AV: E=Sophos;i="5.95,222,1661817600"; 
   d="scan'208";a="145577200"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 00:13:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com (Postfix) with ESMTPS id 3645B41ABD;
        Sat, 29 Oct 2022 00:13:00 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sat, 29 Oct 2022 00:13:00 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Sat, 29 Oct 2022 00:12:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "Mat Martineau" <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [RFC] bhash2 and WARN_ON() for inconsistent sk saddr.
Date:   Fri, 28 Oct 2022 17:12:49 -0700
Message-ID: <20221029001249.86337-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D08UWB004.ant.amazon.com (10.43.161.232) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I want to discuss bhash2 and WARN_ON() being fired every day this month
on my syzkaller instance without repro.

  WARNING: CPU: 0 PID: 209 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
  ...
  inet_csk_listen_start (net/ipv4/inet_connection_sock.c:1205)
  inet_listen (net/ipv4/af_inet.c:228)
  __sys_listen (net/socket.c:1810)
  __x64_sys_listen (net/socket.c:1819 net/socket.c:1817 net/socket.c:1817)
  do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)

For the very first implementation of bhash2, there was a similar report
hitting the same WARN_ON().  The fix was to update the bhash2 bucket when
the kernel changes sk->sk_rcv_saddr from INADDR_ANY.  Then, syzbot has a
repro, so we can indeed confirm that it no longer triggers the warning on
the latest kernel.

  https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.com/

However, Mat reported at that time that there were at least two variants,
the latter being the same as mine.

  https://lore.kernel.org/netdev/4bae9df4-42c1-85c3-d350-119a151d29@linux.intel.com/
  https://lore.kernel.org/netdev/23d8e9f4-016-7de1-9737-12c3146872ca@linux.intel.com/

This week I started looking into this issue and finally figured out
why we could not catch all cases with a single repro.

Please see the source addresses of s2/s3 below after connect() fails.
The s2 case is another variant of the first syzbot report, which has
been already _fixed_.  And the s3 case is a repro for the issue that
Mat and I saw.

  # sysctl -w net.ipv4.tcp_syn_retries=1
  net.ipv4.tcp_syn_retries = 1
  # python3
  >>> from socket import *
  >>> 
  >>> s1 = socket()
  >>> s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
  >>> s1.bind(('0.0.0.0', 10000))
  >>> s1.connect(('127.0.0.1', 10000))
  >>> 
  >>> s2 = socket()
  >>> s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
  >>> s2.bind(('0.0.0.0', 10000))
  >>> s2
  <socket.socket fd=4, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
  >>> 
  >>> s2.connect(('127.0.0.1', 10000))
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  OSError: [Errno 99] Cannot assign requested address
  >>> 
  >>> s2
  <socket.socket fd=4, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('127.0.0.1', 10000)>
                                                                                                   ^^^ ???
  >>> s3 = socket()
  >>> s3.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
  >>> s3.bind(('0.0.0.0', 10000))
  >>> s3
  <socket.socket fd=5, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
  >>> 
  >>> s3.connect(('0.0.0.1', 1))
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  TimeoutError: [Errno 110] Connection timed out
  >>> 
  >>> s3
  <socket.socket fd=5, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>

We can fire the WARN_ON() by s3.listen().

  >>> s3.listen()
  [ 1096.845905] ------------[ cut here ]------------
  [ 1096.846290] WARNING: CPU: 0 PID: 209 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port+0x6bb/0x9e0

In the s3 case, connect() resets sk->sk_rcv_saddr to INADDR_ANY without
updating the bhash2 bucket; OTOH sk has the correct non-NULL bhash bucket.
So, when we call listen() for s3, inet_csk_get_port() does not call
inet_bind_hash() and the WARN_ON() for bhash2 fires.

  if (!inet_csk(sk)->icsk_bind_hash)
  	inet_bind_hash(sk, tb, tb2, port);
  WARN_ON(inet_csk(sk)->icsk_bind_hash != tb);
  WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);

Here I think the s2 case also _should_ trigger WARN_ON().  The issue
seems to be fixed, but it's just because we forgot to _fix_ the source
address in error paths after inet6?_hash_connect() in tcp_v[46]_connect().
(Of course, DCCP as well).

In the s3 case, connect() falls into a different path.  We reach the
sock_error label in __inet_stream_connect() and call sk_prot->disconnect(),
which resets sk->sk_rcv_saddr.

Then, there could be two subsequent issues.

  * listen() leaks a newly allocated bhash2 bucket

  * In inet_put_port(), inet_bhashfn_portaddr() computes a wrong hash for
    inet_csk(sk)->icsk_bind2_hash, resulting in list corruption.

We can fix these easily but it still leaves inconsistent sockets in bhash2,
so we need to fix the root cause.

As a side note, this issue only happens when we bind() only port before
connect().  If we do not bind() port, tcp_set_state(sk, TCP_CLOSE) calls
inet_put_port() and unhashes the sk from bhash2.


At first, I applied the patch below so that both sk2 and sk3 trigger
WARN_ON().  Then, I tried two approaches:

  * Fix up the bhash2 entry when calling sk_rcv_saddr

  * Change the bhash2 entry only when connect() succeeds

The former does not work when we run out of memory.  When we change saddr
from INADDR_ANY, inet_bhash2_update_saddr() could free (INADDR_ANY, port)
bhash2 bucket.  Then, we possibly could not allocate it again when
restoring saddr in the failure path.

The latter does not work when a sk is in non-blocking mode.  In this case,
a user might not call the second connect() to fix up the bhash2 bucket.

  >>> s4 = socket()
  >>> s4.bind(('0.0.0.0', 10000))
  >>> s4.setblocking(False)
  >>> s4
  <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>

  >>> s4.connect(('0.0.0.1', 1))
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  BlockingIOError: [Errno 115] Operation now in progress
  >>> s4
  <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('10.0.2.15', 10000)>

Also, the former approach does not work for the non-blocking case.  Let's
say the second connect() fails.  What if we fail to allocate an INADDR_ANY
bhash2 bucket?  We have to change saddr to INADDR_ANY but cannot.... but
the connect() actually failed....??

  >>> s4.connect(('0.0.0.1', 1))
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  ConnectionRefusedError: [Errno 111] Connection refused
  >>> s4
  <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>


Now, I'm thinking bhash2 bucket needs a refcnt not to be freed while
refcnt is greater than 1.  And we need to change the conflict logic
so that the kernel ignores empty bhash2 bucket.  Such changes could
be big for the net tree, but the next LTS will likely be v6.1 which
has bhash2.

What do you think is the best way to fix the issue?

Thank you.


---8<---
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 713b7b8dad7e..40640c26680e 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -157,6 +157,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * This unhashes the socket and releases the local port, if necessary.
 	 */
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index e57b43006074..626166cb6d7e 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -985,6 +985,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	__sk_dst_reset(sk);
 failure:
 	inet->inet_dport = 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7a250ef9d1b7..834245da1e95 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -343,6 +343,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * if necessary.
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2a3f9296df1e..81b396e5cf79 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -359,6 +359,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 failure:
 	inet->inet_dport = 0;
 	sk->sk_route_caps = 0;
---8<---
