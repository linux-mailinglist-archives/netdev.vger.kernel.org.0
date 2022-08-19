Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D672C5994E9
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 08:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242556AbiHSFwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiHSFwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C46BE193F
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 22:52:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21C2261549
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8654C433D6;
        Fri, 19 Aug 2022 05:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660888351;
        bh=TfZXq47iqzu/8EIddl0mIZxfS8ttR7DPvdgKC6bhgzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iMLxMIPA5bW3TLwBz7fXUhH/P89ns2+voPhaSFhy6WXFRamUBhB1i45/kdioP/LVU
         EPossTSRJT/3n1MRpvqI7Rii68R0J+U2ssUoCmhj/n3yoaPp2ai+NoW9iMVrWrCJpI
         zl9JYud9ssdsIQpHUOaGeWwqSs6xeMJpiCsDZ7hrFZ63Kx3KoZ/ku+wMk2C9t64Esy
         h1l0PURx2EyxDGJeeqsxKxgA4av3S02QdiLpQOhsoDu50+8eTKMpd693alpcvU4+k3
         ZdSW1Givl2KdSnh5aNLsDua4lB9uWZQoKaMG+gB7UnTlBlU3JDkjRudSV51bXup1xd
         L3YE8jsUzy6Xw==
Date:   Fri, 19 Aug 2022 08:52:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <Yv8lGtYIz4z043aI@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <20220816195408.56eec0ed@kernel.org>
 <Yvx6+qLPWWfCmDVG@unreal>
 <20220817111052.0ddf40b0@kernel.org>
 <Yv3M/T5K/f35R5UM@unreal>
 <20220818193449.35c79b63@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818193449.35c79b63@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 07:34:49PM -0700, Jakub Kicinski wrote:
> On Thu, 18 Aug 2022 08:24:13 +0300 Leon Romanovsky wrote:
> > On Wed, Aug 17, 2022 at 11:10:52AM -0700, Jakub Kicinski wrote:
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
> 
> Herm. So you didn't bother figuring out what the current problems are
> but unsurprisingly the solution is "buy our product and let us do it"?

Our hardware didn't support full offload back then and crypto mode
was the one that was supported in our mlx5 FPGA offering. There are
no "other" reasons from our side.

> 
> > lookups. These lookups are expensive in terms of CPU and they can't
> > hold 400 Gb/s line rate.
> > 
> > https://docs.nvidia.com/networking/display/connectx7en/Introduction#Introduction-ConnectX-7400GbEAdapterCards
> >
> > > You must provide a clear analysis (as in examination in data) and
> > > discussion (as in examination in writing) if you're intending to 
> > > change the "let's keep packet formation in the SW" policy. What you 
> > > got below is a good start but not sufficient.  
> > 
> > Can you please point me to an example of such analysis, so I will know
> > what is needed/expected?
> 
> I can't, as I said twice now, we don't have any "full crypto" offloads
> AFAIK.

No, I'm asking for an example of "clear analysis (as in examination in
data)", as I don't understand this sentence. I'm not asking for "full
crypto" examples.

This "discussion (as in examination in writing)" part is clear.

> 
> > > > IPsec full offload is actually improved version of IPsec crypto mode,
> > > > In full mode, HW is responsible to trim/add headers in addition to
> > > > decrypt/encrypt. In this mode, the packet arrives to the stack as already
> > > > decrypted and vice versa for TX (exits to HW as not-encrypted).
> > > > 
> > > > My main motivation is to perform IPsec on RoCE traffic and in our
> > > > preliminary results, we are able to do IPsec full offload in line
> > > > rate. The same goes for ETH traffic.  
> > > 
> > > If the motivation is RoCE I personally see no reason to provide the
> > > configuration of this functionality via netdev interfaces, but I'll
> > > obviously leave the final decision to Steffen.  
> > 
> > This is not limited to RoCE, our customers use this offload for ethernet
> > traffic as well.
> > 
> > RoCE is a good example of traffic that performs all headers magic in HW,
> > without SW involved.
> > 
> > IPsec clearly belongs to netdev and we don't want to duplicate netdev
> > functionality in RDMA. Like I said above, this feature is needed for
> > regular ETH traffic as well.
> > 
> > Right now, RoCE and iWARP devices are based on netdev and long-standing
> > agreement ( >20 years ????) that all netdev configurations are done
> > there they belong - in netdev.
> 
> Let me be very clear - as far as I'm concerned no part of the RDMA
> stack belongs in netdev. What's there is there, but do not try to use
> that argument to justify more stuff.
> 
> If someone from the community thinks that I should have interest in
> working on / helping proprietary protocol stacks please let me know,
> because right now I have none.

No one is asking from you to work on proprietary protocols.

RoCE is IBTA standard protocol and iWARP is IETF one. They both fully
documented and backed by multiple vendors (Intel, IBM, Mellanox, Cavium
...).

There is also interoperability lab https://www.iol.unh.edu/ that runs
various tests. In addition to distro interoperability labs testing.

I invite you to take a look on Jason's presentation "Challenges of the
RDMA subsystem", which he gave 3 years ago, about RDMA and challenges
with netdev.
https://lpc.events/event/4/contributions/364/

Thanks
