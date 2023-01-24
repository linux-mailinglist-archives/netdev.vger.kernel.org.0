Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60AA667A0A6
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjAXR5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjAXR53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:57:29 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CAEF747
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674583048; x=1706119048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q6mZGtXaprTdTZXfLd3GrYswEjSDNWzFDSrxCga35rA=;
  b=lyJkjz+ZuchfkVJKhilbBLvOe4ACmkAG3U9wOkLw3FV0i0rBt+NBXp/y
   SeO2BkkWqZchXp9FKZIZitFSLuvKcehvW03yDXC6PjOqL9XzFjnkNMrTR
   F2ijhNVMpysrSzmZ/yjtvFoZl1kjB3gbB6yH7/dMKQNtVgCRJc8yBWMBI
   Q=;
X-IronPort-AV: E=Sophos;i="5.97,243,1669075200"; 
   d="scan'208";a="174624371"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 17:57:25 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com (Postfix) with ESMTPS id 27B18416B6;
        Tue, 24 Jan 2023 17:57:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 24 Jan 2023 17:57:24 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Tue, 24 Jan 2023 17:57:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <tkhai@ya.ru>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <gorcunov@gmail.com>,
        <kuba@kernel.org>, <kuniyu@amazon.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH net-next] unix: Guarantee sk_state relevance in case of it was assigned by a task on other cpu
Date:   Tue, 24 Jan 2023 09:57:12 -0800
Message-ID: <20230124175712.38112-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
References: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D37UWA002.ant.amazon.com (10.43.160.211) To
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

From:   Kirill Tkhai <tkhai@ya.ru>
Date:   Mon, 23 Jan 2023 01:21:20 +0300
> Some functions use unlocked check for sock::sk_state. This does not guarantee
> a new value assigned to sk_state on some CPU is already visible on this CPU.
> 
> Example:
> 
> [CPU0:Task0]                    [CPU1:Task1]
> unix_listen()
>   unix_state_lock(sk);
>   sk->sk_state = TCP_LISTEN;
>   unix_state_unlock(sk);
>                                 unix_accept()
>                                   if (sk->sk_state != TCP_LISTEN) /* not visible */
>                                      goto out;                    /* return error */
> 
> Task1 may miss new sk->sk_state value, and then unix_accept() returns error.
> Since in this situation unix_accept() is called chronologically later, such
> behavior is not obvious and it is wrong.

Have you seen this on a real workload ?

It sounds like a userspace bug that accept() is called on a different
CPU before listen() returns.  At least, accept() is fetching sk at the
same time, then I think there should be no guarantee that sk_state is
TCP_LISTEN.

Same for other TCP_ESTABLISHED tests, it seems a program is calling
sendmsg()/recvmsg() when sk is still TCP_CLOSE and betting concurrent
connect() will finish earlier.


