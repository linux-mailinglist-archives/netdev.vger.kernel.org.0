Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACAD56A9E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfFZNcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:32:23 -0400
Received: from sauhun.de ([88.99.104.3]:56248 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZNcX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 09:32:23 -0400
Received: from localhost (p54B330AF.dip0.t-ipconnect.de [84.179.48.175])
        by pokefinder.org (Postfix) with ESMTPSA id DD83E2C0114;
        Wed, 26 Jun 2019 15:32:20 +0200 (CEST)
Date:   Wed, 26 Jun 2019 15:32:20 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms+renesas@verge.net.au>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Artemi Ivanov <artemi.ivanov@cogentembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH resend] can: rcar_canfd: fix possible IRQ storm on high
 load
Message-ID: <20190626133220.GK801@ninjato>
References: <20190626130848.6671-1-nikita.yoush@cogentembedded.com>
 <20190626131251.GB801@ninjato>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ogUXNSQj4OI1q3LQ"
Content-Disposition: inline
In-Reply-To: <20190626131251.GB801@ninjato>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ogUXNSQj4OI1q3LQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2019 at 03:12:51PM +0200, Wolfram Sang wrote:
> On Wed, Jun 26, 2019 at 04:08:48PM +0300, Nikita Yushchenko wrote:
> > We have observed rcar_canfd driver entering IRQ storm under high load,
> > with following scenario:
> > - rcar_canfd_global_interrupt() in entered due to Rx available,
> > - napi_schedule_prep() is called, and sets NAPIF_STATE_SCHED in state
> > - Rx fifo interrupts are masked,
> > - rcar_canfd_global_interrupt() is entered again, this time due to
> >   error interrupt (e.g. due to overflow),
> > - since scheduled napi poller has not yet executed, condition for calli=
ng
> >   napi_schedule_prep() from rcar_canfd_global_interrupt() remains true,
> >   thus napi_schedule_prep() gets called and sets NAPIF_STATE_MISSED flag
> >   in state,
> > - later, napi poller function rcar_canfd_rx_poll() gets executed, and
> >   calls napi_complete_done(),
> > - due to NAPIF_STATE_MISSED flag in state, this call does not clear
> >   NAPIF_STATE_SCHED flag from state,
> > - on return from napi_complete_done(), rcar_canfd_rx_poll() unmasks Rx
> >   interrutps,
> > - Rx interrupt happens, rcar_canfd_global_interrupt() gets called
> >   and calls napi_schedule_prep(),
> > - since NAPIF_STATE_SCHED is set in state at this time, this call
> >   returns false,
> > - due to that false return, rcar_canfd_global_interrupt() returns
> >   without masking Rx interrupt
> > - and this results into IRQ storm: unmasked Rx interrupt happens again
> >   and again is misprocessed in the same way.
> >=20
> > This patch fixes that scenario by unmasking Rx interrupts only when
> > napi_complete_done() returns true, which means it has cleared
> > NAPIF_STATE_SCHED in state.
> >=20
> > Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
>=20
> CCing the driver author...

Bounced :(


--ogUXNSQj4OI1q3LQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl0Tc+QACgkQFA3kzBSg
Kbb75BAAhLltyFkBZdASqi3rHjdUTq/5x4rdFSNMulB8Cf9rrTMAt091eREUWO/f
0aks7VxUHsBR3ojRJkzO90kB4Ep/6ph5KksO951YYCfRec4m5kMwLSl6aIDI+i9S
ECa/PF9BYLVFi8WqreaFobkMf60pJrJ0505PBSFEEqM2be5AEuJqTuB51UN+6VEG
BvTx8d3AEQLnvVsfWF+zKfR3YjDmmTHLqwe8KzwqTOmJ8DFhQCtQLQdQyeWNwkug
KNvWA/Epo4XpxsY2IV0gElZhY1tFPJUpjlkFwWgKTONeXQywAdEaoMIaMD/5mQKV
mlKrq5Mi+ZHGmTVikJJs1xUlG6P7s2aPlj3TqYtpmkXK2ySSBULTmvJxkzyZEYWv
BLs7mGZsKT2sqkHk68GcIcPSElof+hkBruJMRZDpW+4XSsarU05/U3i2XG2J2bM3
xCfIlTpEr1X8jkXCwGCfw+aRa7/7rbWv2yeOyKb89MW6U8Z9oXlwaKnwdg1GJVF5
u/Y3kuYtmYtJN6KlOioWSymDn12H3q4Dex+FWUfALknKJvjUFggpjOBp+HmYulr7
LY6AqdLEYEKyG+BsW+xfLuZELUwJdbIU96dEZBli3QvYAxuguhenKFJ93Sy6Qhfg
oJhl7OvQsmKnpmJOe1vHKaBTwqdP0a5uzzJ64zflQCsSE8ItQ1I=
=/Yw0
-----END PGP SIGNATURE-----

--ogUXNSQj4OI1q3LQ--
