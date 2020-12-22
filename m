Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C522E0BED
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgLVOmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:42:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36962 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbgLVOmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 09:42:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1krir7-00DOYM-6N; Tue, 22 Dec 2020 15:41:41 +0100
Date:   Tue, 22 Dec 2020 15:41:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 3/8] net: sparx5: add hostmode with phylink support
Message-ID: <20201222144141.GK3107610@lunn.ch>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-4-steen.hegelund@microchip.com>
 <20201219195133.GD3026679@lunn.ch>
 <fabe6df8e8d1fab86860164ced4142afae3bd70d.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fabe6df8e8d1fab86860164ced4142afae3bd70d.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 10:46:12AM +0100, Steen Hegelund wrote:
> Hi Andrew,
> 
> On Sat, 2020-12-19 at 20:51 +0100, Andrew Lunn wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > > +     /* Create a phylink for PHY management.  Also handles SFPs */
> > > +     spx5_port->phylink_config.dev = &spx5_port->ndev->dev;
> > > +     spx5_port->phylink_co
> > > nfig.type = PHYLINK_NETDEV;
> > > +     spx5_port->phylink_config.pcs_poll = true;
> > > +
> > > +     /* phylink needs a valid interface mode to parse dt node */
> > > +     if (phy_mode == PHY_INTERFACE_MODE_NA)
> > > +             phy_mode = PHY_INTERFACE_MODE_10GBASER;
> > 
> > Maybe just enforce a valid value in DT?
> 
> Maybe I need to clarify that you must choose between an Ethernet cuPHY
> or an SFP, so it is optional.

But you also need to watch out for somebody putting a copper modules
in an SFP port. phylink will then set the mode to SGMII for a 1G
copper module, etc.

> > > +/* Configuration */
> > > +static inline bool sparx5_use_cu_phy(struct sparx5_port *port)
> > > +{
> > > +     return port->conf.phy_mode != PHY_INTERFACE_MODE_NA;
> > > +}
> > 
> > That is a rather odd definition of copper.
> 
> Should I rather use a bool property to select between the two options
> (cuPHY or SFP)?

I guess what you are trying to indicate is between a hard wired Copper
PHY and an SFP cage? You have some sort of MII switch which allows the
MAC to be connected to either the QSGMII PHY, or an SFP cage? But
since the SFP cage could be populated with a copper PHY, and PHYLINK
will then instantiate a phylib copper PHY driver for it, looking at
phy_mode is not reliable. You need a property which selects the port,
not the technology.