> 
> This patch aims to fix the problem. A new function unix_sock_state() is
> introduced, and it makes sure a user never misses a new state assigned just
> before the function is called. We will use it in the places, where unlocked
> sk_state dereferencing was used before.
> 
> Note, that there remain some more places with sk_state unfixed. Also, the same
> problem is with unix_peer(). This will be a subject for future patches.
> 
> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> ---
>  net/unix/af_unix.c |   43 +++++++++++++++++++++++++++++++------------
>  1 file changed, 31 insertions(+), 12 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 009616fa0256..f53e09a0753b 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -247,6 +247,28 @@ struct sock *unix_peer_get(struct sock *s)
>  }
>  EXPORT_SYMBOL_GPL(unix_peer_get);
>  
> +/* This function returns current sk->sk_state guaranteeing
> + * its relevance in case of assignment was made on other CPU.
> + */
> +static unsigned char unix_sock_state(struct sock *sk)
> +{
> +	unsigned char s_state = READ_ONCE(sk->sk_state);
> +
> +	/* SOCK_STREAM and SOCK_SEQPACKET sockets never change their
> +	 * sk_state after switching to TCP_ESTABLISHED or TCP_LISTEN.
> +	 * We may avoid taking the lock in case of those states are
> +	 * already visible.
> +	 */
> +	if ((s_state == TCP_ESTABLISHED || s_state == TCP_LISTEN)
> +	    && sk->sk_type != SOCK_DGRAM)
> +		return s_state;
> +
> +	unix_state_lock(sk);
> +	s_state = sk->sk_state;
> +	unix_state_unlock(sk);
> +	return s_state;
> +}
> +
>  static struct unix_address *unix_create_addr(struct sockaddr_un *sunaddr,
>  					     int addr_len)
>  {
> @@ -812,13 +834,9 @@ static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
>  	int nr_fds = 0;
>  
>  	if (sk) {
> -		s_state = READ_ONCE(sk->sk_state);
> +		s_state = unix_sock_state(sk);
>  		u = unix_sk(sk);
>  
> -		/* SOCK_STREAM and SOCK_SEQPACKET sockets never change their
> -		 * sk_state after switching to TCP_ESTABLISHED or TCP_LISTEN.
> -		 * SOCK_DGRAM is ordinary. So, no lock is needed.
> -		 */
>  		if (sock->type == SOCK_DGRAM || s_state == TCP_ESTABLISHED)
>  			nr_fds = atomic_read(&u->scm_stat.nr_fds);
>  		else if (s_state == TCP_LISTEN)
> @@ -1686,7 +1704,7 @@ static int unix_accept(struct socket *sock, struct socket *newsock, int flags,
>  		goto out;
>  
>  	err = -EINVAL;
> -	if (sk->sk_state != TCP_LISTEN)
> +	if (unix_sock_state(sk) != TCP_LISTEN)
>  		goto out;
>  
>  	/* If socket state is TCP_LISTEN it cannot change (for now...),
> @@ -2178,7 +2196,8 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>  	}
>  
>  	if (msg->msg_namelen) {
> -		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
> +		unsigned char s_state = unix_sock_state(sk);
> +		err = s_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;

No need to define s_state here, or a blank line is needed after
the definition.
https://patchwork.kernel.org/project/netdevbpf/patch/72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru/

>  		goto out_err;
>  	} else {
>  		err = -ENOTCONN;
> @@ -2279,7 +2298,7 @@ static ssize_t unix_stream_sendpage(struct socket *socket, struct page *page,
>  		return -EOPNOTSUPP;
>  
>  	other = unix_peer(sk);
> -	if (!other || sk->sk_state != TCP_ESTABLISHED)
> +	if (!other || unix_sock_state(sk) != TCP_ESTABLISHED)
>  		return -ENOTCONN;
>  
>  	if (false) {
> @@ -2391,7 +2410,7 @@ static int unix_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
>  	if (err)
>  		return err;
>  
> -	if (sk->sk_state != TCP_ESTABLISHED)
> +	if (unix_sock_state(sk) != TCP_ESTABLISHED)
>  		return -ENOTCONN;
>  
>  	if (msg->msg_namelen)
> @@ -2405,7 +2424,7 @@ static int unix_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
>  {
>  	struct sock *sk = sock->sk;
>  
> -	if (sk->sk_state != TCP_ESTABLISHED)
> +	if (unix_sock_state(sk) != TCP_ESTABLISHED)
>  		return -ENOTCONN;
>  
>  	return unix_dgram_recvmsg(sock, msg, size, flags);
> @@ -2689,7 +2708,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
>  
>  static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
>  {
> -	if (unlikely(sk->sk_state != TCP_ESTABLISHED))
> +	if (unlikely(unix_sock_state(sk) != TCP_ESTABLISHED))
>  		return -ENOTCONN;
>  
>  	return unix_read_skb(sk, recv_actor);
> @@ -2713,7 +2732,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>  	size_t size = state->size;
>  	unsigned int last_len;
>  
> -	if (unlikely(sk->sk_state != TCP_ESTABLISHED)) {
> +	if (unlikely(unix_sock_state(sk) != TCP_ESTABLISHED)) {
>  		err = -EINVAL;
>  		goto out;
>  	}
