Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC0C14EA4D
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 10:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgAaJz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 04:55:56 -0500
Received: from mail.katalix.com ([3.9.82.81]:36920 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbgAaJz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 04:55:56 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 4E13D8CC08;
        Fri, 31 Jan 2020 09:55:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1580464554; bh=iG4ji+bcJylXQdegtmETo/iAehM8kf4oRWy/vEkKsqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Aj1QLxA2TwF1veb1Bvt9g3Qr6sakliOWyjimdOPzvHh0hyUvXms6qIuFNeJcrD6Jw
         fSEWdZKG13MfNq1jFRIWnV2mYox1mme51K9yPdCJ76+vImGI3Uju2Ic2w7Le7Bm2+J
         ZonsTD7e6yxVv3Zehi7qjDFXAYWnBfEtvG9Nk0uwHJ2h5fTaCyyl8p/Cejd3JMyzfs
         1VCg1xKIyRqRgYXuIFzuDpW8tGbI3hrV98Mlz7lH6KAu/A1N6Q4Og7vmbTxjtE0u6z
         kcp/gGS2rTqY25iwvGz4q+utdzWyKH111KMMYxYSrFr+TGZPUiWRPvGk9dzI+/HiQ/
         Wh7IuEUe7Gz5w==
Date:   Fri, 31 Jan 2020 09:55:54 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     James Chapman <jchapman@katalix.com>,
        Ridge Kennedy <ridgek@alliedtelesis.co.nz>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200131095553.GA4245@jackdaw>
References: <20200117191939.GB3405@jackdaw>
 <20200118191336.GC12036@linux.home>
 <20200120150946.GB4142@jackdaw>
 <20200121163531.GA6469@localhost.localdomain>
 <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
 <20200125115702.GB4023@p271.fit.wifi.vutbr.cz>
 <72007ca8-3ad4-62db-1b38-1ecefb82cb20@katalix.com>
 <20200129114419.GA11337@pc-61.home>
 <0d7f9d7e-e13b-8254-6a90-fc08bade3e16@katalix.com>
 <20200130223440.GA28541@pc-61.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20200130223440.GA28541@pc-61.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Jan 30, 2020 at 23:34:40 +0100, Guillaume Nault wrote:
> On Thu, Jan 30, 2020 at 10:28:23AM +0000, James Chapman wrote:
> > On 29/01/2020 11:44, Guillaume Nault wrote:
> > > Since userspace is in charge of selecting the session ID, I still can=
't
> > > see how having the kernel accept duplicate IDs goes against the RFC.
> > > The kernel doesn't assign duplicate IDs on its own. Userspace has full
> > > control on the IDs and can implement whatever constraint when assigni=
ng
> > > session IDs (even the DOCSIS DEPI way of partioning the session ID
> > > space).
> > Perhaps another example might help.
> >=20
> > Suppose there's an L2TPv3 app out there today that creates two tunnels
> > to a peer, one of which is used as a hot-standby backup in case the main
> > tunnel fails. This system uses separate network interfaces for the
> > tunnels, e.g. a router using a mobile network as a backup. If the main
> > tunnel fails, it switches traffic of sessions immediately into the
> > second tunnel. Userspace is deliberately using the same session IDs in
> > both tunnels in this case. This would work today for IP-encap, but not
> > for UDP. However, if the kernel treats session IDs as scoped by 3-tuple,
> > the application would break. The app would need to be modified to add
> > each session ID into both tunnels to work again.
> >=20
> That's an interesting use case. I can imagine how this works on Rx, but
> how can packets be transmitted on the new tunnel? The session will
> still send packets through the original tunnel with the original
> 3-tuple, and there's no way to reassign a session to a new tunnel. We
> could probably rebind/reconnect the tunnel socket, but then why
> creating the second tunnel in the kernel?
>=20
> > >>> I would have to read the RFC with scoped session IDs in mind, but, =
as
> > >>> far as I can see, the only things that global session IDs allow whi=
ch
> > >>> can't be done with scoped session IDs are:
> > >>>   * Accepting L2TPoIP sessions to receive L2TPoUDP packets and
> > >>>     vice-versa.
> > >>>   * Accepting L2TPv3 packets from peers we're not connected to.
> > >>>
> > >>> I don't find any of these to be desirable. Although Tom convinced me
> > >>> that global session IDs are in the spirit of the RFC, I still don't
> > >>> think that restricting their scope goes against it in any practical
> > >>> way. The L2TPv3 control plane requires a two way communication, whi=
ch
> > >>> means that the session is bound to a given 3/5-tuple for control
> > >>> messages. Why would the data plane behave differently?
> > >> The Cable Labs / DOCSIS DEPI protocol is a good example. It is based=
 on
> > >> L2TPv3 and uses the L2TPv3 data plane. It treats the session ID as
> > >> unscoped and not associated with a given tunnel.
> > >>
> > > Fair enough. Then we could add a L2TP_ATTR_SCOPE netlink attribute to
> > > sessions. A global scope would reject the session ID if another sessi=
on
> > > already exists with this ID in the same network namespace. Sessions w=
ith
> > > global scope would be looked up solely based on their ID. A non-global
> > > scope would allow a session ID to be duplicated as long as the 3/5-tu=
ple
> > > is different and no session uses this ID with global scope.
> > >
> > >>> I agree that it looks saner (and simpler) for a control plane to ne=
ver
> > >>> assign the same session ID to sessions running over different tunne=
ls,
> > >>> even if they have different 3/5-tuples. But that's the user space
> > >>> control plane implementation's responsability to select unique sess=
ion
> > >>> IDs in this case. The fact that the kernel uses scoped or global ID=
s is
> > >>> irrelevant. For unmanaged tunnels, the administrator has complete
> > >>> control over the local and remote session IDs and is free to assign
> > >>> them globally if it wants to, even if the kernel would have accepted
> > >>> reusing session IDs.
> > >> I disagree. Using scoped session IDs may break applications that ass=
ume
> > >> RFC behaviour. I mentioned one example where session IDs are used
> > >> unscoped above.
> > >>
> > > I'm sorry, but I still don't understand how could that break any
> > > existing application.
> >=20
> > Does my example of the hot-standby backup tunnel help?
> >=20
> Yes, even though I'm not sure how it precisely translate in terms of
> userspace/kernel interraction. But anyway, with L2TP_ATTR_SCOPE, we'd
> have the possibility to keep session ID unscoped for l2tp_ip by
> default. That should be enough to keep any such scenario working
> without any modification.
>=20
> > > For L2TPoUDP, session IDs are always looked up in the context of the
> > > UDP socket. So even though the kernel has stopped accepting duplicate
> > > IDs, the session IDs remain scoped in practice. And with the
> > > application being responsible for assigning IDs, I don't see how maki=
ng
> > > the kernel less restrictive could break any existing implementation.
> > > Again, userspace remains in full control for session ID assignment
> > > policy.
> > >
> > > Then we have L2TPoIP, which does the opposite, always looks up sessio=
ns
> > > globally and depends on session IDs being unique in the network
> > > namespace. But Ridge's patch does not change that. Also, by adding the
> > > L2TP_ATTR_SCOPE attribute (as defined above), we could keep this
> > > behaviour (L2TPoIP session could have global scope by default).
> >=20
> > I'm looking at this with an end goal of having the UDP rx path later
> > modified to work the same way as IP-encap currently does. I know Linux
> > has never worked this way in the L2TPv3 UDP path and no-one has
> > requested that it does yet, but I think it would improve the
> > implementation if UDP and IP encap behaved similarly.
> >=20
> Yes, unifying UDP and IP encap would be really nice.
>=20
> > L2TP_ATTR_SCOPE would be a good way for the app to select which
> > behaviour it prefers.
> >=20
> Yes. But do we agree that it's also a way to keep the existing
> behaviour: unscoped for IP, scoped to the 5-tuple for UDP? That is, IP
> and UDP encap would use a different default value when user space
> doesn't request a specific behaviour.
>=20
> > >> However, there might be an alternative solution to fix this for Ridg=
e's
> > >> use case that doesn't involve adding 3/5-tuple session ID lookups in=
 the
> > >> receive path or adding a control knob...
> > >>
> > >> My understanding is that Ridge's application uses unmanaged tunnels
> > >> (like "ip l2tp" does). These use kernel sockets. The netlink tunnel
> > >> create request does not indicate a valid tunnel socket fd. So we cou=
ld
> > >> use scoped session IDs for unmanaged UDP tunnels only. If Ridge's pa=
tch
> > >> were tweaked to allow scoped IDs only for UDP unmanaged tunnels (add=
ing
> > >> a test for tunnel->fd < 0), managed tunnels would continue to work as
> > >> they do now and any application that uses unmanaged tunnels would get
> > >> scoped session IDs. No control knob or 3/5-tuple session ID lookups
> > >> required.
> > >>
> > > Well, I'd prefer to not introduce another subtle behaviour change. Wh=
at
> > > does rejecting duplicate IDs bring us if the lookup is still done in
> > > the context of the socket? If the point is to have RFC compliance, th=
en
> > > we'd also need to modify the lookup functions.
> > >=20
> > I agree, it's not ideal. Rejecting duplicate IDs for UDP will allow the
> > UDP rx path to be modified later to work the same way as IP. So my idea
> > was to allow for that change to be made later but only for managed
> > tunnels (sockets created by userspace). My worry with the original patch
> > is that it suggests that session IDs for UDP are always scoped by the
> > tunnel so tweaking it to apply only for unmanaged tunnels was a way of
> > showing this.
> >=20
> > However, you've convinced me now that scoping the session ID by
> > 3/5-tuple could work. As long as there's a mechanism that lets
> > applications choose whether the 3/5-tuple is ignored in the rx path, I'm
> > ok with it.
> >=20
> Do we agree that, with L2TP_ATTR_SCOPE being a long-term solution, we
> shouldn't need to reject duplicate session IDs for UDP tunnels?
>=20
> To summarise my idea:
>=20
>   * Short term plan:
>     Integrate a variant of Ridge's patch, as it's simple, can easily be
>     backported to -stable and doesn't prevent the future use of global
>     session IDs (as those will be specified with L2TP_ATTR_SCOPE).
>=20
>   * Long term plan:
>     Implement L2TP_ATTR_SCOPE, a session attribute defining if the
>     session ID is global or scoped to the X-tuple (3-tuple for IP,
>     5-tuple for UDP).
>     Original behaviour would be respected to avoid breaking existing
>     applications. So, by default, IP encapsulation would use global
>     scope and UDP encapsulation would use 5-tuple scope.
>=20
> Does that look like a good way forward?

FWIW, this sounds reasonable to me too.

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl4z+aQACgkQlIwGZQq6
i9D2+AgAnQCROTEkIbgufaQReSB7G1DC8KyaYF1KFTYot2QToTwqfw7j+39R6ZBF
DCJQ0CchcuUNTg+FRfExJY58sWl12mMWfbDd3WGqKZCbAxevM0asUl4ocTJAc3z5
EJe/eu9bLcOVuilA0dPjiytrb2X15dYDXUqmSArOZKPxj+AVTyrxjvL9PNO+k8h3
MtOTZU33PtK3fWkzDHipx9P+PtR7xioK0PxNCNktdlgV4dM5+aYwgT7AbI/BbHxv
Xoq8w//wT1y4ArXGwLXfjNvejLGURQBUdCHPbmfIPJanCAqjRd1l1UutL5qJdpD9
dhDf5Q1DZjNcGbGUqrTH2obqukykgQ==
=uTTJ
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
