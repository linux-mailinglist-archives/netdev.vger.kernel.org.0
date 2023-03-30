Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFE96D0020
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjC3Jrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjC3JrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:47:15 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1616586B4;
        Thu, 30 Mar 2023 02:46:36 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 892C2E0010;
        Thu, 30 Mar 2023 09:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680169595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tDZMFFeXlhTNHv0SPx6QXJ/W5qsCoVxWgCf1SwG+2Wo=;
        b=jl1v7xa81tnvUJc7h0fegAZMWr2Di8Zr9J7ucrXYdEnehswb+2ISKV+RyjocaWIoYTH9AI
        E6HMrrTV2eX7J5osIb34clZX6kQL46SOnjqcZp21jqhUhT349ljsSeaeAgNxIkihlvfyzz
        jFpIaOsBrejO1VxvmqNtSnW3zoW8biP5QIYg8ykBeby1NdknwWVUkJBOcNMZKMvGSlD81g
        z2Ou6jivSsdrTQlSYQwHjN0rhBQxUhdnO1h191oRXFqOYBjkY27a1ofnierJaW25hor1ZX
        m/xHqnOfqLrcT5viVwqpARBqIFc5mo9FkOKqageu4oA8v1RNvSjT/Npb4G5mSg==
Date:   Thu, 30 Mar 2023 11:46:31 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [RFC 4/7] mfd: ocelot-spi: Change the regmap stride to reflect
 the real one
Message-ID: <20230330114631.6afa041c@pc-7.home>
In-Reply-To: <826e295b-6a0b-4015-85bc-5ba6015678dc@lunn.ch>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
        <20230324093644.464704-5-maxime.chevallier@bootlin.com>
        <c87cd0b0-9ea4-493d-819d-217334c299dd@lunn.ch>
        <20230324134817.50358271@pc-7.home>
        <826e295b-6a0b-4015-85bc-5ba6015678dc@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On Mon, 27 Mar 2023 02:02:55 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > > >  static const struct regmap_config ocelot_spi_regmap_config = {
> > > >  	.reg_bits = 24,
> > > > -	.reg_stride = 4,
> > > > +	.reg_stride = 1,
> > > >  	.reg_shift = REGMAP_DOWNSHIFT(2),
> > > >  	.val_bits = 32,    
> > > 
> > > This does not look like a bisectable change? Or did it never work
> > > before?  
> > 
> > Actually this works in all cases because of "regmap: check for
> > alignment on translated register addresses" in this series. Before
> > this series, I think using a stride of 1 would have worked too, as
> > any 4-byte-aligned accesses are also 1-byte aligned.  
> 
> This is the sort of think which is good to explain in the commit
> message. That is the place to answer questions reviewers are likely to
> ask for things which are not obvious from just the patch.

That's right, I will include this explanation in the next iteration.
Thanks for the review,

Maxime

>     Andrew

