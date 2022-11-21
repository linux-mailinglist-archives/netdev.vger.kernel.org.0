Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87F3631E48
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 11:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKUK1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 05:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiKUK1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 05:27:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E393AA4167
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:27:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A74AB80DF7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AD7C433C1;
        Mon, 21 Nov 2022 10:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669026426;
        bh=eWRGxCBEr6i/IvnUWOvN7JOHHdkRzgPgwyCiPexLVhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qmCg9VfTAcdErVX2LMViUvIh6VZ1WEBP/6y8QE+ek2wKWhvwFGEHfW2dy94I/R5PH
         aq0m+8f91W2c9T6spk7fKMn2rlMI+zHAGH6AZHIcY83N9C/TJ/3qj9ghwHvHZwsIb/
         ZvjF8e5LFmpZlVvevDvvVXbJFEeQtJ3mWiRjTIusuAf1+HNh1xPYfZ/LRmHLbK9U5X
         88PbZvzgqhzFnBMehpvuOWlQZKXi4kz63DXyw2IphM7U+dP49MWxRTZEw8tjLbJgq3
         skD+aL7Dx6msCczYOjon1ZWt+V7jJtMU3fgqD2IZj4TF+h6xyNlrg4dfEOVLXrGYgl
         D+QcDkWEM4X0g==
Date:   Mon, 21 Nov 2022 12:27:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y3tSdcA9GgpOJjgP@unreal>
References: <cover.1667997522.git.leonro@nvidia.com>
 <f611857594c5c53918d782f104d6f4e028ba465d.1667997522.git.leonro@nvidia.com>
 <20221117121243.GJ704954@gauss3.secunet.de>
 <Y3YuVcj5uNRHS7Ek@unreal>
 <20221118104907.GR704954@gauss3.secunet.de>
 <Y3p9LvAEQMAGeaCR@unreal>
 <20221121094404.GU704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121094404.GU704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 10:44:04AM +0100, Steffen Klassert wrote:
> On Sun, Nov 20, 2022 at 09:17:02PM +0200, Leon Romanovsky wrote:
> > On Fri, Nov 18, 2022 at 11:49:07AM +0100, Steffen Klassert wrote:
> > > On Thu, Nov 17, 2022 at 02:51:33PM +0200, Leon Romanovsky wrote:
> > > > On Thu, Nov 17, 2022 at 01:12:43PM +0100, Steffen Klassert wrote:
> > > > > On Wed, Nov 09, 2022 at 02:54:34PM +0200, Leon Romanovsky wrote:
> > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > > So this raises the question how to handle acquires with this packet
> > > > > offload. 
> > > > 
> > > > We handle acquires as SW policies and don't offload them.
> > > 
> > > We trigger acquires with states, not policies. The thing is,
> > > we might match a HW policy but create a SW acquire state.
> > > This will not match anymore as soon as the lookup is
> > > implemented correctly.
> > 
> > For now, all such packets will be dropped as we have offlaoded
> > policy but not SA.
> 
> I think you missed my point. If the HW policy does not match
> the SW acquire state, then each packet will geneate a new
> acquire. So you need to make sure that policy and acquire
> state will match to send the acquire just once to userspace.

I think that I'm still missing the point.

We require both policy and SA to be offloaded. It means that once
we hit HW policy, we must hit SA too (at least this is how mlx5 part
is implemented).

If it doesn't hit HW policy, it means that whole path is not offloaded,
so no harm will be if we create SW SA for this path.

> 
> > > > It is not different from any other kernel code, bugs will be fixed.
> > > 
> > > The thing that is different here is, that the concept is already
> > > broken. We can't split the datapath to be partially handled in
> > > SW and HW in any sane way, this becomes clearer and clearer.
> > > 
> > > The full protocol offload simply does not fit well into HW,
> > > but we try to make it fit with a hammer. This is the problem
> > > why I do not really like this, and is also the reason why this
> > > is still not merged. We might be much better of by doing a
> > > HW frindly redesign of the protocol and offload this then.
> > > But, yes that takes time and will have issues too.
> > 
> > When you say "protocol", what do you mean? Many users, who have
> > deployed IPsec solutions, just want to have same look and feel
> > but much faster.
> > 
> > I truly believe that this packet offload fits SW model and the
> > (small) amount of changes supports it. There are almost no changes
> > to the stack to natively support this offload.
> > 
> > As long as HW involved, you will never have solution without issues,
> > and like you said even redesign "will have issues".
> 
> Things would be much easier, if we don't need to add HW policies
> and states to SW databases. But yes, a redesign might have issues
> too. That's why we are still working on the current soluion :)
> 

There will be PSP for that, but it is not IPsec.

Thanks
