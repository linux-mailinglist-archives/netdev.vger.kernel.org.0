Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202BF353488
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 17:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbhDCPZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 11:25:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32854 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236621AbhDCPZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Apr 2021 11:25:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lSi9E-00EeCt-10; Sat, 03 Apr 2021 17:25:16 +0200
Date:   Sat, 3 Apr 2021 17:25:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v1 5/9] net: dsa: qca: ar9331: add forwarding
 database support
Message-ID: <YGiI3JtqU7Ezlbxb@lunn.ch>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403114848.30528-6-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ar9331_sw_port_fdb_rmw(struct ar9331_sw_priv *priv,
> +				  const unsigned char *mac,
> +				  u8 port_mask_set,
> +				  u8 port_mask_clr)
> +{
> +	port_mask = FIELD_GET(AR9331_SW_AT_DES_PORT, f2);
> +	status = FIELD_GET(AR9331_SW_AT_STATUS, f2);
> +	if (status > 0 && status < AR9331_SW_AT_STATUS_STATIC) {
> +		dev_err_ratelimited(priv->dev, "%s: found existing dynamic entry on %x\n",
> +				    __func__, port_mask);
> +
> +		if (port_mask_set && port_mask_set != port_mask)
> +			dev_err_ratelimited(priv->dev, "%s: found existing dynamic entry on %x, replacing it with static on %x\n",
> +					    __func__, port_mask, port_mask_set);
> +		port_mask = 0;
> +	} else if (!status && !port_mask_set) {
> +		return 0;
> +	}

As a generate rule of thumb, use rate limiting where you have no
control of the number of prints, e.g. it is triggered by packet
processing, and there is potentially a lot of them, which could DOS
the box by a remote or unprivileged attacker.

FDB changes should not happen often. Yes, root my be able to DOS the
box by doing bridge fdb add commands in a loop, but only root should
be able to do that.

Plus, i'm not actually sure we should be issuing warnings here. What
does the bridge code do in this case? Is it silent and just does it,
or does it issue a warning?




> +
> +	port_mask_new = port_mask & ~port_mask_clr;
> +	port_mask_new |= port_mask_set;
> +
> +	if (port_mask_new == port_mask &&
> +	    status == AR9331_SW_AT_STATUS_STATIC) {
> +		dev_info(priv->dev, "%s: no need to overwrite existing valid entry on %x\n",
> +				    __func__, port_mask_new);

This one should probably be dev_dbg().

     Andrew
