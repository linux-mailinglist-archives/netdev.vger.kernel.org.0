Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26499161B13
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 19:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgBQSvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 13:51:55 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40846 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbgBQSvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 13:51:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KvB6f7fGXolTqd/wL5HLgEvOSRwBBfxjMW4EXoEa9po=; b=yhcdWpgXTLtsE1Z1omWazoICP
        DWJVggwX8ttrSOzK7AZnClBhh+SAi72l40EFLARh3Jt0rVM2r6xk1Jz88S9JIiJbImkK1IPxmu0/e
        BU5wTD4PxDU4Vxrpj/2JsoAWktKHWB3LiN7E0FMjcZEE9aSIe+YD3fGyyaWanHJD01AyaRf+mfC/X
        vfmW1ikUx1qrGertc+ueZLBDpuy2NdsBjPL/GjHm6b22OVdCPM3bfgQ9cLdBFmM0V2Zg1Jc85HXxO
        oNRaL6CyA4ZnRywnqi5b7IVcoTtCVvXeqnXTixlkAA/EftaDf56IEL9tJAX8V7/7DEnxIs1Z8zlRP
        5zZhq40hg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:41636)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j3lUU-0002YH-Ho; Mon, 17 Feb 2020 18:51:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j3lUR-0006Xg-CX; Mon, 17 Feb 2020 18:51:31 +0000
Date:   Mon, 17 Feb 2020 18:51:31 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@openwrt.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [CFT 0/8] rework phylink interface for split MAC/PCS support
Message-ID: <20200217185131.GC25745@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <20200217173324.GI31084@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217173324.GI31084@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 06:33:24PM +0100, Andrew Lunn wrote:
> On Mon, Feb 17, 2020 at 05:22:43PM +0000, Russell King - ARM Linux admin wrote:
> > Hi,
> > 
> > The following series changes the phylink interface to allow us to
> > better support split MAC / MAC PCS setups.  The fundamental change
> > required for this turns out to be quite simple.
> 
> Hi Russell
> 
> Do you have a branch i can pull and test?

Nothing beyond the branches I've mentioned in the previous heads-up as
yet, sorry.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
