Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A981162D0F
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgBRReF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:34:05 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56784 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgBRReE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:34:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VBlgzDJ8AfzNNQrlB3h3LVPFwGbpAs3qhsXwzwlxheI=; b=N0p6aGLRMUcOXJ5KuML6w9Lhj
        vJmZEoWc/C89BBJt0XapNSfHONAf0TwTNwfli5NFcd6yvdxR8Qz5av0stkZoX1wtsPTG+qqPOnv6s
        yQz35Nj4SEwrSBkZLPoDMV5lvw8re4F5TJ4/ym9BcTtUqzoP2xPKKIhm901yyclBsVuOkzKcPeWvp
        /ViaTkK/LhUtWsAD0ul/VSgI9g75VjvwdwyNAGPsPh/hjMVpcaWYxzlcABH4EOOlEu8gKl4+0lTc0
        qCvvs0OFW8JbcTqZ4CdwgXkj7GspcH2XizKr5YRskawkLE+eaxuR/2Z8dsrjuRkKPWSxLlTgBAt6A
        0O9xzZUoQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53730)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j46kt-0000Ba-VL; Tue, 18 Feb 2020 17:33:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j46kr-0000cN-Ie; Tue, 18 Feb 2020 17:33:53 +0000
Date:   Tue, 18 Feb 2020 17:33:53 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
Message-ID: <20200218173353.GM25745@shell.armlinux.org.uk>
References: <0ebcd40d-b9cc-1a76-bb18-91d8350aa1cd@gmail.com>
 <170d6518-ea82-08d3-0348-228c72425e64@ti.com>
 <7569617d-f69f-9190-1223-77d3be637753@gmail.com>
 <c7a7bd71-3a1c-1cf3-5faa-204b10ea8b78@ti.com>
 <44499cb2-ec72-75a1-195b-fbadd8463e1c@ti.com>
 <6f800f83-0008-c138-c33a-c00a95862463@ti.com>
 <20200218162522.GH25745@shell.armlinux.org.uk>
 <1346e6b0-1d20-593f-d994-37de87ede891@ti.com>
 <20200218164928.GJ25745@shell.armlinux.org.uk>
 <cba40adb-38b9-2e66-c083-3ca7b570b927@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cba40adb-38b9-2e66-c083-3ca7b570b927@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:12:37AM -0600, Dan Murphy wrote:
> Well now the read_status is becoming a lot more complex.  It would be better
> to remove the ack_interrupt call back and just have read_status call the
> interrupt function regardless of interrupts or not.  Because all the
> interrupt function would be doing is clearing all the interrupts in the ISR
> register on a link up/down event.  And as you pointed out we can check and
> set a flag that indicates if a downshift has happened on link up status and
> clear it on link down. We would need to set the downshift interrupt mask to
> always report that bit.  As opposed to not setting any interrupts if
> interrupts are not enabled.  If the user wants to track WoL interrupt or any
> other feature interrupt we would have to add that flag to the read_status as
> well seems like it could get a bit out of control.

To be honest, I don't like phylib's interrupt implementation; it
imposes a fixed way of dealing with interrupts on phylib drivers,
and it sounds like its ideas don't match what modern PHYs want.

For example, the Marvell 88x3310 can produce interrupts for GPIOs
that are on-board, or temperature alarms, or other stuff... but
phylib's idea is that a PHY interrupt is for signalling that the
link changed somehow, and imposes a did_interrupt(), handle
interrupt, clear_interrupt() structure whether or not it's
suitable for the PHY.  If you don't provide the functions phylib
wants, then phydev->irq gets killed.  Plus, phylib claims the
interrupt for you at certain points depending on whether the
PHY is bound to a network interface or not.

So, my suggestion to move ack_interrupt to did_interrupt will
result in phylib forcing phydev->irq to PHY_POLL, killing any
support for interrupts what so ever...

> Again this is a lot of error prone complex changes and tracking just to
> populate a message in the kernel log.  There is no guarantee that the LP did
> not force the downshift or advertise that it supports 1Gbps.  So what
> condition is really being reported here?  There seems like there are so many
> different scenarios why the PHY could not negotiate to its advertised 1Gbps.

Note that when a PHY wants to downshift, it does that by changing its
advertisement that is sent to the other PHY.

So, if both ends support 1G, 100M and 10M, and the remote end decides
to downshift to 100M, the remote end basically stops advertising 1G
and restarts negotiation afresh with the new advertisement.

In that case, if you look at ethtool's output, it will indicate that
the link partner is not advertising 1G, and the link is operating at
100M.

If 100M doesn't work (and there are cases where connections become
quite flakey) then 100M may also be omitted as well, negotiation
restarted, causing a downshift to 10M.

That's basically how downshift works - a PHY will attempt to
establish link a number of times before deciding to restart
negotiation with some of the advertisement omitted, and the
reduced negotiation advertisement appears in the remote PHY's
link partner registers.

As I mentioned, the PHY on either end of the link can be the one
which decides to downshift, and the partner PHY has no idea that
a downshift has happened.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
