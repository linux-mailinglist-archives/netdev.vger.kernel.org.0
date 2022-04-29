Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B710F513F92
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 02:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351559AbiD2Akx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 20:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbiD2Akx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 20:40:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A831DBB09E;
        Thu, 28 Apr 2022 17:37:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64823B83260;
        Fri, 29 Apr 2022 00:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C67C385AD;
        Fri, 29 Apr 2022 00:37:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="e47KqLhw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651192651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r804qhBejoVRexAENK1j1o67bq5qDN1KpREo3y7KOtk=;
        b=e47KqLhw/1igQfy2eq3mJRM+YKpFgfTeNVmmeloNuybW9n/gRtZfG9CKImVVy4zzsZqaeG
        E9wn4CaaV3+67u0mIoqw6qkfQwAL6xzFLbXJFTZXFqx/NqjgC3SlBSkxkSRmLKvpxHgjFb
        OVV4fCm184F9dbbGT7amlrUDDvNI3m0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a2875674 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 29 Apr 2022 00:37:31 +0000 (UTC)
Date:   Fri, 29 Apr 2022 02:37:29 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kuba@kernel.org,
        hannes@stressinduktion.org
Subject: Re: Routing loops & TTL tracking with tunnel devices
Message-ID: <YmszSXueTxYOC41G@zx2c4.com>
References: <CAHmME9r_DbZWe4FsfebHSSf_iPctSe5S-w9bU3o8BN43raeURg@mail.gmail.com>
 <20151116203709.GA27178@oracle.com>
 <CAHmME9pNCqbcoqbOnx6p8poehAntyyy1jQhy=0_HjkJ8nvMQdw@mail.gmail.com>
 <1447712932.22599.77.camel@edumazet-glaptop2.roam.corp.google.com>
 <CAHmME9oTU7HwP5=qo=aFWe0YXv5EPGoREpF2k-QY7qTmkDeXEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9oTU7HwP5=qo=aFWe0YXv5EPGoREpF2k-QY7qTmkDeXEA@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Eric,

On Tue, Nov 17, 2015 at 03:41:35AM +0100, Jason A. Donenfeld wrote:
> On Mon, Nov 16, 2015 at 11:28 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > There is very little chance we'll accept a new member in sk_buff, unless
> > proven needed.
> 
> I actually have no intention of doing this! I'm wondering if there
> already is a member in sk_buff that moonlights as my desired ttl
> counter, or if there's another mechanism for avoiding routing loops. I
> want to work with what's already there, rather than meddling with the
> innards of important and memory sensitive structures such as sk_buff.

Well, 7 years later... Maybe you have a better idea now of what I was
working on then. :)

As an update on this issue, it's still quasi problematic. To review, I
can't use the TTL value, because the outer packet always must get the
TTL of the route to the outer destination, not the inner packet minus
one. I can't rely on reaching MTU size, because people want this to work
with fragmentation (see [1] for my attempt to disallow fragmentation for
this issue, which resulted in hoots and hollers). I can't use the
per-cpu xmit_recursion variable, because I use threads.

What I can sort of use is taking advantage of what looks like a bug in
pskb expansion, such that it always allocates too much, and pretty
quickly fails allocations after a few loops. Only powerpc64 and s390x
don't appear to have this bug. See [2] for a description of this in
depth I wrote a few months ago to you.

Anyway, it'd be nice if there were a free u8 somewhere in sk_buff that I
could use for tracking times through the stack. Other kernels have this
but afaict Linux still does not. I looked into trying to overload some
existing fields -- tstamp/skb_mstamp_ns or queue_mapping -- which I was
thinking might be totally unused on TX?

Any ideas about this?

Thanks,
Jason

[1] https://lore.kernel.org/wireguard/CAHmME9rNnBiNvBstb7MPwK-7AmAN0sOfnhdR=eeLrowWcKxaaQ@mail.gmail.com/
[2] https://lore.kernel.org/netdev/CAHmME9pv1x6C4TNdL6648HydD8r+txpV4hTUXOBVkrapBXH4QQ@mail.gmail.com/
