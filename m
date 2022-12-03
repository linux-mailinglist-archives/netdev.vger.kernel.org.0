Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8044064181C
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 18:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiLCR3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 12:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiLCR26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 12:28:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2B47655;
        Sat,  3 Dec 2022 09:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kf0+FnqxropjT26w5i+R6Mn69hvc/cFGBm10OXyOzQk=; b=Ohj/2JvCsat4UCmFfnUSqfDfsd
        mmrqd00lvsHwnVdPQztHXTrVIjoYI1p0YlnfOG7NeeN1lwgfgfY8OdcSSmsVIWs5fKLdZNWctxvMJ
        L3Ot4Hl0s3AytEVxAPcNgn4p+EFoIrngaKH9NgcC9T5pywnBajeIfgDUwhWWinNhWcfI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1WIw-004HN1-V1; Sat, 03 Dec 2022 18:27:58 +0100
Date:   Sat, 3 Dec 2022 18:27:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chukun Pan <amadeus@jmu.edu.cn>
Cc:     heiko@sntech.de, alexandre.torgue@foss.st.com, davem@davemloft.net,
        david.wu@rock-chips.com, devicetree@vger.kernel.org,
        edumazet@google.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, krzysztof.kozlowski@linaro.org,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, peppe.cavallaro@st.com, robh+dt@kernel.org
Subject: Re: Re: [PATCH 1/2] dt-bindings: net: rockchip-dwmac: add rk3568
 xpcs compatible
Message-ID: <Y4uHHiLxSw1sMcTz@lunn.ch>
References: <3689593.Mh6RI2rZIc@diego>
 <20221203090015.16132-1-amadeus@jmu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221203090015.16132-1-amadeus@jmu.edu.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 03, 2022 at 05:00:15PM +0800, Chukun Pan wrote:
> > Actually looking deeper in the TRM, having these registers "just" written
> > to from the dwmac-glue-layer feels quite a bit like a hack.
> 
> > The "pcs" thingy referenced in patch2 actually looks more like a real device
> > with its own section in the TRM and own iomem area. This pcs device then
> > itself has some more settings stored in said pipe-grf.
> 
> > So this looks more like it wants to be an actual phy-driver.
> 
> > @Chukun Pan: plase take a look at something like
> > https://elixir.bootlin.com/linux/latest/source/drivers/phy/mscc/phy-ocelot-serdes.c#L398
> > on how phy-drivers for ethernets could look like.
> 
> > Aquiring such a phy from the dwmac-glue and calling phy_set_mode after
> > moving the xpcs_setup to a phy-driver shouldn't be too hard I think.
> 
> Thanks for pointing that out.
> The patch2 is come from the sdk kernel of rockchip.
> The sgmii-phy of RK3568 is designed on nanning combo phy.
> In the sdk kernel, if we want to use sgmii mode, we need
> to modify the device tree in the gmac section like this:
> 
> ```
> &gmac0 {
> 	power-domains = <&power RK3568_PD_PIPE>;
> 	phys = <&combphy1_usq PHY_TYPE_SGMII>;
> 	phy-handle = <&sgmii_phy>;
> 	phy-mode = "sgmii";

phy-mode tells you you are using SGMII. You can tell the generic PHY
driver this which will call the PHY drivers .set_mode().

As said above, there are plenty of examples of this, mvneta and its
comphy, various mscc drivers etc.

	Andrew
