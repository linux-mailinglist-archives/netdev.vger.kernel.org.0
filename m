Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB1F25156D
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgHYJd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:33:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48358 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728059AbgHYJd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:33:58 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598348035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tlp8/fNSaYSi6aDNZlHRPGlKoplHZk6XSLrY3fMUxmo=;
        b=xvnlCiEVynCsuxHY4yE97hqIs5KwP2IfSTwOOc42z3GPaN0vSCf7MEAqGn74PUWhN0HhaJ
        H8u7KyrENEAVFI8EDQNA78lI3o0HeUH5v52iu5uWdiZ7T2uI5ghzwltlNXJn7EkDGAXKWP
        l4aTYTC6Pe9Vr3bD0EBb8L650VRAadGNlBQcSGkzdUgDH3AKsnc9HY28SArEoASugq1HHf
        EwZkoJCDkYE5dbubVSS3+vGKpvcrD/s7hEZ5D80dEWJ5PZFg6HLlvCIBFaMZ+UKinKX+RZ
        1hf+xsGwTX+SRtK38+gE7oMBS+QDU74MF1/GeLP8iGZg+uyXvFxrPX1au7Z7IA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598348035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tlp8/fNSaYSi6aDNZlHRPGlKoplHZk6XSLrY3fMUxmo=;
        b=67q605LPp9WYw/vDJ5DlqLWL6E5NodJoTDDep5/BKXMhesjosXg3elcfjKhQ+aTg0Q8cpK
        gbuAE7qotihqwbBA==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <20200824225615.jtikfwyrxa7vxiq2@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <20200824225615.jtikfwyrxa7vxiq2@skbuf>
Date:   Tue, 25 Aug 2020 11:33:53 +0200
Message-ID: <878se3133y.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Aug 25 2020, Vladimir Oltean wrote:
> On Thu, Aug 20, 2020 at 10:11:15AM +0200, Kurt Kanzenbach wrote:
[snip]
>> +static struct hellcreek_schedule *hellcreek_taprio_to_schedule(
>> +	const struct tc_taprio_qopt_offload *taprio)
>
> Personal indentation preference:
>
> static struct hellcreek_schedule
> *hellcreek_taprio_to_schedule(const struct tc_taprio_qopt_offload *taprio)

Sure.

>
>> +{
>> +	struct hellcreek_schedule *schedule;
>> +	size_t i;
>> +
>> +	/* Allocate some memory first */
>> +	schedule = kzalloc(sizeof(*schedule), GFP_KERNEL);
>> +	if (!schedule)
>> +		return ERR_PTR(-ENOMEM);
>> +	schedule->entries = kcalloc(taprio->num_entries,
>> +				    sizeof(*schedule->entries),
>> +				    GFP_KERNEL);
>> +	if (!schedule->entries) {
>> +		kfree(schedule);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	/* Construct hellcreek schedule */
>> +	schedule->num_entries = taprio->num_entries;
>> +	schedule->base_time   = taprio->base_time;
>> +
>> +	for (i = 0; i < taprio->num_entries; ++i) {
>> +		const struct tc_taprio_sched_entry *t = &taprio->entries[i];
>> +		struct hellcreek_gcl_entry *k = &schedule->entries[i];
>> +
>> +		k->interval	  = t->interval;
>> +		k->gate_states	  = t->gate_mask;
>> +		k->overrun_ignore = 0;
>
> Tab to align with gate_states and interval?

Hm. I've used M x align. It should take care of it.

> What does overrun_ignore do, anyway?

I don't remember. The HW engineer suggested to set it to zero.

>
>> +
>> +		/* Update complete cycle time */
>> +		schedule->cycle_time += t->interval;
>> +	}
>> +
>> +	return schedule;
>> +}
>> +
>> +static enum hrtimer_restart hellcreek_set_schedule(struct hrtimer *timer)
>> +{
>> +	struct hellcreek_port *hellcreek_port =
>> +		hrtimer_to_hellcreek_port(timer);
>
> That moment when not even the helper macro fits in 80 characters..
> I think you should let this line have 81 characters.

OK.

>
>> +	struct hellcreek *hellcreek = hellcreek_port->hellcreek;
>> +	struct hellcreek_schedule *schedule;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);
>> +
>> +	/* First select port */
>> +	hellcreek_select_tgd(hellcreek, hellcreek_port->port);
>> +
>> +	/* Set admin base time and switch schedule */
>> +	hellcreek_start_schedule(hellcreek,
>> +				 hellcreek_port->current_schedule->base_time);
>> +
>> +	schedule = hellcreek_port->current_schedule;
>> +	hellcreek_port->current_schedule = NULL;
>> +
>> +	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
>> +
>> +	dev_dbg(hellcreek->dev, "ARMed EST timer for port %d\n",
>> +		hellcreek_port->port);
>> +
>> +	/* Free resources */
>> +	kfree(schedule->entries);
>> +	kfree(schedule);
>> +
>> +	return HRTIMER_NORESTART;
>> +}
>> +
>> +static int hellcreek_port_set_schedule(struct dsa_switch *ds, int port,
>> +				       const struct tc_taprio_qopt_offload *taprio)
>> +{
>> +	struct net_device *netdev = dsa_to_port(ds, port)->slave;
>> +	struct hellcreek *hellcreek = ds->priv;
>> +	struct hellcreek_port *hellcreek_port;
>> +	struct hellcreek_schedule *schedule;
>> +	unsigned long flags;
>> +	ktime_t start;
>> +	u16 ctrl;
>> +
>> +	hellcreek_port = &hellcreek->ports[port];
>> +
>> +	/* Convert taprio data to hellcreek schedule */
>> +	schedule = hellcreek_taprio_to_schedule(taprio);
>> +	if (IS_ERR(schedule))
>> +		return PTR_ERR(schedule);
>> +
>> +	dev_dbg(hellcreek->dev, "Configure traffic schedule on port %d\n",
>> +		port);
>> +
>> +	/* Cancel an in flight timer */
>> +	hrtimer_cancel(&hellcreek_port->cycle_start_timer);
>> +
>> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);
>> +
>> +	if (hellcreek_port->current_schedule) {
>> +		kfree(hellcreek_port->current_schedule->entries);
>> +		kfree(hellcreek_port->current_schedule);
>> +	}
>> +
>> +	hellcreek_port->current_schedule = schedule;
>> +
>> +	/* First select port */
>> +	hellcreek_select_tgd(hellcreek, port);
>> +
>> +	/* Setup traffic class <-> queue mapping */
>> +	hellcreek_setup_tc_mapping(hellcreek, netdev);
>> +
>> +	/* Enable gating and set the admin state to forward everything in the
>> +	 * mean time
>> +	 */
>> +	ctrl = (0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT) | TR_TGDCTRL_GATE_EN;
>> +	hellcreek_write(hellcreek, ctrl, TR_TGDCTRL);
>> +
>> +	/* Cancel pending schedule */
>> +	hellcreek_write(hellcreek, 0x00, TR_ESTCMD);
>> +
>> +	/* Setup a new schedule */
>> +	hellcreek_setup_gcl(hellcreek, port, schedule);
>> +
>> +	/* Configure cycle time */
>> +	hellcreek_set_cycle_time(hellcreek, schedule);
>> +
>> +	/* Setup timer for schedule switch: The IP core only allows to set a
>> +	 * cycle start timer 8 seconds in the future. This is why we setup the
>> +	 * hritmer to base_time - 5 seconds. Then, we have enough time to
>> +	 * activate IP core's EST timer.
>> +	 */
>> +	start = ktime_sub_ns(schedule->base_time, (u64)5 * NSEC_PER_SEC);
>> +	hrtimer_start_range_ns(&hellcreek_port->cycle_start_timer, start,
>> +			       NSEC_PER_SEC, HRTIMER_MODE_ABS);
>
> Explain again how this works, please? The hrtimer measures the CLOCK_TAI
> of the CPU, but you are offloading the CLOCK_TAI domain of the NIC? So
> you are assuming that the CPU and the NIC PHC are synchronized? What if
> they aren't?

