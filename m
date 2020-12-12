Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E792D88DB
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 19:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439607AbgLLSBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 13:01:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbgLLSBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 13:01:30 -0500
Date:   Sat, 12 Dec 2020 10:00:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607796049;
        bh=S3eThU5DZW64V0rbc0rg8TngRTlVEbT08spoA0s5ET0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=hgsIgdEbh9YkfeVZq8wq49gSCQivPsZl1i3UFuYKzMyWPMB1j2cwiuO2Kl+FNCGbK
         wJqowWwZXRpqj5IfCEWvt06CkMZPlKUMXHD5IK1+hC0LNJmjxPMwBAOkhq7lnX34r1
         5byDp9NnEa+Hk9oTkZReKOdUMAr4jv6vwa1PsnKxU7yOauTPSxOY5DPODE7iyUxobw
         hADSzHiV0TTGP2yoRcFT2BUART9HA7RU8JJLfLoL8AmgTDQ/YzuZETX0SCxnPQKtx2
         LyfFbALHKQs/VofC3DFg82Lv8AmAK0cK39+J5ZV2QfsrpTLzBbvcgY6SSBaJUIFZZT
         WEwa6FQqCi2Ig==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v5 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201212100047.1b6afb78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212134852.gwkugi372afazcd5@skbuf>
References: <20201211105322.7818-1-o.rempel@pengutronix.de>
        <20201211105322.7818-3-o.rempel@pengutronix.de>
        <20201212134852.gwkugi372afazcd5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Dec 2020 15:48:52 +0200 Vladimir Oltean wrote:
> > +	stats->rx_packets = u64_stats_read(&s->rx64byte) +
> > +		u64_stats_read(&s->rx128byte) + u64_stats_read(&s->rx256byte) +
> > +		u64_stats_read(&s->rx512byte) + u64_stats_read(&s->rx1024byte) +
> > +		u64_stats_read(&s->rx1518byte) + u64_stats_read(&s->rxmaxbyte);
> > +	stats->tx_packets = u64_stats_read(&s->tx64byte) +
> > +		u64_stats_read(&s->tx128byte) + u64_stats_read(&s->tx256byte) +
> > +		u64_stats_read(&s->tx512byte) + u64_stats_read(&s->tx1024byte) +
> > +		u64_stats_read(&s->tx1518byte) + u64_stats_read(&s->txmaxbyte);
> > +	stats->rx_bytes = u64_stats_read(&s->rxgoodbyte);
> > +	stats->tx_bytes = u64_stats_read(&s->txbyte);
> > +	stats->rx_errors = u64_stats_read(&s->rxfcserr) +
> > +		u64_stats_read(&s->rxalignerr) + u64_stats_read(&s->rxrunt) +
> > +		u64_stats_read(&s->rxfragment) + u64_stats_read(&s->rxoverflow);
> > +	stats->tx_errors = u64_stats_read(&s->txoversize);  
> 
> Should tx_errors not also include tx_aborted_errors, tx_fifo_errors,
> tx_window_errors?

Yes.

> > +	stats->multicast = u64_stats_read(&s->rxmulti);
> > +	stats->collisions = u64_stats_read(&s->txcollision);
> > +	stats->rx_length_errors = u64_stats_read(&s->rxrunt) +
> > +		u64_stats_read(&s->rxfragment) + u64_stats_read(&s->rxtoolong);
> > +	stats->rx_crc_errors = u64_stats_read(&s->rxfcserr) +
> > +		u64_stats_read(&s->rxalignerr) + u64_stats_read(&s->rxfragment);

Why would CRC errors include alignment errors and rxfragments?

Besides looks like rxfragment is already counted to length errors.

> > +	stats->rx_frame_errors = u64_stats_read(&s->rxalignerr);
> > +	stats->rx_missed_errors = u64_stats_read(&s->rxoverflow);
> > +	stats->tx_aborted_errors = u64_stats_read(&s->txabortcol);
> > +	stats->tx_fifo_errors = u64_stats_read(&s->txunderrun);
> > +	stats->tx_window_errors = u64_stats_read(&s->txlatecol);
> > +	stats->rx_nohandler = u64_stats_read(&s->filtered);  
> 
> Should rx_nohandler not be also included in rx_errors?

I don't think drivers should ever touch rx_nohandler, it's a pretty
specific SW stat. But you made me realize that we never specified where
to count frames discarded due to L2 address filtering. It appears that
high speed adapters I was looking at don't have such statistic?

I would go with rx_dropped, if that's what ->filtered is.

We should probably update the doc like this:

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 874cc12a34d9..82708c6db432 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -75,8 +75,9 @@ struct rtnl_link_stats {
  *
  * @rx_dropped: Number of packets received but not processed,
  *   e.g. due to lack of resources or unsupported protocol.
- *   For hardware interfaces this counter should not include packets
- *   dropped by the device which are counted separately in
+ *   For hardware interfaces this counter may include packets discarded
+ *   due to L2 address filtering but should not include packets dropped
+ *   by the device due to buffer exhaustion which are counted separately in
  *   @rx_missed_errors (since procfs folds those two counters together).
  *
  * @tx_dropped: Number of packets dropped on their way to transmission,


> You can probably avoid reading a few of these twice by assigning the
> more specific ones first, then the rx_errors and tx_errors at the end.
