Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3DE2B227B
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 16:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388488AbfIMOry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 10:47:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44613 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388244AbfIMOrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 10:47:53 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8931D307D847;
        Fri, 13 Sep 2019 14:47:53 +0000 (UTC)
Received: from ovpn-117-12.ams2.redhat.com (ovpn-117-12.ams2.redhat.com [10.36.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5FC119C78;
        Fri, 13 Sep 2019 14:47:51 +0000 (UTC)
Message-ID: <15a5bb03286766b58c952027e91ab2514ea2172d.camel@redhat.com>
Subject: Re: [PATCH net] udp: correct reuseport selection with connected
 sockets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kraig@google.com,
        zabele@comcast.net, mark.keaton@raytheon.com,
        Willem de Bruijn <willemb@google.com>
Date:   Fri, 13 Sep 2019 16:47:50 +0200
In-Reply-To: <20190913011639.55895-1-willemdebruijn.kernel@gmail.com>
References: <20190913011639.55895-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 13 Sep 2019 14:47:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-12 at 21:16 -0400, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> UDP reuseport groups can hold a mix unconnected and connected sockets.
> Ensure that connections only receive all traffic to their 4-tuple.
> 
> Fast reuseport returns on the first reuseport match on the assumption
> that all matches are equal. Only if connections are present, return to
> the previous behavior of scoring all sockets.
> 
> Record if connections are present and if so (1) treat such connected
> sockets as an independent match from the group, (2) only return
> 2-tuple matches from reuseport and (3) do not return on the first
> 2-tuple reuseport match to allow for a higher scoring match later.
> 
> New field has_conns is set without locks. No other fields in the
> bitmap are modified at runtime and the field is only ever set
> unconditionally, so an RMW cannot miss a change.
> 
> Fixes: e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
> Link: http://lkml.kernel.org/r/CA+FuTSfRP09aJNYRt04SS6qj22ViiOEWaWmLAwX0psk8-PGNxw@mail.gmail.com
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> 
> ---
> 
> I was unable to compile some older kernels, so the Fixes tag is based
> on basic analysis, not bisected to by the regression test.
> ---
>  include/net/sock_reuseport.h | 20 +++++++++++++++++++-
>  net/core/sock_reuseport.c    | 15 +++++++++++++--
>  net/ipv4/datagram.c          |  2 ++
>  net/ipv4/udp.c               |  5 +++--
>  net/ipv6/datagram.c          |  2 ++
>  net/ipv6/udp.c               |  5 +++--
>  6 files changed, 42 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> index d9112de85261..43f4a818d88f 100644
> --- a/include/net/sock_reuseport.h
> +++ b/include/net/sock_reuseport.h
> @@ -21,7 +21,8 @@ struct sock_reuseport {
>  	unsigned int		synq_overflow_ts;
>  	/* ID stays the same even after the size of socks[] grows. */
>  	unsigned int		reuseport_id;
> -	bool			bind_inany;
> +	unsigned int		bind_inany:1;
> +	unsigned int		has_conns:1;
>  	struct bpf_prog __rcu	*prog;		/* optional BPF sock selector */
>  	struct sock		*socks[0];	/* array of sock pointers */
>  };
> @@ -37,6 +38,23 @@ extern struct sock *reuseport_select_sock(struct sock *sk,
>  extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
>  extern int reuseport_detach_prog(struct sock *sk);
>  
> +static inline bool reuseport_has_conns(struct sock *sk, bool set)
> +{
> +	struct sock_reuseport *reuse;
> +	bool ret = false;
> +
> +	rcu_read_lock();
> +	reuse = rcu_dereference(sk->sk_reuseport_cb);
> +	if (reuse) {
> +		if (set)
> +			reuse->has_conns = 1;
> +		ret = reuse->has_conns;
> +	}
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  int reuseport_get_id(struct sock_reuseport *reuse);
>  
>  #endif  /* _SOCK_REUSEPORT_H */
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index 9408f9264d05..f3ceec93f392 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -295,8 +295,19 @@ struct sock *reuseport_select_sock(struct sock *sk,
>  
>  select_by_hash:
>  		/* no bpf or invalid bpf result: fall back to hash usage */
> -		if (!sk2)
> -			sk2 = reuse->socks[reciprocal_scale(hash, socks)];
> +		if (!sk2) {
> +			int i, j;
> +
> +			i = j = reciprocal_scale(hash, socks);
> +			while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
> +				i++;
> +				if (i >= reuse->num_socks)
> +					i = 0;
> +				if (i == j)
> +					goto out;
> +			}
> +			sk2 = reuse->socks[i];
> +		}
>  	}
>  
>  out:
> diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
> index 7bd29e694603..9a0fe0c2fa02 100644
> --- a/net/ipv4/datagram.c
> +++ b/net/ipv4/datagram.c
> @@ -15,6 +15,7 @@
>  #include <net/sock.h>
>  #include <net/route.h>
>  #include <net/tcp_states.h>
> +#include <net/sock_reuseport.h>
>  
>  int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  {
> @@ -69,6 +70,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
>  	}
>  	inet->inet_daddr = fl4->daddr;
>  	inet->inet_dport = usin->sin_port;
> +	reuseport_has_conns(sk, true);
>  	sk->sk_state = TCP_ESTABLISHED;
>  	sk_set_txhash(sk);
>  	inet->inet_id = jiffies;
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index d88821c794fb..16486c8b708b 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -423,12 +423,13 @@ static struct sock *udp4_lib_lookup2(struct net *net,
>  		score = compute_score(sk, net, saddr, sport,
>  				      daddr, hnum, dif, sdif);
>  		if (score > badness) {
> -			if (sk->sk_reuseport) {
> +			if (sk->sk_reuseport &&
> +			    sk->sk_state != TCP_ESTABLISHED) {
>  				hash = udp_ehashfn(net, daddr, hnum,
>  						   saddr, sport);
>  				result = reuseport_select_sock(sk, hash, skb,
>  							sizeof(struct udphdr));
> -				if (result)
> +				if (result && !reuseport_has_conns(sk, false))
>  					return result;
>  			}
>  			badness = score;
> diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
> index 9ab897ded4df..96f939248d2f 100644
> --- a/net/ipv6/datagram.c
> +++ b/net/ipv6/datagram.c
> @@ -27,6 +27,7 @@
>  #include <net/ip6_route.h>
>  #include <net/tcp_states.h>
>  #include <net/dsfield.h>
> +#include <net/sock_reuseport.h>
>  
>  #include <linux/errqueue.h>
>  #include <linux/uaccess.h>
> @@ -254,6 +255,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
>  		goto out;
>  	}
>  
> +	reuseport_has_conns(sk, true);
>  	sk->sk_state = TCP_ESTABLISHED;
>  	sk_set_txhash(sk);
>  out:
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 827fe7385078..5995fdc99d3f 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -158,13 +158,14 @@ static struct sock *udp6_lib_lookup2(struct net *net,
>  		score = compute_score(sk, net, saddr, sport,
>  				      daddr, hnum, dif, sdif);
>  		if (score > badness) {
> -			if (sk->sk_reuseport) {
> +			if (sk->sk_reuseport &&
> +			    sk->sk_state != TCP_ESTABLISHED) {
>  				hash = udp6_ehashfn(net, daddr, hnum,
>  						    saddr, sport);
>  
>  				result = reuseport_select_sock(sk, hash, skb,
>  							sizeof(struct udphdr));
> -				if (result)
> +				if (result && !reuseport_has_conns(sk, false))
>  					return result;
>  			}
>  			result = sk;

The patch LGTM,

Acked-by: Paolo Abeni <pabeni@redhat.com>

