Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3182C1D851D
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 20:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387562AbgERSQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 14:16:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49932 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731888AbgERSQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 14:16:31 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jakJP-000528-N7; Mon, 18 May 2020 19:16:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jakJP-003feU-BU; Mon, 18 May 2020 19:16:27 +0100
Message-ID: <9364a11c93d09de54aea70ab6098f2a654447bd2.camel@decadent.org.uk>
Subject: Re: [PATCH net] mlx4: Fix information leak on failure to read
 module EEPROM
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Cc:     "960702@bugs.debian.org" <960702@bugs.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Mon, 18 May 2020 19:16:22 +0100
In-Reply-To: <40aaf07aa7463c0fc6ca89aab36c622bfb789ba4.camel@mellanox.com>
References: <20200517172053.GA734488@decadent.org.uk>
         <40aaf07aa7463c0fc6ca89aab36c622bfb789ba4.camel@mellanox.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-43UfY+HhXmvvNo9Nz2cj"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-43UfY+HhXmvvNo9Nz2cj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-05-18 at 16:47 +0000, Saeed Mahameed wrote:
> On Sun, 2020-05-17 at 18:20 +0100, Ben Hutchings wrote:
> > mlx4_en_get_module_eeprom() returns 0 even if it fails.  This results
> > in copying an uninitialised (or partly initialised) buffer back to
> > user-space.
[...]
> I am not sure i see the issue in here, and why we need the partial
> memset ?
> first thing in this function we do:
> memset(data, 0, ee->len);
>=20
> and then mlx4_get_module_info() will only copy valid data only on
> success.

Wow, sorry, I don't know how I missed that.  So this is not the bug I
was looking for.

>=20
> > -		if (!ret) /* Done reading */
> > +		if (!ret) {
> > +			/* DOM was not readable after all */
>=20
> actually if mlx4_get_module_info()  returns any non-negative value it
> means how much data was read, so if it returns 0, it means that this
> was the last iteration and we are done reading the eeprom..=20
>=20
> so i would remove the above comment and the memset below is redundant
> since we already memset the whole buffer before the while loop.

Right.

> > +			memset(data + i, 0, ee->len - i);
> >  			return 0;
> > +		}
> > =20
> >  		if (ret < 0) {
> >  			en_err(priv,
> >  			       "mlx4_get_module_info i(%d) offset(%d)
> > bytes_to_read(%d) - FAILED (0x%x)\n",
> >  			       i, offset, ee->len - i, ret);
> > -			return 0;
> > +			return ret;
>=20
> I think returning error in here was the actual solution for your
> problem. you can verify by looking in the kernel log and verify you see
> the log message.

The original bug report (https://bugs.debian.org/960702) says that
ethtool reports different values depending on whether its output is
redirected.  Although returning all-zeroes for the unreadable part
might be wrong, it doesn't explain that behaviour.

Perhaps if the timing of the I=C2=B2C reads is marginal, varying numbers of
bytes of DOM information might be readable?  But I don't see how
redirection of ethtool's output would affect that.  It uses a single
ioctl to read everything, and the kernel controls timing within that.

So I am mystified about what is going on here.  Maybe there is a bug in
ethtool, but I'm not seeing it.

Ben.

> >  		}
> > =20
> >  		i +=3D ret;
--=20
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.


--=-43UfY+HhXmvvNo9Nz2cj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7C0PYACgkQ57/I7JWG
EQmdiA/8D+wNpcgKm7rW2aSkoc1uS+Um7dRsUCVvEcB9XvlJ3GQp5QHDUcSwhC7t
BrtjCWnFC9kucuJB8HzOe13Z4h2NPDAa8KOudYf2mtOYAA1XL+WFApB1EqbZsiu0
feyhzLK6023rlky8aJg20OT5tmXR5Fi13p+JwNA55MOVFwDS2Y2sFZgNlg+qFxiA
6ywGGQdI1gm3LHVfMCoWc3Y5XgDD+7L8jwJxP5UNTtX0/HIUIb1png5FiVIw/Rhf
VWNZ9fILgeG283sQj6RgWKuJI0JcV7py2oSWs9TtO1YGGWheomtVqHipjdmwSb3u
aKue6xZB6K3sAo7k0CuK20yVwPydk5NzrNZw1tbA+RGOXM/QquJNINWFBy98etu/
6pDce8PSCCbPkArRsbTR5Alt67v1A6eq/2J7m2ZsgjN8GBw5TcGPHUmKTPJ3jsy6
c1eyLoRhjQG7ESsXtb6QTNW5EOBZIoH8uDeBof60UGKVhNAUTCyA2VCrJVSniDJw
/2M71WKzoqv3ZMY6OvivnWSSrXQFq0TiynRcSvkjWaN8TONK60k1EykPMezLUqYs
SAdignvY+miHj/IeYbLyUUV3b/jlZ2EQ/Bz937xxlYGzLJfuc4KsVdr6yW1nD9vA
IauyguRzon/krrYZLivbIULVZE5uQ9nyX1/w0UtPI3laXLJS8yU=
=sRq4
-----END PGP SIGNATURE-----

--=-43UfY+HhXmvvNo9Nz2cj--
