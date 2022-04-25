Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD1350DFA5
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 14:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbiDYMKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 08:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiDYMKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 08:10:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6557C4C43C;
        Mon, 25 Apr 2022 05:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=F+wEY33ANWUtYg71aqPrc+AB1BTI6Adh9M1qs1IIjjs=; b=5nhbs9GYvPdZxBd8ZMwJvFd37R
        1TAIliDayrCvWbT6U+AjG2ydOccbVTtmQf2h1TLEY5xzBDbYBLfc9PnI8YWAuC+quDvBW39V7vmJ8
        tO5a0to474WxsEE92DyxQ1OTSusUZTUjR1boABsz0NeOqXZP7LpmKtqxY0HoBQBQfSF4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nixUG-00HOZ3-3x; Mon, 25 Apr 2022 14:06:40 +0200
Date:   Mon, 25 Apr 2022 14:06:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Subject: Re: [PATCH] FDDI: defxx: simplify if-if to if-else
Message-ID: <YmaO0PEZS6mjsHhO@lunn.ch>
References: <20220424092842.101307-1-wanjiabing@vivo.com>
 <alpine.DEB.2.21.2204241137440.9383@angie.orcam.me.uk>
 <YmXMcUAhUg/p1X3R@lunn.ch>
 <alpine.DEB.2.21.2204250009240.9383@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2204250009240.9383@angie.orcam.me.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 12:26:10AM +0100, Maciej W. Rozycki wrote:
> On Mon, 25 Apr 2022, Andrew Lunn wrote:
> 
> > >  NAK.  The first conditional optionally sets `bp->mmio = false', which 
> > > changes the value of `dfx_use_mmio' in some configurations:
> > > 
> > > #if defined(CONFIG_EISA) || defined(CONFIG_PCI)
> > > #define dfx_use_mmio bp->mmio
> > > #else
> > > #define dfx_use_mmio true
> > > #endif
> > 
> > Which is just asking for trouble like this.
> > 
> > Could i suggest dfx_use_mmio is changed to DFX_USE_MMIO to give a hint
> > something horrible is going on.
> 
>  There's legacy behind it, `dfx_use_mmio' used to be a proper variable and 
> references were retained not to obfuscate the changes that ultimately led 
> to the current arrangement.  I guess at this stage it could be changed to 
> a function-like macro or a static inline function taking `bp' as the 
> argument.

Yes, something like that would be good.

> > It probably won't stop the robots finding this if (x) if (!x), but
> > there is a chance the robot drivers will wonder why it is upper case.
> 
>  Well, blindly relying on automation is bound to cause trouble.

Unfortunately, there are a number of bot drivers who do blindly rely
on automation. We have had to undo the same broken bot driven changes
a few times, and ended up adding extra comments to catch the eye of
the bot drivers.

    Andrew
