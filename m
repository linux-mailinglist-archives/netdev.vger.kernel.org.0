Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3262E5F917
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfGDN2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:28:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbfGDN2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 09:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Xc/4Za6oNGSLkMJvcP3Am29FNfb6aREUWZnvyZhLx/U=; b=uwisZ9EKHtaWlIlsNNAQ9l/9I7
        xkKX0oCwzqABMR9wf2EONn/EesCSmSubenNgGBixanVAOUlYp0/EU4z4YPwe7fliA6MnR8oNsRA/I
        vkIq+fttyKJxymPi4ayZsq9AKakrwVlxMOgtgTwK8sdF8YYQTWoVwN2X+bX5bkXkYsY0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hj1mG-0003mC-5r; Thu, 04 Jul 2019 15:27:56 +0200
Date:   Thu, 4 Jul 2019 15:27:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
Message-ID: <20190704132756.GB13859@lunn.ch>
References: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
 <20190703155518.GE18473@lunn.ch>
 <d1181129-ec9d-01c1-3102-e1dc5dec0378@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1181129-ec9d-01c1-3102-e1dc5dec0378@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 10:54:47AM +0200, Benjamin Beckmeyer wrote:
> 
> On 03.07.19 17:55, Andrew Lunn wrote:
> > On Wed, Jul 03, 2019 at 03:10:34PM +0200, Benjamin Beckmeyer wrote:
> >> Hey folks,
> >>
> >> I'm having a problem with a custom i.mx6ul board. When DSA is loaded I can't 
> >> get access to the switch via MDIO, but the DSA is working properly. I set up
> >> a bridge for testing and the switch is in forwarding mode and i can ping the 
> >> board. But the MDIO access isn't working at address 2 for the switch. When I 
> >> delete the DSA from the devicetree and start the board up, I can access the 
> >> switch via MDIO.
> >>
> >> With DSA up and running:
> >>
> >> mii -i 2 0 0x9800
> >> mii -i 2 1
> >> phyid:2, reg:0x01 -> 0x4000
> >> mii -i 2 0 0x9803
> >> mii -i 2 1
> >> phyid:2, reg:0x01 -> 0x4000
> >> mii -i 2 1 0x1883
> >> mii -i 2 1
> >> phyid:2, reg:0x01 -> 0x4000
> > Hi Benjamin
> >
> > I'm guessing that the driver is also using register 0 and 1 at the
> > same time you are, e.g. to poll the PHYs for link status etc.
> >
> > There are trace points for MDIO, so you can get the kernel to log all
> > registers access. That should confirm if i'm right.
> >
> > 	  Andrew
> 
> Hi Andrew,
> you were absolutly right. The bus is really busy the whole time, I've 
> checked that with the tracepoints in mdio_access.
> 
> But I'm still wondering why isn't that with a single chip addressing 
> mode configured switch? I mean, okay, the switch has more ports, but
> I've checked the accesses for both. The 6321(single chip addressing 
> mode) has around 4-5 accesses to the MDIO bus and the 6390(multi chip 
> addressing mode) has around 600 accesses per second. 

Hi Benjamin

In single chip mode, reading a register is atomic. With multi-chip,
you need to access two registers, so it clearly is not atomic. And so
any other action on the bus will cause you problems when doing things
from user space without being able to take the register mutex.

But 4-5 vs 600 suggests you don't have the interrupt line in your
device tree. If you have the interrupt line connected to a GPIO, and
the driver knows about it, it has no need to poll the PHYs. I also
added support for 'polled interrupts', as a fall back when then
interrupt is not listed in device tree. 10 times a second the driver
polls the interrupt status register, and if any interrupts have
happened within the switch, it triggers the needed handlers. Reading
one status register every 100ms is much less effort than reading all
the PHY status registers once per second.

Still, 600 per second sounds too high. Do you have an SNMP agent
getting statistics?

	Andrew
