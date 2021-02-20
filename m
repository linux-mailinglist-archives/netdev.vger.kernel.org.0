Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC6F3204DE
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 11:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhBTJ5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 04:57:20 -0500
Received: from orthanc.universe-factory.net ([104.238.176.138]:39056 "EHLO
        orthanc.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229543AbhBTJ5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 04:57:17 -0500
X-Greylist: delayed 53411 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Feb 2021 04:57:15 EST
Received: from [IPv6:2001:19f0:6c01:100::2] (unknown [IPv6:2001:19f0:6c01:100::2])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by orthanc.universe-factory.net (Postfix) with ESMTPSA id 872131F4A7;
        Sat, 20 Feb 2021 10:56:34 +0100 (CET)
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
 <20210219201201.GA4974@katalix.com>
From:   Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Re: [PATCH net] net: l2tp: reduce log level when passing up invalid
 packets
Message-ID: <2e75a78b-afa2-3776-2695-f9f6ac93eb67@universe-factory.net>
Date:   Sat, 20 Feb 2021 10:56:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210219201201.GA4974@katalix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PkYDSBTzuiozT8jhkDV38mldeNnBymYAY"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PkYDSBTzuiozT8jhkDV38mldeNnBymYAY
Content-Type: multipart/mixed; boundary="Hm2toQXqrOao3UtdQAxJYjovU4CZx29y6";
 protected-headers="v1"
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: Tom Parkin <tparkin@katalix.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Message-ID: <2e75a78b-afa2-3776-2695-f9f6ac93eb67@universe-factory.net>
Subject: Re: [PATCH net] net: l2tp: reduce log level when passing up invalid
 packets
References: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
 <20210219201201.GA4974@katalix.com>
In-Reply-To: <20210219201201.GA4974@katalix.com>

--Hm2toQXqrOao3UtdQAxJYjovU4CZx29y6
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: quoted-printable

Hi Tom,

On 2/19/21 9:12 PM, Tom Parkin wrote:
> Hi Matthias,
>=20
> Thanks for your patch!
>=20
> On  Fri, Feb 19, 2021 at 20:06:15 +0100, Matthias Schiffer wrote:
>> Before commit 5ee759cda51b ("l2tp: use standard API for warning log
>> messages"), it was possible for userspace applications to use their ow=
n
>> control protocols on the backing sockets of an L2TP kernel device, and=
 as
>> long as a packet didn't look like a proper L2TP data packet, it would =
be
>> passed up to userspace just fine.
>=20
> Hum.  I appreciate we're now logging where we previously were not, but
> I would say these warning messages are valid.
>=20
> It's still perfectly possible to use the L2TP socket for the L2TP contr=
ol
> protocol: packets per the RFCs won't trigger these warnings to the
> best of my knowledge, although I'm happy to be proven wrong!
>=20
> I wonder whether your application is sending non-L2TP packets over the
> L2TP socket?  Could you describe the usecase?

I'm the developer of the UDP-based VPN/tunnel application fastd [1]. This=
=20
is currently a pure userspace implementation, supporting both encrypted a=
nd=20
unencrypted tunnels, with a protocol that doesn't look anything like L2TP=
=2E

To improve performance of unencrypted tunnels, I'm looking into using L2T=
P=20
to offload the data plane to the kernel. Whether to make use of this woul=
d=20
be negotiated in a session handshake (that is also used for key exchange =
in=20
encrypted mode).

As the (IPv4) internet is stupid and everything is NATted, and I even wan=
t=20
to support broken NAT routers that somehow break UDP hole punching, I use=
=20
only a single socket for both control (handshake) and data packets.


>=20
>> After the mentioned change, this approach would lead to significant lo=
g
>> spam, as the previously hidden warnings are now shown by default. Not
>> even setting the T flag on the custom control packets is sufficient to=

>> surpress these warnings, as packet length and L2TP version are checked=

>> before the T flag.
>=20
> Possibly we could sidestep some of these warnings by moving the T flag
> check further up in the function.
>=20
> The code would need to pull the first byte of the header, check the typ=
e
> bit, and skip further processing if the bit was set.  Otherwise go on t=
o
> pull the rest of the header.
>=20
> I think I'd prefer this approach assuming the warnings are not
> triggered by valid L2TP messages.

This will not be sufficient for my usecase: To stay compatible with older=
=20
versions of fastd, I can't set the T flag in the first packet of the=20
handshake, as it won't be known whether the peer has a new enough fastd=20
version to understand packets that have this bit set. Luckily, the second=
=20
handshake byte is always 0 in fastd's protocol, so these packets fail the=
=20
tunnel version check and are passed to userspace regardless.

I'm aware that this usecase is far outside of the original intentions of =

the code and can only be described as a hack, but I still consider this a=
=20
regression in the kernel, as it was working fine in the past, without=20
visible warnings.


[1] https://github.com/NeoRaider/fastd/


>=20
>>
>> Reduce all warnings debug level when packets are passed to userspace.
>>
>> Fixes: 5ee759cda51b ("l2tp: use standard API for warning log messages"=
)
>> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>



>> ---
>>
>> I'm unsure what to do about the pr_warn_ratelimited() in
>> l2tp_recv_common(). It feels wrong to me that an incoming network pack=
et
>> can trigger a kernel message above debug level at all, so maybe they
>> should be downgraded as well? I believe the only reason these were eve=
r
>> warnings is that they were not shown by default.
>>
>>
>>   net/l2tp/l2tp_core.c | 12 ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
>> index 7be5103ff2a8..40852488c62a 100644
>> --- a/net/l2tp/l2tp_core.c
>> +++ b/net/l2tp/l2tp_core.c
>> @@ -809,8 +809,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *=
tunnel, struct sk_buff *skb)
>>  =20
>>   	/* Short packet? */
>>   	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
>> -		pr_warn_ratelimited("%s: recv short packet (len=3D%d)\n",
>> -				    tunnel->name, skb->len);
>> +		pr_debug_ratelimited("%s: recv short packet (len=3D%d)\n",
>> +				     tunnel->name, skb->len);
>>   		goto error;
>>   	}
>> @@ -824,8 +824,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *=
tunnel, struct sk_buff *skb)
>>   	/* Check protocol version */
>>   	version =3D hdrflags & L2TP_HDR_VER_MASK;
>>   	if (version !=3D tunnel->version) {
>> -		pr_warn_ratelimited("%s: recv protocol version mismatch: got %d exp=
ected %d\n",
>> -				    tunnel->name, version, tunnel->version);
>> +		pr_debug_ratelimited("%s: recv protocol version mismatch: got %d ex=
pected %d\n",
>> +				     tunnel->name, version, tunnel->version);
>>   		goto error;
>>   	}
>>  =20
>> @@ -863,8 +863,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *=
tunnel, struct sk_buff *skb)
>>   			l2tp_session_dec_refcount(session);
>>  =20
>>   		/* Not found? Pass to userspace to deal with */
>> -		pr_warn_ratelimited("%s: no session found (%u/%u). Passing up.\n",
>> -				    tunnel->name, tunnel_id, session_id);
>> +		pr_debug_ratelimited("%s: no session found (%u/%u). Passing up.\n",=

>> +				     tunnel->name, tunnel_id, session_id);
>>   		goto error;
>>   	}
>>  =20



