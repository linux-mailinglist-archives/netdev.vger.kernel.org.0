Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816F260B735
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiJXTVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiJXTU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:20:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5612DAB7;
        Mon, 24 Oct 2022 10:56:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F339D1FDA7;
        Mon, 24 Oct 2022 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666634166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/4AsP2lH5VLRlMfCDU8gypauekMVyVorINlnPMIld2U=;
        b=NwYY16UVbu0Qf9CD5Uf4XGmdYIdwelYRbEAYjhqsDilgO2tetDQdlOE+5nkt50vXfPLrCC
        IQ0zVd4V122Oyq5G5yp9b/f/VDlm7L7fBTpoBLfj0TW+bYbmxUVjwijSqf/I6mmrwhESIc
        208fQlSQ0MM3C2R3NcCKcSjSuWpVNTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666634166;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/4AsP2lH5VLRlMfCDU8gypauekMVyVorINlnPMIld2U=;
        b=UNKXMSF60pToCIgoUKZ5sgBRBY89POUDW/+xz3htk59YQWXppXxCDsNsKfLiPdbCE/qV/G
        E5S/5pRictJz5FAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C1D0813357;
        Mon, 24 Oct 2022 17:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cH6CLrXRVmOmEAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 24 Oct 2022 17:56:05 +0000
Message-ID: <f8d72aa1-3f64-b1a1-b776-f8c181f09ca4@suse.cz>
Date:   Mon, 24 Oct 2022 19:56:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v4] skbuff: Proactively round up to kmalloc bucket size
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        David Rientjes <rientjes@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20221021234713.you.031-kees@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20221021234713.you.031-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/22 01:49, Kees Cook wrote:
> Instead of discovering the kmalloc bucket size _after_ allocation, round
> up proactively so the allocation is explicitly made for the full size,
> allowing the compiler to correctly reason about the resulting size of
> the buffer through the existing __alloc_size() hint.
> 
> This will allow for kernels built with CONFIG_UBSAN_BOUNDS or the
> coming dynamic bounds checking under CONFIG_FORTIFY_SOURCE to gain
> back the __alloc_size() hints that were temporarily reverted in commit
> 93dd04ab0b2b ("slab: remove __alloc_size attribute from __kmalloc_track_caller")
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Nit below:

> ---
> v4: use kmalloc_size_roundup() in callers, not kmalloc_reserve()
> v3: https://lore.kernel.org/lkml/20221018093005.give.246-kees@kernel.org
> v2: https://lore.kernel.org/lkml/20220923202822.2667581-4-keescook@chromium.org
> ---
>  net/core/skbuff.c | 50 +++++++++++++++++++++++------------------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 651a82d30b09..77af430296e2 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -508,14 +508,14 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  	 */
>  	size = SKB_DATA_ALIGN(size);
>  	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> -	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
> +	osize = kmalloc_size_roundup(size);
> +	data = kmalloc_reserve(osize, gfp_mask, node, &pfmemalloc);
>  	if (unlikely(!data))
>  		goto nodata;
>  	/* kmalloc(size) might give us more room than requested.

The line above should now say kmalloc_size_roundup(size), or maybe could be
deleted completely now?

>  	 * Put skb_shared_info exactly at the end of allocated zone,
>  	 * to allow max possible filling before reallocation.
>  	 */
> -	osize = ksize(data);
>  	size = SKB_WITH_OVERHEAD(osize);
>  	prefetchw(data + size);
>  

