Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8636F139A
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345618AbjD1IwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345584AbjD1IwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:52:05 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE1F46A0
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 01:51:44 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D19A1C0008;
        Fri, 28 Apr 2023 08:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1682671902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LsYkDKocLqObzGNyM2BVZWDmmQfdDRJ/4qej5bYtW4Y=;
        b=Fnj09Gsmn/AUvtq3eZbydQ7ZcHbGXo02ByfnlkPtglHcIYrahi/6f9wo8K1eDQRSg4JNvo
        T4aYA/deEjkcwAUnPdeZeRIr93Qg91AM3DmLtJT4Le30Q5pC38vrH/cLpa1UrJPd/DSo7W
        FwDxD2QWi6YgfD5K763CF75zFIC5oLvjmbIFZiTFhGRbXItxa+Ir5+Q7mrylh01OEjEX2O
        CVzROcl8be5WnrD5S+xWlLXcKoHckmdo9lEcQYCnVh1WOqJzuWIAqkXpz51G4cO3e3Is6q
        DbCIdfkSzbukk2PsGDW+dg/vL4efOrN5+5D8xhakWqR8jQ+RVSJ0kL6EhztNHA==
Date:   Fri, 28 Apr 2023 10:51:40 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, richardcochran@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230428105140.1710c1fc@kmaincent-XPS-13-7390>
In-Reply-To: <8ad8c6ce-1a3e-4f80-84c8-d6921613cbb9@lunn.ch>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
        <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
        <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
        <20230427171306.2bfd824a@kmaincent-XPS-13-7390>
        <8ad8c6ce-1a3e-4f80-84c8-d6921613cbb9@lunn.ch>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Apr 2023 18:50:47 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > As we are currently moving forward on PTP core to resolve this issue, I
> > would like to investigate your PHY PTP patch in parallel. Indeed it does
> > not work very well on my side.
> > 
> > The PTP UDP v4 and v6 work only if I add "--tx_timestamp_timeout 20" and the
> > PTP IEEE 802.3 (802.1AS) does not work at all.
> > On PTP IEEE 802.3 network transport ("ptp4l -2") I get continuously rx
> > timestamp overrun:
> > Marvell 88E1510 ff0d0000.ethernet-ffffffff:01: rx timestamp overrun (5)
> > Marvell 88E1510 ff0d0000.ethernet-ffffffff:01: rx timestamp overrun (5)
> > 
> > I know it's been a long time but does it ring a bell on your memory?  
> 
> How are you talking to the PHY? I had issues with slow MDIO busses,
> especially those embedded within an Ethernet switch. You end up with
> MDIO over MDIO which has a lot of latency. I _think_ i added some
> patches to ptp4l to deal with this, but i forget exactly what landed.

I am talking to the PHY through a simple MDIO bus.
The current PTP support from Russell does not support interrupts. Could it be
the cause of needing bigger tx timestamp timeout? 
