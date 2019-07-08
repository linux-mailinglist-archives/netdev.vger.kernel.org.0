Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B2E61BE6
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 10:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfGHIsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 04:48:17 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:53019 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbfGHIsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 04:48:16 -0400
Received: from localhost (lfbn-1-2078-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id D3CA6100014;
        Mon,  8 Jul 2019 08:48:09 +0000 (UTC)
Date:   Mon, 8 Jul 2019 10:48:09 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v2 8/8] net: mscc: PTP Hardware Clock (PHC)
 support
Message-ID: <20190708084809.GB2932@kwain>
References: <20190705195213.22041-1-antoine.tenart@bootlin.com>
 <20190705195213.22041-9-antoine.tenart@bootlin.com>
 <20190705151038.0581a052@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190705151038.0581a052@cakuba.netronome.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On Fri, Jul 05, 2019 at 03:10:38PM -0700, Jakub Kicinski wrote:
> On Fri,  5 Jul 2019 21:52:13 +0200, Antoine Tenart wrote:
> > @@ -596,11 +606,50 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
> >  
> >  	dev->stats.tx_packets++;
> >  	dev->stats.tx_bytes += skb->len;
> > -	dev_kfree_skb_any(skb);
> > +
> > +	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
> > +	    port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> > +		struct ocelot_skb *oskb =
> > +			kzalloc(sizeof(struct ocelot_skb), GFP_KERNEL);
> 
> I think this is the TX path, you can't use GFP_KERNEL here.

I'll fix it.

> > +static int ocelot_hwstamp_set(struct ocelot_port *port, struct ifreq *ifr)
> > +{
> > +	struct ocelot *ocelot = port->ocelot;
> > +	struct hwtstamp_config cfg;
> > +
> > +	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> > +		return -EFAULT;
> > +
> > +	/* reserved for future extensions */
> > +	if (cfg.flags)
> > +		return -EINVAL;
> > +
> > +	/* Tx type sanity check */
> > +	switch (cfg.tx_type) {
> > +	case HWTSTAMP_TX_ON:
> > +		port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
> > +		break;
> > +	case HWTSTAMP_TX_ONESTEP_SYNC:
> > +		/* IFH_REW_OP_ONE_STEP_PTP updates the correctional field, we
> > +		 * need to update the origin time.
> > +		 */
> > +		port->ptp_cmd = IFH_REW_OP_ORIGIN_PTP;
> > +		break;
> > +	case HWTSTAMP_TX_OFF:
> > +		port->ptp_cmd = 0;
> > +		break;
> > +	default:
> > +		return -ERANGE;
> > +	}
> > +
> > +	mutex_lock(&ocelot->ptp_lock);
> > +
> > +	switch (cfg.rx_filter) {
> > +	case HWTSTAMP_FILTER_NONE:
> > +		break;
> > +	case HWTSTAMP_FILTER_ALL:
> > +	case HWTSTAMP_FILTER_SOME:
> > +	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> > +	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> > +	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> > +	case HWTSTAMP_FILTER_NTP_ALL:
> > +	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> > +	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> > +	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> > +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> > +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> > +	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> > +	case HWTSTAMP_FILTER_PTP_V2_EVENT:
> > +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> > +	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> > +		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
> > +		break;
> > +	default:
> > +		mutex_unlock(&ocelot->ptp_lock);
> > +		return -ERANGE;
> > +	}
> 
> No device reconfig, so the PTP RX stamping is always enabled?  Perhaps
> consider setting 
> 
> 	ocelot->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT
> 
> at probe?

That's right. Would set the ptp flag to 0 also be an option here (so
that we respect HWTSTAMP_FILTER_NONE at least in the driver)?

> > +	/* Commit back the result & save it */
> > +	memcpy(&ocelot->hwtstamp_config, &cfg, sizeof(cfg));
> > +	mutex_unlock(&ocelot->ptp_lock);
> > +
> > +	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> > +}
> >  
> > +static int ocelot_get_ts_info(struct net_device *dev,
> > +			      struct ethtool_ts_info *info)
> > +{
> > +	struct ocelot_port *ocelot_port = netdev_priv(dev);
> > +	struct ocelot *ocelot = ocelot_port->ocelot;
> > +	int ret;
> > +
> > +	if (!ocelot->ptp)
> > +		return -EOPNOTSUPP;
> 
> Hmm.. why does software timestamping depend on PTP?

Because it depends on the "PTP" register bank (and the "PTP" interrupt)
being described and available. This is why I named the flag 'ptp', but
it could be named 'timestamp' or 'ts' as well.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
