Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DD0A1246
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 09:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfH2HEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 03:04:35 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:53488 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbfH2HEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 03:04:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8E6032057E;
        Thu, 29 Aug 2019 09:04:33 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FaJVm3eALvCu; Thu, 29 Aug 2019 09:04:32 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5299020184;
        Thu, 29 Aug 2019 09:04:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 29 Aug 2019
 09:04:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id DB5203182759;
 Thu, 29 Aug 2019 09:04:31 +0200 (CEST)
Date:   Thu, 29 Aug 2019 09:04:31 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH ipsec-next 7/7] xfrm: add espintcp (RFC 8229)
Message-ID: <20190829070431.GA2879@gauss3.secunet.de>
References: <cover.1566395202.git.sd@queasysnail.net>
 <029b59b8f74dbdbdf202fcf41a9a90b41b4821a2.1566395202.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <029b59b8f74dbdbdf202fcf41a9a90b41b4821a2.1566395202.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 11:46:25PM +0200, Sabrina Dubroca wrote:
> TCP encapsulation of IKE and IPsec messages (RFC 8229) is implemented
> as a TCP ULP, overriding in particular the sendmsg and recvmsg
> operations. A Stream Parser is used to extract messages out of the TCP
> stream using the first 2 bytes as length marker. Received IKE messages
> are put on "ike_queue", waiting to be dequeued by the custom recvmsg
> implementation. Received ESP messages are sent to XFRM, like with UDP
> encapsulation.
> 
> Some of this code is taken from the original submission by Herbert
> Xu. Currently, only IPv4 is supported, like for UDP encapsulation.
> 
> Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  include/net/espintcp.h   |  38 +++
>  include/net/xfrm.h       |   1 +
>  include/uapi/linux/udp.h |   1 +
>  net/ipv4/esp4.c          | 189 ++++++++++++++-
>  net/xfrm/Kconfig         |   9 +
>  net/xfrm/Makefile        |   1 +
>  net/xfrm/espintcp.c      | 505 +++++++++++++++++++++++++++++++++++++++
>  net/xfrm/xfrm_policy.c   |   7 +
>  net/xfrm/xfrm_state.c    |   3 +
>  9 files changed, 751 insertions(+), 3 deletions(-)
>  create mode 100644 include/net/espintcp.h
>  create mode 100644 net/xfrm/espintcp.c
> 

...

