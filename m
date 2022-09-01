Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36B35A9686
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiIAMSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiIAMST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:18:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2918F118A6E
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=6vR9V17BoaRpOP5SeV/OAAka6Lc9MbAl9iI405pM6wc=; b=wL
        R0U6n7OXKElD1neM9wc8Pb7lD/BufFDp8x6oTFdxGExtpXdEu+AaVfSn1T6GQr5XCFa82CZ4YUfw1
        UGmiCY83jucaBEETN+nnwd1i6bUbmx2JY0F3zP+PfokrexerSbugcMHmmIe9oOoprlc9GoXKrpJWe
        PyYwpVCXoOqEpVs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTj9E-00FIkv-T8; Thu, 01 Sep 2022 14:18:16 +0200
Date:   Thu, 1 Sep 2022 14:18:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH] Use a spinlock to guard `fep->ptp_clk_on`
Message-ID: <YxCjCM78tsk9J3gy@lunn.ch>
References: <20220831125631.173171-1-csokas.bence@prolan.hu>
 <20220831171259.GA147052@francesco-nb.int.toradex.com>
 <18c0c238-a006-7e52-65c5-1bcec0ee31e5@prolan.hu>
 <bfd69a72-1c45-a9a3-002b-697aa932c261@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bfd69a72-1c45-a9a3-002b-697aa932c261@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 10:06:03AM +0200, Csókás Bence wrote:
> 
> On 2022. 09. 01. 9:51, Csókás Bence wrote:
> > 
> > On 2022. 08. 31. 18:24, Andrew Lunn wrote:
> >  >>> Please keep to reverse christmas tree
> >  >>
> >  >> checkpatch didn't tell me that was a requirement... Easy to fix though.
> >  >
> >  > checkpatch does not have the smarts to detect this. And it is a netdev
> >  > only thing.
> > 
> > I thought checkpatch also has the per-subsystem rules, too.
> > 
> >  > There is also a different between not being able to sleep, and not
> >  > being able to process an interrupt for some other hardware. You got a
> >  > report about taking a mutex in atomic context. That just means you
> >  > cannot sleep, probably because a spinlock is held. That is very
> >  > different to not being able to handle interrupts. You only need
> >  > spin_lock_irqsave() if the interrupt handler also needs the same spin
> >  > lock to protect it from a thread using the spin lock.
> > 
> > Alright, I will switch to plain `spin_lock()` then.
> 
> By the way, what about `&fep->tmreg_lock`? Should that also be switched to
> `spin_lock()`? If not, how should I handle the nested locking? Calling
> `spin_lock_irqsave(&fep->tmreg_lock)` after `spin_lock(&&fep->ptp_clk_lock)`
> seems pointless. Should I lock with `spin_lock_irqsave(&fep->ptp_clk_lock)`
> there?

Richard was making the point, do you need two locks?

What are the locks protecting? Could you use one lock for both use
cases? Should the other lock also not be an _irqsave()?

       Andrew
