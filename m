Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41131066CE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfKVHJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:09:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:31801 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbfKVHJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 02:09:09 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 23:09:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,228,1571727600"; 
   d="asc'?scan'208";a="210171292"
Received: from lmhaganx-mobl.amr.corp.intel.com ([10.251.138.123])
  by orsmga003.jf.intel.com with ESMTP; 21 Nov 2019 23:09:07 -0800
Message-ID: <2abb44f7a40b3e80a2f869205cf981b975cc3bd7.camel@intel.com>
Subject: Re: [net-next 13/15] ice: Implement ethtool ops for channels
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, Henry Tieman <henry.w.tieman@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Date:   Thu, 21 Nov 2019 23:09:06 -0800
In-Reply-To: <20191121144246.04adde1a@cakuba.netronome.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
         <20191121074612.3055661-14-jeffrey.t.kirsher@intel.com>
         <20191121144246.04adde1a@cakuba.netronome.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-jVKHqyuSY6ux+uv2i7U0"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-jVKHqyuSY6ux+uv2i7U0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-11-21 at 14:42 -0800, Jakub Kicinski wrote:
> On Wed, 20 Nov 2019 23:46:10 -0800, Jeff Kirsher wrote:
> > +	curr_combined =3D ice_get_combined_cnt(vsi);
> > +
> > +	/* these checks are for cases where user didn't specify a
> > particular
> > +	 * value on cmd line but we get non-zero value anyway via
> > +	 * get_channels(); look at ethtool.c in ethtool repository (the
> > user
> > +	 * space part), particularly, do_schannels() routine
> > +	 */
> > +	if (ch->rx_count =3D=3D vsi->num_rxq - curr_combined)
> > +		ch->rx_count =3D 0;
> > +	if (ch->tx_count =3D=3D vsi->num_txq - curr_combined)
> > +		ch->tx_count =3D 0;
> > +	if (ch->combined_count =3D=3D curr_combined)
> > +		ch->combined_count =3D 0;
> > +
> > +	if (!(ch->combined_count || (ch->rx_count && ch->tx_count))) {
> > +		netdev_err(dev, "Please specify at least 1 Rx and 1 Tx
> > channel\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	new_rx =3D ch->combined_count + ch->rx_count;
> > +	new_tx =3D ch->combined_count + ch->tx_count;
>=20
> The combined vs individual count logic looks correct to me which is not
> common, so nice to see that!
>=20
> > +	if (new_rx > ice_get_max_rxq(pf)) {
> > +		netdev_err(dev, "Maximum allowed Rx channels is %d\n",
> > +			   ice_get_max_rxq(pf));
> > +		return -EINVAL;
> > +	}
> > +	if (new_tx > ice_get_max_txq(pf)) {
> > +		netdev_err(dev, "Maximum allowed Tx channels is %d\n",
> > +			   ice_get_max_txq(pf));
> > +		return -EINVAL;
> > +	}
> > +
> > +	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
> > +
> > +	if (new_rx)
> > +		return ice_vsi_set_dflt_rss_lut(vsi, new_rx);
>=20
> But I don't see you doing a netif_is_rxfh_configured() check, which is
> supposed to prevent reconfiguring the RSS indirection table if it was
> set up manually by the user.

Talking with Henry it appears Jake's kernel changes were done in parallel
or after the work that was done in the driver.  There appears to be more
code that just adding a simple check, is this a *required* change for
acceptance.  We are currently looking into making this fix, but due to the
upcoming holidays, not sure if we can make the desired change before the
merge window closes.  So I see the following options:

- accept patch as is, and expect a fix in the next patch submission
- drop this patch since the fix will not be available before the merge
window closes for net-next

While I prefer the first option because we are also submitting the "new"
virtio_bus patches, which depend heavily on these changes upstream, I think
we can drop this patch (if necessary) and be fine to submit the other
patches with little thrash.

Which option is preferred or acceptable to you Dave and Jakub?

> This is doubly sad, because I believe that part of RSS infrastructure
> was added by Jake Keller from Intel, so it should be caught by your
> internal review, not to say tests.. :(
>=20
> > +	return 0;
> > +}


--=-jVKHqyuSY6ux+uv2i7U0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3XiZIACgkQ5W/vlVpL
7c6cTg//TwJnoRwWP1enuikXeAWx1Gz74FpMH+537gCz8vTAM5g7EESY4EMNy6HS
NeUoxH4BiUp1uyewJpt5e0CJXZLx4IBnSW/gpv9iah8H0ntUJNRGIB3MfpEeqE4W
rWjQB2mFPnmxS1+UpI1wAGKBwPLcQ6g0DpelneR230xWXKUutsaXQuoL6m8v/wua
2MaxfnoBbg1+wawmlwwqJLYTV6GCFW+F8u+VEILlu+MK8f8ZQ66M9yviGmVR80YM
deeG+OLuA2zNTB6JVuZnXxJC/nS+2b4TB5aKo1uyvzJkr/ZbMnMr4iJ/LhYRRHbv
h4dW61VzBiJn17IcF2IdCJRARBluV0F9dNcDSU9qvm08seqP/FqMHUQQ3STBcf/3
wn59UQvxRNQnU2Jz7wWOqNI/zvMyIIyIhWh/skGjVLDIWWsx21qkxRFVCcYWYZ8o
C4c5Z2W2kVVojkn3e4sSTyaaz8V4eS/0Ffftba0Oy2kTHor7DmssdqcmV5ReAMSI
BlmJA0cFwbHpPgMhSH26vUzQRGx85GzlL8//hGzABzNOLZK0VgdF3a6Sgl/Uxfzj
YfM9//cwKIpgVZPzOkw8fWYiXEegN9zqNrHcyQ/x9bGP1/DrSym2uxEAZCLaDUSN
M6Xa6v35m7Zg/csfxRz/ZdpMic/H58e3LHpqMzEor/DOIEnlsvc=
=mbuf
-----END PGP SIGNATURE-----

--=-jVKHqyuSY6ux+uv2i7U0--

