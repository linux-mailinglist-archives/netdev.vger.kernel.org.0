Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0142B3522B
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfFDVsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:48:51 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46066 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDVsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:48:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rfwzNeLmjlWWgSUV5Kv9rIXgd7DglWmh/ApBcODQ2vg=; b=cQR7/ZurX8DSC/7k0VDF82sK6
        FSX/SU892ObFp1VXEUNequUmWpFzOKJEUjy1vnTKeSvfsqvMJi9c46e9xVbJDXa6X8yJFDJQfeRQl
        88MHTZCgs91bv1Ofok9Idw1Y5aWrIY/iBIsoOT52J1R78jdi/ryNqTSrpkkr6WqLEOVlJflt4x0IU
        n1Bs4ehDbOjWG4UUy0hYAASx2lCCIrQXocpbckUfY20Uv2/PehF25GYGz0BCumy9PwsikkcxVv5CG
        jq+St4EkzsmOTbTnAZ5B6FaZMfFk1hYchRR6eP+geQmvihqKyaQeJ2TfAbR8InAAjf7ueQl9VMIPt
        LKF/hfmrQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56202)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hYHIV-0003ne-85; Tue, 04 Jun 2019 22:48:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hYHIT-0001pF-RY; Tue, 04 Jun 2019 22:48:45 +0100
Date:   Tue, 4 Jun 2019 22:48:45 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Message-ID: <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch>
 <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch>
 <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
 <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 02:37:31PM -0700, Florian Fainelli wrote:
> The firmware/boot loader transition to a full fledged OS with a switch
> is a tricky one to answer though, and there are no perfect answers
> AFAICT. If your SW is totally hosed, you might want the switch to
> forward traffic between all LAN ports (excluding WAN, otherwise you
> expose your home devices to the outside world, whoops).
> 
> If your SW is fully operational, then the questions are:
> 
> - do you want a DSA like behavior in your boot loader, in that all ports
> are separated but fully usable or do you want a dumb switch model where
> any port can forward to the CPU/management port, without any tags or
> anything (unmanaged mode)
> 
> - what happens during bootloader to OS handover, should the switch be
> held in reset so as to avoid any possible indirect DMA into main memory
> as much as power saving? Should nothing happen and let the OS wipe out
> clean the setting left by the boot loader?
> 
> All of these are in the realm of policy and trade offs as far as
> initializing/disruption goes, so there are no hard and fast answers.

For a switch, there are four stages, not two:

1. The out-of-reset state, which from what I've seen seems to be to
   behave like a dumb switch.

2. The boot loader state, which is generally the same as the
   out-of-reset state.

3. The OS-booting state, which for a DSA switch in Linux isolates each
   port from each other.

4. The OS-booted state, which depends on the system configuration.

If you are setting up a switch in a STP environment, you _have_ to be
aware of all of those states, and plan your network accordingly.
While it's possible to argue that the boot loader should isolate the
ports, it may be that the system gets hosed to the point that the boot
loader is unable to run - then you have a switch operating in a STP
environment acting as a dumb switch.

The same actually goes for many switches - consider your typical DSL
router integrated with a four port switch.  By default, that switch
forwards traffic between each port.  If you've setup the ports to be
isolated, each time the router is rebooted (e.g., due to a
configuration change) it will forward traffic between all ports until
the routers OS has finished booting and applied the switch
configuration.

What I'm basically saying is that if you're going to the point of
using such hardware in a STP environment, you _must_ pay attention
to the behaviour of the hardware through all phases of its operation
and consider the consequences should it fail in any of those phases.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
