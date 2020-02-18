Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C10A162AA5
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgBRQbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:31:23 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55808 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgBRQbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:31:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1OI/4y3IvNaMNuZweVzSx/RlrDTFQNm9QDsumLCrNzw=; b=Lswngxr4IsCwXu5wNUdOXw4kl
        AUea1lBP7u4AWPFyqK6w4JtlT4WwFyDbZGsEFTZSASdzSaiV62Zl0dzFH48Utw8l1F2jrU0wyeD6r
        adXDSqJCo7iAaVzrWKpHcihJtIxJ7FFHwh/XJ41ejjjOdChzNaKNyxRO09jCyfEE9RgkVZqidiogq
        BngZW45nSR3UL5Tggbruc1TT5sQVKHq2Pp8RkFCk7pAa9EhcpnPPjmGbKxWNaU2M66wm7RvWA7b+b
        GM0vnHIwj5LdvKoGwHdrTdhbyvONDMrdWF71+7UlrVCDlX260y9rSRIPzqq2v3DN8d8tkTNycgH3g
        /ow2TNcvw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53696)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j45mG-0008HL-5l; Tue, 18 Feb 2020 16:31:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j45mE-0000ZY-Pu; Tue, 18 Feb 2020 16:31:14 +0000
Date:   Tue, 18 Feb 2020 16:31:14 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: fix duplicate vlan
 warning
Message-ID: <20200218163114.GI25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <E1j41KQ-0002uy-TQ@rmk-PC.armlinux.org.uk>
 <20200218115157.GG25745@shell.armlinux.org.uk>
 <20200218162750.GR31084@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218162750.GR31084@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 05:27:50PM +0100, Andrew Lunn wrote:
> On Tue, Feb 18, 2020 at 11:51:57AM +0000, Russell King - ARM Linux admin wrote:
> > On Tue, Feb 18, 2020 at 11:46:14AM +0000, Russell King wrote:
> > > When setting VLANs on DSA switches, the VLAN is added to both the port
> > > concerned as well as the CPU port by dsa_slave_vlan_add().  If multiple
> > > ports are configured with the same VLAN ID, this triggers a warning on
> > > the CPU port.
> > > 
> > > Avoid this warning for CPU ports.
> > > 
> > > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > 
> > Note that there is still something not right.  On the ZII dev rev B,
> > setting up a bridge across all the switch ports, I get:
> 
> Hi Russell
> 
> FYI: You need to be a little careful with VLANs on rev B. The third
> switch does not have the PVT hardware. So VLANs are going to 'leak'
> when they cross the DSA link to that switch.

However, I'm not using VLAN configuration on any of the ZII boards.
As I stated, I'm just setting up a bridge.  It isn't even vlan
aware:

iface br0 inet manual
	bridge-ports lan0 lan1 lan2 lan3 lan4 lan5 lan6 lan7 lan8
	bridge-maxwait 0

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