--Hm2toQXqrOao3UtdQAxJYjovU4CZx29y6--

--PkYDSBTzuiozT8jhkDV38mldeNnBymYAY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEZmTnvaa2aYgexS51Fu8/ZMsgHZwFAmAw3NEFAwAAAAAACgkQFu8/ZMsgHZwB
VRAA0sCyi0h7M9wRKuwPYot557y3eI3CsV/F46Prod0xkTrnHlScfg7xDo+sRn2THkbIr5Q23tYH
2sGmynfJHQBarbQNOyh7/M8yFoSKy2RjShJ94fqfRODaCxxOTUOnSAI7Gq+X2kCtiH/dpryYbe/s
vXGvPhvsVcfoC6W99JVinHNGPV6LGMNj4NvShM4J/Sdr6mZoMU6PI2zl7Mkm9O+4xmHT2CB1jHL6
7x7yXtTCIPIf/OEMMwoviHbrt90W6yPDId7hPHf7ZwMXuz8Ge0AfBmSvIxCLCeNY8Z8GIq6dE8+n
ClFlI/qTXDJVZ2tV5n7gKrRxv/WGe9WOUVYxJMj2Ifgzas20FEo+/eGFzHDMS98Len60JIf8NUph
wCXvyFHZZyI/nO2t2grOgc1/u1dpwvIlVy2/Fx74BSU0/h2kCDbkEJlfM0iaRWPMqIt/PyiWqcz+
ayiY0KfxcUeVQUq7knBOyfHgswHLujh7Y41YwkIeaHS/CMUqKuFRhEXAo/xf5NGb6qTtSan7NFvl
e3djcdVPCqgV/s4lEsY1+h3Fi5QWndoiizBIdJj39y1CWmoKpIomJbJWqA4o4+5Kl/SNSuEWTmHv
x7U5Db4KuEV3mw49vH4supy0whPyWvHP4R9wYKzU9blan/HNGTsCxsfZ1kEWnJ3skBk/oiIZxYoc
Z+c=
=mKUw
-----END PGP SIGNATURE-----

--PkYDSBTzuiozT8jhkDV38mldeNnBymYAY--
