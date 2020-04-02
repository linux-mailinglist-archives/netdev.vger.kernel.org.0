Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E9719CD43
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 01:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390101AbgDBXCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 19:02:37 -0400
Received: from mail.mbosch.me ([188.68.58.50]:35124 "EHLO mail.mbosch.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388951AbgDBXCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 19:02:36 -0400
Date:   Fri, 3 Apr 2020 01:02:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mbosch.me; s=mail;
        t=1585868554; bh=ZA44HZoHqEVHLuZkNc60SKvMxV1yc9Z3rjtDzY2SLyg=;
        h=Date:From:To:Subject:References:In-Reply-To;
        b=Vet+QnyZD2cvqZDcxFFnpk5Dotmnwk+iTgCXzpEKaYMQuz5J1YqLDxAkv2WIkr7ZM
         0zDBACjp3M3y2wSeIUhsV5uG500GQbFXjmP1IRsQluMLiWZfv6mc1kMOoDym+SiaYX
         r0XT/frpPT34H7ehvpMPGV4DITjG3DRuwB7vjmy4=
From:   Maximilian Bosch <maximilian@mbosch.me>
To:     netdev@vger.kernel.org
Subject: Re: VRF Issue Since kernel 5
Message-ID: <20200402230233.mumqo22khf7q7o7c@topsnens>
References: <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <20200310204721.7jo23zgb7pjf5j33@topsnens>
 <2583bdb7-f9ea-3b7b-1c09-a273d3229b45@gmail.com>
 <20200401181650.flnxssoyih7c5s5y@topsnens>
 <b6ead5e9-cc0e-5017-e9a1-98b09b110650@gmail.com>
 <20200401203523.vafhsqb3uxfvvvxq@topsnens>
 <00917d3a-17f8-b772-5b93-3abdf1540b94@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cgogtu3d72ghalk2"
Content-Disposition: inline
In-Reply-To: <00917d3a-17f8-b772-5b93-3abdf1540b94@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cgogtu3d72ghalk2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I do not see how this worked on 4.19. My comment above is a fundamental
> property of VRF and has been needed since day 1. That's why 'ip vrf
> exec' exists.

I'm afraid I have to disagree here: first of all, I created a
regression-test in NixOS for this purpose a while ago[1]. The third test-ca=
se
(lines 197-208) does basically what I demonstrated in my previous emails
(opening SSH connetions through a local VRF). This worked fine until we
bumped our default kernel to 5.4.x which is the reason why this testcase
is temporarily commented out.

While this is helpful to demonstrate the issue, I acknowledge that this is
pretty useless for a non-NixOS user which is why I did some further research
today:

After skimming through the VRF-related changes in 4.20 and 5.0 (which
might've had some relevant changes as you suggested previously), I
rebuilt the kernels 5.4.29 and 5.5.13 with
3c82a21f4320c8d54cf6456b27c8d49e5ffb722e[2] reverted on top and the
commented-out testcase works fine again. In other words, my usecase
seems to have worked before and the mentioned commit appears to cause
the "regression".

To provide you with further context, I decided to run
`sudo perf record -e fib:* -a -g -- ssh root@92.60.36.231 -o ConnectTimeout=
=3D10s true`
again on my patched kernel at 5.5.13.

The result is available under
https://gist.githubusercontent.com/Ma27/a6f83e05f6ffede21c2e27d5c7d27098/ra=
w/40c78603d5f76caa8717e293aba5c609bf7f013d/perf-report.txt

Thanks!

  Maximilian

[1] https://github.com/NixOS/nixpkgs/blob/58c7a952a13a65398bed3f539061e69f5=
23ee377/nixos/tests/systemd-networkd-vrf.nix
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D3c82a21f4320c8d54cf6456b27c8d49e5ffb722e

On Wed, Apr 01, 2020 at 02:41:56PM -0600, David Ahern wrote:
> On 4/1/20 2:35 PM, Maximilian Bosch wrote:
> > Hi!
> >=20
> >> This should work:
> >>     make -C tools/testing/selftests/net nettest
> >>     PATH=3D$PWD/tools/testing/selftests/net:$PATH
> >>     tools/testing/selftests/net/fcnal-test.sh
> >=20
> > Thanks, will try this out later.
> >=20
> >> If you want that ssh connection to work over a VRF you either need to
> >> set the shell context:
> >>     ip vrf exec <NAME> su - $USER
> >>
> >=20
> > Yes, using `ip vrf exec` is basically my current workaround.
>=20
> that's not a workaround, it's a requirement. With VRF configured all
> addresses are relative to the L3 domain. When trying to connect to a
> remote host, the VRF needs to be given.
>=20
> >=20
> >> or add 'ip vrf exec' before the ssh. If it is an incoming connection to
> >> a server the ssh server either needs to be bound to the VRF or you need
> >> 'net.ipv4.tcp_l3mdev_accept =3D 1'
> >=20
> > Does this mean that the `*l3mdev_accept`-parameters only "fix" this
> > issue if the VRF is on the server I connect to?
>=20
> server side setting only.
>=20
> >=20
> > In my case the VRF is on my local machine and I try to connect through
> > the VRF to the server.
> >=20
> >> The tcp reset suggests you are doing an outbound connection but the
> >> lookup for what must be the SYN-ACK is not finding the local socket -
> >> and that is because of the missing 'ip vrf exec' above.
> >=20
> > I only experience this behavior on a 5.x kernel, not on e.g. 4.19
> > though. I may be wrong, but isn't this a breaking change for userspace
> > applications in the end?
>=20
> I do not see how this worked on 4.19. My comment above is a fundamental
> property of VRF and has been needed since day 1. That's why 'ip vrf
> exec' exists.

--cgogtu3d72ghalk2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEPg3TILK+tBEQDaTVCR2/TR/Ea44FAl6GbwkACgkQCR2/TR/E
a44H2gf7BK/PO/5n51NArlRMQ0ueiBcKklq7sb42k2A92QWHCRh5kspICbYRaj0D
hOhTfELJo1FkXrngoI8DpGzFtDB52z83YJFXu8WxIHbMpLwXnSLDElMbaVeXM/N8
EHmTH+Mav6bycUGD9Oo62lHl+GThRPqsiZAoqMe3gZFI/WzyUCYm0RU5HXgKiD28
X7mo8y0S7D+gVuaysuLosqJZlCG0UW0jfWtA39UH+uzzC2BDaSh36KvHLWq1l6ml
lQIDaHSDU8NJc/3Fc2Jk4lQA20jJ+sXVxgLLAlFeQHc54UItBHXyldgz04r1Vgp/
4aic8SUDLUSmN4S702P+VwyCSYc9ZA==
=uLCX
-----END PGP SIGNATURE-----

--cgogtu3d72ghalk2--
