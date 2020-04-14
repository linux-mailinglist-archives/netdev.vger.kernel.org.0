Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FB51A7493
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 09:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406542AbgDNHVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 03:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406535AbgDNHVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 03:21:36 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CD1F20575;
        Tue, 14 Apr 2020 07:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586848895;
        bh=83MXZTDHd4lI/oTNVZkyFdn+w4GDvfaTkRBAMlhrZGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T7iIE4jWmnoxNv12auwTB7m3hYPvpid/UgEK3C3+EeteqDb3wLTiaTrEi+pJQ+4VG
         zD10uLXT/5HLyDy0IURuB37JmNiTtR/L/yu2QEDTmGAH/Eulm7IcHNPdo3GiPhm2+i
         FeTw2+xUWGgU36K6nhkmFLgL2STBpFVye69r1uMI=
Date:   Tue, 14 Apr 2020 10:21:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     =?utf-8?B?TGXFn2UgRG9ydSBDxINsaW4=?= <lesedorucalin01@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2] net: UDP repair mode for retrieving the send queue of
 corked UDP socket
Message-ID: <20200414072132.GU334007@unreal>
References: <20200413210253.GA28681@white>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200413210253.GA28681@white>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 12:02:54AM +0300, Leşe Doru Călin wrote:
> Hello everyone!
>
> In this year's edition of GSoC, there is a project idea for CRIU to add support
> for checkpoint/restore of cork-ed UDP sockets. But to add it, the kernel API needs
> to be extended.
> This is what this patch does. It adds UDP "repair mode" for UDP sockets in a similar
> approach to the TCP "repair mode", but only the send queue is necessary to be retrieved.
> So the patch extends the recv and setsockopt syscalls. Using UDP_REPAIR option in
> setsockopt, caller can set the socket in repair mode. If it is setted, the
> recv/recvfrom/recvmsg will receive the write queue and the destination of the data.
> As in the TCP mode, to change the repair mode requires the CAP_NET_ADMIN capability
> and to receive data the caller is obliged to use the MSG_PEEK flag.
>
> Best regards,
> Lese Doru


Please write commit message in descriptive format and not as an email
message.

