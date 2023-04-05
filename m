Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8532A6D71EF
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 03:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbjDEBVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 21:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjDEBVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 21:21:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC7B2705
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 18:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E1846225D
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 01:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32660C433EF;
        Wed,  5 Apr 2023 01:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680657677;
        bh=wMbqh+QbavFBqZqfJNzRnuIQikE0s9gHDj8jVVRGzL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y1HnUyXGrbfQ9M29EipgBUTEqqhvibuf0HUerA7gP5aX92/kxaEsj5a9O/OCRd7t8
         mhKDH5+IU+RNvlN2kh0ctvBTsIu1cOMWZuxifUMbusVuNbdiHaq2fxzJ7OuP8J5twe
         K7XclyuUHNWGOppRWYI/kvMhmKVRwJV33gQDAf5PGzzwZ4SPxpAuxMLceBOusSAd7a
         geqvdWzkEJ1qI3dVNT0e0G2yred2ftdSJp/LpN6MF5+kYx4VjHsb0G3f6Egf+U1mvw
         lkGutmhfa6NBy+jNT2BOLNdGf+RpQ6LLIAtiMX0n7DWnDEUzKH5Pe/9SqTdXYKy2GT
         C41E+0hHMC3nw==
Date:   Tue, 4 Apr 2023 18:21:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Liang Chen <liangchen.linux@gmail.com>,
        ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing
 SKBs
Message-ID: <20230404182116.5795563c@kernel.org>
In-Reply-To: <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
        <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Apr 2023 08:51:18 -0700 Alexander H Duyck wrote:
> I'm not quite sure I agree with the fix. Couldn't we just modify the
> check further down that does:
> 
>         if (!skb_cloned(from))
>                 from_shinfo->nr_frags = 0;
> 
> And instead just make that:
> 	if (!skb->cloned || (!skb_cloned(from) && !from->pp_recycle))
>                 from_shinfo->nr_frags = 0;
> 
> With that we would retain the existing behavior and in the case of
> cloned from frames we would take the references and let the original
> from skb freed to take care of pulling the pages from the page pool.

Sounds like a better fix, indeed. But this sort of code will require
another fat comment above to explain why. This:

	if (to->pp_recycle == from->pp_recycle && !skb_cloned(from))

is much easier to understand, no?

We should at least include that in the explanatory comment, I reckon...
