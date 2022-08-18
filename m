Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11ADA597E0A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 07:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242818AbiHRFYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 01:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242905AbiHRFYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 01:24:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9E92E9C6
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 22:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22D6A61632
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA23C433C1;
        Thu, 18 Aug 2022 05:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660800257;
        bh=XGJKwz7xl4XUDCREE6ONBs224plF6srFS7KbhYhAD+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=twWWspO99OEFBb12gJscX/AMTGTOpupO2+YjsgdKvgg7+/aEDM7salYjoMAOD7wde
         9xP//KMYheYNxon/LfAmkI80h3IjfuttVN9eo3A3ilbq+sKVG5GKC79p2V5tmHz8le
         klEX7ocQvQGQcefr1Ytjq3X2fLLvApZPB9gRcafEkYTvJYYTOgfBtEP5wYCjEtHLbP
         7oBjA9td0qr1QjgOGcaD3x/LfWR1gC46jjfvEjeS1VVE2iIamArPTbOWMFoGFy9e5M
         zyqh22LkmLjukMy074wdTESO4KBpslMtaw0Xn4tciQ+2oY4ehJKQVXwRHDlQuRPSQl
         QLFux2Don6vew==
Date:   Thu, 18 Aug 2022 08:24:13 +0300
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
Message-ID: <Yv3M/T5K/f35R5UM@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <20220816195408.56eec0ed@kernel.org>
 <Yvx6+qLPWWfCmDVG@unreal>
 <20220817111052.0ddf40b0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817111052.0ddf40b0@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 11:10:52AM -0700, Jakub Kicinski wrote:
> On Wed, 17 Aug 2022 08:22:02 +0300 Leon Romanovsky wrote:
> > On Tue, Aug 16, 2022 at 07:54:08PM -0700, Jakub Kicinski wrote:
> > > This is making a precedent for full tunnel offload in netdev, right?  
> > 
> > Not really. SW IPsec supports two modes: tunnel and transport.
> > 
> > However HW and SW stack supports only offload of transport mode.
> > This is the case for already merged IPsec crypto offload mode and
> > the case for this full offload.
> 
> My point is on what you called "full offload" vs "crypto offload".
> The policy so far has always been that Linux networking stack should
> populate all the headers and instruct the device to do crypto, no
> header insertion. Obviously we do header insertion in switch/router
> offloads but that's different and stateless.
> 
> I believe the reasoning was to provide as much flexibility and control
> to the software as possible while retaining most of the performance
> gains.

I honestly don't know the reasoning, but "performance gains" are very
limited as long as IPsec stack involved with various policy/state
lookups. These lookups are expensive in terms of CPU and they can't
hold 400 Gb/s line rate.

https://docs.nvidia.com/networking/display/connectx7en/Introduction#Introduction-ConnectX-7400GbEAdapterCards

> 
> You must provide a clear analysis (as in examination in data) and
> discussion (as in examination in writing) if you're intending to 
> change the "let's keep packet formation in the SW" policy. What you 
> got below is a good start but not sufficient.

Can you please point me to an example of such analysis, so I will know
what is needed/expected?

> 
> > > Could you indulge us with a more detailed description, motivation,
> > > performance results, where the behavior of offload may differ (if at
> > > all), what visibility users have, how SW and HW work together on the
> > > datapath? Documentation would be great.  
> > 
> > IPsec full offload is actually improved version of IPsec crypto mode,
> > In full mode, HW is responsible to trim/add headers in addition to
> > decrypt/encrypt. In this mode, the packet arrives to the stack as already
> > decrypted and vice versa for TX (exits to HW as not-encrypted).
> > 
> > My main motivation is to perform IPsec on RoCE traffic and in our
> > preliminary results, we are able to do IPsec full offload in line
> > rate. The same goes for ETH traffic.
> 
> If the motivation is RoCE I personally see no reason to provide the
> configuration of this functionality via netdev interfaces, but I'll
> obviously leave the final decision to Steffen.

This is not limited to RoCE, our customers use this offload for ethernet
traffic as well.

RoCE is a good example of traffic that performs all headers magic in HW,
without SW involved.

IPsec clearly belongs to netdev and we don't want to duplicate netdev
functionality in RDMA. Like I said above, this feature is needed for
regular ETH traffic as well.

Right now, RoCE and iWARP devices are based on netdev and long-standing
agreement ( >20 years ????) that all netdev configurations are done
there they belong - in netdev.

If you think that RDMA<->netdev binding should be untied and netdev
functionality should be duplicated, feel free to submit topic to LPC
and/or catch me and/or Jason to discuss it during the venue.

> 
> > Regarding behavior differences - they are not expected.
> > 
> > We (Raed and me) tried very hard to make sure that IPsec full offload
> > will behave exactly as SW path.
> > 
> > There are some limitations to reduce complexity, but they can be removed
> > later if needs will arise. Right now, none of them are "real" limitations
> > for various *swarn forks, which we extend as well.
> > 
> > Some of them:
> > 1. Request to have reqid for policy and state. I use reqid for HW
> > matching between policy and state.
> 
> reqid?

Policy and state are matched based on their selectors (src/deet IP, direction ...),
but they independent. The reqid is XFRM identification that this specific policy
is connected to this specific state.
https://www.man7.org/linux/man-pages/man8/ip-xfrm.8.html
https://docs.kernel.org/networking/xfrm_device.html
ip x s add ....
   reqid 0x07 ...
   offload dev eth4 dir in

IPsec SW allows to do not set this field. In offload mode, we want to be
explicit and require from user to say which policy belongs to which state.

I personally never saw anyone who configures IPsec without reqid.

> 
> > 2. Automatic separation between HW and SW priorities, because HW sees
> > packet first.
> 
> More detail needed on that.

I have description in the commit message of relevant commit.
https://lore.kernel.org/all/191be9b9c0367d4554b208533f5d75f498784889.1660639789.git.leonro@nvidia.com/
-----
Devices that implement IPsec full offload mode offload policies too.
In RX path, it causes to the situation that HW can't effectively handle
mixed SW and HW priorities unless users make sure that HW offloaded
policies have higher priorities.

In order to make sure that users have coherent picture, let's require
that HW offloaded policies have always (both RX and TX) higher priorities
than SW ones.

To do not over engineer the code, HW policies are treated as SW ones and
don't take into account netdev to allow reuse of same priorities for
different devices.
-----

> 
> > 3. Only main template is supported.
> > 4. No fallback to SW if IPsec HW failed to handle packet. HW should drop
> > such packet.
> 
> Not great for debug.

For now, there are various vendor tools to inspect FW/HW state. We have some
rough ideas on how can we improve it and forward bad packets to SW for analysis,
but it is much advanced topic and needs this series to be merged first.

> 
> > Visibility:
> > Users can see the mode through iproute2
> > https://lore.kernel.org/netdev/cover.1652179360.git.leonro@nvidia.com/
> > and see statistics through ethtool.
> 
> Custom vendor stats?

XFRM doesn't have much to offer. There are bunch of LINUX_MIB_XFRM*
counters, but nothing more.

> 
> > Documentation will come as well. I assume that IPsec folks are familiar
> > with this topic as it was discussed in IPsec coffee hour. 
