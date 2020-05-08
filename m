Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71F31CB9F6
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgEHVif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgEHVie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 17:38:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5F8C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 14:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4jfQxPKo1sBNvjyZGl9krfsPXpBtUOrgvU6Eu3l5OnA=; b=ccxwOSF8FqhvLynCoPpyReerC
        +ou6n/vtGzfJ8lsJ0JEuJeVmM5W54h41fLcaUSI42zBY1tZN9pMhqDuL79IPfYLRGf2iqrB1DnlQ4
        ZF8EQbxHX3hUyvKUNNpxxJgqIxCp8Pw4BrCSIZU6XI+0Sdc7vwyer5cKAlOwXqQlrqlvY7oHhOETt
        YNzjZ+fuJ9WxtRlJr3K+D7d7ShCOIE+8L6wcbIHczWNFjxEQzaCm7LtanN9/AdRnK7SyHpsVL0YJ5
        IXxwMjoZQHh3g5Uwspyl1DTo50Ca8Lt8ZjCj6/26gB5uzTI6BJ517T2HaVGWCwpLCPXJ/Q3sAzOmB
        BUSVqh61Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:37748)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jXAhJ-00029j-Nw; Fri, 08 May 2020 22:38:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jXAhE-00029U-Sl; Fri, 08 May 2020 22:38:16 +0100
Date:   Fri, 8 May 2020 22:38:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 0/2] Fix 88x3310 leaving power save mode
Message-ID: <20200508213816.GY1551@shell.armlinux.org.uk>
References: <20200414194753.GB25745@shell.armlinux.org.uk>
 <20200414.164825.457585417402726076.davem@davemloft.net>
 <CAGnkfhw45WBjaYFcrO=vK0pbYvhzan970vtxVj8urexhh=WU_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhw45WBjaYFcrO=vK0pbYvhzan970vtxVj8urexhh=WU_A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 11:32:39PM +0200, Matteo Croce wrote:
> On Wed, Apr 15, 2020 at 1:48 AM David Miller <davem@davemloft.net> wrote:
> >
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Date: Tue, 14 Apr 2020 20:47:53 +0100
> >
> > > This series fixes a problem with the 88x3310 PHY on Macchiatobin
> > > coming out of powersave mode noticed by Matteo Croce.  It seems
> > > that certain PHY firmwares do not properly exit powersave mode,
> > > resulting in a fibre link not coming up.
> > >
> > > The solution appears to be to soft-reset the PHY after clearing
> > > the powersave bit.
> > >
> > > We add support for reporting the PHY firmware version to the kernel
> > > log, and use it to trigger this new behaviour if we have v0.3.x.x
> > > or more recent firmware on the PHY.  This, however, is a guess as
> > > the firmware revision documentation does not mention this issue,
> > > and we know that v0.2.1.0 works without this fix but v0.3.3.0 and
> > > later does not.
> >
> > Series applied, thanks.
> >
> 
> Hi,
> 
> should we queue this to -stable?
> The 10 gbit ports don't work without this fix.

It has a "Fixes:" tag, so it should be backported automatically.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
