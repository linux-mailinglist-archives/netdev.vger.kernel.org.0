Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93D4279B94
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbgIZRrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:47:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56950 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbgIZRrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:47:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMEHk-00GISK-Rc; Sat, 26 Sep 2020 19:47:00 +0200
Date:   Sat, 26 Sep 2020 19:47:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net-next 02/16] net: dsa: allow drivers to request
 promiscuous mode on master
Message-ID: <20200926174700.GB3883417@lunn.ch>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
 <20200926173108.1230014-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926173108.1230014-3-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 08:30:54PM +0300, Vladimir Oltean wrote:
> Currently DSA assumes that taggers don't mess with the destination MAC
> address of the frames on RX. That is not always the case. Some DSA
> headers are placed before the Ethernet header (ocelot), and others
> simply mangle random bytes from the destination MAC address (sja1105
> with its incl_srcpt option).

...

> So give drivers the possibility to signal that their tagging protocol
> will get randomly dropped otherwise, and let DSA deal with fixing that.

> @@ -317,6 +317,13 @@ struct dsa_switch {
>  	 */
>  	bool			mtu_enforcement_ingress;
>  
> +	/* Some tagging protocols either mangle or shift the destination MAC
> +	 * address, in which case the DSA master would drop packets on ingress
> +	 * if what it understands out of the destination MAC address is not in
> +	 * its RX filter.
> +	 */
> +	bool			promisc_on_master;
> +
>  	size_t num_ports;
>  };

Hi Vladimir

I actually think this is a property of the tagger, not the DSA
driver. In fact, DSA drivers never handle actual frames, they are all
about the control plane, not the data plane. So i think this bool
should be in the tagger structure, dsa_device_ops.

       Andrew
