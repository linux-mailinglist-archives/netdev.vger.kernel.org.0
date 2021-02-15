Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCB531BA92
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 14:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhBONvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 08:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhBONvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 08:51:18 -0500
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E77C0617A7
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 05:48:00 -0800 (PST)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 5DCB0140AA3;
        Mon, 15 Feb 2021 14:47:57 +0100 (CET)
Date:   Mon, 15 Feb 2021 14:47:56 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, Nathan Rossi <nathan.rossi@digi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: prevent 2500BASEX mode override
Message-ID: <20210215144756.76846c9b@nic.cz>
In-Reply-To: <20210215061559.1187396-1-nathan@nathanrossi.com>
References: <20210215061559.1187396-1-nathan@nathanrossi.com>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Feb 2021 06:15:59 +0000
Nathan Rossi <nathan@nathanrossi.com> wrote:

> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 54aa942eed..5c52906b29 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -650,6 +650,13 @@ static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
>  	if (chip->info->ops->phylink_validate)
>  		chip->info->ops->phylink_validate(chip, port, mask, state);
>  
> +	/* Advertise 2500BASEX only if 1000BASEX is not configured, this
> +	 * prevents phylink_helper_basex_speed from always overriding the
> +	 * 1000BASEX mode since auto negotiation is always enabled.
> +	 */
> +	if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
> +		phylink_clear(mask, 2500baseX_Full);
> +

I don't quite like this. This problem should be either solved in
phylink_helper_basex_speed() or somewhere in the mv88e6xxx code, but near
the call to phylink_helper_basex_speed().

Putting a solution to the behaviour of phylink_helper_basex_speed() it
into the validate() method when phylink_helper_basex_speed() is called
from a different place will complicate debugging in the future. If
we start solving problems in this kind of way, the driver will become
totally unreadable, IMO.

Marek
