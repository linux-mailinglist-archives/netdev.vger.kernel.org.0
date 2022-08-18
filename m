Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686C1598730
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245440AbiHRPO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344222AbiHRPOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:14:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56816EF03
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tCrz5cEj0POQ7f5kEcupj32rJt9SS2YPe/6PL0Njfjs=; b=MI+8YA/BTOxc/7IJ+AZgSebtNV
        DDPlZnKAIrFsrhaxSEl4WW+sT29sm/AzxVIElTpHnUjYKayfoWfHDgfuWe5DEGp2A+H/dVzFM468Z
        UwTI4mZprdnYIzNx+QBck18Q90aOuWFyzcYT+NrRTbgtcVDtIIHZ12giubLnyS78q9D0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOhDU-00Dl9S-0j; Thu, 18 Aug 2022 17:13:52 +0200
Date:   Thu, 18 Aug 2022 17:13:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Craig McQueen <craig@mcqueen.id.au>
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Message-ID: <Yv5XL4KTLxukVhck@lunn.ch>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It is important to note that phy_device_create() initializes
> dev->interface = PHY_INTERFACE_MODE_GMII, and so, when we use
> phylink_create(PHY_INTERFACE_MODE_NA), no one will override this, and we
> will end up with a PHY_INTERFACE_MODE_GMII interface inherited from the
> PHY.

Is this actually a bug?

With pure phylib, you should call one of the connect functions, which
underneath calls phy_attach_direct() which has a phy_interface_t. So
the default in practice does not matter.

> All this means that in order to maintain compatibility with device tree
> blobs where the phy-mode property is missing, we need to allow the
> "gmii" phy-mode and treat it as "internal".

of_get_phy_mode() returns PHY_INTERFACE_MODE_NA if the property is
missing, which also suggests this is a bug.

I wonder if we have any ports which actually rely on
PHY_INTERFACE_MODE_GMII?

	 Andrew

