Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3795B87F5
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 14:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiINMOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 08:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiINMOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 08:14:34 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2FA630F;
        Wed, 14 Sep 2022 05:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tz87bZTZSZXeu56QgGABqxUheVY7VP5s9XkP94bRNEg=; b=JbFV4/W60NL52zgyPeWN5DL1j1
        H541VPkVSdhCO4CFCjolpMSnqt2SgWo1DmCwkL5Y7+PgqTV5fPLgBsW42LCnDigzwrVkAQq4gbSso
        fVmP83WrNIVCy0g05a97L7rdPT9GsXVlJ/qA5lRL7r7E01FvwhTi5sCKrP/ai2g27jX4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oYRHZ-00Gh8O-Ms; Wed, 14 Sep 2022 14:14:21 +0200
Date:   Wed, 14 Sep 2022 14:14:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH 5/5] arm64: dts: renesas: r8a779f0: spider: Enable
 Ethernet Switch
Message-ID: <YyHFnZdGTJL8uLxn@lunn.ch>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-6-yoshihiro.shimoda.uh@renesas.com>
 <Yx/L1VeVmR/QAErf@lunn.ch>
 <TYBPR01MB53414B8CA1157760148FACB9D8469@TYBPR01MB5341.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYBPR01MB53414B8CA1157760148FACB9D8469@TYBPR01MB5341.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +		port@2 {
> > > +			reg = <2>;
> > > +			phy-handle = <&etha2>;
> > > +			phy-mode = "sgmii";
> > > +			#address-cells = <1>;
> > > +			#size-cells = <0>;
> > > +			etha2: ethernet-phy@2 {
> > > +				reg = <3>;
> > > +				compatible = "ethernet-phy-ieee802.3-c45";
> > > +			};
> > > +		};
> > 
> > I find it interesting you have PHYs are address 1, 2, 3, even though
> > they are on individual busses. Why pay for the extra pullup/down
> > resistors when they could all have the same address?
> 
> I don't know why. But, the board really configured such PHY addresses...

That is not wrong. It could be the hardware engineer is used to shared
MDIO busses, and just copy/pasted an existing design, but then
separated the busses?

You might see actual customer boards putting all the PHYs on one MDIO
bus, to save pins. Linux has no problem with that, the phy-handle can
point anywhere.

One last thought. Is there anything in the data sheet about the switch
hardware directly talking the PHY? Some of the Marvell switches can do
that, but we disable that feature. The hardware has no idea what the
PHY driver is doing, such as selecting different pages.

	  Andrew
