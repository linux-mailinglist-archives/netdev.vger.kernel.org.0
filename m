Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CE5633E3B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbiKVN4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbiKVN4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:56:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3FC67107
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:56:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46D4461717
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24545C433D6;
        Tue, 22 Nov 2022 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669125364;
        bh=rJL8X2oJQ0FyYLwfzd91iqUqUZ3hixWq7GIdXdaRvPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pN5YGdkc7P6QeccalXoHybWIgE6w5BZrPCzL9+jzBGEupuQYE7w+3zWHqhhkGvxpC
         upbk6+FSwuz7KqaAW6Z7NvsQf5XnA7rd8QNACxOqn5AjgfjHCMEMO2PnQq+PrKgPwJ
         pXF850Ry5MYVzxhwQZWZcS1blhYWaAXd+GTpFdLPB24v1k6z5pEuQqN+9PxFaWnrXZ
         bo7SIo2s/uACS/5R5yi/AtpNPl39nZU3PJd+uZul4CSN5vrdJzlKvL+zgqp+VMI9//
         GFoVIwtaEkOzWqhJydqVhDZKdQ5ncMt66KN5sy7NebP/RgX0DjzV5dvPL93bz9QlX/
         qyARK5hHWuYcA==
Date:   Tue, 22 Nov 2022 15:54:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y3zUosZQhPyoE53C@unreal>
References: <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <20221121121040.GY704954@gauss3.secunet.de>
 <Y3t7aSUBPXPoR8VD@unreal>
 <Y3xQGEZ7izv/JAAX@gondor.apana.org.au>
 <Y3xr5DkA+EZXEfkZ@unreal>
 <20221122130002.GM704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122130002.GM704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 02:00:02PM +0100, Steffen Klassert wrote:
> On Tue, Nov 22, 2022 at 08:27:48AM +0200, Leon Romanovsky wrote:
> > On Tue, Nov 22, 2022 at 12:29:12PM +0800, Herbert Xu wrote:
> > > On Mon, Nov 21, 2022 at 03:21:45PM +0200, Leon Romanovsky wrote:
> > > >
> > > > The thing is that this SW acquire flow is a fraction case, as it applies
> > > > to locally generated traffic.
> > > 
> > > A router can trigger an acquire on forwarded packets too.  Without
> > > larvals this could quickly overwhelm the router.
> > 
> > This series doesn't support tunnel mode yet.
> 
> It does not matter if tunnel or transport mode, acquires must
> work as expected. This is a fundamental concept of IPsec, there
> is no way to tell userspace that we don't support this.
> 
> > Maybe I was not clear, but I wanted to say what in eswitch case and
> > tunnel mode, the packets will be handled purely by HW without raising
> > into SW core.
> 
> Can you please explain why we need host interaction for
> transport, but not for tunnel mode?

The main difference is that in transport mode, you must bring packet
to the kernel in which you configured SA/policy. It means that we must
ensure that such packets won't be checked again in SW because all packets
(encrypted and not) pass XFRM logic.

 - wire -> RX NIC -> kernel -> XFRM stack (we need HW DB here to skip this stage) -> ....
 ... -> kernel -> XFRM stack (skip for HW SA/policies) -> TX NIC -> wire.

In tunnel mode, we arrive to XFRM when nothing IPsec related is configured.

 - wire -> RX PF NIC -> eswitch NIC logic -> TX uplink NIC -> RX
   representors -> XFRM stack in VM (nothing configured here) -> kernel

The most troublesome part is in TX path, where you must skip "double check"
before NIC. This check doesn't exist in tunnel mode.

In RX, there is also difference between modes due to how we are supposed
to treat headers.

Raed will add more details.

> 
> And as said already, I want to see the full picture (transport
> + tunnel mode) before we merge it.

It looks like we already have this picture.

Thanks
