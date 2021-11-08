Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39321449B34
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhKHR7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:59:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51150 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232511AbhKHR7y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:59:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SoHwG/cDZY0rUU5AEO3/6uKAl70lB2c4C5PXVLfeE1c=; b=F1WgcplSDbfMrP6uBdJE2rVBQh
        ty9E++2T/RgqU98vAmTXd1pN1iRcYl2jWXxUjlQ/lU2wyNf6AvRu87wW1nCvx2qOJ3JNMyQFKxKSE
        aN/jL8tdONn1UoZz4YnYZgqZaL31+N7iASleoIb7wzsHANTJm9QVbAVElbJgMhw4LZyU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mk8tF-00Cv3f-R6; Mon, 08 Nov 2021 18:57:05 +0100
Date:   Mon, 8 Nov 2021 18:57:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bastian Germann <bage@linutronix.de>
Cc:     Benedikt Spranger <b.spranger@linutronix.de>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't
 discard phy_start_aneg's return
Message-ID: <YYlk8Rv85h0Ia/LT@lunn.ch>
References: <20211105153648.8337-1-bage@linutronix.de>
 <20211108141834.19105-1-bage@linutronix.de>
 <YYkzbE39ERAxzg4k@shell.armlinux.org.uk>
 <20211108160653.3d6127df@mitra>
 <YYlLvhE6/wjv8g3z@lunn.ch>
 <63e5522a-f420-28c4-dd60-ce317dbbdfe0@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63e5522a-f420-28c4-dd60-ce317dbbdfe0@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It is BCM53125. Currently, you can set "mdix auto|off|on" which does
> not take any effect.  The chip will do what is its default depending
> on copper autonegotiation.
> 
> I am adding support for setting "mdix auto|off". I want the thing to error on "mdix on".
> Where would I add that check?

/* MDI or MDI-X status/control - if MDI/MDI_X/AUTO is set then
 * the driver is required to renegotiate link
 */
#define ETH_TP_MDI_INVALID	0x00 /* status: unknown; control: unsupported */
#define ETH_TP_MDI		0x01 /* status: MDI;     control: force MDI */
#define ETH_TP_MDI_X		0x02 /* status: MDI-X;   control: force MDI-X */
#define ETH_TP_MDI_AUTO		0x03 /*                  control: auto-select */

So there are three valid settings. And you are saying you only want to
implement two of them? If the hardware can do all three, you should
implement all three.

	  Andrew


