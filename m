Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559E52C1EC1
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgKXHTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:19:15 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41228 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729492AbgKXHTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 02:19:14 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606202350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zJlnXNPOdGDREh/mwa2oCDAwdPoUI+/H1uaABgTwtSs=;
        b=zzVstFY0h/U86oFDTm3u6gZCvmaUvrr48XYxuj1LRuO/WjO0XdlYLdProZE1aMW1ml1bV2
        OFU3guAtBCnE8iVNBSITtZDRzSndJoq3Aiz5CFWC8cYhAmy0LA1tGpw1gcTfsMeub/D8Y7
        c+pyP7XOaKvFJMNS+D/AsZqMJJALe93kIcuwCh2Dz8ccGnhYcuPTTNV+TWolenZf8+8I3l
        4ANc41d9xmYhI9l98tW8ow3Xt1lrb7jNiE+5i9/mR9V98/kJS29GiMmczy0QBncSgvtaHg
        yrM1JjPccXQcYDHREIOs0j9AHYukid1zoxPUgGKp0KhkvcnFoUGMYI+j9419NQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606202350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zJlnXNPOdGDREh/mwa2oCDAwdPoUI+/H1uaABgTwtSs=;
        b=fd54+6zx5+STLcspzC2CfiieaGHwCg7oaBKpADoNpHo8LqnBg/2KNvpPvLhEFoclcG9hew
        zbmQBOUh2xZP5LDQ==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <20201122230826.5l7yzdwcjzntpijm@skbuf>
References: <20201121115703.23221-1-kurt@linutronix.de> <20201121115703.23221-2-kurt@linutronix.de> <20201122230826.5l7yzdwcjzntpijm@skbuf>
Date:   Tue, 24 Nov 2020 08:19:01 +0100
Message-ID: <875z5vte6y.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon Nov 23 2020, Vladimir Oltean wrote:
> Hi Kurt,
>
> On Sat, Nov 21, 2020 at 12:57:03PM +0100, Kurt Kanzenbach wrote:
>> The switch has support for the 802.1Qbv Time Aware Shaper (TAS). Traffic
>> schedules may be configured individually on each front port. Each port h=
as eight
>> egress queues. The traffic is mapped to a traffic class respectively via=
 the PCP
