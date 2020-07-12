Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C62821C96A
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 15:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgGLN0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 09:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgGLN0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 09:26:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E777BC061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 06:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7Xiy9rSJVN/geh9xT4cF+3QPjfe//csw6QWGB9cPKwE=; b=FPf5yOTbyEpJy2hdLeOx4a1k+
        skjTKmqHoMJ3UTyjD/WCYXzdXBs8St0omEBHNj9cHXHrVSgkK+bPgdf9FQhuXBE5wny3XMcDVfZ5G
        Kgri7jOJKcZ4vMnhq95sbc4+UjlHF5swrPB5Kh6YZiYxiiRaeGX+T++2PVIoB45Qrb7t/vSRNktmR
        aU+xDSzcjk7cZTHq/Q99+TjCPn7ANEJzHWYfVsiAmus0zGd1PI5dorEBuqm5wrQ7CKCLzHZCVKMEl
        JfyeG35fEu/NDHRRu9MGFjJbEaigCeVNJuW5IJD6wpg6SUM4/XCNbUEUYpJBe7KDBPP2zdQ3S5D7g
        8++7/f0nw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38574)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jubzR-000361-2v; Sun, 12 Jul 2020 14:25:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jubzO-0005K0-GS; Sun, 12 Jul 2020 14:25:54 +0100
Date:   Sun, 12 Jul 2020 14:25:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Martin Rowe <martin.p.rowe@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
Message-ID: <20200712132554.GS1551@shell.armlinux.org.uk>
References: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
 <20200711162349.GL1014141@lunn.ch>
 <20200711192255.GO1551@shell.armlinux.org.uk>
 <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 12, 2020 at 01:00:48PM +0000, Martin Rowe wrote:
> On Sat, 11 Jul 2020 at 19:23, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > On Sat, Jul 11, 2020 at 06:23:49PM +0200, Andrew Lunn wrote:
> > > So i'm guessing it is the connection between the CPU and the switch.
> > > Could you confirm this? Create a bridge, add two ports of the switch
> > > to the bridge, and then see if packets can pass between switch ports.
> > >
> > > If it is the connection between the CPU and the switch, i would then
> > > be thinking about the comphy and the firmware. We have seen issues
> > > where the firmware is too old. That is not something i've debugged
> > > myself, so i don't know where the version information is, or what
> > > version is required.
> >
> > However, in the report, Martin said that reverting the problem commit
> > from April 14th on a kernel from July 6th caused everything to work
> > again.  That is quite conclusive that 34b5e6a33c1a is the cause of
> > the breakage.
> 
> I tried it anyway and couldn't get any traffic to flow between the
> ports, but I could have configured it wrongly. I gave each port a
> static IP, bridged them (with and without br0 having an IP assigned),
> and tried pinging from one port to the other. I tried with the
> assigned IPs in the same and different subnets, and made sure the
> routes were updated between tests. Tx only, no responses, exactly like
> pinging a remote host.

Note that you shouldn't need to set an ip on the bridge ports
themselves.

If you do this:

# ip li set dev eth1 up
# brctl addbr br0
# for port in lan1 lan2 lan3 lan4; do ip li set dev $port up; \
	brctl addif br0 $port; done

Then you should be able to pass traffic between the LAN ports - the
packets should stay on the DSA switch and should not involve the CPU.

If you have machine A with address 192.168.2.1/24 on lan1 and machine B
with address 192.168.2.2/24 on lan2, then they should be able to ping
each other - the packet flow will be through the DSA switch without
involving the CPU.

If that doesn't work, then the next step is to directly connect machine
A to machine B and confirm that works.  If it works there, but does not
work when connected to the DSA switch, then it points to the DSA LAN
ports being incorrectly configured.

At that point, what may help is to get a dump of the registers
associated with each of the ports:

# ethtool -d lan<N>

and then we can see how the kernel is configuring them.

If it is a port issue, that should help pinpoint it - if it's a problem
with the CPU port configuration, then ethtool can't read those registers
(and the only way to get them is to apply some debugfs patch that was
refused from being merged into mainline.)

> I'm now less confident about my git bisect, though, because it appears
> my criteria for verifying if a commit was "good" was not sufficient. I
> was just checking to see if the port could get assigned a DHCP address
> and ping something else, but it appears that (at least on 5.8-rc4 with
> the one revert) the interface "dies" after working for about 30-60
> seconds. Basically the symptoms I described originally, just preceded
> by 30-60 seconds of it working perfectly. I will re-run the bisect to
> figure out what makes it go from "working perfectly" to "working
> perfectly for less than a minute", which will take a few days.

That seems really weird!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
