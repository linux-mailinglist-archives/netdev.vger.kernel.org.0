Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4411635A64
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiKWKnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbiKWKlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:41:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DEC4F193
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:25:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A2161B40
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CB3C433D7;
        Wed, 23 Nov 2022 10:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669199141;
        bh=d9ne0YAilJ+2H0dTuSrwE1dvHOn6U+SptYbF8zwKHOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e3sqTZWhBd9Q8a/jn8Z05TGamtgh9bPGYr2RJiDcOZqAaD5We2sz4nLqnI1zolNOt
         1HWEJlByVXEa+l8atbB1X0Oix3jUSGw1pAHJSg9HClEapWF0al5z/FUV5ZR0qYfhEM
         LgJyGi2HEmGkUC00hNNqzGzDlW4idyRZJXio49RwZCRgzK4ks0M0Gdf7yd9jVjDvbo
         QepI8vafdHNUbKJznIePgengrhrFzi+L15yCVm+rD6xjAl6jPjx09wZheiuqqkSAzw
         HrJpZwseYoHKsKcP49wawZipV+bD25kM7cz2zLsh3086HRh2Ru1ZgaKB3ASzzF/yvP
         fRss1luNOHzHA==
Date:   Wed, 23 Nov 2022 12:25:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y331Hli5YG5XtRgc@unreal>
References: <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <20221121121040.GY704954@gauss3.secunet.de>
 <Y3t7aSUBPXPoR8VD@unreal>
 <Y3xQGEZ7izv/JAAX@gondor.apana.org.au>
 <Y3xr5DkA+EZXEfkZ@unreal>
 <20221122130002.GM704954@gauss3.secunet.de>
 <Y3zUosZQhPyoE53C@unreal>
 <20221123082358.GL424616@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123082358.GL424616@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 09:23:58AM +0100, Steffen Klassert wrote:
> On Tue, Nov 22, 2022 at 03:54:42PM +0200, Leon Romanovsky wrote:
> > On Tue, Nov 22, 2022 at 02:00:02PM +0100, Steffen Klassert wrote:
> > > On Tue, Nov 22, 2022 at 08:27:48AM +0200, Leon Romanovsky wrote:
> > > > On Tue, Nov 22, 2022 at 12:29:12PM +0800, Herbert Xu wrote:
> > > > > On Mon, Nov 21, 2022 at 03:21:45PM +0200, Leon Romanovsky wrote:
> > > 
> > > Can you please explain why we need host interaction for
> > > transport, but not for tunnel mode?
> > 
> > The main difference is that in transport mode, you must bring packet
> > to the kernel in which you configured SA/policy. It means that we must
> > ensure that such packets won't be checked again in SW because all packets
> > (encrypted and not) pass XFRM logic.
> > 
> >  - wire -> RX NIC -> kernel -> XFRM stack (we need HW DB here to skip this stage) -> ....
> >  ... -> kernel -> XFRM stack (skip for HW SA/policies) -> TX NIC -> wire.
> > 
> > In tunnel mode, we arrive to XFRM when nothing IPsec related is configured.
> > 
> >  - wire -> RX PF NIC -> eswitch NIC logic -> TX uplink NIC -> RX
> >    representors -> XFRM stack in VM (nothing configured here) -> kernel
> 
> Forget about eswitch, VM, etc. for a moment. I'm interested how the
> simplest possible tunnel mode cases will work.
> 
> Forwarding:
> 
> wire -> random NIC RX -> kernel -> IPsec tunnel offload NIC TX -> wire
> wire -> IPsec tunnel offload NIC RX -> kernel -> random NIC TX -> wire
> 
> Local endpoints:
> 
> Application -> kernel -> IPsec tunnel offload NIC TX -> wire
> wire -> IPsec tunnel offload NIC RX -> kernel -> Application
> 
> These two must work, so how are these cases handled?

These two cases conceptually no different from transport modes.
The difference is how HW handles IP packets.

If packet comes from RX, it will be received as plain packet in the
kernel. If packet goes to TX, it must be skipped in the XFRM.

For all "wire -> IPsec tunnel offload NIC RX ...", everything works
as you would expect. HW handles everything, and feeds the kernel with
plain packet. These packets will have CRYPTO_DONE and status so they
can skip all XFRM logic.

All this complexity is For "... kernel -> IPsec tunnel offload NIC TX -> wire"
flow. You need a way to say to the kernel that XFRM should be skipped.


In TX path, we will need to perform neighbor resolution to fill proper
MAC address for outer IP header.
In RX path, once the packet is decrypted, there is a need to change MAC
address for the inner IP header. This will be done by kernel as HW
doesn't have such knowledge.

Of course, there are many possible implementations of how to have right
MAC address (static during SA creations, or dynamic if we listen to ARP
events), but it is not XFRM related.

Thanks

> 
> If you can do more fancy things with tunnel mode and special NICs
> at TX and RX, that's fine but not absolutely required.
