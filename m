Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353F06F2026
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 23:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjD1VfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 17:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjD1VfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 17:35:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F636211C
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 14:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=YeyxD+RyeEy4s4tJ6Ldhpq+naLmGe/OeNiOUcWnvoVs=; b=FM
        Bl6mfDGocshtntMcaaI4Bbv1enA30vrqVIBUkcSZObzDWJP+0ku/uZHgiK6IC804f1nS/7lOhTxtf
        7aJXgiJm3b6b6HSTgFjPR5ZOhfr4wni37etE4Nr1gNwcGET9O7HVRg9a8MXrGvAO7ftbdioWNJJTY
        +4kWleQo34sfLqA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1psVkJ-00BSgP-Ia; Fri, 28 Apr 2023 23:35:15 +0200
Date:   Fri, 28 Apr 2023 23:35:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andreas =?iso-8859-1?Q?B=F6hler?= <news@aboehler.at>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: SFP: Copper module with different PHY address (Netgear AGM734)
Message-ID: <fe679ff2-0feb-4f96-a8a5-0c6acfa9f440@lunn.ch>
References: <d57b4fcd-2fa6-bc92-0650-72530fbdc0a8@aboehler.at>
 <d4d526db-995b-4426-8a8d-b53acceb5f74@lunn.ch>
 <e9a859b0-c1da-0f65-b02e-fbf3aa297286@aboehler.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9a859b0-c1da-0f65-b02e-fbf3aa297286@aboehler.at>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 10:15:55PM +0200, Andreas Böhler wrote:
> Hi,
> thanks for the quick reply!
> 
> On 26/04/2023 19:04, Andrew Lunn wrote:
> > On Wed, Apr 26, 2023 at 06:47:33PM +0200, Andreas Böhler wrote:
> > > Hi,
> > > 
> > > I have a bunch of Netgear AGM734 copper SFP modules that I would like to use
> > > with my switches. Upon insertion, a message "no PHY detected" pops up.
> > > 
> > > Upon further investigation I found out that the Marvell PHY in these modules
> > > is at 0x53 and not at the expected 0x56. A quick check with a changed
> > > SFP_PHY_ADDR works as expected.
> > > 
> > > Which is the best scenario to proceed?
> > > 
> > > 1. Always probe SFP_PHY_ADDR and SFP_PHY_ADDR - 3
> > > 
> > > 2. Create a fixup for this specific module to probe at a different address.
> > > However, I'm afraid this might break "compatible" modules.
> > > 
> > > 3. Something else?
> > 
> > 
> > What does ethtool -m show?
> 
> Offset          Values
> ------          ------
> 0x0000:         03 04 00 00 00 00 08 00 00 00 00 01 0d 00 00 00
> 0x0010:         00 00 64 00 4e 45 54 47 45 41 52 20 20 20 20 20
> 0x0020:         20 20 20 20 00 00 09 5b 41 47 4d 37 33 34 20 20
> 0x0030:         20 20 20 20 20 20 20 20 30 30 30 30 00 00 00 7e
> 0x0040:         00 01 00 00 31 38 31 36 30 34 31 30 30 33 34 37
> 0x0050:         20 20 20 20 31 38 30 34 32 35 30 31 00 00 00 79
> 0x0060:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x0070:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x0080:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x0090:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00a0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00b0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00c0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00d0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00e0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00f0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

It looks like you ethtool is either old, or not build to decode the
contents of the eeprom:

ethtool -m eth42
        Identifier                                : 0x02 (module soldered to motherboard)
        Extended identifier                       : 0x04 (GBIC/SFP defined by 2-wire interface ID)
        Connector                                 : 0x07 (LC)
        Transceiver codes                         : 0x04 0x00 0x00 0x02 0x12 0x00 0x01 0xf5 0x00
        Transceiver type                          : Infiniband: 1X LX
        Transceiver type                          : Ethernet: 1000BASE-LX
        Transceiver type                          : FC: long distance (L)
        Transceiver type                          : FC: Longwave laser (LC)
        Transceiver type                          : FC: Single Mode (SM)
        Transceiver type                          : FC: 1200 MBytes/sec
        Transceiver type                          : FC: 800 MBytes/sec
...
        Vendor name                               : COTSWORKS
        Vendor OUI                                : 00:00:00
        Vendor PN                                 : SFBG53DRAP
        Vendor rev                                : 0000

> > Is there something we a key a quirk off?
> 
> Unfortunately, I don't understand this sentence.

The EEPROM contains vendor name and product number. We enable quirks
based on those, so they apply to specific SFPs.

If i'm reading your hex correctly, it says: `NETGEAR` and `AGM734`

Take a look at the quirk for rollball. You can add a new
sfp->mdio_protocol which indicates a different address should be used.

> > Is it a true Netgear SFP?
> 
> Yes, it's a brand new original Netgear module.
> 
> > There are OEMs which will load there EEPROM to emulate other
> > vendors. e.g.:
> 
> Yes, this is what I meant with a quirk might break "compatible" modules.

Then they are not compatible :-)

The real problem here is that the standards don't actually say how you
are supposed to talk to the PHY. The address and the protocol is
undefined.

     Andrew
