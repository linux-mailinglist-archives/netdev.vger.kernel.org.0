Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C385A252B
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245631AbiHZJy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245430AbiHZJyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:54:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D8B2DC
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 02:54:44 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRW2o-0002pl-EH; Fri, 26 Aug 2022 11:54:30 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRW2n-0002tc-4G; Fri, 26 Aug 2022 11:54:29 +0200
Date:   Fri, 26 Aug 2022 11:54:29 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michael Walle <michael@walle.cc>
Cc:     Divya.Koppera@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Message-ID: <20220826095429.GE2116@pengutronix.de>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
 <20220826084249.1031557-1-michael@walle.cc>
 <CO1PR11MB477162C762EF35B0E115B952E2759@CO1PR11MB4771.namprd11.prod.outlook.com>
 <421712ea840fbe5edffcae4a6cb08150@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <421712ea840fbe5edffcae4a6cb08150@walle.cc>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Aug 26, 2022 at 11:26:12AM +0200, Michael Walle wrote:
> [+ Oleksij Rempel]
> 
> Hi,
> 
> Am 2022-08-26 11:11, schrieb Divya.Koppera@microchip.com:
> > > > Supports SQI(Signal Quality Index) for lan8814 phy, where it has SQI
> > > > index of 0-7 values and this indicator can be used for cable integrity
> > > > diagnostic and investigating other noise sources.
> > > >
> > > > Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> 
> ..
> 
> > > > +#define LAN8814_DCQ_CTRL_CHANNEL_MASK                        GENMASK(1,
> > > 0)
> > > > +#define LAN8814_DCQ_SQI                                      0xe4
> > > > +#define LAN8814_DCQ_SQI_MAX                          7
> > > > +#define LAN8814_DCQ_SQI_VAL_MASK                     GENMASK(3, 1)
> > > > +
> > > >  static int lanphy_read_page_reg(struct phy_device *phydev, int page,
> > > > u32 addr)  {
> > > >       int data;
> > > > @@ -2927,6 +2934,32 @@ static int lan8814_probe(struct phy_device
> > > *phydev)
> > > >       return 0;
> > > >  }
> > > >
> > > > +static int lan8814_get_sqi(struct phy_device *phydev) {
> > > > +     int rc, val;
> > > > +
> > > > +     val = lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_CTRL);
> > > > +     if (val < 0)
> > > > +             return val;
> > > > +
> > > > +     val &= ~LAN8814_DCQ_CTRL_CHANNEL_MASK;
> > > 
> > > I do have a datasheet for this PHY, but it doesn't mention 0xe6 on
> > > EP1.
> > 
> > This register values are present in GPHY hard macro as below
> > 
> > 4.2.225	DCQ Control Register
> > Index (In Decimal):	EP 1.230	Size:	16 bits
> > 
> > Can you give me the name of the datasheet which you are following, so
> > that I'll check and let you know the reason.
> 
> I have the AN4286/DS00004286A ("LAN8804/LAN8814 GPHY Register
> Definitions"). Maybe there is a newer version of it.
> 
> > 
> > > So I can only guess that this "channel mask" is for the 4 rx/tx
> > > pairs on GbE?
> > 
> > Yes channel mask is for wire pair.
> > 
> > > And you only seem to evaluate one of them. Is that the correct thing
> > > to do
> > > here?
> > > 
> > 
> > I found in below link is that, get_SQI returns sqi value for 100 base-t1
> > phy's
> > https://lore.kernel.org/netdev/20200519075200.24631-2-o.rempel@pengutronix.de/T/
> 
> That one is for the 100base-t1 which has only one pair.
> 
> > In lan8814 phy only channel 0 is used for 100base-tx. So returning SQI
> > value for channel 0.
> 
> What if the other pairs are bad? Maybe Oleksij has an opinion here.
> 
> Also 100baseTX (and 10baseT) has two pairs, one for transmitting and one
> for receiving. I guess you meassure the SQI on the receiving side. So is
> channel 0 correct here?
> 
> Again this is the first time I hear about SQI but it puzzles me that
> it only evaluate one pair in this case. So as a user who reads this
> SQI might be misleaded.

Wow! I was so possessed with one-pair networks, that forgot to image
that there is 1000Base-T with more then one pairs :D

Yes, your are right. We wont to have readings from all RX channels and
be able to export them to the user space. In fact, if i see it
correctly, the LAN8814_DCQ_CTRL_CHANNEL_MASK value should be synced with
the MDI-X state. Otherwise we will be reading TX channels.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
