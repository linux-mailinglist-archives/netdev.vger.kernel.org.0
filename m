Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F7A6D7031
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 00:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbjDDWg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 18:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbjDDWg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 18:36:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56C2113
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 15:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4123963A92
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 22:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55304C433EF;
        Tue,  4 Apr 2023 22:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680647816;
        bh=hqO0GYMfsJOsKhHiJe21w9hUFOTLFQDEiPvWBngSq0g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EuFATkqdlPmmHP26Ar7rk6camVHolzvLnaQWDCV8NGgoZO4TZcMnR1y3M7ONc61TC
         PQDkDz21ZiUDx2QYwNohFePlEBAjHAGgJ5f6iyGlTngrnliT4hXHqLnBH1CeyG+ZUB
         37m6AVIaxljYI1fnP9RoaxSV3NID4Y/+8NG/eUDPjHlQb88yzxVR3dVzhvNVo9v7SM
         PcLyfIsZvfw7qmqaaJczmmaGusC/Xt7p4N+GvhL3nlF1v1nZvBZwsNdJos2O7tv1gC
         +qilXmCDRy7XEIUP6KCk2Py6QUycZORxxE6wK0fihQ6Ais8pdAabsCbGbMoldSFf43
         RwgpQlv2pGqmA==
Date:   Tue, 4 Apr 2023 15:36:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230404153655.5be6f1a8@kernel.org>
In-Reply-To: <ZCvGDxW+HkcHYaU/@gondor.apana.org.au>
References: <20230401051221.3160913-1-kuba@kernel.org>
        <20230401051221.3160913-2-kuba@kernel.org>
        <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com>
        <20230401115854.371a5b4c@kernel.org>
        <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
        <ZCvGDxW+HkcHYaU/@gondor.apana.org.au>
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

On Tue, 4 Apr 2023 14:39:11 +0800 Herbert Xu wrote:
> Thanks for adding me to this thread as otherwise I would've surely
> missed it.
> 
> I see where the confusion is coming from.  The key is that we weren't
> trying to stop every single race, because not all of them are fatal.
> 
> In particular, we tolerate the race where a wake is done when it
> shouldn't be because the network stack copes with that by requeueing
> the skb onto the qdisc.
> 
> So it's a trade-off.  We could make our code water-tight, but then
> we would be incurring a penalty for every skb.  With our current
> approach, the penalty is only incurred in the unlikely event of a
> race which results in the unlucky skb being requeued.
> 
> The race that we do want to stop is a queue being stuck in a stopped
> state when it shouldn't because that indeed is fatal.
> 
> Going back to the proposed helpers, we only need one mb because
> that's all we need to fix the stuck/stopped queue race.

Thanks, I'm impressed you still remember the details :)

I'll leave it racy in the next version. Re-using the BQL barrier
is a bit more tricky on the xmit path than I thought. I'll just
document that false-positive wake ups are possible.
