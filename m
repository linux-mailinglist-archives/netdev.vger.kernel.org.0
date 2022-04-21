Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1406150A023
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 14:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiDUNAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiDUNAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:00:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4E031201;
        Thu, 21 Apr 2022 05:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2BsecxFaWO+6hY04Blnscj25pg5IT+XD6dNTKQ9lWJI=; b=k/LuANzaW0rc0DneIOMPjHLS/w
        VPa4TP7Nyvqyhn27E+eSkn+c28FI+MC25A/Zoyd4F7j5bNgObcxyqWAStj+G0TzOxdj3evxBr0gBZ
        d16R2BEo775oAsjykjzjwtYjMZLhcX18jLbU9RKWB7EWuaWpSBEXi2AE6PRwpf2Pvaok=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhWNN-00GnoN-Pi; Thu, 21 Apr 2022 14:57:37 +0200
Date:   Thu, 21 Apr 2022 14:57:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] net: phy: marvell: Add LED accessors for Marvell
 88E1510
Message-ID: <YmFUwXLDIW5ouDCd@lunn.ch>
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
 <20220420124053.853891-5-kai.heng.feng@canonical.com>
 <YmAgq1pm37Glw2v+@lunn.ch>
 <CAAd53p6UAhDC2mGkz3_HgVs7kFgCwjfu2R+9FfROhToH2R6CjA@mail.gmail.com>
 <YmFFWd42Nol7Lrlm@lunn.ch>
 <CAAd53p6vUcUu=H=cDMh07zcUUDM8WTp+F_L+jiJSWKqd37+MDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p6vUcUu=H=cDMh07zcUUDM8WTp+F_L+jiJSWKqd37+MDg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 08:24:00PM +0800, Kai-Heng Feng wrote:
> On Thu, Apr 21, 2022 at 7:51 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > This is not feasible.
> > > If BIOS can define a method and restore the LED by itself, it can put
> > > the method inside its S3 method and I don't have to work on this at
> > > the first place.
> >
> > So maybe just declare the BIOS as FUBAR and move on to the next issue
> > assigned to you.
> >
> > Do we really want the maintenance burden of this code for one machines
> > BIOS?
> 
> Wasn't this the "set precedence" we discussed earlier for? Someone has
> to be the first, and more users will leverage the new property we
> added.

I both agree and disagree. I'm trying to make this feature generic,
unlike you who seem to be doing the minimal, only saving one of three
LED configuration registers. But on the other hand, i'm not sure there
will be more users. Do you have a list of machines where the BIOS is
FUBAR? Is it one machine? A range of machines from one vendor, or
multiple vendors with multiple machines. I would feel better about the
maintenance burden if i knew that this was going to be used a lot.
 
> > Maybe the better solution is to push back on the vendor and its
> > BIOS, tell them how they should of done this, if the BIOS wants to be
> > in control of the LEDs it needs to offer the methods to control the
> > LEDs. And then hopefully the next machine the vendor produces will
> > have working BIOS.
> 
> The BIOS doesn't want to control the LED. It just provides a default
> LED setting suitable for this platform, so the driver can use this
> value over the hardcoded one in marvell phy driver.

Exactly, it wants to control the LED, and tell the OS not to touch it
ever.

> So this really has nothing to do with with any ACPI method.
> I believe the new property can be useful for DT world too.

DT generally never trusts the bootloader to do anything. So i doubt
such a DT property would ever be used. Also, DT is about describing
the hardware, not how to configure the hardware. So you could list
there is a PHY LED, what colour it is, etc. But in general, you would
not describe how it is configured, that something else is configuring
it and it should be left alone.

> > Your other option is to take part in the effort to add control of the
> > LEDs via the standard Linux LED subsystem. The Marvel PHY driver is
> > likely to be one of the first to gain support this for. So you can
> > then totally take control of the LED from the BIOS and put it in the
> > users hands. And such a solution will be applicable to many machines,
> > not just one.
> 
> This series just wants to use the default value platform firmware provides.
> Create a sysfs to let user meddle with LED value doesn't really help
> the case here.

I would disagree. You can add a systemd service to configure it at
boot however you want. It opens up the possibility to implement
ethtool --identify in a generic way, etc. It is a much more powerful
and useful feature than saying 'don't touch', and also it justify the
maintenance burden.

     Andrew
