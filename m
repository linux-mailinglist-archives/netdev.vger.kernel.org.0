Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928D41925BA
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgCYKfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:35:45 -0400
Received: from protonic.xs4all.nl ([83.163.252.89]:39992 "EHLO protonic.nl"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727407AbgCYKfo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 06:35:44 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2020 06:35:43 EDT
Received: from erd988 (erd988.prtnl [192.168.224.30])
        by sparta.prtnl (Postfix) with ESMTP id A803844A024D;
        Wed, 25 Mar 2020 11:28:52 +0100 (CET)
Date:   Wed, 25 Mar 2020 11:28:51 +0100
From:   David Jander <david@protonic.nl>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Miller <davem@davemloft.net>, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, mark.rutland@arm.com,
        robh+dt@kernel.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        marex@denx.de, devicetree@vger.kernel.org, olteanv@gmail.com
Subject: Re: user space interface for configuring T1 PHY management mode
 (master/slave)
Message-ID: <20200325112851.43b3e6bc@erd988>
In-Reply-To: <20200325101111.GZ25745@shell.armlinux.org.uk>
References: <20200325083449.GA8404@pengutronix.de>
        <20200325101111.GZ25745@shell.armlinux.org.uk>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 10:11:12 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Wed, Mar 25, 2020 at 09:34:49AM +0100, Oleksij Rempel wrote:
> > Hi all,
> > 
> > I'm working on mainlining of NXP1102 PHY (BroadR Reach/802.3bw) support.
> > 
> > Basic functionality is working and support with mainline kernel. Now it is
> > time to extend it. According to the specification, each PHY can be master
> > or slave.
> > 
> > The HW can be pre configured via bootstrap pins or fuses to have a default
> > configuration. But in some cases we still need to be able to configure the
> > PHY in a different mode: 
> > --------------------------------------------------------------------------------
> > http://www.ieee802.org/3/1TPCESG/public/BroadR_Reach_Automotive_Spec_V3.0.pdf
> > 
> > 6.1 MASTER-SLAVE configuration resolution
> > 
> > All BroadR-Reach PHYs will default to configure as SLAVE upon power up or
> > reset until a management system (for example, processor/microcontroller)
> > configures it to be MASTER. MASTER-SLAVE assignment for each link
> > configuration is necessary for establishing the timing control of each PHY.
> > 
> > 6.2 PHY-Initialization
> > 
> > Both PHYs sharing a link segment are capable of being MASTER or SLAVE. In
> > IEEE 802.3-2012, MASTER-SLAVE resolution is attained during the
> > Auto-Negotiation process (see IEEE 802.3-2012 Clause 28). However, the
> > latency for this process is not acceptable for automotive application. A
> > forced assignment scheme is employed depending on the physical deployment
> > of the PHY within the car. This process is conducted at the power-up or
> > reset condition. The station management system manually configures the
> > BroadR-Reach PHY to be MASTER (before the link acquisition process starts)
> > while the link partner defaults to SLAVE (un-managed).
> > --------------------------------------------------------------------------------
> > 
> > Should phylink be involved in this configuration? What's the proper user
> > space interface to use for this kind of configuration?  ethtool or ip
> > comes into mind. Further having a Device Tree property to configure a
> > default mode to overwrite the boot strap pins would be nice to have.  
> 
> Well, the first question would be whether this is something that
> userspace needs to alter, or whether static configuration at boot
> time is what is necessary.
> 
> Given what is in the description, it seems that the concern is with
> the latency it takes for the link to come up. I would suggest that
> the lowest latency would be achieved when using static configuration
> rather than waiting for the kernel to fully boot and userspace to
> start before configuring the PHY.

Yes, that would be the fastest, and in many cases the preferred way. But the
lack of auto negotiation is not a choice. It is imposed by the spec. Because
of this, and since the PHY's are configurable in software, there is some need
for configuration in user-space. Of course latency would not be an issue in
such a case, otherwise a fixed strapped configuration was chosen.

Best regards,

-- 
David Jander
Protonic Holland.