>
> Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>
> ---
>  include/linux/udp.h      |    3 +-
>  include/uapi/linux/udp.h |    1
>  net/ipv4/udp.c           |   60 +++++++++++++++++++++++++++++++++++++++++++++++
>  net/ipv6/udp.c           |   45 +++++++++++++++++++++++++++++++++++
>  4 files changed, 108 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/udp.h b/include/linux/udp.h
> index aa84597bdc33..b22bd70118ce 100644
> --- a/include/linux/udp.h
> +++ b/include/linux/udp.h
> @@ -51,7 +51,8 @@ struct udp_sock {
>  					   * different encapsulation layer set
>  					   * this
>  					   */
> -			 gro_enabled:1;	/* Can accept GRO packets */
> +			 gro_enabled:1,	/* Can accept GRO packets */
> +			 repair:1;/* Receive the send queue */
>  	/*
>  	 * Following member retains the information to create a UDP header
>  	 * when the socket is uncorked.
> diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
> index 4828794efcf8..2fe78329d6da 100644
> --- a/include/uapi/linux/udp.h
> +++ b/include/uapi/linux/udp.h
> @@ -29,6 +29,7 @@ struct udphdr {
>
>  /* UDP socket options */
>  #define UDP_CORK	1	/* Never send partially complete segments */
> +#define UDP_REPAIR  19  /* Receive the send queue */
>  #define UDP_ENCAP	100	/* Set the socket to accept encapsulated packets */
>  #define UDP_NO_CHECK6_TX 101	/* Disable sending checksum for UDP6X */
>  #define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 32564b350823..306cd70e40cb 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1720,6 +1720,28 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
>  }
>  EXPORT_SYMBOL(__skb_recv_udp);
>
> +static int udp_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
> +{
> +	int copy, copied = 0, err = 0;
> +	struct sk_buff *skb;
> +
> +	skb_queue_walk(&sk->sk_write_queue, skb) {
> +		copy = len - copied;
> +		if (copy > skb->len - off)
> +			copy = skb->len - off;
> +
> +		err = skb_copy_datagram_msg(skb, off, msg, copy);
> +		if (err)
> +			break;
> +
> +		copied += copy;
> +
> +		if (len <= copied)
> +			break;
> +	}
> +	return err ?: copied;
> +}
> +
>  /*
>   * 	This should be easy, if there is something there we
>   * 	return it, otherwise we block.
> @@ -1729,8 +1751,10 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
>  		int flags, int *addr_len)
>  {
>  	struct inet_sock *inet = inet_sk(sk);
> +	struct udp_sock *up = udp_sk(sk);
>  	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
>  	struct sk_buff *skb;
> +	struct flowi4 *fl4;
>  	unsigned int ulen, copied;
>  	int off, err, peeking = flags & MSG_PEEK;
>  	int is_udplite = IS_UDPLITE(sk);
> @@ -1739,6 +1763,12 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
>  	if (flags & MSG_ERRQUEUE)
>  		return ip_recv_error(sk, msg, len, addr_len);
>
> +	if (unlikely(up->repair)) {
> +		if (!peeking)
> +			return -EPERM;
> +		goto recv_sndq;
> +	}
> +
>  try_again:
>  	off = sk_peek_offset(sk, flags);
>  	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
> @@ -1832,6 +1862,18 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
>  	cond_resched();
>  	msg->msg_flags &= ~MSG_TRUNC;
>  	goto try_again;
> +
> +recv_sndq:
> +	off = sizeof(struct iphdr) + sizeof(struct udphdr);
> +	if (sin) {
> +		fl4 = &inet->cork.fl.u.ip4;
> +		sin->sin_family = AF_INET;
> +		sin->sin_port = fl4->fl4_dport;
> +		sin->sin_addr.s_addr = fl4->daddr;
> +		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
> +		*addr_len = sizeof(*sin);
> +	}
> +	return udp_peek_sndq(sk, msg, off, len);
>  }
>
>  int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> @@ -2525,6 +2567,11 @@ void udp_destroy_sock(struct sock *sk)
>  	}
>  }
>
> +static inline bool udp_can_repair_sock(const struct sock *sk)
> +{
> +	return ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN);
> +}

There is no need to add static inline function to hide another function
which is used only once.

> +
>  /*
>   *	Socket option code for UDP
>   */
> @@ -2557,6 +2604,15 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
>  		}
>  		break;
>
> +	case UDP_REPAIR:
> +		if (!udp_can_repair_sock(sk))
> +			err = -EPERM;
> +		else if (val != 0)
> +			up->repair = 1;
> +		else
> +			up->repair = 0;
> +		break;
> +
>  	case UDP_ENCAP:
>  		switch (val) {
>  		case 0:
> @@ -2678,6 +2734,10 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
>  		val = up->corkflag;
>  		break;
>
> +	case UDP_REPAIR:
> +		val = up->repair;
> +		break;
> +
>  	case UDP_ENCAP:
>  		val = up->encap_type;
>  		break;
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 7d4151747340..ec653f9fce2d 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -250,6 +250,28 @@ struct sock *udp6_lib_lookup(struct net *net, const struct in6_addr *saddr, __be
>  EXPORT_SYMBOL_GPL(udp6_lib_lookup);
>  #endif
>
> +static int udp6_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
> +{
> +	int copy, copied = 0, err = 0;
> +	struct sk_buff *skb;
> +
> +	skb_queue_walk(&sk->sk_write_queue, skb) {
> +		copy = len - copied;
> +		if (copy > skb->len - off)
> +			copy = skb->len - off;
> +
> +		err = skb_copy_datagram_msg(skb, off, msg, copy);
> +		if (err)
> +			break;
> +
> +		copied += copy;
> +
> +		if (len <= copied)
> +			break;
> +	}
> +	return err ?: copied;
> +}
> +
>  /* do not use the scratch area len for jumbogram: their length execeeds the
>   * scratch area space; note that the IP6CB flags is still in the first
>   * cacheline, so checking for jumbograms is cheap
> @@ -269,7 +291,9 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  {
>  	struct ipv6_pinfo *np = inet6_sk(sk);
>  	struct inet_sock *inet = inet_sk(sk);
> +	struct udp_sock *up = udp_sk(sk);
>  	struct sk_buff *skb;
> +	struct flowi6 *fl6;
>  	unsigned int ulen, copied;
>  	int off, err, peeking = flags & MSG_PEEK;
>  	int is_udplite = IS_UDPLITE(sk);
> @@ -283,6 +307,12 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
>  		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
>
> +	if (unlikely(up->repair)) {
> +		if (!peeking)
> +			return -EPERM;
> +		goto recv_sndq;
> +	}
> +
>  try_again:
>  	off = sk_peek_offset(sk, flags);
>  	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
> @@ -394,6 +424,21 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  	cond_resched();
>  	msg->msg_flags &= ~MSG_TRUNC;
>  	goto try_again;
> +
> +recv_sndq:
> +	off = sizeof(struct ipv6hdr) + sizeof(struct udphdr);
> +	if (msg->msg_name) {
> +		DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6, msg->msg_name);
> +
> +		fl6 = &inet->cork.fl.u.ip6;
> +		sin6->sin6_family = AF_INET6;
> +		sin6->sin6_port = fl6->fl6_dport;
> +		sin6->sin6_flowinfo = 0;
> +		sin6->sin6_addr = fl6->daddr;
> +		sin6->sin6_scope_id = fl6->flowi6_oif;
> +		*addr_len = sizeof(*sin6);
> +	}
> +	return udp6_peek_sndq(sk, msg, off, len);
>  }
>
>  DEFINE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
