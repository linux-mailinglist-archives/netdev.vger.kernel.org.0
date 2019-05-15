Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC791F845
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfEOQM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:12:59 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54054 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfEOQM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 12:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Hq3vRHLD1pCs0OXQNd9fHWn6XiK8vRrIF7zu56nsyp8=; b=ex0eIU0C/icHcsy6XUqshNtl7
        Qq1iUbCQTkeMNDit04IO/nhO0+K/sUV6B2fbZQqi8c2PU8Owep4XVNHvJtIAefY8f4KNOJD8j0QTD
        QquDLjRrLW20zF75aCZLQWZxnbT41B1Ut80e419kGdtMBnX4hFztiKFh3dQnzNUWD9L3mNEFk51n4
        rFgHHdvFZH1GMU94/Ct2g0wGSmSOf9TzrVMALuDNbageNVK2T//WN2uryfkBLdgyVEjjoru8KYx6b
        I0F1r6VpIL2/BoollFB4N+Qwf3eM0gcNlSHLzSwRUfE0Xf9Kfh94iBs6emdHHB/ZnjMKL1w182pX7
        EkeRni04A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52438)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hQwWS-00059T-9I; Wed, 15 May 2019 17:12:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hQwWR-0000Z0-1t; Wed, 15 May 2019 17:12:51 +0100
Date:   Wed, 15 May 2019 17:12:50 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: dsa: using multi-gbps speeds on CPU port
Message-ID: <20190515161250.ewlj5u4gs3pvuay3@shell.armlinux.org.uk>
References: <20190515143936.524acd4e@bootlin.com>
 <20190515132701.GD23276@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515132701.GD23276@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 03:27:01PM +0200, Andrew Lunn wrote:
> On the master interface, the armada 8040, eth0, you still need
> something. However, if you look at phylink_parse_fixedlink(), it puts
> the speed etc into a phylink_link_state. It never instantiates a
> fixed-phy. So i think that could be expanded to support higher speeds
> without too much trouble. The interesting part is the IOCTL handler.

phylink already supports 2500 and 10G fixed-link (actually, it doesn't
care too much about the speed value, just passing it through), provided
phy_lookup_setting() and the MAC support the speed.

Since it doesn't bother with emulating a set of phy registers, which
then would be read by phylib and translated back to a speed and duplex
for the MAC to use, it's way more flexible when it comes to the old
emulated-phy fixed links code.

What it doesn't do is provide an emulation of C45 PHYs for mii-tool/
mii-diag - ethtool is the way forward, and it supports ethtool for
these speeds.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
