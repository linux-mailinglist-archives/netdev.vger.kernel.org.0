Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125CB5B87C6
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 14:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiINMDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 08:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiINMD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 08:03:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B252E692;
        Wed, 14 Sep 2022 05:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AGiS0RJTIfvi76lZW3pl+xDVDO1sAPMtoNwFdsbw634=; b=vjqzDyEsUkoDI9FWKQ04N1BR2s
        lD59yHKCy3WGtuA1rDc+Q0YxLU6LluESH/a1B1rKF7jjIl4zL6XTDb1DUlT6qdXEXikhXG3HMTXLJ
        HNykcBcCSnQN9qaBKbb6R5fja2iq16eQKNYD0inuCUT3zrAyI3+Aldk025u4Gul/K7M8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oYR6g-00Gh3A-SF; Wed, 14 Sep 2022 14:03:06 +0200
Date:   Wed, 14 Sep 2022 14:03:06 +0200
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
Subject: Re: [PATCH 3/5] net: ethernet: renesas: Add Ethernet Switch driver
Message-ID: <YyHC+r3uP7s15kny@lunn.ch>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-4-yoshihiro.shimoda.uh@renesas.com>
 <Yx+9OrYDxKjVUutF@lunn.ch>
 <TYBPR01MB5341F0C51EB2EBEF5A7107E7D8469@TYBPR01MB5341.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYBPR01MB5341F0C51EB2EBEF5A7107E7D8469@TYBPR01MB5341.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static void rswitch_adjust_link(struct net_device *ndev)
> > > +{
> > > +	struct rswitch_device *rdev = netdev_priv(ndev);
> > > +	struct phy_device *phydev = ndev->phydev;
> > > +
> > > +	if (phydev->link != rdev->etha->link) {
> > > +		phy_print_status(phydev);
> > > +		rdev->etha->link = phydev->link;
> > > +	}
> > 
> > Given that the SERDES supports 100 and 1G, it seems odd you don't need
> > to do anything here.
> 
> Indeed. However, unfortunately, the current hardware cannot change the speed at runtime...
> So, I'll add such comments here.

Then you need to tell phylib about this. MAC drivers with limitations
often call phy_set_max_speed() to remove higher speeds which the PHY
can support, but the MAC cannot. You need to go further and remove
lower speeds as well. The autoneg in the PHY should then only work for
the speeds you actually support.

> > > +static int rswitch_serdes_common_setting(void __iomem *addr0,
> > > +					 enum rswitch_serdes_mode mode)
> > > +{
> > > +	switch (mode) {
> > > +	case SGMII:
> > > +		rswitch_serdes_write32(addr0, 0x0244, 0x180, 0x97);
> > > +		rswitch_serdes_write32(addr0, 0x01d0, 0x180, 0x60);
> > > +		rswitch_serdes_write32(addr0, 0x01d8, 0x180, 0x2200);
> > > +		rswitch_serdes_write32(addr0, 0x01d4, 0x180, 0);
> > > +		rswitch_serdes_write32(addr0, 0x01e0, 0x180, 0x3d);
> > 
> > Please add #defines for all these magic numbers.
> 
> I should have added comments before though, the datasheet also describes
> such magic numbers like below...
> Step S.4.1	bank 0x180	address = 0x0244		data = 0x00000097
> Step S.4.2	bank 0x180	address = 0x01d0		data = 0x00000060
> ...
> 
> So, perhaps we can define like the followings:
> #define	SERDES_BANK_180		0x180
> 
> #define	SERDES_STEP_S_4_1_ADDR	0x0244
> #define	SERDES_STEP_S_4_1_DATA	0x00000097

Not really any better. Better to comment that you have no idea what
any of this does, it is all black magic.

    Andrew
