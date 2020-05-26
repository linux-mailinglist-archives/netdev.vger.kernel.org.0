Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E780C1E254F
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgEZPVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbgEZPVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:21:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E64BC03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=De3WiELNUugEoC/dk6ZOZJqilC5OH2qQmhMugLmVNM8=; b=C5OxeFs8a0W5nKAQdvbLtVzLk
        b3jiqfvgpX1C+oV0rQ+jBkRmmAQM5l2cFNDZhb8xmq1xE8RPoXz6KefpJyhCBGzsJuAOg1Digzy9f
        mtq8rcxgkLZWNCieUsefnQbZ0/hxpwzaEJEtvZuTRy4wWCKbmnKcAs8j0C65O7zg4vZq5tjP5mB/g
        cyx7nWwvHZYHKFD30rQiAV1jXLO5zcMFAavJe4Dya7Z3S/T3/zY1DWCeghyUM7/TcY3TQ6r4Z2syk
        QNU5HICXpu5Q3STF4SsvjGcWOcbjThXcoxP3ni4AdnjcmyXOevOB5suVONHMvHkBN2o/WWMZna37f
        NrvTb/tjw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45326)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdbO5-00089E-ID; Tue, 26 May 2020 16:21:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdbO3-0005U2-2g; Tue, 26 May 2020 16:21:03 +0100
Date:   Tue, 26 May 2020 16:21:03 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 1/7] net: mdiobus: add clause 45 mdiobus accessors
Message-ID: <20200526152102.GA1551@shell.armlinux.org.uk>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdabd-0005s5-DB@rmk-PC.armlinux.org.uk>
 <20200526143906.GK768009@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526143906.GK768009@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 04:39:06PM +0200, Andrew Lunn wrote:
> On Tue, May 26, 2020 at 03:31:01PM +0100, Russell King wrote:
> > There is a recurring pattern throughout some of the PHY code converting
> > a devad and regnum to our packed clause 45 representation. Rather than
> > having this scattered around the code, let's put a common translation
> > function in mdio.h, and provide some register accessors.
> > 
> > Convert the phylib core, phylink, bcm87xx and cortina to use these.
> 
> Hi Russell
> 
> This is a useful patch whatever we decide about C45 probing. If you
> can do some basic testing of it, i say submit it for this merge
> window.

It's almost fine, except for one << 16 I seem to have left in
phylink.c.

I can also report that the 2nd revision of the 88x3310 PHY does
_not_ have bit 0 set in the devices-in-package (just like the first
revision).  The 2nd revision should respond to clause 22 cycles, but
as it's connected to the XSMI interface on the 8040, clause 22 cycles
can't be generated.

Also, I found this in linux/mdio.h:

#define MDIO_SUPPORTS_C22               1
#define MDIO_SUPPORTS_C45               2
#define MDIO_EMULATE_C22                4

which are for use with struct mdio_if_info which we don't use in
phylib.  That seems relevant to our discussions last night.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
