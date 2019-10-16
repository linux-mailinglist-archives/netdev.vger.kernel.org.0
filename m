Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D23D8B2F
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391373AbfJPIkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 04:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfJPIkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 04:40:02 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D030B21835;
        Wed, 16 Oct 2019 08:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571215201;
        bh=n6luFh8m/QXy1ey66nxhe2TFo4De/3PB4Bm/aw3tMhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZVunBCr8RuHu+vjZMcouisIHdgRLVuaonQsMrWxQba9deZUXdPRtXPQHZYXy/MFSV
         I2X4M1E7uF6ZgJaNmsXK5lKLsIf1PCLFOBhU80vokkgDSNyFtKsFcEQzI/wEa9Vl6t
         aUVPAiJSyPgLmGweEwCjv+Gr4x1egMUK39JpJaD8=
Date:   Wed, 16 Oct 2019 10:39:56 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 5/8] net: mvneta: add basic XDP support
Message-ID: <20191016083956.GB2638@localhost.localdomain>
References: <cover.1571049326.git.lorenzo@kernel.org>
 <7c53ff9e148b80613088c7c35444244cbe1358bf.1571049326.git.lorenzo@kernel.org>
 <20191015162047.43e0de8b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <20191015162047.43e0de8b@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 14 Oct 2019 12:49:52 +0200, Lorenzo Bianconi wrote:
> > @@ -3983,6 +4071,46 @@ static int mvneta_ioctl(struct net_device *dev, =
struct ifreq *ifr, int cmd)
> >  	return phylink_mii_ioctl(pp->phylink, ifr, cmd);
> >  }
> > =20
> > +static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *p=
rog,
> > +			    struct netlink_ext_ack *extack)
> > +{
> > +	struct mvneta_port *pp =3D netdev_priv(dev);
> > +	struct bpf_prog *old_prog;
> > +
> > +	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	if (netif_running(dev))
> > +		mvneta_stop(dev);
> > +
> > +	old_prog =3D xchg(&pp->xdp_prog, prog);
> > +	if (old_prog)
> > +		bpf_prog_put(old_prog);
> > +
> > +	if (netif_running(dev))
> > +		mvneta_open(dev);
>=20
> Ah, the stopping and starting of the interface is sad. If start fails
> the interface is left in a funky state until someone does a stop/start
> cycle. Not that you introduced that.

I will add a return check from mvneta_open here. Thx.

Regards,
Lorenzo

>=20
> > +	return 0;
> > +}
> > +
> > +static int mvneta_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> > +{
> > +	struct mvneta_port *pp =3D netdev_priv(dev);
> > +
> > +	switch (xdp->command) {
> > +	case XDP_SETUP_PROG:
> > +		return mvneta_xdp_setup(dev, xdp->prog, xdp->extack);
> > +	case XDP_QUERY_PROG:
> > +		xdp->prog_id =3D pp->xdp_prog ? pp->xdp_prog->aux->id : 0;
> > +		return 0;
> > +	default:
> > +		NL_SET_ERR_MSG_MOD(xdp->extack, "unknown XDP command");
>=20
> Please drop this message here, there are commands you legitimately
> don't care about, just return -EINVAL, no need to risk leaking a
> meaningless warning to the user space.
>=20
> > +		return -EINVAL;
> > +	}
> > +}

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXabXWQAKCRA6cBh0uS2t
rL9yAQD2/IwvELzAY6vWuW6/L58fIQPxU9Y/HvQznyaTwDmZXQEAyrDeGBETsY/Q
PWbRGuls+1RbH7BBWIFWs5s6Trpf/w4=
=fAQx
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
