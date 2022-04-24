Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA76050D5A9
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 00:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbiDXWUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 18:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiDXWUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 18:20:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C48E68F8A;
        Sun, 24 Apr 2022 15:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4KJhNI7dzi5fLHGxffpbeO6uNcV4HJTh/uEWY/YLuRI=; b=XihePaqfCifBFs/qq8nvPD42yQ
        HqcV3RCwV8yRJaVIFD8aRofLAgbVYuuOluce0aKidGzus8BeAlbkutDV8Fd77Zyg6dq405Rt63yhH
        Qua6PLWb3qmFh61VhYpF8IezAeI95051bWrDTe9+fv2nCbGmutAifpBTA+8D9XpzSzNs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nikXh-00HJW0-2S; Mon, 25 Apr 2022 00:17:21 +0200
Date:   Mon, 25 Apr 2022 00:17:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Subject: Re: [PATCH] FDDI: defxx: simplify if-if to if-else
Message-ID: <YmXMcUAhUg/p1X3R@lunn.ch>
References: <20220424092842.101307-1-wanjiabing@vivo.com>
 <alpine.DEB.2.21.2204241137440.9383@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2204241137440.9383@angie.orcam.me.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 11:39:50AM +0100, Maciej W. Rozycki wrote:
> On Sun, 24 Apr 2022, Wan Jiabing wrote:
> 
> > diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
> > index b584ffe38ad6..3edb2e96f763 100644
> > --- a/drivers/net/fddi/defxx.c
> > +++ b/drivers/net/fddi/defxx.c
> > @@ -585,10 +585,10 @@ static int dfx_register(struct device *bdev)
> >  			bp->mmio = false;
> >  			dfx_get_bars(bp, bar_start, bar_len);
> >  		}
> > -	}
> > -	if (!dfx_use_mmio)
> > +	} else {
> >  		region = request_region(bar_start[0], bar_len[0],
> >  					bdev->driver->name);
> > +	}
> 
>  NAK.  The first conditional optionally sets `bp->mmio = false', which 
> changes the value of `dfx_use_mmio' in some configurations:
> 
> #if defined(CONFIG_EISA) || defined(CONFIG_PCI)
> #define dfx_use_mmio bp->mmio
> #else
> #define dfx_use_mmio true
> #endif

Which is just asking for trouble like this.

Could i suggest dfx_use_mmio is changed to DFX_USE_MMIO to give a hint
something horrible is going on.

It probably won't stop the robots finding this if (x) if (!x), but
there is a chance the robot drivers will wonder why it is upper case.

	  Andrew
