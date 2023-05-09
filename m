Return-Path: <netdev+bounces-1281-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC68A6FD2CC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:51:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFE401C20C78
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7868F125D2;
	Tue,  9 May 2023 22:50:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E1A1990C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:50:57 +0000 (UTC)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F27F59E7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683672656; x=1715208656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J6ZIkHPBoIcJJY37qVqyF2jj6r9q+FxrIswaOiGh2XU=;
  b=oo5ZCIva2YwlMraNbF3GU3HImdxUHauozszuhSubdzy5UjYIb6J+dDY4
   JvdsoOFG3WsSypQCW+Pj4RZnFCxGcTbNEDrWz3h99bPzafv3Yt1taFEOR
   D/2CKGuEzSbrKqtCmD2SzcElpE4gSZMvU/VdKdXPQR/CGf+4VTmzVrLN/
   A=;
X-IronPort-AV: E=Sophos;i="5.99,263,1677542400"; 
   d="scan'208";a="330009610"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 22:50:53 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com (Postfix) with ESMTPS id D6F2E81365;
	Tue,  9 May 2023 22:50:51 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 9 May 2023 22:50:45 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 9 May 2023 22:50:41 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>
CC: <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH net] net: datagram: fix data-races in datagram_poll()
Date: Tue, 9 May 2023 15:50:31 -0700
Message-ID: <20230509225031.19553-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230509173131.3263780-1-edumazet@google.com>
References: <20230509173131.3263780-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.39]
X-ClientProxiedBy: EX19D032UWB002.ant.amazon.com (10.13.139.190) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  9 May 2023 17:31:31 +0000
> datagram_poll() runs locklessly, we should add READ_ONCE()
> annotations while reading sk->sk_err, sk->sk_shutdown and sk->sk_state.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>


> ---
>  net/core/datagram.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index 5662dff3d381a92b271d9cba38a28a6a8478c114..176eb58347461b160890ce2d6b2d3cbc7412e321 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -807,18 +807,21 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
>  {
>  	struct sock *sk = sock->sk;
>  	__poll_t mask;
> +	u8 shutdown;
>  
>  	sock_poll_wait(file, sock, wait);
>  	mask = 0;
>  
>  	/* exceptional events? */
> -	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
> +	if (READ_ONCE(sk->sk_err) ||
> +	    !skb_queue_empty_lockless(&sk->sk_error_queue))
>  		mask |= EPOLLERR |
>  			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
>  
> -	if (sk->sk_shutdown & RCV_SHUTDOWN)
> +	shutdown = READ_ONCE(sk->sk_shutdown);
> +	if (shutdown & RCV_SHUTDOWN)
>  		mask |= EPOLLRDHUP | EPOLLIN | EPOLLRDNORM;
> -	if (sk->sk_shutdown == SHUTDOWN_MASK)
> +	if (shutdown == SHUTDOWN_MASK)
>  		mask |= EPOLLHUP;
>  
>  	/* readable? */
> @@ -827,10 +830,12 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
>  
>  	/* Connection-based need to check for termination and startup */
>  	if (connection_based(sk)) {
> -		if (sk->sk_state == TCP_CLOSE)
> +		int state = READ_ONCE(sk->sk_state);
> +
> +		if (state == TCP_CLOSE)
>  			mask |= EPOLLHUP;
>  		/* connection hasn't started yet? */
> -		if (sk->sk_state == TCP_SYN_SENT)
> +		if (state == TCP_SYN_SENT)
>  			return mask;
>  	}
>  
> -- 
> 2.40.1.521.gf1e218fcd8-goog

