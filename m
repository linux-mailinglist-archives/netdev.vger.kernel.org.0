Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A094827A1B7
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 17:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgI0PzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 11:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgI0PzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 11:55:10 -0400
X-Greylist: delayed 1145 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 27 Sep 2020 08:55:10 PDT
Received: from mails.bitsofnetworks.org (mails.bitsofnetworks.org [IPv6:2001:912:1800:ff::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1F9C0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 08:55:10 -0700 (PDT)
Received: from [2001:912:1800::ac1] (helo=fedic)
        by mails.bitsofnetworks.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <baptiste@bitsofnetworks.org>)
        id 1kMYiU-0000JO-0V; Sun, 27 Sep 2020 17:35:58 +0200
Date:   Sun, 27 Sep 2020 17:35:52 +0200
From:   Baptiste Jonglez <baptiste@bitsofnetworks.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Alarig Le Lay <alarig@swordarmor.fr>, netdev@vger.kernel.org,
        jack@basilfillan.uk, Vincent Bernat <bernat@debian.org>,
        Oliver <bird-o@sernet.de>
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
Message-ID: <20200927153552.GA471334@fedic>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
 <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

We are seeing the same issue, more information below.

On 07-03-20, David Ahern wrote:
> On 3/5/20 1:17 AM, Alarig Le Lay wrote:
> > Hi,
> >=20
> > On the bird users ML, we discussed a bug we=E2=80=99re facing when havi=
ng a
> > full table: from time to time all the IPv6 traffic is dropped (and all
> > neighbors are invalidated), after a while it comes back again, then wait
> > a few minutes and it=E2=80=99s dropped again, and so on.
>=20
> Kernel version?

We are seeing the issue with 4.19 (debian stable) and 5.4 (debian
stable backports from a few months ago).  Others reported still seeing
the issue with 5.7:

  http://trubka.network.cz/pipermail/bird-users/2020-September/014877.html
  http://trubka.network.cz/pipermail/bird-users/2020-September/014881.html


Interestingly, the issue manifests itself in several different ways:

1) failing IPv6 neighbours, what Alarig reported.  We are seeing this
   on a full-view BGP router with rather low amount of IPv6 traffic
   (around 10-20 Mbps)


2) high jitter when forwarding IPv6 traffic: this was in the original
   report from Basil and also here: http://trubka.network.cz/pipermail/bird=
-users/2020-September/014877.html


3) system lockup: the system becomes unresponsive, with messages like:

     watchdog: BUG: soft lockup - CPU#X stuck for XXs!

   and messages about transmit timeouts from the NIC driver.

   This happened to us on a router that has a BGP full view and
   handles around 50-100 Mbps of IPv6 traffic, which probably means
   lots of route lookups.  It happened with both 4.19 and 5.4.  On the
   other hand, kernel 4.9 runs fine on that exact same router (we are
   running debian buster with the old kernel from debian stretch).


When we can't use an older kernel, our current workaround is the
following sysctl config:

    net.ipv6.route.gc_thresh =3D 100000
    net.ipv6.route.max_size =3D 400000

=46rom my understanding, this works because it basically disables the gc
in most cases.

However, the "fib_rt_alloc" field from /proc/net/rt6_stats (6th field)
is steadily increasing: after 2 days of uptime it's at 67k.  At some
point it will hit the gc threshold, we'll see what happens.

I am also trying to reproduce the issue locally.

Thanks,
Baptiste
--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEjVflzZuxNlVFbt5QvgHsIqBOLkYFAl9wsVMACgkQvgHsIqBO
LkaYFw/9HKsH496sYjfKGLUD7qdY3JqtXN+dc00Ro5PI8Z/81fFR1kuL08FAcNre
SC5Yl4xU/4MCSjxjprGQeLuiIs3gHU1hOkzqn4b4pZwUFOSoJm9gYNcLCADKACOh
m19XmKcV9Ts11l15Qcdj69ezp/ZySYzAaotfRDz8mRyHLbQRGeRKHIndlsPrhteo
yPHwru90rl717F1p69lQZBWaOCYNV2msaVPX9xshU5X2zEpfD6rWiRzCoHNyqUz4
ufxWPvjrXQINXXyRhNgKu9VLLhTHvTKcAlAI4misBhEHzuvpk+8NucLWZ/6G/9IC
iB6uAFYqAknwkUSlV69tfYfGm9KM9xB2IWPRbbWjPE7MYJTcNeMaUxTMb6se3qyG
vf0LsyEiKd67KaAQk52cTRlOCvXVfJnKp5WfzkG3GjiyiZBIqOyRX1K1e4XTvSs2
r84D/U1z7vJy3gVgZhZDqP3bq7VqMh/dz26+KJlu/H5LuI2zjYMoAi9WMFt451gz
hexkDjFcmoFfBkrcEr8yMu8yN5efdOIDB61O/6e0FTHDr7kHvkSl8d/7Np11uwtG
m9HHS+0Kwe+jOjQ2qQcJUHKLF8mPPCT2LRkEAPY6jJrYhWXv9wqMMVaASEibMrIG
Hiyk8pmLhslQg0N9SFO/vwgzFom+1/Jx2Pd48eFd89y2DFtlK94=
=zulB
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
