Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F270A511B47
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbiD0My0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbiD0MyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:54:25 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78DD1BA79F;
        Wed, 27 Apr 2022 05:51:13 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 2224E1030E54B;
        Wed, 27 Apr 2022 14:51:11 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id EED221191E9; Wed, 27 Apr 2022 14:51:10 +0200 (CEST)
Date:   Wed, 27 Apr 2022 14:51:10 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 6/7] net: phy: smsc: Cache interrupt mask
Message-ID: <20220427125110.GA7941@wunner.de>
References: <cover.1651037513.git.lukas@wunner.de>
 <7603f74ddc32bbaa55e9f1bea5d4024b6e376035.1651037513.git.lukas@wunner.de>
 <Ymkzno2IbyNbFrEL@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymkzno2IbyNbFrEL@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 02:14:22PM +0200, Andrew Lunn wrote:
> On Wed, Apr 27, 2022 at 07:48:06AM +0200, Lukas Wunner wrote:
> > Cache the interrupt mask to avoid re-reading it from the PHY upon every
> > interrupt.  The PHY may be located on a USB device, so the additional
> > read may unnecessarily increase interrupt overhead and latency.
> 
> I don't think your justification is valid. The MDIO bus is clocked at
> 2.5MHz. So even if you are using USB 1.1 at 12MHz, the USB overheads
> are not particularly large. At 480Mbps they are pretty insignificant.
> 
> In general, we consider PHYs as slow devices, they take over 1 second
> to negotiate a link and declare it up. So we don't do this sort of
> micro optimization.
> 
> What i think is relevant here is that you could have an interrupt
> storm going on because you don't mask interrupts? It is not a true
> storm, due to the way USB works, more of a light shower. Do you have
> any statistics to show this code actually reduces the amount of rain
> in a significant way?

TBH the primary motivation for this change is that it simplifies the
succeeding commit ("Cope with hot-removal in interrupt handler").

Additionally it seemed silly to me to re-read the interrupt mask
every time for no reason at all.  To test and debug this series
I logged every MDIO read/write and these nonsensical transactions
are very visible and very annoying in the log output.

So yeah, maybe the latency argument isn't very strong, but there
are other arguments which I didn't deem necessary mentioning in
the commit message as they seemed somewhat egotistical. :)

Thanks,

Lukas
