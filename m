Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32D3B03D5
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 20:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbfIKSpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 14:45:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:13630 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729994AbfIKSpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 14:45:25 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 11:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,494,1559545200"; 
   d="asc'?scan'208";a="209759291"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 11 Sep 2019 11:45:22 -0700
Message-ID: <e278de32937822af05fc9916e21357fd3c10de93.camel@intel.com>
Subject: Re: ixgbe: driver drops packets routed from an IPSec interface with
 a "bad sa_idx" error
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Michael Marley <michael@michaelmarley.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org
Date:   Wed, 11 Sep 2019 11:45:22 -0700
In-Reply-To: <12d6d2313eeb61a51731a2ba9b1fa9bf@michaelmarley.com>
References: <10ba81d178d4ade76741c1a6e1672056@michaelmarley.com>
         <4caa4fb7-9963-99ab-318f-d8ada4f19205@pensando.io>
         <fb63dec226170199e9b0fd1b356d2314@michaelmarley.com>
         <90dd9f8c-57fa-14c7-5d09-207b84ec3292@pensando.io>
         <6ab15854-154a-2c7c-b429-7ba6dfe785ae@michaelmarley.com>
         <20190911061547.GR2879@gauss3.secunet.de>
         <12d6d2313eeb61a51731a2ba9b1fa9bf@michaelmarley.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-YsAJYHzXS9N61fd9/Kr/"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-YsAJYHzXS9N61fd9/Kr/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-09-11 at 10:50 -0400, Michael Marley wrote:
> On 2019-09-11 02:15, Steffen Klassert wrote:
> > On Tue, Sep 10, 2019 at 06:53:30PM -0400, Michael Marley wrote:
> > > StrongSwan has hardware offload disabled by default, and I
> > > didn't=20
> > > enable
> > > it explicitly.  I also already tried turning off all those
> > > switches=20
> > > with
> > > ethtool and it has no effect.  This doesn't surprise me though,=20
> > > because
> > > as I said, I don't actually have the IPSec connection running
> > > over the
> > > ixgbe device.  The IPSec connection runs over another network
> > > adapter
> > > that doesn't support IPSec offload at all.  The problem comes
> > > when
> > > traffic received over the IPSec interface is then routed back out
> > > (unencrypted) through the ixgbe device into the local network.
> >=20
> > Seems like the ixgbe driver tries to use the sec_path
> > from RX to setup an offload at the TX side.
> >=20
> > Can you please try this (completely untested) patch?

Steffen, can you send your patch to intel-wired-lan@lists.osuosl.org
mailing list?

> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > index 9bcae44e9883..ae31bd57127c 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -36,6 +36,7 @@
> >  #include <net/vxlan.h>
> >  #include <net/mpls.h>
> >  #include <net/xdp_sock.h>
> > +#include <net/xfrm.h>
> >=20
> >  #include "ixgbe.h"
> >  #include "ixgbe_common.h"
> > @@ -8696,7 +8697,7 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct
> > sk_buff=20
> > *skb,
> >  #endif /* IXGBE_FCOE */
> >=20
> >  #ifdef CONFIG_IXGBE_IPSEC
> > -	if (secpath_exists(skb) &&
> > +	if (xfrm_offload(skb) &&
> >  	    !ixgbe_ipsec_tx(tx_ring, first, &ipsec_tx))
> >  		goto out_drop;
> >  #endif
> With the patch, the problem is gone.  Thanks!
>=20
> Michael


--=-YsAJYHzXS9N61fd9/Kr/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl15QMIACgkQ5W/vlVpL
7c6NYw//Yux0MYB8Mt49j9tvWehfrUTbtKBmPSqQelv4IAuwQ/Z40sScs5qbvHeS
dlxyWCsW49copzvadGjub36AK9bF06c3JsqnhXvFqvlAdRCKJQ2Oq//6pemUw4c6
VKsb9aSIYtXjoLZVSGrEwMSeV/mGvx9K5KjNJYk8B7VK+g5jEu0+3qdiBB8mcGok
7slcw3DrzOAt+RFNGAh1UwaqB3diRNo2axlAbT9Bed+IFZrFXM2Uq0bATuOw4W0G
387g1b65QAvWj46/2g57h/qBLkuF85fjpS4L8YQGzNUbds32oFu+3crGvYQdi/rv
oHPyBBWNTCWshaLGgbo5AzSTty5IhbVcMgldEFk1WJb3ddv4+0TxPEOMm3RzMj8d
dMtU/HxGqvY0JzQ3qZtX02nQcujnxRjyDr0DGeo1bOClIR+eGD5bGm1gpkiDRnGo
cdLGLJ95RkJVeX+F6dgn3Rpf9q9t0Mb7yP72BxnWaDAYLUoi3wBo5ODw9k18amVO
2yP8P6sN2UjRamlXyfYPDadw16JFOj4fx5AeKtDhXYr0WYNiTIqaUTw8y9YJGmL0
uIOpI3tCB5O7lVTmT46EAzCvZ66gyb9vdFOEFnNFXkvDMUqf3y1OZ+sSA+Ik+coL
VE0qhPKgkRZ/xkliClhwdrJOvgW16ezOozVNJyOgbxkiA0nZ3L0=
=yeLK
-----END PGP SIGNATURE-----

--=-YsAJYHzXS9N61fd9/Kr/--

