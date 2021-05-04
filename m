Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3969373062
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhEDTJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:09:16 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:45519 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbhEDTI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 15:08:58 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 32C572224F;
        Tue,  4 May 2021 21:08:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1620155281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4QGBSbicqLJQJZ17cGGki/cHo+2xPsDzUqYYr7kWQGI=;
        b=ZToFfr/Pyy6rucbem/d+/lMBNbteLciIJ23xYYW1wnuff+UkorF47/UmtyjqdHtifJaFVY
        d23CE/nmvzyzJIPo9miRnxS9bHtYHGutAT79jOATUxHx9y0OiwDNWtGJvHbb4BnrK8NkL4
        YJnx6DkmSrGU/3RVfsi/8RjGA6jvbfA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 04 May 2021 21:08:00 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     xiaoliang.yang_1@nxp.com, Arvid.Brodin@xdin.com,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, andre.guedes@linux.intel.com,
        claudiu.manoil@nxp.com, colin.king@canonical.com,
        davem@davemloft.net, idosch@mellanox.com,
        ivan.khoronzhuk@linaro.org, jiri@mellanox.com,
        joergen.andreasen@microchip.com, leoyang.li@nxp.com,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        michael.chan@broadcom.com, mingkai.hu@nxp.com,
        netdev@vger.kernel.org, po.liu@nxp.com, saeedm@mellanox.com,
        vinicius.gomes@intel.com, vladimir.oltean@nxp.com,
        yuehaibing@huawei.com
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for TAS
 config
In-Reply-To: <20210504185040.ftkub3ropuacmyel@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210504170514.10729-1-michael@walle.cc>
 <20210504181833.w2pecbp2qpuiactv@skbuf>
 <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-05-04 20:50, schrieb Vladimir Oltean:
> On Tue, May 04, 2021 at 08:38:29PM +0200, Michael Walle wrote:
>> Hi Vladimir,
>> 
>> Am 2021-05-04 20:18, schrieb Vladimir Oltean:
>> > On Tue, May 04, 2021 at 07:05:14PM +0200, Michael Walle wrote:
>> > > Hi,
>> > >
>> > > > ALWAYS_GUARD_BAND_SCH_Q bit in TAS config register is descripted as
>> > > > this:
>> > > > 	0: Guard band is implemented for nonschedule queues to schedule
>> > > > 	   queues transition.
>> > > > 	1: Guard band is implemented for any queue to schedule queue
>> > > > 	   transition.
>> > > >
>> > > > The driver set guard band be implemented for any queue to schedule queue
>> > > > transition before, which will make each GCL time slot reserve a guard
>> > > > band time that can pass the max SDU frame. Because guard band time could
>> > > > not be set in tc-taprio now, it will use about 12000ns to pass 1500B max
>> > > > SDU. This limits each GCL time interval to be more than 12000ns.
>> > > >
>> > > > This patch change the guard band to be only implemented for nonschedule
>> > > > queues to schedule queues transition, so that there is no need to reserve
>> > > > guard band on each GCL. Users can manually add guard band time for each
>> > > > schedule queues in their configuration if they want.
>> > >
>> > >
>> > > As explained in another mail in this thread, all queues are marked as
>> > > scheduled. So this is actually a no-op, correct? It doesn't matter if
>> > > it set or not set for now. Dunno why we even care for this bit then.
>> >
>> > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the available
>> > throughput when set.
>> 
>> Ahh, I see now. All queues are "scheduled" but the guard band only 
>> applies
>> for "non-scheduled" -> "scheduled" transitions. So the guard band is 
>> never
>> applied, right? Is that really what we want?
> 
> Xiaoliang explained that yes, this is what we want. If the end user
> wants a guard band they can explicitly add a "sched-entry 00" in the
> tc-taprio config.

You're disabling the guard band, then. I figured, but isn't that
suprising for the user? Who else implements taprio? Do they do it in the
same way? I mean this behavior is passed right to the userspace and have
a direct impact on how it is configured. Of course a user can add it
manually, but I'm not sure that is what we want here. At least it needs
to be documented somewhere. Or maybe it should be a switchable option.

Consider the following:
sched-entry S 01 25000
sched-entry S fe 175000
basetime 0

