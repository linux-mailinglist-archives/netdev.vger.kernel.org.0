Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4393221C5C6
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 20:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgGKS3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 14:29:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58694 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgGKS3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 14:29:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juKFM-004eAj-D9; Sat, 11 Jul 2020 20:29:12 +0200
Date:   Sat, 11 Jul 2020 20:29:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 5/5] net: phy: micrel: ksz886x/ksz8081: add
 cabletest support
Message-ID: <20200711182912.GP1014141@lunn.ch>
References: <20200710120851.28984-1-o.rempel@pengutronix.de>
 <20200710120851.28984-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710120851.28984-6-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 02:08:51PM +0200, Oleksij Rempel wrote:
> This patch support for cable test for the ksz886x switches and the
> ksz8081 PHY.
> 
> The patch was tested on a KSZ8873RLL switch with following results:
> 
> - port 1:
>   - cannot detect any distance
>   - provides inverted values
>     (Errata: DS80000830A: "LinkMD does not work on Port 1",
>      http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8873-Errata-DS80000830A.pdf)
>     - Reports "short" on open or ok.
>     - Reports "ok" on short.
> 
> - port 2:
>   - can detect distance
>   - can detect open on each wire of pair A (wire 1 and 2)
>   - can detect open only on one wire of pair B (only wire 3)
>   - can detect short between wires of a pair (wires 1 + 2 or 3 + 6)
>   - short between pairs is detected as open.
>     For example short between wires 2 + 3 is detected as open.
> 
> In order to work around the errata for port 1, the ksz8795 switch driver
> should be extended to provide proper device tree support for the related
> PHY nodes. So we can set a DT property to mark the port 1 as affected by
> the errata.

Hi Oleksij

Do the PHY register read/writes pass through the DSA driver for the
8873?  I was wondering if the switch could intercept reads/writes on
port1 for KSZ8081_LMD and return EOPNOTSUPP? That would be a more
robust solution than DT properties, which are going to get forgotten.

      Andrew
