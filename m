Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F62548C516
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347620AbiALNqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiALNqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 08:46:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4184C06173F;
        Wed, 12 Jan 2022 05:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ab8Ka5SKJIX2VaYJDOFAW6O83Y0+hrNEcd/jemOMrtw=; b=sGwswN68LdNqbbHxAdXZ3Q95Tk
        QIlMv/SnqIhTe5SSmqy9I5XOb+kif8qcjhUsg+s4rTS63qXiTbyK8fMwih84RK8MRgZgY2DA36VmM
        N45Y5dcSyHemSLqcVGOBHRZ2jA/TMfmZp9a05dRCrjbRfFVWm6TxSwEdgIWZ9xLcm7bH7zQen1tJF
        tQSSFrMceOeAorpfxeBqAExDdaY3Ggo+FpERE/TdAgbMEyTLh/+1hk8f3scyu5azxVhrG9898O3DU
        I0gnIsM+nckhIfsRVftUqyeMFgDxV/k9i2cMIQRHyHMpaxyiClhlnPZIhoCGwQzBhjbbnj5ziprMO
        vRTrmIBA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56674)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n7dxM-00062r-E1; Wed, 12 Jan 2022 13:46:28 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n7dxJ-0006wg-OT; Wed, 12 Jan 2022 13:46:25 +0000
Date:   Wed, 12 Jan 2022 13:46:25 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
Message-ID: <Yd7bsbvLyIquY5jn@shell.armlinux.org.uk>
References: <20210719082756.15733-1-ms@dev.tdt.de>
 <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de>
 <CAJ+vNU2Bn_eks03g191KKLx5uuuekdqovx000aqcT5=f_6Zq=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU2Bn_eks03g191KKLx5uuuekdqovx000aqcT5=f_6Zq=w@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 11:12:33AM -0800, Tim Harvey wrote:
> I added a debug statement in xway_gphy_rgmii_init and here you can see
> it gets called 'before' the link comes up from the NIC on a board that
> has a cable plugged in at power-on. I can tell from testing that the
> rx_delay/tx_delay set in xway_gphy_rgmii_init does not actually take
> effect unless I then bring the link down and up again manually as you
> indicate.
> 
> # dmesg | egrep "xway|nicvf"
> [    6.855971] xway_gphy_rgmii_init mdio_thunder MDI_MIICTRL:0xb100
> rx_delay=1500 tx_delay=500
> [    6.999651] nicvf, ver 1.0
> [    7.002478] nicvf 0000:05:00.1: Adding to iommu group 7
> [    7.007785] nicvf 0000:05:00.1: enabling device (0004 -> 0006)
> [    7.053189] nicvf 0000:05:00.2: Adding to iommu group 8
> [    7.058511] nicvf 0000:05:00.2: enabling device (0004 -> 0006)
> [   11.044616] nicvf 0000:05:00.2 eth1: Link is Up 1000 Mbps Full duplex

Does the kernel message about the link coming up reflect what is going
on physically with the link though?

If a network interface is down, it's entirely possible that the link is
already established at the hardware level, buit the "Link is Up" message
gets reported when the network interface is later brought up. So,
debugging this by looking at the kernel messages is unreliable.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
