Return-Path: <netdev+bounces-10767-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB05773033C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECFCC1C20D2B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD898101C3;
	Wed, 14 Jun 2023 15:15:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180FCDDB6;
	Wed, 14 Jun 2023 15:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5B3C433C0;
	Wed, 14 Jun 2023 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686755715;
	bh=73UmdjDyuEXZ7gArpn6gSWI0sp8/agt77ljLETOlDDw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=No99p1uTWUoT9RkFP/K8Yo418x9uc8mDrJ5k2SJUUGwnaLKemQb6rLwedlXuhTrnJ
	 SutUvrwQA77W+cDbnsAlEsGqOPSblSrhPipnD4fmTNOQLFExWSZ0OWPje3PsOo4BGY
	 EsJGhRpAe1muqMWsXKl0Eq6MYlT3bwCYx/DCztztgXrjmFy5XUblw0kWMeMRXhlHkq
	 Jsxc69llL6n4jBA7EuHg+8dSD59f6YXXDLesjCwotlola01NdKJ/yITVCJjfa9D8N9
	 5YOPWa8JQXgW8/LCH0XQzTdojO9UNZd+zIPG2uoNRsUk8XMIdVj3wjLA3Yc3lzYYr1
	 0ayAlbq8tZtmQ==
Message-ID: <6b5e5988-3dc7-f5d6-e447-397696c0d533@kernel.org>
Date: Wed, 14 Jun 2023 08:15:10 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [RFC PATCH v2 1/4] net: wire up support for
 file_operations->uring_cmd()
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>, io-uring@vger.kernel.org,
 axboe@kernel.dk, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, Matthieu Baerts <matthieu.baerts@tessares.net>,
 Mat Martineau <martineau@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>
Cc: leit@fb.com, asml.silence@gmail.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, dccp@vger.kernel.org, mptcp@lists.linux.dev,
 linux-sctp@vger.kernel.org, ast@kernel.org, kuniyu@amazon.com,
 martin.lau@kernel.org, Jason Xing <kernelxing@tencent.com>,
 Joanne Koong <joannelkoong@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Willem de Bruijn
 <willemb@google.com>, Guillaume Nault <gnault@redhat.com>,
 Andrea Righi <andrea.righi@canonical.com>
References: <20230614110757.3689731-1-leitao@debian.org>
 <20230614110757.3689731-2-leitao@debian.org>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230614110757.3689731-2-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/14/23 5:07 AM, Breno Leitao wrote:
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 8defc8f1d82e..58dea87077af 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -182,6 +182,8 @@ struct proto_ops {
>  	int	 	(*compat_ioctl) (struct socket *sock, unsigned int cmd,
>  				      unsigned long arg);
>  #endif
> +	int		(*uring_cmd)(struct socket *sock, struct io_uring_cmd *cmd,
> +				     unsigned int issue_flags);
>  	int		(*gettstamp) (struct socket *sock, void __user *userstamp,
>  				      bool timeval, bool time32);
>  	int		(*listen)    (struct socket *sock, int len);
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 62a1b99da349..a49b8b19292b 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -111,6 +111,7 @@ typedef struct {
>  struct sock;
>  struct proto;
>  struct net;
> +struct io_uring_cmd;
>  
>  typedef __u32 __bitwise __portpair;
>  typedef __u64 __bitwise __addrpair;
> @@ -1259,6 +1260,9 @@ struct proto {
>  
>  	int			(*ioctl)(struct sock *sk, int cmd,
>  					 int *karg);
> +	int			(*uring_cmd)(struct sock *sk,
> +					     struct io_uring_cmd *cmd,
> +					     unsigned int issue_flags);
>  	int			(*init)(struct sock *sk);
>  	void			(*destroy)(struct sock *sk);
>  	void			(*shutdown)(struct sock *sk, int how);
> @@ -1934,6 +1938,8 @@ int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>  			int flags);
>  int sock_common_setsockopt(struct socket *sock, int level, int optname,
>  			   sockptr_t optval, unsigned int optlen);
> +int sock_common_uring_cmd(struct socket *sock, struct io_uring_cmd *cmd,
> +			  unsigned int issue_flags);
>  
>  void sk_common_release(struct sock *sk);
>  
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 1df7e432fec5..339fa74db60f 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3668,6 +3668,18 @@ int sock_common_setsockopt(struct socket *sock, int level, int optname,
>  }
>  EXPORT_SYMBOL(sock_common_setsockopt);
>  
> +int sock_common_uring_cmd(struct socket *sock, struct io_uring_cmd *cmd,
> +			  unsigned int issue_flags)
> +{
> +	struct sock *sk = sock->sk;
> +
> +	if (!sk->sk_prot || !sk->sk_prot->uring_cmd)
> +		return -EOPNOTSUPP;
> +
> +	return sk->sk_prot->uring_cmd(sk, cmd, issue_flags);
> +}
> +EXPORT_SYMBOL(sock_common_uring_cmd);
> +


io_uring is just another in-kernel user of sockets. There is no reason
for io_uring references to be in core net code. It should be using
exposed in-kernel APIs and doing any translation of its op codes in
io_uring/  code.


