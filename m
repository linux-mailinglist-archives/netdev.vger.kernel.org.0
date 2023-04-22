Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA6F6EB70E
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjDVDWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDVDWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:22:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8CC1BEF;
        Fri, 21 Apr 2023 20:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20CB66534A;
        Sat, 22 Apr 2023 03:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01156C433EF;
        Sat, 22 Apr 2023 03:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682133751;
        bh=dgE/4f1ZoIV0GXhKl47XBKXpyQMOV0InJmJFu1xkGho=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O4MfaUdWgCZl+fCM6r1IIpxPmxpmktd2d1XLdUviGgszC7L/aQV8aDVC1Wjt5V+XW
         U86gBUtaYD/apkXEdTlK5swTb/vXUXDYEjUWuIMnRc+de/dl4lSRlFBL0+kw6i9lqX
         50nxLwlmUh9EcSnjYy5GSEyq3LLfGd+JHFZLuEfJS9BKiLDmRmiwv0vnMqY1LTk4lX
         OJdaTwMsR6c/31twy/fA5Viv6cHet8ncxPddEXSb8dnCE4kCE12qWmgIYU+Eo449TT
         CY927sNshM2uVEnLaiijfmB/W8rfgWqRtB1EYiYS8E0qmv8+dwfWZrDevyL3U8XUnc
         2RZ3cqDkl3h6Q==
Date:   Fri, 21 Apr 2023 20:22:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, mtahhan@redhat.com, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next 1/2] net: veth: add page_pool for page
 recycling
Message-ID: <20230421202230.2fa44cca@kernel.org>
In-Reply-To: <b1c7efdc33221fdb588995b385415d68b149aa73.1681987376.git.lorenzo@kernel.org>
References: <cover.1681987376.git.lorenzo@kernel.org>
        <b1c7efdc33221fdb588995b385415d68b149aa73.1681987376.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 13:16:21 +0200 Lorenzo Bianconi wrote:
> @@ -727,17 +729,21 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>  			goto drop;
>  
>  		/* Allocate skb head */
> -		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> +		if (rq->page_pool)

There's some condition under which we can get to XDP enabled but no
pool?

> +			page = page_pool_dev_alloc_pages(rq->page_pool);
>  		if (!page)
>  			goto drop;
>  
>  		nskb = build_skb(page_address(page), PAGE_SIZE);
>  		if (!nskb) {
> -			put_page(page);
> +			page_pool_put_full_page(rq->page_pool, page, false);

You can recycle direct, AFAIU the basic rule of thumb is that it's
always safe to recycle direct from the context which allocates from
the pool.

>  			goto drop;
>  		}
>  
>  		skb_reserve(nskb, VETH_XDP_HEADROOM);
> +		skb_copy_header(nskb, skb);
> +		skb_mark_for_recycle(nskb);
> +
>  		size = min_t(u32, skb->len, max_head_size);
>  		if (skb_copy_bits(skb, 0, nskb->data, size)) {
>  			consume_skb(nskb);
> @@ -745,16 +751,17 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>  		}
>  		skb_put(nskb, size);
>  
> -		skb_copy_header(nskb, skb);
>  		head_off = skb_headroom(nskb) - skb_headroom(skb);
>  		skb_headers_offset_update(nskb, head_off);
>  
>  		/* Allocate paged area of new skb */
>  		off = size;
>  		len = skb->len - off;
> +		page = NULL;

Why do you clear the page pointer?

-- 
pw-bot: cr
