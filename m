Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204592CFD0F
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgLESTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:19:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbgLERxl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 12:53:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1klYjB-00AMn1-ND; Sat, 05 Dec 2020 15:40:01 +0100
Date:   Sat, 5 Dec 2020 15:40:01 +0100
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
Subject: Re: [PATCH v4 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201205144001.GK2420376@lunn.ch>
References: <20201204145624.11713-1-o.rempel@pengutronix.de>
 <20201204145624.11713-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204145624.11713-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void ar9331_stats_update(struct ar9331_sw_port *port,
> +				struct rtnl_link_stats64 *stats)
> +{
> +	struct ar9331_sw_stats *s = &port->stats;
> +
> +	stats->rx_packets = s->rxbroad + s->rxmulti + s->rx64byte +
> +		s->rx128byte + s->rx256byte + s->rx512byte + s->rx1024byte +
> +		s->rx1518byte + s->rxmaxbyte;
> +	stats->tx_packets = s->txbroad + s->txmulti + s->tx64byte +
> +		s->tx128byte + s->tx256byte + s->tx512byte + s->tx1024byte +
> +		s->tx1518byte + s->txmaxbyte;
> +	stats->rx_bytes = s->rxgoodbyte;
> +	stats->tx_bytes = s->txbyte;
> +	stats->rx_errors = s->rxfcserr + s->rxalignerr + s->rxrunt +
> +		s->rxfragment + s->rxoverflow;
> +	stats->tx_errors = s->txoversize;
> +	stats->multicast = s->rxmulti;
> +	stats->collisions = s->txcollision;
> +	stats->rx_length_errors = s->rxrunt + s->rxfragment + s->rxtoolong;
> +	stats->rx_crc_errors = s->rxfcserr + s->rxalignerr + s->rxfragment;
> +	stats->rx_frame_errors = s->rxalignerr;
> +	stats->rx_missed_errors = s->rxoverflow;
> +	stats->tx_aborted_errors = s->txabortcol;
> +	stats->tx_fifo_errors = s->txunderrun;
> +	stats->tx_window_errors = s->txlatecol;
> +	stats->rx_nohandler = s->filtered;
> +}
> +

Since these are u64 and you cannot take the mutex, you need to using
include/linux/u64_stats_sync.h

	Andrew
