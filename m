Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE9E6D4B5D
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbjDCPFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjDCPFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:05:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BF6269D
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A062661FC6
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC3AC4339B;
        Mon,  3 Apr 2023 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680534347;
        bh=X6h8p4LKNRwgpYJjIfK4O8bqAJ6AxHOQe3pUq56Bnns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lcdzcy78PPIcNv+0QPHiM7/X1vqafHL89mVCt63D7hrxzMEwJU2h0EAfP7wDyIaSq
         OhLA6nb+1EUu9YbKdejnCulSJ9TglWs0aETGVRkXIiteLLUMY0TR9Xkm/eAx4UwzZF
         47snr3eCLUiWlK8VVPlG7nWrsQZ7oC+fH3sKYJdnFeoUJC20bvZeqnBndgRS3lW8y0
         hUx/ydKL+s/q+DeC5wzKn6MJWeJu5A2HiDb2P01/VitJoJFQzMGMY8w5d2a+8tCjHp
         JS+ZeFtmUFN8dUf36cMdR/RSDzrf1Twlcsps/b6XJUXqMXpbEkFM9n0xmzuQajDj5L
         HlDwYLRy2hymA==
Date:   Mon, 3 Apr 2023 08:05:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, hawk@kernel.org
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely
 localized NAPI
Message-ID: <20230403080545.390f51ce@kernel.org>
In-Reply-To: <ZCqZVNvhjLqBh2cv@hera>
References: <20230331043906.3015706-1-kuba@kernel.org>
        <ZCqZVNvhjLqBh2cv@hera>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 12:16:04 +0300 Ilias Apalodimas wrote:
> >  /* If the page refcnt == 1, this will try to recycle the page.
> >   * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
> >   * the configured size min(dma_sync_size, pool->max_len).
> > @@ -570,6 +583,9 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
> >  			page_pool_dma_sync_for_device(pool, page,
> >  						      dma_sync_size);
> >
> > +		if (!allow_direct)
> > +			allow_direct = page_pool_safe_producer(pool);
> > +  
> 
> Do we want to hide the decision in __page_pool_put_page().  IOW wouldn't it
> be better for this function to honor whatever allow_direct dictates and
> have the allow_direct = page_pool_safe_producer(pool); in callers?

Meaning in page_pool_return_skb_page() or all the way from
napi_consume_skb()? The former does indeed sounds like a good idea!
