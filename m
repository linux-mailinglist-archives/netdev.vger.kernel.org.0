Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3279269321B
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 16:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBKPuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 10:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBKPuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 10:50:50 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16B619F32;
        Sat, 11 Feb 2023 07:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IW8sOTr1S+sSd3KikWXfhJRwrqiYvg/psbaU5gYSmvw=; b=kNt1d0O96YZekLokKl76hC7t4y
        VsTIUA1XyyIh5f0QoTdh/B4TvJf9smb2E8fotqYho1S143A4JQW4MVfIs1Nh17efmrmr+GekZIIOY
        3H/Dj8aBzbCmNj2lz9e75v3KCaVk4rlTiHi/sxLXravypO1Fg6+Ta1RTYqRhEBlCcumY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pQs99-004hxL-6Z; Sat, 11 Feb 2023 16:50:39 +0100
Date:   Sat, 11 Feb 2023 16:50:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lee Jones <lee@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Advice on MFD-style probing of DSA switch SoCs
Message-ID: <Y+e5TzNRckDADd5d@lunn.ch>
References: <20221222134844.lbzyx5hz7z5n763n@skbuf>
 <4263dc33-0344-16b6-df22-1db9718721b1@linaro.org>
 <20221223134459.6bmiidn4mp6mnggx@skbuf>
 <CAGETcx8De_qm9hVtK5CznfWke9nmOfV8OcvAW6kmwyeb7APr=g@mail.gmail.com>
 <20230211012755.wh4unmkzibdyo4ln@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211012755.wh4unmkzibdyo4ln@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Let's take an absolutely extreme (and hypothetical) example:
> 
>     +--------------------------------+
>     |                                |
>     |     Host SoC running Linux     |
>     |                                |
>     |  +----------+   +----------+   |
>     |  |   MDIO   |   |   ETH    |   |
>     |  |controller|   |controller|   |
>     |  |          |   |  (DSA    |   |
>     |  |          |   | master)  |   |
>     +--+----------+---+----------+---+
>             |              |
>             |              |
>        MDIO |              | ETH
>             |              |
>             v              v
>     +--------------------------------+
>     |                    CPU port    |-------
>     |                                |-------
>     |               MDIO-controller  |-------
>     |  +----------+  DSA switch #1   |------- External
>     |  |   MDIO   |                  |------- ETH
>     |  |controller|                  |------- ports
>     |  |          |                  |-------
>     |  |          |   cascade port   |-------
>     +--+----------+------------------+
>             |       ^      |
>             |       |      |
>        MDIO |   CLK |      | ETH
>             |       |      |
>             v       |      v
>     +--------------------------------+
>     |                 cascade port   |-------
>     |                                |-------
>     |                                |-------
>     |         MDIO-controlled        |------- External
>     |            switch #2           |------- ETH
>     |                                |------- ports
>     |                                |-------
>     |                                |-------
>     +--------------------------------+
> 
> where we have a DSA switch tree with 2 chips, both have their registers
> accessible over MDIO. But chip #1 is accessed through the host's MDIO
> controller, and chip #2 through chip #1's MDIO controller.
> 
> These chips are also going to be used with PTP, and the PTP timers of
> the 2 switches don't feed off of individual oscillators as would be
> usual, but instead, there is a single oscillator feeding into one
> switch, and that switch forwards this as a clock to the other switch
> (because board designers heard it's more trendy this way). So switch #2
> provides a clock to switch #1.
> 
> 
> With the current mainline DSA code structure, assuming a monolithically
> written $vendor driver (as basically N-1 of them are), the above would
> not work under any circumstance.

I'm not sure that is true. The switches probe method should register
with the driver core any resources a switch provides. So switch #1
MDIO bus driver is registered during its probe, allowing the probe of
switch #2 to happen. When switch #2 probes, it should register its
clock with the common clock framework, etc.

However, the linking of resources together, the PTP clock in your
example, should happen in the switches setup() call, which only
happens once all the switches in the cluster have probed, so all the
needed resources should be available.

Because we have these two phases, i think the above setup would work.

	Andrew
