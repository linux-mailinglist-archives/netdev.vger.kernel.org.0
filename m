Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3979F51F4D8
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 08:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiEIGdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 02:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiEIGaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 02:30:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADDCC183AE;
        Sun,  8 May 2022 23:26:12 -0700 (PDT)
Date:   Mon, 9 May 2022 08:26:08 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] netfilter: nft_flow_offload: skip dst neigh lookup
 for ppp devices
Message-ID: <Yni0AIc06fBELtXz@salvia>
References: <20220506131841.3177-1-nbd@nbd.name>
 <20220506131841.3177-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220506131841.3177-2-nbd@nbd.name>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Series LGTM.

Would you repost adding Fixes: tag and target nf tree?

Thanks.

On Fri, May 06, 2022 at 03:18:39PM +0200, Felix Fietkau wrote:
> The dst entry does not contain a valid hardware address, so skip the lookup
> in order to avoid running into errors here.
> The proper hardware address is filled in from nft_dev_path_info
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  net/netfilter/nft_flow_offload.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 900d48c810a1..d88de26aad75 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -36,6 +36,15 @@ static void nft_default_forward_path(struct nf_flow_route *route,
>  	route->tuple[dir].xmit_type	= nft_xmit_type(dst_cache);
>  }
>  
> +static bool nft_is_valid_ether_device(const struct net_device *dev)
> +{
> +	if (!dev || (dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
> +	    dev->addr_len != ETH_ALEN || !is_valid_ether_addr(dev->dev_addr))
> +		return false;
> +
> +	return true;
> +}
> +
>  static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
>  				     const struct dst_entry *dst_cache,
>  				     const struct nf_conn *ct,
> @@ -47,6 +56,9 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
>  	struct neighbour *n;
>  	u8 nud_state;
>  
> +	if (!nft_is_valid_ether_device(dev))
> +		goto out;
> +
>  	n = dst_neigh_lookup(dst_cache, daddr);
>  	if (!n)
>  		return -1;
> @@ -60,6 +72,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
>  	if (!(nud_state & NUD_VALID))
>  		return -1;
>  
> +out:
>  	return dev_fill_forward_path(dev, ha, stack);
>  }
>  
> @@ -78,15 +91,6 @@ struct nft_forward_info {
>  	enum flow_offload_xmit_type xmit_type;
>  };
>  
> -static bool nft_is_valid_ether_device(const struct net_device *dev)
> -{
> -	if (!dev || (dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
> -	    dev->addr_len != ETH_ALEN || !is_valid_ether_addr(dev->dev_addr))
> -		return false;
> -
> -	return true;
> -}
> -
>  static void nft_dev_path_info(const struct net_device_path_stack *stack,
>  			      struct nft_forward_info *info,
>  			      unsigned char *ha, struct nf_flowtable *flowtable)
> -- 
> 2.35.1
> 
