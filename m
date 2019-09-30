Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674B7C26BF
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732364AbfI3Uji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:39:38 -0400
Received: from ja.ssi.bg ([178.16.129.10]:40674 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731474AbfI3Ujh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 16:39:37 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x8UIncN1008757;
        Mon, 30 Sep 2019 21:49:39 +0300
Date:   Mon, 30 Sep 2019 21:49:38 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     zhang kai <zhangkaiheb@126.com>
cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] ipvs: no need to update skb route entry for local
 destination packets.
In-Reply-To: <20190930051455.GA20692@toolchain>
Message-ID: <alpine.LFD.2.21.1909302146530.2706@ja.home.ssi.bg>
References: <20190930051455.GA20692@toolchain>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 30 Sep 2019, zhang kai wrote:

> In the end of function __ip_vs_get_out_rt/__ip_vs_get_out_rt_v6,the
> 'local' variable is always zero.
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

	Simon, this is for -next kernels...

> ---
>  net/netfilter/ipvs/ip_vs_xmit.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index 9c464d24beec..037c7c91044e 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -407,12 +407,9 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
>  		goto err_put;
>  
>  	skb_dst_drop(skb);
> -	if (noref) {
> -		if (!local)
> -			skb_dst_set_noref(skb, &rt->dst);
> -		else
> -			skb_dst_set(skb, dst_clone(&rt->dst));
> -	} else
> +	if (noref)
> +		skb_dst_set_noref(skb, &rt->dst);
> +	else
>  		skb_dst_set(skb, &rt->dst);
>  
>  	return local;
> @@ -574,12 +571,9 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
>  		goto err_put;
>  
>  	skb_dst_drop(skb);
> -	if (noref) {
> -		if (!local)
> -			skb_dst_set_noref(skb, &rt->dst);
> -		else
> -			skb_dst_set(skb, dst_clone(&rt->dst));
> -	} else
> +	if (noref)
> +		skb_dst_set_noref(skb, &rt->dst);
> +	else
>  		skb_dst_set(skb, &rt->dst);
>  
>  	return local;
> -- 
> 2.17.1

Regards

--
Julian Anastasov <ja@ssi.bg>
