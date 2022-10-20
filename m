Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A33606814
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJTSUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJTSUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:20:00 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A1963878
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666289999; x=1697825999;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VXv+5nw1uniG4kx/+4kbwmBBcXy/t5DQjqLqRBz/u+8=;
  b=K35y3tgyFtMGVM/XBVcT6mS7Q2goI+JGNC10kjzYXGLEshCYJuqzeXsN
   5fEax1F++IMPUPUdvyQ/PkMLNPCXJtOq86Ku96CgvPoz+6ORS67uD/J0o
   eebS8KUp3D3uULxvRBIatMgYUeDQ+K51qfgJIgQ3mem87jOsx5F9x+ZXf
   Q=;
X-IronPort-AV: E=Sophos;i="5.95,199,1661817600"; 
   d="scan'208";a="1066072278"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 18:19:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com (Postfix) with ESMTPS id 706196112D;
        Thu, 20 Oct 2022 18:19:49 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 20 Oct 2022 18:19:38 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.58) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Thu, 20 Oct 2022 18:19:36 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <kuniyu@amazon.com>,
        <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <mptcp@lists.linux.dev>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/2] net: introduce and use custom sockopt socket flag
Date:   Thu, 20 Oct 2022 11:19:26 -0700
Message-ID: <20221020181926.192-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <dc549a4d5c1d2031c64794c8e12bed55afb85c3e.1666287924.git.pabeni@redhat.com>
References: <dc549a4d5c1d2031c64794c8e12bed55afb85c3e.1666287924.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.58]
X-ClientProxiedBy: EX13D39UWB001.ant.amazon.com (10.43.161.5) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Thu, 20 Oct 2022 19:48:51 +0200
> We will soon introduce custom setsockopt for UDP sockets, too.
> Instead of doing even more complex arbitrary checks inside
> sock_use_custom_sol_socket(), add a new socket flag and set it
> for the relevant socket types (currently only MPTCP).
> 
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>


> ---
>  include/linux/net.h  | 1 +
>  net/mptcp/protocol.c | 4 ++++
>  net/socket.c         | 8 +-------
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 711c3593c3b8..59350fd85823 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -41,6 +41,7 @@ struct net;
>  #define SOCK_NOSPACE		2
>  #define SOCK_PASSCRED		3
>  #define SOCK_PASSSEC		4
> +#define SOCK_CUSTOM_SOCKOPT	5
>  
>  #ifndef ARCH_HAS_SOCKET_TYPES
>  /**
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index f599ad44ed24..0448a5c3da3c 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -2708,6 +2708,8 @@ static int mptcp_init_sock(struct sock *sk)
>  	if (ret)
>  		return ret;
>  
> +	set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
> +
>  	/* fetch the ca name; do it outside __mptcp_init_sock(), so that clone will
>  	 * propagate the correct value
>  	 */
> @@ -3684,6 +3686,8 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
>  		struct mptcp_subflow_context *subflow;
>  		struct sock *newsk = newsock->sk;
>  
> +		set_bit(SOCK_CUSTOM_SOCKOPT, &newsock->flags);
> +
>  		lock_sock(newsk);
>  
>  		/* PM/worker can now acquire the first subflow socket
> diff --git a/net/socket.c b/net/socket.c
> index 00da9ce3dba0..55c5d536e5f6 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2199,13 +2199,7 @@ SYSCALL_DEFINE4(recv, int, fd, void __user *, ubuf, size_t, size,
>  
>  static bool sock_use_custom_sol_socket(const struct socket *sock)
>  {
> -	const struct sock *sk = sock->sk;
> -
> -	/* Use sock->ops->setsockopt() for MPTCP */
> -	return IS_ENABLED(CONFIG_MPTCP) &&
> -	       sk->sk_protocol == IPPROTO_MPTCP &&
> -	       sk->sk_type == SOCK_STREAM &&
> -	       (sk->sk_family == AF_INET || sk->sk_family == AF_INET6);
> +	return test_bit(SOCK_CUSTOM_SOCKOPT, &sock->flags);
>  }
>  
>  /*
> -- 
> 2.37.3
