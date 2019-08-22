Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C47699E95
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 20:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732911AbfHVSTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 14:19:46 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:48746 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbfHVSTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 14:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Resent-To:
        Resent-Message-ID:Resent-Date:Resent-From:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Sender:
        Resent-Cc:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
        List-Owner:List-Archive; bh=5Z2SosjvkZ1nQ9T8O5LbKIz7Ppc6knjwo45eqJZ9RQQ=; b=e
        dmIcIXMOdJWjhj/E+TjSBWlgE82w6NTI+xFmqsxasLDkNIBHTgul6JpnS8Ei/i/GFrJMXAsbMBqJ2
        /sjXfGDOTZGVt+aDGMiMePaSaihkq5YFZUXcOeELQ+37zOPxZELIFEvIVWu4U5CUvjOsACJxOyq4x
        rQG1gK49UsJPQgfo=;
Received: from 92.40.26.78.threembb.co.uk ([92.40.26.78] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i0rgU-0007cX-6Z; Thu, 22 Aug 2019 18:19:42 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id DA54ED02CB0; Thu, 22 Aug 2019 19:19:39 +0100 (BST)
Date:   Thu, 22 Aug 2019 18:11:37 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-spi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH spi for-5.4 2/5] spi: Add a PTP system timestamp to the
 transfer structure
Message-ID: <20190822171137.GB23391@sirena.co.uk>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <20190818182600.3047-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <20190818182600.3047-3-olteanv@gmail.com>
X-Cookie: Don't SANFORIZE me!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 18, 2019 at 09:25:57PM +0300, Vladimir Oltean wrote:

> @@ -1391,6 +1402,13 @@ static void __spi_pump_messages(struct spi_control=
ler *ctlr, bool in_kthread)
>  		goto out;
>  	}
> =20
> +	if (!ctlr->ptp_sts_supported) {
> +		list_for_each_entry(xfer, &mesg->transfers, transfer_list) {
> +			xfer->ptp_sts_word_pre =3D 0;
> +			ptp_read_system_prets(xfer->ptp_sts);
> +		}
> +	}
> +

We can do better than this for controllers which use transfer_one().

> +const void *spi_xfer_ptp_sts_word(struct spi_transfer *xfer, bool pre)
> +{

xfer can be const here too.

> + * @ptp_sts_supported: If the driver sets this to true, it must provide a
> + *	time snapshot in @spi_transfer->ptp_sts as close as possible to the
> + *	moment in time when @spi_transfer->ptp_sts_word_pre and
> + *	@spi_transfer->ptp_sts_word_post were transmitted.
> + *	If the driver does not set this, the SPI core takes the snapshot as
> + *	close to the driver hand-over as possible.

A couple of issues here.  The big one is that for PIO transfers
this is going to either complicate the code or introduce overhead
in individual drivers for an extremely niche use case.  I guess
most drivers won't implement it which makes this a bit moot but
then this is a concern that pushes back against the idea of
implementing the feature.

The other is that it's not 100% clear what you're looking to
timestamp here - is it when the data goes on the wire, is it when
the data goes on the FIFO (which could be relatively large)?  I'm
guessing you're looking for the physical transfer here, if that's
the case should there be some effort to compensate for the delays
in the controller?

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1ezMgACgkQJNaLcl1U
h9Dtlwf8D458UfQqr72thVWI+Ey8aogmoV90iL49JqGttusBMDAzjT53BuOcQqwH
qnhIsIhw5c9GntD5ecx5US51xCJspCBd2krEL6xkadG2zAUFbjM7IAZogNzSHSe7
4AycBeqzcABbZU1ajW1AEg/KDJ9RVryh15rxsDKPrvCq29lFTTD/GOG9DJOMfR1/
KusCvjkIe7KN8y84i//XaugzufS2H+M66d1w1gka84/ML3tpnpLRKdqmXL2fbrN2
3kH1ntk0zeV/EpHR/LYCZ3dRy8vesTfNRCFbm2iUGQuLCe9Jsv3+vdWBBQ6YQLqv
2erPwB/lwaAUM9kXu/xkbtTOl+GryQ==
=j++/
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
