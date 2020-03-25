Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE3D19252E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbgCYKLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:11:33 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54658 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgCYKLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 06:11:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yV/yZP4Ds9lzjdf9Qgb31R1wrp8j5EQ/N+9DmWJ+ZOc=; b=ZqnvWDSriXdZUZ32jFaszejeV
        xzr9I5/j9jWPmXfVjLh3uqfGy8CKLlpmtvr59qnOhyKe/gGhNVJLTW3iS5YkCfLjVGC/tocHedQ7U
        LXpTB8GtaDeoDKbL0dYyG04XGizNBQggCbz7IlODgJDX0GsQrgXvX42yqej5EwtI5JY20wyaJr0LZ
        QEFVzHE6wphwjfCrbaNOMlbhbCDHyqJiT05m7/MDnOoSeYGA76nFJAlYZ5R9OrmR/fHLvoB4RRDCs
        JLG1CHWJeP5TtuF+S45tn3FVz3omKZr0CUQDZ55RJRQZOfMyAklUX5vevyfn5OHko1SjAMay9wLtd
        qKYiJyRUw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41132)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jH30H-00055p-Ml; Wed, 25 Mar 2020 10:11:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jH30C-00029w-2B; Wed, 25 Mar 2020 10:11:12 +0000
Date:   Wed, 25 Mar 2020 10:11:12 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     David Miller <davem@davemloft.net>, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, mark.rutland@arm.com,
        robh+dt@kernel.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        marex@denx.de, david@protonic.nl, devicetree@vger.kernel.org,
        olteanv@gmail.com
Subject: Re: user space interface for configuring T1 PHY management mode
 (master/slave)
Message-ID: <20200325101111.GZ25745@shell.armlinux.org.uk>
References: <20200325083449.GA8404@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325083449.GA8404@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 09:34:49AM +0100, Oleksij Rempel wrote:
> Hi all,
> 
> I'm working on mainlining of NXP1102 PHY (BroadR Reach/802.3bw) support.
> 
> Basic functionality is working and support with mainline kernel. Now it is time
> to extend it. According to the specification, each PHY can be master or slave.
> 
> The HW can be pre configured via bootstrap pins or fuses to have a default
> configuration. But in some cases we still need to be able to configure the PHY
> in a different mode: 
> --------------------------------------------------------------------------------
> http://www.ieee802.org/3/1TPCESG/public/BroadR_Reach_Automotive_Spec_V3.0.pdf
> 
> 6.1 MASTER-SLAVE configuration resolution
> 
> All BroadR-Reach PHYs will default to configure as SLAVE upon power up or reset
> until a management system (for example, processor/microcontroller) configures
> it to be MASTER. MASTER-SLAVE assignment for each link configuration is
> necessary for establishing the timing control of each PHY.
> 
> 6.2 PHY-Initialization
> 
> Both PHYs sharing a link segment are capable of being MASTER or SLAVE. In IEEE
> 802.3-2012, MASTER-SLAVE resolution is attained during the Auto-Negotiation
> process (see IEEE 802.3-2012 Clause 28). However, the latency for this process
> is not acceptable for automotive application. A forced assignment scheme is
> employed depending on the physical deployment of the PHY within the car. This
> process is conducted at the power-up or reset condition. The station management
> system manually configures the BroadR-Reach PHY to be MASTER (before the link
> acquisition process starts) while the link partner defaults to SLAVE
> (un-managed).
> --------------------------------------------------------------------------------
> 
> Should phylink be involved in this configuration? What's the proper user
> space interface to use for this kind of configuration?  ethtool or ip
> comes into mind. Further having a Device Tree property to configure a
> default mode to overwrite the boot strap pins would be nice to have.

Well, the first question would be whether this is something that
userspace needs to alter, or whether static configuration at boot
time is what is necessary.

Given what is in the description, it seems that the concern is with
the latency it takes for the link to come up. I would suggest that
the lowest latency would be achieved when using static configuration
rather than waiting for the kernel to fully boot and userspace to
start before configuring the PHY.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
