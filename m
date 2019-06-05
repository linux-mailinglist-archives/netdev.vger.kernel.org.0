Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC9136182
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 18:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfFEQkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 12:40:40 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59248 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728661AbfFEQkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 12:40:40 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hYYxg-0002aW-5g; Wed, 05 Jun 2019 12:40:36 -0400
Date:   Wed, 5 Jun 2019 12:40:00 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next] net: Drop unlikely before IS_ERR(_OR_NULL)
Message-ID: <20190605164000.GB554@hmswarspite.think-freely.org>
References: <20190605142428.84784-1-wangkefeng.wang@huawei.com>
 <20190605142428.84784-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605142428.84784-3-wangkefeng.wang@huawei.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 10:24:26PM +0800, Kefeng Wang wrote:
> IS_ERR(_OR_NULL) already contain an 'unlikely' compiler flag,
> so no need to do that again from its callers. Drop it.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-sctp@vger.kernel.org
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/net/udp.h           | 2 +-
>  net/ipv4/fib_semantics.c    | 2 +-
>  net/ipv4/inet_hashtables.c  | 2 +-
>  net/ipv4/udp.c              | 2 +-
>  net/ipv4/udp_offload.c      | 2 +-
>  net/ipv6/inet6_hashtables.c | 2 +-
>  net/ipv6/udp.c              | 2 +-
>  net/sctp/socket.c           | 4 ++--
>  8 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 79d141d2103b..bad74f780831 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -480,7 +480,7 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
>  	 * CB fragment
>  	 */
>  	segs = __skb_gso_segment(skb, features, false);
> -	if (unlikely(IS_ERR_OR_NULL(segs))) {
> +	if (IS_ERR_OR_NULL(segs)) {
>  		int segs_nr = skb_shinfo(skb)->gso_segs;
>  
>  		atomic_add(segs_nr, &sk->sk_drops);
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index b80410673915..cd35bd0a4d8a 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -1295,7 +1295,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
>  		goto failure;
>  	fi->fib_metrics = ip_fib_metrics_init(fi->fib_net, cfg->fc_mx,
>  					      cfg->fc_mx_len, extack);
> -	if (unlikely(IS_ERR(fi->fib_metrics))) {
> +	if (IS_ERR(fi->fib_metrics)) {
>  		err = PTR_ERR(fi->fib_metrics);
>  		kfree(fi);
>  		return ERR_PTR(err);
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index c4503073248b..97824864e40d 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -316,7 +316,7 @@ struct sock *__inet_lookup_listener(struct net *net,
>  				    saddr, sport, htonl(INADDR_ANY), hnum,
>  				    dif, sdif);
>  done:
> -	if (unlikely(IS_ERR(result)))
> +	if (IS_ERR(result))
>  		return NULL;
>  	return result;
>  }
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 189144346cd4..8983afe2fe9e 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -478,7 +478,7 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
>  					  htonl(INADDR_ANY), hnum, dif, sdif,
>  					  exact_dif, hslot2, skb);
>  	}
> -	if (unlikely(IS_ERR(result)))
> +	if (IS_ERR(result))
>  		return NULL;
>  	return result;
>  }
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index 06b3e2c1fcdc..0112f64faf69 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -208,7 +208,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
>  		gso_skb->destructor = NULL;
>  
>  	segs = skb_segment(gso_skb, features);
> -	if (unlikely(IS_ERR_OR_NULL(segs))) {
> +	if (IS_ERR_OR_NULL(segs)) {
>  		if (copy_dtor)
>  			gso_skb->destructor = sock_wfree;
>  		return segs;
> diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
> index b2a55f300318..cf60fae9533b 100644
> --- a/net/ipv6/inet6_hashtables.c
> +++ b/net/ipv6/inet6_hashtables.c
> @@ -174,7 +174,7 @@ struct sock *inet6_lookup_listener(struct net *net,
>  				     saddr, sport, &in6addr_any, hnum,
>  				     dif, sdif);
>  done:
> -	if (unlikely(IS_ERR(result)))
> +	if (IS_ERR(result))
>  		return NULL;
>  	return result;
>  }
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index b3418a7c5c74..693518350f79 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -215,7 +215,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
>  					  exact_dif, hslot2,
>  					  skb);
>  	}
> -	if (unlikely(IS_ERR(result)))
> +	if (IS_ERR(result))
>  		return NULL;
>  	return result;
>  }
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 39ea0a37af09..c7b0f51c19d5 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -985,7 +985,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  		return -EINVAL;
>  
>  	kaddrs = memdup_user(addrs, addrs_size);
> -	if (unlikely(IS_ERR(kaddrs)))
> +	if (IS_ERR(kaddrs))
>  		return PTR_ERR(kaddrs);
>  
>  	/* Walk through the addrs buffer and count the number of addresses. */
> @@ -1315,7 +1315,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
>  		return -EINVAL;
>  
>  	kaddrs = memdup_user(addrs, addrs_size);
> -	if (unlikely(IS_ERR(kaddrs)))
> +	if (IS_ERR(kaddrs))
>  		return PTR_ERR(kaddrs);
>  
>  	/* Allow security module to validate connectx addresses. */
> -- 
> 2.20.1
> 
> 
for the SCTP bits
Acked-by: Neil Horman <nhorman@tuxdriver.com>

