Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E77591C99
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 22:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbiHMUmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 16:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiHMUmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 16:42:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8E5DF7;
        Sat, 13 Aug 2022 13:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uYG/3bvDD/aIehieTFZ6RQ90evcA+hq/P9eGFj7ektU=; b=sPT9KSEuVrHDMAVEIZtCH3z/ea
        Efhhe9C5+KN+bkt1/UMwIznj6BAn/49heyXOtd4dUDjjtlNtO9sJG+AeeAsW3bG/cmKIKfn43Buay
        yTD2cfuGzTxl3Qu3Ir5JJ9YKTiH+DUzi0vVJrXYzmbIt5530viG0BMEzYWFOVdklzKDQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oMxxN-00DFHc-NK; Sat, 13 Aug 2022 22:42:05 +0200
Date:   Sat, 13 Aug 2022 22:42:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 07/10] net: dsa: microchip: warn about not
 supported synclko properties on KSZ9893 chips
Message-ID: <YvgMnfSkEeD8jwIG@lunn.ch>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-8-o.rempel@pengutronix.de>
 <20220802113633.73rxlb2kmihivwpx@skbuf>
 <20220805115601.GB10667@pengutronix.de>
 <20220805134234.ps4qfjiachzm7jv4@skbuf>
 <20220813143215.GA12534@pengutronix.de>
 <Yve/MSMc/4klJPFL@lunn.ch>
 <20220813161850.GB12534@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220813161850.GB12534@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 13, 2022 at 06:18:50PM +0200, Oleksij Rempel wrote:
> On Sat, Aug 13, 2022 at 05:11:45PM +0200, Andrew Lunn wrote:
> > On Sat, Aug 13, 2022 at 04:32:15PM +0200, Oleksij Rempel wrote:
> > > On Fri, Aug 05, 2022 at 04:42:34PM +0300, Vladimir Oltean wrote:
> > > > On Fri, Aug 05, 2022 at 01:56:01PM +0200, Oleksij Rempel wrote:
> > > > > Hm, if we will have any random not support OF property in the switch
> > > > > node. We won't be able to warn about it anyway. So, if it is present
> > > > > but not supported, we will just ignore it.
> > > > > 
> > > > > I'll drop this patch.
> > > > 
> > > > To continue, I think the right way to go about this is to edit the
> > > > dt-schema to say that these properties are only applicable to certain
> > > > compatible strings, rather than for all. Then due to the
> > > > "unevaluatedProperties: false", you'd get the warnings you want, at
> > > > validation time.
> > > 
> > > Hm, with "unevaluatedProperties: false" i have no warnings. Even if I
> > > create examples with random strings as properties. Are there some new
> > > json libraries i should use?
> > 
> > Try
> > 
> > additionalProperties: False
> 
> Yes, it works. But in this case I'll do more changes. Just wont to make
> sure I do not fix not broken things.

I've been working on converting some old SoCs bindings from .txt to
.yaml. My observations is that the yaml is sometimes more restrictive
than what the drivers actually imposes. So you might need to change
perfectly working .dts files to get it warning free. Or you just
accept the warnings and move on. At lot will depend on the number of
warnings and how easy it is to see real problems mixed in with
warnings you never intend to fix.

       Andrew

