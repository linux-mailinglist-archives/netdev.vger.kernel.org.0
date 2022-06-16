Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CE154E828
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiFPQzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbiFPQzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:55:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8585369F4
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 53749CE25CB
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 16:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A5BC3411A;
        Thu, 16 Jun 2022 16:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655398496;
        bh=CH7RnYu3pzJtcRBY6+l3MjsGpg6xtLriVO1e9fMlbfE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E91c4Xz7ODmmTUKeTsGbR9/ibpasgtRCAUBR0FqiX4enctP8ZiNKGy5Fzie9bMYlI
         saWrOZ3v4kNPEbG4llsfPKpYzkhOJB4kRqNmlAWmPmNI0xM3g2SFzGuWpzu0V3wT03
         MMoN2YA+NxdonMk8umBgrMZ5QLfS9x5St9QJ3mJS7P12yr69opbxC+03Hpy2+15BXO
         ikdIViugeEdT9SeyBTVt/l/dlthuJZ5c6RVn/cS1krJ1WxWauOBmowp9O+23PDqTi4
         sQjqEdSqMhpGeGUVK6O/2znq9nvANzh4PyGDj4B3qviSHFdPbTnpIHCXxHjxJe/LwJ
         gtI/Qg+HJvmuA==
Date:   Thu, 16 Jun 2022 09:54:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        brouer@redhat.com, imagedong@tencent.com, vasily.averin@linux.dev,
        talalahmad@google.com, luiz.von.dentz@intel.com,
        jk@codeconstruct.com.au, netdev@vger.kernel.org
Subject: Re: [PATCH] net: helper function for skb_shift
Message-ID: <20220616095455.012db786@kernel.org>
In-Reply-To: <20220616122617.GA2237@debian>
References: <20220616122617.GA2237@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 14:26:29 +0200 Richard Gobert wrote:
> Move the len fields manipulation in the skbs to a helper function.
> There is a comment specifically requesting this. This improves the
> readability of skb_shift.
> 
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
>  net/core/skbuff.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 30b523fa4ad2..8a0a941915e8 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3508,6 +3508,19 @@ static int skb_prepare_for_shift(struct sk_buff *skb)
>  }
>  
>  /**
> + * skb_shift_len - Update length fields of skbs when shifting.
> + */

1) this is not a valid kdoc
2) I don't see the point unless we have another user of this helper

> +static inline void skb_shift_len(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
> +{
> +	skb->len -= shiftlen;
> +	skb->data_len -= shiftlen;
> +	skb->truesize -= shiftlen;
> +	tgt->len += shiftlen;
> +	tgt->data_len += shiftlen;
> +	tgt->truesize += shiftlen;
> +}
> +
> +/**
>   * skb_shift - Shifts paged data partially from skb to another
>   * @tgt: buffer into which tail data gets added
>   * @skb: buffer from which the paged data comes from
> @@ -3634,14 +3647,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
>  	tgt->ip_summed = CHECKSUM_PARTIAL;
>  	skb->ip_summed = CHECKSUM_PARTIAL;
>  
> -	/* Yak, is it really working this way? Some helper please? */
> -	skb->len -= shiftlen;
> -	skb->data_len -= shiftlen;
> -	skb->truesize -= shiftlen;
> -	tgt->len += shiftlen;
> -	tgt->data_len += shiftlen;
> -	tgt->truesize += shiftlen;
> -
> +	skb_shift_len(tgt, skb, shiftlen);
>  	return shiftlen;
>  }
>  

