Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D02640DA43
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239640AbhIPMrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:47:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhIPMry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=blLTBJBUXDjrO3ZZ8TPo9N3rgru39vDBHZ72imqGbm0=; b=j+bY353POdkkFTi0Yg5Io/vtDW
        KKNt6puNypRB+qwdof2rDeewxXt5LVRSu6Y7WQf+WGKf8w0xhvmfFWvRu1fTnT95SWTqbnXArBHV/
        Of53Gj0Dt8qfoCHrQF2q0YLGadFHWJPRyKyx1xXE8AzWRNqbXv7dmiDDQVoc7TTS2734=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQqma-006uH7-VD; Thu, 16 Sep 2021 14:46:28 +0200
Date:   Thu, 16 Sep 2021 14:46:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Heimpold <mhei@heimpold.de>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] net: vertexcom: Add MSE102x SPI support
Message-ID: <YUM8pAkt7kxD7owG@lunn.ch>
References: <20210914151717.12232-1-stefan.wahren@i2se.com>
 <20210914151717.12232-4-stefan.wahren@i2se.com>
 <YUJi0cVawjyiteEx@lunn.ch>
 <20210916112618.Horde.UWH1AKpXpmAwqSTq8U1y-WN@www.mhei.heimpold.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916112618.Horde.UWH1AKpXpmAwqSTq8U1y-WN@www.mhei.heimpold.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 11:26:18AM +0000, Michael Heimpold wrote:
> Hi Andrew,
> 
> Zitat von Andrew Lunn <andrew@lunn.ch>:
> 
> > > +static int mse102x_probe_spi(struct spi_device *spi)
> > > +{
> > 
> > ...
> > 
> > > +	netif_carrier_off(mse->ndev);
> > > +	ndev->if_port = IF_PORT_10BASET;
> > 
> > That is not correct. Maybe you should add a IF_PORT_HOMEPLUG ?
> 
> Would a simple IF_PORT_HOMEPLUG be sufficient, or should it be
> more precise as for Ethernet (10BASET, 100BASET...), e.g.
> IF_PORT_HOMEPLUG_10
> IF_PORT_HOMEPLUG_AV
> IF_PORT_HOMEPLUG_AV2
> IF_PORT_HOMEPLUG_GREENPHY

It is an interesting question. I think the first thing to find out is,
what in userspace actually uses this. If it is a deprecated tool, i
would not spend the energy.

Probably a better interface is ethtool get_link_ksettings, and
set_link_ksettings.

$ /sbin/ethtool enp3s0
Settings for enp3s0:
	Supported ports: [ TP	 MII ]
	Supported link modes:   10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Full

You can set supported ports to HomePlug, and supported link modes to
10, AV, AV2, GREENPHY etc.

Is there a negotiation mechanism where different homeplug devices can
find out what they have in common and select a mode? That would be
very similar to Ethernet autoneg, so you can make use of the other
fields ethtool provides to show this information, etc.

       Andrew


