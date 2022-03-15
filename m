Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED44DA283
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 19:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351103AbiCOSkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 14:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351116AbiCOSkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 14:40:51 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192AC3BA53
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 11:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647369578; x=1678905578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i9kHH3N2YgDgJx4J4nZNq8O3J1myq6j/lLoTD9s0gIw=;
  b=JxcD4AmWltQBdS5bNQJmAt8gHFfH8MRg9WnsGamqgBfy8BbaQIE27ONA
   ZfzIyJWP59nxaNwX5q2u40Oh08oSl14LbiVZcAUt30yP49w1LBlLlGLBg
   9N/Mg4ENc9lzcMyY6Kc34G9ewa+emo6GjuDeyXyMnrRUwXdlVf+S0eGpR
   A=;
X-IronPort-AV: E=Sophos;i="5.90,184,1643673600"; 
   d="scan'208";a="182187628"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 15 Mar 2022 18:39:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com (Postfix) with ESMTPS id 59AA9C086B;
        Tue, 15 Mar 2022 18:39:34 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Tue, 15 Mar 2022 18:39:33 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.124) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 15 Mar 2022 18:39:30 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rao Shoaib <Rao.Shoaib@oracle.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net 1/2] af_unix: Fix some data-races around unix_sk(sk)->oob_skb.
Date:   Wed, 16 Mar 2022 03:38:54 +0900
Message-ID: <20220315183855.15190-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315183855.15190-1-kuniyu@amazon.co.jp>
References: <20220315183855.15190-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.124]
X-ClientProxiedBy: EX13D19UWA003.ant.amazon.com (10.43.160.170) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Out-of-band data automatically places a "mark" showing wherein the
sequence the out-of-band data would have been.  If the out-of-band data
implies cancelling everything sent so far, the "mark" is helpful to flush
them.  When the socket's read pointer reaches the "mark", the ioctl() below
sets a non zero value to the arg `atmark`:

The out-of-band data is queued in sk->sk_receive_queue as well as ordinary
data and also saved in unix_sk(sk)->oob_skb.  It can be used to test if the
head of the receive queue is the out-of-band data meaning the socket is at
the "mark".

While testing that, unix_ioctl() reads unix_sk(sk)->oob_skb locklessly.
Thus, all accesses to oob_skb need some basic protection to avoid
load/store tearing which KCSAN detects when these are called concurrently:

  - ioctl(fd_a, SIOCATMARK, &atmark, sizeof(atmark))
  - send(fd_b_connected_to_a, buf, sizeof(buf), MSG_OOB)

BUG: KCSAN: data-race in unix_ioctl / unix_stream_sendmsg

write to 0xffff888003d9cff0 of 8 bytes by task 175 on cpu 1:
 unix_stream_sendmsg (net/unix/af_unix.c:2087 net/unix/af_unix.c:2191)
 sock_sendmsg (net/socket.c:705 net/socket.c:725)
 __sys_sendto (net/socket.c:2040)
 __x64_sys_sendto (net/socket.c:2048)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113)

read to 0xffff888003d9cff0 of 8 bytes by task 176 on cpu 0:
 unix_ioctl (net/unix/af_unix.c:3101 (discriminator 1))
 sock_do_ioctl (net/socket.c:1128)
 sock_ioctl (net/socket.c:1242)
 __x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:874 fs/ioctl.c:860 fs/ioctl.c:860)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113)

value changed: 0xffff888003da0c00 -> 0xffff888003da0d00

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 176 Comm: unix_race_oob_i Not tainted 5.17.0-rc5-59529-g83dc4c2af682 #12
Hardware name: Red Hat KVM, BIOS 1.11.0-2.amzn2 04/01/2014

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c19569819866..0c37e5595aae 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2084,7 +2084,7 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	if (ousk->oob_skb)
 		consume_skb(ousk->oob_skb);
 
-	ousk->oob_skb = skb;
+	WRITE_ONCE(ousk->oob_skb, skb);
 
 	scm_stat_add(other, skb);
 	skb_queue_tail(&other->sk_receive_queue, skb);
@@ -2602,9 +2602,8 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 
 	oob_skb = u->oob_skb;
 
-	if (!(state->flags & MSG_PEEK)) {
-		u->oob_skb = NULL;
-	}
+	if (!(state->flags & MSG_PEEK))
+		WRITE_ONCE(u->oob_skb, NULL);
 
 	unix_state_unlock(sk);
 
@@ -2639,7 +2638,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 				skb = NULL;
 			} else if (sock_flag(sk, SOCK_URGINLINE)) {
 				if (!(flags & MSG_PEEK)) {
-					u->oob_skb = NULL;
+					WRITE_ONCE(u->oob_skb, NULL);
 					consume_skb(skb);
 				}
 			} else if (!(flags & MSG_PEEK)) {
@@ -3094,11 +3093,10 @@ static int unix_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	case SIOCATMARK:
 		{
 			struct sk_buff *skb;
-			struct unix_sock *u = unix_sk(sk);
 			int answ = 0;
 
 			skb = skb_peek(&sk->sk_receive_queue);
-			if (skb && skb == u->oob_skb)
+			if (skb && skb == READ_ONCE(unix_sk(sk)->oob_skb))
 				answ = 1;
 			err = put_user(answ, (int __user *)arg);
 		}
-- 
2.30.2