> +static struct sock *esp_find_tcp_sk(struct xfrm_state *x)
> +{
> +	struct xfrm_encap_tmpl *encap = x->encap;
> +	struct esp_tcp_sk *esk;
> +	__be16 sport, dport;
> +	struct sock *nsk;
> +	struct sock *sk;
> +
> +	sk = rcu_dereference(x->encap_sk);
> +	if (sk && sk->sk_state == TCP_ESTABLISHED)
> +		return sk;
> +
> +	spin_lock_bh(&x->lock);
> +	sport = encap->encap_sport;
> +	dport = encap->encap_dport;
> +	nsk = rcu_dereference_protected(x->encap_sk,
> +					lockdep_is_held(&x->lock));
> +	if (sk && sk == nsk) {
> +		esk = kmalloc(sizeof(*esk), GFP_ATOMIC);
> +		if (!esk) {
> +			spin_unlock_bh(&x->lock);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +		RCU_INIT_POINTER(x->encap_sk, NULL);
> +		esk->sk = sk;
> +		call_rcu(&esk->rcu, esp_free_tcp_sk);

I don't understand this, can you please explain what you are doing here?


> +	}
> +	spin_unlock_bh(&x->lock);
> +
> +	sk = inet_lookup_established(xs_net(x), &tcp_hashinfo, x->id.daddr.a4,
> +				     dport, x->props.saddr.a4, sport, 0);
> +	if (!sk)
> +		return ERR_PTR(-ENOENT);
> +
> +	if (!tcp_is_ulp_esp(sk)) {
> +		sock_put(sk);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	spin_lock_bh(&x->lock);
> +	nsk = rcu_dereference_protected(x->encap_sk,
> +					lockdep_is_held(&x->lock));
> +	if (encap->encap_sport != sport ||
> +	    encap->encap_dport != dport) {
> +		sock_put(sk);
> +		sk = nsk ?: ERR_PTR(-EREMCHG);
> +	} else if (sk == nsk) {
> +		sock_put(sk);
> +	} else {
> +		rcu_assign_pointer(x->encap_sk, sk);
> +	}
> +	spin_unlock_bh(&x->lock);
> +
> +	return sk;
> +}
> +
> +static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
> +{
> +	struct sock *sk;
> +	int err;
> +
> +	rcu_read_lock();
> +
> +	sk = esp_find_tcp_sk(x);
> +	err = PTR_ERR(sk);
> +	if (IS_ERR(sk))

Maybe better 'if (err)'?

> +		goto out;
> +
> +	bh_lock_sock(sk);
> +	if (sock_owned_by_user(sk)) {
> +		err = espintcp_queue_out(sk, skb);
> +		if (err < 0)
> +			goto unlock_sock;

This goto is not needed.

> +	} else {
> +		err = espintcp_push_skb(sk, skb);
> +	}
> +
> +unlock_sock:
> +	bh_unlock_sock(sk);
> +out:
> +	rcu_read_unlock();
> +	return err;
> +}
> +
> +static int esp_output_tcp_encap_cb(struct net *net, struct sock *sk,
> +				   struct sk_buff *skb)
> +{
> +	struct dst_entry *dst = skb_dst(skb);
> +	struct xfrm_state *x = dst->xfrm;
> +
> +	return esp_output_tcp_finish(x, skb);
> +}
> +
> +static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
> +{
> +	int err;
> +
> +	local_bh_disable();
> +	err = xfrm_trans_queue_net(xs_net(x), skb, esp_output_tcp_encap_cb);
> +	local_bh_enable();
> +
> +	/* EINPROGRESS just happens to do the right thing.  It
> +	 * actually means that the skb has been consumed and
> +	 * isn't coming back.
> +	 */
> +	return err ?: -EINPROGRESS;
> +}
> +#endif
> +
>  static void esp_output_done(struct crypto_async_request *base, int err)
>  {
>  	struct sk_buff *skb = base->data;
> @@ -147,7 +272,13 @@ static void esp_output_done(struct crypto_async_request *base, int err)
>  		secpath_reset(skb);
>  		xfrm_dev_resume(skb);
>  	} else {
> -		xfrm_output_resume(skb, err);
> +#ifdef CONFIG_XFRM_ESPINTCP

Do we really need all these ifdef? I guess most of them could
be avoided with some code refactorization.

> +		if (!err &&
> +		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
> +			esp_output_tail_tcp(x, skb);
> +		else
> +#endif
> +			xfrm_output_resume(skb, err);
>  	}
>  }

...

> @@ -296,7 +460,7 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
>  	struct sk_buff *trailer;
>  	int tailen = esp->tailen;
>  
> -	/* this is non-NULL only with UDP Encapsulation */
> +	/* this is non-NULL only with TCP/UDP Encapsulation */
>  	if (x->encap) {
>  		int err = esp_output_encap(x, skb, esp);
>  
> @@ -491,6 +655,11 @@ int esp_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
>  	if (sg != dsg)
>  		esp_ssg_unref(x, tmp);
>  
> +#ifdef CONFIG_XFRM_ESPINTCP
> +	if (!err && x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
> +		err = esp_output_tail_tcp(x, skb);
> +#endif
> +
>  error_free:
>  	kfree(tmp);
>  error:
> @@ -617,10 +786,16 @@ int esp_input_done2(struct sk_buff *skb, int err)
>  
>  	if (x->encap) {
>  		struct xfrm_encap_tmpl *encap = x->encap;
> +		struct tcphdr *th = (void *)(skb_network_header(skb) + ihl);

This gives a unused variable warning if CONFIG_XFRM_ESPINTCP
is not set.

>  		struct udphdr *uh = (void *)(skb_network_header(skb) + ihl);
>  		__be16 source;
>  
>  		switch (x->encap->encap_type) {
> +#ifdef CONFIG_XFRM_ESPINTCP
> +		case TCP_ENCAP_ESPINTCP:
> +			source = th->source;
> +			break;
> +#endif
>  		case UDP_ENCAP_ESPINUDP:
>  		case UDP_ENCAP_ESPINUDP_NON_IKE:
>  			source = uh->source;
> @@ -1017,6 +1192,14 @@ static int esp_init_state(struct xfrm_state *x)
>  		case UDP_ENCAP_ESPINUDP_NON_IKE:
>  			x->props.header_len += sizeof(struct udphdr) + 2 * sizeof(u32);
>  			break;
> +#ifdef CONFIG_XFRM_ESPINTCP
> +		case TCP_ENCAP_ESPINTCP:
> +			/* only the length field, TCP encap is done by
> +			 * the socket
> +			 */
> +			x->props.header_len += 2;
> +			break;
> +#endif
>  		}
>  	}
>  
> diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
> index c967fc3c38c8..ccc012b3ea10 100644
> --- a/net/xfrm/Kconfig
> +++ b/net/xfrm/Kconfig
> @@ -71,6 +71,15 @@ config XFRM_IPCOMP
>  	select CRYPTO
>  	select CRYPTO_DEFLATE
>  
> +config XFRM_ESPINTCP
> +	bool "ESP in TCP encapsulation (RFC 8229)"
> +	depends on XFRM && INET_ESP
> +	select STREAM_PARSER

I'm getting these compile errors:

espintcp.o: In function `espintcp_close':
/home/klassert/git/linux-stk/net/xfrm/espintcp.c:469: undefined reference to `sk_msg_free'
net/xfrm/espintcp.o: In function `espintcp_sendmsg':
/home/klassert/git/linux-stk/net/xfrm/espintcp.c:302: undefined reference to `sk_msg_alloc'
/home/klassert/git/linux-stk/net/xfrm/espintcp.c:316: undefined reference to `sk_msg_memcopy_from_iter'
/home/klassert/git/linux-stk/net/xfrm/espintcp.c:341: undefined reference to `sk_msg_free'
/home/klassert/git/linux-stk/net/xfrm/espintcp.c:321: undefined reference to `sk_msg_memcopy_from_iter'
/home/klassert/git/linux-stk/Makefile:1067: recipe for target 'vmlinux' failed
make[1]: *** [vmlinux] Error 1

I guess you need to select NET_SOCK_MSG.

Btw. I've updated the ipsec-next tree, so patch 1 is not needed anymore.

Everything else looks good!

