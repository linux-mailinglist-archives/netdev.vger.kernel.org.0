Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D045B55B30F
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 19:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiFZRKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 13:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiFZRKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 13:10:21 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76C8DF46
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 10:10:20 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o5Vly-0003fl-59; Sun, 26 Jun 2022 19:10:10 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o5Vlw-0008K0-92; Sun, 26 Jun 2022 19:10:08 +0200
Date:   Sun, 26 Jun 2022 19:10:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/3] net: dsa: ar9331: add support for pause
 stats
Message-ID: <20220626171008.GA7581@pengutronix.de>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
 <20220624125902.4068436-2-o.rempel@pengutronix.de>
 <20220624220317.ckhx6z7cmzegvoqi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220624220317.ckhx6z7cmzegvoqi@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 25, 2022 at 01:03:17AM +0300, Vladimir Oltean wrote:
> On Fri, Jun 24, 2022 at 02:59:01PM +0200, Oleksij Rempel wrote:
> > Add support for pause stats and fix rx_packets/tx_packets calculation.
> > 
> > Pause packets are counted by raw.rx64byte/raw.tx64byte counters, so
> > subtract it from main rx_packets/tx_packets counters.
> > 
> > tx_/rx_bytes are not affected.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/qca/ar9331.c | 23 +++++++++++++++++++++--
> >  1 file changed, 21 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> > index fb3fe74abfe6..82412f54c432 100644
> > --- a/drivers/net/dsa/qca/ar9331.c
> > +++ b/drivers/net/dsa/qca/ar9331.c
> > @@ -606,6 +607,7 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
> >  static void ar9331_read_stats(struct ar9331_sw_port *port)
> >  {
> >  	struct ar9331_sw_priv *priv = ar9331_sw_port_to_priv(port);
> > +	struct ethtool_pause_stats *pstats = &port->pause_stats;
> >  	struct rtnl_link_stats64 *stats = &port->stats;
> >  	struct ar9331_sw_stats_raw raw;
> >  	int ret;
> > @@ -625,9 +627,11 @@ static void ar9331_read_stats(struct ar9331_sw_port *port)
> >  	stats->tx_bytes += raw.txbyte;
> >  
> >  	stats->rx_packets += raw.rx64byte + raw.rx128byte + raw.rx256byte +
> > -		raw.rx512byte + raw.rx1024byte + raw.rx1518byte + raw.rxmaxbyte;
> > +		raw.rx512byte + raw.rx1024byte + raw.rx1518byte +
> > +		raw.rxmaxbyte - raw.rxpause;
> >  	stats->tx_packets += raw.tx64byte + raw.tx128byte + raw.tx256byte +
> > -		raw.tx512byte + raw.tx1024byte + raw.tx1518byte + raw.txmaxbyte;
> > +		raw.tx512byte + raw.tx1024byte + raw.tx1518byte +
> > +		raw.txmaxbyte - raw.txpause;
> 
> Is there an authoritative source who is able to tell whether rtnl_link_stats64 ::
> rx_packets and tx_packets should count PAUSE frames or not?

Yes, it will be interesting to know how to proceed with it. For example
KSZ switch do count pause frame Bytes together will other frames. At
same time, atheros switch do not count pause frame bytes at all.

To make things worse, i can manually send pause frame of any size, so it
will not be accounted by HW. What ever decision we will made, i will
need to calculate typical pause frame size and hope it will fit for 90%
of cases.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
