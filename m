Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62283646598
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 01:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiLHAEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 19:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLHAEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 19:04:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1619C25;
        Wed,  7 Dec 2022 16:04:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DB41B82193;
        Thu,  8 Dec 2022 00:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB55EC433C1;
        Thu,  8 Dec 2022 00:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670457860;
        bh=dGzD3MabdJ3gCO/vnjgNvWqrDyu07kPWOPO5r5Uket4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=neGTvB+xf2NPBz6T3qCPQAVptu8rAxAJQJTo4zBhj/n8RLT5UdL+FtQGpmlArTLwH
         ofh/hgYCPoOpGwroW8TDvNyaq5Kqt2QwBEJlxNIkdMLjskgZLvDmnMsyGOneTLYtuL
         H9bphHHwqoLNim5SnVWPTDb5nlgKVIzGVV8u1Ij5H0cyHNo2ph2h/X/c25gbKTgF3r
         B2Qq4PElqUbqnTIVwv7Gx8i3BeK35y0JvaUdj9bzejaoSRJV5lJsng/e3LV7SUjINn
         B7WkfXi6yFD30qhyMNkoJeaM+AdCNOIum8KHSLzFo9nhPZawsB6+i2Ju7xzMKlG/aP
         FHMIJ6D3FniSA==
Date:   Wed, 7 Dec 2022 16:04:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, stable@vger.kernel.org
Subject: Re: [RFC net] Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue
 depth data field")
Message-ID: <20221207160418.68e408c3@kernel.org>
In-Reply-To: <1328d117-70b5-b03c-c0be-cd046d728d53@uliege.be>
References: <20221205153557.28549-1-justin.iurman@uliege.be>
        <CANn89iLjGnyh0GgW_5kkMQJBCi-KfgwyvZwT1ou2FMY4ZDcMXw@mail.gmail.com>
        <CANn89iK3hMpJQ1w4peg2g35W+Oi3t499C5rUv7rcwzYtxDGBuw@mail.gmail.com>
        <a8dcb88c-16be-058b-b890-5d479d22c8a8@uliege.be>
        <CANn89iKgeVFRAstW3QRwOdn8SV_EbHqcKYqmoWT6m5nGQwPWUg@mail.gmail.com>
        <d579c817-50c7-5bd5-4b28-f044daabf7f6@uliege.be>
        <20221206124342.7f429399@kernel.org>
        <1328d117-70b5-b03c-c0be-cd046d728d53@uliege.be>
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

On Wed, 7 Dec 2022 13:07:18 +0100 Justin Iurman wrote:
> > Can you say more about the use? What signal do you derive from it?
> > I do track qlen on Meta's servers but haven't found a strong use
> > for it yet (I did for backlog drops but not the qlen itself).  
> 
> The specification goal of the queue depth was initially to be able to 
> track the entire path with a detailed view for packets or flows (kind of 
> a zoom on the interface to have details about its queues). With the 
> current definition/implementation of the queue depth, if only one queue 
> is congested, you're able to know it. Which doesn't necessarily mean 
> that all queues are full, but this one is and there might be something 
> going on. And this is something operators might want to be able to 
> detect precisely, for a lot of use cases depending on the situation. On 
> the contrary, if all queues are full, then you could deduce that as well 
> for each queue separately, as soon as a packet is assigned to it. So I 
> think that with "queue depth = sum(queues)", you don't have details and 
> you're not able to detect a single queue congestion, while with "queue 
> depth = queue" you could detect both. One might argue that it's fine to 
> only have the aggregation in some situation. I'd say that we might need 
> both, actually. Which is technically possible (even though expensive, as 
> Eric mentioned) thanks to the way it is specified by the RFC, where some 
> freedom was intentionally given. I could come up with a solution for that.

Understood. My hope was that by now there was some in-field experience
which could help us judge how much signal can one derive from a single
queue. Or a user that could attest.

> > Because it measures the length of a single queue not the device.  
> 
> Yep, I figured that out after the off-list discussion we've had with Eric.
> 
> So my plan would be, if you all agree with, to correct and repost this 
> patch to fix the NULL qdisc issue. Then, I'd come with a solution to 
> allow both (with and without aggregation of queues) and post it on 
> net-next. But again, if the consensus is to revert this patch (which I 
> think would bring no benefit IMHO), then so be it. Thoughts?

To summarize - we have reservations about correctness and about 
breaking layering (ip6 calling down to net/sched).

You can stick to your approach, respost and see if any of the other
maintainer is willing to pick this up (i.e. missed this nack).
If you ask for my option I'll side with Eric.
