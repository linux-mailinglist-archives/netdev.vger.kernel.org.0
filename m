Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8212E1AFE1E
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 22:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgDSUfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 16:35:19 -0400
Received: from mail.mbosch.me ([188.68.58.50]:40222 "EHLO mail.mbosch.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgDSUfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 16:35:19 -0400
Date:   Sun, 19 Apr 2020 22:35:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mbosch.me; s=mail;
        t=1587328516; bh=cj/rqNpocza58qjmALkIKhAdDTN/g5SCfDMzFAsrlgE=;
        h=Date:From:To:Subject:References:In-Reply-To;
        b=F3DN99z2zQnkzBNuVPgBFWN8N9FBwKe5bVUnqiqvsjDw0kWumNb9IznVq4zCyfdhK
         p7h2RRZDG4UvhfSK9QKuy/rzD/BdFI01ALiuVI1Y8DfvyPxHV6nrMPTlxNUthL6Fn6
         F4W9OysG2o4iVPzNywk5CLwq+DJT8nYTCr8l/8Ww=
From:   Maximilian Bosch <maximilian@mbosch.me>
To:     Mike Manning <mmanning@vyatta.att-mail.com>, netdev@vger.kernel.org
Subject: Re: VRF Issue Since kernel 5
Message-ID: <20200419203516.jrpm5jzokmswkpue@topsnens>
References: <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <20200310204721.7jo23zgb7pjf5j33@topsnens>
 <2583bdb7-f9ea-3b7b-1c09-a273d3229b45@gmail.com>
 <20200401181650.flnxssoyih7c5s5y@topsnens>
 <b6ead5e9-cc0e-5017-e9a1-98b09b110650@gmail.com>
 <20200401203523.vafhsqb3uxfvvvxq@topsnens>
 <00917d3a-17f8-b772-5b93-3abdf1540b94@gmail.com>
 <20200402230233.mumqo22khf7q7o7c@topsnens>
 <5e64064d-eb03-53d3-f80a-7646e71405d8@gmail.com>
 <d81f97fe-be4b-041d-1233-7e69758d96ef@vyatta.att-mail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3ims3hi3g2cdsnvh"
Content-Disposition: inline
In-Reply-To: <d81f97fe-be4b-041d-1233-7e69758d96ef@vyatta.att-mail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3ims3hi3g2cdsnvh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Can you please clarify what the issue is with using 'ip vrf exec <vrf>
> ssh' for running the ssh client in the vrf?

well, SSH was just an example to demonstrate the issue. As mentioned in
my previous emails, the `ip vrf exec`-wrapper is only needed for
processes that do TCP, UDP-traffic is still leaked through the VRF.

Thanks

  Maximilian

On Wed, Apr 08, 2020 at 11:07:31AM +0100, Mike Manning wrote:
> Hi Maximilian,
> Can you please clarify what the issue is with using 'ip vrf exec <vrf>
> ssh' for running the ssh client in the vrf? This is the recommended
> method for running an application in a VRF. As part of our VRF
> development on this a couple of years ago, we provided a changeset for
> openssh so that the vrf could be specified as an option, cf
> https://bugzilla.mindrot.org/show_bug.cgi?id=3D2784. That was not applied
> due to the ease of using 'ip vrf exec'.
>=20
> Alternatively, to run the ssh client in the default VRF, you can bind it
> to an address on an interface (or specify the interface) in the default
> VRF using ssh -b (or -B) option, or similarly add an entry in
> /etc/ssh/ssh_config for BindAddress (or BindInterface).
>=20
> Then for egress, leak a route in the default table to get to the gateway
> via the VRF (as you must already be doing), and for ingress, leak a
> route in the VRF's table for the return path to the ssh client. For
> this, get the table id for the vrf from 'ip vrf', add the route for the
> client prefix with the additional 'table <tbl-id>' option, and confirm
> the route with 'ip route show vrf <vrf-name>'.
>=20
> I have started looking at the issue you have reported, but as you may
> appreciate, it is not trivial. This client-side use-case is not typical,
> as VRF config is generally applied to routers or switches, not hosts.
>=20
> Thanks
> Mike
>=20
>=20
> On 05/04/2020 17:52, David Ahern wrote:
> > On 4/2/20 5:02 PM, Maximilian Bosch wrote:
> >> Hi!
> >>
> >>> I do not see how this worked on 4.19. My comment above is a fundament=
al
> >>> property of VRF and has been needed since day 1. That's why 'ip vrf
> >>> exec' exists.
> >> I'm afraid I have to disagree here: first of all, I created a
> >> regression-test in NixOS for this purpose a while ago[1]. The third te=
st-case
> >> (lines 197-208) does basically what I demonstrated in my previous emai=
ls
> >> (opening SSH connetions through a local VRF). This worked fine until we
> >> bumped our default kernel to 5.4.x which is the reason why this testca=
se
> >> is temporarily commented out.
> > I do not have access to a NixOS install, nor the time to create one.
> > Please provide a set of ip commands to re-create the test that work with
> > Ubuntu, debian or fedora.
> >
> >
> >> After skimming through the VRF-related changes in 4.20 and 5.0 (which
> >> might've had some relevant changes as you suggested previously), I
> >> rebuilt the kernels 5.4.29 and 5.5.13 with
> >> 3c82a21f4320c8d54cf6456b27c8d49e5ffb722e[2] reverted on top and the
> >> commented-out testcase works fine again. In other words, my usecase
> >> seems to have worked before and the mentioned commit appears to cause
> >> the "regression".
> > The vyatta folks who made the changes will take a look.
>=20
>=20

--3ims3hi3g2cdsnvh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEPg3TILK+tBEQDaTVCR2/TR/Ea44FAl6ctgQACgkQCR2/TR/E
a45ZNggAqlLjpms+sASnPFs5rYDZN5b7ym29irUKR6M3Pb384bVyQu1LJMB7o2Jq
CqVVK3Vgn548SdXsDKVWzFotNwwpTlTukyM43LPLrFAoi2teMejH23+tUnluNjK6
9QefUCRi4C8FCoSZTGUueyCjVwtArrMM5wxWuqThSrKrgwv43fwThwZCO0N13Dkl
q0fWpiUmR7ZareDqhcV31G64A4oAzxasPMh9cVJTH0xTmhlkEXlmDeOf/N9K09TH
nPhWpo9VO2HmcOBVzTdx1fUGj3U72PKo2R6soQ31wJUXfdQP6PDyTj/fBGnV5anB
DHRQju3V3Y8J6OKFxtqDZwrjN/Q9kw==
=MWK7
-----END PGP SIGNATURE-----

--3ims3hi3g2cdsnvh--
