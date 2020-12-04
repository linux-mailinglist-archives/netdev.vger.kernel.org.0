Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94E22CF6A3
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgLDWNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:13:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLDWNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 17:13:47 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1klJJx-00AGxT-JU; Fri, 04 Dec 2020 23:12:57 +0100
Date:   Fri, 4 Dec 2020 23:12:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v4 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201204221257.GH2400258@lunn.ch>
References: <20201204145624.11713-1-o.rempel@pengutronix.de>
 <20201204145624.11713-3-o.rempel@pengutronix.de>
 <CAFSKS=Pq9=mNXGeTbcTOL-=rp8wWCS2qtHF38eD1HiN=EK0DOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=Pq9=mNXGeTbcTOL-=rp8wWCS2qtHF38eD1HiN=EK0DOQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +struct ar9331_sw_stats {
> > +       u64 rxbroad;
> > +       u64 rxpause;
> > +       u64 rxmulti;
> > +};

7> > +struct ar9331_sw_port {
> > +       int idx;
> > +       struct ar9331_sw_priv *priv;
> > +       struct delayed_work mib_read;
> > +       struct ar9331_sw_stats stats;


> > +static void ar9331_stats_update(struct ar9331_sw_port *port,
> > +                               struct rtnl_link_stats64 *stats)
> > +{
> > +       struct ar9331_sw_stats *s = &port->stats;
> > +
> > +       stats->rx_packets = s->rxbroad + s->rxmulti + s->rx64byte +
> > +               s->rx128byte + s->rx256byte + s->rx512byte + s->rx1024byte +
> > +               s->rx1518byte + s->rxmaxbyte;
> 
> Are all of these port->stats accesses always atomic? I'll need to do
> something similar in my xrs700x driver and want to make sure there
> doesn't need to be a lock between here and where they're updated in
> the delayed work.

Since these are u64, they are not atomic on 32 bit systems.

Take a look at

include/linux/u64_stats_sync.h

	Andrewu
