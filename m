Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3627EDA902
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 11:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405826AbfJQJqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 05:46:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732002AbfJQJqQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 05:46:16 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B2E520650;
        Thu, 17 Oct 2019 09:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571305575;
        bh=PZEYDLyau8wuGvBF0ZnfxqTWSklpMPP7W534r/y0++A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VRvwau6oQmL7eyjSEJSRV42qJ4ivbi8lXp+euSkSnKGLur5HVoqFsMaxnves7j71U
         buo9O7GHtlJSHAImt9yuUTxebQxza1Zt4sglXD/9naxtYOS2ufMrx/RnYJSOO6QgHv
         /oletUbT4pBXmHdsXS723VbYAe2PtabgY7QH/ibM=
Date:   Thu, 17 Oct 2019 11:46:09 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v4 net-next 4/7] net: mvneta: add basic XDP support
Message-ID: <20191017094609.GC2861@localhost.localdomain>
References: <cover.1571258792.git.lorenzo@kernel.org>
 <30b6fad4fe5411e092171bb825f7a6ce0041d63e.1571258793.git.lorenzo@kernel.org>
 <20191016182650.2989ddf4@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
In-Reply-To: <20191016182650.2989ddf4@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 16 Oct 2019 23:03:09 +0200, Lorenzo Bianconi wrote:
> > Add basic XDP support to mvneta driver for devices that rely on software
> > buffer management. Currently supported verdicts are:
> > - XDP_DROP
> > - XDP_PASS
> > - XDP_REDIRECT
> > - XDP_ABORTED
> >=20
> > - iptables drop:
> > $iptables -t raw -I PREROUTING -p udp --dport 9 -j DROP
> > $nstat -n && sleep 1 && nstat
> > IpInReceives		151169		0.0
> > IpExtInOctets		6953544		0.0
> > IpExtInNoECTPkts	151165		0.0
> >=20
> > - XDP_DROP via xdp1
> > $./samples/bpf/xdp1 3
> > proto 0:	421419 pkt/s
> > proto 0:	421444 pkt/s
> > proto 0:	421393 pkt/s
> > proto 0:	421440 pkt/s
> > proto 0:	421184 pkt/s
> >=20
> > Tested-by: Matteo Croce <mcroce@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
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
>=20
> Actually if pp->prog && prog you don't have to stop/start, right?
> You just gotta restart if !!pp->prog !=3D !!prog?

uhm..right :). I will fix in in v5.

Regards,
Lorenzo

>=20
> > +	old_prog =3D xchg(&pp->xdp_prog, prog);
> > +	if (old_prog)
> > +		bpf_prog_put(old_prog);
> > +
> > +	if (netif_running(dev))
> > +		return mvneta_open(dev);
> > +
> > +	return 0;
> > +}

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXag4XgAKCRA6cBh0uS2t
rFfEAQCmHEpSS7U1TiQaL8XcHP/U9iiec3SZDXSOMUhV6Ob2QQEAtCR8k5yuIE8p
F1291qW3Ca6CDker1ZDM582XBweKKAM=
=WwcZ
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