>> field of a VLAN tagged frame.
>>=20
>> The TAPRIO Qdisc already implements that. Therefore, this interface can =
simply
>> be reused. Add .port_setup_tc() accordingly.
>>=20
>> The activation of a schedule on a port is split into two parts:
>>=20
>>  * Programming the necessary gate control list (GCL)
>>  * Setup delayed work for starting the schedule
>>=20
>> The hardware supports starting a schedule up to eight seconds in the fut=
ure. The
>> TAPRIO interface provides an absolute base time. Therefore, periodic del=
ayed
>> work is leveraged to check whether a schedule may be started or not.
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>>  drivers/net/dsa/hirschmann/hellcreek.c | 314 +++++++++++++++++++++++++
>>  drivers/net/dsa/hirschmann/hellcreek.h |  22 ++
>>  2 files changed, 336 insertions(+)
>>=20
>> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hi=
rschmann/hellcreek.c
>> index 6420b76ea37c..35514af1922a 100644
>> --- a/drivers/net/dsa/hirschmann/hellcreek.c
>> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/mutex.h>
>>  #include <linux/delay.h>
>>  #include <net/dsa.h>
>> +#include <net/pkt_sched.h>
>>=20=20
>>  #include "hellcreek.h"
>>  #include "hellcreek_ptp.h"
>> @@ -153,6 +154,13 @@ static void hellcreek_select_vlan(struct hellcreek =
*hellcreek, int vid,
>>  	hellcreek_write(hellcreek, val, HR_VIDCFG);
>>  }
>>=20=20
>> +static void hellcreek_select_tgd(struct hellcreek *hellcreek, int port)
>> +{
>> +	u16 val =3D port << TR_TGDSEL_TDGSEL_SHIFT;
>> +
>> +	hellcreek_write(hellcreek, val, TR_TGDSEL);
>> +}
>> +
>>  static int hellcreek_wait_until_ready(struct hellcreek *hellcreek)
>>  {
>>  	u16 val;
>> @@ -1135,6 +1143,308 @@ hellcreek_port_prechangeupper(struct dsa_switch =
*ds, int port,
>>  	return ret;
>>  }
>>=20=20
>> +static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
>> +				const struct hellcreek_schedule *schedule)
>> +{
>> +	size_t i;
>> +
>> +	for (i =3D 1; i <=3D schedule->num_entries; ++i) {
>> +		const struct hellcreek_gcl_entry *cur, *initial, *next;
>> +		u16 data;
>> +		u8 gates;
>> +
>> +		cur =3D &schedule->entries[i - 1];
>> +		initial =3D &schedule->entries[0];
>> +		next =3D &schedule->entries[i];
>> +
>
> I would find it more intuitive to have the invariant assignment out of
> the loop.
>
> 	const struct hellcreek_gcl_entry *cur, *initial, *next;
>
> 	cur =3D initial =3D &schedule->entries[0];
> 	next =3D cur + 1;
>
> 	for (i =3D 0; i < schedule->num_entries; i++) {
> 		u16 data;
> 		u8 gates;
>
> 		[...]
>
> 		cur++;
> 		next++;
> 	}

Sure. Could also do

 for (i =3D 0; i < schedule->num_entries; i++, cur++, next++)

>
>> +		if (i =3D=3D schedule->num_entries)
>> +			gates =3D initial->gate_states ^
>> +				cur->gate_states;
>> +		else
>> +			gates =3D next->gate_states ^
>> +				cur->gate_states;
>> +
>> +		data =3D gates;
>> +		if (cur->overrun_ignore)
>> +			data |=3D TR_GCLDAT_GCLOVRI;
>> +
>> +		if (i =3D=3D schedule->num_entries)
>> +			data |=3D TR_GCLDAT_GCLWRLAST;
>> +
>> +		/* Gates states */
>> +		hellcreek_write(hellcreek, data, TR_GCLDAT);
>> +
>> +		/* Time intervall */
>
> interval

Ah. That's German spelling.

>
>> +		hellcreek_write(hellcreek,
>> +				cur->interval & 0x0000ffff,
>> +				TR_GCLTIL);
>> +		hellcreek_write(hellcreek,
>> +				(cur->interval & 0xffff0000) >> 16,
>> +				TR_GCLTIH);
>> +
>> +		/* Commit entry */
>> +		data =3D ((i - 1) << TR_GCLCMD_GCLWRADR_SHIFT) |
>> +			(initial->gate_states <<
>> +			 TR_GCLCMD_INIT_GATE_STATES_SHIFT);
>> +		hellcreek_write(hellcreek, data, TR_GCLCMD);
>
> So the command register holds the initial gate states. When the command
> register is written, it samples the data register, populating GCL entry
> number GCLWRADR with that information. Every GCL entry contains the
> duration until it is executed, and the gates that need to change when
> the schedule transitions towards the next GCL entry. Right?
>
> Why are the initial gate states written each time into the command
> register? Is it required by the hardware, or just easier in the
> implementation?

I think it's required. That sequence is from the programming guide.

>
>> +	}
>> +}
>> +
>> +static void hellcreek_set_cycle_time(struct hellcreek *hellcreek,
>> +				     const struct hellcreek_schedule *schedule)
>> +{
>> +	u32 cycle_time =3D schedule->cycle_time;
>> +
>> +	hellcreek_write(hellcreek, cycle_time & 0x0000ffff, TR_CTWRL);
>> +	hellcreek_write(hellcreek, (cycle_time & 0xffff0000) >> 16, TR_CTWRH);
>
> The cycle_time in struct tc_taprio_qopt_offload is 64-bit, so you should
> NACK a value that is too large and return an appropriate extack
> message.

Ok, makes sense.

>
>> +}
>> +
>> +static void hellcreek_switch_schedule(struct hellcreek *hellcreek,
>> +				      ktime_t start_time)
>> +{
>> +	struct timespec64 ts =3D ktime_to_timespec64(start_time);
>> +
>> +	/* Start can be up to eight seconds in the future */
>> +	ts.tv_sec %=3D 8;
>
> What happens if base_time is specified as zero, or a small number that
> only encodes a phase?
>
> I would expect that the base time is advanced by an integer number of
> cycles until it becomes in the immediate future, so that it can be
> applied.

Yes, that's missing/not implemented. If the admin base time is in the
past, a valid starting point in the future has to be calculated by the
driver.

>
> I don't think that's what happens right now.
> If the start_time is 0.000000000, the cycle_time is 0.333333333, and now
> is 8.125000000.
>
> I believe that what would happen is:
> - hellcreek_schedule_startable() says "yes, it's startable right away",
>   because base_time_ns - current_ns) is negative, and therefore also
>   smaller than 8 * NSEC_PER_SEC.
> - hellcreek_switch_schedule() gets called with the 0.000000000 time, and
>   this start_time gets programmed right away into hardware.
>
> What does the hardware do if it's given a schedule that begins at 0.00000=
0000
> when the current time is at 8.125000000?
>
> I would expect that somebody (hardware or driver) advances the time
> 0.000000000 into the first time that is larger than 8.125000000, while
> still remaining congruent to the original time in terms of phase offset.
>
> I.e. advance the base time by 25 cycle times, to get
> 0.000000000 + 25 x 0.333333333 =3D 8.333333325 ns.
>
> Then I would expect the schedule to start at 8.333333325 nanoseconds,
> which is the first value immediately larger than "now" (8.125000000).

