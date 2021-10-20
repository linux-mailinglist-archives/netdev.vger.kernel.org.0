Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A074347A2
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhJTJJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhJTJJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 05:09:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A3B660F25;
        Wed, 20 Oct 2021 09:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634720853;
        bh=jTUKR+Xf/qDYN96zbVV7NGYiZBynFhnV+TqkshXTLhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hd8M+wEDqUgR0CDmyM92YxlmvueFDTMDwiT0YaLIvAHhTtxPgEDBBGLDbXZjDUDKg
         oD/e/75nKCnvsciIXfDVJevR/f/Q5eZX1hd3Un5NU/pxr66J3qAFL8QVB23UYWpDFB
         KfGQvcaaeyoYjiOFTE79RRJK/iwHIbo4mhVptaj9Ufkfl6qsTNNuq5uBJSwOZqzRI3
         P0AQwUlT+erRG5goaAOlkpTSzVF8pRwuus+nvn1kNShlrxFD396pytvmot8YFlj2xl
         qt3Z3XEId14UYRCzVurMbMXohZY5obdQndPzgVrDdKxa05QQD3ylbIrcmidoSJS/Po
         OVaCdmotQCOuw==
Date:   Wed, 20 Oct 2021 11:07:29 +0200
From:   Simon Horman <horms@kernel.org>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, penghao luo <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] xfrm: Remove redundant fields
Message-ID: <20211020090729.GC3935@kernel.org>
References: <20211018091758.858899-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018091758.858899-1-luo.penghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 09:17:58AM +0000, luo penghao wrote:
> From: penghao luo <luo.penghao@zte.com.cn>
> 
> the variable err is not necessary in such places. It should be revmoved
> for the simplicity of the code.
> 
> The clang_analyzer complains as follows:
> 
> net/xfrm/xfrm_input.c:530: warning:
> 
> Although the value stored to 'err' is used in the enclosing expression,
> the value is never actually read from 'err'.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: penghao luo <luo.penghao@zte.com.cn>
> ---
>  net/xfrm/xfrm_input.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> index 3df0861..ff34667 100644
> --- a/net/xfrm/xfrm_input.c
> +++ b/net/xfrm/xfrm_input.c
> @@ -530,7 +530,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
>  				goto drop;
>  			}
>  
> -			if ((err = xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
> +			if ((xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {

I agree that assigning the value to err is not needed.
But you may also wish to consider:

1. Dropping the () around the call to xfrm_parse_spi, which seem out of
   place now.
2. Dropping the explicit check against zero

Which would leave you with:

			if (xfrm_parse_spi(skb, nexthdr, &spi, &seq)) {

>  				XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
>  				goto drop;
>  			}
> @@ -560,7 +560,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
>  	}
>  
>  	seq = 0;
> -	if (!spi && (err = xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
> +	if (!spi && (xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
>  		secpath_reset(skb);
>  		XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
>  		goto drop;
> -- 
> 2.15.2
> 
> 
