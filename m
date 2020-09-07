Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83E125F2F1
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 08:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgIGGFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 02:05:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46304 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgIGGFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 02:05:40 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599458737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IQ9rQZvwaojnAND98zBS0Qjc2bcI20zafO8aAmRJIC8=;
        b=SHWASEW/ddMLgVqEVez9FCIRid6H6k3eGCMwWSFIl202Lm1w6k91b24uP43AVRtNK5C2kR
        9kASF0XaOCtCwDJvj/I5AvH7lvXDPcnZMTZHh+BkofchcO7Zxep1WIo0l92yoFTOtYC/8I
        cUF6IFfs7AzWC6OxrcJyamPN+2zamf/cvnEQbSl73RISH9EaXP9kT9l9sIB6zuDxFBL1gw
        HQavJCjt7z1OGUdugRijQNQb4OQU4Lmm+TEOq0zkNhE0CkPJdWcNpqS0pkheCh/XqUzzLU
        U1nLLgKuE6rwE5Ow/wvVMe16OjhI0gqIvmUovCV9TTLiQo96ZKWmHqYaDRWEAg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599458737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IQ9rQZvwaojnAND98zBS0Qjc2bcI20zafO8aAmRJIC8=;
        b=Yp7hCd6GGAV8dX/EWzdjHCKi9Mp5D/LVxtNhGX2YSLSyqmdJGB7vMW5vJYfnlFBGj+19Et
        VfJKV/C9tLgazBAw==
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
Subject: Re: [PATCH v5 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20200905204235.f6b5til4sc3hoglr@skbuf>
References: <20200904062739.3540-1-kurt@linutronix.de> <20200904062739.3540-3-kurt@linutronix.de> <20200905204235.f6b5til4sc3hoglr@skbuf>
Date:   Mon, 07 Sep 2020 08:05:25 +0200
Message-ID: <875z8qazq2.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat Sep 05 2020, Vladimir Oltean wrote:
> On Fri, Sep 04, 2020 at 08:27:34AM +0200, Kurt Kanzenbach wrote:
>> Add a basic DSA driver for Hirschmann Hellcreek switches. Those switches=
 are
>> implementing features needed for Time Sensitive Networking (TSN) such as=
 support
>> for the Time Precision Protocol and various shapers like the Time Aware =
Shaper.
>>=20
>> This driver includes basic support for networking:
>>=20
>>  * VLAN handling
>>  * FDB handling
>>  * Port statistics
>>  * STP
>>  * Phylink
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>> +
>> +/* Default setup for DSA:
>> + *  VLAN 2: CPU and Port 1 egress untagged.
>> + *  VLAN 3: CPU and Port 2 egress untagged.
>> + */
>> +static int hellcreek_setup_vlan_membership(struct dsa_switch *ds, int p=
ort,
>> +					   bool enabled)
>
> If you use VLAN 2 and 3 for port separation, then how does the driver
> deal with the following:
>
> ip link add link swp1 name swp1.100 type vlan id 100
> ip link add link swp2 name swp2.100 type vlan id 100
>
> In this case, frames with VLAN 100 shouldn't leak from one port to the
> other, will they?

Well, that depends on whether hellcreek_vlan_add() is called for
creating that vlan interfaces. In general: As soon as both ports are
members of the same vlan that traffic is switched.

>
>> +{
>> +	int upstream =3D dsa_upstream_port(ds, port);
>> +	struct switchdev_obj_port_vlan vlan =3D {
>> +		.vid_begin =3D port,
>> +		.vid_end =3D port,
>> +	};
>> +	int err =3D 0;
>> +
>> +	/* The CPU port is implicitly configured by
>> +	 * configuring the front-panel ports
>> +	 */
>> +	if (!dsa_is_user_port(ds, port))
>> +		return 0;
>> +
>> +	/* Apply vid to port as egress untagged and port vlan id */
>> +	vlan.flags =3D BRIDGE_VLAN_INFO_UNTAGGED | BRIDGE_VLAN_INFO_PVID;
>> +	if (enabled)
>> +		hellcreek_vlan_add(ds, port, &vlan);
>> +	else
>> +		err =3D hellcreek_vlan_del(ds, port, &vlan);
>> +	if (err) {
>> +		dev_err(ds->dev, "Failed to apply VID %d to port %d: %d\n",
>> +			port, port, err);
>> +		return err;
>> +	}
>> +
>> +	/* Apply vid to cpu port as well */
>> +	vlan.flags =3D BRIDGE_VLAN_INFO_UNTAGGED;
>> +	if (enabled)
>> +		hellcreek_vlan_add(ds, upstream, &vlan);
>> +	else
>> +		err =3D hellcreek_vlan_del(ds, upstream, &vlan);
>> +	if (err) {
>> +		dev_err(ds->dev, "Failed to apply VID %d to port %d: %d\n",
>> +			port, port, err);
>> +		return err;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void hellcreek_setup_ingressflt(struct hellcreek *hellcreek, int=
 port,
>> +				       bool enable)
>> +{
>> +	struct hellcreek_port *hellcreek_port =3D &hellcreek->ports[port];
>> +	u16 ptcfg;
>> +
>> +	mutex_lock(&hellcreek->reg_lock);
>> +
>> +	ptcfg =3D hellcreek_port->ptcfg;
>> +
>> +	if (enable)
>> +		ptcfg |=3D HR_PTCFG_INGRESSFLT;
>> +	else
>> +		ptcfg &=3D ~HR_PTCFG_INGRESSFLT;
>> +
>> +	hellcreek_select_port(hellcreek, port);
>> +	hellcreek_write(hellcreek, ptcfg, HR_PTCFG);
>> +	hellcreek_port->ptcfg =3D ptcfg;
>> +
>> +	mutex_unlock(&hellcreek->reg_lock);
>> +}
>> +
>> +static int hellcreek_vlan_filtering(struct dsa_switch *ds, int port,
>> +				    bool vlan_filtering)
>
> I remember asking in Message-ID: <20200716082935.snokd33kn52ixk5h@skbuf>
> whether it would be possible for you to set
> ds->configure_vlan_while_not_filtering =3D true during hellcreek_setup.
> Did anything unexpected happen while trying that?

No, that comment got lost.

So looking at the flag: Does it mean the driver can receive vlan
configurations when a bridge without vlan filtering is used? That might
be problematic as this driver uses vlans for the port separation by
default. This is undone when vlan filtering is set to 1 meaning vlan
configurations can be received without any problems.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9VzaUACgkQeSpbgcuY
8KZPEg//RykS40TAFVuMDei76HWDZDhFXmHSmd1CgdauhC0IIsFsN9DlyVrz8a17
LzItMxsDnzIi3dUNGsA7TAcxyeL6VguUZzOQZV6bcauQJ5+9onbxprxPEQ3u8+ea
ANMBUr0x5crEjy9PJmXcqpCzYoyxwTNHPVesHoAkNGU2evZKu6YHJjPGKuwLgsmd
Zd08zpJQKXMKZC4UnNziFkiWjHZ0f7ge1D90EUZQYfTSLkYmRH3Y2AKgHWobR1Ng
khIc4fg5+s5P2YyJ4lP0/2RPs1gCYFg93XqpmZaY+K/4mtGqfyKDQxb/cp/rFNjx
SpCAie4kleWojT/4YPLbJ9oFoW+GmHydCbUaW2N0/LCc2SQcPt77t/iqH9bU6L/i
a54+LQUQSdeRfDFFySrolYsBht5SWklsJeXlXF9KjSIimUjfAameHsoQfAjqqQBL
Puw3HtU+sF7MnzL1rgM+1PdcKmVYYt7woBMrOx57us8eLYgHe9NS16Y8KHXBAU/y
puobRjZYzWTOcMY8xQ7KFVrfomYJtAUueq7mfupUbZG91fDZZEi4v1Fq3vrAjKzL
lBV+a4GpPtYfOfkPtZqoK46aWbn6AgZcwfrZJN8gW9z2tCDsOCl1V7ldhOIkwyQz
f5qeo6UsiyR3hm+9dM8x+aGcsNmxg2UONMxkv5hrzD7W0qqGmzc=
=FkPv
-----END PGP SIGNATURE-----
--=-=-=--
