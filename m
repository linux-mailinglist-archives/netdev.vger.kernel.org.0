Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB46C4D75F1
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 15:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbiCMOx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 10:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiCMOxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 10:53:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3663D8879A;
        Sun, 13 Mar 2022 07:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SYLJecFzMoXae9Yd63DSIRQsBWaqYrsKU+5452Z4zcQ=; b=AECFhEzbz4hZ9WbIJVzXpFpbKH
        kidJPcYSinNrYvzgsSMIytPZjpRanYKa7XnHlYUxM2QtD/A3TK2LpQKi5q7PNg+mlwYh2LfC5Vvqu
        JX55NxICbc6nzjMLUm/evTnRuIp+a0JiiPdOqBuzUxuwWax+z5zkCZuSpZgo0f2lmsGA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nTPZs-00AdA3-1f; Sun, 13 Mar 2022 15:52:12 +0100
Date:   Sun, 13 Mar 2022 15:52:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: mdio: mscc-miim: replace magic numbers
 for the bus reset
Message-ID: <Yi4FHDz+ya8VZZDq@lunn.ch>
References: <20220313002153.11280-1-michael@walle.cc>
 <20220313002153.11280-3-michael@walle.cc>
 <Yi1ALN6hN9aV1VrA@lunn.ch>
 <7cbe529d46c64b01eb99c016d9f16f1a@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cbe529d46c64b01eb99c016d9f16f1a@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 13, 2022 at 02:17:55AM +0100, Michael Walle wrote:
> Am 2022-03-13 01:51, schrieb Andrew Lunn:
> > > diff --git a/drivers/net/mdio/mdio-mscc-miim.c
> > > b/drivers/net/mdio/mdio-mscc-miim.c
> > > index 64fb76c1e395..7773d5019e66 100644
> > > --- a/drivers/net/mdio/mdio-mscc-miim.c
> > > +++ b/drivers/net/mdio/mdio-mscc-miim.c
> > > @@ -158,18 +158,18 @@ static int mscc_miim_reset(struct mii_bus *bus)
> > >  {
> > >  	struct mscc_miim_dev *miim = bus->priv;
> > >  	int offset = miim->phy_reset_offset;
> > > +	int mask = PHY_CFG_PHY_ENA | PHY_CFG_PHY_COMMON_RESET |
> > > +		   PHY_CFG_PHY_RESET;
> > 
> > > -		ret = regmap_write(miim->phy_regs,
> > > -				   MSCC_PHY_REG_PHY_CFG + offset, 0x1ff);
> > > +		ret = regmap_write(miim->phy_regs, offset, mask);
> > 
> > Is mask the correct name? It is not being used in the typical way for
> > a mask.
> 
> It is the mask of all the reset bits, see also patch 3/3. Either all
> these bits are set or none.

Yes, it is you just don't use it in the typical way for a mask

	foo = bar & mask;

The name mask made me look for a read-modify-write or similar. And
that then makes me thing of race conditions.

> Do you haave any suggestion?

value everywhere? Or phy_reset_bits?

      Andrew
