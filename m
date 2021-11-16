Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107E2453C2A
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 23:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhKPWSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 17:18:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230484AbhKPWSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 17:18:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hodBCJqu6DrYhRyFZgnOax5xrSZCHSnQVs9tmJudSdU=; b=mknBv1g28v8YIZCaSKyS+jkYJB
        yd0ueYWiA1nFKZTT1mvhbLE/gXGwKBtMIFiYl1u58oQxdTPgNjgGSD1EadJKg5hRPOQnVmNfbe7rQ
        aNtDmjtjV5V5D3R2L82MrTd54pnrJq25naHiEB22VJsIAluba/AJpBHcNT4/HMd0eeQY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mn6jH-00Djdt-TU; Tue, 16 Nov 2021 23:15:03 +0100
Date:   Tue, 16 Nov 2021 23:15:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        Vincent Shih =?utf-8?B?5pa96YyV6bS7?= 
        <vincent.shih@sunplus.com>
Subject: Re: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YZQtZ4kMEGa+tFuU@lunn.ch>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <YY7/v1msiaqJF3Uy@lunn.ch>
 <452b9aa57d034bed988a685d320906c6@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <452b9aa57d034bed988a685d320906c6@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static const char def_mac_addr[ETHERNET_MAC_ADDR_LEN] = {
> > > +	0xfc, 0x4b, 0xbc, 0x00, 0x00, 0x00
> > 
> > This does not have the locally administered bit set. Should it? Or is this and address
> > from your OUI?
> 
> This is default MAC address when MAC address in NVMEM is not found.
> Fc:4b:bc:00:00:00 is OUI of "Sunplus Technology Co., Ltd.".
> Can I keep this? or it should be removed?

Please add a comment about whos OUI it is.

It is however more normal to use a random MAC address if no other MAC
address is available. That way, you avoid multiple devices on one LAN
using the same default MAC address.

> > > +	if (mac->next_ndev) {
> > > +		struct net_device *ndev2 = mac->next_ndev;
> > > +
> > > +		if (!netif_carrier_ok(ndev2) && (reg & PORT_ABILITY_LINK_ST_P1)) {
> > > +			netif_carrier_on(ndev2);
> > > +			netif_start_queue(ndev2);
> > > +		} else if (netif_carrier_ok(ndev2) && !(reg & PORT_ABILITY_LINK_ST_P1)) {
> > > +			netif_carrier_off(ndev2);
> > > +			netif_stop_queue(ndev2);
> > > +		}
> > 
> > Looks very odd. The two netdev should be independent.
> 
> I don't understand your comment.
> ndev checks PORT_ABILITY_LINK_ST_P0
> ndev2 checks PORT_ABILITY_LINK_ST_P1
> They are independent already.

I would try to remove the mac->next_ndev. I think without that, you
will get a cleaner abstraction. You might want to keep an array of mac
pointers in your top level shared structure.

	 Andrew