Doesn't guarantee, that queue 0 is available at the beginning of
the cycle, in the worst case it takes up to
<begin of cycle> + ~12.5us until the frame makes it through (given
gigabit and 1518b frames).

Btw. there are also other implementations which don't need a guard
band (because they are store-and-forward and cound the remaining
bytes). So yes, using a guard band and scheduling is degrading the
performance.


>> > > > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
>> > > > ---
>> > > >  drivers/net/dsa/ocelot/felix_vsc9959.c | 8 ++++++--
>> > > >  1 file changed, 6 insertions(+), 2 deletions(-)
>> > > >
>> > > > diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
>> > > > index 789fe08cae50..2473bebe48e6 100644
>> > > > --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
>> > > > +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
>> > > > @@ -1227,8 +1227,12 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
>> > > >  	if (taprio->num_entries > VSC9959_TAS_GCL_ENTRY_MAX)
>> > > >  		return -ERANGE;
>> > > >
>> > > > -	ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port) |
>> > > > -		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
>> > > > +	/* Set port num and disable ALWAYS_GUARD_BAND_SCH_Q, which means set
>> > > > +	 * guard band to be implemented for nonschedule queues to schedule
>> > > > +	 * queues transition.
>> > > > +	 */
>> > > > +	ocelot_rmw(ocelot,
>> > > > +		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port),
>> > > >  		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM_M |
>> > > >  		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
>> > > >  		   QSYS_TAS_PARAM_CFG_CTRL);
>> > >
>> > > Anyway, I don't think this the correct place for this:
>> > >  (1) it isn't per port, but a global bit, but here its done per port.
>> >
>> > I don't understand. According to the documentation, selecting the port
>> > whose time-aware shaper you are configuring is done through
>> > QSYS::TAS_PARAM_CFG_CTRL.PORT_NUM.
>> 
>> According to the LS1028A RM:
>> 
>>   PORT_NUM
>>   Specifies the port number to which the TAS_PARAMS register 
>> configurations
>>   (CFG_REG_1 to CFG_REG_5, TIME_INTERVAL and GATE_STATE) need to be 
>> applied.
>> 
>> I guess this work together with CONFIG_CHANGE and applies the mentions
>> registers
>> in an atomic way (or at a given time). There is no mention of the
>> ALWAYS_GUARD_BAND_SCH_Q bit nor the register TAS_PARAM_CFG_CTRL.
>> 
>> But the ALWAYS_GUARD_BAND_SCH_Q mention its "Global configuration". 
>> That
>> together with the fact that it can't be read back (unless I'm missing
>> something), led me to the conclusion that this bit is global for the 
>> whole
>> switch. I may be wrong.
> 
> Sorry, I don't understand what you mean to say here.

I doubt that ALWAYS_GUARD_BAND_SCH_Q is a per-port setting. But that is
only a guess. One would have to check with the IP vendor.

>> But in any case, (2) is more severe IMHO.
>> 
>> > >  (2) rmw, I presume is read-modify-write. and there is one bit CONFIG_CHAGE
>> > >      which is set by software and cleared by hardware. What happens if it
>> > > 	 will be cleared right after we read it. Then it will be set again, no?
>> > >
>> > > So if we really care about this bit, shouldn't this be moved to switch
>> > > initialization then?
> 
> Sorry, again, I don't understand. Let me copy here the procedure from
> vsc9959_qos_port_tas_set():
> 
> 	ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
> 		   QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
> 		   QSYS_TAS_PARAM_CFG_CTRL); <- set the CONFIG_CHANGE bit, keep
> everything else the same
> 
> 	ret = readx_poll_timeout(vsc9959_tas_read_cfg_status, ocelot, val,
> 				 !(val & QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE),
> 				 10, 100000); <- spin until CONFIG_CHANGE clears
> 
> Should there have been a mutex at the beginning of 
> vsc9959_qos_port_tas_set,
> ensuring that two independent user space processes configuring the TAS
> of two ports cannot access the global config registers concurrently?
> Probably, although my guess is that currently, the global rtnetlink
> mutex prevents this from happening in practice.

Ah ok, I missed that.

> 
>> > May I know what drew your attention to this patch? Is there something
>> > wrong?

See private mail.

-michael
