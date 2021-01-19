Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3662FC537
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbhASX6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730772AbhASX5v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 18:57:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FAEF20A8B;
        Tue, 19 Jan 2021 23:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611100624;
        bh=EzYqdUoRupYWLnotAGOXjuCTFNqltXcjQp1zzVAAx5Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jAlaXuo7Ck5eSexPFYvTNcSqdMo/Aq4A1gM0x+JUFBJSc0o8xYVKtWf5DGStXmonP
         GDiWzAW4tQ/ssPjOwnG5yt90nrQIiimr5gHTIxbitTtQFh6Ke2b4Mgrfee1oW9RJ5V
         bGbG+rX4vOX7/PhWdUlNT85+8n1B3JDwRq6BCrBVx5xMAoG1rSu1ef3mQZ1MYJoFIt
         wwuNPEnAnEWBf2jMK3MXhn4iQrwUAx1+l8GqvA6cEeVOhyP14IuM+GwaUlaQiMQ26y
         47owk6FFaTWjKZfnJ7igVOiF37yZduGOJCw4AfA5PwMnZbEvkC2T/EADD/nDKMa2z5
         pvzUlqMekJdFQ==
Date:   Tue, 19 Jan 2021 15:57:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/1] net: dsa: hellcreek: Add TAPRIO
 offloading support
Message-ID: <20210119155703.7064800d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210116124922.32356-2-kurt@linutronix.de>
References: <20210116124922.32356-1-kurt@linutronix.de>
        <20210116124922.32356-2-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Jan 2021 13:49:22 +0100 Kurt Kanzenbach wrote:
> The switch has support for the 802.1Qbv Time Aware Shaper (TAS). Traffic
> schedules may be configured individually on each front port. Each port has eight
> egress queues. The traffic is mapped to a traffic class respectively via the PCP
> field of a VLAN tagged frame.
> 
> The TAPRIO Qdisc already implements that. Therefore, this interface can simply
> be reused. Add .port_setup_tc() accordingly.
> 
> The activation of a schedule on a port is split into two parts:
> 
>  * Programming the necessary gate control list (GCL)
>  * Setup delayed work for starting the schedule
> 
> The hardware supports starting a schedule up to eight seconds in the future. The
> TAPRIO interface provides an absolute base time. Therefore, periodic delayed
> work is leveraged to check whether a schedule may be started or not.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

> +static bool hellcreek_schedule_startable(struct hellcreek *hellcreek, int port)
> +{
> +	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
> +	s64 base_time_ns, current_ns;
> +
> +	/* The switch allows a schedule to be started only eight seconds within
> +	 * the future. Therefore, check the current PTP time if the schedule is
> +	 * startable or not.
> +	 */
> +
> +	/* Use the "cached" time. That should be alright, as it's updated quite
> +	 * frequently in the PTP code.
> +	 */
> +	mutex_lock(&hellcreek->ptp_lock);
> +	current_ns = hellcreek->seconds * NSEC_PER_SEC + hellcreek->last_ts;
> +	mutex_unlock(&hellcreek->ptp_lock);
> +
> +	/* Calculate difference to admin base time */
> +	base_time_ns = ktime_to_ns(hellcreek_port->current_schedule->base_time);
> +
> +	if (base_time_ns - current_ns < (s64)8 * NSEC_PER_SEC)
> +		return true;
> +
> +	return false;

nit:
	return base_time_ns - current_ns < (s64)8 * NSEC_PER_SEC;

> +static int hellcreek_port_set_schedule(struct dsa_switch *ds, int port,
> +				       struct tc_taprio_qopt_offload *taprio)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	struct hellcreek_port *hellcreek_port;
> +	bool startable;
> +	u16 ctrl;
> +
> +	hellcreek_port = &hellcreek->ports[port];
> +
> +	dev_dbg(hellcreek->dev, "Configure traffic schedule on port %d\n",
> +		port);
> +
> +	/* First cancel delayed work */
> +	cancel_delayed_work_sync(&hellcreek_port->schedule_work);
> +
> +	mutex_lock(&hellcreek->reg_lock);
> +
> +	if (hellcreek_port->current_schedule) {
> +		taprio_offload_free(hellcreek_port->current_schedule);
> +		hellcreek_port->current_schedule = NULL;
> +	}
> +	hellcreek_port->current_schedule = taprio_offload_get(taprio);
> +
> +	/* Then select port */
> +	hellcreek_select_tgd(hellcreek, port);
> +
> +	/* Enable gating and keep defaults */
> +	ctrl = (0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT) | TR_TGDCTRL_GATE_EN;
> +	hellcreek_write(hellcreek, ctrl, TR_TGDCTRL);
> +
> +	/* Cancel pending schedule */
> +	hellcreek_write(hellcreek, 0x00, TR_ESTCMD);
> +
> +	/* Setup a new schedule */
> +	hellcreek_setup_gcl(hellcreek, port, hellcreek_port->current_schedule);
> +
> +	/* Configure cycle time */
> +	hellcreek_set_cycle_time(hellcreek, hellcreek_port->current_schedule);
> +
> +	/* Check starting time */
> +	startable = hellcreek_schedule_startable(hellcreek, port);
> +	if (startable) {
> +		hellcreek_start_schedule(hellcreek, port);
> +		mutex_unlock(&hellcreek->reg_lock);
> +		return 0;
> +	}
> +
> +	mutex_unlock(&hellcreek->reg_lock);
> +
> +	/* Schedule periodic schedule check */
> +	schedule_delayed_work(&hellcreek_port->schedule_work,
> +			      HELLCREEK_SCHEDULE_PERIOD);

Why schedule this work every 2 seconds rather than scheduling it
$start_time - 8 sec + epsilon?

> +static bool hellcreek_validate_schedule(struct hellcreek *hellcreek,
> +					struct tc_taprio_qopt_offload *schedule)
> +{
> +	/* Does this hellcreek version support Qbv in hardware? */
> +	if (!hellcreek->pdata->qbv_support)
> +		return false;
> +
> +	/* cycle time can only be 32bit */
> +	if (schedule->cycle_time > (u32)-1)
> +		return false;
> +
> +	/* cycle time extension is not supported */
> +	if (schedule->cycle_time_extension)
> +		return false;

What's the story with entries[i].command? I see most drivers validate
the command is what they expect.

> +	return true;
> +}
> +
> +static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
> +				   enum tc_setup_type type, void *type_data)
> +{
> +	struct tc_taprio_qopt_offload *taprio = type_data;
> +	struct hellcreek *hellcreek = ds->priv;
> +
> +	if (type != TC_SETUP_QDISC_TAPRIO)
> +		return -EOPNOTSUPP;
> +
> +	if (!hellcreek_validate_schedule(hellcreek, taprio))
> +		return -EOPNOTSUPP;
> +
> +	if (taprio->enable)
> +		return hellcreek_port_set_schedule(ds, port, taprio);
> +
> +	return hellcreek_port_del_schedule(ds, port);
> +}
> +
>  static const struct dsa_switch_ops hellcreek_ds_ops = {
>  	.get_ethtool_stats   = hellcreek_get_ethtool_stats,
>  	.get_sset_count	     = hellcreek_get_sset_count,
