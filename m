Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149495ED200
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbiI1A23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiI1A2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:28:24 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635A6112676;
        Tue, 27 Sep 2022 17:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664324902; x=1695860902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JpC+VIgFCKMP4Dco+OF4SIAfPdUi+cxpvQFmjgko8JU=;
  b=gGSWRyF0PvKArJAt8OnWWRBfUL4qFN9YuSPjPpGgJ7gVtFbDslOisrlH
   omX81JZpqVYqnaPRHKzD+ItUQKad0gFXlNoFBCOgvxJD2xUAAw1IL2FYC
   oRJPwXv6O/5gMiWWTNMeRaU7xzZPNTo3wKmm0AEAoXJFfm3SZaqsr+Y5f
   I=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 00:28:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com (Postfix) with ESMTPS id 3834B81256;
        Wed, 28 Sep 2022 00:28:08 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 28 Sep 2022 00:28:07 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.58) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Wed, 28 Sep 2022 00:28:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <linux-kernel@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
Subject: [PATCH v2 net 1/5] tcp/udp: Fix memory leak in ipv6_renew_options().
Date:   Tue, 27 Sep 2022 17:27:37 -0700
Message-ID: <20220928002741.64237-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220928002741.64237-1-kuniyu@amazon.com>
References: <20220928002741.64237-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.58]
X-ClientProxiedBy: EX13D13UWB004.ant.amazon.com (10.43.161.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a memory leak [0] related to IPV6_ADDRFORM.

The scenario is that while one thread is converting an IPv6 socket into
IPv4 with IPV6_ADDRFORM, another thread calls do_ipv6_setsockopt() and
allocates memory to inet6_sk(sk)->XXX after conversion.

Then, the converted sk with (tcp|udp)_prot never frees the IPv6 resources,
which inet6_destroy_sock() should have cleaned up.

setsockopt(IPV6_ADDRFORM)                 setsockopt(IPV6_DSTOPTS)
+-----------------------+                 +----------------------+
- do_ipv6_setsockopt(sk, ...)
  - lock_sock(sk)                         - do_ipv6_setsockopt(sk, ...)
  - WRITE_ONCE(sk->sk_prot, &tcp_prot)      ^._ called via tcpv6_prot
  - xchg(&np->opt, NULL)                        before WRITE_ONCE()
  - txopt_put(opt)
  - release_sock(sk)
                                            - lock_sock(sk)
                                            - ipv6_set_opt_hdr(sk, ...)
                                              - ipv6_update_options(sk, opt)
                                                - xchg(&inet6_sk(sk)->opt, opt)
                                                  ^._ opt is never freed.

                                            - release_sock(sk)

Since IPV6_DSTOPTS allocates options under lock_sock(), we can avoid this
memory leak by testing whether sk_family is changed by IPV6_ADDRFORM after
acquiring the lock.

This issue exists from the initial commit between IPV6_ADDRFORM and
IPV6_PKTOPTIONS.

[0]:
BUG: memory leak
unreferenced object 0xffff888009ab9f80 (size 96):
  comm "syz-executor583", pid 328, jiffies 4294916198 (age 13.034s)
  hex dump (first 32 bytes):
    01 00 00 00 48 00 00 00 08 00 00 00 00 00 00 00  ....H...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002ee98ae1>] kmalloc include/linux/slab.h:605 [inline]
    [<000000002ee98ae1>] sock_kmalloc+0xb3/0x100 net/core/sock.c:2566
    [<0000000065d7b698>] ipv6_renew_options+0x21e/0x10b0 net/ipv6/exthdrs.c:1318
    [<00000000a8c756d7>] ipv6_set_opt_hdr net/ipv6/ipv6_sockglue.c:354 [inline]
    [<00000000a8c756d7>] do_ipv6_setsockopt.constprop.0+0x28b7/0x4350 net/ipv6/ipv6_sockglue.c:668
    [<000000002854d204>] ipv6_setsockopt+0xdf/0x190 net/ipv6/ipv6_sockglue.c:1021
    [<00000000e69fdcf8>] tcp_setsockopt+0x13b/0x2620 net/ipv4/tcp.c:3789
    [<0000000090da4b9b>] __sys_setsockopt+0x239/0x620 net/socket.c:2252
    [<00000000b10d192f>] __do_sys_setsockopt net/socket.c:2263 [inline]
    [<00000000b10d192f>] __se_sys_setsockopt net/socket.c:2260 [inline]
    [<00000000b10d192f>] __x64_sys_setsockopt+0xbe/0x160 net/socket.c:2260
    [<000000000a80d7aa>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<000000000a80d7aa>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
    [<000000004562b5c6>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv6/ipv6_sockglue.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index e0dcc7a193df..b61066ac8648 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -419,6 +419,12 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		rtnl_lock();
 	lock_sock(sk);
 
+	/* Another thread has converted the socket into IPv4 with
+	 * IPV6_ADDRFORM concurrently.
+	 */
+	if (unlikely(sk->sk_family != AF_INET6))
+		goto unlock;
+
 	switch (optname) {
 
 	case IPV6_ADDRFORM:
@@ -994,6 +1000,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 	}
 
+unlock:
 	release_sock(sk);
 	if (needs_rtnl)
 		rtnl_unlock();
-- 
2.30.2

