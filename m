Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B4652D798
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241027AbiESPct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241017AbiESPcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:32:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051D860ABF;
        Thu, 19 May 2022 08:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RftDzywG3r2aAn9dn2kxlngBMt6wN9yyHzisOWaRAY0=; b=AR+vTJME19UjwVUasj8rGPp7Fr
        8PadH/tNushEB0xq2HqXaHOWK3Jspk3nHeaFivvV4N1HEt/vFhhp/zO5L2ksFNDVBFB0keYF5o40N
        aAyX8U4dwODaCVq8jxZ5OLLTSZ10fD166r+OZo6JMssZztKRB+qracGilTqg9LWALut0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nri8h-003Vd3-Vj; Thu, 19 May 2022 17:32:35 +0200
Date:   Thu, 19 May 2022 17:32:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <jstultz@google.com>,
        Alvin =?utf-8?B?4pS8w6FpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH net 0/2] Make phylink and DSA wait for PHY driver
 that defers probe
Message-ID: <YoZjE77QvIGifDnY@lunn.ch>
References: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
 <Yn72l3O6yI7YstMf@lunn.ch>
 <20220519145936.3ofmmnrehydba7t6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519145936.3ofmmnrehydba7t6@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > There is a very different approach, which might be simpler.
> > 
> > We know polling will always work. And it should be possible to
> > transition between polling and interrupt at any point, so long as the
> > phylock is held. So if you get -EPROBE_DEFFER during probe, mark some
> > state in phydev that there should be an irq, but it is not around yet.
> > When the phy is started, and phylib starts polling, look for the state
> > and try getting the IRQ again. If successful, swap to interrupts, if
> > not, keep polling. Maybe after 60 seconds of polling and trying, give
> > up trying to find the irq and stick with polling.
> 
> That doesn't sound like something that I'd backport to stable kernels.

> What motivates me to make these changes in the first place is the idea
> that current kernels should work with updated device trees.

By current, you mean old kernels, LTS etc. You want an LTS kernel to
work with a new DT blob? You want forward compatibility with a DT
blob. Do the stable rules say anything about that?

      Andrew
