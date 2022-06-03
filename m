Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D5C53D286
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 21:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349344AbiFCTzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 15:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiFCTzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 15:55:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC3B2CDC7;
        Fri,  3 Jun 2022 12:55:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 158CDB8247D;
        Fri,  3 Jun 2022 19:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F29AC385B8;
        Fri,  3 Jun 2022 19:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654286117;
        bh=y8aYnaYwz4+KId5P5OeplEKVGDbn7Zzq1Ft2dBsCh3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iJTbyezmQ9eaEmyTuFD/fY5KA7hnnJLhI6ELaf5GmGUBoWBMVo0pv5BPLbO7WWFIw
         UzuXhT6QzCyOXM0pKRjilJLdOausogus+uE3VRNA1SmOqcJK/NKbq+mRtU/3+VZdZi
         n3VQ08ZtKeHb7nRjnnzMCeVcnY+BF5769Cd3itj8hGfbfmjXjZHIblzdgkzqE1c0D7
         JL1lbbXSZRLhejRq/7n2MV6joHNfRVPE4J8/Myjec5UgQUbKLxZr6TMKeK+EHGaGvj
         k7ieV3fxfbn8gh6oZZ0N5p/n4ECiwIsLOzq5di0JI8lJGJUwyi4FjFvNGDfCYsyxhp
         VAyhQ9kiriIcQ==
Date:   Fri, 3 Jun 2022 12:55:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Chen Lin <chen45464546@163.com>, Felix Fietkau <nbd@nbd.name>,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix misuse of mem alloc
 interface netdev[napi]_alloc_frag
Message-ID: <20220603125516.52353a4a@kernel.org>
In-Reply-To: <CANn89i+dW+paaybeDkkC0XxYM+Mv_AOnbi6GSLtTgAv9L=TX7Q@mail.gmail.com>
References: <2997c5b0-3611-5e00-466c-b2966f09f067@nbd.name>
        <1654245968-8067-1-git-send-email-chen45464546@163.com>
        <CANn89iKiyh36ULH4PCXF4c8sBdh9WLksMoMcmQwipZYWCzBkMA@mail.gmail.com>
        <20220603115956.6ad82a53@kernel.org>
        <CANn89i+dW+paaybeDkkC0XxYM+Mv_AOnbi6GSLtTgAv9L=TX7Q@mail.gmail.com>
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

On Fri, 3 Jun 2022 12:11:43 -0700 Eric Dumazet wrote:
> Yes, we only have to review callers and change the documentation and
> implementation.
> 
> The confusion/overhead/generalization came with :
> 
> commit 7ba7aeabbaba484347cc98fbe9045769ca0d118d
> Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Date:   Fri Jun 7 21:20:34 2019 +0200
> 
>     net: Don't disable interrupts in napi_alloc_frag()
> 
>     netdev_alloc_frag() can be used from any context and is used by NAPI
>     and non-NAPI drivers. Non-NAPI drivers use it in interrupt context
>     and NAPI drivers use it during initial allocation (->ndo_open() or
>     ->ndo_change_mtu()). Some NAPI drivers share the same function for the  
>     initial allocation and the allocation in their NAPI callback.
> 
>     The interrupts are disabled in order to ensure locked access from every
>     context to `netdev_alloc_cache'.
> 
>     Let netdev_alloc_frag() check if interrupts are disabled. If they are,
>     use `netdev_alloc_cache' otherwise disable BH and invoke
>     __napi_alloc_frag() for the allocation. The IRQ check is cheaper
>     compared to disabling & enabling interrupts and memory allocation with
>     disabled interrupts does not work on -RT.

Hm, should have looked at the code. Were you thinking of adding a
helper which would replace both netdev_ and napi_ variants and DTRT
internally?

An option for getting GFP_KERNEL in there would be having an rtnl frag
cache. Users who need frags on the reconfig path should be under rtnl,
they can call rtnl_alloc_frag(), which can use GFP_KERNEL internally.
Otherwise the GFP_KERNEL frag cache would need to be protected by
another mutex, I presume. Pre-allocating memory before using the napi
cache seems hard.
