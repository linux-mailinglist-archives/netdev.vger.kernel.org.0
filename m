Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991CD59E895
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343725AbiHWRHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343755AbiHWRDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:03:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F48BCC0B
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 07:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E8F7614F5
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 14:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07886C433D6;
        Tue, 23 Aug 2022 14:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661263622;
        bh=2FTxVBsIMcpp6W95ZNwurkkAl+h4nbKgxuXodFpRjqk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pYIxWBQ/O9WbQfPGj1P1IqkzBU3f9AlCsNkmwtaeVyy0UsJFN8unAuhca1PS1pzVp
         qVxbo0rpGolKGoCNcwEuAPTYO1VT8fzicVmVfFI+5rQSuk8GFyLVm8P4gocpl+lnRI
         jgEZZqtJuyCUZ7Mr/xCe7fHvrC31N+jZhVija+5NlOSKG2rf1fRzr3j/AlIDuQ9hoS
         jwEz+oxE7YFZTgneGIPGbdI7TyJpcSNl/Ud0s1ZJfGu4ai5t0rZDXGjhBfunbhgi3n
         AsECHInOnPu88RanAj6o9pBJRKjpgULQgtgaXjpDtOx+HEwpRzG+zrtttyYDoNNePO
         G4D50YdiIDx5Q==
Date:   Tue, 23 Aug 2022 17:06:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <YwTfAg/Fq4m85+u/@unreal>
References: <Yv8lGtYIz4z043aI@unreal>
 <20220819084707.7ed64b72@kernel.org>
 <Yv+z0nBW60SBFAmZ@nvidia.com>
 <20220819105356.100003d5@kernel.org>
 <20220822084105.GI2602992@gauss3.secunet.de>
 <YwNEUguW7aTXC2Vs@unreal>
 <20220822093304.7ddc5d35@kernel.org>
 <20220822212716.yji3ugbppse7snfy@sx1>
 <20220822171706.3287ee18@kernel.org>
 <20220823052203.GI2950045@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823052203.GI2950045@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 07:22:03AM +0200, Steffen Klassert wrote:
> On Mon, Aug 22, 2022 at 05:17:06PM -0700, Jakub Kicinski wrote:
> > On Mon, 22 Aug 2022 14:27:16 -0700 Saeed Mahameed wrote:
> > > >My questions about performance were more about where does
> > > >the performance loss originate. Is it because of loss of GRO?  
> > > 
> > > Performance loss between full and baseline ? it's hardly measurable .. 
> > > less than 3% in the worst case.
> > 
> > The loss for crypto only vs baseline is what I meant. Obviously if we
> > offload everything the CPU perf may look great but we're giving up
> > flexibility and ability to fix problems in SW. 
> 
> The main difference between baseline TCP and crypto offload
> is the policy/state lookup and ESP encapsulation/decapsulation.
> 
> We don't loose GRO on crypto offload. The ESP header/trailer
> is stripped away in the GRO layer so that the inner TCP
> packet gets GRO. But we loose hardware LRO, as the ESP
> headers are not stripped in HW.
> 
> It would be really good to see where the bottlenecks are
> with crypto offload (RX or TX).
> 
> Also, it would be good to see why the full offload performs
> better. Some perf traces would be helpfull.
> 
> When I thought about possible offloads, I came to three
> different types:
> 
> 1. encapsulation offload:
>    - Kernel does policy enforcement
>    - NIC does encapsulation
>    - NIC manages anti replay window and lifetime of SAs
>    - NIC sends lifetime and anti replay notifications to the kernel
>    - The Kernel talks to the keymanager
> 
> 2. statefull offload with fallback:
>    - NIC handles the full datapath, but kernel can take over (fragments
>      etc.)
>    - Kernel and NIC hold the full SA and policy database
>    - Kernel and NIC must sync the state (lifetime, replay window etc.)
>      of SAs and policies
>    - The Kernel talks to the keymanager
> 
> 3. statefull offload:
>    - NIC handles the full datapath
>    - NIC talks directly with the keymanager
>    - Kernel xfrm acts as a stub layer to pass messages from
>      userspace to the NIC.
> 
> The offload that is implemented here comes option 2 closest.
> The statefull handling is shared between host and NIC.
> Unfortunalely, this is the most complicated one.

Our implementation something like option 2 but without fallback.

1. I didn't implement fallback for a number of reasons:
 * It is almost impossible to keep in sync HW and SW states in linerate.
 * IPv6 sets (require???) do-not-fragment bit.
2. NIC and kernel keep their SA and policy databases in sync to make
sure that they both see coherent picture and for users to be able to
use existing iproute2 tools.
3. Like any other offload, I want to make sure that kernel in the middle
between our HW and user. This includes keymanager.

> 
> If just encapsulation/decapsulation brings the performance
> we could also go with option 1. That would be still a
> stateless offload.

Option 1 isn't sufficient for us as it doesn't support combination of TC
and eswitch manager. In that mode, packets that arrive to uplink forwarded
directly to representor without kernel involvement,

> 
> Option 3 is what I would consider as a full offload.
> Kernel acts as a stateless stub layer, NIC does
> statefull IPsec.
