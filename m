Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616A165F284
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbjAERVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbjAERVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:21:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F052564DC;
        Thu,  5 Jan 2023 09:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LkvD/ZJvz+OVyFnCwIuvp2j0F8+usxn0PTicBH2Ift0=; b=HiifJLxSC8BAU/h5CUbMQdHFzO
        9qxUh6HZFDfYSC5uzDZ/e6vFMNcinBc0vB9ASu7seFz7Ovu+nwsiE8A91FcELJ89uIrb1pqXK6xM8
        AG8rfRGXji+3M0CQh8Gj6TncjjrFX6lNjQynW/iT+MB+jcHsp4AA987r3ZvOBKB5CqWM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pDToP-001Eyg-Et; Thu, 05 Jan 2023 18:13:53 +0100
Date:   Thu, 5 Jan 2023 18:13:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     Md Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Suman Anna <s-anna@ti.com>, YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Message-ID: <Y7cFUW6dFRaI+nPV@lunn.ch>
References: <20221223110930.1337536-1-danishanwar@ti.com>
 <20221223110930.1337536-2-danishanwar@ti.com>
 <Y6W7FNzJEHYt6URg@lunn.ch>
 <620ce8e6-2b40-1322-364a-0099a6e2af26@kernel.org>
 <Y7Mjx8ZEVEcU2mK8@lunn.ch>
 <b55dec4b-4fd5-71fa-4073-b5793cafdee7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b55dec4b-4fd5-71fa-4073-b5793cafdee7@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> On 23/12/2022 16:28, Andrew Lunn wrote:
> >>>> +        ethernet-ports {
> >>>> +            #address-cells = <1>;
> >>>> +            #size-cells = <0>;
> >>>> +            pruss2_emac0: port@0 {
> >>>> +                reg = <0>;
> >>>> +                phy-handle = <&pruss2_eth0_phy>;
> >>>> +                phy-mode = "rgmii-rxid";
> >>>
> >>> That is unusual. Where are the TX delays coming from?
> >>
> >> >From the below property
> >>
> >> +                ti,syscon-rgmii-delay = <&scm_conf 0x4120>;
> >>
> >> The TX delay can be enabled/disabled from within the ICSSG block.
> >>
> >> If this property exists and PHY mode is neither PHY_INTERFACE_MODE_RGMII_ID
> >> nor PHY_INTERFACE_MODE_RGMII_TXID then the internal delay is enabled.
> >>
> >> This logic is in prueth_config_rgmiidelay() function in the introduced driver.
> > 
> > What nearly every other MAC driver does is pass the phy-mode to the
> > PHY and lets the PHY add the delays. I would recommend you do that,
> > rather than be special and different.
> 
> 
> If I remember right we couldn't disable MAC TX delay on some earlier silicon
> so had to take this route. I don't remember why we couldn't disable it though.
> 
> In more recent Silicon Manuals I do see that MAC TX delay can be enabled/disabled.
> If this really is the case then we should change to
> 
>  phy-mode = "rgmii-id";
> 
> And let PHY handle the TX+RX delays.

DT describes the board. PHY mode indicates what delays the board
requires, because the board itself is not performing the delays by
using extra long lines. So typically, phy-mode is rgmii-id, indicating
delays need to be added somewhere in both directions.

Who adds the delays is then between the MAC and the PHY. In most
cases, the MAC does nothing, and passes phy-mode to the PHY and the
PHY does it.

But it is also possible for the MAC to do the delay. So if you cannot
actually disable the TX delay in the MAC, that is O.K. But you need to
modify phy-mode you pass to the PHY to indicate the MAC is doing the
delay, otherwise the PHY will additionally do the delay. So your DT
will contain rgmii-id, because that is what the board requires, but
the MAC will pass rmgii-rxid to the PHY, since that is what the PHY
needs to add.

	Andrew
