Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECF571477
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbfGWI6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:58:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53466 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727748AbfGWI6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 04:58:07 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB0EEC18B2D9;
        Tue, 23 Jul 2019 08:58:06 +0000 (UTC)
Received: from ovpn-117-106.ams2.redhat.com (ovpn-117-106.ams2.redhat.com [10.36.117.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D0EB41001B28;
        Tue, 23 Jul 2019 08:58:04 +0000 (UTC)
Message-ID: <0fc58a4883f6656208b9250876e53d723919e342.camel@redhat.com>
Subject: Re: [PATCH net-next v2 3/3] netlink: add validation of NLA_F_NESTED
 flag
From:   Thomas Haller <thaller@redhat.com>
To:     Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Date:   Tue, 23 Jul 2019 10:57:54 +0200
In-Reply-To: <6b6ead21c5d8436470b82ab40355f6bd7dbbf14b.1556806084.git.mkubecek@suse.cz>
References: <cover.1556806084.git.mkubecek@suse.cz>
         <6b6ead21c5d8436470b82ab40355f6bd7dbbf14b.1556806084.git.mkubecek@suse.cz>
Organization: Red Hat
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-rWRNAe4I++vsGAiuCtRA"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 23 Jul 2019 08:58:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-rWRNAe4I++vsGAiuCtRA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-05-02 at 16:15 +0200, Michal Kubecek wrote:
> Add new validation flag NL_VALIDATE_NESTED which adds three
> consistency
> checks of NLA_F_NESTED_FLAG:
>=20
>   - the flag is set on attributes with NLA_NESTED{,_ARRAY} policy
>   - the flag is not set on attributes with other policies except
> NLA_UNSPEC
>   - the flag is set on attribute passed to nla_parse_nested()
>=20
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
>=20
> v2: change error messages to mention NLA_F_NESTED explicitly
> ---
>  include/net/netlink.h | 11 ++++++++++-
>  lib/nlattr.c          | 15 +++++++++++++++
>  2 files changed, 25 insertions(+), 1 deletion(-)

Hi,


libnl3 does currently not ever set NLA_F_NESTED flag.

That means, nla_nest_start() will not work as it used to.
https://github.com/thom311/libnl/blob/65b3dd5ac2d5de4c7a0c64e430596d9d27973=
527/lib/attr.c#L902

As workaround, one could call

  nla_nest_start(msg, NLA_F_NESTED | attr);


Of course, that is a bug in libnl3 that should be fixed. But it seems
quite unfortunate to me.


Does this flag and strict validation really provide any value? Commonly a n=
etlink message
is a plain TLV blob, and the meaning depends entirely on the policy.

What I mean is that for example

  NLA_PUT_U32 (msg, ATTR_IFINDEX, (uint32_t) ifindex)
  NLA_PUT_STRING (msg, ATTR_IFNAME, "net")

results in a 4 bytes payload that does not encode whether the data is a num=
ber or
a string.

Why is it valuable in this case to encode additional type information insid=
e the message,
when it's commonly not done and also not necessary?


best,
Thomas

--=-rWRNAe4I++vsGAiuCtRA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEESep8Zw4IUOdBlRT2KcI2bk38VygFAl02zBIACgkQKcI2bk38
VyiG5g/+Nz8gA69nc2FT1SLcKISfH9GaebM8sBPW0RtlQPuXuW9SItdje+WqATBZ
0uAlHMrX1zk3G07WsN/V6lFAm4buMj5eDMvZgoR+lJKMklckegrPuGfWtvsQE3aB
GLMcL5LmzelVaQG/BmKTFgFo+4RJwEEFzG5KXLDKVDT1ta9fFRwIIqfCQntZjWEX
1SZS5zmAy5+XJJVgQTPM3W0mcT4hb9ycFK9+qijRUtBvgJmZVezwowC3SpVx2Vs/
vR4PKmNi+tx6AT8u3fxMRUypiTZqOpqqWA2hq/1UzHGjV11MprD+zApN11ae6FTf
1ARfAIa9DJXBGzRXGnqOpjg3GYVD5haA1U7v3xYW6sIoqpDkx4Cl3iwljIP117/c
s9Jt6dVR+YWF7lugH5Tgwq6oo0AcwEbu64YP3+sEJaGwPm0CJMePfMzeacPwx5zF
D1Guxi4O1EyyzXZO1Y60URAo3cRoxigssX5MHvKYEB70+A0YHPe1mhQ4YeJQRmX5
ZAWXa3mIpy8i63F8zHXV7eUMWJL3PH7IxYCb+YqC9h8IKPItN6RVkv4M+bJZ0VJj
K9Yyl5eup9Db7o5rThw22YBJ0xcNJvZjxCloQQs69Q7ElPbIykrqeEhEBLiRNyx/
Oty9bR8bXrTZN3q9Oqd7kWn0FeQm18rFwKhVxlqI7HdDGeFjP0k=
=vh60
-----END PGP SIGNATURE-----

--=-rWRNAe4I++vsGAiuCtRA--

