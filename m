Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD3E59BCE9
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbiHVJex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiHVJew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AC63055A
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 02:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9790B80E88
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 09:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A8AC433D7;
        Mon, 22 Aug 2022 09:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661160888;
        bh=2jNVVTYqXPWcZwA396jV52ZxLi9Ac9EYUIInMQBjjlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IGyALxSYFoANjVDnK5mhz3JWhFRg9HZgbKdXvLpdIMC80tN89r+JT6Ckcn814NcQG
         oM4yVGCtX2rsgXDg5qEYcTPcTaRViCVm3SoFnmA0yVnw96SUPd49RsmEbWMb5bLxJn
         YH4PbQgQORaLuM2SePjeA99kdzLYlhq0FJcnM7xrklNQuKNTRimIlrDT8uEnqNZvEN
         7h1T5Kv900CQ6tUxuRdljBqEmO1OAZjxdqxNkJM+8bbXSiWvbl2KDfjijvH0SSqAvg
         JbKwstcE+CPWBTtU6sWA6yeK3QVCUtxoRuVM3uXFeENxhTP5dfPqtDTjFqfwi8KOwe
         jOyV8R/WIfbJg==
Date:   Mon, 22 Aug 2022 12:34:44 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <YwNNtOqQIDM2lSdC@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <20220818100930.GA622211@gauss3.secunet.de>
 <Yv4+D+2d3HPQKymx@unreal>
 <20220822083443.GH2602992@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822083443.GH2602992@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 10:34:43AM +0200, Steffen Klassert wrote:
> On Thu, Aug 18, 2022 at 04:26:39PM +0300, Leon Romanovsky wrote:
> > On Thu, Aug 18, 2022 at 12:09:30PM +0200, Steffen Klassert wrote:
> > > Hi Leon,
> > > 
> > > On Tue, Aug 16, 2022 at 11:59:21AM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Changelog:
> > > > v2:
> > > >  * Rebased to latest 6.0-rc1
> > > >  * Add an extra check in TX datapath patch to validate packets before
> > > >    forwarding to HW.
> > > >  * Added policy cleanup logic in case of netdev down event 
> > > > v1: https://lore.kernel.org/all/cover.1652851393.git.leonro@nvidia.com 
> > > >  * Moved comment to be before if (...) in third patch.
> > > > v0: https://lore.kernel.org/all/cover.1652176932.git.leonro@nvidia.com
> > > > -----------------------------------------------------------------------
> > > > 
> > > > The following series extends XFRM core code to handle new type of IPsec
> > > > offload - full offload.
> > > > 
> > > > In this mode, the HW is going to be responsible for whole data path, so
> > > > both policy and state should be offloaded.
> > > 
> > > some general comments about the pachset:
> > > 
> > > As implemented, the software does not hold any state.
> > > I.e. there is no sync between hardware and software
> > > regarding stats, liftetime, lifebyte, packet counts
> > > and replay window. IKE rekeying and auditing is based
> > > on these, how should this be done?
> > 
> > This is only rough idea as we only started to implement needed
> > support in libreswan, but our plan is to configure IKE with
> > highest possible priority 
> 
> If it is only a rough idea, then mark it as RFC. I want to see
> the whole picture before we merge it. And btw. tunnel mode
> belongs to the whoule picture too.

It is a rough in a sense that we don't have code to present yet.
We did arch review of this IKE approach and it is how we are
implementing it.

> 
> > 
> > > 
> > > I have not seen anything that catches configurations
> > > that stack multiple tunnels with the outer offloaded.
> > > 
> > > Where do we make sure that policy offloading device
> > > is the same as the state offloading device?
> > 
> > It is configuration error and we don't check it. Should we?
> 
> We should at least make sure to not send out packets untransformed
> in this case.

In TX SW path, if state doesn't exist, the packets will be sent
unencrypted. This "wrong" device configuration in offloaded path
has same behavior as not having state at all.

Thanks
