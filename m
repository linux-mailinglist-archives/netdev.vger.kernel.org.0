Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFE1674CDD
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjATFz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjATFzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:55:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F0330F8
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 21:55:22 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pIkMs-0008SL-C0; Fri, 20 Jan 2023 06:55:14 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pIkMs-0000wd-40; Fri, 20 Jan 2023 06:55:14 +0100
Date:   Fri, 20 Jan 2023 06:55:14 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v1 2/4] net: phy: micrel: add EEE configuration
 support for KSZ9477 variants of PHYs
Message-ID: <20230120055514.GI6162@pengutronix.de>
References: <20230119131821.3832456-1-o.rempel@pengutronix.de>
 <20230119131821.3832456-3-o.rempel@pengutronix.de>
 <6a02c93f-e854-bb8e-2172-2c2537f9d800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6a02c93f-e854-bb8e-2172-2c2537f9d800@gmail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 11:25:42AM -0800, Florian Fainelli wrote:
> On 1/19/23 05:18, Oleksij Rempel wrote:
> > KSZ9477 variants of PHYs are not completely compatible with generic
> > phy_ethtool_get/set_eee() handlers. For example MDIO_PCS_EEE_ABLE acts
> > like a mirror of MDIO_AN_EEE_ADV register. If MDIO_AN_EEE_ADV set to 0,
> > MDIO_PCS_EEE_ABLE will be 0 too. It means, if we do
> > "ethtool --set-eee lan2 eee off", we won't be able to enable it again.
> > 
> > With this patch, instead of reading MDIO_PCS_EEE_ABLE register, the
> > driver will provide proper abilities.
> 
> We have hooks in place already for PHY drivers with the form of the read_mmd
> and write_mmd callbacks, did this somehow not work for you?
> 
> Below is an example:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d88fd1b546ff19c8040cfaea76bf16aed1c5a0bb
> 
> (here the register location is non-standard but the bit definitions within
> that register are following the standard).

It will work for this PHY, but not allow to complete support for AR8035.
AR8035 provides support for "SmartEEE" where  tx_lpi_enabled and
tx_lpi_timer are optionally handled by the PHY, not by MAC.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
