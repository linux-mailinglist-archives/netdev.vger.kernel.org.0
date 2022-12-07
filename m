Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6476453D7
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 07:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiLGGOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 01:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiLGGOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 01:14:16 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8560B58BC6
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 22:14:14 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p2nh5-0003N7-Nf; Wed, 07 Dec 2022 07:14:11 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p2nh3-0007QJ-Qu; Wed, 07 Dec 2022 07:14:09 +0100
Date:   Wed, 7 Dec 2022 07:14:09 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>, UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: add stats64 support
 for ksz8 series of switches
Message-ID: <20221207061409.GB19179@pengutronix.de>
References: <20221205052904.2834962-1-o.rempel@pengutronix.de>
 <20221205052904.2834962-1-o.rempel@pengutronix.de>
 <20221206170801.othuifyrm3qrz7ub@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221206170801.othuifyrm3qrz7ub@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 07:08:01PM +0200, Vladimir Oltean wrote:
> On Mon, Dec 05, 2022 at 06:29:04AM +0100, Oleksij Rempel wrote:
> > +void ksz88xx_r_mib_stats64(struct ksz_device *dev, int port)
> > +{
> > +	struct ethtool_pause_stats *pstats;
> > +	struct rtnl_link_stats64 *stats;
> > +	struct ksz88xx_stats_raw *raw;
> > +	struct ksz_port_mib *mib;
> > +
> > +	mib = &dev->ports[port].mib;
> > +	stats = &mib->stats64;
> > +	pstats = &mib->pause_stats;
> > +	raw = (struct ksz88xx_stats_raw *)mib->counters;
> > +
> > +	spin_lock(&mib->stats64_lock);
> > +
> > +	stats->rx_packets = raw->rx_bcast + raw->rx_mcast + raw->rx_ucast +
> > +		raw->rx_pause;
> > +	stats->tx_packets = raw->tx_bcast + raw->tx_mcast + raw->tx_ucast +
> > +		raw->tx_pause;
> > +
> > +	/* HW counters are counting bytes + FCS which is not acceptable
> > +	 * for rtnl_link_stats64 interface
> > +	 */
> > +	stats->rx_bytes = raw->rx + raw->rx_hi - stats->rx_packets * ETH_FCS_LEN;
> > +	stats->tx_bytes = raw->tx + raw->tx_hi - stats->tx_packets * ETH_FCS_LEN;
> 
> What are rx_hi, tx_hi compared to rx, tx?

rx, tx are packets with normal priority and rx_hi, tx_hi are packets
with high prio.

> > +
> > +	stats->rx_length_errors = raw->rx_undersize + raw->rx_fragments +
> > +		raw->rx_oversize;
> > +
> > +	stats->rx_crc_errors = raw->rx_crc_err;
> > +	stats->rx_frame_errors = raw->rx_align_err;
> > +	stats->rx_dropped = raw->rx_discards;
> > +	stats->rx_errors = stats->rx_length_errors + stats->rx_crc_errors +
> > +		stats->rx_frame_errors  + stats->rx_dropped;
> > +
> > +	stats->tx_window_errors = raw->tx_late_col;
> > +	stats->tx_fifo_errors = raw->tx_discards;
> > +	stats->tx_aborted_errors = raw->tx_exc_col;
> > +	stats->tx_errors = stats->tx_window_errors + stats->tx_fifo_errors +
> > +		stats->tx_aborted_errors;
> > +
> > +	stats->multicast = raw->rx_mcast;
> > +	stats->collisions = raw->tx_total_col;
> > +
> > +	pstats->tx_pause_frames = raw->tx_pause;
> > +	pstats->rx_pause_frames = raw->rx_pause;
> 
> FWIW, ksz_get_pause_stats() can sleep, just ksz_get_stats64() can't. So
> the pause stats don't need to be periodically read (unless you want to
> do that to prevent 32-bit overflows).

KSZ driver is using worker to read stats periodically. Since all needed
locks are already taken, I copy pause stats as well.

Otherwise it will need some different locking, which will make things
look different but do not reduce CPU load. 

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
