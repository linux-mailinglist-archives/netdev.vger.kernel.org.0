Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47904224AE9
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 13:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgGRLVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 07:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgGRLVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 07:21:09 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3D3C0619D2;
        Sat, 18 Jul 2020 04:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dCGpUxkIfKHHwj840SN3vXyjVZKmEAte11yhOcdbYIQ=; b=QBh0o5M19Sg5kwLfZF8Tu8V+1q
        clDdPqLY5NqxjFbVdlXuabmV794WIxRhLzfKq7f2iqxw0jTQe2XCFSX5hL0nMOpT0yjYRa6JQamHz
        xhBGOjACnGy+6pXINNSPNE3JSSf0cm4VpNIjf+nwScop03dsIfFw2n3qJiUyX7ygtbou1Ls+9qhTh
        pVD2EdjBcrj8eR4ffEEHt7iAf6I6xrmUDLmYfTcnKk1YUee9Clu37bfhuwQisEwxIkbrYkEy1zliI
        VP9vT93xqOx3hK8rC9wfllZ9EWRCs/bvUAwg7GeXUmFmuvNc7+youc7I4NHT818j6pSqqMqrJ+rKV
        ywbiWX7A==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jwktq-00072H-6H; Sat, 18 Jul 2020 12:21:02 +0100
Date:   Sat, 18 Jul 2020 12:21:02 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: qca8k: implement the port MTU callbacks
Message-ID: <20200718112102.GJ23489@earth.li>
References: <20200718093555.GA12912@earth.li>
 <20200718103808.6wj5dlwtuxmwjvt5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718103808.6wj5dlwtuxmwjvt5@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 01:38:08PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 18, 2020 at 10:35:55AM +0100, Jonathan McDowell wrote:
> > This switch has a single max frame size configuration register, so we
> > track the requested MTU for each port and apply the largest.
> > 
> > Signed-off-by: Jonathan McDowell <noodles@earth.li>
> > ---
> >  drivers/net/dsa/qca8k.c | 38 ++++++++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/qca8k.h |  3 +++
> >  2 files changed, 41 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 4acad5fa0c84..3690f02aea3a 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -670,6 +670,12 @@ qca8k_setup(struct dsa_switch *ds)
> >  		}
> >  	}
> >  
> > +	/* Setup our port MTUs to match power on defaults */
> > +	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
> > +		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
> > +	}
> 
> I am not quite sure the curly brackets are needed. And nowhere else in
> qca8k.c is this convention being used.

Good point; force of habit from coding standards elsewhere. Fixed (and
also the instance below).

