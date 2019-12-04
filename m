Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D122112EA2
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 16:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfLDPiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 10:38:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728340AbfLDPiI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 10:38:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZQmp2vK+9E6vnQm9JAkg9Rvuxe+dAzf3t78hymxRP7k=; b=Q3AoIEKekqOiipHkidJ41yiHt0
        op5NY2amX6eSwpZ7bAlMgmCCvHLTYKZy7bNDxeGNzYPH3feMHgd0jla10384zaEFflD/JY2JUPKNV
        f090Ap6q7hF2qgkpv2wnTTJX7MbRE3gx+bCL2q3OTvSV5TBDhpVkBIt2VXsFlasBcZcE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1icWj6-0002cv-Ql; Wed, 04 Dec 2019 16:38:04 +0100
Date:   Wed, 4 Dec 2019 16:38:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?J=FCrgen?= Lambrecht <j.lambrecht@televic.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rasmus.villemoes@prevas.dk,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        vivien.didelot@gmail.com
Subject: Re: net: dsa: mv88e6xxx: error parsing ethernet node from dts
Message-ID: <20191204153804.GD21904@lunn.ch>
References: <27f65072-f3a1-7a3c-5e9e-0cc86d25ab51@televic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27f65072-f3a1-7a3c-5e9e-0cc86d25ab51@televic.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Here parts of dmesg (no error reported):
> 
> [    1.992342] libphy: Fixed MDIO Bus: probed
> [    2.009532] pps pps0: new PPS source ptp0
> [    2.014387] libphy: fec_enet_mii_bus: probed
> [    2.017159] mv88e6085 2188000.ethernet-1:00: switch 0x710 detected: Marvell 88E6071, revision 5
> [    2.125616] libphy: mv88e6xxx SMI: probed
> [    2.134450] fec 2188000.ethernet eth0: registered PHC device 0
> ...
> [   11.366359] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=POLL)
> [   11.366722] fec 2188000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
> 
> When I enable debugging in the source code, I see that mv88e6xxx_probe() fails, because *'of_find_net_device_by_node(ethernet);'* fails. But why?,

That always happens the first time. There is a chicken/egg
problem. The MDIO bus is registered by the FEC driver, the switch is
probed, and the DSA core looks for the ethernet interface. But the FEC
driver has not yet registered the interface, it is still busy
registering the MDIO bus. So you get an EPRODE_DEFFER from the switch
probe. The FEC then completes its probe, registering the
interface. Sometime later Linux retries the switch probe, and this
time it works.

What you are seeing here is the first attempt. There should be a
second go later in the log.

       Andrew
