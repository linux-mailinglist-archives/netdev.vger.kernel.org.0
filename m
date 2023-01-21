Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE4E67642D
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 07:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjAUGfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 01:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjAUGfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 01:35:00 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0686E407
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 22:34:59 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pJ7Sh-0006Rv-9B; Sat, 21 Jan 2023 07:34:47 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pJ7Sf-00028R-FI; Sat, 21 Jan 2023 07:34:45 +0100
Date:   Sat, 21 Jan 2023 07:34:45 +0100
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
Message-ID: <20230121063445.GK6162@pengutronix.de>
References: <20230119131821.3832456-1-o.rempel@pengutronix.de>
 <20230119131821.3832456-3-o.rempel@pengutronix.de>
 <6a02c93f-e854-bb8e-2172-2c2537f9d800@gmail.com>
 <20230120055514.GI6162@pengutronix.de>
 <c45aa954-0931-1829-459f-8771faf05173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c45aa954-0931-1829-459f-8771faf05173@gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 09:58:05AM -0800, Florian Fainelli wrote:
> 
> 
> On 1/19/2023 9:55 PM, Oleksij Rempel wrote:
> > On Thu, Jan 19, 2023 at 11:25:42AM -0800, Florian Fainelli wrote:
> > > On 1/19/23 05:18, Oleksij Rempel wrote:
> > > > KSZ9477 variants of PHYs are not completely compatible with generic
> > > > phy_ethtool_get/set_eee() handlers. For example MDIO_PCS_EEE_ABLE acts
> > > > like a mirror of MDIO_AN_EEE_ADV register. If MDIO_AN_EEE_ADV set to 0,
> > > > MDIO_PCS_EEE_ABLE will be 0 too. It means, if we do
> > > > "ethtool --set-eee lan2 eee off", we won't be able to enable it again.
> > > > 
> > > > With this patch, instead of reading MDIO_PCS_EEE_ABLE register, the
> > > > driver will provide proper abilities.
> > > 
> > > We have hooks in place already for PHY drivers with the form of the read_mmd
> > > and write_mmd callbacks, did this somehow not work for you?
> > > 
> > > Below is an example:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d88fd1b546ff19c8040cfaea76bf16aed1c5a0bb
> > > 
> > > (here the register location is non-standard but the bit definitions within
> > > that register are following the standard).
> > 
> > It will work for this PHY, but not allow to complete support for AR8035.
> > AR8035 provides support for "SmartEEE" where  tx_lpi_enabled and
> > tx_lpi_timer are optionally handled by the PHY, not by MAC.
> 
> Not sure I understand your reply here, this would appear to be a limitation
> that exists regardless of the current API defined, does that mean that you
> can make use of the phy_driver::{read,write}_mmd function calls and you will
> make a v2 that uses them, or something else entirely?

There are two ways to solve this problem:
- indirect way. Add read/write_mdd filter to catch requests and patch
  them as needed.
- direct way. Introduce PHY specific EEE API and allow drivers to use
  it.

What's with indirect way?
1. Hard to find common pattern within other drivers.
2. It is not obvious for some one, what is going on, without deep diving
   in to documentation.
3. We provide different levels of abstractions not really compatible with
   each other. One part of code thinks we are doing right thing other
   part is trying to fake the answers. It looks and feels wrong.
4. I already tried to mainline driver with for a HW not 100% compatible
   with 802.3 specification, which was faking read/write_mdd answers to
   not supported or broken registers. It was not accepted and it was
   good decision to not doing this.

Direct way:
- clean understandable API.
- It is possible to find common patterns.
- It is possible to support more exotic variants not reflected in the
  802.3 spec.

Now we have a direct way. Yes, it is possible to implement in exact this
driver a read/write_mdd filter, but it is also possible to implement
get/set_eee as well. Why should I implement in this driver the filter
if I already know that next driver will need get/set_eee any way?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
