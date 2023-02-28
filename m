Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6756A5BFD
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjB1Pdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjB1Pdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:33:42 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3CF244B1
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tmcq73IUc4LvXSHBXdbpsMijFb7QY3Bc9LUwZThORHo=; b=HUVWd8hY+zRC9Tt9zGhrYypijy
        5VDSBTWIdQ4EkdpNZ56b0EkVd6xUD48BgFCfGvJhsHtpi6V00pkZDBQUEK453mRcAhSgjwXMb34zw
        gsmQ7BFe/+KZlxCYo/FzJULoHKWUDjMJ3hfB9n84AM1WrQZO9/a4Ilz2kh0o9ANUXuXE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pX1yn-006AaB-L7; Tue, 28 Feb 2023 16:33:25 +0100
Date:   Tue, 28 Feb 2023 16:33:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/4exYkeQF2wOTkD@lunn.ch>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
 <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
 <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
 <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
 <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
 <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The overall default must be PHY, because that is the legacy condition.
> The options to change the default are:
> 
> 1. device tree: Bad because the default is a configuration and does
>    not describe the hardware.

There are also lots of systems which don't use DT, e.g. ACPI, or are
just plain PCI or USB devices which don't have any configuration at
all.

> 2. Kconfig: Override PHY default at compile time.

Per MAC/PHY combination? That does not scale.

> 3. Module Param: Configure default on kernel command line.

Module params are consider bad in the networking stack. DaveM always
NACKs them.

> 4. Letting drivers override PHY at run time.

This is what Russell suggested.

> 5. other?
> 
> It would be possible to support both 2 and 3, with command line having
> the last word.
> 
> I don't like #4 because it would cleaner if every time stamping driver
> would simply implement the internal APIs, without having special hooks
> for various boards.

I agree that stamping drivers should implement the API. All i think
Russell is suggesting is that MAC drivers have an API call they can
make on the PTP core to tell it to direct all calls to the MAC
implementation of the time stamper, not the PHY implementation of the
time stamper. This might need some changes to the internal APIs, such
that all kernel API calls should go through the PTP core, and the PTP
core then directs them by default to the PHY, but on request sends it
to the MAC stamper.

     Andrew
