Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9873315DA51
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgBNPIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:08:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45782 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729430AbgBNPId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:08:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ciB+nuVqLQoTOgHNipMpeEq6Q5heUVJDZIKP3A78ZLo=; b=tDhvjiVX8kIEF7m7nD29iixiZC
        lRBeHsl3Bn9+dBBOW2vErKNHKakwAWW1bRnN1YJfEsQ0OiVFzr4msUux1Z6U0+c5iaPW/zhqwwOpO
        CV2wIZKhc0R3D7UtLb5BbWQ5YxXmXM36TLOb9Ky3EbCAmZgihupfwvpQycaeq8n7jDmA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j2cZu-0007tm-Sb; Fri, 14 Feb 2020 16:08:26 +0100
Date:   Fri, 14 Feb 2020 16:08:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Heads up: phylink changes for next merge window
Message-ID: <20200214150826.GF15299@lunn.ch>
References: <20200213133831.GM25745@shell.armlinux.org.uk>
 <20200213144615.GH18808@shell.armlinux.org.uk>
 <20200213160004.GC31084@lunn.ch>
 <20200213171602.GO25745@shell.armlinux.org.uk>
 <20200213174500.GI18808@shell.armlinux.org.uk>
 <20200214104148.GJ18808@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214104148.GJ18808@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The reasoning is, if the PHY detect bit is set, the PPU should be
> polling the attached PHY and automatically updating the MAC to reflect
> the PHY status.  This seems great...
> 
> On the ZII dev rev C, we have the following port status values:
> - port 0 = 0xe04
> - port 1 through 8 = 0x100f
> - port 9 = 0x49
> - port 10 = 0xcf4c
> 
> On the ZII dev rev B, port 4 (which is one of the optical ports) has a
> value of 0xde09, despite being linked to the on-board serdes.  It seems
> that the PPU on the 88e6352 automatically propagates the status from the
> serdes there.
> 
> So, it looks to me like using the PHY detect bit is the right solution,
> we just need access to it at this mid-layer...

Hi Russell

We need to be careful of the PPU. I'm assuming it uses MDIO to access
the PHY registers. We have code which allows the PHY page to the
changed, e.g. hwmon to get the temperature sensors, and i will soon
have code for cable diagnostics. We don't want the PPU reading some
temperature sensor registers and configuring the MAC based on that.

For cases not using a PHY, e.g. the SERDES on the 6352, it might be
safe to use the PPU.

     Andrew
