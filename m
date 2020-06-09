Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEF71F3E18
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 16:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbgFIO2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 10:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbgFIO2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 10:28:01 -0400
Received: from localhost (unknown [5.171.8.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1961320734;
        Tue,  9 Jun 2020 14:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591712880;
        bh=pnYvn3vlySNYJGWPr66fPTUZeFe/fdVmmoBPYoLeu24=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IF50b+m0RwE4xwbWdDlU/QC7YTDcz/tV4oLXGigGrpI9Zug/RC+thAHbMG0ieTHi3
         PNfMnPNsAYQNBayhlG0LCBgz50PI4KvEtQ42BqFpeJf/6v9SIW0C4hYMY6oo4Z7jPJ
         6mk4qf3AmdOsLCkH1tWee2MJhNEq8ZuQoZIxqmPU=
Date:   Tue, 9 Jun 2020 16:27:56 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, lorenzo.bianconi@redhat.com,
        brouer@redhat.com
Subject: Re: [PATCH net] net: mvneta: do not redirect frames during
 reconfiguration
Message-ID: <20200609142756.GA66761@localhost.localdomain>
References: <fd076dae0536d823e136ab4c114346602e02b6d7.1591653494.git.lorenzo@kernel.org>
 <20200608231015.GH1022955@lunn.ch>
 <20200609074110.GA2067@localhost.localdomain>
 <20200609130654.GI1022955@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20200609130654.GI1022955@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Jun 09, 2020 at 09:41:10AM +0200, Lorenzo Bianconi wrote:
> > > On Tue, Jun 09, 2020 at 12:02:39AM +0200, Lorenzo Bianconi wrote:
> > > > Disable frames injection in mvneta_xdp_xmit routine during hw
> > > > re-configuration in order to avoid hardware hangs
> > >=20
> > > Hi Lorenzo
> > >=20
> > > Why does mvneta_tx() also not need the same protection?
> > >=20
> > >     Andrew
> >=20
> > Hi Andrew,
> >=20
> > So far I have not been able to trigger the issue in the legacy tx path.
>=20
> Even if you have not hit the issue, do you still think it is possible?
> If it is hard to trigger, maybe it is worth protecting against it,
> just in case.

The issue occurs putting the device down while it is still transmitting. In
particular mvneta_port_down() fails to stop tx (TIMEOUT for TX stopped stat=
us=3D...)
and the device is not able to recover.
The above pattern can occur with XDP because if we remove the program from a
running interface, we will put the interface down for DMA buffers
reconfiguration while mvneta_xdp_xmit() is concurrently running on a remote
cpu.
Looking at the code I do not think it can occurs in the legacy tx path
(mvneta_tx()) since __dev_close() (trigger by userspace) will run
dev_deactivate_many() before running mvneta_stop().

>=20
> > I hit the problem adding the capability to attach an eBPF program to CP=
UMAP
> > entries [1]. In particular I am redirecting traffic to mvneta and concu=
rrently
> > attaching/removing a XDP program to/from it.
> > I am not sure this can occur running mvneta_tx().
> > Moreover it seems a common pattern for .ndo_xdp_xmit() in other drivers
> > (e.g ixgbe, bnxt, mlx5)
>=20
> I was wondering if this should be solved at a higher level. And if you
> say there are more MAC drivers with this issue, maybe it should. Not
> sure how though. It seems like MTU change and rx mode change wound
> need to be protected, which at a higher level is harder to do. What
> exactly do you need to protect, in a generic way?

Yes, we can think about it but I guess we should fix the issue first since =
it
is already there and it will be easy to backport the fix, agree?

Regards,
Lorenzo

>=20
>      Andrew

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXt+cZwAKCRA6cBh0uS2t
rHuiAQD9vn8va62PI2/1ni1k3nlixmFsgY5AL7IWZ2iXBh0b7QEA34tJXXRWkLjP
Vw+jC6QdA6dAnQiskMqa3tXMV4dMaws=
=lE/4
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
