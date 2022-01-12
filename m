Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E6548C964
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355652AbiALRaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:30:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33086 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355691AbiALR3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:29:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D7096185C;
        Wed, 12 Jan 2022 17:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF96C36AEA;
        Wed, 12 Jan 2022 17:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642008547;
        bh=WmoSnDqhinKjkewcpUgnfaaSxspJGZbTKcK3e1khB2s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A+XZRwxhONR1uKqXI/kXd3jARiYRIchjvhJYEHkEPmNndBoLznSDZ9a1oxAOt23hO
         eiNe/F6cWhbWlL8bCV6AuVTd7ssunTf5FK0/DebMc1yb2QW+dML3RPhvN5OmQfl+56
         ngo2YOH44yavegkW0q9DOVbydiDSV6PVP1vXziYBUaIwFEAqz8wdg2KMmK01bRxP8X
         NNTsjuBIXPKIDWZ/YXsJwaGu1F9EwW8UaargoqI9CVzodeU01wkj9a0WPRf+SGBiLF
         PtqDuKin/DWEKaygGcyCbFigLP82jb3kPoA3Wm+PnbC0sq46i142Fp5MsKbMWLWMiE
         PX5FG7+iqYH2g==
Date:   Wed, 12 Jan 2022 18:29:00 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree 2/2] dt-bindings: phy: Add
 `tx-amplitude-microvolt` property binding
Message-ID: <20220112182900.7054c4d9@thinkpad>
In-Reply-To: <YbplENKCcjCUdwke@robh.at.kernel.org>
References: <20211214233432.22580-1-kabel@kernel.org>
        <20211214233432.22580-3-kabel@kernel.org>
        <YbplENKCcjCUdwke@robh.at.kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob,

On Wed, 15 Dec 2021 15:58:40 -0600
Rob Herring <robh@kernel.org> wrote:

> On Wed, Dec 15, 2021 at 12:34:32AM +0100, Marek Beh=C3=BAn wrote:
> > Common PHYs often have the possibility to specify peak-to-peak voltage
> > on the differential pair - the default voltage sometimes needs to be
> > changed for a particular board. =20
>=20
> I can envision needing this, but I can't say that I've seen custom=20
> properties being proposed for this purpose.
>=20
> >=20
> > Add properties `tx-amplitude-microvolt` and
> > `tx-amplitude-microvolt-names` for this purpose. The second property is
> > needed to specify =20
>=20
> Is the amplitude peak to peak? You just said it was, but perhaps make=20
> the property name more clearly defined: tx-p2p-microvolt

Yes, it is peak to peak.

> >=20
> > Example usage with only one voltage (it will be used for all supported
> > PHY modes, the `tx-amplitude-microvolt-names` property is not needed in
> > this case):
> >=20
> >   tx-amplitude-microvolt =3D <915000>;
> >=20
> > Example usage with voltages for multiple modes:
> >=20
> >   tx-amplitude-microvolt =3D <915000>, <1100000>, <1200000>;
> >   tx-amplitude-microvolt-names =3D "2500base-x", "usb", "pcie"; =20
>=20
> I'm not wild about the -names, but I think outside of ethernet most=20
> cases will only be 1 entry.
>=20
> For a phy provider with multiple phys, what if each one needs a=20
> different voltage (for the same mode)?

For such a provider I think the best way would be to have the different
PHYs each have a subnode:
  phy-provider {
    phy@0 {
      tx-p2p-microvolt =3D ...;
    };
  }
>=20
> >=20
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > ---
> >=20
> > I wanted to constrain the values allowed in the
> > `tx-amplitude-microvolt-names` property to:
> > - ethernet SerDes modes (sgmii, qsgmii, 10gbase-r, 2500base-x, ...)
> > - PCIe modes (pattern: ^pcie[1-6]?$)
> > - USB modes (pattern: ^usb((-host|-device|-otg)?-(ls|fs|hs|ss|ss\+|4))?=
$)
> > - DisplayPort modes (pattern: ^dp(-rbr|-hbr[23]?|-uhbr-(10|13.5|20))?$)
> > - Camera modes (mipi-dphy, mipi-dphy-univ, mipi-dphy-v2.5-univ)
> > - Storage modes (sata, ufs-hs, ufs-hs-a, ufs-hs-b)
> >=20
> > But was unable to. The '-names' suffix implies string-array type, and
> > string-array type does not allow to specify a type for all items in a
> > simple way, i.e.:
> >   items:
> >     enum:
> >       - sgmii
> >       - sata
> >       - usb
> >       ... =20
>=20
> Works here: Documentation/devicetree/bindings/arm/samsung/pmu.yaml:56
>=20
> The requirement is you need to constrain the size with maxItems. It can=20
> be a 'should be enough for anyone' value.

Thx.

Marek
