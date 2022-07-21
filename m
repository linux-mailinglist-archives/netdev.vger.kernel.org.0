Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F10C57D15F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiGUQU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiGUQU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:20:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E96DD116;
        Thu, 21 Jul 2022 09:20:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF03061E05;
        Thu, 21 Jul 2022 16:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980B6C3411E;
        Thu, 21 Jul 2022 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658420426;
        bh=HOKEGqbNtknAQt0cuic72RlBJrJJCnIdEoHjz7JAhlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l+5A6RFlEIQFZPdSUHe0prdiulAO6baXLituorna5fBrBm99sBmBgHZmhLfTJqaSC
         tTyMNT80CdJZEwU2hbwYlFB5D8q4DJZil8eLn5dERURcRRmnm1X95uEp9JH2GRNRDc
         vGHnEBZI/dFLJVS9RHQvIlQdCKDuHr1DZRXgCpSfRllNOjBBuwg9tYoBGOEhRHekro
         JLmiUXJfjciD/9qUv1dEx5eUF3GNEG03Nf578D4VJ9HXkgqliVCOu+biyAptEIqwd7
         w143xM46gWWv/a1Y9jabkmIHdCuttZyT3EIxlL2tbCNejStAA89Uq4hH1/YC+ukZCT
         ojNTgBjfQjw+A==
Date:   Thu, 21 Jul 2022 09:20:23 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, llvm@lists.linux.dev
Subject: Re: [PATCH net-next 18/29] can: pch_can: do not report txerr and
 rxerr during bus-off
Message-ID: <Ytl8x20qmsKyYJpS@dev-arch.thelio-3990X>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
 <20220720081034.3277385-19-mkl@pengutronix.de>
 <YtlwSpoeT+nhmhVn@dev-arch.thelio-3990X>
 <20220721154725.ovcsfiio7e6hts2n@pengutronix.de>
 <CAMZ6RqLdYCqag_MDp7dj=u1SEjx1r=bs_xHG26w11_A_D_SumQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLdYCqag_MDp7dj=u1SEjx1r=bs_xHG26w11_A_D_SumQ@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 01:11:49AM +0900, Vincent MAILHOL wrote:
> On Fri. 22 Jul. 2022 at 00:49, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > On 21.07.2022 08:27:06, Nathan Chancellor wrote:
> > > On Wed, Jul 20, 2022 at 10:10:23AM +0200, Marc Kleine-Budde wrote:
> > > > From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > > >
> > > > During bus off, the error count is greater than 255 and can not fit in
> > > > a u8.
> > > >
> > > > Fixes: 0c78ab76a05c ("pch_can: Add setting TEC/REC statistics processing")
> > > > Link: https://lore.kernel.org/all/20220719143550.3681-2-mailhol.vincent@wanadoo.fr
> > > > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > > > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > > > ---
> > > >  drivers/net/can/pch_can.c | 6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> > > > index fde3ac516d26..497ef77340ea 100644
> > > > --- a/drivers/net/can/pch_can.c
> > > > +++ b/drivers/net/can/pch_can.c
> > > > @@ -496,6 +496,9 @@ static void pch_can_error(struct net_device *ndev, u32 status)
> > > >             cf->can_id |= CAN_ERR_BUSOFF;
> > > >             priv->can.can_stats.bus_off++;
> > > >             can_bus_off(ndev);
> > > > +   } else {
> > > > +           cf->data[6] = errc & PCH_TEC;
> > > > +           cf->data[7] = (errc & PCH_REC) >> 8;
> > > >     }
> > > >
> > > >     errc = ioread32(&priv->regs->errc);
> > > > @@ -556,9 +559,6 @@ static void pch_can_error(struct net_device *ndev, u32 status)
> > > >             break;
> > > >     }
> > > >
> > > > -   cf->data[6] = errc & PCH_TEC;
> > > > -   cf->data[7] = (errc & PCH_REC) >> 8;
> > > > -
> > > >     priv->can.state = state;
> > > >     netif_receive_skb(skb);
> > > >  }
> > > > --
> > > > 2.35.1
> > > >
> > > >
> > > >
> > >
> > > Apologies if this has been reported already, I didn't see anything on
> > > the mailing lists.
> > >
> > > This commit is now in -next as commit 3a5c7e4611dd ("can: pch_can: do
> > > not report txerr and rxerr during bus-off"), where it causes the
> > > following clang warning:
> > >
> > >   ../drivers/net/can/pch_can.c:501:17: error: variable 'errc' is uninitialized when used here [-Werror,-Wuninitialized]
> > >                   cf->data[6] = errc & PCH_TEC;
> > >                                 ^~~~
> > >   ../drivers/net/can/pch_can.c:484:10: note: initialize the variable 'errc' to silence this warning
> > >           u32 errc, lec;
> > >                   ^
> > >                    = 0
> > >   1 error generated.
> > >
> > > errc is initialized underneath this now, should it be hoisted or is
> > > there another fix?
> 
> Thanks for reporting and sorry for the bug.

No worries, it happens :)

> That said, I have one complaint: this type of warning is reported at
> W=2 *but* W=2 output is heavily polluted, mostly due to a false
> positive on linux/bits.h's GENMASK_INPUT_CHECK(). Under the current
> situation, the relevant warings become invisible with all the
> flooding.
> I tried to send a patch to silence a huge chunk of the W=2 spam in [1]
> but it got rejected. I am sorry but even with the best intent, I might
> repeat a similar mistake in the future. The W=2 is just not usable.
> 
> [1] https://lore.kernel.org/all/20220426161658.437466-1-mailhol.vincent@wanadoo.fr/

Yes, having -Wmaybe-uninitialized in W=2 is unfortunate because these
types of mistakes will continue to happen. I have been fighting this for
a while and so has Dan Carpenter, who started a thread about it a couple
of months ago but it doesn't seem like it really went anywhere:

https://lore.kernel.org/20220506091338.GE4031@kadam/

Cheers,
Nathan
