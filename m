Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AFF39B484
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 10:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFDIDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 04:03:22 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:33342 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhFDIDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 04:03:19 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 64628800056;
        Fri,  4 Jun 2021 10:01:32 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 10:01:32 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 4 Jun 2021
 10:01:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 897153180326; Fri,  4 Jun 2021 10:01:31 +0200 (CEST)
Date:   Fri, 4 Jun 2021 10:01:31 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Huy Nguyen <huyn@nvidia.com>
CC:     <netdev@vger.kernel.org>, <saeedm@nvidia.com>, <borisp@nvidia.com>,
        <raeds@nvidia.com>, <danielj@nvidia.com>, <yossiku@nvidia.com>,
        <kuba@kernel.org>
Subject: Re: [RESEND PATCH net v3 2/3] net/xfrm: Add inner_ipproto into
 sec_path
Message-ID: <20210604080131.GF40979@gauss3.secunet.de>
References: <20210603160045.11805-1-huyn@nvidia.com>
 <20210603160045.11805-3-huyn@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210603160045.11805-3-huyn@nvidia.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 07:00:44PM +0300, Huy Nguyen wrote:
>  
> +/* For partial checksum offload, the outer header checksum is calculated
> + * by software and the inner header checksum is calculated by hardware.
> + * This requires hardware to know the inner packet type to calculate
> + * the inner header checksum. Save inner ip protocol here to avoid
> + * traversing the packet in the vendor's xmit code.
> + * If the encap type is IPIP, just save skb->inner_ipproto. Otherwise,
> + * get the ip protocol from the IP header.
> + */
> +static void xfrm_get_inner_ipproto(struct sk_buff *skb)
> +{
> +	struct xfrm_offload *xo = xfrm_offload(skb);
> +	const struct ethhdr *eth;
> +
> +	if (!skb->inner_protocol)
> +		return;

inner_protocol is only valid if skb->encapsulation is set, maybe
you should test for that before calling this function. In particular,
you should do that before we set it explicitly in xfrm_output.

> +
> +	xo = xfrm_offload(skb);
> +	if (!xo)
> +		return;
> +
> +	if (skb->inner_protocol_type == ENCAP_TYPE_IPPROTO) {
> +		xo->inner_ipproto = skb->inner_ipproto;
> +		return;
> +	}
> +
> +	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER)
> +		return;
> +
> +	eth = (struct ethhdr *)skb_inner_mac_header(skb);
> +
> +	switch (ntohs(eth->h_proto)) {
> +	case ETH_P_IPV6:
> +		xo->inner_ipproto = inner_ipv6_hdr(skb)->nexthdr;
> +		break;
> +	case ETH_P_IP:
> +		xo->inner_ipproto = inner_ip_hdr(skb)->protocol;
> +		break;
> +	}
> +}
> +
>  int xfrm_output(struct sock *sk, struct sk_buff *skb)
>  {
>  	struct net *net = dev_net(skb_dst(skb)->dev);
> @@ -594,12 +634,14 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
>  			kfree_skb(skb);
>  			return -ENOMEM;
>  		}
> -		skb->encapsulation = 1;
>  
> +		skb->encapsulation = 1;
>  		sp->olen++;
>  		sp->xvec[sp->len++] = x;
>  		xfrm_state_hold(x);
>  
> +		xfrm_get_inner_ipproto(skb);
> +
>  		if (skb_is_gso(skb)) {
>  			if (skb->inner_protocol)
>  				return xfrm_output_gso(net, sk, skb);
> -- 
> 2.24.1
