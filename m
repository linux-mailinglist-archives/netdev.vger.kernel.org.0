Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92982599311
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 04:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240128AbiHSCey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 22:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiHSCew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 22:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D0FCB5DD
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 19:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E6B861483
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 02:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59747C433C1;
        Fri, 19 Aug 2022 02:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660876490;
        bh=A0C0ES7ye7hri4SynIFV6cVxk5lvJNgMsqRxu3qMB1E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vi6MrO0xz2MQrptR/6qRXml+4yV2Fr4eM9IbuYysCslTVLkfqzs/2yBx0soEEdhZ9
         jI4tI/y4tnYvDH5Ult96gJt/m37ClxIxTuHaiL3AR05qClTfsEa86yV76tr5Mmg2+6
         M+6W6cP5S/SfgjFDZhQAc5XCcDoOVHiSK+6ioyH2EMMkW2QQ+nWZPpqF8oy2zkuFlZ
         5yfVqLSZ35MtJUGYi9QkqRTMaB4sdArK5F+k/dX1ovViVCN5e0S00Jx3G6y3OzsVqj
         L6kh4YA0rSRfhS2l19tnfEG7R3hxUgHK5y3PcNu16paAp0V/D9fso8+t9cT7kreYv1
         4aw4oUg9e4Q1A==
Date:   Thu, 18 Aug 2022 19:34:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220818193449.35c79b63@kernel.org>
In-Reply-To: <Yv3M/T5K/f35R5UM@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
        <20220816195408.56eec0ed@kernel.org>
        <Yvx6+qLPWWfCmDVG@unreal>
        <20220817111052.0ddf40b0@kernel.org>
        <Yv3M/T5K/f35R5UM@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 08:24:13 +0300 Leon Romanovsky wrote:
> On Wed, Aug 17, 2022 at 11:10:52AM -0700, Jakub Kicinski wrote:
> > My point is on what you called "full offload" vs "crypto offload".
> > The policy so far has always been that Linux networking stack should
> > populate all the headers and instruct the device to do crypto, no
> > header insertion. Obviously we do header insertion in switch/router
> > offloads but that's different and stateless.
> > 
> > I believe the reasoning was to provide as much flexibility and control
> > to the software as possible while retaining most of the performance
> > gains.  
> 
> I honestly don't know the reasoning, but "performance gains" are very
> limited as long as IPsec stack involved with various policy/state

Herm. So you didn't bother figuring out what the current problems are
but unsurprisingly the solution is "buy our product and let us do it"?

> lookups. These lookups are expensive in terms of CPU and they can't
> hold 400 Gb/s line rate.
> 
> https://docs.nvidia.com/networking/display/connectx7en/Introduction#Introduction-ConnectX-7400GbEAdapterCards
>
> > You must provide a clear analysis (as in examination in data) and
> > discussion (as in examination in writing) if you're intending to 
> > change the "let's keep packet formation in the SW" policy. What you 
> > got below is a good start but not sufficient.  
> 
> Can you please point me to an example of such analysis, so I will know
> what is needed/expected?

I can't, as I said twice now, we don't have any "full crypto" offloads
AFAIK.

> > > IPsec full offload is actually improved version of IPsec crypto mode,
> > > In full mode, HW is responsible to trim/add headers in addition to
> > > decrypt/encrypt. In this mode, the packet arrives to the stack as already
> > > decrypted and vice versa for TX (exits to HW as not-encrypted).
> > > 
> > > My main motivation is to perform IPsec on RoCE traffic and in our
> > > preliminary results, we are able to do IPsec full offload in line
> > > rate. The same goes for ETH traffic.  
> > 
> > If the motivation is RoCE I personally see no reason to provide the
> > configuration of this functionality via netdev interfaces, but I'll
> > obviously leave the final decision to Steffen.  
> 
> This is not limited to RoCE, our customers use this offload for ethernet
> traffic as well.
> 
> RoCE is a good example of traffic that performs all headers magic in HW,
> without SW involved.
> 
> IPsec clearly belongs to netdev and we don't want to duplicate netdev
> functionality in RDMA. Like I said above, this feature is needed for
> regular ETH traffic as well.
> 
> Right now, RoCE and iWARP devices are based on netdev and long-standing
> agreement ( >20 years ????) that all netdev configurations are done
> there they belong - in netdev.

Let me be very clear - as far as I'm concerned no part of the RDMA
stack belongs in netdev. What's there is there, but do not try to use
that argument to justify more stuff.

If someone from the community thinks that I should have interest in
working on / helping proprietary protocol stacks please let me know,
because right now I have none.
