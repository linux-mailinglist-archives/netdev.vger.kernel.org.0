Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DC062FF16
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 22:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiKRVAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 16:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiKRVAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 16:00:36 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EED7C683;
        Fri, 18 Nov 2022 13:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668805236; x=1700341236;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xo7YlfY0qWLMxaDrAnEG7OrDJP628JDokAkG5VJqxcM=;
  b=m+AsxNByITerXBbUldLa3opIrH1tORfpospdd+PSE8+9MFxEi351/CzJ
   IcVH/rBXR7Dk4wOusR/5LPxHdxw38M7Xvl5IbkeKgMqAznh6++sbPzess
   8PKPrlj+GJjUuPwYjPERmRA8+e6d4vKUm0AyqRn5FuNYUweZ/H2LD/xEA
   s=;
X-IronPort-AV: E=Sophos;i="5.96,175,1665446400"; 
   d="scan'208";a="268394035"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 21:00:35 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com (Postfix) with ESMTPS id B42F5825E3;
        Fri, 18 Nov 2022 21:00:33 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 18 Nov 2022 21:00:32 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 18 Nov 2022 21:00:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Arnaldo Carvalho de Melo <acme@mandriva.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "Mat Martineau" <mathew.j.martineau@linux.intel.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <dccp@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH v3 net 4/4] dccp/tcp: Fixup bhash2 bucket when connect() fails.
Date:   Fri, 18 Nov 2022 12:58:39 -0800
Message-ID: <20221118205839.14312-5-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221118205839.14312-1-kuniyu@amazon.com>
References: <20221118205839.14312-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D40UWA002.ant.amazon.com (10.43.160.149) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a socket bound to a wildcard address fails to connect(), we
only reset saddr and keep the port.  Then, we have to fix up the
bhash2 bucket; otherwise, the bucket has an inconsistent address
in the list.

Also, listen() for such a socket will fire the WARN_ON() in
inet_csk_get_port(). [0]

Note that when a system runs out of memory, we give up fixing the
bucket and unlink sk from bhash and bhash2 by inet_put_port().

[0]:
WARNING: CPU: 0 PID: 207 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
Modules linked in:
CPU: 0 PID: 207 Comm: bhash2_prev_rep Not tainted 6.1.0-rc3-00799-gc8421681c845 #63
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.amzn2022.0.1 04/01/2014
RIP: 0010:inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
Code: 74 a7 eb 93 48 8b 54 24 18 0f b7 cb 4c 89 e6 4c 89 ff e8 48 b2 ff ff 49 8b 87 18 04 00 00 e9 32 ff ff ff 0f 0b e9 34 ff ff ff <0f> 0b e9 42 ff ff ff 41 8b 7f 50 41 8b 4f 54 89 fe 81 f6 00 00 ff
RSP: 0018:ffffc900003d7e50 EFLAGS: 00010202
RAX: ffff8881047fb500 RBX: 0000000000004e20 RCX: 0000000000000000
RDX: 000000000000000a RSI: 00000000fffffe00 RDI: 00000000ffffffff
RBP: ffffffff8324dc00 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000004e20 R15: ffff8881054e1280
FS:  00007f8ac04dc740(0000) GS:ffff88842fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001540 CR3: 00000001055fa003 CR4: 0000000000770ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 inet_csk_listen_start (net/ipv4/inet_connection_sock.c:1205)
 inet_listen (net/ipv4/af_inet.c:228)
 __sys_listen (net/socket.c:1810)
 __x64_sys_listen (net/socket.c:1819 net/socket.c:1817 net/socket.c:1817)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
RIP: 0033:0x7f8ac051de5d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 af 1b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffc1c177248 EFLAGS: 00000206 ORIG_RAX: 0000000000000032
RAX: ffffffffffffffda RBX: 0000000020001550 RCX: 00007f8ac051de5d
RDX: ffffffffffffff80 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007ffc1c177270 R08: 0000000000000018 R09: 0000000000000007
R10: 0000000020001540 R11: 0000000000000206 R12: 00007ffc1c177388
R13: 0000000000401169 R14: 0000000000403e18 R15: 00007f8ac0723000
 </TASK>

Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/inet_hashtables.h |  1 +
 net/dccp/ipv4.c               |  3 +--
 net/dccp/ipv6.c               |  3 +--
 net/dccp/proto.c              |  3 +--
 net/ipv4/inet_hashtables.c    | 35 ++++++++++++++++++++++++++++++++---
 net/ipv4/tcp.c                |  3 +--
 net/ipv4/tcp_ipv4.c           |  3 +--
 net/ipv6/tcp_ipv6.c           |  3 +--
 8 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index ba06e8b52264..69174093078f 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -282,6 +282,7 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
  * rcv_saddr field should already have been updated when this is called.
  */
 int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family);
