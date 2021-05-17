Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1F138307E
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 16:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbhEQO2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 10:28:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:55454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237660AbhEQO0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 10:26:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621261486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=psXfcclVTBaiBuEIRBHeyf5N3qXDyygm0+4A2JGIQ2I=;
        b=KFAlAk5kSj9kN5kOhQ5f5uuc1L1wcG6xJBafUPAuFXYrJkKsStZorfXq69wfCCssTNvTJh
        PaYfYH1w2jy9ZnCYJZcNLEMZqvG79fCPDvFgLurQo1JND9YfAbxks3S8HU3Ob+ucoAuMRn
        FYNE0pl+fX5WB776RmWaWZwPUDmaP8Y=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E0048B233;
        Mon, 17 May 2021 14:24:45 +0000 (UTC)
Subject: Re: [PATCH 5/8] xen/netfront: read response from backend only once
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210513100302.22027-1-jgross@suse.com>
 <20210513100302.22027-6-jgross@suse.com>
 <c9f90370-fc02-3f05-0670-35f795c59d95@suse.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <132c33ae-52c9-532b-b0b4-b5952db09720@suse.com>
Date:   Mon, 17 May 2021 16:24:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <c9f90370-fc02-3f05-0670-35f795c59d95@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="erLtx1Uu4AqeXpHOV2LdFAUXM77dGXQRf"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--erLtx1Uu4AqeXpHOV2LdFAUXM77dGXQRf
Content-Type: multipart/mixed; boundary="iIxXbN4RlBG5iLT9GjgqjHMfgfF7HsdnN";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <132c33ae-52c9-532b-b0b4-b5952db09720@suse.com>
Subject: Re: [PATCH 5/8] xen/netfront: read response from backend only once
References: <20210513100302.22027-1-jgross@suse.com>
 <20210513100302.22027-6-jgross@suse.com>
 <c9f90370-fc02-3f05-0670-35f795c59d95@suse.com>
In-Reply-To: <c9f90370-fc02-3f05-0670-35f795c59d95@suse.com>

--iIxXbN4RlBG5iLT9GjgqjHMfgfF7HsdnN
Content-Type: multipart/mixed;
 boundary="------------06866E4B8953044595525960"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------06866E4B8953044595525960
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 17.05.21 16:20, Jan Beulich wrote:
> On 13.05.2021 12:02, Juergen Gross wrote:
>> In order to avoid problems in case the backend is modifying a response=

>> on the ring page while the frontend has already seen it, just read the=

>> response into a local buffer in one go and then operate on that buffer=

>> only.
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>=20
> Reviewed-by: Jan Beulich <jbeulich@suse.com>
> with one remark:
>=20
>> @@ -830,24 +830,22 @@ static int xennet_get_extras(struct netfront_que=
ue *queue,
>>   			break;
>>   		}
>>  =20
>> -		extra =3D (struct xen_netif_extra_info *)
>> -			RING_GET_RESPONSE(&queue->rx, ++cons);
>> +		RING_COPY_RESPONSE(&queue->rx, ++cons, &extra);
>>  =20
>> -		if (unlikely(!extra->type ||
>> -			     extra->type >=3D XEN_NETIF_EXTRA_TYPE_MAX)) {
>> +		if (unlikely(!extra.type ||
>> +			     extra.type >=3D XEN_NETIF_EXTRA_TYPE_MAX)) {
>>   			if (net_ratelimit())
>>   				dev_warn(dev, "Invalid extra type: %d\n",
>> -					extra->type);
>> +					extra.type);
>>   			err =3D -EINVAL;
>>   		} else {
>> -			memcpy(&extras[extra->type - 1], extra,
>> -			       sizeof(*extra));
>> +			memcpy(&extras[extra.type - 1], &extra, sizeof(extra));
>=20
> Maybe take the opportunity and switch to (type safe) structure
> assignment?

Yes, good idea.


Juergen

--------------06866E4B8953044595525960
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Description: OpenPGP public key
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

--------------06866E4B8953044595525960--

--iIxXbN4RlBG5iLT9GjgqjHMfgfF7HsdnN--

--erLtx1Uu4AqeXpHOV2LdFAUXM77dGXQRf
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmCifK0FAwAAAAAACgkQsN6d1ii/Ey/t
Owf/W6F4yLE4ar8JzbuqpMqSkwm/nom8yx9ADY79ZCrrpRZH3MMBlbmzarNCoGZ4+hQknSwyFHf9
XRLfQEFoRGt1EYJKhiwkT5jnqa0DXQmEphb8rYVlhVtt87OBs8xOBhvDR5qYa0lT9rNl6jon/h/R
k6eo3fQ6U3i0SsPghYxwxsOrUJ5T8PApQwn2kBC+VnzlOfdTByLw+fA84fxf+6WKqsRt/SDyr/4t
3FpdfKqgjI+5xyeaGY+KIz8tpBnAgk+8NzfGzV7mT1n++SQwaZtc4hLiTIyONAoFPWg8FxxcZ0iW
aOOpG0nJdWsqIT8w301IS8zVGqTgfBwGOGPcNKaWtw==
=vTDb
-----END PGP SIGNATURE-----

--erLtx1Uu4AqeXpHOV2LdFAUXM77dGXQRf--
