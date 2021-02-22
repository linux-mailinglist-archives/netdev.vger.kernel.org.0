Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B123321D3C
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhBVQlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:41:15 -0500
Received: from orthanc.universe-factory.net ([104.238.176.138]:48484 "EHLO
        orthanc.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231280AbhBVQlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 11:41:03 -0500
Received: from [IPv6:2001:19f0:6c01:100::2] (unknown [IPv6:2001:19f0:6c01:100::2])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by orthanc.universe-factory.net (Postfix) with ESMTPSA id D3EB91F508;
        Mon, 22 Feb 2021 17:40:16 +0100 (CET)
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
 <20210219201201.GA4974@katalix.com>
 <2e75a78b-afa2-3776-2695-f9f6ac93eb67@universe-factory.net>
 <20210222114907.GA4943@katalix.com>
From:   Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Re: [PATCH net] net: l2tp: reduce log level when passing up invalid
 packets
Message-ID: <ec0f874e-b5af-1007-5a83-e3de7399ef29@universe-factory.net>
Date:   Mon, 22 Feb 2021 17:40:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222114907.GA4943@katalix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OlYuSA0aS97zS09WTe3eGl9WCQlal9BcS"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OlYuSA0aS97zS09WTe3eGl9WCQlal9BcS
Content-Type: multipart/mixed; boundary="XuVbPkvPhSStZrBy2WEsbC9LFpsMyJJ8a";
 protected-headers="v1"
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: Tom Parkin <tparkin@katalix.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Message-ID: <ec0f874e-b5af-1007-5a83-e3de7399ef29@universe-factory.net>
Subject: Re: [PATCH net] net: l2tp: reduce log level when passing up invalid
 packets
References: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
 <20210219201201.GA4974@katalix.com>
 <2e75a78b-afa2-3776-2695-f9f6ac93eb67@universe-factory.net>
 <20210222114907.GA4943@katalix.com>
In-Reply-To: <20210222114907.GA4943@katalix.com>

--XuVbPkvPhSStZrBy2WEsbC9LFpsMyJJ8a
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: quoted-printable

On 2/22/21 12:49 PM, Tom Parkin wrote:
> On  Sat, Feb 20, 2021 at 10:56:33 +0100, Matthias Schiffer wrote:
>> On 2/19/21 9:12 PM, Tom Parkin wrote:
>>> On  Fri, Feb 19, 2021 at 20:06:15 +0100, Matthias Schiffer wrote:
>>>> Before commit 5ee759cda51b ("l2tp: use standard API for warning log
>>>> messages"), it was possible for userspace applications to use their =
own
>>>> control protocols on the backing sockets of an L2TP kernel device, a=
nd as
>>>> long as a packet didn't look like a proper L2TP data packet, it woul=
d be
>>>> passed up to userspace just fine.
>>>
>>> Hum.  I appreciate we're now logging where we previously were not, bu=
t
>>> I would say these warning messages are valid.
>>>
>>> It's still perfectly possible to use the L2TP socket for the L2TP con=
trol
>>> protocol: packets per the RFCs won't trigger these warnings to the
>>> best of my knowledge, although I'm happy to be proven wrong!
>>>
>>> I wonder whether your application is sending non-L2TP packets over th=
e
>>> L2TP socket?  Could you describe the usecase?
>>
>> I'm the developer of the UDP-based VPN/tunnel application fastd [1]. T=
his is
>> currently a pure userspace implementation, supporting both encrypted a=
nd
>> unencrypted tunnels, with a protocol that doesn't look anything like L=
2TP.
>>
>> To improve performance of unencrypted tunnels, I'm looking into using =
L2TP
>> to offload the data plane to the kernel. Whether to make use of this w=
ould
>> be negotiated in a session handshake (that is also used for key exchan=
ge in
>> encrypted mode).
>>
>> As the (IPv4) internet is stupid and everything is NATted, and I even =
want
>> to support broken NAT routers that somehow break UDP hole punching, I =
use
>> only a single socket for both control (handshake) and data packets.
>=20
> Thanks for describing the usecase a bit more.  It looks an interesting
> project.
>=20
> To be honest I'm not sure the L2TP subsystem is a good match for
> fastd's datapath offload though.
>=20
> This is for the following reasons:
>=20
> Firstly, the warnings referenced in your patch are early in the L2TP re=
cv
> path, called shortly after our hook into the UDP recv code.
>=20
> So at this point, I don't believe the L2TP subsystem is really buying y=
ou
> anything over a plain UPD recv.
>=20
> Now, I'm perhaps reading too much into what you've said, but I imagine
> that fastd using the L2TP tunnel context is just a first step.  I
> assume the end goal for datapath offload would be to use the L2TP
> pseudowire code in order to have session data appear from e.g. a
> virtual Ethernet interface.  That way you get to avoid copying data
> to userspace, and then stuffing it back into the kernel via. tun/tap.
> And that makes sense to me as a goal!

That is indeed what I want to achieve.

>=20
> However, if that is indeed the goal, I really can't see it working
> without fastd's protocol being modified to look like L2TP.  (I also,
> btw, can't see it working without some kind of kernel-space L2TP
> subsystem support for fastd's various encryption protocols, but that's
> another matter).

Only unencrypted connections would be offloaded.

fastd's data protocol will be modified to use L2TP Ethernet pseudowire as=
=20
specified by the RFC (I actually finished the userspace implementation of=
=20
this yesterday, in branch method-l2tp for now). Two peers can negotiate t=
he=20
protocol to use (called "method" in fastd terms) in the session handshake=
=2E=20
A session would only be offloaded to kernel-space L2TP when both sides=20
agree that they indeed want to use the L2TP method; otherwise fastd will =

continue to use TUN/TAP.

The only part of the fastd protocol that I can't modify arbitrarily is th=
e=20
first packet of the handshake, as it must be compatible with older versio=
ns=20
of fastd. There may be a point when I can set the T flag in handshakes=20
unconditionally, but that would be 3~5 years in the future.


>=20
> If you take a look at the session recv datapath from l2tp_recv_common
> onwards you'll see that there is a lot of code you have to avoid
> confusing in l2tp_core.c alone, even before you get into any
> pseudowire-specifics.  I can't see that being possible with fastd's
> current data packet format >
> In summary, I think at this point in the L2TP recv path a normal UDP
> socket would serve you just as well, and I can't see the L2TP subsystem=

> being useful as a data offload mechanism for fastd in the future
> without effectively changing fastd's packet format to look like L2TP.
>=20
> Secondly, given the above (and apologies if I've missed the mark); I
> really wouldn't want to encourage you to use the L2TP subsystem for
> future fastd improvements.
>=20
>  From fastd's perspective it is IMO a bad idea, since it would be easy
> for a future (perfectly valid) change in the L2TP code to accidentally
> break fastd.  And next time it might not be some easily-tweaked thing
> like logging levels, but rather e.g. a security fix or bug fix which
> cannot be undone.
>=20
>  From the L2TP subsystem's perspective it is a bad idea, since by
> encouraging fastd to use the L2TP code, we end up hampering future L2TP=

> development in order to support a project which doesn't actually use
> the L2TP protocol at all.

As explained above, this only concerns fastd's handshake format. As long =
as=20
no new L2TP version accepts 0 as its "Version" field and such packets=20
continue to passed to userspace even without the T flag, fastd would be f=
ine.


>=20
> In the hope of being more constructive -- have you considered whether
> tc and/or ebpf could be used for fastd?  As more generic mechanisms I
> think you might get on better with these than trying to twist the L2TP
> code's arm :-)

(e)BPF might actually be an option. I will look into this.


>=20
>>>> After the mentioned change, this approach would lead to significant =
log
>>>> spam, as the previously hidden warnings are now shown by default. No=
t
>>>> even setting the T flag on the custom control packets is sufficient =
to
>>>> surpress these warnings, as packet length and L2TP version are check=
ed
>>>> before the T flag.
>>>
>>> Possibly we could sidestep some of these warnings by moving the T fla=
g
>>> check further up in the function.
>>>
>>> The code would need to pull the first byte of the header, check the t=
ype
>>> bit, and skip further processing if the bit was set.  Otherwise go on=
 to
>>> pull the rest of the header.
>>>
>>> I think I'd prefer this approach assuming the warnings are not
>>> triggered by valid L2TP messages. >>
>> This will not be sufficient for my usecase: To stay compatible with ol=
der
>> versions of fastd, I can't set the T flag in the first packet of the
>> handshake, as it won't be known whether the peer has a new enough fast=
d
>> version to understand packets that have this bit set. Luckily, the sec=
ond
>> handshake byte is always 0 in fastd's protocol, so these packets fail =
the
>> tunnel version check and are passed to userspace regardless.
>>
>> I'm aware that this usecase is far outside of the original intentions =
of the
>> code and can only be described as a hack, but I still consider this a
>> regression in the kernel, as it was working fine in the past, without
>> visible warnings.
>>
>=20
> I'm sorry, but for the reasons stated above I disagree about it being
> a regression.

Hmm, is it common for protocol implementations in the kernel to warn abou=
t=20
invalid packets they receive? While L2TP uses connected sockets and thus =

usually no unrelated packets end up in the socket, a simple UDP port scan=
=20
originating from the configured remote address/port will trigger the "sho=
rt=20
packet" warning now (nmap uses a zero-length payload for UDP scans by=20
default). Log spam caused by a malicous party might also be a concern.


>=20
>>
>> [1] https://github.com/NeoRaider/fastd/
>>
>>
>>>
>>>>
>>>> Reduce all warnings debug level when packets are passed to userspace=
=2E
>>>>
>>>> Fixes: 5ee759cda51b ("l2tp: use standard API for warning log message=
s")
>>>> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
>>
>>
>>
>>>> ---
>>>>
>>>> I'm unsure what to do about the pr_warn_ratelimited() in
>>>> l2tp_recv_common(). It feels wrong to me that an incoming network pa=
cket
>>>> can trigger a kernel message above debug level at all, so maybe they=

>>>> should be downgraded as well? I believe the only reason these were e=
ver
>>>> warnings is that they were not shown by default.
>>>>
>>>>
>>>>    net/l2tp/l2tp_core.c | 12 ++++++------
>>>>    1 file changed, 6 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
>>>> index 7be5103ff2a8..40852488c62a 100644
>>>> --- a/net/l2tp/l2tp_core.c
>>>> +++ b/net/l2tp/l2tp_core.c
>>>> @@ -809,8 +809,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel=
 *tunnel, struct sk_buff *skb)
>>>>    	/* Short packet? */
>>>>    	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
>>>> -		pr_warn_ratelimited("%s: recv short packet (len=3D%d)\n",
>>>> -				    tunnel->name, skb->len);
>>>> +		pr_debug_ratelimited("%s: recv short packet (len=3D%d)\n",
>>>> +				     tunnel->name, skb->len);
>>>>    		goto error;
>>>>    	}
>>>> @@ -824,8 +824,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel=
 *tunnel, struct sk_buff *skb)
