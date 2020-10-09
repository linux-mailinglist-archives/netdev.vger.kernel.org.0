Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D713E2897CC
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732761AbgJIUFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390349AbgJIUEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 16:04:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F83C2225B;
        Fri,  9 Oct 2020 20:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602273885;
        bh=P9rIsaGo8r5GHy8F04hfa1tm5nUMHfgAzkrVpuFy3o0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fUUBTTR69gVck+KGJ4c+sf3iOjYxWQlVK7eYzFfUzqHDDxCWOPj2t34//gpCwuiZa
         lqUcXouU2jmbNukBAT8lQxZvIebut/d75Su6nnZgmYd2b+0uXvo/jxCFSV2L680bSl
         wpGqXKbq0386/8hM4jhejuskIr0ws5ofKcL9jhco=
Date:   Fri, 9 Oct 2020 13:04:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [net v3] net: dsa: microchip: fix race condition
Message-ID: <20201009130442.7f558756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007085523.11757-1-ceggers@arri.de>
References: <20201007085523.11757-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Oct 2020 10:55:23 +0200 Christian Eggers wrote:
> Between queuing the delayed work and finishing the setup of the dsa
> ports, the process may sleep in request_module() (via
> phy_device_create()) and the queued work may be executed prior to the
> switch net devices being registered. In ksz_mib_read_work(), a NULL
> dereference will happen within netof_carrier_ok(dp->slave).
> 
> Not queuing the delayed work in ksz_init_mib_timer() makes things even
> worse because the work will now be queued for immediate execution
> (instead of 2000 ms) in ksz_mac_link_down() via
> dsa_port_link_register_of().
> 
> Call tree:
> ksz9477_i2c_probe()
> \--ksz9477_switch_register()
>    \--ksz_switch_register()
>       +--dsa_register_switch()
>       |  \--dsa_switch_probe()
>       |     \--dsa_tree_setup()
>       |        \--dsa_tree_setup_switches()
>       |           +--dsa_switch_setup()
>       |           |  +--ksz9477_setup()
>       |           |  |  \--ksz_init_mib_timer()
>       |           |  |     |--/* Start the timer 2 seconds later. */
>       |           |  |     \--schedule_delayed_work(&dev->mib_read, msecs_to_jiffies(2000));
>       |           |  \--__mdiobus_register()
>       |           |     \--mdiobus_scan()
>       |           |        \--get_phy_device()
>       |           |           +--get_phy_id()
>       |           |           \--phy_device_create()
>       |           |              |--/* sleeping, ksz_mib_read_work() can be called meanwhile */
>       |           |              \--request_module()
>       |           |
>       |           \--dsa_port_setup()
>       |              +--/* Called for non-CPU ports */
>       |              +--dsa_slave_create()
>       |              |  +--/* Too late, ksz_mib_read_work() may be called beforehand */
>       |              |  \--port->slave = ...
>       |             ...
>       |              +--Called for CPU port */
>       |              \--dsa_port_link_register_of()
>       |                 \--ksz_mac_link_down()
>       |                    +--/* mib_read must be initialized here */
>       |                    +--/* work is already scheduled, so it will be executed after 2000 ms */
>       |                    \--schedule_delayed_work(&dev->mib_read, 0);
>       \-- /* here port->slave is setup properly, scheduling the delayed work should be safe */

Thanks for this graph, very informative!

> Solution:
> 1. Do not queue (only initialize) delayed work in ksz_init_mib_timer().
> 2. Only queue delayed work in ksz_mac_link_down() if init is completed.
> 3. Queue work once in ksz_switch_register(), after dsa_register_switch()
> has completed.
> 
> Fixes: 7c6ff470aa86 ("net: dsa: microchip: add MIB counter reading support")
> Signed-off-by: Christian Eggers <ceggers@arri.de>

You should add Florian's and Vladimir's review tags here, under your
sign-off.

> @@ -143,7 +137,9 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
>  
>  	/* Read all MIB counters when the link is going down. */
>  	p->read = true;
> -	schedule_delayed_work(&dev->mib_read, 0);
> +	/* timer started */
> +	if (dev->mib_read_interval)
> +		schedule_delayed_work(&dev->mib_read, 0);

Your patch seems fine, but I wonder what was the original author trying
to achieve with this schedule_delayed_work(..., 0) call?

The work is supposed to be scheduled at this point, right?
In that case another call to schedule_delayed_work() is
simply ignored. 

Judging by the comment it seems like someone was under the impression
this will reschedule the work to be run immediately, which is not the
case.

In fact looks like a separate bug introduced in:

469b390e1ba3 ("net: dsa: microchip: use delayed_work instead of timer + work")

>  }
>  EXPORT_SYMBOL_GPL(ksz_mac_link_down);
>  