Correct.

>
> When you give the hardware the base_time of 0.000000000, is this what
> happens? Is it equivalent to giving it 0.333333325?
>
>> +
>> +	/* Start schedule at this point of time */
>> +	hellcreek_write(hellcreek, ts.tv_nsec & 0x0000ffff, TR_ESTWRL);
>> +	hellcreek_write(hellcreek, (ts.tv_nsec & 0xffff0000) >> 16, TR_ESTWRH);
>> +
>> +	/* Arm timer, set seconds and switch schedule */
>> +	hellcreek_write(hellcreek, TR_ESTCMD_ESTARM | TR_ESTCMD_ESTSWCFG |
>> +			((ts.tv_sec & TR_ESTCMD_ESTSEC_MASK) <<
>> +			 TR_ESTCMD_ESTSEC_SHIFT), TR_ESTCMD);
>> +}
>> +
>> +static struct hellcreek_schedule *
>> +hellcreek_taprio_to_schedule(struct tc_taprio_qopt_offload *taprio)
>> +{
>> +	struct hellcreek_schedule *schedule;
>> +	size_t i;
>> +
>> +	/* Allocate some memory first */
>> +	schedule =3D kzalloc(sizeof(*schedule), GFP_KERNEL);
>
> struct hellcreek_schedule has no added value on top of struct
> tc_taprio_qopt_offload (except for _maybe_ that overrun_ignore, which
> currently you don't use and could therefore remove - arguably the
> overrun_ignore flag should be user-visible if it ever was to be
> configured, and therefore my argument still stands).

overrun_ignore shouldn't be used. So, yes, that schedule can be removed.

>
> The reason why I'm making the point, though, is that you don't need to
> allocate extra memory if you use the plain struct tc_taprio_qopt_offload.
> You can use taprio_offload_get() to increase the reference count on the
> structure that was passed to you, use it for as long as you need, and
> just call taprio_offload_free() when you're done with it.

Ah, didn't know that. That'll help.

>
>> +	if (!schedule)
>> +		return ERR_PTR(-ENOMEM);
>> +	schedule->entries =3D kcalloc(taprio->num_entries,
>> +				    sizeof(*schedule->entries),
>> +				    GFP_KERNEL);
>> +	if (!schedule->entries) {
>> +		kfree(schedule);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	/* Construct hellcreek schedule */
>> +	schedule->num_entries =3D taprio->num_entries;
>> +	schedule->base_time   =3D taprio->base_time;
>> +
>> +	for (i =3D 0; i < taprio->num_entries; ++i) {
>> +		const struct tc_taprio_sched_entry *t =3D &taprio->entries[i];
>> +		struct hellcreek_gcl_entry *k =3D &schedule->entries[i];
>> +
>> +		k->interval	  =3D t->interval;
>> +		k->gate_states	  =3D t->gate_mask;
>> +		k->overrun_ignore =3D 0;
>> +
>> +		/* Update complete cycle time */
>> +		schedule->cycle_time +=3D t->interval;
>
> You shouldn't need to do this, the cycle_time from struct
> tc_taprio_qopt_offload should come properly populated. If it doesn't
> it's a bug.

True.

>
>> +	}
>> +
>> +	return schedule;
>> +}
>> +
>> +static void hellcreek_free_schedule(struct hellcreek *hellcreek, int po=
rt)
>> +{
>> +	struct hellcreek_port *hellcreek_port =3D &hellcreek->ports[port];
>> +
>> +	kfree(hellcreek_port->current_schedule->entries);
>> +	kfree(hellcreek_port->current_schedule);
>> +	hellcreek_port->current_schedule =3D NULL;
>> +}
>> +
>> +static bool hellcreek_schedule_startable(struct hellcreek *hellcreek, i=
nt port)
>> +{
>> +	struct hellcreek_port *hellcreek_port =3D &hellcreek->ports[port];
>> +	s64 base_time_ns, current_ns;
>> +
>> +	/* The switch allows a schedule to be started only eight seconds within
>> +	 * the future. Therefore, check the current PTP time if the schedule is
>> +	 * startable or not.
>> +	 */
>
> The future of whom? I expect that TR_ESTWR is relative to the most
> recent integer multiple of 8 seconds, and not relative to "now".

I think TR_ESTWR is relative to "now" and software has to make sure that
is programmed correctly.

> Otherwise you would never be able to phase-align taprio schedules with
> other devices in the LAN.
>
> Doesn't this mean that you need to be extra careful at modulo-8-seconds
> wraparounds of the current PTP time?

Yes, indeed.

>
>> +
>> +	/* Use the "cached" time. That should be alright, as it's updated quite
>> +	 * frequently in the PTP code.
>> +	 */
>> +	mutex_lock(&hellcreek->ptp_lock);
>> +	current_ns =3D hellcreek->seconds * NSEC_PER_SEC + hellcreek->last_ts;
>> +	mutex_unlock(&hellcreek->ptp_lock);
>> +
>> +	/* Calculate difference to admin base time */
>> +	base_time_ns =3D ktime_to_ns(hellcreek_port->current_schedule->base_ti=
me);
>> +
>> +	if (base_time_ns - current_ns < (s64)8 * NSEC_PER_SEC)
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>> +static void hellcreek_start_schedule(struct hellcreek *hellcreek, int p=
ort)
>> +{
>> +	struct hellcreek_port *hellcreek_port =3D &hellcreek->ports[port];
>> +
>> +	/* First select port */
>> +	hellcreek_select_tgd(hellcreek, port);
>> +
>> +	/* Set admin base time and switch schedule */
>> +	hellcreek_switch_schedule(hellcreek,
>> +				  hellcreek_port->current_schedule->base_time);
>> +
>> +	hellcreek_free_schedule(hellcreek, port);
>> +
>> +	dev_dbg(hellcreek->dev, "ARMed EST timer for port %d\n",
>
> Is ARM used as an acronym for something here? Why not Armed?

Yeah, it should be "Armed".

>
>> +		hellcreek_port->port);
>> +}
>> +
>> +static void hellcreek_check_schedule(struct work_struct *work)
>> +{
>> +	struct delayed_work *dw =3D to_delayed_work(work);
>> +	struct hellcreek_port *hellcreek_port;
>> +	struct hellcreek *hellcreek;
>> +	bool startable;
>> +
>> +	hellcreek_port =3D dw_to_hellcreek_port(dw);
>> +	hellcreek =3D hellcreek_port->hellcreek;
>> +
>> +	mutex_lock(&hellcreek->reg_lock);
>> +
>> +	/* Check starting time */
>> +	startable =3D hellcreek_schedule_startable(hellcreek,
>> +						 hellcreek_port->port);
>> +	if (startable) {
>> +		hellcreek_start_schedule(hellcreek, hellcreek_port->port);
>> +		mutex_unlock(&hellcreek->reg_lock);
>> +		return;
>> +	}
>> +
>> +	mutex_unlock(&hellcreek->reg_lock);
>> +
>> +	/* Reschedule */
>> +	schedule_delayed_work(&hellcreek_port->schedule_work,
>> +			      HELLCREEK_SCHEDULE_PERIOD);
>> +}
>> +
>> +static int hellcreek_port_set_schedule(struct dsa_switch *ds, int port,
>> +				       struct tc_taprio_qopt_offload *taprio)
>> +{
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +	struct hellcreek_port *hellcreek_port;
>> +	struct hellcreek_schedule *schedule;
>> +	bool startable;
>> +	u16 ctrl;
>> +
>> +	hellcreek_port =3D &hellcreek->ports[port];
>> +
>> +	/* Convert taprio data to hellcreek schedule */
>> +	schedule =3D hellcreek_taprio_to_schedule(taprio);
>> +	if (IS_ERR(schedule))
>> +		return PTR_ERR(schedule);
>> +
>> +	dev_dbg(hellcreek->dev, "Configure traffic schedule on port %d\n",
>> +		port);
>> +
>> +	/* First cancel delayed work */
>> +	cancel_delayed_work_sync(&hellcreek_port->schedule_work);
>> +
>> +	mutex_lock(&hellcreek->reg_lock);
>> +
>> +	if (hellcreek_port->current_schedule)
>> +		hellcreek_free_schedule(hellcreek, port);
>> +	hellcreek_port->current_schedule =3D schedule;
>> +
>> +	/* Then select port */
>> +	hellcreek_select_tgd(hellcreek, port);
>> +
>> +	/* Enable gating and set the admin state to forward everything in the
>> +	 * mean time
>> +	 */
>> +	ctrl =3D (0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT) | TR_TGDCTRL_GATE_=
EN;
>> +	hellcreek_write(hellcreek, ctrl, TR_TGDCTRL);
>
> Hmm, "in the meantime"? When do these admin gate states become effective?
> If possible, I expect that the currently operational schedule remains
> operational exactly until the base_time of the newly installed one,
> minus a possible cycle_time_extension.

Yes, that's the expectation. And the hardware works like that. I'll have
a look if this code is correct.

>
>> +
>> +	/* Cancel pending schedule */
>> +	hellcreek_write(hellcreek, 0x00, TR_ESTCMD);
>> +
>> +	/* Setup a new schedule */
>> +	hellcreek_setup_gcl(hellcreek, port, schedule);
>> +
>> +	/* Configure cycle time */
>> +	hellcreek_set_cycle_time(hellcreek, schedule);
>
> As a general comment, if the hardware doesn't support the cycle time
> extension when switching schedules, then you should NACK a non-zero
> passed argument there.

Ok.

>
>> +
>> +	/* Check starting time */
>> +	startable =3D hellcreek_schedule_startable(hellcreek, port);
>> +	if (startable) {
>> +		hellcreek_start_schedule(hellcreek, port);
>> +		mutex_unlock(&hellcreek->reg_lock);
>> +		return 0;
>> +	}
>> +
>> +	mutex_unlock(&hellcreek->reg_lock);
>> +
>> +	/* Schedule periodic schedule check */
>> +	schedule_delayed_work(&hellcreek_port->schedule_work,
>> +			      HELLCREEK_SCHEDULE_PERIOD);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hellcreek_port_del_schedule(struct dsa_switch *ds, int port)
>> +{
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +	struct hellcreek_port *hellcreek_port;
>> +
>> +	hellcreek_port =3D &hellcreek->ports[port];
>> +
>> +	dev_dbg(hellcreek->dev, "Remove traffic schedule on port %d\n", port);
>> +
>> +	/* First cancel delayed work */
>> +	cancel_delayed_work_sync(&hellcreek_port->schedule_work);
>> +
>> +	mutex_lock(&hellcreek->reg_lock);
>> +
>> +	if (hellcreek_port->current_schedule)
>> +		hellcreek_free_schedule(hellcreek, port);
>> +
>> +	/* Then select port */
>> +	hellcreek_select_tgd(hellcreek, port);
>> +
>> +	/* Disable gating and return to regular switching flow */
>> +	hellcreek_write(hellcreek, 0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT,
>> +			TR_TGDCTRL);
>> +
>> +	mutex_unlock(&hellcreek->reg_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
>> +				   enum tc_setup_type type, void *type_data)
>> +{
>> +	struct tc_taprio_qopt_offload *taprio =3D type_data;
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +
>> +	if (type !=3D TC_SETUP_QDISC_TAPRIO)
>> +		return -EOPNOTSUPP;
>> +
>> +	/* Does this hellcreek version support Qbv in hardware? */
>> +	if (!hellcreek->pdata->qbv_support)
>> +		return -EOPNOTSUPP;
>> +
>> +	if (taprio->enable)
>> +		return hellcreek_port_set_schedule(ds, port, taprio);
>> +
>> +	return hellcreek_port_del_schedule(ds, port);
>> +}
>> +
>>  static const struct dsa_switch_ops hellcreek_ds_ops =3D {
>>  	.get_ethtool_stats   =3D hellcreek_get_ethtool_stats,
>>  	.get_sset_count	     =3D hellcreek_get_sset_count,
>> @@ -1153,6 +1463,7 @@ static const struct dsa_switch_ops hellcreek_ds_op=
s =3D {
>>  	.port_hwtstamp_get   =3D hellcreek_port_hwtstamp_get,
>>  	.port_prechangeupper =3D hellcreek_port_prechangeupper,
>>  	.port_rxtstamp	     =3D hellcreek_port_rxtstamp,
>> +	.port_setup_tc	     =3D hellcreek_port_setup_tc,
>>  	.port_stp_state_set  =3D hellcreek_port_stp_state_set,
>>  	.port_txtstamp	     =3D hellcreek_port_txtstamp,
>>  	.port_vlan_add	     =3D hellcreek_vlan_add,
>> @@ -1208,6 +1519,9 @@ static int hellcreek_probe(struct platform_device =
*pdev)
>>=20=20
>>  		port->hellcreek	=3D hellcreek;
>>  		port->port	=3D i;
>> +
>> +		INIT_DELAYED_WORK(&port->schedule_work,
>> +				  hellcreek_check_schedule);
>>  	}
>>=20=20
>>  	mutex_init(&hellcreek->reg_lock);
>> diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hi=
rschmann/hellcreek.h
>> index e81781ebc31c..7ffb1b33ff72 100644
>> --- a/drivers/net/dsa/hirschmann/hellcreek.h
>> +++ b/drivers/net/dsa/hirschmann/hellcreek.h
>> @@ -213,6 +213,20 @@ struct hellcreek_counter {
>>  	const char *name;
>>  };
>>=20=20
>> +struct hellcreek_gcl_entry {
>> +	u32 interval;
>> +	u8 gate_states;
>> +	bool overrun_ignore;
>> +};
>> +
>> +struct hellcreek_schedule {
>> +	struct hellcreek_gcl_entry *entries;
>> +	size_t num_entries;
>> +	ktime_t base_time;
>> +	u32 cycle_time;
>> +	int port;
>
> You don't need/use the "port" member.

True.

>
>> +};
>> +
>>  struct hellcreek;
>>=20=20
>>  /* State flags for hellcreek_port_hwtstamp::state */
>> @@ -246,6 +260,10 @@ struct hellcreek_port {
>>=20=20
>>  	/* Per-port timestamping resources */
>>  	struct hellcreek_port_hwtstamp port_hwtstamp;
>> +
>> +	/* Per-port Qbv schedule information */
>> +	struct hellcreek_schedule *current_schedule;
>> +	struct delayed_work schedule_work;
>>  };
>>=20=20
>>  struct hellcreek_fdb_entry {
>> @@ -283,4 +301,8 @@ struct hellcreek {
>>  	size_t fdb_entries;
>>  };
>>=20=20
>> +#define HELLCREEK_SCHEDULE_PERIOD	(2 * HZ)
>
> Is there a risk if you schedule rarer than this? The hellcreek->seconds
> value is no longer accurate enough?

The hw engineer recommended to use the two seconds. In theory, it can be
increased.

Thanks for the review.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+8s+UACgkQeSpbgcuY
8KblFg//WjzkhpsLG1MhEpNzxBPaxADUfL043OY4WD+YCKfQLj35kIPMnSWN0VtQ
QXEpLwe1uYocanPazCsiIiHqT268XJKUwLqk7eOU9x4HInAFU7ruM/+6YGEKZE30
ROoDaVedjjQInvni29e2FpjLowpBWdU8aYtJfBey+Bv0FIK4Jz+xPYypzAjrkep3
s7DPtKIRLeXrJH/uoAO5GMN0bakArNq4Hh64f23VGH5s3HJsNwe/TNFDuxtfif3/
i3jn8kTiqCa6AtAM0J0P2i0T49GO446AyiKVZRsqClaCaLrJ/+icXSs9vkssPzsz
a03WgqriaUjbNNe+g+u/kFcw+riZP59WaifVXHCqy85wOykuRMjsB/YUBUP43Np2
2vwfeqJsk7apTgtFiQ6EmcfLJQQDk/ZhpdxqDJHyaqmAU9wI/1t3PK40Cc/MbzXd
SfnlkqBXZ73UxRa0vgZLCWmRCh8yD0ncQZVFhqPXW0lLW0/wvldW99fa8jQ4ykV/
d8u+UyYNEd7WOEGQxtrQRiT0PhEOkKdsbRF8s2wvCH9UfIVIGHGu2+nPE5GYz/+u
dT8j59fP2P9C4UnhkP4HMnVtJWPvNZoMs9o1uFCLkWsO/kDzKyk4GP4N4/zowBYv
2aY8QSilR5dF94q8CpLcwGJvaanNeT38gk3lnRoHYnv0R5VYkxU=
=AKab
-----END PGP SIGNATURE-----
--=-=-=--
