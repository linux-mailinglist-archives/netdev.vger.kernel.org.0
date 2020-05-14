Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312D61D2F34
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgENMKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 08:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgENMKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 08:10:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06034C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 05:10:04 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jZCgb-0003BD-K7; Thu, 14 May 2020 14:10:01 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jZCgZ-0004mB-9G; Thu, 14 May 2020 14:09:59 +0200
Date:   Thu, 14 May 2020 14:09:59 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mark Rutland <mark.rutland@arm.com>, Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1] net: phy: tja11xx: add cable-test support
Message-ID: <20200514120959.b24cszsmkjvfzss6@pengutronix.de>
References: <20200513123440.19580-1-o.rempel@pengutronix.de>
 <20200513133925.GD499265@lunn.ch>
 <20200513174011.kl6l767cimeo6dpy@pengutronix.de>
 <20200513180140.GK499265@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gajm7flkp5ezd5xr"
Content-Disposition: inline
In-Reply-To: <20200513180140.GK499265@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:50:05 up 181 days,  3:08, 197 users,  load average: 0.14, 0.08,
 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gajm7flkp5ezd5xr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2020 at 08:01:40PM +0200, Andrew Lunn wrote:
> > What would be the best place to do a test before the link is getting up?
> > Can it be done in the phy core, or it should be done in the PHY driver?
> >=20
> > So far, no action except of logging these errors is needed.=20
>=20
> You could do it in the config_aneg callback.

In this case I get two test cycles if the test was requested from user
space: from .cable_test_get_status and from .config_aneg

> A kernel log entry is not very easy to use. You might want to see how
> easy it is to send a cable test result to userspace. Anything which is
> interested in this information can then listen for it. All the needed
> code is there, you will just need to rearrange it a bit.

Indeed. I discovered" ethtool --monitor" for me. And the code is some
thing like this:
	ethnl_cable_test_alloc(phydev);
	phydev->drv->cable_test_start(phydev);
	usleep_range(100, 200);
	phydev->drv->cable_test_get_status(phydev, &finished);
	if (finished)
		ethnl_cable_test_finished(phydev);


Beside, what do you think about new result codes:
  ETHTOOL_A_CABLE_RESULT_CODE_POLARITY - if cable polarity is wrong (-
  connected to +)
  ETHTOOL_A_CABLE_RESULT_CODE_ACTIVE_PARTNER - the link partner is active.
     The TJA1102 is able to detect it if partner link is master.

Regards,
Oleksij

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--gajm7flkp5ezd5xr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl69NRMACgkQ4omh9DUa
UbNEnhAAu3NAVDNkJoC3+NmPL1wXsVPuDQpQvL07ZQ7CWXY7he1iC7CMDN/CkEeg
PebzI10BA7AbFVjBCAtPRFtIDC9brvS3OLy2VwLsv8Kca7XheAAE66fdihWxcRQg
smHbrb9zBtjPsmSGv3PlHqlBxHJaenz9D1fyONvOOpIBB1NY+zjrcHr01FZLSEN0
0rsDIifNM9Gs5ffNvlC5Egzkrib50XFx5boZXcM2ZVTydZ6hj1lh7sqSr0+IXakY
5uFynAp+eCalvJ/qkkcrkqubuEibahNlmz0KQCU4xGZ7FWvjmozAa8B86RmG6xuB
GP18d7kXT8pIoBDlfCxnqCJ5dC+rbM5sWyEH65amYPCl/55pJmK00Q0t0zFjh5CN
4CPHC3S4Lk2FR05UMIF4Jw06trTpOr5UN1DmtV+Ef0p0tL+GqkwSKYtaelmRbFdX
1Jcv9xpvQcarfMpMFDKXhaKl+lS3nDpUbfCuA9nzdNv/nxY5H51oQFcANV9HGCXG
D7LqMRjRe4glCiS9YqVMSK+3P7N/Tiq6JlTcueMktzdPtLIwDuTN/Yigi810cum7
p5+/TFrhJpE1frvjwRZuiUcKQpVwZyHRkMducjFG+wpJZiAvcE0mOfM/anPNjlEW
R3EEbTaVlCguHvx5KKbXeFosDr5haLNEOCkPi+NBHC5ljh5s1SI=
=hMfY
-----END PGP SIGNATURE-----

--gajm7flkp5ezd5xr--
