Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183A5BF42C
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfIZNiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:38:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39070 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfIZNiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 09:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YcsqfYdXrRbMSIDyM+a78oLZNTIc6tel5NswvkDTZOs=; b=LlsBQVq9RDNS6SsGUcKJU9FQ1z
        j2EnMXmtSr7H3H4IjwvGIJ9gdbz2BbXALYZic1Sr8hRCzGCbkc9Efxk3XXhre6bHMnCA/VoDO1KFN
        OiDlgMlsHZEGqSyntiJbYe4ls3F3L73i5z3bJ0kH1h/msOXjAC/fVxOqVEdckB9/3rnw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iDTyE-0002b9-2O; Thu, 26 Sep 2019 15:38:10 +0200
Date:   Thu, 26 Sep 2019 15:38:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zoran Stojsavljevic <zoran.stojsavljevic@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA driver kernel extension for dsa mv88e6190 switch
Message-ID: <20190926133810.GD20927@lunn.ch>
References: <CAGAf8LzeyrMSHCYMxn1FNtMQVyhhLYbJaczhe2AMj+7T_nBt7Q@mail.gmail.com>
 <20190923191713.GB28770@lunn.ch>
 <CAGAf8LyQpi_R-A2Zx72bJhSBqnFo-r=KCnfVCTD9N8cNNtbhrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGAf8LyQpi_R-A2Zx72bJhSBqnFo-r=KCnfVCTD9N8cNNtbhrQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 03:23:48PM +0200, Zoran Stojsavljevic wrote:
> Hello Andrew,
> 
> I would like to thank you for the reply.
> 
> I do not know if this is the right place to post such the questions,
> but my best guess is: yes.
> 
> Since till now I did not make any success to make (using DSA driver)
> make mv88e6190 single switch to work with any kernel.org. :-(
> 
> I did ugly workaround as kernel dsa patch, which allowed me to
> introduce TXC and RXC clock skews between I.MX6 and mv88e6190 (MAC to
> MAC layer over rgmii).

You should not need any kernel patches for switch side RGMII
delays. rgmii-id in the DT for the switch CPU port should be enough.
Some of the vf610-zii platforms use it.

> My DTS mv88e6190 configuration, which I adopted for the custom board I
> am working on, could be seen here:
> https://pastebin.com/xpXQYNRX

So you have the FEC using rgmii-id. Which you say does not work?  So
why not use plain rgmii. What you have in port@0 looks correct.

gpios = <&gpio1 29 GPIO_ACTIVE_HIGH>; is wrong. It probably should be
reset-gpios. The rest looks O.K.

 
> But on another note... I am wondering if I am setting correct kernel
> configuration for it?!
> 
> Here is the part of the configuration I made while going through maze
> of posts from google search results:
> 
>       Switch (and switch-ish) device support @ Networking
> support->Networking options
>       Distributed Switch Architecture @ Networking support->Networking options
>       Tag driver for Marvell switches using DSA headers @ Networking
> support->Networking options->Distributed Switch Architecture
>       Tag driver for Marvell switches using EtherType DSA headers @
> Networking support->Networking options->Distributed Switch
> Architecture
>       Marvell 88E6xxx Ethernet switch fabric support @ Device
> Drivers->Network device support->Distributed Switch Architecture
> drivers
>       Switch Global 2 Registers support @ Device Drivers->Network
> device support->Distributed Switch Architecture drivers->Marvell
> 88E6xxx Ethernet switch fabric support
>       Freescale devices @ Device Drivers->Network device
> support->Ethernet driver support
>       FEC ethernet controller (of ColdFire and some i.MX CPUs) @
> Device Drivers->Network device support->Ethernet driver
> support->Freescale devices
>       Marvell devices @ Device Drivers->Network device
> support->Ethernet driver support
>       Marvell MDIO interface support @ Device Drivers->Network device
> support->Ethernet driver support->Marvell devices
>       MDIO Bus/PHY emulation with fixed speed/link PHYs @ Device
> Drivers->Network device support->PHY Device support and infrastructure
> 
> (Do we need Marvell PHYs option as =y ? I do not think so - should be:
> is not set)

Yes you do. The PHYs inside the switch are Marvell.
 
> What possibly I made wrong here (this does not work - I could not get
> through the switch, and seems that MDIO works (from the logic
> analyzer), but addresses some 0x1B/0x1C ports, which should NOT be
> addressed, according to the the DTS configuration shown)?

0x1b is global1, and 0x1c is global2. These are registers shared by
all ports.

Please show me the configuration steps you are doing? How are you
configuring the FEC and the switch interfaces?

    Andrew