+void inet_bhash2_reset_saddr(struct sock *sk);
 
 void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
 		    struct inet_bind2_bucket *tb2, unsigned short port);
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 95e376e3b911..b780827f5e0a 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -143,8 +143,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * This unhashes the socket and releases the local port, if necessary.
 	 */
 	dccp_set_state(sk, DCCP_CLOSED);
-	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
-		inet_reset_saddr(sk);
+	inet_bhash2_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 94c101ed57a9..602f3432d80b 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -970,8 +970,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	dccp_set_state(sk, DCCP_CLOSED);
-	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
-		inet_reset_saddr(sk);
+	inet_bhash2_reset_saddr(sk);
 	__sk_dst_reset(sk);
 failure:
 	inet->inet_dport = 0;
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index c548ca3e9b0e..85e35c5e8890 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -279,8 +279,7 @@ int dccp_disconnect(struct sock *sk, int flags)
 
 	inet->inet_dport = 0;
 
-	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
-		inet_reset_saddr(sk);
+	inet_bhash2_reset_saddr(sk);
 
 	sk->sk_shutdown = 0;
 	sock_reset_flag(sk, SOCK_DONE);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index fce0bd62d6b5..e657da6dced0 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -871,7 +871,7 @@ static void inet_update_saddr(struct sock *sk, void *saddr, int family)
 #endif
 }
 
-int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
+static int __inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family, bool reset)
 {
 	struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
 	struct inet_bind_hashbucket *head, *head2;
@@ -883,7 +883,11 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
 
 	if (!inet_csk(sk)->icsk_bind2_hash) {
 		/* Not bind()ed before. */
-		inet_update_saddr(sk, saddr, family);
+		if (reset)
+			inet_reset_saddr(sk);
+		else
+			inet_update_saddr(sk, saddr, family);
+
 		goto out;
 	}
 
@@ -901,6 +905,16 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
 	 */
 	new_tb2 = kmem_cache_alloc(hinfo->bind2_bucket_cachep, GFP_ATOMIC);
 	if (!new_tb2) {
+		if (reset) {
+			/* The (INADDR_ANY, port) bucket might have already
+			 * been freed, then we cannot fixup icsk_bind2_hash,
+			 * so we give up and unlink sk from bhash/bhash2 not
+			 * to leave inconsistency in bhash2.
+			 */
+			inet_put_port(sk);
+			inet_reset_saddr(sk);
+		}
+
 		err = -ENOMEM;
 		goto unlock;
 	}
@@ -912,7 +926,10 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
 	inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep, inet_csk(sk)->icsk_bind2_hash);
 	spin_unlock(&head2->lock);
 
-	inet_update_saddr(sk, saddr, family);
+	if (reset)
+		inet_reset_saddr(sk);
+	else
+		inet_update_saddr(sk, saddr, family);
 
 	head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
 
@@ -934,8 +951,20 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
 out:
 	return err;
 }
+
+int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
+{
+	return __inet_bhash2_update_saddr(sk, saddr, family, false);
+}
 EXPORT_SYMBOL_GPL(inet_bhash2_update_saddr);
 
+void inet_bhash2_reset_saddr(struct sock *sk)
+{
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		__inet_bhash2_update_saddr(sk, NULL, 0, true);
+}
+EXPORT_SYMBOL_GPL(inet_bhash2_reset_saddr);
+
 /* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 54836a6b81d6..4f2205756cfe 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3114,8 +3114,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 
 	inet->inet_dport = 0;
 
-	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
-		inet_reset_saddr(sk);
+	inet_bhash2_reset_saddr(sk);
 
 	sk->sk_shutdown = 0;
 	sock_reset_flag(sk, SOCK_DONE);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 23dd7e9df2d5..da46357f501b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -331,8 +331,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * if necessary.
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
-	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
-		inet_reset_saddr(sk);
+	inet_bhash2_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2f3ca3190d26..f0548dbcabd2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -346,8 +346,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	tcp_set_state(sk, TCP_CLOSE);
-	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
-		inet_reset_saddr(sk);
+	inet_bhash2_reset_saddr(sk);
 failure:
 	inet->inet_dport = 0;
 	sk->sk_route_caps = 0;
-- 
2.30.2

