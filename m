Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA9614115B
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgAQS7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:59:33 -0500
Received: from mail.katalix.com ([3.9.82.81]:39376 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbgAQS7d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 13:59:33 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id BF1C386ACC;
        Fri, 17 Jan 2020 18:59:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1579287571; bh=ifb2IvEz4BsX1IZ/CE3RlIjT6/DPTiGNq9vf4NwYtFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h8R6Es8rYFyZOqdp3QqNw9EhRVuztV/BuDPPgrlQjObni4NV0NIMVasxi6SVLpUwP
         f8SIvsvHnwrv+JX/HlDBKnU5gdyPH/RaxFNW43TBTuPg8WwLkU5k+BKq44jEFczxVI
         56V14NLuXeLijHmyvEHzM9DXCyBDC4cCtyGqtmRMG53MeTWsJIWF0LkSqBCTtVA6DT
         jCtAg9r5JkjOK4NYcV2IilOtgmmqrVUPbW1F69ofhyaMO+5SvFPKlmqP4gkRuBicRv
         CFdyBgKon/HfkvYUDf+i/yAAUp4L9kZMepXxCxn07KeFZkbTP1fWRfWjMCaspTbC0w
         hFl+xPs/hFENw==
Date:   Fri, 17 Jan 2020 18:59:31 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200117185931.GA19201@jackdaw>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123143.GA4028@jackdaw>
 <20200116192827.GB25654@linux.home>
 <20200116210501.GC4028@jackdaw>
 <20200117134327.GA2743@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20200117134327.GA2743@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Fri, Jan 17, 2020 at 14:43:27 +0100, Guillaume Nault wrote:
> On Thu, Jan 16, 2020 at 09:05:01PM +0000, Tom Parkin wrote:
> > On  Thu, Jan 16, 2020 at 20:28:27 +0100, Guillaume Nault wrote:
> > > How is UDP-encap broken with duplicate session IDs (as long as a UDP
> > > socket can only one have one tunnel associated with it and that no
> > > duplicate session IDs are allowed inside the same tunnel)?
> > >=20
> > > It all boils down to what's the scope of a session ID. For me it has
> > > always been the parent tunnel. But if that's in contradiction with
> > > RFC 3931, I'd be happy to know.
> >=20
> > For RFC 2661 the session ID is scoped to the tunnel.  Section 3.1
> > says:
> >=20
> >   "Session ID indicates the identifier for a session within a tunnel."
> >=20
> > Control and data packets share the same header which includes both the
> > tunnel and session ID with 16 bits allocated to each.  So it's always
> > possible to tell from the data packet header which tunnel the session is
> > associated with.
> >=20
> > RFC 3931 changed the scheme.  Control packets now include a 32-bit
> > "Control Connection ID" (analogous to the Tunnel ID).  Data packets
> > have a session header specific to the packet-switching network in use:
> > the RFC describes schemes for both IP and UDP, both of which employ a
> > 32-bit session ID.  Section 4.1 says:
> >=20
> >   "The Session ID alone provides the necessary context for all further
> >   packet processing"
> >=20
> > Since neither UDP nor IP encapsulated data packets include the control
> > connection ID, the session ID must be unique to the LCCE to allow
> > identification of the session.
>=20
> Well my understanding was that the tunnel was implicitely given by the
> UDP and IP headers. I don't think that multiplexing tunnels over the
> same UDP connection made any sense with L2TPv2, and the kernel never
> supported it natively (it might be possible with SO_REUSEPORT). Given
> that the tunnel ID field was redundant with the lower headers, it made
> sense to me that L2TPv3 dropped it (note that the kernel ignores the
> L2TPv2 tunnel ID field on Rx). At least that was my understanding.
>=20
> But as your quote says, the session ID _alone_ should provide all the
> L2TP context. So I guess the spirit of the RFC is that there's a single
> global namespace for session IDs. Now, practically speaking, I don't
> see how scoped session IDs makes us incompatible, unless we consider
> that a given session can be shared between several remote hosts (the
> cross-talk case in my other email). Also, sharing a session over
> several hosts would mean that L2TPv3 sessions aren't point-to-point,
> which the control plane doesn't seem to take into account.

I think from your other emails in this thread that we're maybe in
agreement already.

But just in case, I wanted to clarify that the session ID namespace
is for a given LCCE (LAC or LNS in L2TPv2 parlance) per RFC 3931
section 4.1 -- it's not truly "global".

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl4iBA4ACgkQlIwGZQq6
i9A85Qf/d33jxFTCQgccYYasXCEP04KGw33SAvgk/1xJwVrUxvyh7dkFlP2SI/t8
8R9MQ/vBrb/xnh8yt4kYi+f8iPzgFUTzkH2MIRUERKKBSMejGnC/zLWg3iY7E1hc
q1xhm72robeKF8MM5Ql7LNH5tUdQCLv19iJIzlXvka4FwPG2tyvO5BZXenlpCMTa
CNVgQqb4UG45sDUsXB+l2dsdWGxOykUShCHeInc3COmuQGhMOA318jsmPc2xVIMf
z5WkoXL/k6txtF9lGErszTufDa0BvJb2V3n8hQKs+nuwV3vPj4BRQokPbzO3jOfr
G6LOHiMKQ+Dy7vBW7aw8kltscuCI3w==
=31i9
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
