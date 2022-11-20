Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1C263132C
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 10:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiKTJJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 04:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKTJJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 04:09:47 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECC98F3DC
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 01:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668935385; x=1700471385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LvLRtFPaan5gE4b9PgmIVWJFVG/QQpSQaG+ZzjS5aK8=;
  b=oJY8iko4v3iwKrOrz/PTZDytKt/DCXqhbAM0bgObP1ojXBWF+30Vq6LV
   eJK34q1AsqGj+tg+/Ot65lxB4Ob3MwMBZnAjRYw79Aw5EcyvCYh49MB31
   DD8YLKExFZnqF/FGXV79cSozuB/awfxzyssQg9JpVx8ixnu51RNOOF6vH
   8=;
X-IronPort-AV: E=Sophos;i="5.96,179,1665446400"; 
   d="scan'208";a="281939831"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 09:09:41 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id 634D44166C;
        Sun, 20 Nov 2022 09:09:40 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sun, 20 Nov 2022 09:09:38 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Sun, 20 Nov 2022 09:09:36 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <tkhai@ya.ru>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH net] unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()
Date:   Sun, 20 Nov 2022 01:09:28 -0800
Message-ID: <20221120090928.30474-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <38a920a7-cfba-7929-886d-c3c6effc0c43@ya.ru>
References: <38a920a7-cfba-7929-886d-c3c6effc0c43@ya.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D45UWA001.ant.amazon.com (10.43.160.91) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kirill Tkhai <tkhai@ya.ru>
Date:   Sun, 20 Nov 2022 02:16:47 +0300
> There is a race resulting in alive SOCK_SEQPACKET socket
> may change its state from TCP_ESTABLISHED to TCP_CLOSE:
> 
> unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
>   sock_orphan(peer)
>     sock_set_flag(peer, SOCK_DEAD)
>                                            sock_alloc_send_pskb()
>                                              if !(sk->sk_shutdown & SEND_SHUTDOWN)
>                                                OK
>                                            if sock_flag(peer, SOCK_DEAD)
>                                              sk->sk_state = TCP_CLOSE
>   sk->sk_shutdown = SHUTDOWN_MASK
> 
> 
> After that socket sk remains almost normal: it is able to connect, listen, accept
> and recvmsg, while it can't sendmsg.

nit: Then, also recvmsg() fails with -ENOTCONN.  And after connect(), even
both of recvmsg() and sendmsg() does not fail.

static int unix_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
				  size_t size, int flags)
{
	struct sock *sk = sock->sk;

	if (sk->sk_state != TCP_ESTABLISHED)
		return -ENOTCONN;

	return unix_dgram_recvmsg(sock, msg, size, flags);
}


> 
> Since this is the only possibility for alive SOCK_SEQPACKET to change
> the state in such way, we should better fix this strange and potentially
> danger corner case.
> 
> Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock.
> 
> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>

Fixes tag is needed:

Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")

Before this commit, there was no state change and SEQPACKET sk also went
through the same path.  The bug was introduced because the commit did not
consider SEAPACKET.

So, I think the fix should be like below, then we can free the peer faster.
Note unix_dgram_peer_wake_disconnect_wakeup() is dgram-specific too.

---8<---
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index b3545fc68097..be40023a61fb 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2001,11 +2001,14 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		err = 0;
 		if (unix_peer(sk) == other) {
 			unix_peer(sk) = NULL;
-			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
+
+			if (sk->sk_type == SOCK_DGRAM) {
+				unix_dgram_peer_wake_disconnect_wakeup(sk, other);
+				sk->sk_state = TCP_CLOSE;
+			}
 
 			unix_state_unlock(sk);
 
-			sk->sk_state = TCP_CLOSE;
 			unix_dgram_disconnected(sk, other);
 			sock_put(other);
 			err = -ECONNREFUSED;
---8<---

Also, it's better to mention that moving TCP_CLOSE under the lock resolves
another rare race with unix_dgram_connect() for DGRAM sk:

  unix_state_unlock(sk);
  <--------------------------> connect() could set TCP_ESTABLISHED here.
  sk->sk_state = TCP_CLOSE;


Thank you!


> ---
>  net/unix/af_unix.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index b3545fc68097..6fd745cfc492 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1999,13 +1999,20 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>  			unix_state_lock(sk);
>  
>  		err = 0;
> -		if (unix_peer(sk) == other) {
> +		if (sk->sk_type == SOCK_SEQPACKET) {
> +			/* We are here only when racing with unix_release_sock()
> +			 * is clearing @other. Never change state to TCP_CLOSE
> +			 * unlike SOCK_DGRAM wants.
> +			 */
> +			unix_state_unlock(sk);
> +			err = -EPIPE;
> +		} else if (unix_peer(sk) == other) {
>  			unix_peer(sk) = NULL;
>  			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
>  
> +			sk->sk_state = TCP_CLOSE;
>  			unix_state_unlock(sk);
>  
> -			sk->sk_state = TCP_CLOSE;
>  			unix_dgram_disconnected(sk, other);
>  			sock_put(other);
>  			err = -ECONNREFUSED;
