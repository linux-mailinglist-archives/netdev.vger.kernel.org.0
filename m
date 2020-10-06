Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F3A284C7B
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgJFNXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:23:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36574 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFNXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:23:42 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601990618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AXPEm95Bw/hixuvgwVIQM5OVIsxZxlO6A4MwZv+vsgE=;
        b=ciNlZwxLQdimj4ytMtKHIkqjhpazYOBRcGeTe09KVp7u29AetCSxxJu6n4dc4Z/1IHwnHX
        7mHQFp4hOeb/0EDOMrKz4IIiAAxOzUa3gR9OtZIQGaUv1W0S1dwknKeVMrHA/ZbJ80TUXY
        lKy3im/iocNwCSm+e48gggSyGvjxv/vkiyBqtMTbA7P4xCrvlqte44b8fsUEF2aCR5/WWW
        r6f72y4zEciLOcX0wkBBGPb+GNIORwtXOsCQDDAHlkv6msn5oHdFU+ZQE9XYEBs0W4dDGN
        F+Fz55M1UkTLlWHE0HCQ6831wut0KmaGi3ytp2qNIfMBnCo22h8bUZPmc6BqTA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601990618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AXPEm95Bw/hixuvgwVIQM5OVIsxZxlO6A4MwZv+vsgE=;
        b=ae05X2w1w7lWEJ6gJf2LXb7WIFuU17FX89OgcFqSURq9FYvyoZ4HVne8/jZVtHrzoU+N/V
        rhw4j/SvacjNf9Bg==
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
In-Reply-To: <20201006113237.73rzvw34anilqh4d@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-3-kurt@linutronix.de> <20201004125601.aceiu4hdhrawea5z@skbuf> <87lfgj997g.fsf@kurt> <20201006092017.znfuwvye25vsu4z7@skbuf> <878scj8xxr.fsf@kurt> <20201006113237.73rzvw34anilqh4d@skbuf>
Date:   Tue, 06 Oct 2020 15:23:36 +0200
Message-ID: <87wo037ajr.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Oct 06 2020, Vladimir Oltean wrote:
> Yes, that's what I said, and it's not wrong because there's a big IF ther=
e.
> But first of all, whatever you do has to work, no matter how you do it.
>
> DSA can at any moment call your .port_vlan_add method either from the
> bridge or from the 8021q module. And you need to make sure that you:
>
> - offer the correct services to these layers. Meaning:
>   (a) a bridge with vlan_filtering=3D0 does not expect its offloading
>       ports to filter (drop) by VLAN ID. The only thing that changed
>       after the configure_vlan_while_not_filtering patch was that now,
>       DSA drivers are supposed to make sure that the VLAN database can
>       accept .port_vlan_add calls that were made during the time that
>       vlan_filtering was 0. These VLANs are supposed to make no
>       difference to the data path until vlan_filtering is switched to 1.

Does this mean that tagged traffic is forwarded no matter what? That
doesn't work with the current implementation, because the VLAN tags are
interpreted by default. There's a global flag to put the switch in VLAN
unaware mode. But it's global and not per bridge or port.

>   (b) a bridge with vlan_filtering=3D1 with offloading expects that VLANs
>       from its VLAN group are tagged according to their flags, and
>       forwarded to the other ports that are members of that VLAN group,
>       and VLANs from outside its VLAN group are dropped in hardware.
>   (c) 8021q uppers receive traffic tagged with their VLAN ID
>
> - still keep port separation where that's needed (i.e. in standalone
>   mode). Ports that are not under a bridge do not perform autonomous L2
>   forwarding on their own.
>
> Because port separation is only a concern in standalone mode, I expect
> that you only call hellcreek_setup_vlan_membership when entering
> standalone mode.
>
> So:
> - neither the bridge nor the 8021q module cannot offload a VLAN on a
>   port that is the private pvid of any other standalone port. Maybe this
>   would not even be visible if you would configure those private pvids
>   as 4095, 4094, etc, but you should definitely enfore the restriction.
> - IF you let the bridge or 8021q module use a private pvid of a
>   standalone port during the time that said port did not need it, then
>   you should restore that private pvid when the bridge or 8021q upper is
>   removed. This is the part that seems to be causing problems.
> - in standalone mode, you can't let 8021q uppers request the same VLAN
>   from different ports, as that would break separation.
>
> I am thinking:
> If you _don't_ ever let the private pvids of the standalone ports
> overlap with the valid range for the bridge and 8021q module, then you
> don't need to care whether the bridge or 8021q module could delete a
> private pvid of yours (because you wouldn't let them install it in the
> first place). So you solve half the problem.

So you're saying private VLANs can be used but the user or the other
kernel modules shouldn't be allowed to use them to simplify the
implementation?  Makes sense to me.

>
> Otherwise said:
> If you reject VLANs 4095 and 4094 in the .port_vlan_prepare callback,
> you'll be left with 4094 usable VLANs for the bridge on each port, or
> 4094 VLANs usable for the 8021q module in total (but mutually exclusive
> either on one port or the other). So you lose exactly 2 VLANs, and you
> simplify the driver implementation.
>
> - The .port_vlan_prepare will check whether the VLAN is 4095 or 4094,
>   and if it is, refuse it.
>
> - The .port_vlan_add will always install the VLAN to the hardware
>   database, no queuing if there's no reason for it (and I can't see any.
>   Your hardware seems to be sane enough to not drop a VLAN-tagged frame,
>   and forward it correctly on egress, as long as you call
>   hellcreek_setup_ingressflt with enable=3Dfalse, am I right? or does the
>   VLAN still need to be installed into the egress port?).

The egress port has to member to that VLAN.

