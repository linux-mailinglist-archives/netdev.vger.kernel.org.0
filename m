Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F267C36A1D7
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 17:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhDXPwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 11:52:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39354 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232434AbhDXPwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 11:52:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1laKZR-000pmO-DV; Sat, 24 Apr 2021 17:51:49 +0200
Date:   Sat, 24 Apr 2021 17:51:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v6 04/10] net: dsa: microchip: ksz8795: add
 support for ksz88xx chips
Message-ID: <YIQ+lWrb+66Ky4p9@lunn.ch>
References: <20210423080218.26526-1-o.rempel@pengutronix.de>
 <20210423080218.26526-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423080218.26526-5-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 10:02:12AM +0200, Oleksij Rempel wrote:
> We add support for the ksz8863 and ksz8873 chips which are
> using the same register patterns but other offsets as the
> ksz8795.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> ---
> v1 -> v4: - extracted this change from bigger previous patch
> v4 -> v5: - added clear of reset bit for ksz8863 reset code
>           - using extra device flag IS_KSZ88x3 instead of is_ksz8795 function
>           - using DSA_TAG_PROTO_KSZ9893 protocol for ksz88x3 instead
> v5 -> v6: - changed variable order to revers christmas tree
> 	  - added back missed dropped handling in init_cnt for ksz8863
>           - disable VLAN support for ksz8863. Currently it need more
>             work.
> ---
>  drivers/net/dsa/microchip/ksz8795.c     | 321 ++++++++++++++++++++----
>  drivers/net/dsa/microchip/ksz8795_reg.h |  40 ++-
>  drivers/net/dsa/microchip/ksz_common.h  |   1 +
>  3 files changed, 286 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 8835217e2804..78181d29db12 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -22,6 +22,9 @@
>  #include "ksz8795_reg.h"
>  #include "ksz8.h"
>  
> +/* Used with variable features to indicate capabilities. */
> +#define IS_88X3				BIT(0)

How well is this going to scale? With only two devices, this is
O.K. But when you add a third, you are probably going to want to use a
switch statement, and that is not so easy with bits. I think an enum
makes this more future proof.

      Andrew
