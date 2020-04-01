Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05FE619B716
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 22:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733027AbgDAUf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 16:35:26 -0400
Received: from mail.mbosch.me ([188.68.58.50]:57388 "EHLO mail.mbosch.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732337AbgDAUfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 16:35:25 -0400
Date:   Wed, 1 Apr 2020 22:35:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mbosch.me; s=mail;
        t=1585773324; bh=CuWbeJhD3hV0jfGTPLHLHXyTZmrbniUamCtz2EzZ3Oo=;
        h=Date:From:To:Subject:References:In-Reply-To;
        b=cGmfl9yUTd2B4+JD7PAHLzVK1uJt4gjX3rEwOmkh0WwC0ptnj3IOgo8+fSzFebFke
         yIRgWjOvGJoQS/1a60Iv7zidGJWkvcBMKe6NOWCHqyWY6dcMgD3JvYqA5f/6J992gE
         ACLAr8ogJIhtaUOVyo4UBVNsgv/Lr/y1EMaS8mHI=
From:   Maximilian Bosch <maximilian@mbosch.me>
To:     netdev@vger.kernel.org
Subject: Re: VRF Issue Since kernel 5
Message-ID: <20200401203523.vafhsqb3uxfvvvxq@topsnens>
References: <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
 <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
 <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <20200310204721.7jo23zgb7pjf5j33@topsnens>
 <2583bdb7-f9ea-3b7b-1c09-a273d3229b45@gmail.com>
 <20200401181650.flnxssoyih7c5s5y@topsnens>
 <b6ead5e9-cc0e-5017-e9a1-98b09b110650@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yo642vexa4szaq7u"
Content-Disposition: inline
In-Reply-To: <b6ead5e9-cc0e-5017-e9a1-98b09b110650@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yo642vexa4szaq7u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This should work:
>     make -C tools/testing/selftests/net nettest
>     PATH=3D$PWD/tools/testing/selftests/net:$PATH
>     tools/testing/selftests/net/fcnal-test.sh

Thanks, will try this out later.

> If you want that ssh connection to work over a VRF you either need to
> set the shell context:
>     ip vrf exec <NAME> su - $USER
>=20

Yes, using `ip vrf exec` is basically my current workaround.

> or add 'ip vrf exec' before the ssh. If it is an incoming connection to
> a server the ssh server either needs to be bound to the VRF or you need
> 'net.ipv4.tcp_l3mdev_accept =3D 1'

Does this mean that the `*l3mdev_accept`-parameters only "fix" this
issue if the VRF is on the server I connect to?

In my case the VRF is on my local machine and I try to connect through
the VRF to the server.

> The tcp reset suggests you are doing an outbound connection but the
> lookup for what must be the SYN-ACK is not finding the local socket -
> and that is because of the missing 'ip vrf exec' above.

I only experience this behavior on a 5.x kernel, not on e.g. 4.19
though. I may be wrong, but isn't this a breaking change for userspace
applications in the end?

Thanks!

  Maximilian

On Wed, Apr 01, 2020 at 01:18:28PM -0600, David Ahern wrote:
> On 4/1/20 12:16 PM, Maximilian Bosch wrote:
> > Hi!
> >=20
> > First of all, sorry for my delayed response!
> >=20
> >> functional test script under tools/testing/selftests/net covers VRF
> >> tests and it ran clean for 5.4 last time I checked. There were a few
> >> changes that went into 4.20 or 5.0 that might be tripping up this use
> >> case, but I need a lot more information.
> >=20
> > I recently started an attempt to get those tests running on my machine
> > (and a Fedora VM after that), however I had several issues with
> > timeouts (when running `sudo -E make -C tools/testing/selftests TARGETS=
=3D"net"
> > run_tests`).
> >=20
> > May I ask if there are further things I need to take care of to get
> > those tests successfully running?
>=20
> This should work:
>     make -C tools/testing/selftests/net nettest
>     PATH=3D$PWD/tools/testing/selftests/net:$PATH
>     tools/testing/selftests/net/fcnal-test.sh
>=20
> >=20
> >> are you saying wireguard worked with VRF in the past but is not now?
> >=20
> > No. WireGuard traffic is still working fine. The only issue is
> > TCP-traffic through a VRF (which worked with 4.19, but doesn't anymore
> > with 5.4 and 5.5).
> >=20
> >> 'ip vrf exec' loads a bpf program and that requires locked memory, so
> >> yes, you need to increase it.
> >=20
> > Thanks a lot for the explanation!
> >=20
> >> Let's start with lookups:
> >>
> >> perf record -e fib:* -a -g
> >> <run test that fails, ctrl-c>
> >> perf script
> >=20
> > For the record, please note that I'm now on Linux 5.5.13.
> >=20
> > I ran the following command:
> >=20
> > ```
> > sudo perf record -e fib:* -a -g -- ssh root@92.60.36.231 -o ConnectTime=
out=3D10s
> > ```
>=20
> If you want that ssh connection to work over a VRF you either need to
> set the shell context:
>     ip vrf exec <NAME> su - $USER
>=20
> or add 'ip vrf exec' before the ssh. If it is an incoming connection to
> a server the ssh server either needs to be bound to the VRF or you need
> 'net.ipv4.tcp_l3mdev_accept =3D 1'
>=20
> >=20
> > The full output can be found here:
> >=20
> > https://gist.githubusercontent.com/Ma27/a6f83e05f6ffede21c2e27d5c7d2709=
8/raw/4852d97ee4860f7887e16f94a8ede4b4406f07bc/perf-report.txt
>=20
> seems like you have local rule ahead of the l3mdev rule. The order
> should be:
>=20
> # ip ru ls
> 1000:	from all lookup [l3mdev-table]
> 32765:	from all lookup local
> 32766:	from all lookup main
>=20
> That is not the problem, I just noticed some sub-optimal lookups.
>=20
> The tcp reset suggests you are doing an outbound connection but the
> lookup for what must be the SYN-ACK is not finding the local socket -
> and that is because of the missing 'ip vrf exec' above.

--yo642vexa4szaq7u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEPg3TILK+tBEQDaTVCR2/TR/Ea44FAl6E+wsACgkQCR2/TR/E
a44KdggAlIV10jZn2kBgzH8Jsn+oDe3XkHXgqNA7/fop36oOZDZ7kONCj+lJIXmM
mk1wyz1hrGQb6dxkWQqy6X9vQuqp462tqjSbEh+LD38gVZxfki6L4YAjFZImBHP8
S37bcHdfpHFZMCf4XX5bgsSqRvUcolR8WUtTeFERbR641jmNGxUCPBeSr42hA71W
0C7i4t10kgQYL+hwFbdlxVaR5hmSmFmwmcBnOrQfCtwLEst8dyOt3NPpHDfN5Clp
NvkGzLTVl+fr2rNvqJxN0obY36sJFqIpSDAnup6+22zQb3+9NP0mWKWGaiCi/Clx
N08DGCQI/OSXsyJWc3BZZAMoGsiOgQ==
=1I16
-----END PGP SIGNATURE-----

--yo642vexa4szaq7u--
