Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAB6233916
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgG3Tbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:31:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:47754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728616AbgG3Tbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 15:31:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 73B29AFD4;
        Thu, 30 Jul 2020 19:31:43 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 904CA604C2; Thu, 30 Jul 2020 21:31:30 +0200 (CEST)
Date:   Thu, 30 Jul 2020 21:31:30 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Jamie Gloudon <jamie.gloudon@gmx.fr>
Subject: Re: [ethtool v2 1/2] ethtool: fix netlink bitmasks when sent as
 NOMASK
Message-ID: <20200730193130.jemdjrqe2qkfo5uh@lion.mk-sys.cz>
References: <20200727224937.9185-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n67yu4l5nvtqfx3b"
Content-Disposition: inline
In-Reply-To: <20200727224937.9185-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n67yu4l5nvtqfx3b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2020 at 03:49:36PM -0700, Jacob Keller wrote:
> The ethtool netlink API can send bitsets without an associated bitmask.
> These do not get displayed properly, because the dump_link_modes, and
> bitset_get_bit to not check whether the provided bitset is a NOMASK
> bitset. This results in the inability to display peer advertised link
> modes.
>=20
> Both the dump_link_modes and bitset_git_bit functions do not check
> ETHTOOL_A_BITSET_NOMASK, and thus do not properly handle bitsets which
> do not have a provided mask.
>=20
> For compact bitmaps, things work more or less ok, as long as mask was
> provided as "false". This is because it will always use the
> ETHTOOL_A_BITSET_BIT_VALUE section when mask is false. A NOMASK compact
> bitmap will provide this.
>=20
> Unfortunately, if the bitset is not sent in the compact format, these
> functions do not behave correctly. When NOMASK is set, then the
> ETHTOOL_A_BITSET_BIT_VALUE is not provided. Instead, the application is
> supposed to treat it as a list of all the valid values.
>=20
> Fix these functions so that they behave properly with NOMASK bitsets in
> the non-compact form. Additionally, make these functions report an error
> if requesting to operate with "mask" set on a NOMASK bitmap. This
> ensures that we catch issues in the case where ethtool is trying to
> print the mask of a bitset that has no mask. Doing so highlights a small
> bug in the FEC settings where we accidentally set mask to true. Fix this
> also.
>=20
> Reported-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied with

  Fixes: 490503bdbd67 ("netlink: add bitset helpers")
  Fixes: 10cc3ea337d1 ("netlink: partial netlink handler for gset (no optio=
n)")

Michal

--n67yu4l5nvtqfx3b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8jIA0ACgkQ538sG/LR
dpVYBwgAurFf6UrYSeVdCPusQ4EZ+fHLX6WkJHNj6Tytxez9jqhjHx+M++dhJ7j9
H6lQXasyb6ooDxh8U2diDiRrw/OoTB+Ul1k/JrkECLsPhuT+nTyNViRN+soTowKN
gvrf1jjvN+/1s1zg0laAFItgjiTpvVeVCYds9v/BkYXrI3zBxqcttw+8KjebJ4yK
mgiO4VEnHNafPhg+x7qxYxibZDbspnteoy5Ax79LBORGw+198jqVkMZhv1uNDy7Q
SD2/3fzgO2Vn1HRPp/+8D7kMewuBrclORzw1tZChjTl3uAC3zilPR/z8BncCACbW
qWnSelivKsah78DrmYZNja2x238YoQ==
=NdxW
-----END PGP SIGNATURE-----

--n67yu4l5nvtqfx3b--
