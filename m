Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA88200A02
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732785AbgFSN1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:27:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48868 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbgFSN1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 09:27:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmH2p-001HFC-AH; Fri, 19 Jun 2020 15:26:59 +0200
Date:   Fri, 19 Jun 2020 15:26:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Dajun Jin <adajunjin@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE" 
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH net 2/2] net: phy: Check harder for errors in get_phy_id()
Message-ID: <20200619132659.GB304147@lunn.ch>
References: <20200619044759.11387-1-f.fainelli@gmail.com>
 <20200619044759.11387-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619044759.11387-3-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 09:47:59PM -0700, Florian Fainelli wrote:
> Commit 02a6efcab675 ("net: phy: allow scanning busses with missing
> phys") added a special condition to return -ENODEV in case -ENODEV or
> -EIO was returned from the first read of the MII_PHYSID1 register.
> 
> In case the MDIO bus data line pull-up is not strong enough, the MDIO
> bus controller will not flag this as a read error. This can happen when
> a pluggable daughter card is not connected and weak internal pull-ups
> are used (since that is the only option, otherwise the pins are
> floating).
> 
> The second read of MII_PHYSID2 will be correctly flagged an error
> though, but now we will return -EIO which will be treated as a hard
> error, thus preventing MDIO bus scanning loops to continue succesfully.
> 
> Apply the same logic to both register reads, thus allowing the scanning
> logic to proceed.

Hi Florian

Maybe extend the kerneldoc for this function to document the return
values and there special meanings?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

BTW: Did you look at get_phy_c45_ids()? Is it using the correct return
value? Given the current work being done to extend scanning to C45,
maybe it needs reviewing for issues like this.

    Andrew
