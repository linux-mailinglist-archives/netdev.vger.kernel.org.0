Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEFC2B78CF
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgKRIbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:31:15 -0500
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:55854 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727154AbgKRIbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:31:15 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 36C4818021461;
        Wed, 18 Nov 2020 08:31:14 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3872:4321:5007:6119:6737:10004:10400:10848:11026:11658:11783:11914:12043:12048:12296:12297:12679:12740:12895:13069:13311:13357:13439:13894:14659:14721:21080:21627:21990:30054:30070:30080:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: horse56_4e0bd9427338
X-Filterd-Recvd-Size: 2407
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Wed, 18 Nov 2020 08:31:11 +0000 (UTC)
Message-ID: <af05dec1ea9366c2374cb35a559a1156cf605b80.camel@perches.com>
Subject: Re: [PATCH] net/core: use xx_zalloc instead xx_alloc and memset
From:   Joe Perches <joe@perches.com>
To:     Tian Tao <tiantao6@hisilicon.com>, davem@davemloft.net,
        kuba@kernel.org, linmiaohe@huawei.com, martin.varghese@nokia.com,
        pshelar@ovn.org, pabeni@redhat.com, fw@strlen.de,
        viro@zeniv.linux.org.uk, gnault@redhat.com,
        steffen.klassert@secunet.com, kyk.segfault@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 18 Nov 2020 00:31:10 -0800
In-Reply-To: <1605687308-57318-1-git-send-email-tiantao6@hisilicon.com>
References: <1605687308-57318-1-git-send-email-tiantao6@hisilicon.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-18 at 16:15 +0800, Tian Tao wrote:
> use kmem_cache_zalloc instead kmem_cache_alloc and memset.
[]
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
[]
> @@ -313,12 +313,10 @@ struct sk_buff *__build_skb(void *data, unsigned int frag_size)
>  {
>  	struct sk_buff *skb;
>  
> -	skb = kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
> +	skb = kmem_cache_zalloc(skbuff_head_cache, GFP_ATOMIC);
>  	if (unlikely(!skb))
>  		return NULL;
>  
> -	memset(skb, 0, offsetof(struct sk_buff, tail));
> -
>  	return __build_skb_around(skb, data, frag_size);
>  }
>  
> 
> @@ -6170,12 +6168,10 @@ static void *skb_ext_get_ptr(struct skb_ext *ext, enum skb_ext_id id)
>   */
>  struct skb_ext *__skb_ext_alloc(gfp_t flags)
>  {
> -	struct skb_ext *new = kmem_cache_alloc(skbuff_ext_cache, flags);
> +	struct skb_ext *new = kmem_cache_zalloc(skbuff_ext_cache, flags);
>  
> -	if (new) {
> -		memset(new->offset, 0, sizeof(new->offset));
> +	if (new)
>  		refcount_set(&new->refcnt, 1);
> -	}
>  
>  	return new;
>  }

I think it'd be nicer to use the same form for both of these functions.
This could be:

struct skb_ext *__skb_ext_alloc(gfp_t flags)
{
	struct skb_ext *new;

	new = kmem_cache_zalloc(skbbuff_ext_cache, flags);
	if (unlikely(!new))
		return NULL;

	refcount_set(&new->refcnt, 1);

	return new;
}


