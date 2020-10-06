Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DB8284D1A
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgJFOFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:05:55 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36818 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgJFOFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 10:05:17 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601993114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aevUCo3puiob2HP//iPLvFAqgxEFdjfpmUhfAFAJfaI=;
        b=zARUnj1E6h2b0KXvNa2/Rrkxv3WqjQfxr22mblxs64LVWc1ewrxxyYi70f52yKaIsRDqGY
        7DwFyOp4nYRYAFq/og9E1tQc6uP4UCQofMZq33L2SnXd7KhSxHkPsKYsbNSnF0U8mMqirJ
        0eU9prDntnttwK3umbzInqLTFTToV7CnJ4ugGmt1wxVR2xUd9+WK51d7fvHNLnAEhC3FHG
        nmGt6pERt3tv39250fvij1o+2GkDWRgsbMsvZe32knMMdTGRT6bHF4xZMgR6vYCPi1gu63
        aLpxwj55dLyXwFnXGGRT8pUjP3M1Cin/O7CPbA0x4lD40JYfHPELhWuFFNiPfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601993114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aevUCo3puiob2HP//iPLvFAqgxEFdjfpmUhfAFAJfaI=;
        b=1nujxp/iHWjSaxL4HabpIgMjmQ57vzahHd2fB00qEnWO+uoYq14OkplLfbT9ypi5sNNoM8
        ipf4f7+NzXN339Bg==
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
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20201006134247.7uwchuo6s7lmyzeq@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-3-kurt@linutronix.de> <20201004125601.aceiu4hdhrawea5z@skbuf> <87lfgj997g.fsf@kurt> <20201006092017.znfuwvye25vsu4z7@skbuf> <878scj8xxr.fsf@kurt> <20201006113237.73rzvw34anilqh4d@skbuf> <87wo037ajr.fsf@kurt> <20201006134247.7uwchuo6s7lmyzeq@skbuf>
Date:   Tue, 06 Oct 2020 16:05:11 +0200
Message-ID: <87o8lf78mg.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Oct 06 2020, Vladimir Oltean wrote:
> On Tue, Oct 06, 2020 at 03:23:36PM +0200, Kurt Kanzenbach wrote:
>> On Tue Oct 06 2020, Vladimir Oltean wrote:
>> Does this mean that tagged traffic is forwarded no matter what?
>
> Precisely. The bridge VLAN table should be irrelevant to the acceptance
> or forwarding decision of the packet if vlan_filtering is 0.

I see.

>
>> That doesn't work with the current implementation, because the VLAN
>> tags are interpreted by default. There's a global flag to put the
>> switch in VLAN unaware mode. But it's global and not per bridge or
>> port.
>
> Oh, there is? Maybe you can use it then.
>
> JUST FOR CONTEXT, for sja1105 and felix/ocelot, this is the mode that
> they're operating in, when a bridge with vlan_filtering=0 is configured
> as an upper.
>
> In sja1105, I don't even have the VLAN awareness flag that you have. So
> I need to change the VLAN TPID from 0x8100 to 0xdadb, and the switch
> will think that VLAN-tagged frames aren't VLAN. So all frames are tagged
> internally by the switch with the port-based VLAN ID and PCP, when in
> vlan_filtering=0.
> And because my knob is global and not per bridge either, I just set
> ds->vlan_filtering_is_global = true and let DSA handle the rest.

What's that flag doing? ...

	/* Disallow bridge core from requesting different VLAN awareness
	 * settings on ports if not hardware-supported
	 */
	bool			vlan_filtering_is_global;

OK, that's what I need for the bridging part.

>
> As for ocelot/felix, those switches have 2 knobs:
> - VLAN awareness: does the ingress port derive the classified VLAN from
>   the packet's 802.1Q header? If yes, the VLAN ID and PCP are taken from
>   the packet. If not, they are taken from the port-based default.
> - VLAN ingress filtering: does the ingress port drop a VLAN-tagged frame
>   if the classified VLAN is not installed in its ingress filter?
>
> As you may guess, even for ocelot/felix, when we have a bridge with
> vlan_filtering=0, we are still configuring it as:
> VLAN awareness = disabled
> VLAN ingress filtering = enabled
>
> Because the classified VLAN is not derived from the packet, it will
> always be equal to the pvid of the port, which is installed privately by
> the driver. So no packet drops due to VLAN, regardless of VLAN ID.
>
>> So you're saying private VLANs can be used but the user or the other
>> kernel modules shouldn't be allowed to use them to simplify the
>> implementation?  Makes sense to me.
>
> Yes.
> And because the user is more likely to install VLAN 2 and 3 than 4095
> and 4094, maybe you could use private VLANs from the end of the range,
> just to make this restriction less obvious (or maybe not at all).
>
>> The egress port has to member to that VLAN.
>
> Same as ocelot/felix. This is the reason why we make it VLAN-unaware.
> There's no point in disabling just VLAN ingress filtering if the end
> result is still going to be a drop, albeit due to a different reason (no
> destinations).

OK.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl98eZcACgkQeSpbgcuY
8KaSrw/6AuKxfgjS6/8A2hFlJed9EWY3rrkcWDwaqgcZUQM/mXEEzLRcCZrCvC99
f6DatFt6nsvuPcYEV3kZXTUboif9WuW/ne7uFNrUzB2E6WjTSmwTTreJHWSR23U5
CvmRM9nrNNncqbCFxW2mjY/kVUd1GqMgAiEHwnzvnn7r68/H6VUoCb/p6fES42sY
7s8s37H6KqlpzP8rnIDbDR455hW59OuyybNT2zlHu48/EmQLYLKBf2S3maRaEHH/
nJlSj6aHkVz3RcJBE2rwWMXOr+aV2r6mzviqSEh0oo1U6n8hzeviBfN0IKbzerXP
I1oRTc9Q+RkD172eegmSdA5dA1M5WveAMLwZn5uWUtCt9vDEY/qB7M5RwcGKFRPz
nsGGPbb0plGXTXGxt1qpfUO9GrhIEMz6Kf9ZYpGBU9izEtqvDnE/cEeU5122mre8
lnrdGGFZ30osU3O3vcfVm7tpH5yKRBgheL0XtXEKfO1Y4ZHh/fIAfvtaMueRKZQr
7agxy3MCX/8eCO89uFlHqYWf+zPs1QanKutqmAixo9rYvQb1iQZZz0ino7BAZCEJ
2u23xG93R9x1rMC3i/BSnu9r7WWFzzrT34ydPbIAu1MiSjk6twkwnvLdz1YSK+a6
LxwX3cg8mDQXy4VSo1CqWpMUgK4rbLQ0OxcRtuytZijDDweG0xQ=
=41+2
-----END PGP SIGNATURE-----
--=-=-=--
