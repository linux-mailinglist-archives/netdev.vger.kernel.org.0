Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7972B5E6BE4
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 21:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbiIVTkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 15:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbiIVTko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 15:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C874C100AAF;
        Thu, 22 Sep 2022 12:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64EF7637B5;
        Thu, 22 Sep 2022 19:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45829C433C1;
        Thu, 22 Sep 2022 19:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663875641;
        bh=Iu+ioVZAl++oTxE1oI47t/6oQuwifWn8lmpY1yCr8J4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YC8ixN8EP0aZI0e+nDZs91siEij37VrKEmFWG3Ty2t8usgwjVxksauo5Og7qifkq5
         ESf2BqmXtU9USNgh+H2YKJEXRWpyu7EDcgicu3AJOn2B/4WayyL94dp8xbokjZvmw2
         M56qmrIx+uvo2sUUrQmzfQ5/ucT/pOiWMPHGNcLJ6IIzRCYzVRcutddcWgSvzdbhZM
         fcZkJSFboZpZl7fu6RLNBgaLlv3gbFkR4ETLqK750bOZ4J5pst6/eAIZH31PhhVZLn
         QMHkEcQOXS8pXwYt/LtILex4KMGS/VXDhD7XC9erQbOO/ciNySxRd4PP7XyTR4i5Zs
         1sdrT7lGqR5Mw==
Date:   Thu, 22 Sep 2022 12:40:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 02/12] skbuff: Proactively round up to kmalloc bucket
 size
Message-ID: <20220922124039.688be0b8@kernel.org>
In-Reply-To: <20220922031013.2150682-3-keescook@chromium.org>
References: <20220922031013.2150682-1-keescook@chromium.org>
        <20220922031013.2150682-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 20:10:03 -0700 Kees Cook wrote:
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 974bbbbe7138..4fe4c7544c1d 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -427,14 +427,15 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  	 */
>  	size = SKB_DATA_ALIGN(size);
>  	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> -	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
> -	if (unlikely(!data))
> -		goto nodata;
> -	/* kmalloc(size) might give us more room than requested.
> +	/* kmalloc(size) might give us more room than requested, so
> +	 * allocate the true bucket size up front.
>  	 * Put skb_shared_info exactly at the end of allocated zone,
>  	 * to allow max possible filling before reallocation.
>  	 */
> -	osize = ksize(data);
> +	osize = kmalloc_size_roundup(size);
> +	data = kmalloc_reserve(osize, gfp_mask, node, &pfmemalloc);
> +	if (unlikely(!data))
> +		goto nodata;
>  	size = SKB_WITH_OVERHEAD(osize);
>  	prefetchw(data + size);

I'd rename osize here to alloc_size for consistency but one could 
argue either way :)

Acked-by: Jakub Kicinski <kuba@kernel.org>
