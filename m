Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B632236E2
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 10:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgGQIS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 04:18:58 -0400
Received: from mail.intenta.de ([178.249.25.132]:28224 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbgGQIS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 04:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=kDstqAsqjrdHPVtO5IP3CACJmPEHAj7gSO3dv1iNRW8=;
        b=BhnjDZDnZWhXJMPwGsuNkhUjErfDjbi/Z5wJz78HV/8yG6z32yD55FchR228QydroelZkrUhMCiXJjMBxpfGkeLfSi2F4TlqrCByTPQZjqE34UQ6FWcE4O9epI214rjCP3N7NyWNcKGWLiwGYvJR0jTSCnX220ni7OGhysSG1EHf7Brl4XNok2kP9LvJTDrX6ETO3UNKYIZAGSgg7JaujGfcNL4GwwqA5yHaCmsJu55NasDyWZlFmcB/hKsh6ULw296yWmvZiKNevBHFo2Ti5ZSDcD3e9KPBzWuQ/kektQ2zClBk+27VbQY9ko9+VAbMgLHT/tMFvRJgWWDU8qJHdA==;
Date:   Fri, 17 Jul 2020 10:18:52 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [PATCH v2] net: dsa: microchip: call phy_remove_link_mode during
 probe
Message-ID: <20200717081852.GA23732@laureti-dev>
References: <20200715192722.GD1256692@lunn.ch>
 <20200716125723.GA19500@laureti-dev>
 <20200716141044.GA1266257@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200716141044.GA1266257@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 04:10:44PM +0200, Andrew Lunn wrote:
> However, i'm having trouble understanding how PHYs actually work in
> this driver. 
> 
> We have:
> 
> struct ksz_port {
>         u16 member;
>         u16 vid_member;
>         int stp_state;
>         struct phy_device phydev;
> 
> with an instance of this structure per port of the switch.
> 
> And it is this phydev which you are manipulating.
> 
> > +	for (i = 0; i < dev->phy_port_cnt; ++i) {
> > +		/* The MAC actually cannot run in 1000 half-duplex mode. */
> > +		phy_remove_link_mode(&dev->ports[i].phydev,
> > +				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> > +
> > +		/* PHY does not support gigabit. */
> > +		if (!(dev->features & GBIT_SUPPORT))
> > +			phy_remove_link_mode(&dev->ports[i].phydev,
> > +					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
> > +	}
> > +
> >  	return 0;
> 
> But how is this phydev associated with the netdev? I don't see how
> phylink_connect_phy() is called using this phydev structure?

The ksz* drivers are implemented using the DSA framework. The relevant
phylink_connect_phy call is issued by the DSA infrastructure. We can see
this (and its ordering relative to phy_remove_link_mode after my patch)
using ftrace by adding the following to the kernel command line:

    trace_options=func_stack_trace ftrace=function ftrace_filter=phylink_connect_phy,phy_remove_link_mode

I've added the trace buffer to the end of this mail to avoid cluttering
it. The key takeaways are:
 * phylink_connect_phy is called by dsa_slave_create. A few inlined
   functions later we arrive at dsa_register_switch, which is called
   during driver probe.
 * All phy_remove_link_mode calls now happen before any
   phylink_connect_phy calls as requested.

Helmut

----8<-----8<------
# tracer: function
#
# entries-in-buffer/entries-written: 10/10   #P:2
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
       swapper/0-1     [000] ....     7.166645: phy_remove_link_mode <-macb_probe
       swapper/0-1     [000] ....     7.166654: <stack trace>
 => macb_probe
 => platform_drv_probe
 => really_probe
 => driver_probe_device
 => device_driver_attach
 => __driver_attach
 => bus_for_each_dev
 => driver_attach
 => bus_add_driver
 => driver_register
 => __platform_driver_register
 => macb_driver_init
 => do_one_initcall
 => kernel_init_freeable
 => kernel_init
 => ret_from_fork
 => 0
     kworker/1:1-28    [001] ....     7.592479: phy_remove_link_mode <-ksz9477_setup
     kworker/1:1-28    [001] ....     7.592489: <stack trace>
 => ksz9477_setup
 => dsa_register_switch
 => ksz_switch_register
 => ksz9477_switch_register
 => ksz9477_i2c_probe
 => i2c_device_probe
 => really_probe
 => driver_probe_device
 => __device_attach_driver
 => bus_for_each_drv
 => __device_attach
 => device_initial_probe
 => bus_probe_device
 => deferred_probe_work_func
 => process_one_work
 => worker_thread
 => kthread
 => ret_from_fork
 => 0
     kworker/1:1-28    [001] ....     7.592494: phy_remove_link_mode <-ksz9477_setup
     kworker/1:1-28    [001] ....     7.592498: <stack trace>
 => ksz9477_setup
 => dsa_register_switch
 => ksz_switch_register
 => ksz9477_switch_register
 => ksz9477_i2c_probe
 => i2c_device_probe
 => really_probe
 => driver_probe_device
 => __device_attach_driver
 => bus_for_each_drv
 => __device_attach
 => device_initial_probe
 => bus_probe_device
 => deferred_probe_work_func
 => process_one_work
 => worker_thread
 => kthread
 => ret_from_fork
 => 0
     kworker/1:1-28    [001] ....     7.604375: phylink_connect_phy <-dsa_slave_create
     kworker/1:1-28    [001] ....     7.604383: <stack trace>
 => dsa_slave_create
 => dsa_register_switch
 => ksz_switch_register
 => ksz9477_switch_register
 => ksz9477_i2c_probe
 => i2c_device_probe
 => really_probe
 => driver_probe_device
 => __device_attach_driver
 => bus_for_each_drv
 => __device_attach
 => device_initial_probe
 => bus_probe_device
 => deferred_probe_work_func
 => process_one_work
 => worker_thread
 => kthread
 => ret_from_fork
 => 0
     kworker/1:1-28    [001] .n..     7.623675: phylink_connect_phy <-dsa_slave_create
     kworker/1:1-28    [001] .n..     7.623685: <stack trace>
 => dsa_slave_create
 => dsa_register_switch
 => ksz_switch_register
 => ksz9477_switch_register
 => ksz9477_i2c_probe
 => i2c_device_probe
 => really_probe
 => driver_probe_device
 => __device_attach_driver
 => bus_for_each_drv
 => __device_attach
 => device_initial_probe
 => bus_probe_device
 => deferred_probe_work_func
 => process_one_work
 => worker_thread
 => kthread
 => ret_from_fork
 => 0
---->8----->8------
