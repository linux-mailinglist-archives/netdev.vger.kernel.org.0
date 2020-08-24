Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC41724F24D
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 08:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgHXGKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 02:10:52 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40522 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgHXGKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 02:10:52 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598249449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ir6fINy3N3sxAruK420IofSpHlFqJK8LbAjfvaW+DJE=;
        b=TITEt5oeLfJhtYPd1SL6CaEABWKyHHkzqz02ODqV2+dV/QYkoX4miaa+A2wD5YlMQxwDds
        DnMRWh+wmk09Nz7vhKhrotQhRqvVCYP1GAeYuO9gJzFVVsvZAAozYVAj5fNgy7G0GWwfAl
        9ZRq1sZBJWEzW6Bzex+2iXdpToOOTwnfy/Onk69CoC8uirbxjvlw9F7F4qRulipK/Sgoyh
        sfcYembALM1yBlq+X1uE1fH6Iln57O2HEacapY5npfw42BWZtkV1RBJmMTv654GpVwX4cT
        OpXK5Uko0ZuEatXATiMBmHMmKYnx4BmFWPO3/ZUYjBYHYI94eslJhXYVLLQdLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598249449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ir6fINy3N3sxAruK420IofSpHlFqJK8LbAjfvaW+DJE=;
        b=kVJ6XsCBeZexi4YM0vCM7OM35ynpbRCUSnkZRVqk+jGDsnbRdNuBeHy7kU9N5ldZUahvGq
        wqf0vTZSNG4JDpDg==
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
In-Reply-To: <20200822143922.frjtog4mcyaegtyg@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <20200822143922.frjtog4mcyaegtyg@skbuf>
Date:   Mon, 24 Aug 2020 08:10:36 +0200
Message-ID: <87imd8zi8z.fsf@kurt>
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

On Sat Aug 22 2020, Vladimir Oltean wrote:
> Hi Kurt,
>
> On Thu, Aug 20, 2020 at 10:11:15AM +0200, Kurt Kanzenbach wrote:
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
>>  * Setup hrtimer for starting the schedule
>>=20
>> The hardware supports starting a schedule up to eight seconds in the fut=
ure. The
>> TAPRIO interface provides an absolute base time. Therefore, hrtimers are
>> leveraged.
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>>  drivers/net/dsa/hirschmann/hellcreek.c | 294 +++++++++++++++++++++++++
>>  drivers/net/dsa/hirschmann/hellcreek.h |  21 ++
>>  2 files changed, 315 insertions(+)
>>=20
>> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hi=
rschmann/hellcreek.c
>> index 745ca60342b4..e5b54f42c635 100644
>> --- a/drivers/net/dsa/hirschmann/hellcreek.c
>> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
>> @@ -22,7 +22,9 @@
>>  #include <linux/spinlock.h>
>>  #include <linux/delay.h>
>>  #include <linux/ktime.h>
>> +#include <linux/time.h>
>>  #include <net/dsa.h>
>> +#include <net/pkt_sched.h>
>>=20=20
>>  #include "hellcreek.h"
>>  #include "hellcreek_ptp.h"
>> @@ -153,6 +155,15 @@ static void hellcreek_select_vlan(struct hellcreek =
*hellcreek, int vid,
>>  	hellcreek_write(hellcreek, val, HR_VIDCFG);
>>  }
>>=20=20
>> +static void hellcreek_select_tgd(struct hellcreek *hellcreek, int port)
>> +{
>> +	u16 val =3D 0;
>> +
>> +	val |=3D port << TR_TGDSEL_TDGSEL_SHIFT;
>> +
>> +	hellcreek_write(hellcreek, val, TR_TGDSEL);
>> +}
>> +
>>  static int hellcreek_wait_until_ready(struct hellcreek *hellcreek)
>>  {
>>  	u16 val;
>> @@ -958,6 +969,24 @@ static void __hellcreek_setup_tc_identity_mapping(s=
truct hellcreek *hellcreek)
>>  	}
>>  }
>>=20=20
>> +static void hellcreek_setup_tc_mapping(struct hellcreek *hellcreek,
>> +				       struct net_device *netdev)
>> +{
>> +	int i, j;
>> +
>> +	/* Setup mapping between traffic classes and port queues. */
>> +	for (i =3D 0; i < netdev_get_num_tc(netdev); ++i) {
>> +		for (j =3D 0; j < netdev->tc_to_txq[i].count; ++j) {
>> +			const int queue =3D j + netdev->tc_to_txq[i].offset;
>> +
>> +			hellcreek_select_prio(hellcreek, i);
>> +			hellcreek_write(hellcreek,
>> +					queue << HR_PRTCCFG_PCP_TC_MAP_SHIFT,
>> +					HR_PRTCCFG);
>> +		}
>> +	}
>> +}
>
> What other driver have you seen that does this?
>

Probably none.

With TAPRIO traffic classes and the mapping to queues can be
configured. The switch can also map traffic classes. That sounded like a
good match to me.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9DWdwACgkQeSpbgcuY
8KaY6hAAjzRy8J2bN+84vK3lOAWesijRbxOy8c34j78vsszIYb3i4U9kxBBZkNE3
cDDEF5MDfm8CTBvQkbJAX1NG1fSsR8vez64AGO4OwN+F4oPttAlwEPuGJrN2kKGS
j/dHTlt0jCggnjZiNjyXqpxqEyMxGOhAO0hJdiLc/c9acrkuaYGQjvsJ8wU3/m3T
6NfAVClZNsbHr9JBVzc2G7DBCZtgoAjYmjmr5KTh2Bj15UFFDfifnPlrqGBAB0Fw
orTpvRtLKinvnXCtQW7OR217gyR7o9p5bR9vpQkltHi6ziscZCUVCiv5ME0dEpwK
c/VRnsg6oc3JbWTZnjPyFn5bzuET9rEZpStnB1TquLcwXQSVj5A0o4N7GD8nSfcZ
dOzZwx1NCwQjEbix7tZPdtk2v4K52+ctWusAI2AxbcNVcxW05st8mTcQFKiF+2Y/
fCzHgYKZJ+9CFKcxzBctEc/O3Se/BcjY8sz5Jdo42NA7tLQQ1J4u/NlnhZajpmnK
b+24WF/pUKmB98xRG6wDuE+4OSMzyGs4hx91xeSgrwDQBwhD1Gw2c5o2YupZzHUj
tbfaxN/VYyenBtfJBp2vEqTYVa3pYPtX0c+C99Vf3MqVtoPOd22K4nTFteJr3BS6
5+N0v0nF49kPLAcmJr/GDE4PvcgqgbykB9Ga8YoIqIdq7iUn0tM=
=yOid
-----END PGP SIGNATURE-----
--=-=-=--