>
> - The .port_vlan_del will always delete the VLAN from the hardware.
>
> - The .port_bridge_join will:
>   (a) disable the VLAN ingress filtering that you need for standalone
>       mode. Let the bridge re-enable it if it needs.
>   (b) delete VLAN 4094 or 4095 from the port's database. It bothers you
>       in bridged mode.
>
> - The .port_bridge_leave will:
>   (a) re-enable the VLAN ingress filtering for standalone mode.
>   (b) reinstall VLAN 4094 or 4095 into the port's database. You need it
>       for isolation in standalone mode.
>
> Am I missing something? The rules are relatively simple and intuitive
> (until they aren't!), I'm not trying to impose a certain implementation,
> sorry if that's what you understood, I'm just trying to make sure that
> the rules are observed in the simplest way possible.

And I'm trying to understand what the rules are... Thanks for detailed
explanation.

>
> You'll also need something along the lines of this patch, that's what I
> was hoping to see from you:
>
> ----------------------[ cut here ]----------------------
> From 151271ebeebe520ff997bdc08a3e776fbefce17c Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Tue, 6 Oct 2020 14:06:54 +0300
> Subject: [PATCH] net: dsa: give drivers the chance to veto certain upper
>  devices
>
> Some switches rely on unique pvids to ensure port separation in
> standalone mode, because they don't have a port forwarding matrix
> configurable in hardware. So, setups like a group of 2 uppers with the
> same VLAN, swp0.100 and swp1.100, will cause traffic tagged with VLAN
> 100 to be autonomously forwarded between these switch ports, in spite
> of there being no bridge between swp0 and swp1.
>
> These drivers need to prevent this from happening. They need to have
> VLAN filtering enabled in standalone mode (so they'll drop frames tagged
> with unknown VLANs) and they can only accept an 8021q upper on a port as
> long as it isn't installed on any other port too. So give them the
> chance to veto bad user requests.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/net/dsa.h |  6 ++++++
>  net/dsa/slave.c   | 12 ++++++++++++
>  2 files changed, 18 insertions(+)
>
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index c0185660881c..17e4bb9170e7 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -534,6 +534,12 @@ struct dsa_switch_ops {
>  	void	(*get_regs)(struct dsa_switch *ds, int port,
>  			    struct ethtool_regs *regs, void *p);
>=20=20
> +	/*
> +	 * Upper device tracking.
> +	 */
> +	int	(*port_prechangeupper)(struct dsa_switch *ds, int port,
> +				       struct netdev_notifier_changeupper_info *info);
> +
>  	/*
>  	 * Bridge integration
>  	 */
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index e7c1d62fde99..919dbc1bcf6c 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2006,10 +2006,22 @@ static int dsa_slave_netdevice_event(struct notif=
ier_block *nb,
>  	switch (event) {
>  	case NETDEV_PRECHANGEUPPER: {
>  		struct netdev_notifier_changeupper_info *info =3D ptr;
> +		struct dsa_switch *ds;
> +		struct dsa_port *dp;
> +		int err;
>=20=20
>  		if (!dsa_slave_dev_check(dev))
>  			return dsa_prevent_bridging_8021q_upper(dev, ptr);
>=20=20
> +		dp =3D dsa_slave_to_port(dev);
> +		ds =3D dp->ds;
> +
> +		if (ds->ops->port_prechangeupper) {
> +			err =3D ds->ops->port_prechangeupper(ds, dp->index, ptr);
> +			if (err)
> +				return err;
> +		}
> +
>  		if (is_vlan_dev(info->upper_dev))
>  			return dsa_slave_check_8021q_upper(dev, ptr);
>  		break;
> --=20
> 2.25.1
>
> ----------------------[ cut here ]----------------------
>
> And then you'll implement this callback and reject 8021q uppers (see the
> dsa_slave_check_8021q_upper function for how) with equal VLANs on
> another port. Maybe that's one place where you can keep a VLAN list. But
> that's an implementation detail which should be best left to you to
> figure out.

OK.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl98b9gACgkQeSpbgcuY
8Ka5mA//dPauQLy9178sBMJ2xg2ttPoM8GlTNtqxzu6hAOS1fZ1AM6Napnw5AyCl
0ScOuaEO2sYIIbE4cEFJ5f6O2p27e8MlieKTamiiaRLVEllLe8h20JXRdDTO0Pj5
qLpEIlaB5/q36MKj3HAn584CxXO3PGKYNCnCfuR/b2kGgTEZQG5nuU/AlVMsAYUf
2ozqNNVMWE2G1tkdOXus824hiY2Wmxx+zjuIiH8emXXO9pHA4a1TV5UIY3rlfTkd
KntWwpG6LfILeWpEip6spot/hTmvtfMVjrk2bZSctnb8mk5aid7ubzLxyeCcBzsw
rzh25RNIdxWX1QLDGmB+6GU/wvDISaEH27PKVLqLNBnMwyDzF8Vk+jA9Pp0z3aYv
sTIU3I32rCfimnp6VLd9LuhlZLcBHLzkV7r2gcaSuyDYLuV7lMi3fpNyfBNH2Gxy
CsEmv63wiRyA7Wv/TbA4I9ISpMYbajrSWB+Gaw+dQSSiYb8Ux/uvI3aMfkkojvxd
sIiWxrreKeX81R2zpfFz+JLD9n+P/BvLcPIbkmihI+m5U7cgTkONvhfNhFlphgPi
jkVDw27UVg2sNp+w0cyf/1qrIspEsZqX7mggtqH9HL/pocXmyewe83K+KJe9zWD5
BpVbRqOfsxrDvvrG5GtArbB6vWpOqyq84nm9GbQKAyxYizSouyE=
=vfn8
-----END PGP SIGNATURE-----
--=-=-=--
