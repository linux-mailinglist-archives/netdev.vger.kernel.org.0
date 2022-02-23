Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2D34C0DA6
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 08:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238816AbiBWHyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 02:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbiBWHyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 02:54:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316BF580CD
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 23:54:12 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nMmTN-0006ga-Gz; Wed, 23 Feb 2022 08:54:05 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nMmTM-00024F-Bo; Wed, 23 Feb 2022 08:54:04 +0100
Date:   Wed, 23 Feb 2022 08:54:04 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de, Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz9477: implement
 MTU configuration
Message-ID: <20220223075404.GA4594@pengutronix.de>
References: <20220221084328.3661250-1-o.rempel@pengutronix.de>
 <20220222165217.62426462@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220222165217.62426462@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:44:25 up 74 days, 16:30, 83 users,  load average: 0.16, 0.16,
 0.17
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 04:52:17PM -0800, Jakub Kicinski wrote:
> On Mon, 21 Feb 2022 09:43:28 +0100 Oleksij Rempel wrote:
> > This chips supports two ways to configure max MTU size:
> > - by setting SW_LEGAL_PACKET_DISABLE bit: if this bit is 0 allowed packed size
> >   will be between 64 and bytes 1518. If this bit is 1, it will accept
> >   packets up to 2000 bytes.
> > - by setting SW_JUMBO_PACKET bit. If this bit is set, the chip will
> >   ignore SW_LEGAL_PACKET_DISABLE value and use REG_SW_MTU__2 register to
> >   configure MTU size.
> > 
> > Current driver has disabled SW_JUMBO_PACKET bit and activates
> > SW_LEGAL_PACKET_DISABLE. So the switch will pass all packets up to 2000 without
> > any way to configure it.
> > 
> > By providing port_change_mtu we are switch to SW_JUMBO_PACKET way and will
> > be able to configure MTU up to ~9000.
> 
> And it has no negative side affects to always have jumbo enabled?
> Maybe the internal buffer will be carved up in a different way?

Hm I tested it with iperf3 on 4 of 7 ports on this switch without
noticeable changes before and after this patch. My setup looks as
following:

----`
    |      /- iperf -s
    = port0
    |      \- iperf3 -c 172.17.0.11 -t 100
    |
    |
    = port1 ... same as port0, ... -c 172.17.0.10
    = port2 ... same as port0, ... -c 172.17.0.13
    = port3 ... same as port0, ... -c 172.17.0.12

Each port was sending and receiving. Each instance reported 938 Mbits/sec

> > +static int ksz9477_change_mtu(struct dsa_switch *ds, int port, int mtu)
> > +{
> > +	struct ksz_device *dev = ds->priv;
> > +	u16 new_mtu, max_mtu = 0;
> > +	int i;
> > +
> > +	new_mtu = mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN;
> > +
> > +	if (dsa_is_cpu_port(ds, port))
> > +		new_mtu += KSZ9477_INGRESS_TAG_LEN;
> > +
> > +	/* Cache the per-port MTU setting */
> > +	dev->ports[port].max_mtu = new_mtu;
> > +
> > +	for (i = 0; i < dev->port_cnt; i++) {
> > +		if (dev->ports[i].max_mtu > max_mtu)
> > +			max_mtu = dev->ports[i].max_mtu;
> > +	}
> 
> nit:
> 
> 	for (...)
> 		max_mtu = max(max_mtu, dev->ports[i].max_mtu)
> 
> > @@ -41,6 +41,7 @@ struct ksz_port {
> >  
> >  	struct ksz_port_mib mib;
> >  	phy_interface_t interface;
> > +	unsigned int max_mtu;
> >  };
> 
> max_mtu already has two meanings in this patch, let's call this
> max_frame or max_len etc, instead of adding a third meaning.

Ok, thx. Will update the patch.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
