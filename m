Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B3E2B7BAE
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 11:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgKRKrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 05:47:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727739AbgKRKrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 05:47:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605696431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YwZxwwPGug2FmlVJknT/fA/Ax4qLJ0AR2iLC3Jt+Az4=;
        b=eZIABOmCC//MV4XV0ipLzI1/c4V1Y2HyGu3Refu3Wr/ayBKBHy2zci8H4eEFYulhq6Zt8D
        fdjNIvEA3eA9uTZ+EU0RgDp7WxqifO/QCL0qhVNo0iT8lufK5YIlT7yDdfmij4R5vytB/p
        RVopPjoJOCD25jIWXOLXeNQm4pUH1YA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-MLpPsVLWNSu5mc6CLNWcww-1; Wed, 18 Nov 2020 05:47:07 -0500
X-MC-Unique: MLpPsVLWNSu5mc6CLNWcww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 517CA1084C99;
        Wed, 18 Nov 2020 10:47:05 +0000 (UTC)
Received: from ovpn-115-70.ams2.redhat.com (ovpn-115-70.ams2.redhat.com [10.36.115.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D94675D707;
        Wed, 18 Nov 2020 10:47:01 +0000 (UTC)
Message-ID: <f29be74792c7711e0a157a6a024d3998d30be4dd.camel@redhat.com>
Subject: Re: [PATCH] net/core: use xx_zalloc instead xx_alloc and memset
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tian Tao <tiantao6@hisilicon.com>, davem@davemloft.net,
        kuba@kernel.org, linmiaohe@huawei.com, martin.varghese@nokia.com,
        pshelar@ovn.org, fw@strlen.de, viro@zeniv.linux.org.uk,
        gnault@redhat.com, steffen.klassert@secunet.com,
        kyk.segfault@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 18 Nov 2020 11:47:00 +0100
In-Reply-To: <1605687308-57318-1-git-send-email-tiantao6@hisilicon.com>
References: <1605687308-57318-1-git-send-email-tiantao6@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-18 at 16:15 +0800, Tian Tao wrote:
> use kmem_cache_zalloc instead kmem_cache_alloc and memset.
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  net/core/skbuff.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index c9a5a3c..3449c1c 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -313,12 +313,10 @@ struct sk_buff *__build_skb(void *data, unsigned int frag_size)
>  {
>  	struct sk_buff *skb;
>  
> -	skb = kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
> +	skb = kmem_cache_zalloc(skbuff_head_cache, GFP_ATOMIC);

This will zeroed a slighly larger amount of data compared to the
existing code: offsetof(struct sk_buff, tail) == 182, sizeof(struct
sk_buff) == 224.

>  	if (unlikely(!skb))
>  		return NULL;
>  
> -	memset(skb, 0, offsetof(struct sk_buff, tail));

Additionally this leverages constant argument optimizations.

Possibly overall not noticeable, but this code path is quite critical
performance wise.

I would avoid the above.
> -
>  	return __build_skb_around(skb, data, frag_size);
>  }
>  
> @@ -6170,12 +6168,10 @@ static void *skb_ext_get_ptr(struct skb_ext *ext, enum skb_ext_id id)
>   */
>  struct skb_ext *__skb_ext_alloc(gfp_t flags)
>  {
> -	struct skb_ext *new = kmem_cache_alloc(skbuff_ext_cache, flags);
> +	struct skb_ext *new = kmem_cache_zalloc(skbuff_ext_cache, flags);
>  
> -	if (new) {
> -		memset(new->offset, 0, sizeof(new->offset));

Similar to the above, but additionally here the number of zeroed bytes
changes a lot and a few additional cachelines will be touched. The
performance impact is likely relevant.

Overall I think we should not do this.

Thanks,

Paolo

