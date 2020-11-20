Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F9D2BAB21
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgKTNbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:31:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKTNbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 08:31:01 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kg6V0-00875Y-CL; Fri, 20 Nov 2020 14:30:50 +0100
Date:   Fri, 20 Nov 2020 14:30:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, olteanv@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201120133050.GF1804098@lunn.ch>
References: <20201119144508.29468-1-tobias@waldekranz.com>
 <20201119144508.29468-3-tobias@waldekranz.com>
 <20201120003009.GW1804098@lunn.ch>
 <5e2d23da-7107-e45e-0ab3-72269d7b6b24@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e2d23da-7107-e45e-0ab3-72269d7b6b24@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 06:43:38PM -0800, Florian Fainelli wrote:
> 
> 
> On 11/19/2020 4:30 PM, Andrew Lunn wrote:
> >> +static struct dsa_lag *dsa_lag_get(struct dsa_switch_tree *dst,
> >> +				   struct net_device *dev)
> >> +{
> >> +	unsigned long busy = 0;
> >> +	struct dsa_lag *lag;
> >> +	int id;
> >> +
> >> +	list_for_each_entry(lag, &dst->lags, list) {
> >> +		set_bit(lag->id, &busy);
> >> +
> >> +		if (lag->dev == dev) {
> >> +			kref_get(&lag->refcount);
> >> +			return lag;
> >> +		}
> >> +	}
> >> +
> >> +	id = find_first_zero_bit(&busy, BITS_PER_LONG);
> >> +	if (id >= BITS_PER_LONG)
> >> +		return ERR_PTR(-ENOSPC);
> >> +
> >> +	lag = kzalloc(sizeof(*lag), GFP_KERNEL);
> >> +	if (!lag)
> >> +		return ERR_PTR(-ENOMEM);
> > 
> > Hi Tobias
> > 
> > My comment last time was to statically allocated them at probe
> > time. Worse case scenario is each port is alone in a LAG. Pointless,
> > but somebody could configure it. In dsa_tree_setup_switches() you can
> > count the number of ports and then allocate an array, or while setting
> > up a port, add one more lag to the list of lags.
> 
> The allocation is allowed to sleep (have not checked the calling context
> of dsa_lag_get() whether this is OK) so what would be the upside of
> doing upfront dsa_lag allocation which could be wasteful?

Hi Florian

It fits the pattern for the rest of the DSA core. We never allocate
anything at runtime. That keeps the error handling simple, we don't
need to deal with ENOMEM errors, undoing whatever we might of done,
implementing transactions etc.

And the memory involved here is small. I guess around 80 bytes per
lag? So even for a 10 port switch, we are only talking about 800
bytes. That is not a lot.

       Andrew
