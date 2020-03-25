Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10811922D8
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 09:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgCYIfC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Mar 2020 04:35:02 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47823 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgCYIfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 04:35:01 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jH1Uy-0003At-S7; Wed, 25 Mar 2020 09:34:52 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jH1Uv-00047B-MV; Wed, 25 Mar 2020 09:34:49 +0100
Date:   Wed, 25 Mar 2020 09:34:49 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mark.rutland@arm.com, robh+dt@kernel.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        marex@denx.de, david@protonic.nl, devicetree@vger.kernel.org,
        linux@armlinux.org.uk, olteanv@gmail.com
Subject: user space interface for configuring T1 PHY management mode
 (master/slave)
Message-ID: <20200325083449.GA8404@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:27:16 up 195 days, 21:15, 449 users,  load average: 0.25, 0.32,
 0.69
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm working on mainlining of NXP1102 PHY (BroadR Reach/802.3bw) support.

Basic functionality is working and support with mainline kernel. Now it is time
to extend it. According to the specification, each PHY can be master or slave.

The HW can be pre configured via bootstrap pins or fuses to have a default
configuration. But in some cases we still need to be able to configure the PHY
in a different mode: 
--------------------------------------------------------------------------------
http://www.ieee802.org/3/1TPCESG/public/BroadR_Reach_Automotive_Spec_V3.0.pdf

6.1 MASTER-SLAVE configuration resolution

All BroadR-Reach PHYs will default to configure as SLAVE upon power up or reset
until a management system (for example, processor/microcontroller) configures
it to be MASTER. MASTER-SLAVE assignment for each link configuration is
necessary for establishing the timing control of each PHY.

6.2 PHY-Initialization

Both PHYs sharing a link segment are capable of being MASTER or SLAVE. In IEEE
802.3-2012, MASTER-SLAVE resolution is attained during the Auto-Negotiation
process (see IEEE 802.3-2012 Clause 28). However, the latency for this process
is not acceptable for automotive application. A forced assignment scheme is
employed depending on the physical deployment of the PHY within the car. This
process is conducted at the power-up or reset condition. The station management
system manually configures the BroadR-Reach PHY to be MASTER (before the link
acquisition process starts) while the link partner defaults to SLAVE
(un-managed).
--------------------------------------------------------------------------------

Should phylink be involved in this configuration? What's the proper user
space interface to use for this kind of configuration?  ethtool or ip
comes into mind. Further having a Device Tree property to configure a
default mode to overwrite the boot strap pins would be nice to have.


Regards,
Oleksij

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