Yes, I assume that's synchronized with e.g. phc2sys.

>
> And what if the base-time is in the past, do you deal with that (how
> does the hardware deal with a base-time in the past)?
> A base-time in the past (example: 0) should work: you should advance the
> base-time into the nearest future multiple of the cycle-time, to at
> least preserve phase correctness of the schedule.

If the hrtimer is programmed with a value in the past, it fires
instantly. The callback is executed and the start time is
programmed.

>
> Just trying to understand if this whole hrtimer thing is worth it. It
> complicates the driver by quite a significant amount.

See my other reply mail, why I used hrtimers.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9E2wEACgkQeSpbgcuY
8KahRg//RRRGwIWAQhR1Iw4EZ6hKkS4kLrB+gu3Jm5Tn2xoBXfTPlDYO0zQYC1BF
QC7WKamPNFqtNOZKj51FWJY2W8M0H+qtMvO1rUd6VZx91knpCGBSwCyTncFiMobM
IHRG+KaTer2k0wUjgG0OxTe9N9K+fCSg6y82RUfUTDO2mNUh/psgWI64VuuJJIzF
2KjT6Z6ekM7tY3zMOG2ifXM9fjNLeZ9nKAbpa4X+wzYHmP1k6Nnl3IJYpf984DTo
EPkBUMG8ruVXPKuKCt6ujhHMv7tuS/SCAVSCTk0kGIl0OI4XEM8HGuyyGq3kRtEh
xOV8dOdhzEsTI0IEpg34P/wv1dIqX6HCRX8H+/UwpwX6Y9Mx8+x9d39p+Ul4kzvy
yGpv95u6xisI7eVhqLWXQf0c2BecxhB+z/vSia0Oo38bxr2xNVFOuEyERbCi/FvR
wiZtdasdCavxqt5TLv+Be69BedL2+5y8hMH4rx+UwjICRLJ5k5VcZnQvMIJqOrZs
NcbrKhiIqfwSFFz8bkVK2g+NKh4pQdItKMVmB0E03LZ6rzzZW94Iid+rQ22LAqxc
wv5z74wotwlORJIGi/tgl2wI2l5gfEZV+j20acnAdzgmntpRk4KAJYOXPQX6VSWJ
SdLxNG674wZWdoJaIPYCk21Nhf09+MXHUvK65Q1NGwJzDDPXdCQ=
=jME8
-----END PGP SIGNATURE-----
--=-=-=--
