Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D612C5E7E
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 01:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392092AbgK0AzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 19:55:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392082AbgK0AzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 19:55:11 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kiS2Q-00943w-S0; Fri, 27 Nov 2020 01:55:02 +0100
Date:   Fri, 27 Nov 2020 01:55:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on i.MX28
 SoC
Message-ID: <20201127005502.GQ2075216@lunn.ch>
References: <20201125232459.378-1-lukma@denx.de>
 <20201126123027.ocsykutucnhpmqbt@skbuf>
 <20201127003549.3753d64a@jawa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127003549.3753d64a@jawa>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> (A side question - DSA uses switchdev, so when one shall use switchdev
> standalone?)

DSA gives you a framework for an Ethernet switch connected to a host
via Ethernet for the data plane. Generally, that Ethernet link to the
switch is a MAC to MAC connection. It can be PHY to PHY. But those are
just details. The important thing is you use an Ethernet driver on the
host.

If you look at pure switchdev devices, they generally DMA frames
directly into the switch. There is either one DMA queue per switch
port, or there is a way to multiplex frames over one DMA queue,
generally by additional fields in the buffer descriptor.

For this device, at the moment, it is hard to say which is the best
fit. A lot will depend on how the FEC driver works, if you can reuse
it, while still having the degree of control you need over the DMA
channel. If you can reuse the FEC driver, then a DSA driver might
work. If the coupling it too loose, and you have to take control of
the DMA, then a pure switchdev driver seems more appropriate.

    Andrew

