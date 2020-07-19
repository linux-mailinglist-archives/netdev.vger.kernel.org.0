Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398EE22527A
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 17:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgGSP2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 11:28:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43560 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgGSP2y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 11:28:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxBFA-005t0I-Oa; Sun, 19 Jul 2020 17:28:48 +0200
Date:   Sun, 19 Jul 2020 17:28:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Rowe <martin.p.rowe@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Gregory Clement <gregory.clement@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: fix in-band AN link
 establishment
Message-ID: <20200719152848.GH1383417@lunn.ch>
References: <E1jx73b-0006mh-Ox@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jx73b-0006mh-Ox@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 12:00:35PM +0100, Russell King wrote:
> If in-band negotiation or fixed-link modes are specified for a DSA
> port, the DSA code will force the link down during initialisation. For
> fixed-link mode, this is fine, as phylink will manage the link state.
> However, for in-band mode, phylink expects the PCS to detect link,
> which will not happen if the link is forced down.
> 
> There is a related issue that in in-band mode, the link could come up
> while we are making configuration changes, so we should force the link
> down prior to reconfiguring the interface mode.
> 
> This patch addresses both issues.
> 
> Fixes: 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink will control")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 20 +++++++++++++++++---
>  drivers/net/dsa/mv88e6xxx/chip.h |  1 +
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 0bce26f1df93..9c7b8cf0e39a 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -664,6 +664,7 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
>  				 const struct phylink_link_state *state)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct mv88e6xxx_port *p = &chip->ports[port];
>  	int err;

David might not like the reverse christmas tree breakage, but:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
