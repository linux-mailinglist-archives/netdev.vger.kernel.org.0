Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C0EE953A
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfJ3DSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:18:50 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:33235 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfJ3DSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 23:18:50 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2019 23:18:48 EDT
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 357FD41856;
        Wed, 30 Oct 2019 11:09:56 +0800 (CST)
Subject: Re: [PATCH nf-next] netfilter: nf_tables_offload: allow ethernet
 interface type only
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     jiri@resnulli.us, netdev@vger.kernel.org
References: <20191029104057.21894-1-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <4b32ec17-d7e1-f79f-2f90-522e2c810721@ucloud.cn>
Date:   Wed, 30 Oct 2019 11:09:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029104057.21894-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEJKS0tLSk5KTUhPSUlZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6My46EAw6HTgyAxwwEQMCAgsC
        Lg5PCz5VSlVKTkxJT0tPQkJNT05KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSU1CSzcG
X-HM-Tid: 0a6e1aa4290c2086kuqy357fd41856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/29/2019 6:40 PM, Pablo Neira Ayuso wrote:
> @@ -113,6 +114,7 @@ static int __nft_cmp_offload(struct nft_offload_ctx *ctx,
>  			     const struct nft_cmp_expr *priv)
>  {
>  	struct nft_offload_reg *reg = &ctx->regs[priv->sreg];
> +	static u16 iftype_ether = ARPHRD_ETHER;
>  	u8 *mask = (u8 *)&flow->match.mask;
>  	u8 *key = (u8 *)&flow->match.key;
>  
> @@ -125,6 +127,11 @@ static int __nft_cmp_offload(struct nft_offload_ctx *ctx,
>  	flow->match.dissector.used_keys |= BIT(reg->key);
>  	flow->match.dissector.offset[reg->key] = reg->base_offset;
>  
> +	if (reg->key == FLOW_DISSECTOR_KEY_META &&
> +	    reg->offset == offsetof(struct nft_flow_key, meta.ingress_iftype) &&
> +	    memcmp(&priv->data, &iftype_ether, priv->len))
Maybe it is better to check the priv->len == sizeof(u16)?
> +		return -EOPNOTSUPP;
> +
>  	nft_offload_update_dependency(ctx, &priv->data, priv->len);
>  
>  	return 0;
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 8fd21f436347..6fb6a6778e68 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -551,6 +551,10 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
>  		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_META, meta,
>  				  ingress_ifindex, sizeof(__u32), reg);
>  		break;
> +	case NFT_META_IIFTYPE:
> +		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_META, meta,
> +				  ingress_iftype, sizeof(__u16), reg);
> +		break;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
