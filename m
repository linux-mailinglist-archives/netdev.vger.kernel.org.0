Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF83E2BC8
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 10:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438027AbfJXII5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 04:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfJXII5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 04:08:57 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E33020684;
        Thu, 24 Oct 2019 08:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571904536;
        bh=jZQqNwSUxva3l51zcJ1O93jn/tL3QHziuhKu/M7kJVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jX99tMhIeNmzXlOC5vHdQhDMxI7P+97pll/JeJJrLI6hYbvzLxNpwtLgDUufzC/kf
         KqYmUdKBxk6z0JLX8A46adBny6JpbQ7nc/t10eMunn03uvS4tw1k+WepcjZ26Qey7R
         +F8GG049o5JdJSh1YarPDtISzoNVVwIqYfw9yxfs=
Date:   Thu, 24 Oct 2019 10:08:50 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, oleksandr@natalenko.name,
        netdev@vger.kernel.org
Subject: Re: [PATCH wireless-drivers 1/2] mt76: mt76x2e: disable pcie_aspm by
 default
Message-ID: <20191024080850.GA9346@localhost.localdomain>
References: <cover.1571868221.git.lorenzo@kernel.org>
 <fec60f066bab1936d58b2e69bae3f20e645d1304.1571868221.git.lorenzo@kernel.org>
 <87eez2u44r.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <87eez2u44r.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20
> > On same device (e.g. U7612E-H1) PCIE_ASPM causes continuous mcu hangs a=
nd
> > instability and so let's disable PCIE_ASPM by default. This patch has
> > been successfully tested on U7612E-H1 mini-pice card
> >
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> [...]
>=20
> > +void mt76_mmio_disable_aspm(struct pci_dev *pdev)
> > +{
> > +	struct pci_dev *parent =3D pdev->bus->self;
> > +	u16 aspm_conf, parent_aspm_conf =3D 0;
> > +
> > +	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &aspm_conf);
> > +	aspm_conf &=3D PCI_EXP_LNKCTL_ASPMC;
> > +	if (parent) {
> > +		pcie_capability_read_word(parent, PCI_EXP_LNKCTL,
> > +					  &parent_aspm_conf);
> > +		parent_aspm_conf &=3D PCI_EXP_LNKCTL_ASPMC;
> > +	}
> > +
> > +	if (!aspm_conf && (!parent || !parent_aspm_conf)) {
> > +		/* aspm already disabled */
> > +		return;
> > +	}
> > +
> > +	dev_info(&pdev->dev, "disabling ASPM %s %s\n",
> > +		 (aspm_conf & PCI_EXP_LNKCTL_ASPM_L0S) ? "L0s" : "",
> > +		 (aspm_conf & PCI_EXP_LNKCTL_ASPM_L1) ? "L1" : "");
> > +
> > +#ifdef CONFIG_PCIEASPM
> > +	pci_disable_link_state(pdev, aspm_conf);
> > +
> > +	/* Double-check ASPM control.  If not disabled by the above, the
> > +	 * BIOS is preventing that from happening (or CONFIG_PCIEASPM is
> > +	 * not enabled); override by writing PCI config space directly.
> > +	 */
> > +	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &aspm_conf);
> > +	if (!(aspm_conf & PCI_EXP_LNKCTL_ASPMC))
> > +		return;
> > +#endif /* CONFIG_PCIEASPM */
>=20
> A minor comment, but 'if IS_ENABLED(CONFIG_PCIEASPM)' is preferred over
> #ifdef. Better compiler coverage and so on.

Hi Kalle,

ack, I will fix it in v2.

Regards,
Lorenzo

>=20
> --=20
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXbFcEAAKCRA6cBh0uS2t
rGOtAQCGhErEs2zXuOOCpsKHdrNhCmZVXNfmNFRLzx3pvw7gAAD/Q+FCJo/TtLTT
5bx4h3MOKy8tD22nno2praFY8IJ8LwE=
=QH3z
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
