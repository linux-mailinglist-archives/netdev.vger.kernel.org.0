Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288285F144F
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 23:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiI3VFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 17:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiI3VFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 17:05:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031AF6B667;
        Fri, 30 Sep 2022 14:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=J7qo4tcoHbVRsdIYi1Di3dH/rrrUnpIwqYQdQ0vvc30=; b=R5
        BKZgAm0Po2B4VOa5Rx+nxz4ihBAVMavypemu8I9EQPWQukHPiRLXnjw5FHV7MROcC8jzPfa7cycIc
        izyBhb+HOZNCpkIVLZURbB+dhiOS/2u0tAvy1WV5rP8V7fB8HKU5M/oi5Y48Qsv6doMyH0ehTLXwc
        7siYiz614w77Mp4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oeNBy-000kEO-C0; Fri, 30 Sep 2022 23:05:06 +0200
Date:   Fri, 30 Sep 2022 23:05:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yangfl <mmyangfl@gmail.com>
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mv643xx_eth: support MII/GMII/RGMII modes
Message-ID: <YzdaAlg77SyrgjE3@lunn.ch>
References: <20220930194923.954551-1-mmyangfl@gmail.com>
 <YzdRdC1qgZY+8gQk@lunn.ch>
 <CAAXyoMNmf7YMPZYqimxJMo6W=Z-zMXHE9TjnB-SYNnpit8RV4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAXyoMNmf7YMPZYqimxJMo6W=Z-zMXHE9TjnB-SYNnpit8RV4g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 01, 2022 at 04:47:42AM +0800, Yangfl wrote:
> Andrew Lunn <andrew@lunn.ch> 于2022年10月1日周六 04:28写道：
> >
> > On Sat, Oct 01, 2022 at 03:49:23AM +0800, David Yang wrote:
> > > On device reset all ports are automatically set to RGMII mode. MII
> > > mode must be explicitly enabled.
> > >
> > > If SoC has two Ethernet controllers, by setting both of them into MII
> > > mode, the first controller enters GMII mode, while the second
> > > controller is effectively disabled. This requires configuring (and
> > > maybe enabling) the second controller in the device tree, even though
> > > it cannot be used.
> > >
> > > Signed-off-by: David Yang <mmyangfl@gmail.com>
> > > ---
> > >  drivers/net/ethernet/marvell/mv643xx_eth.c | 16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
> > > index b6be0552a..e2216ce5e 100644
> > > --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> > > +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> > > @@ -108,6 +108,7 @@ static char mv643xx_eth_driver_version[] = "1.4";
> > >  #define TXQ_COMMAND                  0x0048
> > >  #define TXQ_FIX_PRIO_CONF            0x004c
> > >  #define PORT_SERIAL_CONTROL1         0x004c
> > > +#define  RGMII_EN                    0x00000008
> > >  #define  CLK125_BYPASS_EN            0x00000010
> > >  #define TX_BW_RATE                   0x0050
> > >  #define TX_BW_MTU                    0x0058
> > > @@ -1245,6 +1246,21 @@ static void mv643xx_eth_adjust_link(struct net_device *dev)
> > >
> > >  out_write:
> > >       wrlp(mp, PORT_SERIAL_CONTROL, pscr);
> > > +
> > > +     /* If two Ethernet controllers present in the SoC, MII modes follow the
> > > +      * following matrix:
> > > +      *
> > > +      * Port0 Mode   Port1 Mode      Port0 RGMII_EN  Port1 RGMII_EN
> > > +      * RGMII        RGMII           1               1
> > > +      * RGMII        MII/MMII        1               0
> > > +      * MII/MMII     RGMII           0               1
> > > +      * GMII         N/A             0               0
> > > +      *
> > > +      * To enable GMII on Port 0, Port 1 must also disable RGMII_EN too.
> > > +      */
> > > +     if (!phy_interface_is_rgmii(dev->phydev))
> > > +             wrlp(mp, PORT_SERIAL_CONTROL1,
> > > +                  rdlp(mp, PORT_SERIAL_CONTROL1) & ~RGMII_EN);
> >
> > I could be reading this wrong, but doesn't this break the third line:
> >
> > > +      * MII/MMII     RGMII           0               1
> >
> > Port 1 probes first, phy_interface is rgmii, so nothing happens, port1
> > RGMII_EN is left true.
> >
> > Port 0 then probes, MII/MMII is not RGMII, so port1 RGMII_EN is
> > cleared, breaking port1.
> >
> > I think you need to be more specific with the comparison.
> >
> >   Andrew
> 
> Oh, I see. So you mean "phy-mode" property should belong to
> controller, not port? I thought one controller can have at most one
> port.

If you look at mv643xx_eth_shared_of_probe(), it appears a controller
can have multiple ports. And:

        if (dev_num == 3) {
                dev_err(&pdev->dev, "too many ports registered\n");
                return -EINVAL;
        }

I don't know the details?

	Andrew



