Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0F730EC12
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 06:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhBDFdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 00:33:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:39992 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhBDFdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 00:33:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612416754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7bOPQvy7qTInyB9wYQ9IL2fnW0fKtEjyxYEe1vYqV0c=;
        b=Hi8wPm5pIzWzXmj5NK+rF+oJbT/b2+PtaRhTiXfHfgTJfcncJB2ngC2gblQQ+UlJDKjA6U
        CHZAYXOeQmqs2CBkbHEiGWKGL51DEt+JrhuhjLB0DwK6KguPPHTWUQD26pv1uDqNCSdw40
        X6zsvPzYwLsYdBde0wCHKwQNNwb7FRk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DE6EBAD37;
        Thu,  4 Feb 2021 05:32:33 +0000 (UTC)
Subject: Re: [PATCH] xen/netback: avoid race in
 xenvif_rx_ring_slots_available()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Druzhinin <igor.druzhinin@citrix.com>,
        stable@vger.kernel.org
References: <20210202070938.7863-1-jgross@suse.com>
 <20210203154800.4c6959d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <f6fa1533-0646-e8b1-b7f8-51ad70691cae@suse.com>
Date:   Thu, 4 Feb 2021 06:32:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210203154800.4c6959d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mHapG4vhTCP36nbTdrhUC7cqDD240Fsgi"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mHapG4vhTCP36nbTdrhUC7cqDD240Fsgi
Content-Type: multipart/mixed; boundary="3tMIMW2EI4iG1ylfu3D1bWpPCgMh1TUEY";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
 Paul Durrant <paul@xen.org>, "David S. Miller" <davem@davemloft.net>,
 Igor Druzhinin <igor.druzhinin@citrix.com>, stable@vger.kernel.org
Message-ID: <f6fa1533-0646-e8b1-b7f8-51ad70691cae@suse.com>
Subject: Re: [PATCH] xen/netback: avoid race in
 xenvif_rx_ring_slots_available()
References: <20210202070938.7863-1-jgross@suse.com>
 <20210203154800.4c6959d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203154800.4c6959d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>

--3tMIMW2EI4iG1ylfu3D1bWpPCgMh1TUEY
Content-Type: multipart/mixed;
 boundary="------------0650DBEFF4F58FCE9BE6C4D9"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------0650DBEFF4F58FCE9BE6C4D9
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 04.02.21 00:48, Jakub Kicinski wrote:
> On Tue,  2 Feb 2021 08:09:38 +0100 Juergen Gross wrote:
>> Since commit 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding"=
)
>> xenvif_rx_ring_slots_available() is no longer called only from the rx
>> queue kernel thread, so it needs to access the rx queue with the
>> associated queue held.
>>
>> Reported-by: Igor Druzhinin <igor.druzhinin@citrix.com>
>> Fixes: 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>=20
> Should we route this change via networking trees? I see the bug did not=

> go through networking :)
>=20

I'm fine with either networking or the Xen tree. It should be included
in 5.11, though. So if you are willing to take it, please do so.


Juergen

--------------0650DBEFF4F58FCE9BE6C4D9
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="OpenPGP_0xB0DE9DD628BF132F.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOBy=
cWx
w3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJvedYm8O=
f8Z
d621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y=
9bf
IhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xq=
G7/
377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR=
3Jv
c3MgPGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsEFgIDA=
QIe
AQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4FUGNQH2lvWAUy+dnyT=
hpw
dtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3TyevpB0CA3dbBQp0OW0fgCetToGIQrg0=
MbD
1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbv=
oPH
Z8SlM4KWm8rG+lIkGurqqu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v=
5QL
+qHI3EIPtyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVyZ=
2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJCAcDAgEGFQgCC=
QoL
BBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4RF7HoZhPVPogNVbC4YA6lW7Dr=
Wf0
teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz78X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC=
/nu
AFVGy+67q2DH8As3KPu0344TBDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0Lh=
ITT
d9jLzdDad1pQSToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLm=
XBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkMnQfvUewRz=
80h
SnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMBAgAjBQJTjHDXAhsDBwsJC=
AcD
AgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJn=
FOX
gMLdBQgBlVPO3/D9R8LtF9DBAFPNhlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1=
jnD
kfJZr6jrbjgyoZHiw/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0=
N51
N5JfVRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwPOoE+l=
otu
fe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK/1xMI3/+8jbO0tsn1=
tqS
EUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuZGU+wsB5BBMBAgAjBQJTjHDrA=
hsD
BwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3=
g3O
ZUEBmDHVVbqMtzwlmNC4k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5=
dM7
wRqzgJpJwK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu5=
D+j
LRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzBTNh30FVKK1Evm=
V2x
AKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37IoN1EblHI//x/e2AaIHpzK5h88N=
Eaw
QsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpW=
nHI
s98ndPUDpnoxWQugJ6MpMncr0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZR=
wgn
BC5mVM6JjQ5xDk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNV=
bVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mmwe0icXKLk=
pEd
IXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0Iv3OOImwTEe4co3c1mwARA=
QAB
wsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMvQ/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEw=
Tbe
8YFsw2V/Buv6Z4Mysln3nQK5ZadD534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1=
vJz
Q1fOU8lYFpZXTXIHb+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8=
VGi
wXvTyJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqcsuylW=
svi
uGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5BjR/i1DG86lem3iBDX=
zXs
ZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------0650DBEFF4F58FCE9BE6C4D9--

--3tMIMW2EI4iG1ylfu3D1bWpPCgMh1TUEY--

--mHapG4vhTCP36nbTdrhUC7cqDD240Fsgi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmAbhvAFAwAAAAAACgkQsN6d1ii/Ey+E
Uwf+JIObFNlFrVyuHtDT+OqNp02a0vcUZ8IKMz8XFYYcfdtdav0EZnV00K6OwsrnBd8bhwUrIoxz
DkrxX5HfAqIUn1y1djZg7Abh0RGnGPACceKkr77Cjxi43nw1+UQxRdoHDvAj2xHzijp2fLdolK34
RtPlDFV0N29+qoyRv1Mhe3d5RvL4nSSMuxtOEvOnn5JAWqC95UUS32RymaLzdWIaz21MBzlpsa9s
AbGGcJZikD6wvIB81Py/CYj00R5fWI+o5ztTTfh1YKOjQuAr7GFWDSPF9KWaPFkUt48mrIzvkJ9V
Sqnjj4uQN9tD4WhouG8EKl9FyXDrtwt773lKKvpaPg==
=ujiM
-----END PGP SIGNATURE-----

--mHapG4vhTCP36nbTdrhUC7cqDD240Fsgi--
