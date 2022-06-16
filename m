Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E74054DE3F
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 11:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359691AbiFPJfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 05:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiFPJfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 05:35:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED2235876
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 02:34:59 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o1ltt-00071U-Dp; Thu, 16 Jun 2022 11:34:53 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o1lts-00035k-0K; Thu, 16 Jun 2022 11:34:52 +0200
Date:   Thu, 16 Jun 2022 11:34:51 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: phy: add remote fault support
Message-ID: <20220616093451.GA28995@pengutronix.de>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
 <YqS+zYHf6eHMWJlD@lunn.ch>
 <20220613125552.GA4536@pengutronix.de>
 <YqdQJepq3Klvr5n5@lunn.ch>
 <20220614185221.79983e9b@kernel.org>
 <YqlUCtJhR1Iw3o3F@lunn.ch>
 <20220614220948.5f0b4827@kernel.org>
 <Yqo8BuxL+XKw8U+a@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yqo8BuxL+XKw8U+a@lunn.ch>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 10:07:34PM +0200, Andrew Lunn wrote:
> On Tue, Jun 14, 2022 at 10:09:48PM -0700, Jakub Kicinski wrote:
> > On Wed, 15 Jun 2022 05:37:46 +0200 Andrew Lunn wrote:
> > > > Does this dovetail well with ETHTOOL_A_LINKSTATE_EXT_STATE /
> > > > ETHTOOL_A_LINKSTATE_EXT_SUBSTATE ?
> > > > 
> > > > That's where people who read extended link state out of FW put it
> > > > (and therefore it's read only now).  
> > > 
> > > I did wonder about that. But this is to do with autoneg which is part
> > > of ksetting. Firmware hindered MAC drivers also support ksetting
> > > set/get.  This patchset is also opening the door to more information
> > > which is passed via autoneg. It can also contain the ID the link peer
> > > PHY, etc. This is all part of 802.3, where as
> > > ETHTOOL_A_LINKSTATE_EXT_STATE tends to be whatever the firmware
> > > offers, not something covered by a standard.
> > 
> > I see, yeah, I think you're right.
> > 
> > But I'm missing the bigger picture. I'm unclear on who is supposed 
> > to be setting the fault user space or kernel / device?
> 
> It is also a bit unclear, but at the moment, i think user
> space. However, i can see the kernel making use of maybe RF TEST to
> ask the link peer to go quiet in order to perform a cable test.
> 
> Oleksij, what are your use cases?

Currently I was thinking only about diagnostic:
- request transmit pause for cable testing
- request remote loopback for selftest. In this case I will need to use
  vendor specific NextPage to request something like this.

> Maybe add something to patch 0/X indicating how you plan to make use of this?

I can move it from first patch if needed.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
