Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E2955249D
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 21:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbiFTTd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 15:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiFTTdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 15:33:22 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07BA1C128;
        Mon, 20 Jun 2022 12:33:20 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id DAFE3100D9414;
        Mon, 20 Jun 2022 21:33:18 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B0E9D8943BB; Mon, 20 Jun 2022 21:33:18 +0200 (CEST)
Date:   Mon, 20 Jun 2022 21:33:18 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Simon Han <z.han@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH net] net: phy: smsc: Disable Energy Detect Power-Down in
 interrupt mode
Message-ID: <20220620193318.GA15322@wunner.de>
References: <439a3f3168c2f9d44b5fd9bb8d2b551711316be6.1655714438.git.lukas@wunner.de>
 <c40cc5fb-a84d-23f2-a400-c01b5b419bc9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c40cc5fb-a84d-23f2-a400-c01b5b419bc9@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 10:03:26AM -0700, Florian Fainelli wrote:
> On 6/20/22 04:04, Lukas Wunner wrote:
> > --- a/drivers/net/phy/smsc.c
> > +++ b/drivers/net/phy/smsc.c
> > @@ -110,7 +110,7 @@ static int smsc_phy_config_init(struct phy_device *phydev)
> >   	struct smsc_phy_priv *priv = phydev->priv;
> >   	int rc;
> > -	if (!priv->energy_enable)
> > +	if (!priv->energy_enable || phydev->irq != PHY_POLL)
> 
> phy_interrupt_is_valid() may be more appropriate, since you are assuming
> that you either have PHY_POLL or valid "external" PHY interrupt but there is
> also the special case of PHY_MAC_INTERRUPT that is not dealt with.

I deliberately disable EDPD for PHY_MAC_INTERRUPT as well.

That's a proper interrupt, i.e. the PHY signals interrupts
to the MAC (e.g. through an interrupt pin on the MAC),
which forwards the interrupts to phylib.  EDPD cannot
be used in that situation either.


> > @@ -217,7 +219,7 @@ static int lan87xx_read_status(struct phy_device *phydev)
> >   	int err = genphy_read_status(phydev);
> > -	if (!phydev->link && priv->energy_enable) {
> > +	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
> 
> phy_polling_mode()?

Personally I think checking for PHY_POLL is succinct,
but if you or anyone else feels strongly about it
I'll be happy to add such a static inline to
include/linux/phy.h.

Thanks,

Lukas