>>>>    	/* Check protocol version */
>>>>    	version =3D hdrflags & L2TP_HDR_VER_MASK;
>>>>    	if (version !=3D tunnel->version) {
>>>> -		pr_warn_ratelimited("%s: recv protocol version mismatch: got %d e=
xpected %d\n",
>>>> -				    tunnel->name, version, tunnel->version);
>>>> +		pr_debug_ratelimited("%s: recv protocol version mismatch: got %d =
expected %d\n",
>>>> +				     tunnel->name, version, tunnel->version);
>>>>    		goto error;
>>>>    	}
>>>> @@ -863,8 +863,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel=
 *tunnel, struct sk_buff *skb)
>>>>    			l2tp_session_dec_refcount(session);
>>>>    		/* Not found? Pass to userspace to deal with */
>>>> -		pr_warn_ratelimited("%s: no session found (%u/%u). Passing up.\n"=
,
>>>> -				    tunnel->name, tunnel_id, session_id);
>>>> +		pr_debug_ratelimited("%s: no session found (%u/%u). Passing up.\n=
",
>>>> +				     tunnel->name, tunnel_id, session_id);
>>>>    		goto error;
>>>>    	}



--XuVbPkvPhSStZrBy2WEsbC9LFpsMyJJ8a--

--OlYuSA0aS97zS09WTe3eGl9WCQlal9BcS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEZmTnvaa2aYgexS51Fu8/ZMsgHZwFAmAz3nAFAwAAAAAACgkQFu8/ZMsgHZyV
+w//dk3WZStQWynrdIhQ9QM+jhxoljLAOtxGZR7k1fhpq7314OBVqYlltpwA/vp0X6FN7Ut93+2a
z2L6cEai4YEINoq0C9Ecp1Mi+e4sIWmmDtMpvm7UzAKwgF7ssyafCzedephDj68H9ogj4W3frV/4
BH2x2klmlIfjj27RF8CKiEXXAC4uPDi4EfJVhIMuhF/ZAD0vi8GFChAGM4Zv+PqnABo9wh/BO8TJ
aXXYO/tHI54lXj0YbakCCr3yodv1kX5xHSDjW19DmMWszz9ZZJ/1mPCmi0cy66BtHq6UbQ//K4yr
a/JknVRsh55bx2kxoghqhbI/BLGTY51KvqQj2LASCOWgTFYImCkpzHDSq97aaPvzjMo1nc3synBN
QSplQ73LowT5zdCexpHKDK0V8aQ4D3nRedTmGRz7mg3a2wl48Oz9yNXVVBRH8aVg8+QuF4YNvJbj
gGWTbhlSourjgEkmUenGmWezzetnsan0NML9ZboyB1PwX5xgjtl1+jo/LmLLLmS9nMqevQhbEB+b
JSBa/Ng5nj+9h7LjKRX8q+a9cdpvd5uh06PZem60KOmm7qG5+/hKM3fszj2R+Ctaed63oQwtQFxc
IymCzvdQ6rz5b5RYEiCgj1etH0Ireckc795yAXDh9ryzi6AYG1zNgAyf/SoetMR2+auiteUr4xXf
eXU=
=nbku
-----END PGP SIGNATURE-----

--OlYuSA0aS97zS09WTe3eGl9WCQlal9BcS--
