Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782F02D43EF
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732911AbgLIOHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729209AbgLIOHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:07:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF585C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 06:06:56 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kn07E-0004oj-76; Wed, 09 Dec 2020 15:06:48 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kn07C-0004QE-0q; Wed, 09 Dec 2020 15:06:46 +0100
Date:   Wed, 9 Dec 2020 15:06:45 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20201209140645.vjgllb46p7ue26ms@pengutronix.de>
References: <20201204145624.11713-1-o.rempel@pengutronix.de>
 <20201204145624.11713-3-o.rempel@pengutronix.de>
 <CAFSKS=OoOYQe_-TUePJVP0KURXr0YpKSFH=JFu_3VaO5kEbScw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFSKS=OoOYQe_-TUePJVP0KURXr0YpKSFH=JFu_3VaO5kEbScw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:05:52 up 7 days,  4:12, 26 users,  load average: 0.07, 0.06, 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi George,

On Fri, Dec 04, 2020 at 04:04:07PM -0600, George McCollister wrote:
> On Fri, Dec 4, 2020 at 8:59 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> >
> > Add stats support for the ar9331 switch.
> >
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/qca/ar9331.c | 247 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 246 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> > index 605d7b675216..4c1a4c448d80 100644
> > --- a/drivers/net/dsa/qca/ar9331.c
> > +++ b/drivers/net/dsa/qca/ar9331.c
> > @@ -101,6 +101,57 @@
> >          AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
> >          AR9331_SW_PORT_STATUS_SPEED_M)
> >
> > +/* MIB registers */
> > +#define AR9331_MIB_COUNTER(x)                  (0x20000 + ((x) * 0x100))
> > +
> > +#define AR9331_PORT_MIB_rxbroad(_port)         (AR9331_MIB_COUNTER(_port) + 0x00)
> > +#define AR9331_PORT_MIB_rxpause(_port)         (AR9331_MIB_COUNTER(_port) + 0x04)
> > +#define AR9331_PORT_MIB_rxmulti(_port)         (AR9331_MIB_COUNTER(_port) + 0x08)
> > +#define AR9331_PORT_MIB_rxfcserr(_port)                (AR9331_MIB_COUNTER(_port) + 0x0c)
> > +#define AR9331_PORT_MIB_rxalignerr(_port)      (AR9331_MIB_COUNTER(_port) + 0x10)
> > +#define AR9331_PORT_MIB_rxrunt(_port)          (AR9331_MIB_COUNTER(_port) + 0x14)
> > +#define AR9331_PORT_MIB_rxfragment(_port)      (AR9331_MIB_COUNTER(_port) + 0x18)
> > +#define AR9331_PORT_MIB_rx64byte(_port)                (AR9331_MIB_COUNTER(_port) + 0x1c)
> > +#define AR9331_PORT_MIB_rx128byte(_port)       (AR9331_MIB_COUNTER(_port) + 0x20)
> > +#define AR9331_PORT_MIB_rx256byte(_port)       (AR9331_MIB_COUNTER(_port) + 0x24)
> > +#define AR9331_PORT_MIB_rx512byte(_port)       (AR9331_MIB_COUNTER(_port) + 0x28)
> > +#define AR9331_PORT_MIB_rx1024byte(_port)      (AR9331_MIB_COUNTER(_port) + 0x2c)
> > +#define AR9331_PORT_MIB_rx1518byte(_port)      (AR9331_MIB_COUNTER(_port) + 0x30)
> > +#define AR9331_PORT_MIB_rxmaxbyte(_port)       (AR9331_MIB_COUNTER(_port) + 0x34)
> > +#define AR9331_PORT_MIB_rxtoolong(_port)       (AR9331_MIB_COUNTER(_port) + 0x38)
> > +
> > +/* 64 bit counter */
> > +#define AR9331_PORT_MIB_rxgoodbyte(_port)      (AR9331_MIB_COUNTER(_port) + 0x3c)
> > +
> > +/* 64 bit counter */
> > +#define AR9331_PORT_MIB_rxbadbyte(_port)       (AR9331_MIB_COUNTER(_port) + 0x44)
> > +
> > +#define AR9331_PORT_MIB_rxoverflow(_port)      (AR9331_MIB_COUNTER(_port) + 0x4c)
> > +#define AR9331_PORT_MIB_filtered(_port)                (AR9331_MIB_COUNTER(_port) + 0x50)
> > +#define AR9331_PORT_MIB_txbroad(_port)         (AR9331_MIB_COUNTER(_port) + 0x54)
> > +#define AR9331_PORT_MIB_txpause(_port)         (AR9331_MIB_COUNTER(_port) + 0x58)
> > +#define AR9331_PORT_MIB_txmulti(_port)         (AR9331_MIB_COUNTER(_port) + 0x5c)
> > +#define AR9331_PORT_MIB_txunderrun(_port)      (AR9331_MIB_COUNTER(_port) + 0x60)
> > +#define AR9331_PORT_MIB_tx64byte(_port)                (AR9331_MIB_COUNTER(_port) + 0x64)
> > +#define AR9331_PORT_MIB_tx128byte(_port)       (AR9331_MIB_COUNTER(_port) + 0x68)
> > +#define AR9331_PORT_MIB_tx256byte(_port)       (AR9331_MIB_COUNTER(_port) + 0x6c)
> > +#define AR9331_PORT_MIB_tx512byte(_port)       (AR9331_MIB_COUNTER(_port) + 0x70)
> > +#define AR9331_PORT_MIB_tx1024byte(_port)      (AR9331_MIB_COUNTER(_port) + 0x74)
> > +#define AR9331_PORT_MIB_tx1518byte(_port)      (AR9331_MIB_COUNTER(_port) + 0x78)
> > +#define AR9331_PORT_MIB_txmaxbyte(_port)       (AR9331_MIB_COUNTER(_port) + 0x7c)
> > +#define AR9331_PORT_MIB_txoversize(_port)      (AR9331_MIB_COUNTER(_port) + 0x80)
> > +
> > +/* 64 bit counter */
> > +#define AR9331_PORT_MIB_txbyte(_port)          (AR9331_MIB_COUNTER(_port) + 0x84)
> > +
> > +#define AR9331_PORT_MIB_txcollision(_port)     (AR9331_MIB_COUNTER(_port) + 0x8c)
> > +#define AR9331_PORT_MIB_txabortcol(_port)      (AR9331_MIB_COUNTER(_port) + 0x90)
> > +#define AR9331_PORT_MIB_txmulticol(_port)      (AR9331_MIB_COUNTER(_port) + 0x94)
> > +#define AR9331_PORT_MIB_txsinglecol(_port)     (AR9331_MIB_COUNTER(_port) + 0x98)
> > +#define AR9331_PORT_MIB_txexcdefer(_port)      (AR9331_MIB_COUNTER(_port) + 0x9c)
> > +#define AR9331_PORT_MIB_txdefer(_port)         (AR9331_MIB_COUNTER(_port) + 0xa0)
> > +#define AR9331_PORT_MIB_txlatecol(_port)       (AR9331_MIB_COUNTER(_port) + 0xa4)
> > +
> >  /* Phy bypass mode
> >   * ------------------------------------------------------------------------
> >   * Bit:   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |13 |14 |15 |
> > @@ -154,6 +205,59 @@
> >  #define AR9331_SW_MDIO_POLL_SLEEP_US           1
> >  #define AR9331_SW_MDIO_POLL_TIMEOUT_US         20
> >
> > +#define STATS_INTERVAL_JIFFIES                 (3 * HZ)
> > +
> > +struct ar9331_sw_stats {
> > +       u64 rxbroad;
> > +       u64 rxpause;
> > +       u64 rxmulti;
> > +       u64 rxfcserr;
> > +       u64 rxalignerr;
> > +       u64 rxrunt;
> > +       u64 rxfragment;
> > +       u64 rx64byte;
> > +       u64 rx128byte;
> > +       u64 rx256byte;
> > +       u64 rx512byte;
> > +       u64 rx1024byte;
> > +       u64 rx1518byte;
> > +       u64 rxmaxbyte;
> > +       u64 rxtoolong;
> > +       u64 rxgoodbyte;
> > +       u64 rxbadbyte;
> > +       u64 rxoverflow;
> > +       u64 filtered;
> > +       u64 txbroad;
> > +       u64 txpause;
> > +       u64 txmulti;
> > +       u64 txunderrun;
> > +       u64 tx64byte;
> > +       u64 tx128byte;
> > +       u64 tx256byte;
> > +       u64 tx512byte;
> > +       u64 tx1024byte;
> > +       u64 tx1518byte;
> > +       u64 txmaxbyte;
> > +       u64 txoversize;
> > +       u64 txbyte;
> > +       u64 txcollision;
> > +       u64 txabortcol;
> > +       u64 txmulticol;
> > +       u64 txsinglecol;
> > +       u64 txexcdefer;
> > +       u64 txdefer;
> > +       u64 txlatecol;
> > +};
> > +
> > +struct ar9331_sw_priv;
> > +struct ar9331_sw_port {
> > +       int idx;
> > +       struct ar9331_sw_priv *priv;
> > +       struct delayed_work mib_read;
> > +       struct ar9331_sw_stats stats;
> > +       struct mutex lock;              /* stats access */
> > +};
> > +
> >  struct ar9331_sw_priv {
> >         struct device *dev;
> >         struct dsa_switch ds;
> > @@ -165,6 +269,7 @@ struct ar9331_sw_priv {
> >         struct mii_bus *sbus; /* mdio slave */
> >         struct regmap *regmap;
> >         struct reset_control *sw_reset;
> > +       struct ar9331_sw_port port[AR9331_SW_PORTS];
> >  };
> >
> >  /* Warning: switch reset will reset last AR9331_SW_MDIO_PHY_MODE_PAGE request
> > @@ -424,6 +529,7 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
> >                                             phy_interface_t interface)
> >  {
> >         struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> > +       struct ar9331_sw_port *p = &priv->port[port];
> >         struct regmap *regmap = priv->regmap;
> >         int ret;
> >
> > @@ -431,6 +537,8 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
> >                                  AR9331_SW_PORT_STATUS_MAC_MASK, 0);
> >         if (ret)
> >                 dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> > +
> > +       cancel_delayed_work_sync(&p->mib_read);
> >  }
> >
> >  static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
> > @@ -441,10 +549,13 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
> >                                           bool tx_pause, bool rx_pause)
> >  {
> >         struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> > +       struct ar9331_sw_port *p = &priv->port[port];
> >         struct regmap *regmap = priv->regmap;
> >         u32 val;
> >         int ret;
> >
> > +       schedule_delayed_work(&p->mib_read, 0);
> > +
> >         val = AR9331_SW_PORT_STATUS_MAC_MASK;
> >         switch (speed) {
> >         case SPEED_1000:
> > @@ -477,6 +588,123 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
> >                 dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> >  }
> >
> > +static u32 ar9331_stat_get_val(const struct ar9331_sw_priv *priv, u32 reg)
> > +{
> > +       u32 val;
> > +       int ret;
> > +
> > +       ret = regmap_read(priv->regmap, reg, &val);
> > +       if (ret) {
> > +               dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> > +               return 0;
> > +       }
> > +
> > +       return val;
> > +}
> > +
> > +#define AR9331_READ_STATS(_port, _reg) \
> > +{ \
> > +       const struct ar9331_sw_priv *priv = _port->priv; \
> > +       struct ar9331_sw_stats *s = &_port->stats; \
> > +       int idx = _port->idx; \
> > +\
> > +       s->_reg += ar9331_stat_get_val(priv, AR9331_PORT_MIB_##_reg(idx)); \
> > +}
> > +
> > +static void ar9331_read_stats(struct ar9331_sw_port *port)
> > +{
> > +       mutex_lock(&port->lock);
> > +
> > +       AR9331_READ_STATS(port, rxbroad);
> > +       AR9331_READ_STATS(port, rxpause);
> > +       AR9331_READ_STATS(port, rxmulti);
> > +       AR9331_READ_STATS(port, rxfcserr);
> > +       AR9331_READ_STATS(port, rxalignerr);
> > +       AR9331_READ_STATS(port, rxrunt);
> > +       AR9331_READ_STATS(port, rxfragment);
> > +       AR9331_READ_STATS(port, rx64byte);
> > +       AR9331_READ_STATS(port, rx128byte);
> > +       AR9331_READ_STATS(port, rx256byte);
> > +       AR9331_READ_STATS(port, rx512byte);
> > +       AR9331_READ_STATS(port, rx1024byte);
> > +       AR9331_READ_STATS(port, rx1518byte);
> > +       AR9331_READ_STATS(port, rxmaxbyte);
> > +       AR9331_READ_STATS(port, rxtoolong);
> > +       AR9331_READ_STATS(port, rxgoodbyte);
> > +       AR9331_READ_STATS(port, rxbadbyte);
> > +       AR9331_READ_STATS(port, rxoverflow);
> > +       AR9331_READ_STATS(port, filtered);
> > +       AR9331_READ_STATS(port, txbroad);
> > +       AR9331_READ_STATS(port, txpause);
> > +       AR9331_READ_STATS(port, txmulti);
> > +       AR9331_READ_STATS(port, txunderrun);
> > +       AR9331_READ_STATS(port, tx64byte);
> > +       AR9331_READ_STATS(port, tx128byte);
> > +       AR9331_READ_STATS(port, tx256byte);
> > +       AR9331_READ_STATS(port, tx512byte);
> > +       AR9331_READ_STATS(port, tx1024byte);
> > +       AR9331_READ_STATS(port, tx1518byte);
> > +       AR9331_READ_STATS(port, txmaxbyte);
> > +       AR9331_READ_STATS(port, txoversize);
> > +       AR9331_READ_STATS(port, txbyte);
> > +       AR9331_READ_STATS(port, txcollision);
> > +       AR9331_READ_STATS(port, txabortcol);
> > +       AR9331_READ_STATS(port, txmulticol);
> > +       AR9331_READ_STATS(port, txsinglecol);
> > +       AR9331_READ_STATS(port, txexcdefer);
> > +       AR9331_READ_STATS(port, txdefer);
> > +       AR9331_READ_STATS(port, txlatecol);
> > +
> > +       mutex_unlock(&port->lock);
> > +}
> > +
> > +static void ar9331_stats_update(struct ar9331_sw_port *port,
> > +                               struct rtnl_link_stats64 *stats)
> > +{
> > +       struct ar9331_sw_stats *s = &port->stats;
> > +
> > +       stats->rx_packets = s->rxbroad + s->rxmulti + s->rx64byte +
> > +               s->rx128byte + s->rx256byte + s->rx512byte + s->rx1024byte +
> > +               s->rx1518byte + s->rxmaxbyte;
> 
> I think you might be counting these more than once. For instance if
> it's a 256byte broadcast.
> 
> > +       stats->tx_packets = s->txbroad + s->txmulti + s->tx64byte +
> > +               s->tx128byte + s->tx256byte + s->tx512byte + s->tx1024byte +
> > +               s->tx1518byte + s->txmaxbyte;
> 
> Same here.

Good point, fixed.

> > +       stats->rx_bytes = s->rxgoodbyte;
> > +       stats->tx_bytes = s->txbyte;
> > +       stats->rx_errors = s->rxfcserr + s->rxalignerr + s->rxrunt +
> > +               s->rxfragment + s->rxoverflow;
> > +       stats->tx_errors = s->txoversize;
> > +       stats->multicast = s->rxmulti;
> > +       stats->collisions = s->txcollision;
> > +       stats->rx_length_errors = s->rxrunt + s->rxfragment + s->rxtoolong;
> > +       stats->rx_crc_errors = s->rxfcserr + s->rxalignerr + s->rxfragment;
> > +       stats->rx_frame_errors = s->rxalignerr;
> > +       stats->rx_missed_errors = s->rxoverflow;
> > +       stats->tx_aborted_errors = s->txabortcol;
> > +       stats->tx_fifo_errors = s->txunderrun;
> > +       stats->tx_window_errors = s->txlatecol;
> > +       stats->rx_nohandler = s->filtered;
> > +}
> > +
> > +static void ar9331_do_stats_poll(struct work_struct *work)
> > +{
> > +       struct ar9331_sw_port *port = container_of(work, struct ar9331_sw_port,
> > +                                                  mib_read.work);
> > +
> > +       ar9331_read_stats(port);
> > +
> > +       schedule_delayed_work(&port->mib_read, STATS_INTERVAL_JIFFIES);
> > +}
> > +
> > +static void ar9331_get_stats64(struct dsa_switch *ds, int port,
> > +                              struct rtnl_link_stats64 *s)
> > +{
> > +       struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> > +       struct ar9331_sw_port *p = &priv->port[port];
> > +
> > +       ar9331_stats_update(p, s);
> > +}
> > +
> >  static const struct dsa_switch_ops ar9331_sw_ops = {
> >         .get_tag_protocol       = ar9331_sw_get_tag_protocol,
> >         .setup                  = ar9331_sw_setup,
> > @@ -485,6 +713,7 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
> >         .phylink_mac_config     = ar9331_sw_phylink_mac_config,
> >         .phylink_mac_link_down  = ar9331_sw_phylink_mac_link_down,
> >         .phylink_mac_link_up    = ar9331_sw_phylink_mac_link_up,
> > +       .get_stats64            = ar9331_get_stats64,
> >  };
> >
> >  static irqreturn_t ar9331_sw_irq(int irq, void *data)
> > @@ -796,7 +1025,7 @@ static int ar9331_sw_probe(struct mdio_device *mdiodev)
> >  {
> >         struct ar9331_sw_priv *priv;
> >         struct dsa_switch *ds;
> > -       int ret;
> > +       int ret, i;
> >
> >         priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
> >         if (!priv)
> > @@ -831,6 +1060,15 @@ static int ar9331_sw_probe(struct mdio_device *mdiodev)
> >         ds->ops = &priv->ops;
> >         dev_set_drvdata(&mdiodev->dev, priv);
> >
> > +       for (i = 0; i < ARRAY_SIZE(priv->port); i++) {
> > +               struct ar9331_sw_port *port = &priv->port[i];
> > +
> > +               port->idx = i;
> > +               port->priv = priv;
> > +               mutex_init(&port->lock);
> > +               INIT_DELAYED_WORK(&port->mib_read, ar9331_do_stats_poll);
> > +       }
> > +
> >         ret = dsa_register_switch(ds);
> >         if (ret)
> >                 goto err_remove_irq;
> > @@ -846,6 +1084,13 @@ static int ar9331_sw_probe(struct mdio_device *mdiodev)
> >  static void ar9331_sw_remove(struct mdio_device *mdiodev)
> >  {
> >         struct ar9331_sw_priv *priv = dev_get_drvdata(&mdiodev->dev);
> > +       unsigned int i;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(priv->port); i++) {
> > +               struct ar9331_sw_port *port = &priv->port[i];
> > +
> > +               cancel_delayed_work_sync(&port->mib_read);
> > +       }
> >
> >         irq_domain_remove(priv->irqdomain);
> >         mdiobus_unregister(priv->mbus);
> > --
> > 2.29.2
> >
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
