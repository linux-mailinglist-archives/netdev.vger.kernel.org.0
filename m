Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234F5212FA9
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgGBWog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:44:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:39414 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgGBWof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 18:44:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EE276ABCE;
        Thu,  2 Jul 2020 22:44:33 +0000 (UTC)
Date:   Fri, 3 Jul 2020 08:44:22 +1000
From:   Aleksa Sarai <asarai@suse.de>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        netdev@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Matt Bennett <matt.bennett@alliedtelesis.co.nz>,
        zbr@ioremap.net
Subject: Re: [PATCH 0/5] RFC: connector: Add network namespace awareness
Message-ID: <20200702224422.rtbzxuock523o4ls@yavin.dot.cyphar.com>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
 <87h7uqukct.fsf@x220.int.ebiederm.org>
 <20200702191025.bqxqwsm6kwnhm2p7@wittgenstein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7yvvc7bj43wjipa4"
Content-Disposition: inline
In-Reply-To: <20200702191025.bqxqwsm6kwnhm2p7@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7yvvc7bj43wjipa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-07-02, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> On Thu, Jul 02, 2020 at 08:17:38AM -0500, Eric W. Biederman wrote:
> > Matt Bennett <matt.bennett@alliedtelesis.co.nz> writes:
> >=20
> > > Previously the connector functionality could only be used by processe=
s running in the
> > > default network namespace. This meant that any process that uses the =
connector functionality
> > > could not operate correctly when run inside a container. This is a dr=
aft patch series that
> > > attempts to now allow this functionality outside of the default netwo=
rk namespace.
> > >
> > > I see this has been discussed previously [1], but am not sure how my =
changes relate to all
> > > of the topics discussed there and/or if there are any unintended side=
 effects from my draft
> > > changes.
> >=20
> > Is there a piece of software that uses connector that you want to get
> > working in containers?
> >=20
> > I am curious what the motivation is because up until now there has been
> > nothing very interesting using this functionality.  So it hasn't been
> > worth anyone's time to make the necessary changes to the code.
>=20
> Imho, we should just state once and for all that the proc connector will
> not be namespaced. This is such a corner-case thing and has been
> non-namespaced for such a long time without consistent push for it to be
> namespaced combined with the fact that this needs quite some code to
> make it work correctly that I fear we end up buying more bugs than we're
> selling features. And realistically, you and I will end up maintaining
> this and I feel this is not worth the time(?). Maybe I'm being too
> pessimistic though.

It would be nice to have the proc connector be namespaced, because it
would allow you to have init systems that don't depend on cgroups to
operate -- and it would allow us to have a subset of FreeBSD's kqueue
functionality that doesn't exist today under Linux. However, arguably
pidfds might be a better path forward toward implementing such events
these days -- and is maybe something we should look into.

All of that being said, I agree that doing this is going to be
particularly hairy and likely not worth the effort. In particular, the
proc connector is:

 * Almost entirely unused (and largely unknown) by userspace.

 * Fairly fundamentally broken right now (the "security feature" of
   PROC_CN_MCAST_LISTEN doesn't work because once there is one listener,
   anyone who opens an cn_proc socket can get all events on the system
   -- and if the process which opened the socket dies with calling
   PROC_CN_MCAST_IGNORE then that information is now always streaming).
   So if we end up supporting this, we'll need to fix those bugs too.

 * Is so deeply intertwined with netlink and thus is so deeply embedded
   with network namespaces (rather than pid namespaces) meaning that
   getting it to correctly handle shared-network-namespace cases is
   going to be a nightmare. I agree with Eric that this patchset looks
   like it doesn't approach the problem from the right angle (and
   thinking about how you could fix it makes me a little nervous).

Not to mention that when I brought this up with the maintainer listed in
MAINTAINERS a few years ago (soon after I posted [1]), I was told that
they no longer maintain this code -- so whoever touches it next is the
new maintainer.

In 2017, I wrote that GNU Shepherd uses cn_proc, however I'm pretty sure
(looking at the code now) that it wasn't true then and isn't true now
(Shepherd seems to just do basic pidfile liveliness checks). So even the
niche example I used then doesn't actually use cn_proc.

[1]: https://lore.kernel.org/lkml/a2fa1602-2280-c5e8-cac9-b718eaea5d22@suse=
=2Ede/

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--7yvvc7bj43wjipa4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAl7+Y0MACgkQnhiqJn3b
jbQK2w//RnV3LBW6JLU3tXpsEaAW5AWmGYwVXGYOJcz8qZ/svfbKtAiHomv/fZzZ
VKqpeZylQQjWO/QFQbwKqKAzaLKmt0w0Y9DtlPtjmvp53c3JsJkG0swDAbPMOt4V
N9wqtKeHxGWQ7JaxT79EN2eehE7/HV8aSSg9FFHKRvvxF5XBdesDJbyVRVCLCdPy
555+HK315dHBCjp4xf/mrn30/Nmb3mMITuv8jKZ3fNUYicdLikK8S9k759u3pWm0
hGzKuPjiUfJYXhY5rvNnri2oBvGaBAIWjQqZpzFNgpjP3YWEYxPyIcQaJvqrPHit
XjJI0XEEqiu3ENwqeeL4qPvbDuIzSRj//2JkZzZpP/RF3gVPBkFkKygyMt0/84NB
cB9N2GXSK3xeWhRLTlwiUAQjyj7VsrAkPcgDGKrkdF6OuG/OLk4csU5K/iWVi4zj
rUnBu48OAdZA+FD5rl+sNsNXLDM77MS0Zn5y0fOexD9lfKGq6H7lUFvCaN1E1OxQ
n5wSYfnpElfw87eS7GSOO/24S1s/gS3tY81iJcqGHjXS7CD78D9+alu/mamDnvKL
PyPMhRnuelFbUjKpWOyr+jKULaUEwszq3H9EcKoYIibbOiqQrAr04w1CN2bJE6yw
8uNBUom8o89umkBpuM1GO6S4lsKgymaWzG/frRdAHqG1e6EgrvE=
=vMyH
-----END PGP SIGNATURE-----

--7yvvc7bj43wjipa4--
