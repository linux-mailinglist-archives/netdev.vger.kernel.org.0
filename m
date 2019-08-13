Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9328B32A
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfHMI6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:58:21 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:56793 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfHMI6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:58:21 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 668AE240010;
        Tue, 13 Aug 2019 08:58:18 +0000 (UTC)
Date:   Tue, 13 Aug 2019 10:58:17 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Message-ID: <20190813085817.GA3200@kwain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Igor,

On Sat, Aug 10, 2019 at 01:20:32PM +0000, Igor Russkikh wrote:
> On 08.08.2019 17:05, Antoine Tenart wrote:
> 
> > The Rx and TX handlers are modified to take in account the special case
> > were the MACsec transformation happens in the hardware, whether in a PHY
> > or in a MAC, as the packets seen by the networking stack on both the
> 
> Don't you think we may eventually may need xmit / handle_frame ops to be
> a part of macsec_ops?
> 
> That way software macsec could be extract to just another type of offload.
> The drawback of current code is it doesn't show explicitly the path of
> offloaded packets. It is hidden in `handle_not_macsec` and in
> `macsec_start_xmit` branch. This makes incorrect counters to tick (see my below
> comment)
> 
> Another thing is that both xmit / macsec_handle_frame can't now be customized
> by device driver. But this may be required.
> We for example have usecases and HW features to allow specific flows to bypass
> macsec encryption. This is normally used for macsec key control protocols,
> identified by ethertype. Your phy is also capable on that as I see.

I think this question is linked to the use of a MACsec virtual interface
when using h/w offloading. The starting point for me was that I wanted
to reuse the data structures and the API exposed to the userspace by the
s/w implementation of MACsec. I then had two choices: keeping the exact
same interface for the user (having a virtual MACsec interface), or
registering the MACsec genl ops onto the real net devices (and making
the s/w implementation a virtual net dev and a provider of the MACsec
"offloading" ops).

The advantages of the first option were that nearly all the logic of the
s/w implementation could be kept and especially that it would be
transparent for the user to use both implementations of MACsec. But this
raised an issue as I had to modify the xmit / handle_frame ops to let
all the traffic pass. This is because we have no way of knowing if a
frame was handled by the MACsec h/w or not in ingress. So the virtual
interface here only serve as the entrypoint for the API...

The second option would have the advantage to better represent the actual
flow, but the way of configuring MACsec would be a bit different for the
user, whether he wants to use s/w or h/w MACsec. If we were to do this I
think we could extract the genl functions from the MACsec s/w
implementation, and let it implement the MACsec ops (exactly as the
offloading drivers).

I'm open to discussing this :)

As for the need for xmit / handle_frame ops (for a MAC w/ MACsec
offloading), I'd say the xmit / handle_frame ops of the real net device
driver could be used as the one of the MACsec virtual interface do not
do much (regardless of the implementation choice discussed above).

> > @@ -2546,11 +2814,15 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
> >  {
> >  	struct macsec_dev *macsec = netdev_priv(dev);
> >  	struct macsec_secy *secy = &macsec->secy;
> > +	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
> >  	struct pcpu_secy_stats *secy_stats;
> > +	struct macsec_tx_sa *tx_sa;
> >  	int ret, len;
> >  
> > +	tx_sa = macsec_txsa_get(tx_sc->sa[tx_sc->encoding_sa]);
> 
> Declared, but not used?

I'll remove it then.

> >  	/* 10.5 */
> > -	if (!secy->protect_frames) {
> > +	if (!secy->protect_frames || macsec_get_ops(netdev_priv(dev), NULL)) {
> >  		secy_stats = this_cpu_ptr(macsec->stats);
> >  		u64_stats_update_begin(&secy_stats->syncp);
> >  		secy_stats->stats.OutPktsUntagged++;
> 
> Here you use same `if` for sw and hw flows, this making `OutPktsUntagged`
> counter invalid.

Right, I'll try to fix that.

> >  	struct macsec_dev *macsec = macsec_priv(dev);
> > -	struct net_device *real_dev;
> > +	struct net_device *real_dev, *loop_dev;
> > +	struct macsec_context ctx;
> > +	const struct macsec_ops *ops;
> > +	struct net *loop_net;
> 
> Reverse Christmas tree is normally a formatting requirement where possible.

Sure.

> > +	for_each_net(loop_net) {
> > +		for_each_netdev(loop_net, loop_dev) {
> > +			struct macsec_dev *priv;
> > +
> > +			if (!netif_is_macsec(loop_dev))
> > +				continue;
> > +
> > +			priv = macsec_priv(loop_dev);
> > +
> > +			/* A limitation of the MACsec h/w offloading is only a
> > +			 * single MACsec interface can be created for a given
> > +			 * real interface.
> > +			 */
> > +			if (macsec_get_ops(netdev_priv(dev), NULL) &&
> > +			    priv->real_dev == real_dev)
> > +				return -EBUSY;
> > +		}
> > +	}
> > +
> 
> There is no need to do this search loop if `macsec_get_ops(..) == NULL` ?
> So you can extract this check before `for_each_net` for SW macsec...

Right, I'll fix it!

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
