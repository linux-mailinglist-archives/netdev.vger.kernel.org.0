Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE202CBD3E
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgLBMoG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 07:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729750AbgLBMoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:44:06 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5617C0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 04:43:25 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kkRTa-0002hW-Cy; Wed, 02 Dec 2020 13:43:18 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kkRTZ-0003Rz-EO; Wed, 02 Dec 2020 13:43:17 +0100
Date:   Wed, 2 Dec 2020 13:43:17 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201202124317.vehujtj2fdur2ed2@pengutronix.de>
References: <20201202120712.6212-1-o.rempel@pengutronix.de>
 <20201202120712.6212-3-o.rempel@pengutronix.de>
 <d3f790c6-d84c-f1bd-df6e-912ab64cce8c@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <d3f790c6-d84c-f1bd-df6e-912ab64cce8c@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:17:58 up  2:24, 17 users,  load average: 0.03, 0.06, 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 01:15:58PM +0100, Marc Kleine-Budde wrote:
> On 12/2/20 1:07 PM, Oleksij Rempel wrote:
> > Add stats support for the ar9331 switch.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/qca/ar9331.c | 242 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 241 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> > index e24a99031b80..1a8027bc9561 100644
> > --- a/drivers/net/dsa/qca/ar9331.c
> > +++ b/drivers/net/dsa/qca/ar9331.c
> > @@ -101,6 +101,57 @@
> >  	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
> >  	 AR9331_SW_PORT_STATUS_SPEED_M)
> >  
> > +/* MIB registers */
> > +#define AR9331_MIB_COUNTER(x)			(0x20000 + ((x) * 0x100))
> > +
> > +#define AR9331_PORT_MIB_rxbroad(_port)		(AR9331_MIB_COUNTER(_port) + 0x00)
> > +#define AR9331_PORT_MIB_rxpause(_port)		(AR9331_MIB_COUNTER(_port) + 0x04)
> > +#define AR9331_PORT_MIB_rxmulti(_port)		(AR9331_MIB_COUNTER(_port) + 0x08)
> > +#define AR9331_PORT_MIB_rxfcserr(_port)		(AR9331_MIB_COUNTER(_port) + 0x0c)
> > +#define AR9331_PORT_MIB_rxalignerr(_port)	(AR9331_MIB_COUNTER(_port) + 0x10)
> > +#define AR9331_PORT_MIB_rxrunt(_port)		(AR9331_MIB_COUNTER(_port) + 0x14)
> > +#define AR9331_PORT_MIB_rxfragment(_port)	(AR9331_MIB_COUNTER(_port) + 0x18)
> > +#define AR9331_PORT_MIB_rx64byte(_port)		(AR9331_MIB_COUNTER(_port) + 0x1c)
> > +#define AR9331_PORT_MIB_rx128byte(_port)	(AR9331_MIB_COUNTER(_port) + 0x20)
> > +#define AR9331_PORT_MIB_rx256byte(_port)	(AR9331_MIB_COUNTER(_port) + 0x24)
> > +#define AR9331_PORT_MIB_rx512byte(_port)	(AR9331_MIB_COUNTER(_port) + 0x28)
> > +#define AR9331_PORT_MIB_rx1024byte(_port)	(AR9331_MIB_COUNTER(_port) + 0x2c)
> > +#define AR9331_PORT_MIB_rx1518byte(_port)	(AR9331_MIB_COUNTER(_port) + 0x30)
> > +#define AR9331_PORT_MIB_rxmaxbyte(_port)	(AR9331_MIB_COUNTER(_port) + 0x34)
> > +#define AR9331_PORT_MIB_rxtoolong(_port)	(AR9331_MIB_COUNTER(_port) + 0x38)
> > +
> > +/* 64 bit counter */
> > +#define AR9331_PORT_MIB_rxgoodbyte(_port)	(AR9331_MIB_COUNTER(_port) + 0x3c)
> > +
> > +/* 64 bit counter */
> > +#define AR9331_PORT_MIB_rxbadbyte(_port)	(AR9331_MIB_COUNTER(_port) + 0x44)
> > +
> > +#define AR9331_PORT_MIB_rxoverflow(_port)	(AR9331_MIB_COUNTER(_port) + 0x4c)
> > +#define AR9331_PORT_MIB_filtered(_port)		(AR9331_MIB_COUNTER(_port) + 0x50)
> > +#define AR9331_PORT_MIB_txbroad(_port)		(AR9331_MIB_COUNTER(_port) + 0x54)
> > +#define AR9331_PORT_MIB_txpause(_port)		(AR9331_MIB_COUNTER(_port) + 0x58)
> > +#define AR9331_PORT_MIB_txmulti(_port)		(AR9331_MIB_COUNTER(_port) + 0x5c)
> > +#define AR9331_PORT_MIB_txunderrun(_port)	(AR9331_MIB_COUNTER(_port) + 0x60)
> > +#define AR9331_PORT_MIB_tx64byte(_port)		(AR9331_MIB_COUNTER(_port) + 0x64)
> > +#define AR9331_PORT_MIB_tx128byte(_port)	(AR9331_MIB_COUNTER(_port) + 0x68)
> > +#define AR9331_PORT_MIB_tx256byte(_port)	(AR9331_MIB_COUNTER(_port) + 0x6c)
> > +#define AR9331_PORT_MIB_tx512byte(_port)	(AR9331_MIB_COUNTER(_port) + 0x70)
> > +#define AR9331_PORT_MIB_tx1024byte(_port)	(AR9331_MIB_COUNTER(_port) + 0x74)
> > +#define AR9331_PORT_MIB_tx1518byte(_port)	(AR9331_MIB_COUNTER(_port) + 0x78)
> > +#define AR9331_PORT_MIB_txmaxbyte(_port)	(AR9331_MIB_COUNTER(_port) + 0x7c)
> > +#define AR9331_PORT_MIB_txoversize(_port)	(AR9331_MIB_COUNTER(_port) + 0x80)
> > +
> > +/* 64 bit counter */
> > +#define AR9331_PORT_MIB_txbyte(_port)		(AR9331_MIB_COUNTER(_port) + 0x84)
> > +
> > +#define AR9331_PORT_MIB_txcollision(_port)	(AR9331_MIB_COUNTER(_port) + 0x8c)
> > +#define AR9331_PORT_MIB_txabortcol(_port)	(AR9331_MIB_COUNTER(_port) + 0x90)
> > +#define AR9331_PORT_MIB_txmulticol(_port)	(AR9331_MIB_COUNTER(_port) + 0x94)
> > +#define AR9331_PORT_MIB_txsinglecol(_port)	(AR9331_MIB_COUNTER(_port) + 0x98)
> > +#define AR9331_PORT_MIB_txexcdefer(_port)	(AR9331_MIB_COUNTER(_port) + 0x9c)
> > +#define AR9331_PORT_MIB_txdefer(_port)		(AR9331_MIB_COUNTER(_port) + 0xa0)
> > +#define AR9331_PORT_MIB_txlatecol(_port)	(AR9331_MIB_COUNTER(_port) + 0xa4)
> > +
> >  /* Phy bypass mode
> >   * ------------------------------------------------------------------------
> >   * Bit:   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |13 |14 |15 |
> > @@ -154,6 +205,59 @@
> >  #define AR9331_SW_MDIO_POLL_SLEEP_US		1
> >  #define AR9331_SW_MDIO_POLL_TIMEOUT_US		20
> >  
> > +#define STATS_INTERVAL_JIFFIES			(100 * HZ)
> > +
> > +struct ar9331_sw_stats {
> > +	u64 rxbroad;
> > +	u64 rxpause;
> > +	u64 rxmulti;
> > +	u64 rxfcserr;
> > +	u64 rxalignerr;
> > +	u64 rxrunt;
> > +	u64 rxfragment;
> > +	u64 rx64byte;
> > +	u64 rx128byte;
> > +	u64 rx256byte;
> > +	u64 rx512byte;
> > +	u64 rx1024byte;
> > +	u64 rx1518byte;
> > +	u64 rxmaxbyte;
> > +	u64 rxtoolong;
> > +	u64 rxgoodbyte;
> > +	u64 rxbadbyte;
> > +	u64 rxoverflow;
> > +	u64 filtered;
> > +	u64 txbroad;
> > +	u64 txpause;
> > +	u64 txmulti;
> > +	u64 txunderrun;
> > +	u64 tx64byte;
> > +	u64 tx128byte;
> > +	u64 tx256byte;
> > +	u64 tx512byte;
> > +	u64 tx1024byte;
> > +	u64 tx1518byte;
> > +	u64 txmaxbyte;
> > +	u64 txoversize;
> > +	u64 txbyte;
> > +	u64 txcollision;
> > +	u64 txabortcol;
> > +	u64 txmulticol;
> > +	u64 txsinglecol;
> > +	u64 txexcdefer;
> > +	u64 txdefer;
> > +	u64 txlatecol;
> > +};
> > +
> > +struct ar9331_sw_priv;
> > +struct ar9331_sw_port {
> > +	int idx;
> > +	struct ar9331_sw_priv *priv;
> > +	struct delayed_work mib_read;
> > +	struct ar9331_sw_stats stats;
> > +	struct mutex lock;		/* stats access */
> 
> What does the lock protect? It's only used a single time.

The ar9331_read_stats() function is called from two different contests:
from worker over ar9331_do_stats_poll() and from user space over
ar9331_get_stats64().

The mutex lock should prevent a race in the read modify write operations
for in the stats->*

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
