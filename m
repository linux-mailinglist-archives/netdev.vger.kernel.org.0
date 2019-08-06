Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF1283383
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 16:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732827AbfHFOEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 10:04:36 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:38631 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730188AbfHFOEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 10:04:36 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id A31A71BF20B;
        Tue,  6 Aug 2019 14:04:33 +0000 (UTC)
Date:   Tue, 6 Aug 2019 16:04:33 +0200
From:   "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next v4 6/6] net: mscc: PTP Hardware Clock (PHC)
 support
Message-ID: <20190806140433.GB3249@kwain>
References: <20190725142707.9313-1-antoine.tenart@bootlin.com>
 <20190725142707.9313-7-antoine.tenart@bootlin.com>
 <2b70e0fbebf1875c51272f3005271a9aec68f00f.camel@mellanox.com>
 <20190731074609.GA3579@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190731074609.GA3579@kwain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 09:46:09AM +0200, antoine.tenart@bootlin.com wrote:
> On Fri, Jul 26, 2019 at 08:52:10PM +0000, Saeed Mahameed wrote:
> > On Thu, 2019-07-25 at 16:27 +0200, Antoine Tenart wrote:
> > > @@ -145,6 +151,22 @@ static irqreturn_t ocelot_xtr_irq_handler(int
> > > irq, void *arg)
> > >  			break;
> > >  		}
> > >  
> > > +		if (ocelot->ptp) {
> > > +			ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
> > > +
> > > +			tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
> > > +			if ((tod_in_ns & 0xffffffff) < info.timestamp)
> > > +				full_ts_in_ns = (((tod_in_ns >> 32) -
> > > 1) << 32) |
> > > +						info.timestamp;
> > > +			else
> > > +				full_ts_in_ns = (tod_in_ns &
> > > GENMASK_ULL(63, 32)) |
> > > +						info.timestamp;
> > > +
> > > +			shhwtstamps = skb_hwtstamps(skb);
> > > +			memset(shhwtstamps, 0, sizeof(struct
> > > skb_shared_hwtstamps));
> > > +			shhwtstamps->hwtstamp = full_ts_in_ns;
> > 
> > the right way to set the timestamp is by calling: 
> > skb_tstamp_tx(skb, &tstamp);
> 
> I'll fix this.

This is in the Rx path, so we do not have to call this.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
