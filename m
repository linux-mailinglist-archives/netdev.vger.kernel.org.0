Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098C12C743B
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389089AbgK1Vtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54538 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730912AbgK1SqD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 13:46:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kj5De-009HGC-O0; Sat, 28 Nov 2020 19:45:14 +0100
Date:   Sat, 28 Nov 2020 19:45:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201128184514.GD2191767@lunn.ch>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127133307.2969817-3-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Add a potentially wrapping 32 bit value to a 64 bit counter */
> +static inline void sparx5_update_counter(u64 *cnt, u32 val)
> +{
> +	if (val < (*cnt & U32_MAX))
> +		*cnt += (u64)1 << 32; /* value has wrapped */
> +
> +	*cnt = (*cnt & ~(u64)U32_MAX) + val;
> +}

I don't follow what this is doing. Could you give some examples?

> +static const char *const sparx5_stats_layout[] = {
> +	"rx_in_bytes",
> +	"rx_symbol_err",
> +	"rx_pause",
> +	"rx_unsup_opcode",

> +static void sparx5_update_port_stats(struct sparx5 *sparx5, int portno)
> +{
> +	struct sparx5_port *spx5_port = sparx5->ports[portno];
> +	bool high_speed_dev = sparx5_is_high_speed_device(&spx5_port->conf);

Reverse christmas tree. Which in this case, means you need to move the
assignment into the body of the code.

> +static void sparx5_get_sset_strings(struct net_device *ndev, u32 sset, u8 *data)
> +{
> +	struct sparx5_port *port = netdev_priv(ndev);
> +	struct sparx5  *sparx5 = port->sparx5;
> +	int idx;
> +
> +	if (sset != ETH_SS_STATS)
> +		return;
> +
> +	for (idx = 0; idx < sparx5->num_stats; idx++)
> +		memcpy(data + idx * ETH_GSTRING_LEN,
> +		       sparx5->stats_layout[idx], ETH_GSTRING_LEN);

You cannot use memcpy here, because the strings you have defined are
not ETH_GSTRING_LEN long. We once had a driver which happened to have
its strings at the end of a page. The memcpy would copy the string,
but keep going passed the end of string, over the page boundary, and
trigger a segmentation fault.

	Andrew