> > +	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
> > +
> >  	/* Flush the FDB table */
> >  	qca8k_fdb_flush(priv);
> >  
> > @@ -1098,6 +1104,36 @@ qca8k_port_disable(struct dsa_switch *ds, int port)
> >  	priv->port_sts[port].enabled = 0;
> >  }
> >  
> > +static int
> > +qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> > +{
> > +	struct qca8k_priv *priv = ds->priv;
> > +	int i, mtu;
> > +
> > +	if ((new_mtu < ETH_MIN_MTU) || (new_mtu > QCA8K_MAX_MTU)) {
> > +		return -EINVAL;
> > +	}
> 
> I'm pretty sure this check should not be needed.
> The only reason why slave_dev->min_mtu is 0 seems to be:
> 
> commit 8b1efc0f83f1f75b8f85c70d2211007de8fd7633
> Author: Jarod Wilson <jarod@redhat.com>
> Date:   Thu Oct 20 23:25:27 2016 -0400
> 
>     net: remove MTU limits on a few ether_setup callers
> 
>     These few drivers call ether_setup(), but have no ndo_change_mtu, and thus
>     were overlooked for changes to MTU range checking behavior. They
>     previously had no range checks, so for feature-parity, set their min_mtu
>     to 0 and max_mtu to ETH_MAX_MTU (65535), instead of the 68 and 1500
>     inherited from the ether_setup() changes. Fine-tuning can come after we get
>     back to full feature-parity here.
> 
>     CC: netdev@vger.kernel.org
>     Reported-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
>     CC: Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
>     CC: R Parameswaran <parameswaran.r7@gmail.com>
>     Signed-off-by: Jarod Wilson <jarod@redhat.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> which is an oversight on my part. Since now DSA supports
> ndo_change_mtu(), the "slave_dev->min_mtu = 0;" line in net/dsa/slave.c
> can be removed and so can this check.

Ok.

> > +
> > +	priv->port_mtu[port] = new_mtu;
> > +
> > +	mtu = 0;
> 
> I think it's more typical to initialize mtu to 0 at declaration time.

Sure, fixed.

> > +	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
> > +		if (priv->port_mtu[port] > mtu)
> > +			mtu = priv->port_mtu[port];
> > +	}
> 
> Again, curly brackets are not needed here, although some might feel it
> aids readability.
> 
> > +
> > +	/* Include L2 header / FCS length */
> > +	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +qca8k_port_max_mtu(struct dsa_switch *ds, int port)
> > +{
> > +	return QCA8K_MAX_MTU;
> 
> So what is the maximum value that you can write into
> QCA8K_MAX_FRAME_SIZE? 9000 or 9018? If it's 9000, you should report a
> max MTU of 8982, and let the network stack do the range check for you,
> that's why this callback exists in the first place.

9018 (including header + fcs), hence returning QCA8K_MAX_MTU here.

> Do you know how are VLAN tags accounted for (i.e. does iperf3 TCP work
> over a VLAN sub-interface after your patch)? There are 2 options:
> - The ports automatically increase the maximum accepted frame size by 4
>   (or 8, in case of double tag) bytes if they see VLAN tagged traffic.
>   Case in which you don't need to do anything.
> - You need to manually account for the possibility that VLAN-tagged
>   traffic will be received, since the 802.1Q header is not part of the
>   SDU whose max length is measured by the MTU. So you might want to
>   write a value to QCA8K_MAX_FRAME_SIZE that is either "mtu +
>   VLAN_ETH_HLEN + ETH_FCS_LEN", or "mtu + ETH_HLEN + 2 * VLAN_HLEN +
>   ETH_FCS_LEN", depending on whether you foresee double-tagging being
>   used.

The value is for a normal packet; the switch accounts for VLAN / double
VLAN / the switch tagging header size itself.

> > +}
> > +
> >  static int
> >  qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
> >  		      u16 port_mask, u16 vid)
> > @@ -1174,6 +1210,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
> >  	.set_mac_eee		= qca8k_set_mac_eee,
> >  	.port_enable		= qca8k_port_enable,
> >  	.port_disable		= qca8k_port_disable,
> > +	.port_change_mtu	= qca8k_port_change_mtu,
> > +	.port_max_mtu		= qca8k_port_max_mtu,
> >  	.port_stp_state_set	= qca8k_port_stp_state_set,
> >  	.port_bridge_join	= qca8k_port_bridge_join,
> >  	.port_bridge_leave	= qca8k_port_bridge_leave,
> > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > index 10ef2bca2cde..31439396401c 100644
> > --- a/drivers/net/dsa/qca8k.h
> > +++ b/drivers/net/dsa/qca8k.h
> > @@ -13,6 +13,7 @@
> >  #include <linux/gpio.h>
> >  
> >  #define QCA8K_NUM_PORTS					7
> > +#define QCA8K_MAX_MTU					9000
> >  
> >  #define PHY_ID_QCA8337					0x004dd036
> >  #define QCA8K_ID_QCA8337				0x13
> > @@ -58,6 +59,7 @@
> >  #define   QCA8K_MDIO_MASTER_MAX_REG			32
> >  #define QCA8K_GOL_MAC_ADDR0				0x60
> >  #define QCA8K_GOL_MAC_ADDR1				0x64
> > +#define QCA8K_MAX_FRAME_SIZE				0x78
> >  #define QCA8K_REG_PORT_STATUS(_i)			(0x07c + (_i) * 4)
> >  #define   QCA8K_PORT_STATUS_SPEED			GENMASK(1, 0)
> >  #define   QCA8K_PORT_STATUS_SPEED_10			0
> > @@ -189,6 +191,7 @@ struct qca8k_priv {
> >  	struct device *dev;
> >  	struct dsa_switch_ops ops;
> >  	struct gpio_desc *reset_gpio;
> > +	unsigned int port_mtu[QCA8K_NUM_PORTS];
> >  };
> >  
> >  struct qca8k_mib_desc {
> > -- 
> > 2.27.0

J.

-- 
/-\                             | 101 things you can't have too much
|@/  Debian GNU/Linux Developer |       of : 19 - A Good Thing.
\-                              |
