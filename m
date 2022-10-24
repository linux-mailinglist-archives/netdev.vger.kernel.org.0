Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586B4609D01
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 10:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJXInd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 04:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJXInc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 04:43:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF81D6053A
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 01:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 580A560E15
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29021C433D6;
        Mon, 24 Oct 2022 08:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666601010;
        bh=0fayqMG9gyJKkAMexAXOx1iejA/bEvgJU/+2yGgs2xs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A/VIz2rJbgIfjZ5uio1wNJ0T2QUx+V/leqnUfVY9QmfCPIiCI1smP08y281gnX1lc
         kCNRpuCP20udnWYqF4RCsjzGQuGqImnujoLyMJeQ0bV90xNyUiavQSRrVHsAfZ67++
         Lo7OF/e+jaNzLMrWUyn8kF4C5u34aq+IzqlZ4BBYe+Gm3hdIq19CW8iV2m/2GcgZux
         to0zBJGSHPxLoukm9LAj7sWi2GJ+g6lUaqs0lJL8W0OaMHO529Q59FEzCWgtn+Srbs
         stRJhHEjFIKqZdWDGfTPGxOcOe+sqg3CzanOFyBfZyY0D0k7yzRI2xiTdzTxGXxwJ8
         55BbFg5/UqzkQ==
Date:   Mon, 24 Oct 2022 11:43:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [PATCH net 0/5] macsec: offload-related fixes
Message-ID: <Y1ZQLtjs18YOvRXF@unreal>
References: <cover.1665416630.git.sd@queasysnail.net>
 <Y0j+E+n/RggT05km@unreal>
 <Y0kTMXzY3l4ncegR@hog>
 <Y0lCHaGTQjsNvzVN@unreal>
 <166575623691.3451.2587099917911763555@kwain>
 <Y05HeGnTKBY0RVI4@unreal>
 <Y1FTFOsZxELhvWT4@hog>
 <Y1Ty2LlrdrhVvLYA@unreal>
 <Y1ZLvNE3W9Ph+qqJ@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1ZLvNE3W9Ph+qqJ@hog>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 10:24:28AM +0200, Sabrina Dubroca wrote:
> 2022-10-23, 10:52:56 +0300, Leon Romanovsky wrote:
> > On Thu, Oct 20, 2022 at 03:54:28PM +0200, Sabrina Dubroca wrote:
> > > 2022-10-18, 09:28:08 +0300, Leon Romanovsky wrote:
> > > > On Fri, Oct 14, 2022 at 04:03:56PM +0200, Antoine Tenart wrote:
> > > > > Quoting Leon Romanovsky (2022-10-14 13:03:57)
> > > > > > On Fri, Oct 14, 2022 at 09:43:45AM +0200, Sabrina Dubroca wrote:
> > > > > > > 2022-10-14, 09:13:39 +0300, Leon Romanovsky wrote:
> > > > > > > > On Thu, Oct 13, 2022 at 04:15:38PM +0200, Sabrina Dubroca wrote:
> > 
> > <...>
> > 
> > > > > - With the revert: IPsec and MACsec can be offloaded to the lower dev.
> > > > >   Some features might not propagate to the MACsec dev, which won't allow
> > > > >   some performance optimizations in the MACsec data path.
> > > > 
> > > > My concern is related to this sentence: "it's not possible to offload macsec
> > > > to lower devices that also support ipsec offload", because our devices support
> > > > both macsec and IPsec offloads at the same time.
> > > > 
> > > > I don't want to see anything (even in commit messages) that assumes that IPsec
> > > > offload doesn't exist.
> > > 
> > > I don't understand what you're saying here. Patch #1 from this series
> > > is exactly about the macsec device acknowledging that ipsec offload
> > > exists. The rest of the patches is strictly macsec stuff and says
> > > nothing about ipsec. Can you point out where, in this series, I'm
> > > claiming that ipsec offload doesn't exist?
> > 
> > All this conversation is about one sentence, which I cited above - "it's not possible
> > to offload macsec to lower devices that also support ipsec offload". From the comments,
> > I think that you wanted to say "macsec offload is not working due to performance
> > optimization, where IPsec offload feature flag was exposed from lower device." Did I get
> > it correctly, now?
> 
> Yes. "In the current state" (that I wrote in front of the sentence you
> quoted) refers to the changes introduced by commit c850240b6c41. The
> details are present in the commit message for patch 1.
> 
> Do you object to the revert, if I rephrase the justification, and then
> re-add the features that make sense in net-next?

I don't have any objections.

Thanks

> 
> -- 
> Sabrina
> 
