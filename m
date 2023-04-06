Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F107F6D9B73
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbjDFO72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239292AbjDFO7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:59:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A73EAD05
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 07:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5698464901
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 14:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64873C4339B;
        Thu,  6 Apr 2023 14:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680793149;
        bh=NpOaxzoBrrAlvz9yihDu/mIMe34kWLuTT4d3K/CtqM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BM6HBH8spVZs2kJIrGNGLvnHOnGtP5l+/TcRAwWSzp2GBD1YZqlMLLk8YZH+4RtSv
         zK9Uajm5QnN5ttrMpqsBpNPnUu1Y8M/x5WU/qJj0hhmS8haqC3pfmoAUU6BzFVBw+J
         4k7dTRakMlHNJHye1j5H2bxobXXsX/jh5A62eHLq30bfbNhPaOu/IN95H0NXnY2LTS
         Nca85VDPn13UwkiMNz4DqhmBVGS2QYp3lwJsXvZ6ZcETb9f/aQJuK7wTV2m6AWVmLv
         EBKvDL1wnRWrpQmPbYHmfcRvx3iK18PnbjjkbwwTJuFn12jxrcuLjPtm0/LOAv2FjC
         lKxU1mGsS5QUg==
Date:   Thu, 6 Apr 2023 07:59:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>, hawk@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing
 SKBs
Message-ID: <20230406075908.5ebcb5a0@kernel.org>
In-Reply-To: <CAKhg4tK0D2CqbcCm5TW6LeoBuyQKq7ThrQTS7fLHBUXfoFe1XA@mail.gmail.com>
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
        <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
        <20230404182116.5795563c@kernel.org>
        <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
        <CAKgT0UfPvkiRSqxOjDUsEVapSbtV++AqSLctZHKKs=_gSxtWfA@mail.gmail.com>
        <CAKhg4t+omfRPP3pe4Suq65GiJCT2QtpB=6f+T=dWrmu7_SrZZQ@mail.gmail.com>
        <CANn89iJwMOAD_r+4eUpV65PmhMoSHbr0GOE-WA0APZDh3zpiPQ@mail.gmail.com>
        <CAC_iWjJD-g34ABOhu8f9wMLF0a9YYAZdh_uh2Vq44C-fAU3Nag@mail.gmail.com>
        <CAKhg4tK0D2CqbcCm5TW6LeoBuyQKq7ThrQTS7fLHBUXfoFe1XA@mail.gmail.com>
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

On Thu, 6 Apr 2023 19:54:23 +0800 Liang Chen wrote:
> > > Same feeling on my side.
> > > I prefer not trying to merge mixed pp_recycle skbs "just because we
> > > could" at the expense
> > > of adding more code in a fast path.  
> >
> > +1 here.  The intention of recycling was to affect the normal path as
> > less as possible.  On top of that, we've some amount of race
> > conditions over the years, trying to squeeze more performance with
> > similar tricks.  I'd much rather be safe here, since recycling by
> > itself is a great performance boost
> 
> Sorry, I didn't check my inbox before sending out the v2 patch.

I can discard v2 from patchwork, let's continue the conversation
here.

> Yeah, It is a bit complicated as we expected. The patch is sent out.
> Please take a look to see if it is the way to go, or We should stay
> with the current patch for simplicity reasons. Thanks!

Sounds like you know what Eric and Ilias agreed with, I'm a bit
confused.. are we basically going back to v1? (hopefully with coding
style fixed)
