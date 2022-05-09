Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504D4520379
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbiEIRY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiEIRY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:24:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87D01116F
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6399761570
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821E1C385B2;
        Mon,  9 May 2022 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652116860;
        bh=qudMDqmlv5s0HRpKIFsr8xGIW7uRO+URTEC/9qkCMhE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d/wMvY2/cBQfKSfZ5p6DwIhGT7lStgdRHnwTePEYu0N0e829gS6ISkWO3T0Zyg7As
         njpbUbD5OD2z0F6vvIdUUcNlzwuncv0Wz7Nfx7vLV4CRdUJhl6Z1q6Jn5ORUAZLqzN
         Z7GzNCAhWGZzq3FXe5t/cl+8BkFv/0PDLnhQHy7lhSKxUVc04F2/LRYdda6rcjKtt9
         xW/SmdUyV679GA62kAoJCvR0qH5RWhtfNsMEfvNVFVLGDtuQbvjyeWmRyAMIzs3Xc3
         KOi0D6oGNAzLh8018LjDx39RNl1ifn8A3gZvTjt00apXPzsguZTdoQDeYJSpXFYXnU
         jdI0f4qAoVF0g==
Date:   Mon, 9 May 2022 10:20:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: warn if transport header was not set
Message-ID: <20220509102059.26f1f16f@kernel.org>
In-Reply-To: <20220509165716.745111-1-eric.dumazet@gmail.com>
References: <20220509165716.745111-1-eric.dumazet@gmail.com>
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

On Mon,  9 May 2022 09:57:16 -0700 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Make sure skb_transport_header() and skb_transport_offset() uses
> are not fooled if the transport header has not been set.
> 
> This change will likely expose existing bugs in linux networking stacks.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/linux/skbuff.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index d58669d6cb91aa30edc70d59a0a7e9d4e2298842..043c59fa0bd6d921f2d2e211348929681bfce186 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2804,6 +2804,7 @@ static inline bool skb_transport_header_was_set(const struct sk_buff *skb)
>  
>  static inline unsigned char *skb_transport_header(const struct sk_buff *skb)
>  {
> +	WARN_ON_ONCE(!skb_transport_header_was_set(skb));
>  	return skb->head + skb->transport_header;
>  }
>  

This is for prod or for syzbot?

What are your feelings on putting this under a kconfig?

We already have a #ifdef DEBUG in skb_checksum_none_assert()
we could generalize that into some form of kconfig-gated
SKB_CHECK(). Kconfig-gated so that people don't feel self-conscious
about using it. I wrote such a patch a few times already but never 
sent it.
