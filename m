Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6CB33F77E
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhCQRt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:49:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33222 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232483AbhCQRtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 13:49:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lMaIR-00BV78-QU; Wed, 17 Mar 2021 18:49:27 +0100
Date:   Wed, 17 Mar 2021 18:49:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: mdio: Add BCM6368 MDIO mux bus controller
Message-ID: <YFJBJ1IHpkXXaGvc@lunn.ch>
References: <20210308184102.3921-1-noltari@gmail.com>
 <20210308184102.3921-3-noltari@gmail.com>
 <YEaQdXwrmVekXp4G@lunn.ch>
 <D39D163A-C6B3-4B66-B650-8FF0A06EF7A2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D39D163A-C6B3-4B66-B650-8FF0A06EF7A2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> BCM6368 (and newer) SoCs have an integrated ethernet switch controller with dedicated internal phys, but it also supports connecting to external phys not integrated in the internal switch.
> Ports 0-3 are internal, ports 4-7 are external and can be connected to external switches or phys and port 8 is the CPU.
> This MDIO bus device is integrated in the BCM63xx switch registers, which corresponds to the same registers present in drivers/net/dsa/b53/b53_regs.h.
> As you can see in the source code, registers are the same for the internal and external bus. The only difference is that if MDIOC_EXT_MASK (bit 16) is set, the MDIO bus accessed will be the external, and on the contrary, if bit 16 isn’t set, the MDIO bus accessed will be the internal one.
> 
> I don’t know if this answers your question, but I think that adding it as mdiomux is the way to go.

Hi Álvaro

The Marvell mv88e6390 family of switches has a very similar setup. An
internal and an external MDIO bus, one bit difference in a
register. When i wrote the code for that, i decided it was not a mux
as such, but two MDIO busses. So i register two MDIO busses, and rely
on a higher level switch register mutex to prevent parallel operations
on the two busses.

The reason i decided it was not a mux, is that all the other mux
drivers are separate drivers which rely on another MDIO bus
driver. The mux driver gets a handle to the underlying MDIO bus
driver, and and builds on it. Here you have it all combined in one, so
it does not follow the pattern.

So if you want to use a max, please break this up into an MDIO driver,
and a mux driver. Or have one driver which registers two mdio busses,
no mux.

   Andrew
