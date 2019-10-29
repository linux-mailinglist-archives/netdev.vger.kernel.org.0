Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78F50E7E15
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 02:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbfJ2Bjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 21:39:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39434 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbfJ2Bjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 21:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WWPqqpxMK49aX8fxq2Vp7OQYSMvT98SnujSdTfgf4ts=; b=qpizOuVKfF2ZOjdNvONrI9tbvy
        NWEHbpgPyIb9QFWtR9EvX58E38TY5SMldtbSIsyF22tVXlRxoDrolH0NKjRCkexhWA1D1Be91iagk
        3Gg5agceubRVq7QtnYe53lwYC5nh/BtVX/uo2H+rjgi4Olia5R2dcq7yv9CJedEsMycA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPGTy-0001E1-8A; Tue, 29 Oct 2019 02:39:38 +0100
Date:   Tue, 29 Oct 2019 02:39:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: Add ability to elect CPU port
Message-ID: <20191029013938.GG15259@lunn.ch>
References: <20191028223236.31642-1-f.fainelli@gmail.com>
 <20191028223236.31642-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028223236.31642-2-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 03:32:35PM -0700, Florian Fainelli wrote:
> In a configuration where multiple CPU ports are declared within the
> platform configuration, it may be desirable to make sure that a
> particular CPU port gets used. This is particularly true for Broadcom
> switch that are fairly flexible to some extent in which port can be the
> CPU port, yet will be more featureful if port 8 is elected.

> -static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
> +static struct dsa_port *dsa_tree_find_cpu(struct dsa_switch_tree *dst)
>  {
> +	struct dsa_switch *ds;
>  	struct dsa_port *dp;
> +	int err;
>  
> -	list_for_each_entry(dp, &dst->ports, list)
> -		if (dsa_port_is_cpu(dp))
> +	list_for_each_entry(dp, &dst->ports, list) {
> +		ds = dp->ds;
> +		if (!dsa_port_is_cpu(dp))
> +			continue;
> +
> +		if (!ds->ops->elect_cpu_port)
>  			return dp;
>  
> +		err = ds->ops->elect_cpu_port(ds, dp->index);
> +		if (err == 0)
> +			return dp;
> +	}
> +
>  	return NULL;
>  }

Hi Florian

I think is_preferred_cpu_port() would be a better name, and maybe a
bool?

Also, i don't think we should be returning NULL at the end like
this. If the device tree does not have the preferred port as CPU port,
we should use dsa_tree_find_cpu() to pick one of the actually offered
CPU ports in DT? It sounds like your hardware will still work if any
port is used as the CPU port.

And maybe we need a is_valid_cpu_port()? Some of the chipsets only
have a subset which can be CPU ports, the hardware is not as flexible.
The core can then validate the CPU port really is valid, rather than
the driver, e.g. qca8k, validating the CPU port in setup() and
returning an error.

    Andrew