> > > +static int sparx5_port_open(struct net_device *ndev)
> > > +{
> > > +     struct sparx5_port *port = netdev_priv(ndev);
> > > +     int err = 0;
> > > +
> > > +     err = phylink_of_phy_connect(port->phylink, port->of_node,
> > > 0);
> > > +     if (err) {
> > > +             netdev_err(ndev, "Could not attach to PHY\n");
> > > +             return err;
> > > +     }
> > > +
> > > +     phylink_start(port->phylink);
> > > +
> > > +     if (!ndev->phydev) {
> > 
> > Humm. When is ndev->phydev set? I don't think phylink ever sets it.
> 
> Indirectly: phylink_of_phy_connect uses phy_attach_direct and that sets
> the phydev.

Ah, O.K. But watch out for a copper SFP module!

> > > +static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool
> > > byte_swap)
> > > +{
> > > +     int i, byte_cnt = 0;
> > > +     bool eof_flag = false, pruned_flag = false, abort_flag =
> > > false;
> > > +     u32 ifh[IFH_LEN];
> > > +     struct sk_buff *skb;
> > > +     struct frame_info fi;
> > > +     struct sparx5_port *port;
> > > +     struct net_device *netdev;
> > > +     u32 *rxbuf;
> > > +
> > > +     /* Get IFH */
> > > +     for (i = 0; i < IFH_LEN; i++)
> > > +             ifh[i] = spx5_rd(sparx5, QS_XTR_RD(grp));
> > > +
> > > +     /* Decode IFH (whats needed) */
> > > +     sparx5_ifh_parse(ifh, &fi);
> > > +
> > > +     /* Map to port netdev */
> > > +     port = fi.src_port < SPX5_PORTS ?
> > > +             sparx5->ports[fi.src_port] : NULL;
> > > +     if (!port || !port->ndev) {
> > > +             dev_err(sparx5->dev, "Data on inactive port %d\n",
> > > fi.src_port);
> > > +             sparx5_xtr_flush(sparx5, grp);
> > > +             return;
> > > +     }
> > > +
> > > +     /* Have netdev, get skb */
> > > +     netdev = port->ndev;
> > > +     skb = netdev_alloc_skb(netdev, netdev->mtu + ETH_HLEN);
> > > +     if (!skb) {
> > > +             sparx5_xtr_flush(sparx5, grp);
> > > +             dev_err(sparx5->dev, "No skb allocated\n");
> > > +             return;
> > > +     }
> > > +     rxbuf = (u32 *)skb->data;
> > > +
> > > +     /* Now, pull frame data */
> > > +     while (!eof_flag) {
> > > +             u32 val = spx5_rd(sparx5, QS_XTR_RD(grp));
> > > +             u32 cmp = val;
> > > +
> > > +             if (byte_swap)
> > > +                     cmp = ntohl((__force __be32)val);
> > > +
> > > +             switch (cmp) {
> > > +             case XTR_NOT_READY:
> > > +                     break;
> > > +             case XTR_ABORT:
> > > +                     /* No accompanying data */
> > > +                     abort_flag = true;
> > > +                     eof_flag = true;
> > > +                     break;
> > > +             case XTR_EOF_0:
> > > +             case XTR_EOF_1:
> > > +             case XTR_EOF_2:
> > > +             case XTR_EOF_3:
> > > +                     /* This assumes STATUS_WORD_POS == 1, Status
> > > +                      * just after last data
> > > +                      */
> > > +                     byte_cnt -= (4 - XTR_VALID_BYTES(val));
> > > +                     eof_flag = true;
> > > +                     break;
> > > +             case XTR_PRUNED:
> > > +                     /* But get the last 4 bytes as well */
> > > +                     eof_flag = true;
> > > +                     pruned_flag = true;
> > > +                     fallthrough;
> > > +             case XTR_ESCAPE:
> > > +                     *rxbuf = spx5_rd(sparx5, QS_XTR_RD(grp));
> > > +                     byte_cnt += 4;
> > > +                     rxbuf++;
> > > +                     break;
> > > +             default:
> > > +                     *rxbuf = val;
> > > +                     byte_cnt += 4;
> > > +                     rxbuf++;
> > > +             }
> > > +     }
> > > +
> > > +     if (abort_flag || pruned_flag || !eof_flag) {
> > > +             netdev_err(netdev, "Discarded frame: abort:%d
> > > pruned:%d eof:%d\n",
> > > +                        abort_flag, pruned_flag, eof_flag);
> > > +             kfree_skb(skb);
> > > +             return;
> > > +     }
> > > +
> > > +     if (!netif_oper_up(netdev)) {
> > > +             netdev_err(netdev, "Discarded frame: Interface not
> > > up\n");
> > > +             kfree_skb(skb);
> > > +             return;
> > > +     }
> > 
> > Why is it sending frames when it is not up?
> 
> This is intended for received frames. A situation where the lower
> layers have been enabled correctly but not the port.

But why should that happen? It suggests you have the order wrong. The
lower level should only be enabled once the port is opened.

> > No DMA? What sort of performance do you get? Enough for the odd BPDU,
> > IGMP frame etc, but i guess you don't want any real bulk data to be
> > sent this way?
> 
> Yes the register based injection/extration is not going to be fast, but
> the FDMA and its driver is being sent later as separate series to keep
> the size of this review down.

FDMA?

I need a bit more background here, just to make use this should be a
pure switchdev driver and not a DSA driver.

> 
> > 
> > > +irqreturn_t sparx5_xtr_handler(int irq, void *_sparx5)
> > > +{
> > > +     struct sparx5 *sparx5 = _sparx5;
> > > +
> > > +     /* Check data in queue */
> > > +     while (spx5_rd(sparx5, QS_XTR_DATA_PRESENT) & BIT(XTR_QUEUE))
> > > +             sparx5_xtr_grp(sparx5, XTR_QUEUE, false);
> > > +
> > > +     return IRQ_HANDLED;
> > > +}
> > 
> > Is there any sort of limit how many times this will loop? If somebody
> > is blasting 10Gbps at the CPU, will it ever get out of this loop?
> 
> Hmmm, not at the moment but this is because the FDMA driver is intended
> to be used in these scenarios.

So throwing out an idea, which might be terrible. How about limiting
it to 64 loops, the same as the NAPI poll? That might allow the
machine to get some work done before the next interrupt? Does the
hardware do interrupt coalescing? But is this is going to be quickly
thrown away and replaced with FDMA, don't spend too much time on it.

	 Andrew
