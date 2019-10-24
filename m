Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCAAE3E8C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbfJXVzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfJXVzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 17:55:04 -0400
Received: from lore-desk.lan (unknown [151.66.11.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EAC020663;
        Thu, 24 Oct 2019 21:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571954102;
        bh=Ct0arrhFcRuyT69o0kp0Cxj1ORQIfTWXcIwmtNzYuKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z/Lr3MJGtB3UIwlHFIrZvAMG0p/ehmMO8AILTBMCChW556GYNY1uK46QmHU3cX7Gj
         CVjbCb+DzikaCNeFrZA5DdSN4oS4OSaTkspa1kDIwYsbgFRgbpG+Xje9eMaCTyQFGC
         rAqOozr9b1dWIcdfyV6cy2u9Cy6TDMQvifK0pxvA=
Date:   Thu, 24 Oct 2019 23:54:51 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org, nbd@nbd.name,
        sgruszka@redhat.com, lorenzo.bianconi@redhat.com,
        oleksandr@natalenko.name, netdev@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH wireless-drivers 1/2] mt76: mt76x2e: disable pcie_aspm by
 default
Message-ID: <20191024215451.GA30822@lore-desk.lan>
References: <cover.1571868221.git.lorenzo@kernel.org>
 <fec60f066bab1936d58b2e69bae3f20e645d1304.1571868221.git.lorenzo@kernel.org>
 <5924c8eb-7269-b8ef-ad0e-957104645638@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <5924c8eb-7269-b8ef-ad0e-957104645638@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 24.10.2019 00:23, Lorenzo Bianconi wrote:
> > On same device (e.g. U7612E-H1) PCIE_ASPM causes continuous mcu hangs a=
nd
> > instability and so let's disable PCIE_ASPM by default. This patch has
> > been successfully tested on U7612E-H1 mini-pice card
> >=20
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mmio.c     | 47 +++++++++++++++++++
> >  drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
> >  .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
> >  3 files changed, 50 insertions(+)
> >=20

[...]

> > +
> > +	if (parent)
> > +		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
> > +					   aspm_conf);
>=20
> + linux-pci mailing list

Hi Heiner,

>=20
> All this seems to be legacy code copied from e1000e.
> Fiddling with the low-level PCI(e) registers should be left to the
> PCI core. It shouldn't be needed here, a simple call to
> pci_disable_link_state() should be sufficient. Note that this function
> has a return value meanwhile that you can check instead of reading
> back low-level registers.

ack, I will add it to v2

> If BIOS forbids that OS changes ASPM settings, then this should be
> respected (like PCI core does). Instead the network chip may provide
> the option to configure whether it activates certain ASPM (sub-)states
> or not. We went through a similar exercise with the r8169 driver,
> you can check how it's done there.

looking at the vendor sdk (at least in the version I currently have) there =
are
no particular ASPM configurations, it just optionally disables it writing d=
irectly
in pci registers.
Moreover there are multiple drivers that are currently using this approach:
- ath9k in ath_pci_aspm_init()
- tg3 in tg3_chip_reset()
- e1000e in __e1000e_disable_aspm()
- r8169 in rtl_enable_clock_request()/rtl_disable_clock_request()

Is disabling the ASPM for the system the only option to make this minipcie
work?

Regards,
Lorenzo

>=20
> > +}
> > +EXPORT_SYMBOL_GPL(mt76_mmio_disable_aspm);
> > +
> >  void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
> >  {
> >  	static const struct mt76_bus_ops mt76_mmio_ops =3D {
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wi=
reless/mediatek/mt76/mt76.h
> > index 570c159515a0..962812b6247d 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> > @@ -578,6 +578,7 @@ bool __mt76_poll_msec(struct mt76_dev *dev, u32 off=
set, u32 mask, u32 val,
> >  #define mt76_poll_msec(dev, ...) __mt76_poll_msec(&((dev)->mt76), __VA=
_ARGS__)
> > =20
> >  void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs);
> > +void mt76_mmio_disable_aspm(struct pci_dev *pdev);
> > =20
> >  static inline u16 mt76_chip(struct mt76_dev *dev)
> >  {
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/=
net/wireless/mediatek/mt76/mt76x2/pci.c
> > index 73c3104f8858..264bef87e5c7 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
> > @@ -81,6 +81,8 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_=
device_id *id)
> >  	/* RG_SSUSB_CDR_BR_PE1D =3D 0x3 */
> >  	mt76_rmw_field(dev, 0x15c58, 0x3 << 6, 0x3);
> > =20
> > +	mt76_mmio_disable_aspm(pdev);
> > +
> >  	return 0;
> > =20
> >  error:
> >=20
>=20

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXbIdqQAKCRA6cBh0uS2t
rCwJAP9TQYbzoTDW107MrwmbRPSxNPttIP2u/vIHoAO7CnI/bgD/VEbeg3ymqpVw
iEM7cfdP6FEholmTwZV+BSUBcm4e5AY=
=7Nvy
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
