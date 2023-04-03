Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC396D4EA9
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 19:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjDCRMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 13:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjDCRMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 13:12:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E149272E
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 10:12:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB72F62272
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 17:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD000C433EF;
        Mon,  3 Apr 2023 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680541941;
        bh=+W2jK6XJBDJV4oHo3xHACPZj9Jz+akH/CzY5rl4LdP0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HDPIHc4A0Is5m6j13OIYzKl8dTW089Lpft00NWnH2h3gP8yt0gpVOf/qD4FT85Pld
         85P5oyJdze2yTOZk7/4BKfrG7MIxcy0aKSinIOl+Y4W4AOO2wWmGYdBlBSw9slOx20
         bfSj+STdTBItMjn6FqJKXqVIpQkerwN0gfLXx3Vf9g0BTvj6L+BFUOn6/gooie19Uf
         bJ4DADsZs3a2i6zuWTPcewSizdew/8kcreJ4PdALqIIJV0AdagazaNhdr1WmMHAaj7
         ROXOSR8ib9hg0tab3AmZVcA0U9APRYICz42y2JFId9FRG6e9ceQUwWTRB8SCyNaYZF
         +/sdg1r7xhvBA==
Date:   Mon, 3 Apr 2023 10:12:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, hawk@kernel.org
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely
 localized NAPI
Message-ID: <20230403101219.59a83043@kernel.org>
In-Reply-To: <CAC_iWjJiTddh7cKo-18LGGE+XQS_H8B5ieXLW6+uSq6uBNPnDw@mail.gmail.com>
References: <20230331043906.3015706-1-kuba@kernel.org>
        <ZCqZVNvhjLqBh2cv@hera>
        <20230403080545.390f51ce@kernel.org>
        <CAC_iWjJiTddh7cKo-18LGGE+XQS_H8B5ieXLW6+uSq6uBNPnDw@mail.gmail.com>
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

On Mon, 3 Apr 2023 18:30:55 +0300 Ilias Apalodimas wrote:
> > Meaning in page_pool_return_skb_page() or all the way from
> > napi_consume_skb()? The former does indeed sounds like a good idea!  
> 
> page_pool_return_skb_page() (and maybe page_pool_put_full_page()).
> FWIW we completely agree on napi_consume_skb().  We are trying to keep
> page_pool and the net layer as disjoint as possible.  The only point
> we 'pollute' networking code is the recycle bit checking and we'd
> prefer keeping it like that

Ack, OTOH plumbing thru the budget argument within netdev code should
not be a major refactoring. So maybe I should do that after all.

Otherwise we have two different conditions - netdev only recycles skbs
based on the NAPI budget != 0, but page pool will assume that
in_softirq() && !in_hardirq() is always safe.

The latter is safe, I think, unless someone adds a print half way thru
the cache update... but then it's also safe in NAPI skb recycling,
so napi_consume_skb() should stop taking the budget and just look
at preempt flags...

To make the correctness obvious, for now, I think I will refactor 
the netdev code to pass a "in NAPI poll" bool to
page_pool_return_skb_page(), and add a WARN_ON(!softirq || hardirq).

Let's see how the code ends up looking, I'll send it as RFCv2 rather
than PATCH to make it clear I'm not sure it's okay with you :)
