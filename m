Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEFE598374
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 14:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244492AbiHRMvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 08:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240543AbiHRMvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 08:51:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B88C792DC
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:51:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17114B82157
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 12:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E571C433D6;
        Thu, 18 Aug 2022 12:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660827076;
        bh=rGhU58fzA+kobbY71asfgdsh0ZHD1JDj5XjTr8LuCoc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m27ZqAeETrcRhSK2d2iz51JiQWmrH66RnqqKr2CVbebzdcgcQxakcuPss7x5tEV+8
         me0q6GL1DDxqjFHRIU7lUScM75FT0jS9p4zo/Y7g5jBhv1OUsN0RELaoAo6Ycfvpjf
         4TItleGm0SFoQlaeyXbGEhK4ElPwwnHhkgTbtuBXLRt48aHVFxqCHd9ztodhZIW3Cu
         cJeGK7Hg0TB6LJkM/2c3XR7wdGpfmzGuSKe8w5Xn7r/w726B6FsHHvpk48GiFxPojs
         64O5SI74vlxC3/jF6Es0Q9rYx/3w1scLPxcBLbtZYNZ09Mz5OoFDhPb1xCppLfuRz2
         yj3DxOTZRTL0g==
Date:   Thu, 18 Aug 2022 15:51:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <Yv41wPd11Sg8WU1F@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <20220816195408.56eec0ed@kernel.org>
 <Yvx6+qLPWWfCmDVG@unreal>
 <20220817111052.0ddf40b0@kernel.org>
 <Yv3M/T5K/f35R5UM@unreal>
 <20220818101031.GC566407@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818101031.GC566407@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:10:31PM +0200, Steffen Klassert wrote:
> On Thu, Aug 18, 2022 at 08:24:13AM +0300, Leon Romanovsky wrote:
> > On Wed, Aug 17, 2022 at 11:10:52AM -0700, Jakub Kicinski wrote:
> > > On Wed, 17 Aug 2022 08:22:02 +0300 Leon Romanovsky wrote:
> > > > On Tue, Aug 16, 2022 at 07:54:08PM -0700, Jakub Kicinski wrote:
> > > > > This is making a precedent for full tunnel offload in netdev, right?  
> > > > 
> > > > Not really. SW IPsec supports two modes: tunnel and transport.
> > > > 
> > > > However HW and SW stack supports only offload of transport mode.
> > > > This is the case for already merged IPsec crypto offload mode and
> > > > the case for this full offload.
> > > 
> > > My point is on what you called "full offload" vs "crypto offload".
> > > The policy so far has always been that Linux networking stack should
> > > populate all the headers and instruct the device to do crypto, no
> > > header insertion. Obviously we do header insertion in switch/router
> > > offloads but that's different and stateless.
> > > 
> > > I believe the reasoning was to provide as much flexibility and control
> > > to the software as possible while retaining most of the performance
> > > gains.
> > 
> > I honestly don't know the reasoning, but "performance gains" are very
> > limited as long as IPsec stack involved with various policy/state
> > lookups. These lookups are expensive in terms of CPU and they can't
> > hold 400 Gb/s line rate.
> 
> Can you provide some performance results that show the difference
> between crypto and full offload? In particular because on the TX
> path, the full policy and state offload is done twice (in software
> to find the offloading device and then in hardware to match policy
> to state).

I will prepare the numbers.

> 
> > 
> > https://docs.nvidia.com/networking/display/connectx7en/Introduction#Introduction-ConnectX-7400GbEAdapterCards
> > 
> > > 
> > > You must provide a clear analysis (as in examination in data) and
> > > discussion (as in examination in writing) if you're intending to 
> > > change the "let's keep packet formation in the SW" policy. What you 
> > > got below is a good start but not sufficient.
> 
> I'm still a bit unease about this approach. I fear that doing parts
> of statefull IPsec procesing in software and parts in hardware will
> lead to all sort of problems. E.g. with this implementation
> the software has no stats, liftetime, lifebyte and packet count
> information but is responsible to do the IKE communication.
> 
> We might be able to sort out all problems during the upstraming
> process, but I still have no clear picture how this should work
> in the end with all corener cases this creates.

Like we discussed in IPsec coffee hour, there is no reliable way
to synchronize SW and HW. This is why we offload both policy and state
and skip stack completely.

> 
> Also the name full offload is a bit missleading, because the
> software still has to hold all offloaded states and policies.
> In a full offload, the stack would IMO just act as a stub
> layer between IKE and hardware.

It is just a name, I'm open to change it to any other name.

> 
> > > > Some of them:
> > > > 1. Request to have reqid for policy and state. I use reqid for HW
> > > > matching between policy and state.
> > > 
> > > reqid?
> > 
> > Policy and state are matched based on their selectors (src/deet IP, direction ...),
> > but they independent. The reqid is XFRM identification that this specific policy
> > is connected to this specific state.
> > https://www.man7.org/linux/man-pages/man8/ip-xfrm.8.html
> > https://docs.kernel.org/networking/xfrm_device.html
> > ip x s add ....
> >    reqid 0x07 ...
> >    offload dev eth4 dir in
> 
> Can you elaborate this a bit more? Does that matching happen in
> hardware? The reqid is not a unique identifyer to match between
> policy and state. You MUST match the selectors as defined in 
> https://www.rfc-editor.org/rfc/rfc4301

The reqid is needed for TX path and part of mlx5 flow steering logic.
https://lore.kernel.org/netdev/51ee028577396c051604703c46bd31d706b4b387.1660641154.git.leonro@nvidia.com/
I'm relying on it to make sure that both policy and state exist.

For everything else, I rely on selectors.

Thanks

> 
