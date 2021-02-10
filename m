Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73748315B57
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhBJAfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:35:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59014 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233826AbhBJA3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 19:29:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9dN7-005CzA-Vx; Wed, 10 Feb 2021 01:28:45 +0100
Date:   Wed, 10 Feb 2021 01:28:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mickey Rachamim <mickeyr@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [EXT] Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG
 support
Message-ID: <YCMovY0veFPIQkTB@lunn.ch>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
 <20210203165458.28717-6-vadym.kochan@plvision.eu>
 <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87v9b249oq.fsf@waldekranz.com>
 <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YCKVAtu2Y8DAInI+@lunn.ch>
 <20210209093500.53b55ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN6PR18MB158781B17E633670912AEED6BA8E9@BN6PR18MB1587.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR18MB158781B17E633670912AEED6BA8E9@BN6PR18MB1587.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Right at the beginning - we implemented PP function into the Kernel
> driver like the SDMA operation (This is the RX/TX DMA engine).

> We do plan to port more and more PP functions as Kernel drivers
> along the way.

It will be interesting to see how well you manage to handle the 'split
brain' problem.

DMA packets to/from the host is pretty isolated from the rest of the
driver. Look at DSA, it has completely separate drivers. But when you
start having parts of the control plain in the driver poking switch
registers, and parts of the control plane in the SDK poking registers,
you have an interesting synchronisation problem.

I guess stats would be a good place to start. Throw away the current
code making an RPC into the SDK, and just directly get the values from
the registers. No real synchronisation problems there. In fact, most
of the ethtool get API calls should be reasonably easy to do via
direct hardware access, rather than using the SDK RPC. Getting values
like that should be easy to synchronise.

     Andrew
