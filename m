Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93DC223852
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 11:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgGQJ0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 05:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgGQJ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 05:26:43 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A53C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 02:26:43 -0700 (PDT)
Received: from localhost.localdomain (p200300e9d737160bc31b0c5d63306033.dip0.t-ipconnect.de [IPv6:2003:e9:d737:160b:c31b:c5d:6330:6033])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id B77EDC0617;
        Fri, 17 Jul 2020 11:26:35 +0200 (CEST)
Subject: Re: [PATCH 05/22] net: remove compat_sock_common_{get,set}sockopt
To:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chas Williams <3chas3@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-wpan@vger.kernel.org, mptcp@lists.01.org
References: <20200717062331.691152-1-hch@lst.de>
 <20200717062331.691152-6-hch@lst.de>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <52d031f9-70c2-89c1-941f-c8187a6a2b68@datenfreihafen.org>
Date:   Fri, 17 Jul 2020 11:26:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200717062331.691152-6-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 17.07.20 08:23, Christoph Hellwig wrote:
> Add the compat handling to sock_common_{get,set}sockopt instead,
> keyed of in_compat_syscall().  This allow to remove the now unused
> ->compat_{get,set}sockopt methods from struct proto_ops.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   include/linux/net.h      |  6 ------
>   include/net/sock.h       |  4 ----
>   net/core/sock.c          | 30 ++++++------------------------
>   net/dccp/ipv4.c          |  4 ----
>   net/dccp/ipv6.c          |  2 --
>   net/ieee802154/socket.c  |  8 --------
>   net/ipv4/af_inet.c       |  6 ------
>   net/ipv6/af_inet6.c      |  4 ----
>   net/ipv6/ipv6_sockglue.c | 12 ++----------
>   net/ipv6/raw.c           |  2 --
>   net/l2tp/l2tp_ip.c       |  4 ----
>   net/l2tp/l2tp_ip6.c      |  2 --
>   net/mptcp/protocol.c     |  6 ------
>   net/phonet/socket.c      |  8 --------
>   net/sctp/ipv6.c          |  2 --
>   net/sctp/protocol.c      |  4 ----
>   16 files changed, 8 insertions(+), 96 deletions(-)
> 
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 016a9c5faa3479..858ff1d981540d 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -165,12 +165,6 @@ struct proto_ops {
>   				      int optname, char __user *optval, unsigned int optlen);
>   	int		(*getsockopt)(struct socket *sock, int level,
>   				      int optname, char __user *optval, int __user *optlen);
> -#ifdef CONFIG_COMPAT
> -	int		(*compat_setsockopt)(struct socket *sock, int level,
> -				      int optname, char __user *optval, unsigned int optlen);
> -	int		(*compat_getsockopt)(struct socket *sock, int level,
> -				      int optname, char __user *optval, int __user *optlen);
> -#endif
>   	void		(*show_fdinfo)(struct seq_file *m, struct socket *sock);
>   	int		(*sendmsg)   (struct socket *sock, struct msghdr *m,
>   				      size_t total_len);
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 4bf8841651486d..1fd7cf5fc7516c 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1744,10 +1744,6 @@ int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>   			int flags);
>   int sock_common_setsockopt(struct socket *sock, int level, int optname,
>   				  char __user *optval, unsigned int optlen);
> -int compat_sock_common_getsockopt(struct socket *sock, int level,
> -		int optname, char __user *optval, int __user *optlen);
> -int compat_sock_common_setsockopt(struct socket *sock, int level,
> -		int optname, char __user *optval, unsigned int optlen);
>   
>   void sk_common_release(struct sock *sk);
>   
> diff --git a/net/core/sock.c b/net/core/sock.c
> index e085df79482520..018404d1762682 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3199,23 +3199,14 @@ int sock_common_getsockopt(struct socket *sock, int level, int optname,
>   {
>   	struct sock *sk = sock->sk;
>   
> -	return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);
> -}
> -EXPORT_SYMBOL(sock_common_getsockopt);
> -
>   #ifdef CONFIG_COMPAT
> -int compat_sock_common_getsockopt(struct socket *sock, int level, int optname,
> -				  char __user *optval, int __user *optlen)
> -{
> -	struct sock *sk = sock->sk;
> -
> -	if (sk->sk_prot->compat_getsockopt != NULL)
> +	if (in_compat_syscal() && sk->sk_prot->compat_getsockopt)
>   		return sk->sk_prot->compat_getsockopt(sk, level, optname,
>   						      optval, optlen);
> +#endif
>   	return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);
>   }
> -EXPORT_SYMBOL(compat_sock_common_getsockopt);
> -#endif
> +EXPORT_SYMBOL(sock_common_getsockopt);
>   
>   int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>   			int flags)
> @@ -3240,23 +3231,14 @@ int sock_common_setsockopt(struct socket *sock, int level, int optname,
>   {
>   	struct sock *sk = sock->sk;
>   
> -	return sk->sk_prot->setsockopt(sk, level, optname, optval, optlen);
> -}
> -EXPORT_SYMBOL(sock_common_setsockopt);
> -
>   #ifdef CONFIG_COMPAT
> -int compat_sock_common_setsockopt(struct socket *sock, int level, int optname,
> -				  char __user *optval, unsigned int optlen)
> -{
> -	struct sock *sk = sock->sk;
> -
> -	if (sk->sk_prot->compat_setsockopt != NULL)
> +	if (in_compat_syscall() && sk->sk_prot->compat_setsockopt)
>   		return sk->sk_prot->compat_setsockopt(sk, level, optname,
>   						      optval, optlen);
> +#endif
>   	return sk->sk_prot->setsockopt(sk, level, optname, optval, optlen);
>   }
> -EXPORT_SYMBOL(compat_sock_common_setsockopt);
> -#endif
> +EXPORT_SYMBOL(sock_common_setsockopt);
>   
>   void sk_common_release(struct sock *sk)
>   {
> diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> index a7e989919c5307..316cc5ac0da72b 100644
> --- a/net/dccp/ipv4.c
> +++ b/net/dccp/ipv4.c
> @@ -999,10 +999,6 @@ static const struct proto_ops inet_dccp_ops = {
>   	.recvmsg	   = sock_common_recvmsg,
>   	.mmap		   = sock_no_mmap,
>   	.sendpage	   = sock_no_sendpage,
> -#ifdef CONFIG_COMPAT
> -	.compat_setsockopt = compat_sock_common_setsockopt,
> -	.compat_getsockopt = compat_sock_common_getsockopt,
> -#endif
>   };
>   
>   static struct inet_protosw dccp_v4_protosw = {
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index 650187d688519c..b50f85a72cd5fc 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -1083,8 +1083,6 @@ static const struct proto_ops inet6_dccp_ops = {
>   	.sendpage	   = sock_no_sendpage,
>   #ifdef CONFIG_COMPAT
>   	.compat_ioctl	   = inet6_compat_ioctl,
> -	.compat_setsockopt = compat_sock_common_setsockopt,
> -	.compat_getsockopt = compat_sock_common_getsockopt,
>   #endif
>   };
>   
> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> index d93d4531aa9bc5..94ae9662133e30 100644
> --- a/net/ieee802154/socket.c
> +++ b/net/ieee802154/socket.c
> @@ -423,10 +423,6 @@ static const struct proto_ops ieee802154_raw_ops = {
>   	.recvmsg	   = sock_common_recvmsg,
>   	.mmap		   = sock_no_mmap,
>   	.sendpage	   = sock_no_sendpage,
> -#ifdef CONFIG_COMPAT
> -	.compat_setsockopt = compat_sock_common_setsockopt,
> -	.compat_getsockopt = compat_sock_common_getsockopt,
> -#endif
>   };
>   
>   /* DGRAM Sockets (802.15.4 dataframes) */
> @@ -986,10 +982,6 @@ static const struct proto_ops ieee802154_dgram_ops = {
>   	.recvmsg	   = sock_common_recvmsg,
>   	.mmap		   = sock_no_mmap,
>   	.sendpage	   = sock_no_sendpage,
> -#ifdef CONFIG_COMPAT
> -	.compat_setsockopt = compat_sock_common_setsockopt,
> -	.compat_getsockopt = compat_sock_common_getsockopt,
> -#endif

For the ieee802154 part:

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
