Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114975A382F
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 16:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiH0Owo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 10:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiH0Own (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 10:52:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2895F22BF6;
        Sat, 27 Aug 2022 07:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sR79VFPBCA8tZLh/TC8sfn22rbjfdEtN+K5XwPFv4Vg=; b=Zek9T16mlWliPSt+ILl7HNpUXZ
        ISGrWQwL2tJatiOMDb2e2b04CfkM5CdEFW55s6IVJoBhZT7UxM8gmlixiyoBrkxov+dOtyGaLLV5D
        DVXAHZYPWO77A1dqnNhvRAHngRe8TFFdoKmjJ2QK9THhzlVIhDFzptGsq39Ln3qn0jio=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRxAr-00EmcQ-KC; Sat, 27 Aug 2022 16:52:37 +0200
Date:   Sat, 27 Aug 2022 16:52:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [net-next PATCH v2] net: dsa: qca8k: convert to regmap
 read/write API
Message-ID: <YwovtTcGvE5OOHIz@lunn.ch>
References: <20220827114918.8863-1-ansuelsmth@gmail.com>
 <YwojiJdIsz/qL1XC@lunn.ch>
 <630a2575.170a0220.be4f4.6683@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <630a2575.170a0220.be4f4.6683@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 27, 2022 at 03:48:34PM +0200, Christian Marangi wrote:
> On Sat, Aug 27, 2022 at 04:00:40PM +0200, Andrew Lunn wrote:
> > >  static struct regmap_config qca8k_regmap_config = {
> > > -	.reg_bits = 16,
> > > +	.reg_bits = 32,
> > 
> > Does this change really allow you to access more registers? 
> >
> 
> I could be confused but I think the value was wrong from the start. (the
> driver is a bit old and the regmap config struct was very wrong at
> times)
> This should declare how wide is each address right?
> 
> If this is the case then at times who declared the regmap config was
> confused by the fact that the mdio is limited to 16 bits and require
> special handling.
> 
> This is not problematic for the bits ops but is problematic for the bulk
> ops as they base the calculation on these values.
> 
> Or I could be totally wrong... Anyway without this change the wrong
> address is passed to the bulk ops so it's necessary (and for the said
> reason, the value was wrong from the start)

So please figure it out, maybe use git blame to see who added it, and
ask etc. And then submit a patch which changes just this, including
and explanation why it should be changed.
 
> > >  	.val_bits = 32,
> > >  	.reg_stride = 4,
> > >  	.max_register = 0x16ac, /* end MIB - Port6 range */
> > > -	.reg_read = qca8k_regmap_read,
> > > -	.reg_write = qca8k_regmap_write,
> > > +	.read = qca8k_bulk_read,
> > > +	.write = qca8k_bulk_write,
> > >  	.reg_update_bits = qca8k_regmap_update_bits,
> > >  	.rd_table = &qca8k_readable_table,
> > >  	.disable_locking = true, /* Locking is handled by qca8k read/write */
> > >  	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
> > > +	.max_raw_read = 16, /* mgmt eth can read/write up to 4 bytes at times */
> > > +	.max_raw_write = 16,
> > 
> > I think the word 'bytes' in the comment is wrong. I assume you can
> > access 4 registers, each register is one 32-bit work in size.
> > 
> 
> Yes you are right. Any suggestion on how to improve?

s/bytes/words/

	Andrew
