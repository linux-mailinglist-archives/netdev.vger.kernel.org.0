Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AA62B9F56
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgKTAaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:30:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40132 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727140AbgKTAaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 19:30:16 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfuJV-0082Bm-RR; Fri, 20 Nov 2020 01:30:09 +0100
Date:   Fri, 20 Nov 2020 01:30:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201120003009.GW1804098@lunn.ch>
References: <20201119144508.29468-1-tobias@waldekranz.com>
 <20201119144508.29468-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119144508.29468-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static struct dsa_lag *dsa_lag_get(struct dsa_switch_tree *dst,
> +				   struct net_device *dev)
> +{
> +	unsigned long busy = 0;
> +	struct dsa_lag *lag;
> +	int id;
> +
> +	list_for_each_entry(lag, &dst->lags, list) {
> +		set_bit(lag->id, &busy);
> +
> +		if (lag->dev == dev) {
> +			kref_get(&lag->refcount);
> +			return lag;
> +		}
> +	}
> +
> +	id = find_first_zero_bit(&busy, BITS_PER_LONG);
> +	if (id >= BITS_PER_LONG)
> +		return ERR_PTR(-ENOSPC);
> +
> +	lag = kzalloc(sizeof(*lag), GFP_KERNEL);
> +	if (!lag)
> +		return ERR_PTR(-ENOMEM);

Hi Tobias

My comment last time was to statically allocated them at probe
time. Worse case scenario is each port is alone in a LAG. Pointless,
but somebody could configure it. In dsa_tree_setup_switches() you can
count the number of ports and then allocate an array, or while setting
up a port, add one more lag to the list of lags.

   Andrew
