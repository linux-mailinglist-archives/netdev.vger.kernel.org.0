Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B232468C46A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjBFRS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBFRSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:18:25 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A20D1CF7A
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:18:23 -0800 (PST)
Date:   Mon, 6 Feb 2023 18:18:19 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Antony Antony <antony.antony@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] xfrm: Support GRO for IPv6 ESP in UDP encapsulation.
Message-ID: <Y+E2W3/PRt999Spb@salvia>
References: <6dfd03c5fa0afb99f255f4a35772df19e33880db.1674156645.git.antony.antony@secunet.com>
 <3d9a846f9af55920490a28b569817aa5707bb07e.1674156645.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3d9a846f9af55920490a28b569817aa5707bb07e.1674156645.git.antony.antony@secunet.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 08:34:00PM +0100, Antony Antony wrote:
> From: Steffen Klassert <steffen.klassert@secunet.com>
> 
> This patch enables the GRO codepath for IPv6 ESP in UDP encapsulated
> packets. Decapsulation happens at L2 and saves a full round through
> the stack for each packet. This is also needed to support HW offload
> for ESP in UDP encapsulation.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> Co-developed-by: Antony Antony <antony.antony@secunet.com>
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
> ---
>  include/net/ipv6_stubs.h |  3 ++
>  include/net/xfrm.h       |  4 +-
>  net/ipv4/udp.c           |  4 +-
>  net/ipv6/af_inet6.c      |  1 +
>  net/ipv6/esp6_offload.c  | 15 +++++-
>  net/ipv6/xfrm6_input.c   | 99 ++++++++++++++++++++++++++++++++--------
>  6 files changed, 103 insertions(+), 23 deletions(-)
> 
> diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
> index c48186bf4737..887d35f716c7 100644
> --- a/include/net/ipv6_stubs.h
> +++ b/include/net/ipv6_stubs.h
> @@ -60,6 +60,9 @@ struct ipv6_stub {
>  #if IS_ENABLED(CONFIG_XFRM)
>  	void (*xfrm6_local_rxpmtu)(struct sk_buff *skb, u32 mtu);
>  	int (*xfrm6_udp_encap_rcv)(struct sock *sk, struct sk_buff *skb);
> +	struct sk_buff *(*xfrm6_gro_udp_encap_rcv)(struct sock *sk,
> +						   struct list_head *head,
> +						   struct sk_buff *skb);
>  	int (*xfrm6_rcv_encap)(struct sk_buff *skb, int nexthdr, __be32 spi,
>  			       int encap_type);
>  #endif
> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index 74dba98fbf2c..5cc6d8432d2f 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -1666,8 +1666,6 @@ void xfrm_local_error(struct sk_buff *skb, int mtu);
>  int xfrm4_extract_input(struct xfrm_state *x, struct sk_buff *skb);
>  int xfrm4_rcv_encap(struct sk_buff *skb, int nexthdr, __be32 spi,
>  		    int encap_type);
> -struct sk_buff *xfrm4_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
> -					struct sk_buff *skb);
>  int xfrm4_transport_finish(struct sk_buff *skb, int async);
>  int xfrm4_rcv(struct sk_buff *skb);
>  
> @@ -1710,6 +1708,8 @@ int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb);
>  int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb);
>  struct sk_buff *xfrm4_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
>  					struct sk_buff *skb);
> +struct sk_buff *xfrm6_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
> +					struct sk_buff *skb);
>  int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval,
>  		     int optlen);
>  #else
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 6a30d0210c4e..497ef68c80ea 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2727,8 +2727,10 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
>  		case UDP_ENCAP_ESPINUDP:
>  		case UDP_ENCAP_ESPINUDP_NON_IKE:
>  #if IS_ENABLED(CONFIG_IPV6)
> -			if (sk->sk_family == AF_INET6)
> +			if (sk->sk_family == AF_INET6) {
>  				up->encap_rcv = ipv6_stub->xfrm6_udp_encap_rcv;
> +				up->gro_receive = ipv6_stub->xfrm6_gro_udp_encap_rcv;
> +			}
>  #endif
>  			if (sk->sk_family == AF_INET) {
>  				up->encap_rcv = xfrm4_udp_encap_rcv;
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index fee9163382c2..03c04a5a073d 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -1054,6 +1054,7 @@ static const struct ipv6_stub ipv6_stub_impl = {
>  #if IS_ENABLED(CONFIG_XFRM)
>  	.xfrm6_local_rxpmtu = xfrm6_local_rxpmtu,
>  	.xfrm6_udp_encap_rcv = xfrm6_udp_encap_rcv,
> +	.xfrm6_gro_udp_encap_rcv = xfrm6_gro_udp_encap_rcv,
>  	.xfrm6_rcv_encap = xfrm6_rcv_encap,
>  #endif
>  	.nd_tbl	= &nd_tbl,
> diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
> index ee5f5abdb503..395bfee94d84 100644
> --- a/net/ipv6/esp6_offload.c
> +++ b/net/ipv6/esp6_offload.c
> @@ -33,7 +33,9 @@ static __u16 esp6_nexthdr_esp_offset(struct ipv6hdr *ipv6_hdr, int nhlen)
>  	int off = sizeof(struct ipv6hdr);
>  	struct ipv6_opt_hdr *exthdr;
>  
> -	if (likely(ipv6_hdr->nexthdr == NEXTHDR_ESP))
> +	/* ESP or ESPINUDP */
> +	if (likely(ipv6_hdr->nexthdr == NEXTHDR_ESP ||
> +		   ipv6_hdr->nexthdr == NEXTHDR_UDP))
>  		return offsetof(struct ipv6hdr, nexthdr);
>  
>  	while (off < nhlen) {
> @@ -53,10 +55,19 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
>  	int offset = skb_gro_offset(skb);
>  	struct xfrm_offload *xo;
>  	struct xfrm_state *x;
> +	int encap_type = 0;
>  	__be32 seq;
>  	__be32 spi;
>  	int nhoff;
>  
> +	if (NAPI_GRO_CB(skb)->proto == IPPROTO_UDP && skb->sk &&
> +	    (udp_sk(skb->sk)->encap_type == UDP_ENCAP_ESPINUDP ||
> +	     udp_sk(skb->sk)->encap_type == UDP_ENCAP_ESPINUDP_NON_IKE)) {
> +		encap_type = udp_sk(skb->sk)->encap_type;
> +		sock_put(skb->sk);
> +		skb->sk = NULL;
> +	}
> +
>  	if (!pskb_pull(skb, offset))
>  		return NULL;
>  
> @@ -103,7 +114,7 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
>  
>  	/* We don't need to handle errors from xfrm_input, it does all
>  	 * the error handling and frees the resources on error. */
> -	xfrm_input(skb, IPPROTO_ESP, spi, 0);
> +	xfrm_input(skb, IPPROTO_ESP, spi, encap_type);
>  
>  	return ERR_PTR(-EINPROGRESS);
>  out_reset:
> diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
> index 04cbeefd8982..cd18ca75c9f6 100644
> --- a/net/ipv6/xfrm6_input.c
> +++ b/net/ipv6/xfrm6_input.c
> @@ -16,6 +16,8 @@
>  #include <linux/netfilter_ipv6.h>
>  #include <net/ipv6.h>
>  #include <net/xfrm.h>
> +#include <net/protocol.h>
> +#include <net/gro.h>
>  
>  int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi,
>  		  struct ip6_tnl *t)
> @@ -67,14 +69,7 @@ int xfrm6_transport_finish(struct sk_buff *skb, int async)
>  	return 0;
>  }
>  
> -/* If it's a keepalive packet, then just eat it.
> - * If it's an encapsulated packet, then pass it to the
> - * IPsec xfrm input.
> - * Returns 0 if skb passed to xfrm or was dropped.
> - * Returns >0 if skb should be passed to UDP.
> - * Returns <0 if skb should be resubmitted (-ret is protocol)
> - */
> -int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
> +static int __xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb, bool pull)
>  {
>  	struct udp_sock *up = udp_sk(sk);
>  	struct udphdr *uh;
> @@ -106,7 +101,7 @@ int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
>  	case UDP_ENCAP_ESPINUDP:
>  		/* Check if this is a keepalive packet.  If so, eat it. */
>  		if (len == 1 && udpdata[0] == 0xff) {
> -			goto drop;
> +			return -EINVAL;
>  		} else if (len > sizeof(struct ip_esp_hdr) && udpdata32[0] != 0) {
>  			/* ESP Packet without Non-ESP header */
>  			len = sizeof(struct udphdr);
> @@ -117,7 +112,7 @@ int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
>  	case UDP_ENCAP_ESPINUDP_NON_IKE:
>  		/* Check if this is a keepalive packet.  If so, eat it. */
>  		if (len == 1 && udpdata[0] == 0xff) {
> -			goto drop;
> +			return -EINVAL;
>  		} else if (len > 2 * sizeof(u32) + sizeof(struct ip_esp_hdr) &&
>  			   udpdata32[0] == 0 && udpdata32[1] == 0) {
>  
> @@ -135,31 +130,99 @@ int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
>  	 * protocol to ESP, and then call into the transform receiver.
>  	 */
>  	if (skb_unclone(skb, GFP_ATOMIC))
> -		goto drop;
> +		return -EINVAL;
>  
>  	/* Now we can update and verify the packet length... */
>  	ip6h = ipv6_hdr(skb);
>  	ip6h->payload_len = htons(ntohs(ip6h->payload_len) - len);
>  	if (skb->len < ip6hlen + len) {
>  		/* packet is too small!?! */
> -		goto drop;
> +		return -EINVAL;
>  	}
>  
>  	/* pull the data buffer up to the ESP header and set the
>  	 * transport header to point to ESP.  Keep UDP on the stack
>  	 * for later.
>  	 */
> -	__skb_pull(skb, len);
> -	skb_reset_transport_header(skb);
> +	if (pull) {
> +		__skb_pull(skb, len);
> +		skb_reset_transport_header(skb);
> +	} else {
> +		skb_set_transport_header(skb, len);
> +	}
>  
>  	/* process ESP */
> -	return xfrm6_rcv_encap(skb, IPPROTO_ESP, 0, encap_type);
> -
> -drop:
> -	kfree_skb(skb);
>  	return 0;
>  }
>  
> +/* If it's a keepalive packet, then just eat it.
> + * If it's an encapsulated packet, then pass it to the
> + * IPsec xfrm input.
> + * Returns 0 if skb passed to xfrm or was dropped.
> + * Returns >0 if skb should be passed to UDP.
> + * Returns <0 if skb should be resubmitted (-ret is protocol)
> + */
> +int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
> +{
> +	int ret;
> +
> +	ret = __xfrm6_udp_encap_rcv(sk, skb, true);
> +	if (!ret)
> +		return xfrm6_rcv_encap(skb, IPPROTO_ESP, 0,
> +				       udp_sk(sk)->encap_type);
> +
> +	if (ret < 0) {
> +		kfree_skb(skb);
> +		return 0;
> +	}
> +
> +	return ret;
> +}
> +
> +struct sk_buff *xfrm6_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
> +					struct sk_buff *skb)
> +{
> +	int offset = skb_gro_offset(skb);
> +	const struct net_offload *ops;
> +	struct sk_buff *pp = NULL;
> +	int ret;
> +
> +	offset = offset - sizeof(struct udphdr);
> +
> +	if (!pskb_pull(skb, offset))
> +		return NULL;
> +
> +	if (!refcount_inc_not_zero(&sk->sk_refcnt))
> +		return NULL;
> +
> +	rcu_read_lock();
> +	ops = rcu_dereference(inet6_offloads[IPPROTO_ESP]);
> +	if (!ops || !ops->callbacks.gro_receive)
> +		goto out;
> +
> +	ret = __xfrm6_udp_encap_rcv(sk, skb, false);
> +	if (ret)
> +		goto out;
> +
> +	skb->sk = sk;
> +	skb_push(skb, offset);
> +	NAPI_GRO_CB(skb)->proto = IPPROTO_UDP;
> +
> +	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
> +	rcu_read_unlock();
> +
> +	return pp;
> +
> +out:
> +	rcu_read_unlock();
> +	sock_put(sk);
> +	skb_push(skb, offset);
> +	NAPI_GRO_CB(skb)->same_flow = 0;
> +	NAPI_GRO_CB(skb)->flush = 1;
> +
> +	return NULL;

This function looks like a copy and paste, maybe:

struct sk_buff *xfrm_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
                                       struct sk_buff *skb, const struct net_offload *ops,
                                       int (*encap_rcv)(struct sock *sk, struct sk_buff *skb, bool x))
{
        ...
}

Then, pass __xfrm4_udp_encap_rcv() and __xfrm6_udp_encap_rcv() and
net_offload, so IPv4 and IPv6 use the same function.
