Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E53C60C45C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 08:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiJYG4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 02:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiJYG41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 02:56:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E2C152033
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 23:55:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A5F561784
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 06:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01577C433D6;
        Tue, 25 Oct 2022 06:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666680927;
        bh=skI9JyNVkj1EqolgfrysZxSpR9oH+lWIc1njk995X4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NSq1LFguETg7pk+xmTy2+pNIw1cXXpEjkIgHhSCNlpe70Plsu5+rcj90WVujZHo92
         FYMb9Yecz+MGMDo4GYmqySgbFf5ATWOkhfmsjNCOfRm/Jf36a/wN5IUWToUAgn8pWF
         VIc2Xeq33z6EfdIVjSBSEqYzUEWl5HT9tstUmOisCfXZf3Ey36aBEv/LDI5agN9rU8
         fcY2UXcdhas+EWxgfetVbEYfwbbjhuLN/1ZX8g5ynJJce/NNkRfAw87/mxQkR7AyQ1
         RHHj7XYQMYkIR0PxCwBYSu0jSbimzTouTWZp/L2drLL63gIS28+LYisM0TzyiW5qqH
         Q0NbgkiU9XcUQ==
Date:   Tue, 25 Oct 2022 09:55:23 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [PATCH net 0/5] macsec: offload-related fixes
Message-ID: <Y1eIWwTlHbODRoub@unreal>
References: <Y0j+E+n/RggT05km@unreal>
 <Y0kTMXzY3l4ncegR@hog>
 <Y0lCHaGTQjsNvzVN@unreal>
 <166575623691.3451.2587099917911763555@kwain>
 <Y05HeGnTKBY0RVI4@unreal>
 <Y1FTFOsZxELhvWT4@hog>
 <Y1Ty2LlrdrhVvLYA@unreal>
 <Y1ZLvNE3W9Ph+qqJ@hog>
 <Y1ZQLtjs18YOvRXF@unreal>
 <Y1cMDkGJSlG5SS1B@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1cMDkGJSlG5SS1B@hog>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 12:05:02AM +0200, Sabrina Dubroca wrote:
> 2022-10-24, 11:43:26 +0300, Leon Romanovsky wrote:
> > On Mon, Oct 24, 2022 at 10:24:28AM +0200, Sabrina Dubroca wrote:
> > > 2022-10-23, 10:52:56 +0300, Leon Romanovsky wrote:
> > > > On Thu, Oct 20, 2022 at 03:54:28PM +0200, Sabrina Dubroca wrote:
> > > > > 2022-10-18, 09:28:08 +0300, Leon Romanovsky wrote:
> > > > > > On Fri, Oct 14, 2022 at 04:03:56PM +0200, Antoine Tenart wrote:
> > > > > > > Quoting Leon Romanovsky (2022-10-14 13:03:57)
> > > > > > > > On Fri, Oct 14, 2022 at 09:43:45AM +0200, Sabrina Dubroca wrote:
> > > > > > > > > 2022-10-14, 09:13:39 +0300, Leon Romanovsky wrote:
> > > > > > > > > > On Thu, Oct 13, 2022 at 04:15:38PM +0200, Sabrina Dubroca wrote:
> > > > 
> > > > <...>
> > > > 
> > > > > > > - With the revert: IPsec and MACsec can be offloaded to the lower dev.
> > > > > > >   Some features might not propagate to the MACsec dev, which won't allow
> > > > > > >   some performance optimizations in the MACsec data path.
> > > > > > 
> > > > > > My concern is related to this sentence: "it's not possible to offload macsec
> > > > > > to lower devices that also support ipsec offload", because our devices support
> > > > > > both macsec and IPsec offloads at the same time.
> > > > > > 
> > > > > > I don't want to see anything (even in commit messages) that assumes that IPsec
> > > > > > offload doesn't exist.
> > > > > 
> > > > > I don't understand what you're saying here. Patch #1 from this series
> > > > > is exactly about the macsec device acknowledging that ipsec offload
> > > > > exists. The rest of the patches is strictly macsec stuff and says
> > > > > nothing about ipsec. Can you point out where, in this series, I'm
> > > > > claiming that ipsec offload doesn't exist?
> > > > 
> > > > All this conversation is about one sentence, which I cited above - "it's not possible
> > > > to offload macsec to lower devices that also support ipsec offload". From the comments,
> > > > I think that you wanted to say "macsec offload is not working due to performance
> > > > optimization, where IPsec offload feature flag was exposed from lower device." Did I get
> > > > it correctly, now?
> > > 
> > > Yes. "In the current state" (that I wrote in front of the sentence you
> > > quoted) refers to the changes introduced by commit c850240b6c41. The
> > > details are present in the commit message for patch 1.
> > > 
> > > Do you object to the revert, if I rephrase the justification, and then
> > > re-add the features that make sense in net-next?
> > 
> > I don't have any objections.
> 
> Would this be ok for the cover letter?
> 
>     ----
>     The first patch is a revert of commit c850240b6c41 ("net: macsec:
>     report real_dev features when HW offloading is enabled"). That
>     commit tried to improve the performance of macsec offload by
>     taking advantage of some of the NIC's features, but in doing so,
>     broke macsec offload when the lower device supports both macsec
>     and ipsec offload, as the ipsec offload feature flags were copied
>     from the real device. Since the macsec device doesn't provide
>     xdo_* ops, the XFRM core rejects the registration of the new
>     macsec device in xfrm_api_check.
> 
>     I'm working on re-adding those feature flags when offload is
>     available, but I haven't fully solved that yet. I think it would
>     be safer to do that second part in net-next considering how
>     complex feature interactions tend to be.
>     ----
> 
> Do you want something added to the commit message of the revert as
> well?

It will be great to see this sentence "commit tried to improve ...
device in xfrm_api_check." in that revert patch. It makes everything
clearer.

Thanks
